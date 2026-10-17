#!/usr/bin/env python3
"""Check content, Xcode membership and resources without claiming an iOS build.

Python 3.10+. Optional: tree-sitter + tree-sitter-swift for syntax parsing,
Pillow for image decoding. No network calls or source mutations.
"""
from __future__ import annotations

import argparse
import collections
import datetime as dt
import hashlib
import json
import plistlib
import re
import struct
import sys
import xml.etree.ElementTree as ET
from pathlib import Path
from urllib.parse import urlparse

ROOT = Path(__file__).resolve().parents[1]
ERRORS: list[str] = []
WARNINGS: list[str] = []
CHECKS = 0


def check(condition: bool, message: str) -> None:
    global CHECKS
    CHECKS += 1
    if not condition:
        ERRORS.append(message)


def https(value: str) -> bool:
    try:
        url = urlparse(value)
        return url.scheme == "https" and bool(url.hostname)
    except (ValueError, TypeError):
        return False


def date(value: dict, label: str) -> None:
    check(isinstance(value.get("year"), int) and 1900 <= value["year"] <= 2100, f"{label}: invalid year")
    check("day" not in value or "month" in value, f"{label}: day requires month")
    try:
        dt.date(value["year"], value.get("month", 1), value.get("day", 1))
    except (ValueError, KeyError, TypeError):
        check(False, f"{label}: invalid calendar date")


def content() -> None:
    catalog = json.loads((ROOT / "Content/gem-catalog.json").read_text(encoding="utf-8-sig"))
    check(catalog.get("schemaVersion") == 1, "Unsupported catalog schema")
    dt.date.fromisoformat(catalog["updatedAt"])
    entries, sources = catalog["entries"], catalog["sources"]
    ids = {item["id"] for item in entries}
    source_ids = {item["id"] for item in sources}
    check(len(ids) == len(entries), "Duplicate entry IDs")
    check(len(source_ids) == len(sources), "Duplicate source IDs")
    by_id = {item["id"]: item for item in entries}
    valid_kinds = {"event", "release", "track", "program", "stage"}
    for source in sources:
        label = source["id"]
        for key in ["id", "title", "publisher", "url", "verifiedAt", "scope"]:
            check(isinstance(source.get(key), str) and bool(source[key].strip()), f"{label}: missing source {key}")
        check(https(source["url"]), f"{label}: source URL must be HTTPS")
        dt.date.fromisoformat(source["verifiedAt"])
    for item in entries:
        label = item["id"]
        check(bool(re.fullmatch(r"[a-z0-9][a-z0-9-]*", label)), f"{label}: unstable or invalid ID")
        check(item["kind"] in valid_kinds, f"{label}: unknown kind")
        for key in ["title", "subtitle", "category", "summary", "editorial"]:
            check(isinstance(item.get(key), str), f"{label}: {key} must be text")
        for key in ["title", "summary", "category"]:
            check(bool(item.get(key, "").strip()), f"{label}: empty {key}")
        check(bool(item.get("paragraphs")) and all(isinstance(p, str) and p.strip() for p in item["paragraphs"]), f"{label}: missing article paragraphs")
        check(isinstance(item.get("tags"), list), f"{label}: tags must be an array")
        date(item["date"], label)
        check(bool(item.get("sourceIDs")), f"{label}: no factual source")
        check(set(item.get("sourceIDs", [])) <= source_ids, f"{label}: unresolved source")
        check(set(item.get("relatedIDs", [])) <= ids, f"{label}: unresolved related entry")
        check(label not in item.get("relatedIDs", []), f"{label}: self-related entry")
        image = item.get("imageAsset")
        if image:
            check((ROOT / "Assets.xcassets" / (image + ".imageset/Contents.json")).is_file(), f"{label}: missing image {image}")
        if item.get("artworkURL"):
            check(https(item["artworkURL"]), f"{label}: artwork must use HTTPS")
        links = list(item.get("links", []))
        numbers = [track["number"] for track in item.get("tracks", [])]
        check(len(set(numbers)) == len(numbers) and numbers == sorted(numbers), f"{label}: duplicate/unordered track numbers")
        for track in item.get("tracks", []):
            check(isinstance(track["number"], int) and track["number"] > 0, f"{label}: invalid track number")
            if track.get("entryID"):
                check(by_id.get(track["entryID"], {}).get("kind") == "track", f"{label}: track entryID is not a track")
        versions = item.get("versions", [])
        check(len({v["id"] for v in versions}) == len(versions), f"{label}: duplicate version IDs")
        for version in versions:
            date(version["date"], f"{label}/{version['id']}")
            check(bool(version.get("sourceIDs")), f"{label}: version missing source")
            check(set(version.get("sourceIDs", [])) <= source_ids, f"{label}: unresolved version source")
            if version.get("releaseID"):
                check(by_id.get(version["releaseID"], {}).get("kind") == "release", f"{label}: releaseID is not a release")
            links.extend(version.get("links", []))
        for link in links:
            check(bool(link.get("label")) and https(link.get("url")), f"{label}: invalid external link")
    counts = collections.Counter(item["kind"] for item in entries)
    check(valid_kinds <= set(counts), "Catalog needs event/release/track/program/stage entries")
    event_years = collections.Counter(item["date"]["year"] for item in entries if item["kind"] == "event")
    check(any(n > 1 for n in event_years.values()), "No same-year events to exercise independent IDs")
    artwork_map_path = ROOT / "Content/artwork-map.json"
    if artwork_map_path.exists():
        artwork_map = json.loads(artwork_map_path.read_text(encoding="utf-8-sig"))
        release_ids = {item["id"] for item in entries if item["kind"] == "release"}
        check(set(artwork_map) == release_ids, "Artwork map does not cover exactly the catalog releases")
        for identifier, image in artwork_map.items():
            check(https(image["url"]) and https(image["sourceURL"]), f"{identifier}: invalid artwork provenance")
    print("Content:", ", ".join(f"{kind}={counts[kind]}" for kind in sorted(counts)), f"sources={len(sources)}")


