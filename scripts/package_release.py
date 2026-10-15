#!/usr/bin/env python3
"""Create a Mac handoff ZIP from source, excluding Git and local build state."""
import hashlib
import json
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT.parents[1] / "dist"
EXCLUDED = {".git", "xcuserdata", "DerivedData", "build", "dist", "__pycache__", ".validation-deps"}


def main():
    OUTPUT.mkdir(exist_ok=True)
    destination = OUTPUT / "GEM-about-iOS27-v2.zip"
    count = 0
    with ZipFile(destination, "w", ZIP_DEFLATED, compresslevel=9) as archive:
        for path in sorted(ROOT.rglob("*")):
            relative = path.relative_to(ROOT)
            if not path.is_file() or any(part in EXCLUDED for part in relative.parts):
                continue
            if path.suffix == ".pyc" or path.name in {".DS_Store", ".gitignore"}:
                continue
            archive.write(path, "GEM_about/" + relative.as_posix())
            count += 1
    checksum = hashlib.sha256(destination.read_bytes()).hexdigest()
    receipt = {"file": destination.name, "files": count, "bytes": destination.stat().st_size,
               "sha256": checksum, "platform": "iOS 27.0", "xcodeBuild": "not run on Windows"}
    (OUTPUT / "GEM-about-iOS27-v2.sha256").write_text(checksum + "  " + destination.name + "\n", encoding="utf-8")
    (OUTPUT / "package-receipt.json").write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(receipt, indent=2))


if __name__ == "__main__":
    main()
