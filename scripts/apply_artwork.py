#!/usr/bin/env python3
"""Attach verified remote artwork metadata without bundling cover pixels.

Run after editing the catalog. Artwork provenance is added as a source on each
release. Songs inherit artwork only from a matching contemporary release, not
from a later re-recording that happens to contain the same song.
"""
import json
from pathlib import Path
from urllib.parse import urlparse

ROOT = Path(__file__).resolve().parents[1]


def main():
    path = ROOT / "Content/gem-catalog.json"
    data = json.loads(path.read_text(encoding="utf-8-sig"))
    artwork = json.loads((ROOT / "Content/artwork-map.json").read_text(encoding="utf-8-sig"))
    by_id = {entry["id"]: entry for entry in data["entries"]}
    existing = {source["id"] for source in data["sources"]}
    for entry_id, art in artwork.items():
        entry = by_id[entry_id]
        entry["artworkURL"] = art["url"]
        source_id = "artwork-" + entry_id
        if source_id not in existing:
            data["sources"].append({
                "id": source_id, "title": entry["title"] + "｜封面來源",
                "publisher": urlparse(art["sourceURL"]).hostname,
                "url": art["sourceURL"], "verifiedAt": "2026-10-15",
                "scope": "此發行作品的遠端封面來源；封面權利屬相應權利人。"
            })
            existing.add(source_id)
        if source_id not in entry["sourceIDs"]:
            entry["sourceIDs"].append(source_id)

    linked = 0
    releases = [entry for entry in data["entries"] if entry["kind"] == "release"]
    for song in (entry for entry in data["entries"] if entry["kind"] == "track"):
        candidates = [release for release in releases
                      if release["date"]["year"] <= song["date"]["year"]
                      and any(track.get("entryID") == song["id"] for track in release.get("tracks", []))]
        if candidates:
            primary = min(candidates, key=lambda release: release["date"]["year"])
            if primary.get("artworkURL"):
                song["artworkURL"] = primary["artworkURL"]
                source_id = "artwork-" + primary["id"]
                if source_id not in song["sourceIDs"]:
                    song["sourceIDs"].append(source_id)
                linked += 1
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Applied {len(artwork)} verified release covers; {linked} contemporary song covers.")


if __name__ == "__main__":
    main()