def parse_openstep(text: str) -> dict:
    pattern = r'/\*[\s\S]*?\*/|//[^\n]*|"(?:\\.|[^"\\])*"|[{}()=;,]|[^\s{}()=;,]+'
    tokens = [m.group() for m in re.finditer(pattern, text) if not m.group().startswith(("//", "/*"))]
    index = 0

    def take() -> str:
        nonlocal index
        value = tokens[index]
        index += 1
        return value

    def expect(expected: str) -> None:
        found = take()
        if found != expected:
            raise ValueError(f"OpenStep expected {expected}, found {found}")

    def value():
        token = take()
        if token == "{":
            result = {}
            while tokens[index] != "}":
                key = value()
                expect("=")
                result[key] = value()
                expect(";")
            expect("}")
            return result
        if token == "(":
            result = []
            while tokens[index] != ")":
                result.append(value())
                if tokens[index] == ",":
                    take()
            expect(")")
            return result
        if token.startswith('"'):
            return json.loads(token)
        return token

    result = value()
    if index != len(tokens):
        raise ValueError("Unexpected trailing project tokens")
    return result


def project() -> None:
    project_dir = ROOT / "GEM_BeyondTheVoice.xcodeproj"
    data = parse_openstep((project_dir / "project.pbxproj").read_text(encoding="utf-8"))
    objects = data["objects"]
    root = objects[data["rootObject"]]
    check(data["objectVersion"] == "60", "Unexpected project object format")
    targets = [objects[identifier] for identifier in root["targets"]]
    check({target["productType"] for target in targets} == {"com.apple.product-type.application", "com.apple.product-type.bundle.unit-test"}, "Missing App/XCTest targets")
    resolved: dict[str, Path] = {}

    def visit(identifier: str, parent: Path) -> None:
        obj = objects[identifier]
        current = parent / obj.get("path", "")
        if obj["isa"] == "PBXGroup":
            for child in obj.get("children", []):
                visit(child, current)
        elif obj["isa"] == "PBXFileReference" and obj.get("sourceTree") != "BUILT_PRODUCTS_DIR":
            resolved[identifier] = current
            check(current.exists(), f"Project references missing file {current.relative_to(ROOT)}")

    visit(root["mainGroup"], ROOT)
    for identifier, obj in objects.items():
        if obj["isa"] == "PBXBuildFile":
            check(obj["fileRef"] in objects, f"Unresolved build file {identifier}")
    all_app = set(ROOT.glob("SwiftUI/*.swift"))
    all_test = set(ROOT.glob("GEM_BeyondTheVoiceTests/*.swift"))
    expected_resources = set(ROOT.glob("Content/*.json")) | set(ROOT.glob("font/*.ttf")) | set(ROOT.glob("font/*-OFL.txt"))
    expected_resources |= {ROOT / "Assets.xcassets", ROOT / "Config/PrivacyInfo.xcprivacy"}
    for target in targets:
        phases = [objects[phase] for phase in target["buildPhases"]]
        membership = {}
        for phase in phases:
            paths = [resolved[objects[build_id]["fileRef"]] for build_id in phase["files"]]
            check(len(paths) == len(set(paths)), f"Duplicate membership in {target['name']} {phase['isa']}")
            membership[phase["isa"]] = set(paths)
        is_app = target["productType"] == "com.apple.product-type.application"
        check(membership["PBXSourcesBuildPhase"] == (all_app if is_app else all_test), f"Incomplete Swift source membership for {target['name']}; run scripts/update_xcode_project.py")
        if is_app:
            check(membership["PBXResourcesBuildPhase"] == expected_resources, "Incomplete App Resources membership")
        else:
            check(bool(target["dependencies"]), "XCTest must depend on the App target")
        configs = objects[target["buildConfigurationList"]]["buildConfigurations"]
        for config in configs:
            settings = objects[config]["buildSettings"]
            check(settings["IPHONEOS_DEPLOYMENT_TARGET"] == "27.0", "Deployment target must be iOS 27")
            check(settings["SWIFT_VERSION"] == "5.0", "Swift version changed")
            if is_app:
                check(settings["PRODUCT_BUNDLE_IDENTIFIER"] == "com.example.GEMBeyondTheVoice", "App bundle identity changed")
            else:
                check(bool(settings.get("TEST_HOST")) and bool(settings.get("BUNDLE_LOADER")), "XCTest host not configured")
    scheme = ET.parse(project_dir / "xcshareddata/xcschemes/GEM_BeyondTheVoice.xcscheme").getroot()
    tests = scheme.findall("./TestAction/Testables/TestableReference")
    check(len(tests) == 1 and tests[0].get("skipped") == "NO", "Shared scheme does not enable XCTest")
    for ref in scheme.findall(".//BuildableReference"):
        check(ref.get("BlueprintIdentifier") in root["targets"], "Scheme refers to missing target")
    print(f"Project: {len(all_app)} App Swift files, {len(all_test)} XCTest files, {len(expected_resources)} resources, shared scheme.")


