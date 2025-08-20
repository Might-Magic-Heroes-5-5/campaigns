#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
h55_map_packer.py  — MMH5.5 Campaigns helper (CLI)

Actions (interactive menu if none given):
  1) Pack: Scenario/<Mission> -> LOCAL_DIR/COMPILED_MAPS/DEV_<Mission>.h5m
     - During Pack, you may optionally include selected or ALL campaign scripts from:
       ./UserMODs/MMH55-Cam-Maps/scripts/*
       (numeric UI; shows Created/Modified date per file; bulk confirm; conflict policy)
  2) Unpack: LOCAL_DIR/COMPILED_MAPS/*.h5m -> restore into sources (with backup)
  3) Quit

Key rules from repo:
- Template 'DEV_C1M1.h5m' must be at repo root.  :contentReference[oaicite:4]{index=4}
- Mission sources: UserMODs/MMH55-Cam-Maps/Maps/Scenario/<MissionFolder>/  :contentReference[oaicite:5]{index=5}
- map-tag.xdb inside the packed map must be exactly:
    <AdvMapDesc href="map.xdb#xpointer(/AdvMapDesc)"/>  :contentReference[oaicite:6]{index=6}
- Optional: set Player 2 ActivePlayer=true to enable single-player start; and revert on unpack.  :contentReference[oaicite:7]{index=7}
"""

from __future__ import annotations
import sys
import os
import json
import shutil
import zipfile
import tempfile
import datetime as _dt
from pathlib import Path
from typing import Optional, Tuple, List

import xml.etree.ElementTree as ET

# ---------- Constants ----------
META_FILENAME = ".campaigns_pack_meta.json"
MAP_TAG_XML_FOR_MAP_XDB = '<AdvMapDesc href="map.xdb#xpointer(/AdvMapDesc)"/>'
SINGLE_MISSIONS_REL = Path("Maps") / "SingleMissions"

# ---------- Paths helper ----------
class Paths:
    def __init__(self, script_path: Path):
        self.repo_root = self._find_repo_root(script_path)
        self.template_h5m = self.repo_root / "DEV_C1M1.h5m"
        self.missions_root = self.repo_root / "UserMODs" / "MMH55-Cam-Maps" / "Maps" / "Scenario"
        self.campaign_scripts_dir = self.repo_root / "UserMODs" / "MMH55-Cam-Maps" / "scripts"
        self.local_dir = self.repo_root / "LOCAL_DIR"
        self.compiled_dir = self.local_dir / "COMPILED_MAPS"
        self.extracted_dir = self.compiled_dir / "extracted"
        self.backups_dir = self.compiled_dir / "backups"

    @staticmethod
    def _find_repo_root(start: Path) -> Path:
        cur = start
        for parent in [cur] + list(cur.parents):
            if (parent / "README.md").exists() and (parent / "UserMODs").exists():
                return parent
        # Fallback to scripts/../../ if not found
        return start.parent.parent

def ensure_dir(p: Path) -> None:
    p.mkdir(parents=True, exist_ok=True)

# ---------- Console helpers ----------
def prompt_choice(options: List[str], title: str) -> int:
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

# ---------- File I/O helpers ----------
def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")

def write_text(path: Path, text: str) -> None:
    path.write_text(text, encoding="utf-8", newline="\n")

def safe_rename(src: Path, dst: Path) -> None:
    if src.resolve() == dst.resolve():
        return
    if dst.exists():
        dst.unlink()
    src.rename(dst)

def zip_dir_to_file(src_dir: Path, out_file: Path) -> None:
    with zipfile.ZipFile(out_file, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for root, _, files in os.walk(src_dir):
            root_path = Path(root)
            for fname in files:
                abs_f = root_path / fname
                arc = abs_f.relative_to(src_dir)
                zf.write(abs_f, arcname=str(arc))

def _is_within(base: Path, target: Path) -> bool:
    try:
        target.resolve().relative_to(base.resolve())
        return True
    except Exception:
        return False

def safe_unzip_to_dir(zip_file: Path, dst_dir: Path) -> None:
    """Prevent Zip Slip by validating members before extraction."""
    with zipfile.ZipFile(zip_file, "r") as zf:
        for info in zf.infolist():
            member = Path(info.filename)
            if member.is_absolute() or ".." in member.parts:
                raise SystemExit(f"Unsafe path in archive: {info.filename}")
            target = dst_dir / member
            if not _is_within(dst_dir, target):
                raise SystemExit(f"Refusing to extract outside target: {info.filename}")
            ensure_dir(target.parent)
            if info.is_dir():
                ensure_dir(target)
                continue
            with zf.open(info) as src, open(target, "wb") as dst:
                shutil.copyfileobj(src, dst)

# ---------- Map/XDB helpers ----------
def _find_first_by_suffix(root: ET.Element, name_suffix: str) -> Optional[ET.Element]:
    for e in root.iter():
        if isinstance(e.tag, str) and e.tag.endswith(name_suffix):
            return e
    return None

def _iter_children_by_suffix(parent: ET.Element, name_suffix: str):
    for c in list(parent):
        if isinstance(c.tag, str) and c.tag.endswith(name_suffix):
            yield c

def parse_map_tag_href_xml(map_tag_path: Path) -> Optional[str]:
    """Return 'href' basename from map-tag.xdb using real XML parsing."""
    try:
        root = ET.fromstring(read_text(map_tag_path))
    except Exception:
        return None
    href = root.attrib.get("href")
    if not href:
        return None
    return Path(href.split("#", 1)[0]).name

def detect_main_xdb(folder: Path, orig_guess: str) -> Path:
    # 1) exact guess
    guess = folder / orig_guess
    if guess.exists():
        return guess
    # 2) via map-tag.xdb
    mt = folder / "map-tag.xdb"
    via_tag = parse_map_tag_href_xml(mt)
    if via_tag and (folder / via_tag).exists():
        return folder / via_tag
    # 3) pick an .xdb whose root tag endswith 'AdvMapDesc'
    candidates = []
    for f in folder.glob("*.xdb"):
        try:
            rt = ET.parse(f).getroot()
        except Exception:
            continue
        if isinstance(rt.tag, str) and rt.tag.endswith("AdvMapDesc"):
            candidates.append((f.stat().st_size, f))
    if candidates:
        candidates.sort()
        return candidates[-1][1]
    # 4) fallback largest .xdb
    xdbs = list(folder.glob("*.xdb"))
    if not xdbs:
        raise SystemExit("No .xdb files found to select as main map.")
    return max(xdbs, key=lambda p: p.stat().st_size)

def write_map_tag_for_target(map_tag_path: Path, xdb_name: str) -> None:
    if xdb_name == "map.xdb":
        xml = MAP_TAG_XML_FOR_MAP_XDB  # exact per README
    else:
        xml = f'<AdvMapDesc href="{xdb_name}#xpointer(/AdvMapDesc)"/>'
    write_text(map_tag_path, xml)

def set_player2_active(map_xdb_path: Path, make_active: bool) -> Tuple[bool, Optional[bool]]:
    """
    Toggle Player 2 (<players>/<Item>[index 1]) <ActivePlayer>.
    Returns (success, previous_value or None if unknown).
    """
    try:
        tree = ET.parse(map_xdb_path)
        root = tree.getroot()
    except Exception:
        return (False, None)
    players = _find_first_by_suffix(root, "players")
    if players is None:
        return (False, None)
    items = list(_iter_children_by_suffix(players, "Item"))
    if len(items) < 2:
        return (False, None)
    p2 = items[1]
    ap = p2.find("./ActivePlayer")
    if ap is None:
        ap = ET.SubElement(p2, "ActivePlayer")
    prev = None
    if ap.text is not None:
        prev = ap.text.strip().lower() == "true"
    ap.text = "true" if make_active else "false"
    try:
        tree.write(map_xdb_path, encoding="utf-8", xml_declaration=False)
        return (True, prev)
    except Exception:
        return (False, prev)

# ---------- Discovery helpers ----------
def detect_singlemissions_folder(root_dir: Path) -> Path:
    """ robust: single folder -> use; multiple -> prefer DEV_*; else ask user """
    sm_dir = root_dir / SINGLE_MISSIONS_REL
    if not sm_dir.exists():
        raise RuntimeError(f"Missing {SINGLE_MISSIONS_REL} in unpacked structure.")
    subdirs = sorted([d for d in sm_dir.iterdir() if d.is_dir()], key=lambda p: p.name)
    if not subdirs:
        raise RuntimeError(f"No folders found inside {SINGLE_MISSIONS_REL}.")
    if len(subdirs) == 1:
        return subdirs[0]
    devs = [d for d in subdirs if d.name.startswith("DEV_")]
    if len(devs) == 1:
        return devs[0]
    # ask user
    idx = prompt_choice([d.name for d in subdirs], f"Multiple folders in {SINGLE_MISSIONS_REL}. Pick one:")
    return subdirs[idx]

def list_mission_dirs(missions_root: Path) -> List[Path]:
    if not missions_root.exists():
        return []
    return sorted([d for d in missions_root.iterdir() if d.is_dir()])

# ---------- Cross‑platform time formatting ----------
def format_file_time(p: Path) -> Tuple[str, str]:
    """
    Returns (label, formatted_time).
    - On Windows: ("Created", localtime of st_ctime)
    - On platforms with birth time (e.g., macOS/BSD): ("Created", st_birthtime)
    - Otherwise (e.g., most Linux): ("Modified", st_mtime)
    """
    st = p.stat()
    if os.name == "nt":
        ts = st.st_ctime
        label = "Created"
    else:
        birth = getattr(st, "st_birthtime", None)
        if birth is not None:
            ts = birth
            label = "Created"
        else:
            ts = st.st_mtime
            label = "Modified"
    return label, _dt.datetime.fromtimestamp(ts).strftime("%Y-%m-%d %H:%M:%S")

# ---------- Interactive inclusion of campaign scripts ----------
def include_campaign_scripts_interactive(P: Paths, map_folder: Path) -> None:
    """
    Offer to include scripts from P.campaign_scripts_dir into map_folder/scripts/.
    Numeric UI; two modes: per-file or ALL.
    Safe conflict handling (global policy or per-file).
    """
    src_dir = P.campaign_scripts_dir
    if not src_dir.exists():
        return

    files = sorted([p for p in src_dir.iterdir() if p.is_file()])
    if not files:
        return

    choice = prompt_choice(
        ["Yes, include campaign scripts (choose individually)",
         "Yes, include ALL campaign scripts",
         "No, skip"],
        f"Would you like to include campaign scripts from:\n  {src_dir}"
    )
    if choice == 2:
        return

    # Overview list with dates before any inclusion
    print("\nAvailable campaign scripts:")
    for i, f in enumerate(files, 1):
        label, tstr = format_file_time(f)
        print(f"  {i}. {f.name} — {label}: {tstr}")

    dest_dir = map_folder / "scripts"
    ensure_dir(dest_dir)

    if choice == 1:
        # -------- Include ALL --------
        confirm = prompt_choice(
            ["Yes, include ALL listed scripts", "No, cancel"],
            "Include ALL listed scripts?"
        )
        if confirm == 1:
            print("Cancelled including ALL scripts.")
            return

        # Detect conflicts
        conflicts = [f for f in files if (dest_dir / f.name).exists()]
        policy = "ask"
        if conflicts:
            pol_idx = prompt_choice(
                ["Overwrite ALL conflicting files",
                 "Skip ALL conflicting files",
                 "Ask per conflicting file"],
                f"There are {len(conflicts)} conflicting destination files.\nChoose conflict resolution policy:"
            )
            policy = ["overwrite_all", "skip_all", "ask"][pol_idx]

        included = 0
        for f in files:
            dst = dest_dir / f.name
            if dst.exists():
                if policy == "skip_all":
                    continue
                if policy == "ask":
                    how = prompt_choice(
                        ["Overwrite this file", "Skip this file", "Abort the scripts inclusion step"],
                        f"Conflict: destination file already exists:\n  {dst}\nSelect resolution:"
                    )
                    if how == 1:  # Skip
                        continue
                    if how == 2:  # Abort
                        print("Aborted campaign scripts inclusion by user request.")
                        break
                    # how == 0 -> overwrite
                # overwrite_all -> proceed
            shutil.copy2(f, dst)
            included += 1
            print(f" - Included: {dst}")
        print(f"\nCampaign scripts inclusion complete. Files included: {included}")
        return

    # -------- Per-file interactive inclusion --------
    included = 0
    for f in files:
        label, tstr = format_file_time(f)
        act = prompt_choice(
            ["Include this file", "Skip this file", "Quit (stop including scripts)"],
            f"\nScript: {f.name}\n{label}: {tstr}\nInclude?"
        )
        if act == 1:
            continue
        if act == 2:
            break

        dst = dest_dir / f.name
        if dst.exists():
            how = prompt_choice(
                ["Overwrite existing destination file",
                 "Skip this file",
                 "Abort the scripts inclusion step"],
                f"Conflict: destination file already exists:\n  {dst}\nSelect resolution:"
            )
            if how == 1:
                continue
            if how == 2:
                print("Aborted campaign scripts inclusion by user request.")
                break
            # how == 0 -> overwrite
        shutil.copy2(f, dst)
        included += 1
        print(f" - Included: {dst}")

    print(f"\nCampaign scripts inclusion complete. Files included: {included}")

# ---------- Core actions ----------
def verify_environment(P: Paths) -> None:
    missing = []
    if not P.template_h5m.exists():
        missing.append(str(P.template_h5m))
    if not P.missions_root.exists():
        missing.append(str(P.missions_root))
    ensure_dir(P.compiled_dir)

    print("🔎 Verifying environment ...")
    if missing:
        print("❌ Environment problems:")
        for m in missing:
            print(" - Missing:", m)
        # Also show scripts directory status even if missing critical paths
        if P.campaign_scripts_dir.exists():
            _print_scripts_inventory(P.campaign_scripts_dir)
        else:
            print(" - Optional campaign scripts: (none found)")
        sys.exit(1)

    print("✅ Environment OK")
    print(f" - Template: {P.template_h5m}")
    print(f" - Missions: {P.missions_root}")
    print(f" - Compiled output: {P.compiled_dir}")
    if P.campaign_scripts_dir.exists():
        _print_scripts_inventory(P.campaign_scripts_dir)
    else:
        print(" - Optional campaign scripts: (none found)")

def _print_scripts_inventory(scripts_dir: Path) -> None:
    files = sorted([p for p in scripts_dir.iterdir() if p.is_file()])
    print(f" - Optional campaign scripts: {scripts_dir}")
    if not files:
        print("   (directory exists but contains no files)")
        return
    print(f"   {len(files)} file(s):")
    for f in files:
        label, tstr = format_file_time(f)
        size = f.stat().st_size
        print(f"   - {f.name} — {label}: {tstr} — {size} B")

def pack(P: Paths) -> None:
    # Environment already verified at startup; ensure output dir still exists
    ensure_dir(P.compiled_dir)

    mission_dirs = list_mission_dirs(P.missions_root)
    if not mission_dirs:
        raise SystemExit(f"No missions found in {P.missions_root}")

    names = [d.name for d in mission_dirs]
    idx = prompt_choice(names, "Select a mission to PACK into a single-player .h5m:")
    mission_name = names[idx]
    mission_src = mission_dirs[idx]
    internal_dev_id = f"DEV_{mission_name}"

    map_tag_src = mission_src / "map-tag.xdb"
    orig_xdb_guess = parse_map_tag_href_xml(map_tag_src) or f"{mission_name}.xdb"

    print(f"\nPacking mission: {mission_name}")
    print(f"- Original main XDB (from sources): {orig_xdb_guess}")
    print(f"- Internal folder in .h5m: {internal_dev_id}")

    with tempfile.TemporaryDirectory(prefix="h55_pack_") as tmpdir:
        tmpdir = Path(tmpdir)

        # 1) Unzip template
        safe_unzip_to_dir(P.template_h5m, tmpdir)

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

        # 4) Copy mission files from sources
        for item in mission_src.iterdir():
            dst = new_singles_folder / item.name
            if item.is_dir():
                shutil.copytree(item, dst, dirs_exist_ok=True)
            else:
                shutil.copy2(item, dst)

        # 4b) Offer to include campaign scripts into DEV_<Mission>/scripts
        include_campaign_scripts_interactive(P, new_singles_folder)

        # 5) Rename main XDB -> map.xdb; set map-tag.xdb exactly
        src_main_xdb = detect_main_xdb(new_singles_folder, orig_xdb_guess)
        dst_main_xdb = new_singles_folder / "map.xdb"
        safe_rename(src_main_xdb, dst_main_xdb)
        write_map_tag_for_target(new_singles_folder / "map-tag.xdb", "map.xdb")  # exact per README

        # 6) Optional single-player flip
        flip_applied = False
        player2_prev = None
        if yes_no("Activate Player 2 in map.xdb for single-player start?", default=True):
            ok, prev = set_player2_active(dst_main_xdb, True)
            flip_applied, player2_prev = ok, prev
            print(" - Player 2 set to ActivePlayer=true." if ok else " - Could not edit map.xdb automatically; continuing without flip.")

        # 7) Embed metadata for round-trip
        meta = {
            "mission_folder": mission_name,
            "original_main_xdb": orig_xdb_guess,
            "internal_dev_id": internal_dev_id,
            "player2_flip_applied": flip_applied,
            "player2_active_original": player2_prev,
        }
        write_text(new_singles_folder / META_FILENAME, json.dumps(meta, indent=2))

        # 8) Produce .h5m
        out_h5m = P.compiled_dir / f"{internal_dev_id}.h5m"
        if out_h5m.exists():
            if not yes_no(f"Target file already exists:\n  {out_h5m}\nOverwrite?", default=False):
                print("Aborted by user. Nothing written.")
                return
            out_h5m.unlink()
        # zip the WHOLE unpacked tree (template structure included)
        zip_dir_to_file(tmpdir, out_h5m)

    print(f"\n✅ Packed: {out_h5m}")
    print("Reminder: keep Instant Travel blocked if it was blocked in the mission.")

def _timestamp() -> str:
    return _dt.datetime.now().strftime("%Y%m%d-%H%M%S")

def _zip_folder(folder: Path, out_zip: Path) -> None:
    with zipfile.ZipFile(out_zip, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for root, _, files in os.walk(folder):
            rp = Path(root)
            for f in files:
                p = rp / f
                zf.write(p, arcname=str(p.relative_to(folder)))

def unpack(P: Paths) -> None:
    # Environment already verified at startup; ensure output dir still exists
    ensure_dir(P.compiled_dir)

    h5ms = sorted([p for p in P.compiled_dir.glob("*.h5m") if p.is_file()])
    if not h5ms:
        raise SystemExit(f"No .h5m files found in {P.compiled_dir}")

    names = [p.name for p in h5ms]
    idx = prompt_choice(names, "Select a .h5m to UNPACK and restore into sources:")
    chosen = h5ms[idx]

    print(f"\nUnpacking: {chosen}")
    with tempfile.TemporaryDirectory(prefix="h55_unpack_") as tmpdir:
        tmpdir = Path(tmpdir)
        safe_unzip_to_dir(chosen, tmpdir)

        singles_folder = detect_singlemissions_folder(tmpdir)
        dev_folder_name = singles_folder.name

        # Read metadata
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
            except Exception:
                pass

        if not mission_folder:
            mission_folder = dev_folder_name.replace("DEV_", "", 1)
        if not orig_xdb_name:
            orig_xdb_name = f"{mission_folder}.xdb"

        # Extraction target
        base_extracted = P.extracted_dir / dev_folder_name
        extracted_root = base_extracted
        if base_extracted.exists():
            if yes_no(f"Extraction folder exists:\n  {base_extracted}\nOverwrite its contents?", default=False):
                shutil.rmtree(base_extracted)
            else:
                extracted_root = P.extracted_dir / f"{dev_folder_name}-{_timestamp()}"
                print(f" - Using new extraction folder: {extracted_root}")
        shutil.copytree(singles_folder, extracted_root)

        # Revert map.xdb -> <orig_xdb_name>; fix map-tag.xdb
        map_xdb = extracted_root / "map.xdb"
        if map_xdb.exists():
            safe_rename(map_xdb, extracted_root / orig_xdb_name)
        write_map_tag_for_target(extracted_root / "map-tag.xdb", orig_xdb_name)

        # Roll back Player‑2 flip
        if p2_flip_applied:
            target_value = bool(p2_active_original) if p2_active_original is not None else False
            set_player2_active(extracted_root / orig_xdb_name, target_value)

        # Remove metadata from the restored copy
        (extracted_root / META_FILENAME).unlink(missing_ok=True) if hasattr(Path, "unlink") else None

        print(f" - Files prepared in: {extracted_root}")

        # Replace sources with prompt and backup
        missions_root = P.missions_root
        dest_folder = missions_root / mission_folder
        ensure_dir(missions_root)

        if dest_folder.exists():
            if not yes_no(
                f"Destination sources folder exists:\n  {dest_folder}\n"
                "Replace its contents? (A timestamped backup will be created first.)", default=False):
                print("Aborted by user. Sources were not modified.")
                return
            ensure_dir(P.backups_dir)
            bk_zip = P.backups_dir / f"{mission_folder}-{_timestamp()}.zip"
            print(f" - Backing up existing sources to: {bk_zip}")
            _zip_folder(dest_folder, bk_zip)
            shutil.rmtree(dest_folder)

        print(f" - Restoring into sources: {dest_folder}")
        shutil.copytree(extracted_root, dest_folder)

    print(f"\n✅ Unpacked and restored into sources: {dest_folder}")
    print(f"   Extraction at: {extracted_root}")
    print(f"   Backups (if any) are in: {P.backups_dir}")

# ---------- Menu / entrypoint ----------
def main(argv: List[str]) -> None:
    script_path = Path(__file__).resolve()
    P = Paths(script_path)

    # ALWAYS verify environment on startup (not a user option)
    verify_environment(P)

    # If user gave an explicit action, run it (no 'verify' command anymore)
    if len(argv) > 1:
        cmd = argv[1].lower()
        if cmd in {"-h", "--help", "help"}:
            print(__doc__)
            return
        if cmd == "pack":
            pack(P); return
        if cmd == "unpack":
            unpack(P); return
        print(f"Unknown command: {cmd}\nUse: pack | unpack")
        return

    # Otherwise, show a numeric action selector (no 'Verify environment' entry)
    choice = prompt_choice(
        ["Pack a mission to .h5m",
         "Unpack a .h5m and restore into sources",
         "Quit"], "Select action:")
    if choice == 0:
        pack(P)
    elif choice == 1:
        unpack(P)
    else:
        print("Bye.")

if __name__ == "__main__":
    main(sys.argv)
