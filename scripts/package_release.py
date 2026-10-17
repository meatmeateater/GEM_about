#!/usr/bin/env python3
"""Create a release archive from source, excluding Git and local build state."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile

ROOT = Path(__file__).resolve().parents[1]
EXCLUDED = {".git", "xcuserdata", "DerivedData", "build", "dist", "__pycache__", ".validation-deps", ".DS_Store"}


def create_archive(output_dir: Path) -> None:
    output_dir.mkdir(parents=True, exist_ok=True)
    destination = output_dir / "GEM-about-iOS27-release.zip"
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
    receipt = {
        "file": destination.name,
        "files": count,
        "bytes": destination.stat().st_size,
        "sha256": checksum,
        "platform": "iOS 27.0",
        "testedOn": "macOS / Xcode 27 / iOS 27 Simulator",
    }
    (output_dir / "GEM-about-iOS27-release.sha256").write_text(checksum + "  " + destination.name + "\n", encoding="utf-8")
    (output_dir / "package-receipt.json").write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(receipt, indent=2))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "dist", help="Output directory for the release package")
    args = parser.parse_args()
    create_archive(args.output)