def font_names(path: Path) -> set[str]:
    raw = path.read_bytes()
    tables = struct.unpack_from(">H", raw, 4)[0]
    table_offset = None
    for i in range(tables):
        tag, _, offset, _ = struct.unpack_from(">4sIII", raw, 12 + 16 * i)
        if tag == b"name":
            table_offset = offset
            break
    if table_offset is None:
        raise ValueError(f"{path.name}: missing name table")
    _, count, storage = struct.unpack_from(">HHH", raw, table_offset)
    result = set()
    for i in range(count):
        platform, _, _, name_id, length, offset = struct.unpack_from(">HHHHHH", raw, table_offset + 6 + i * 12)
        if name_id == 6:
            start = table_offset + storage + offset
            result.add(raw[start:start + length].decode("utf-16-be" if platform in (0, 3) else "mac_roman"))
    return result


def resources() -> None:
    info = plistlib.loads((ROOT / "Config/Info.plist").read_bytes())
    all_names = set()
    for font in info["UIAppFonts"]:
        path = ROOT / "font" / font
        check(path.is_file(), f"Info.plist font missing: {font}")
        names = font_names(path)
        all_names |= names
        check(path.stem in names, f"Font PostScript name mismatch: {font}: {names}")
    check(set(info["UIAppFonts"]) == {p.name for p in ROOT.glob("font/*.ttf")}, "UIAppFonts not aligned with bundled TTFs")
    theme = (ROOT / "SwiftUI/GEMTheme.swift").read_text(encoding="utf-8")
    for name in all_names:
        check('"' + name + '"' in theme, f"Theme does not reference registered font {name}")
    for license_file in ROOT.glob("font/*-OFL.txt"):
        check("SIL OPEN FONT LICENSE" in license_file.read_text(encoding="utf-8-sig"), f"Invalid font license {license_file.name}")
    privacy = plistlib.loads((ROOT / "Config/PrivacyInfo.xcprivacy").read_bytes())
    declared = privacy["NSPrivacyAccessedAPITypes"]
    check(any(item["NSPrivacyAccessedAPIType"] == "NSPrivacyAccessedAPICategoryUserDefaults" and "CA92.1" in item["NSPrivacyAccessedAPITypeReasons"] for item in declared), "Missing UserDefaults reason CA92.1")
    check(privacy["NSPrivacyTracking"] is False, "Unexpected tracking declaration")
    credits = json.loads((ROOT / "Content/media-credits.json").read_text(encoding="utf-8-sig"))
    check(len({item["id"] for item in credits}) == len(credits), "Duplicate media credit ID")
    check({item["assetName"] for item in credits} == {"gem_portrait", "gem_live"}, "Missing photo credits")
    for credit in credits:
        for key in ["id", "assetName", "title", "author", "license", "modifications"]:
            check(bool(credit.get(key)), f"Photo credit missing {key}")
        check(https(credit["sourceURL"]), f"Invalid photo source URL: {credit.get('id')}")
        if credit.get("licenseURL"):
            check(https(credit["licenseURL"]), f"Invalid photo license URL: {credit.get('id')}")
    originals = {
        "gem_portrait/影像.jpeg": "b960c0cc8c678d6701bc65e136a19f513a0fcc68",
        "gem_live/Gem_Tang_Singing_with_Piano_2.jpg": "cbcd0b697aa7348a315b6fce6b3b2eb850a29f04",
    }
    for asset_path, expected_sha1 in originals.items():
        asset_name, file_name = asset_path.split("/", 1)
        image_path = ROOT / "Assets.xcassets" / (asset_name + ".imageset") / file_name
        check(hashlib.sha1(image_path.read_bytes()).hexdigest() == expected_sha1,
              f"Photo asset file integrity mismatch: {asset_name}")
    try:
        from PIL import Image
    except ImportError:
        Image = None
        WARNINGS.append("Pillow unavailable: image metadata checked, binary decoding skipped.")
    count = 0
    for asset in ROOT.glob("Assets.xcassets/**/*.imageset/Contents.json"):
        definition = json.loads(asset.read_text(encoding="utf-8-sig"))
        for image in definition["images"]:
            if not image.get("filename"):
                continue
            image_path = asset.parent / image["filename"]
            check(image_path.is_file(), f"Missing asset pixels {image_path}")
            if Image:
                with Image.open(image_path) as loaded:
                    loaded.verify()
            count += 1
    print(f"Resources: {len(all_names)} font PostScript names, {count} asset images, 2 attributed photos, valid privacy plist.")


