#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
h55_map_packer.py

Pack:   Scenario/<Mission>  -> LOCAL_DIR/COMPILED_MAPS/DEV_<Mission>.h5m
Unpack: LOCAL_DIR/COMPILED_MAPS/*.h5m -> restore into sources at
        UserMODs/MMH55-Cam-Maps/Maps/Scenario/<Mission>/ (with backup),
        reverting map.xdb name, map-tag.xdb, and Player-2 flip.

README requirements reflected:
- Use DEV_C1M1.h5m as the template; internal folder under Maps/SingleMissions
  renamed to DEV_<Mission>; copy mission files into it; rename main XDB to
  map.xdb; set map-tag.xdb to:
    <AdvMapDesc href="map.xdb#xpointer(/AdvMapDesc)"/>
- Optional single-player start: activate Player 2 in map.xdb (flip).  :contentReference[oaicite:3]{index=3}
- During "opposing action" (unpack), restore original XDB name and the flip.

All artifacts, extractions and backups go to LOCAL_DIR/COMPILED_MAPS.
"""

from __future__ import annotations
import sys
import os
import re
import json
import shutil
import zipfile
import tempfile
import datetime as _dt
from pathlib import Path
from typing import Optional, Tuple

import xml.etree.ElementTree as ET

# ---------- Constants ----------
META_FILENAME = ".campaigns_pack_meta.json"  # embedded to help lossless unpack
MAP_TAG_XML_FOR_MAP_XDB = '<AdvMapDesc href="map.xdb#xpointer(/AdvMapDesc)"/>'  # :contentReference[oaicite:4]{index=4}
SINGLE_MISSIONS_REL = Path("Maps") / "SingleMissions"

# ---------- Helpers ----------
def find_repo_root(start: Path) -> Path:
    """Ascend directories until we find a path that looks like the repo root."""
    cur = start
    for parent in [cur] + list(cur.parents):
        if (parent / "README.md").exists() and (parent / "UserMODs").exists():
            return parent
    return start.parent.parent  # reasonable fallback

def ensure_dir(p: Path) -> None:
    p.mkdir(parents=True, exist_ok=True)

def list_directories(p: Path) -> list[Path]:
    if not p.exists():
        return []
    return sorted([d for d in p.iterdir() if d.is_dir()])

def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")

def write_text(path: Path, text: str) -> None:
    path.write_text(text, encoding="utf-8", newline="\n")

def prompt_choice(options: list[str], title: str) -> int:
    if not options:
        raise SystemExit(f"No options available for: {title}")
    print(f"\n{title}")
    for i, opt in enumerate(options, 1):
        print(f"  {i}. {opt}")
    while True:
        raw = input("Enter number: ").strip()
        if raw.isdigit():
            idx = int(raw)
            if 1 <= idx <= len(options):
                return idx - 1
        print("Invalid choice. Try again.")

def yes_no(question: str, default: bool = False) -> bool:
    suffix = " [Y/n]: " if default else " [y/N]: "
    ans = input(question + suffix).strip().lower()
    if ans == "" and default:
        return True
    return ans in ("y", "yes")

def zip_dir_to_file(src_dir: Path, out_file: Path) -> None:
    with zipfile.ZipFile(out_file, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for root, _, files in os.walk(src_dir):
            root_path = Path(root)
            for fname in files:
                abs_f = root_path / fname
                arc = abs_f.relative_to(src_dir)
                zf.write(abs_f, arcname=str(arc))

def unzip_to_dir(zip_file: Path, dst_dir: Path) -> None:
    with zipfile.ZipFile(zip_file, "r") as zf:
        zf.extractall(dst_dir)

def detect_singlemissions_folder(root_dir: Path) -> Path:
    sm_dir = root_dir / SINGLE_MISSIONS_REL
    if not sm_dir.exists():
        raise RuntimeError(f"Missing {SINGLE_MISSIONS_REL} in unpacked structure.")
    subdirs = [d for d in sm_dir.iterdir() if d.is_dir()]
    if not subdirs:
        raise RuntimeError(f"No folders found inside {SINGLE_MISSIONS_REL}.")
    subdirs.sort(key=lambda p: p.name)
    return subdirs[0]

def parse_orig_xdb_from_map_tag(map_tag_path: Path) -> Optional[str]:
    try:
        content = read_text(map_tag_path)
    except Exception as e:
        print(e)
        return None
    m = re.search(r'href="([^"]+)"', content)
    if not m:
        return None
    href = m.group(1)
    href_base = href.split("#", 1)[0]
    return Path(href_base).name or None

def write_map_tag_for_target(map_tag_path: Path, xdb_name: str) -> None:
    if xdb_name == "map.xdb":
        xml = MAP_TAG_XML_FOR_MAP_XDB  # exact string per README. :contentReference[oaicite:5]{index=5}
    else:
        xml = f'<AdvMapDesc href="{xdb_name}#xpointer(/AdvMapDesc)"/>'
    write_text(map_tag_path, xml)

def safe_rename(src: Path, dst: Path) -> None:
    if src.resolve() == dst.resolve():
        return
    if dst.exists():
        dst.unlink()
    src.rename(dst)

# ---------- XML helpers for the Player‑2 flip ----------
def _get_players_items(root: ET.Element) -> list[ET.Element]:
    # players element may be nested under AdvMapDesc
    players = root.find(".//players")
    if players is None:
        return []
    # children are usually <Item> entries
    return [c for c in list(players) if c.tag.endswith("Item") or c.tag == "Item"]

def _get_or_create_child(parent: ET.Element, tag: str) -> ET.Element:
    node = parent.find(tag)
    if node is None:
        node = ET.SubElement(parent, tag)
    return node

def set_player2_active(map_xdb_path: Path, make_active: bool) -> Tuple[bool, Optional[bool]]:
    """
    Toggle Player 2 (<players>/<Item>[index 1]) <ActivePlayer>.
    Returns (success, previous_value or None if unknown).
    """
    try:
        tree = ET.parse(map_xdb_path)
        root = tree.getroot()
    except Exception as e:
        print(e)
        return (False, None)

    items = _get_players_items(root)
    if len(items) < 2:
        return (False, None)
    p2 = items[1]
    ap = _get_or_create_child(p2, "ActivePlayer")
    prev = None
    if ap.text is not None:
        prev = ap.text.strip().lower() == "true"
    ap.text = "true" if make_active else "false"
    try:
        # Write back without XML declaration; XDB files are fine with this.
        tree.write(map_xdb_path, encoding="utf-8", xml_declaration=False)
        return (True, prev)
    except Exception as e:
        print(e)
        return (False, prev)

# ---------- Core operations ----------
def pack(repo_root: Path) -> None:
    missions_root = repo_root / "UserMODs" / "MMH55-Cam-Maps" / "Maps" / "Scenario"
    template_h5m = repo_root / "DEV_C1M1.h5m"
    local_dir = repo_root / "LOCAL_DIR"
    compiled_dir = local_dir / "COMPILED_MAPS"

    ensure_dir(compiled_dir)

    if not template_h5m.exists():
        raise SystemExit(
            f"Template map not found at {template_h5m}. "
            "The README expects it at repository root.  :contentReference[oaicite:6]{index=6}"
        )

    mission_dirs = list_directories(missions_root)
    if not mission_dirs:
        raise SystemExit(f"No missions found in {missions_root}")

    names = [d.name for d in mission_dirs]
    idx = prompt_choice(names, "Select a mission to PACK into a single-player .h5m:")
    mission_name = names[idx]
    mission_src = mission_dirs[idx]
    internal_dev_id = f"DEV_{mission_name}"

    map_tag_src = mission_src / "map-tag.xdb"
    orig_xdb_guess = parse_orig_xdb_from_map_tag(map_tag_src) or f"{mission_name}.xdb"

    print(f"\nPacking mission: {mission_name}")
    print(f"- Original main XDB (from sources): {orig_xdb_guess}")
    print(f"- Internal folder in .h5m: {internal_dev_id}")

    with tempfile.TemporaryDirectory(prefix="h55_pack_") as tmpdir:
        tmpdir = Path(tmpdir)

        # 1) Unzip template to temp
        unzip_to_dir(template_h5m, tmpdir)

        # 2) Rename internal folder to DEV_<Mission>
        singles_folder = detect_singlemissions_folder(tmpdir)
        new_singles_folder = singles_folder.parent / internal_dev_id
        if singles_folder.name != internal_dev_id:
            if new_singles_folder.exists():
                shutil.rmtree(new_singles_folder)
            singles_folder.rename(new_singles_folder)

        # 3) Clear the working folder
        for child in new_singles_folder.iterdir():
            if child.is_dir():
                shutil.rmtree(child)
            else:
                child.unlink()

        # 4) Copy mission files
        for item in mission_src.iterdir():
            dst = new_singles_folder / item.name
            if item.is_dir():
                shutil.copytree(item, dst, dirs_exist_ok=True)
            else:
                shutil.copy2(item, dst)

        # 5) Rename main XDB to map.xdb and rewrite map-tag.xdb
        src_main_xdb = new_singles_folder / orig_xdb_guess
        if not src_main_xdb.exists():
            # try case-insensitive search
            lower = orig_xdb_guess.lower()
            alt = None
            for f in new_singles_folder.glob("*.xdb"):
                if f.name.lower() == lower:
                    alt = f
                    break
            if alt:
                src_main_xdb = alt
            else:
                xdbs = list(new_singles_folder.glob("*.xdb"))
                if xdbs:
                    src_main_xdb = max(xdbs, key=lambda p: p.stat().st_size)
        if not src_main_xdb.exists():
            raise SystemExit("Could not locate the mission's main .xdb to rename to map.xdb.")

        dst_main_xdb = new_singles_folder / "map.xdb"
        safe_rename(src_main_xdb, dst_main_xdb)

        map_tag_dst = new_singles_folder / "map-tag.xdb"
        write_map_tag_for_target(map_tag_dst, "map.xdb")  # exact string per README. :contentReference[oaicite:7]{index=7}

        # 6) Ask about the single-player flip (activate Player 2)
        flip_applied = False
        player2_prev = None
        if yes_no("Activate Player 2 in map.xdb for single-player start?", default=True):
            ok, prev = set_player2_active(dst_main_xdb, True)
            flip_applied = ok
            player2_prev = prev
            if ok:
                print(" - Player 2 set to ActivePlayer=true.")
            else:
                print(" - Could not edit map.xdb automatically; continuing without flip.")

        # 7) Embed metadata for perfect round-trip on unpack
        meta = {
            "mission_folder": mission_name,
            "original_main_xdb": orig_xdb_guess,
            "internal_dev_id": internal_dev_id,
            "player2_flip_applied": flip_applied,
            "player2_active_original": player2_prev,
        }
        write_text(new_singles_folder / META_FILENAME, json.dumps(meta, indent=2))

        # 8) Zip temp dir into COMPILED_MAPS/DEV_<Mission>.h5m
        out_h5m = compiled_dir / f"{internal_dev_id}.h5m"
        if out_h5m.exists():
            out_h5m.unlink()
        zip_dir_to_file(tmpdir, out_h5m)

    print(f"\n✅ Packed: {out_h5m}")
    print("Reminder: Per README, keep Instant Travel blocked if it was blocked in the mission.  :contentReference[oaicite:8]{index=8}")

def _timestamp() -> str:
    return _dt.datetime.now().strftime("%Y%m%d-%H%M%S")

def _zip_folder(folder: Path, out_zip: Path) -> None:
    with zipfile.ZipFile(out_zip, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for root, _, files in os.walk(folder):
            root_p = Path(root)
            for f in files:
                p = root_p / f
                zf.write(p, arcname=str(p.relative_to(folder)))

def unpack(repo_root: Path) -> None:
    local_dir = repo_root / "LOCAL_DIR"
    compiled_dir = local_dir / "COMPILED_MAPS"
    ensure_dir(compiled_dir)

    h5ms = sorted([p for p in compiled_dir.glob("*.h5m") if p.is_file()])
    if not h5ms:
        raise SystemExit(f"No .h5m files found in {compiled_dir}")

    names = [p.name for p in h5ms]
    idx = prompt_choice(names, "Select a .h5m to UNPACK and restore into sources:")
    chosen = h5ms[idx]

    print(f"\nUnpacking: {chosen}")
    with tempfile.TemporaryDirectory(prefix="h55_unpack_") as tmpdir:
        tmpdir = Path(tmpdir)
        unzip_to_dir(chosen, tmpdir)

        singles_folder = detect_singlemissions_folder(tmpdir)
        dev_folder_name = singles_folder.name

        # Read metadata if present
        meta_path = singles_folder / META_FILENAME
        mission_folder = None
        orig_xdb_name = None
        p2_flip_applied = False
        p2_active_original = None
        if meta_path.exists():
            try:
                meta = json.loads(read_text(meta_path))
                mission_folder = meta.get("mission_folder")
                orig_xdb_name = meta.get("original_main_xdb")
                p2_flip_applied = bool(meta.get("player2_flip_applied", False))
                p2_active_original = meta.get("player2_active_original", None)
            except Exception as e:
                print(e)
                pass

        if not mission_folder:
            mission_folder = dev_folder_name.replace("DEV_", "", 1)
        if not orig_xdb_name:
            orig_xdb_name = f"{mission_folder}.xdb"

        # Extract to a reference folder (inspectable)
        extracted_root = compiled_dir / "extracted" / dev_folder_name
        if extracted_root.exists():
            shutil.rmtree(extracted_root)
        shutil.copytree(singles_folder, extracted_root)

        # Revert map.xdb -> <orig_xdb_name>, and fix map-tag.xdb
        map_xdb = extracted_root / "map.xdb"
        if map_xdb.exists():
            safe_rename(map_xdb, extracted_root / orig_xdb_name)
        map_tag = extracted_root / "map-tag.xdb"
        if map_tag.exists():
            write_map_tag_for_target(map_tag, orig_xdb_name)

        # Roll back the Player‑2 flip to the original value if we know it,
        # otherwise default to false (campaign default).
        if p2_flip_applied:
            target_value = bool(p2_active_original) if p2_active_original is not None else False
            set_player2_active(extracted_root / orig_xdb_name, target_value)

        # Remove metadata from the restored copy
        try:
            (extracted_root / META_FILENAME).unlink(missing_ok=True)
        except TypeError:
            f = extracted_root / META_FILENAME
            if f.exists():
                f.unlink()

        print(f" - Files prepared in: {extracted_root}")

        # Copy back into the repo sources with backup and replacement
        missions_root = repo_root / "UserMODs" / "MMH55-Cam-Maps" / "Maps" / "Scenario"
        dest_folder = missions_root / mission_folder
        ensure_dir(missions_root)

        # Backup existing content if present
        if dest_folder.exists():
            backups_dir = compiled_dir / "backups"
            ensure_dir(backups_dir)
            bk_zip = backups_dir / f"{mission_folder}-{_timestamp()}.zip"
            print(f" - Backing up existing sources to: {bk_zip}")
            _zip_folder(dest_folder, bk_zip)
            shutil.rmtree(dest_folder)

        print(f" - Restoring into sources: {dest_folder}")
        shutil.copytree(extracted_root, dest_folder)

    print(f"\n✅ Unpacked and restored into sources: {dest_folder}")
    print(f"   A reference extraction remains at: {compiled_dir / 'extracted' / dev_folder_name}")
    print(f"   A backup (if any) lives at: {compiled_dir / 'backups'}")

# ---------- Entrypoint ----------
def main(argv: list[str]) -> None:
    script_path = Path(__file__).resolve()
    repo_root = find_repo_root(script_path)

    if len(argv) < 2 or argv[1] in {"-h", "--help", "help"}:
        print(__doc__)
        print("\nUsage:\n  python git_docs/scripts/h55_map_packer.py pack\n"
              "  python git_docs/scripts/h55_map_packer.py unpack\n")
        return

    cmd = argv[1].lower()
    if cmd == "pack":
        pack(repo_root)
    elif cmd == "unpack":
        unpack(repo_root)
    else:
        print(f"Unknown command: {cmd}")
        print("Use: pack | unpack")

if __name__ == "__main__":
    main(sys.argv)
