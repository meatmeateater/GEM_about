#!/usr/bin/env python3
"""Regenerate Xcode file membership after adding Swift/resources.

Preserves the existing app identity and project/target IDs; targets iOS 27.
Preserves user's actual Xcode project settings:
- ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon
- ASSETCATALOG_COMPILER_INCLUDE_ALL_APPICON_ASSETS = YES
- TARGETED_DEVICE_FAMILY = 1 (iPhone only)
- DEVELOPMENT_TEAM = 398C8C2Q8L
- PRODUCT_BUNDLE_IDENTIFIER = com.example.GEMBeyondTheVoice
"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROJECT_ID = "1781F676DEDF5767F3243DB0"
APP_ID = "730950AD798A77AD508AA9E2"
APP_PRODUCT_ID = "6EDEBCE3A94A8852C819FDBE"
APP_NAME = "GEM_BeyondTheVoice"
TEST_NAME = APP_NAME + "Tests"
DEVELOPMENT_TEAM = "398C8C2Q8L"


def uid(value: str) -> str:
    return hashlib.sha1(("gem-about-v2:" + value).encode()).hexdigest()[:24].upper()


def quoted(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def generate(dry_run: bool = False) -> None:
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

    common = ["SDKROOT = iphoneos;", "IPHONEOS_DEPLOYMENT_TARGET = 27.0;", "SWIFT_VERSION = 5.0;"]
    for scope in ["project", "app", "test"]:
        for configuration in ["Debug", "Release"]:
            settings = list(common)
            if scope == "project":
                settings += ["ALWAYS_SEARCH_USER_PATHS = NO;", "CLANG_ENABLE_MODULES = YES;",
                             "CLANG_ENABLE_OBJC_ARC = YES;", "COPY_PHASE_STRIP = NO;",
                             "ENABLE_STRICT_OBJC_MSGSEND = YES;", "GCC_C_LANGUAGE_STANDARD = gnu17;"]
            else:
                bundle = "com.example.GEMBeyondTheVoice" + (".tests" if scope == "test" else "")
                settings += ["CODE_SIGN_STYLE = Automatic;", "CURRENT_PROJECT_VERSION = 2;",
                             f"DEVELOPMENT_TEAM = {DEVELOPMENT_TEAM};",
                             "MARKETING_VERSION = 2.0;", f"PRODUCT_BUNDLE_IDENTIFIER = {bundle};",
                             'PRODUCT_NAME = "$(TARGET_NAME)";', 'TARGETED_DEVICE_FAMILY = 1;',
                             'SUPPORTED_PLATFORMS = "iphoneos iphonesimulator";']
                if scope == "app":
                    settings += ["ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;",
                                 "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;",
                                 "ASSETCATALOG_COMPILER_INCLUDE_ALL_APPICON_ASSETS = YES;",
                                 "INFOPLIST_FILE = Config/Info.plist;",
                                 'LD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "@executable_path/Frameworks");']
                else:
                    settings += ["GENERATE_INFOPLIST_FILE = YES;", 'BUNDLE_LOADER = "$(TEST_HOST)";',
                                 f'TEST_HOST = "$(BUILT_PRODUCTS_DIR)/{APP_NAME}.app/{APP_NAME}";',
                                 'LD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "@executable_path/Frameworks", "@loader_path/Frameworks");']
            if configuration == "Debug":
                settings += ["DEBUG_INFORMATION_FORMAT = dwarf;", 'SWIFT_OPTIMIZATION_LEVEL = "-Onone";',
                             'SWIFT_ACTIVE_COMPILATION_CONDITIONS = "$(inherited) DEBUG";',
                             "ENABLE_TESTABILITY = YES;"]
            else:
                settings += ['DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";', "SWIFT_COMPILATION_MODE = wholemodule;"]
            obj(uid(scope + ":" + configuration), scope + " " + configuration, [
                "isa = XCBuildConfiguration;", "buildSettings = { " + " ".join(settings) + " };",
                f"name = {configuration};",
            ])
        obj(uid(scope + ":config-list"), scope + " configuration list", [
            "isa = XCConfigurationList;",
            array("buildConfigurations", [uid(scope + ":" + configuration) for configuration in ["Debug", "Release"]]),
            "defaultConfigurationIsVisible = 0;", "defaultConfigurationName = Release;",
        ])

    project = "// !$*UTF8*$!\n{\n\tarchiveVersion = 1;\n\tclasses = {};\n\tobjectVersion = 60;\n\tobjects = {\n"
    project += "\n".join(objects)
    project += f"\n\t}};\n\trootObject = {PROJECT_ID} /* Project object */;\n}}\n"
    project_dir = ROOT / (APP_NAME + ".xcodeproj")

    def reference(identifier: str, name: str, product: str) -> str:
        return f'<BuildableReference BuildableIdentifier="primary" BlueprintIdentifier="{identifier}" BuildableName="{product}" BlueprintName="{name}" ReferencedContainer="container:{APP_NAME}.xcodeproj"/>'

    app_reference = reference(APP_ID, APP_NAME, APP_NAME + ".app")
    test_reference = reference(uid("test-target"), TEST_NAME, TEST_NAME + ".xctest")
    scheme = f'''<?xml version="1.0" encoding="UTF-8"?>
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
    if dry_run:
        print(f"[Dry Run] Validated settings: {len(swift_files)} Swift, {len(test_files)} XCTest, {len(resources)} resources.")
        print("Settings protected: DEVELOPMENT_TEAM=398C8C2Q8L, TARGETED_DEVICE_FAMILY=1, ASSETCATALOG_COMPILER_APPICON_NAME=AppIcon.")
        return

    (project_dir / "project.pbxproj").write_text(project, encoding="utf-8")
    scheme_dir = project_dir / "xcshareddata/xcschemes"
    scheme_dir.mkdir(parents=True, exist_ok=True)
    (scheme_dir / (APP_NAME + ".xcscheme")).write_text(scheme, encoding="utf-8")
    print(f"Updated Xcode membership: {len(swift_files)} app Swift, {len(test_files)} XCTest, {len(resources)} resources.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Update Xcode project membership")
    parser.add_argument("--dry-run", action="store_true", help="Validate without writing files")
    parser.add_argument("--force", action="store_true", help="Force regenerate project.pbxproj")
    args = parser.parse_args()

    if not args.force and not args.dry_run:
        print("Notice: To avoid overwriting existing Xcode configuration, run with --force to regenerate, or --dry-run to validate.")
        sys.exit(0)

    generate(dry_run=args.dry_run)