def swift_syntax(extra_path: str | None) -> None:
    if extra_path:
        sys.path.insert(0, str(Path(extra_path).resolve()))
    else:
        local_deps = ROOT.parents[1] / ".validation-deps"
        if local_deps.exists():
            sys.path.insert(0, str(local_deps))
    try:
        import tree_sitter
        import tree_sitter_swift
    except ImportError:
        WARNINGS.append("Tree-sitter Swift unavailable: syntax parsing skipped. Install tree-sitter/tree-sitter-swift or pass --syntax-deps.")
        return
    parser = tree_sitter.Parser(tree_sitter.Language(tree_sitter_swift.language()))
    files = sorted(ROOT.glob("SwiftUI/*.swift")) + sorted(ROOT.glob("GEM_BeyondTheVoiceTests/*.swift"))
    for file in files:
        raw = file.read_bytes()
        tree = parser.parse(raw)
        if tree.root_node.has_error:
            nodes = [tree.root_node]
            while nodes:
                node = nodes.pop()
                if node.type == "ERROR" or node.is_missing:
                    snippet = raw[node.start_byte:node.end_byte].decode("utf-8", errors="replace")[:100]
                    check(False, f"Swift parse {file.name}:{node.start_point.row + 1}: {snippet!r}")
                nodes.extend(reversed(node.children))
        else:
            check(True, file.name)
    print(f"Swift syntax: Tree-sitter parsed {len(files)} files. This does not type-check Apple frameworks.")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--syntax-deps", help="Directory containing optional tree_sitter modules")
    args = parser.parse_args()
    for function in [content, project, resources, lambda: swift_syntax(args.syntax_deps)]:
        try:
            function()
        except Exception as exc:
            check(False, f"{getattr(function, '__name__', 'syntax')}: {type(exc).__name__}: {exc}")
    for warning in WARNINGS:
        print("SKIP:", warning)
    for error in ERRORS:
        print("FAIL:", error)
    print(f"Static validation: {CHECKS} checks, {len(ERRORS)} failures, {len(WARNINGS)} optional skips.")
    print("NOT RUN: Xcode build, XCTest execution, Simulator/device, VoiceOver, layout and font registration.")
    return 1 if ERRORS else 0


if __name__ == "__main__":
    raise SystemExit(main())
