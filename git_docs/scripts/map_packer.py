#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
h55_map_packer.py

Pack:  Scenario/<Mission>  ->  LOCAL_DIR/COMPILED_MAPS/DEV_<Mission>.h5m
Unpack: LOCAL_DIR/COMPILED_MAPS/*.h5m -> LOCAL_DIR/COMPILED_MAPS/extracted/<DEV_...>/
         and revert map.xdb back to the original XDB name.

Assumptions from README:
- Template map exists at repo root: DEV_C1M1.h5m
- Mission sources live under: UserMODs/MMH55-Cam-Maps/Maps/Scenario/<Mission>/
- In sources, map-tag.xdb points to the mission’s original main XDB (e.g., C1M1.xdb).
- During packing we must:
    * rename that main XDB to map.xdb
    * set map-tag.xdb content to: <AdvMapDesc href="map.xdb#xpointer(/AdvMapDesc)"/>
    * place everything under Maps/SingleMissions/DEV_<Mission>
    * zip and name the file with .h5m extension
- During unpacking we revert map.xdb to the original name and fix map-tag.xdb.

All results (built maps & extracted folders) are stored inside LOCAL_DIR/COMPILED_MAPS.
"""

from __future__ import annotations
import sys
import os
import re
import json
import shutil
import zipfile
import tempfile
from pathlib import Path
from typing import Optional, Tuple

# ---------- Constants ----------
META_FILENAME = ".campaigns_pack_meta.json"  # embedded to help lossless unpack
MAP_TAG_XML_FOR_MAP_XDB = '<AdvMapDesc href="map.xdb#xpointer(/AdvMapDesc)"/>'
SINGLE_MISSIONS_REL = Path("Maps") / "SingleMissions"

# ---------- Helpers ----------
def find_repo_root(start: Path) -> Path:
    """Ascend directories until we find a path that looks like the repo root."""
    cur = start
    for parent in [cur] + list(cur.parents):
        if (parent / "README.md").exists() and (parent / "UserMODs").exists():
            return parent
    # Fallback: assume two levels up from scripts/ dir
    return start.parent.parent

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
    """Find the *single* folder inside Maps/SingleMissions in an unpacked template or map."""
    sm_dir = root_dir / SINGLE_MISSIONS_REL
    if not sm_dir.exists():
        raise RuntimeError(f"Missing {SINGLE_MISSIONS_REL} in unpacked structure.")
    subdirs = [d for d in sm_dir.iterdir() if d.is_dir()]
    if not subdirs:
        raise RuntimeError(f"No folders found inside {SINGLE_MISSIONS_REL}.")
    if len(subdirs) > 1:
        # We expect just one DEV_* folder in template/h5m.
        # If multiple exist, prefer a DEV_* with max length (usually the real one).
        subdirs.sort(key=lambda p: p.name)
    return subdirs[0]

def parse_orig_xdb_from_map_tag(map_tag_path: Path) -> Optional[str]:
    """
    In sources, map-tag.xdb usually contains href="C1M1.xdb#xpointer(/AdvMapDesc)".
    Return the basename part (e.g., "C1M1.xdb"). If not found, return None.
    """
    try:
        content = read_text(map_tag_path)
    except Exception:
        return None
    m = re.search(r'href="([^"]+)"', content)
    if not m:
        return None
    href = m.group(1)
    # Strip any #xpointer suffix and any path components
    href_base = href.split("#", 1)[0]
    href_name = Path(href_base).name
    return href_name if href_name else None

def write_map_tag_for_target(map_tag_path: Path, xdb_name: str) -> None:
    """
    Set map-tag.xdb to point at xdb_name (e.g., "map.xdb").
    If writing map.xdb, we must match the README line exactly.  :contentReference[oaicite:2]{index=2}
    Otherwise, write the same pattern but with provided xdb_name.
    """
    if xdb_name == "map.xdb":
        xml = MAP_TAG_XML_FOR_MAP_XDB
    else:
        xml = f'<AdvMapDesc href="{xdb_name}#xpointer(/AdvMapDesc)"/>'
    write_text(map_tag_path, xml)

def safe_rename(src: Path, dst: Path) -> None:
    if src.resolve() == dst.resolve():
        return
    if dst.exists():
        dst.unlink()
    src.rename(dst)

# ---------- Core operations ----------
def pack(repo_root: Path) -> None:
    missions_root = repo_root / "UserMODs" / "MMH55-Cam-Maps" / "Maps" / "Scenario"
    template_h5m = repo_root / "DEV_C1M1.h5m"
    local_dir = repo_root / "LOCAL_DIR"
    compiled_dir = local_dir / "COMPILED_MAPS"

    ensure_dir(compiled_dir)

    if not template_h5m.exists():
        raise SystemExit(
            f"Template map not found at {template_h5m}. The README expects it at repo root.  "
            "Open the repo and ensure DEV_C1M1.h5m exists.  "
            "See README: 'Test map: DEV_C1M1.h5m at the repository root'."
        )

    mission_dirs = list_directories(missions_root)
    if not mission_dirs:
        raise SystemExit(f"No missions found in {missions_root}")

    # Choose mission
    names = [d.name for d in mission_dirs]
    idx = prompt_choice(names, "Select a mission to PACK into a single-player .h5m:")
    mission_name = names[idx]
    mission_src = mission_dirs[idx]

    # Derive DEV_* id
    internal_dev_id = f"DEV_{mission_name}"

    # Determine original main xdb file from sources via map-tag.xdb
    map_tag_src = mission_src / "map-tag.xdb"
    orig_xdb_guess = parse_orig_xdb_from_map_tag(map_tag_src) or f"{mission_name}.xdb"

    print(f"\nPacking mission: {mission_name}")
    print(f"- Original main XDB (from sources): {orig_xdb_guess}")
    print(f"- Internal folder in .h5m: {internal_dev_id}")

    with tempfile.TemporaryDirectory(prefix="h55_pack_") as tmpdir:
        tmpdir = Path(tmpdir)

        # 1) Unzip template to temp
        unzip_to_dir(template_h5m, tmpdir)

        # 2) Find and rename Maps/SingleMissions/<template_folder> -> DEV_<mission_name>
        singles_folder = detect_singlemissions_folder(tmpdir)
        new_singles_folder = singles_folder.parent / internal_dev_id
        if singles_folder.name != internal_dev_id:
            if new_singles_folder.exists():
                shutil.rmtree(new_singles_folder)
            singles_folder.rename(new_singles_folder)

        # 3) Clear the working folder (inside DEV_<mission_name>)
        for child in new_singles_folder.iterdir():
            if child.is_dir():
                shutil.rmtree(child)
            else:
                child.unlink()

        # 4) Copy mission files from sources into the archive folder
        #    (this mirrors the README step 5). :contentReference[oaicite:3]{index=3}
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
                # As last resort, pick the largest .xdb file (often the main map)
                xdbs = list(new_singles_folder.glob("*.xdb"))
                if xdbs:
                    src_main_xdb = max(xdbs, key=lambda p: p.stat().st_size)

        dst_main_xdb = new_singles_folder / "map.xdb"
        if src_main_xdb.exists():
            safe_rename(src_main_xdb, dst_main_xdb)
        else:
            raise SystemExit("Could not locate the mission's main .xdb to rename to map.xdb.")

        map_tag_dst = new_singles_folder / "map-tag.xdb"
        if not map_tag_dst.exists():
            # If somehow missing, create it anew
            write_map_tag_for_target(map_tag_dst, "map.xdb")
        else:
            write_map_tag_for_target(map_tag_dst, "map.xdb")  # exact string required. :contentReference[oaicite:4]{index=4}

        # 6) Drop metadata for perfect round-trip on unpack (opposing action)
        meta = {
            "mission_folder": mission_name,
            "original_main_xdb": orig_xdb_guess,
            "internal_dev_id": internal_dev_id,
        }
        write_text(new_singles_folder / META_FILENAME, json.dumps(meta, indent=2))

        # 7) Zip the temp dir back into LOCAL_DIR/COMPILED_MAPS/DEV_<Mission>.h5m
        out_h5m = compiled_dir / f"{internal_dev_id}.h5m"
        if out_h5m.exists():
            out_h5m.unlink()
        zip_dir_to_file(tmpdir, out_h5m)

    print(f"\n✅ Packed: {out_h5m}")
    print("You can now open it in the MMH5.5 Editor or the game (Single Missions).")
    print("Tip (README): keep Instant Travel disabled if it was disabled in the original mission.  ")  # :contentReference[oaicite:5]{index=5}

def unpack(repo_root: Path) -> None:
    local_dir = repo_root / "LOCAL_DIR"
    compiled_dir = local_dir / "COMPILED_MAPS"
    ensure_dir(compiled_dir)

    h5ms = sorted([p for p in compiled_dir.glob("*.h5m") if p.is_file()])
    if not h5ms:
        raise SystemExit(f"No .h5m files found in {compiled_dir}")

    names = [p.name for p in h5ms]
    idx = prompt_choice(names, "Select a .h5m to UNPACK (opposing action):")
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
        if meta_path.exists():
            try:
                meta = json.loads(read_text(meta_path))
                mission_folder = meta.get("mission_folder")
                orig_xdb_name = meta.get("original_main_xdb")
            except Exception:
                pass

        # Fallbacks if meta missing
        if not mission_folder:
            mission_folder = dev_folder_name.replace("DEV_", "", 1)
        if not orig_xdb_name:
            # In compiled map, map-tag.xdb points to map.xdb; we restore using mission_folder.xdb
            orig_xdb_name = f"{mission_folder}.xdb"

        # Destination to drop the extracted, reverted content
        extracted_root = compiled_dir / "extracted" / dev_folder_name
        ensure_dir(extracted_root)

        # Copy the SingleMissions/<DEV_...> content
        # We keep the original internal folder structure for clarity:
        # extracted/<DEV_...>/  (contains the mission files)
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

        # Remove metadata from extracted copy to match repo sources layout
        try:
            (extracted_root / META_FILENAME).unlink(missing_ok=True)
        except TypeError:
            # Python < 3.8 compatibility
            meta_f = extracted_root / META_FILENAME
            if meta_f.exists():
                meta_f.unlink()

    print(f"✅ Unpacked into: {compiled_dir / 'extracted' / dev_folder_name}")
    print("The extracted folder has the original XDB name restored and map-tag.xdb updated.")
    print("If you want to move it back into sources, copy its contents into:")
    print("  UserMODs/MMH55-Cam-Maps/Maps/Scenario/<Mission>/")
    print("(Do this manually to avoid accidental overwrites.)")

# ---------- Entrypoint ----------
def main(argv: list[str]) -> None:
    # Find repo root relative to this script location
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
