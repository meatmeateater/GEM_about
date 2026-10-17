#!/usr/bin/env python3
"""Xcode project membership inspector and safe synchronizer.

Default mode is non-destructive inspection (--dry-run or no flags).
Validates on-disk project.pbxproj without altering disk files:
- Inspects and verifies critical protected settings directly from on-disk project:
  * DEVELOPMENT_TEAM
  * PRODUCT_BUNDLE_IDENTIFIER
  * ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon
  * TARGETED_DEVICE_FAMILY = 1 (iPhone)
  * INFOPLIST_FILE = Config/Info.plist
  * CFBundleDisplayName = G.E.M. About (in Info.plist)
  * IPHONEOS_DEPLOYMENT_TARGET = 27.0
  * SWIFT_VERSION = 5.0
- Verifies all Swift source files and resource files are accounted for.
- Full regeneration is classified as a destructive high-risk operation requiring
  both --force and --confirm flags, and automatically creates a backup of project.pbxproj.
"""
from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import re
import shutil
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROJECT_DIR = ROOT / "GEM_BeyondTheVoice.xcodeproj"
PBXPROJ_PATH = PROJECT_DIR / "project.pbxproj"
SCHEME_PATH = PROJECT_DIR / "xcshareddata/xcschemes/GEM_BeyondTheVoice.xcscheme"
INFO_PLIST_PATH = ROOT / "Config/Info.plist"

PROJECT_ID = "1781F676DEDF5767F3243DB0"
APP_ID = "730950AD798A77AD508AA9E2"
APP_PRODUCT_ID = "6EDEBCE3A94A8852C819FDBE"
APP_NAME = "GEM_BeyondTheVoice"
TEST_NAME = APP_NAME + "Tests"


def uid(value: str) -> str:
    return hashlib.sha1(("gem-about-v2:" + value).encode()).hexdigest()[:24].upper()


def quoted(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def parse_openstep(text: str) -> dict:
    """Parse Xcode OpenStep format into Python data structures."""
    pattern = r'/\*[\s\S]*?\*/|//[^\n]*|"(?:\\.|[^"\\])*"|[{}()=;,]|[^<>\s{}()=;,]+'
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
    return result


def extract_app_build_settings(objects: dict, root: dict) -> dict[str, str]:
    """Extract App target build settings from parsed OpenStep objects."""
    extracted: dict[str, str] = {}
    for target_id in root.get("targets", []):
        target = objects.get(target_id, {})
        if target.get("productType") == "com.apple.product-type.application":
            config_list_id = target.get("buildConfigurationList")
            config_list = objects.get(config_list_id, {})
            for config_id in config_list.get("buildConfigurations", []):
                config = objects.get(config_id, {})
                settings = config.get("buildSettings", {})
                for key, val in settings.items():
                    if key not in extracted and isinstance(val, str):
                        extracted[key] = val
    return extracted


def inspect_project() -> tuple[bool, list[str], dict[str, str]]:
    """Inspect and validate on-disk Xcode project without modifying disk."""
    if not PBXPROJ_PATH.exists():
        return False, [f"Missing project file: {PBXPROJ_PATH}"], {}

    pbx_text = PBXPROJ_PATH.read_text(encoding="utf-8")
    try:
        data = parse_openstep(pbx_text)
    except Exception as err:
        return False, [f"Failed to parse project.pbxproj: {err}"], {}

    objects = data.get("objects", {})
    root_id = data.get("rootObject", "")
    root = objects.get(root_id, {})
    settings = extract_app_build_settings(objects, root)
    issues: list[str] = []

    # 1. Protected build settings verification
    checks = [
        ("ASSETCATALOG_COMPILER_APPICON_NAME", "AppIcon", settings.get("ASSETCATALOG_COMPILER_APPICON_NAME")),
        ("TARGETED_DEVICE_FAMILY", "1", str(settings.get("TARGETED_DEVICE_FAMILY"))),
        ("INFOPLIST_FILE", "Config/Info.plist", settings.get("INFOPLIST_FILE")),
        ("IPHONEOS_DEPLOYMENT_TARGET", "27.0", settings.get("IPHONEOS_DEPLOYMENT_TARGET")),
        ("SWIFT_VERSION", "5.0", settings.get("SWIFT_VERSION")),
        ("PRODUCT_BUNDLE_IDENTIFIER", "com.example.GEMBeyondTheVoice", settings.get("PRODUCT_BUNDLE_IDENTIFIER")),
    ]
    for key, expected, actual in checks:
        if actual != expected:
            issues.append(f"Setting mismatch for {key}: expected '{expected}', found '{actual}'")

    dev_team = settings.get("DEVELOPMENT_TEAM", "")
    if not dev_team:
        issues.append("DEVELOPMENT_TEAM is empty or unconfigured")

    # 2. CFBundleDisplayName in Info.plist
    if INFO_PLIST_PATH.exists():
        info_text = INFO_PLIST_PATH.read_text(encoding="utf-8")
        if "<key>CFBundleDisplayName</key>" not in info_text or "<string>G.E.M. About</string>" not in info_text:
            issues.append("CFBundleDisplayName in Info.plist is not 'G.E.M. About'")
    else:
        issues.append("Config/Info.plist is missing")

    # 3. File membership check
    swift_files = sorted(ROOT.glob("SwiftUI/*.swift"))
    test_files = sorted(ROOT.glob("GEM_BeyondTheVoiceTests/*.swift"))
    resource_files = (
        sorted(ROOT.glob("Content/*.json"))
        + sorted(ROOT.glob("font/*.ttf"))
        + sorted(ROOT.glob("font/*-OFL.txt"))
        + [ROOT / "Config/PrivacyInfo.xcprivacy"]
    )

    for sf in swift_files:
        if sf.name not in pbx_text:
            issues.append(f"Swift source not referenced in project: {sf.name}")
    for tf in test_files:
        if tf.name not in pbx_text:
            issues.append(f"Test source not referenced in project: {tf.name}")
    for rf in resource_files:
        if rf.name not in pbx_text:
            issues.append(f"Resource file not referenced in project: {rf.name}")
    if "Assets.xcassets" not in pbx_text:
        issues.append("Assets.xcassets not referenced in project")

    # 4. Shared Scheme check
    if SCHEME_PATH.exists():
        try:
            tree = ET.parse(SCHEME_PATH)
            root_elem = tree.getroot()
            test_refs = root_elem.findall("./TestAction/Testables/TestableReference")
            if not test_refs or any(ref.get("skipped") == "YES" for ref in test_refs):
                issues.append("Shared Scheme does not enable XCTest")
        except Exception as err:
            issues.append(f"Cannot parse shared scheme: {err}")
    else:
        issues.append(f"Shared scheme missing: {SCHEME_PATH}")

    return len(issues) == 0, issues, settings


def build_project_content(settings: dict[str, str]) -> tuple[str, str]:
    """Generate in-memory representation of project.pbxproj and .xcscheme using extracted settings."""
    team = settings.get("DEVELOPMENT_TEAM", "398C8C2Q8L")
    bundle_id = settings.get("PRODUCT_BUNDLE_IDENTIFIER", "com.example.GEMBeyondTheVoice")
    device_family = settings.get("TARGETED_DEVICE_FAMILY", "1")
    app_icon = settings.get("ASSETCATALOG_COMPILER_APPICON_NAME", "AppIcon")
    deploy_target = settings.get("IPHONEOS_DEPLOYMENT_TARGET", "27.0")
    swift_ver = settings.get("SWIFT_VERSION", "5.0")
    info_plist = settings.get("INFOPLIST_FILE", "Config/Info.plist")

    objects: list[str] = []

    def obj(identifier: str, label: str, properties: list[str]) -> None:
        body = "\n".join("\t\t\t" + line for line in properties)
        objects.append(f"\t\t{identifier} /* {label} */ = {{\n{body}\n\t\t}};")

    def array(key: str, entries: list[str]) -> str:
        return key + " = (" + ", ".join(entries) + (", " if entries else "") + ");"

    def fileref(relative: Path, kind: str, source_tree: str = "<group>") -> str:
        path = relative.as_posix()
        identifier = uid("file:" + path)
        obj(identifier, relative.name, [
            "isa = PBXFileReference;", f"lastKnownFileType = {kind};",
            f"path = {quoted(relative.name)};", f"sourceTree = {quoted(source_tree)};",
        ])
        return identifier

    def buildfile(file_id: str, label: str, target: str) -> str:
        identifier = uid("build:" + target + ":" + file_id)
        obj(identifier, label, ["isa = PBXBuildFile;", f"fileRef = {file_id};"])
        return identifier

    swift_files = sorted(ROOT.glob("SwiftUI/*.swift"))
    test_files = sorted(ROOT.glob("GEM_BeyondTheVoiceTests/*.swift"))
    content_files = sorted(ROOT.glob("Content/*.json"))
    font_files = sorted(ROOT.glob("font/*.ttf")) + sorted(ROOT.glob("font/*-OFL.txt"))
    resources: list[str] = []
    groups: list[str] = []
    swift_build: list[str] = []
    test_build: list[str] = []
    for directory, files, kind in [
        ("SwiftUI", swift_files, "sourcecode.swift"),
        ("GEM_BeyondTheVoiceTests", test_files, "sourcecode.swift"),
        ("Content", content_files, "text.json"),
        ("font", font_files, None),
        ("Config", [ROOT / "Config/Info.plist", ROOT / "Config/PrivacyInfo.xcprivacy"], None),
    ]:
        members: list[str] = []
        for file in files:
            relative = file.relative_to(ROOT)
            file_kind = kind or ({".ttf": "file", ".txt": "text", ".plist": "text.plist.xml",
                                  ".xcprivacy": "text.xml"}[file.suffix])
            file_id = fileref(relative, file_kind)
            members.append(file_id)
            if directory == "SwiftUI":
                swift_build.append(buildfile(file_id, file.name + " in Sources", "app"))
            elif directory == "GEM_BeyondTheVoiceTests":
                test_build.append(buildfile(file_id, file.name + " in Sources", "test"))
            elif file.name != "Info.plist":
                resources.append(buildfile(file_id, file.name + " in Resources", "app"))
        group_id = uid("group:" + directory)
        groups.append(group_id)
        obj(group_id, directory, ["isa = PBXGroup;", array("children", members),
                                 f"path = {quoted(directory)};", 'sourceTree = "<group>";'])

    assets_id = fileref(Path("Assets.xcassets"), "folder.assetcatalog")
    resources.append(buildfile(assets_id, "Assets.xcassets in Resources", "app"))
    for identifier, product, kind in [
        (APP_PRODUCT_ID, APP_NAME + ".app", "wrapper.application"),
        (uid("test-product"), TEST_NAME + ".xctest", "wrapper.cfbundle"),
    ]:
        obj(identifier, product, ["isa = PBXFileReference;", f"explicitFileType = {kind};",
                                "includeInIndex = 0;", f"path = {quoted(product)};",
                                "sourceTree = BUILT_PRODUCTS_DIR;"])
    products_id = uid("group:products")
    obj(products_id, "Products", ["isa = PBXGroup;", array("children", [APP_PRODUCT_ID, uid("test-product")]),
                                 "name = Products;", 'sourceTree = "<group>";'])
    root_id = uid("group:root")
    obj(root_id, "Main Group", ["isa = PBXGroup;", array("children", groups + [assets_id, products_id]),
                                'sourceTree = "<group>";'])

    for target, sources, resource_files in [("app", swift_build, resources), ("test", test_build, [])]:
        for name, phase_kind, entries in [
            ("Sources", "PBXSourcesBuildPhase", sources),
            ("Frameworks", "PBXFrameworksBuildPhase", []),
            ("Resources", "PBXResourcesBuildPhase", resource_files),
        ]:
            obj(uid(target + ":" + name), target + " " + name, [
                f"isa = {phase_kind};", "buildActionMask = 2147483647;", array("files", entries),
                "runOnlyForDeploymentPostprocessing = 0;",
            ])

    proxy_id = uid("test-proxy")
    dependency_id = uid("test-dependency")
    obj(proxy_id, "PBXContainerItemProxy", [
        "isa = PBXContainerItemProxy;", f"containerPortal = {PROJECT_ID};", "proxyType = 1;",
        f"remoteGlobalIDString = {APP_ID};", f"remoteInfo = {APP_NAME};",
    ])
    obj(dependency_id, "PBXTargetDependency", ["isa = PBXTargetDependency;", f"target = {APP_ID};",
                                               f"targetProxy = {proxy_id};"])
    for target, identifier, name, product_id, product_type, dependencies in [
        ("app", APP_ID, APP_NAME, APP_PRODUCT_ID, "application", []),
        ("test", uid("test-target"), TEST_NAME, uid("test-product"), "bundle.unit-test", [dependency_id]),
    ]:
        obj(identifier, name, [
            "isa = PBXNativeTarget;", f"buildConfigurationList = {uid(target + ':config-list')};",
            array("buildPhases", [uid(target + ":" + phase) for phase in ["Sources", "Frameworks", "Resources"]]),
            "buildRules = ();", array("dependencies", dependencies), f"name = {name};",
            f"productName = {name};", f"productReference = {product_id};",
            f'productType = "com.apple.product-type.{product_type}";',
        ])

    obj(PROJECT_ID, "Project object", [
        "isa = PBXProject;",
        "attributes = { BuildIndependentTargetsInParallel = 1; LastUpgradeCheck = 2700; "
        f"TargetAttributes = {{ {APP_ID} = {{ CreatedOnToolsVersion = 27.0; }}; "
        f"{uid('test-target')} = {{ CreatedOnToolsVersion = 27.0; TestTargetID = {APP_ID}; }}; }}; }};",
        f"buildConfigurationList = {uid('project:config-list')};", 'compatibilityVersion = "Xcode 15.0";',
        'developmentRegion = "zh-Hant";', "hasScannedForEncodings = 0;",
        'knownRegions = (en, Base, "zh-Hant");', f"mainGroup = {root_id};", f"productRefGroup = {products_id};",
        'projectDirPath = "";', 'projectRoot = "";', array("targets", [APP_ID, uid("test-target")]),
    ])

    common = [f"SDKROOT = iphoneos;", f"IPHONEOS_DEPLOYMENT_TARGET = {deploy_target};", f"SWIFT_VERSION = {swift_ver};"]
    for scope in ["project", "app", "test"]:
        for configuration in ["Debug", "Release"]:
            settings_list = list(common)
            if scope == "project":
                settings_list += ["ALWAYS_SEARCH_USER_PATHS = NO;", "CLANG_ENABLE_MODULES = YES;",
                                  "CLANG_ENABLE_OBJC_ARC = YES;", "COPY_PHASE_STRIP = NO;",
                                  "ENABLE_STRICT_OBJC_MSGSEND = YES;", "GCC_C_LANGUAGE_STANDARD = gnu17;"]
            else:
                bundle = bundle_id + (".tests" if scope == "test" else "")
                family = device_family if scope == "app" else '"1,2"'
                settings_list += ["CODE_SIGN_STYLE = Automatic;", "CURRENT_PROJECT_VERSION = 2;",
                                  f"DEVELOPMENT_TEAM = {team};",
                                  "MARKETING_VERSION = 2.0;", f"PRODUCT_BUNDLE_IDENTIFIER = {bundle};",
                                  'PRODUCT_NAME = "$(TARGET_NAME)";', f'TARGETED_DEVICE_FAMILY = {family};',
                                  'SUPPORTED_PLATFORMS = "iphoneos iphonesimulator";']
                if scope == "app":
                    settings_list += [f"ASSETCATALOG_COMPILER_APPICON_NAME = {app_icon};",
                                      "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;",
                                      "ASSETCATALOG_COMPILER_INCLUDE_ALL_APPICON_ASSETS = YES;",
                                      f"INFOPLIST_FILE = {info_plist};",
                                      'LD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "@executable_path/Frameworks");']
                else:
                    settings_list += ["GENERATE_INFOPLIST_FILE = YES;", 'BUNDLE_LOADER = "$(TEST_HOST)";',
                                      f'TEST_HOST = "$(BUILT_PRODUCTS_DIR)/{APP_NAME}.app/{APP_NAME}";',
                                      'LD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "@executable_path/Frameworks", "@loader_path/Frameworks");']
            if configuration == "Debug":
                settings_list += ["DEBUG_INFORMATION_FORMAT = dwarf;", 'SWIFT_OPTIMIZATION_LEVEL = "-Onone";',
                                  'SWIFT_ACTIVE_COMPILATION_CONDITIONS = "$(inherited) DEBUG";',
                                  "ENABLE_TESTABILITY = YES;"]
            else:
                settings_list += ['DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";', "SWIFT_COMPILATION_MODE = wholemodule;"]
            obj(uid(scope + ":" + configuration), scope + " " + configuration, [
                "isa = XCBuildConfiguration;", "buildSettings = { " + " ".join(settings_list) + " };",
                f"name = {configuration};",
            ])
        obj(uid(scope + ":config-list"), scope + " configuration list", [
            "isa = XCConfigurationList;",
            array("buildConfigurations", [uid(scope + ":" + configuration) for configuration in ["Debug", "Release"]]),
            "defaultConfigurationIsVisible = 0;", "defaultConfigurationName = Release;",
        ])

    project_str = "//!$*UTF8*$!\n{\n\tarchiveVersion = 1;\n\tclasses = {};\n\tobjectVersion = 60;\n\tobjects = {\n"
    project_str += "\n".join(objects)
    project_str += f"\n\t}};\n\trootObject = {PROJECT_ID} /* Project object */;\n}}\n"

    def reference(identifier: str, name: str, product: str) -> str:
        return f'<BuildableReference BuildableIdentifier="primary" BlueprintIdentifier="{identifier}" BuildableName="{product}" BlueprintName="{name}" ReferencedContainer="container:{APP_NAME}.xcodeproj"/>'

    app_reference = reference(APP_ID, APP_NAME, APP_NAME + ".app")
    test_reference = reference(uid("test-target"), TEST_NAME, TEST_NAME + ".xctest")
    scheme_str = f'''<?xml version="1.0" encoding="UTF-8"?>
<Scheme LastUpgradeVersion="2700" version="1.3">
  <BuildAction parallelizeBuildables="YES" buildImplicitDependencies="YES">
    <BuildActionEntries>
      <BuildActionEntry buildForTesting="YES" buildForRunning="YES" buildForProfiling="YES" buildForArchiving="YES" buildForAnalyzing="YES">{app_reference}</BuildActionEntry>
      <BuildActionEntry buildForTesting="YES" buildForRunning="NO" buildForProfiling="NO" buildForArchiving="NO" buildForAnalyzing="NO">{test_reference}</BuildActionEntry>
    </BuildActionEntries>
  </BuildAction>
  <TestAction buildConfiguration="Debug" selectedDebuggerIdentifier="Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier="Xcode.IDEFoundation.Launcher.LLDB" shouldUseLaunchSchemeArgsEnv="YES">
    <Testables><TestableReference skipped="NO">{test_reference}</TestableReference></Testables>
  </TestAction>
  <LaunchAction buildConfiguration="Debug" selectedDebuggerIdentifier="Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier="Xcode.IDEFoundation.Launcher.LLDB" launchStyle="0" useCustomWorkingDirectory="NO" ignoresPersistentStateOnLaunch="NO" debugDocumentVersioning="YES" debugServiceExtension="internal" allowLocationSimulation="YES"><BuildableProductRunnable runnableDebuggingMode="0">{app_reference}</BuildableProductRunnable></LaunchAction>
  <ProfileAction buildConfiguration="Release" shouldUseLaunchSchemeArgsEnv="YES" savedToolIdentifier="" useCustomWorkingDirectory="NO" debugDocumentVersioning="YES"><BuildableProductRunnable runnableDebuggingMode="0">{app_reference}</BuildableProductRunnable></ProfileAction>
  <AnalyzeAction buildConfiguration="Debug"/>
  <ArchiveAction buildConfiguration="Release" revealArchiveInOrganizer="YES"/>
</Scheme>
'''
    return project_str, scheme_str


def main() -> int:
    parser = argparse.ArgumentParser(description="Inspect and safely manage Xcode project membership.")
    parser.add_argument("--dry-run", action="store_true", help="Perform inspection without writing to disk (default).")
    parser.add_argument("--check", action="store_true", help="Alias for --dry-run inspection.")
    parser.add_argument("--force", action="store_true", help="Request project regeneration (high-risk; requires --confirm).")
    parser.add_argument("--confirm", action="store_true", help="Explicit confirmation for destructive regeneration.")
    args = parser.parse_args()

    # Destructive overwrite branch
    if args.force:
        if not args.confirm:
            print("[REFUSED] High-Risk Operation Aborted:")
            print("  Regenerating project.pbxproj will overwrite the existing file and may erase manual Xcode customizations.")
            print("  If you intentionally wish to regenerate from source files, you must pass BOTH --force AND --confirm.")
            print("  Recommended: Run without flags or with --dry-run for non-destructive inspection.")
            return 1

        if not PBXPROJ_PATH.exists():
            print(f"[ERROR] Existing project file not found: {PBXPROJ_PATH}")
            return 1

        pbx_text = PBXPROJ_PATH.read_text(encoding="utf-8")
        data = parse_openstep(pbx_text)
        objects = data.get("objects", {})
        root = objects.get(data.get("rootObject", ""), {})
        settings = extract_app_build_settings(objects, root)

        # Create timestamped backup
        timestamp = dt.datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_path = PROJECT_DIR / f"project.pbxproj.backup.{timestamp}"
        latest_backup_path = PROJECT_DIR / "project.pbxproj.backup"
        shutil.copy2(PBXPROJ_PATH, backup_path)
        shutil.copy2(PBXPROJ_PATH, latest_backup_path)
        print(f"[BACKUP] Created backup: {backup_path.relative_to(ROOT)}")

        # Build and write project
        project_str, scheme_str = build_project_content(settings)
        PBXPROJ_PATH.write_text(project_str, encoding="utf-8")
        scheme_dir = SCHEME_PATH.parent
        scheme_dir.mkdir(parents=True, exist_ok=True)
        SCHEME_PATH.write_text(scheme_str, encoding="utf-8")
        print("[SUCCESS] Project regenerated successfully using dynamic preserved settings:")
        for k in sorted(settings):
            print(f"  - {k} = {settings[k]}")
        return 0

    # Non-destructive Inspection Mode (default and --dry-run)
    print("=" * 60)
    print("Xcode Project Safe Inspector (Dry-Run / Non-Destructive)")
    print("=" * 60)

    ok, issues, settings = inspect_project()

    swift_count = len(list(ROOT.glob("SwiftUI/*.swift")))
    test_count = len(list(ROOT.glob("GEM_BeyondTheVoiceTests/*.swift")))
    resource_count = (
        len(list(ROOT.glob("Content/*.json")))
        + len(list(ROOT.glob("font/*.ttf")))
        + len(list(ROOT.glob("font/*-OFL.txt")))
        + (1 if (ROOT / "Assets.xcassets").exists() else 0)
        + (1 if (ROOT / "Config/PrivacyInfo.xcprivacy").exists() else 0)
    )

    print(f"Project Scope:")
    print(f"  • SwiftUI Sources : {swift_count} files on disk")
    print(f"  • XCTest Sources  : {test_count} files on disk")
    print(f"  • App Resources   : {resource_count} resources on disk")
    print("\nProtected Build Settings on Disk (App Target):")
    for key in [
        "DEVELOPMENT_TEAM",
        "PRODUCT_BUNDLE_IDENTIFIER",
        "ASSETCATALOG_COMPILER_APPICON_NAME",
        "TARGETED_DEVICE_FAMILY",
        "INFOPLIST_FILE",
        "IPHONEOS_DEPLOYMENT_TARGET",
        "SWIFT_VERSION",
    ]:
        val = settings.get(key, "(not set)")
        print(f"  • {key:35s} = {val}")

    if ok:
        print("\n[OK] All protected build settings, targets, and file memberships are in sync and verified.")
        print("[INFO] No disk files were modified (Safe Inspection Mode).")
        return 0
    else:
        print("\n[WARN] Issues detected during project inspection:")
        for issue in issues:
            print(f"  ⚠ {issue}")
        print("\n[INFO] No disk files were modified (Safe Inspection Mode).")
        return 1


if __name__ == "__main__":
    sys.exit(main())
