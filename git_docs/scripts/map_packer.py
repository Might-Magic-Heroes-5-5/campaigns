#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
h55_map_packer.py  — MMH5.5 Campaigns helper (CLI)

Performance‑focused + UX update
-------------------------------
Default behavior is still QUIET + FAST, but with two important improvements:

A) Dynamic progress for the final archive build
   • While packing .h5m/.h5u, non‑verbose mode now shows a live percent and file counter.
   • Verbose mode continues to print per‑file lines.

B) Interactive, templated map‑tag auto‑fix (A2* .h5m‑style drops)
   • Before creating missing map‑tag.xdb files, we now:
       1) List the missions that are missing tags (e.g., A2C?M? with map.xdb present).
       2) Ask if you want to create tags from a template.
       3) Print the template content for review.
       4) Ask for final confirmation.
       5) Only then write map‑tag.xdb files (one per mission).
   • The template is read from a file placed next to this script:
         map-tag-template.xdb
     If that file is not present, we fall back to the canonical one‑liner:
         <AdvMapDesc href="map.xdb#xpointer(/AdvMapDesc)"/>
   • This aligns with repo guidance about doFile() paths resolving from archive ROOT.  (See README’s
     “Arcane Knowledge: How doFile() Paths Work”.)

Global flags (may be placed before or after the command):
  --verbose              Enable detailed per‑file progress logs (opt‑in)
  --quiet, --skip-logs   Force minimal logs (default behavior)
  --hash=fast|full       Fast: size+mtime only (default). Full: compute sha1.
  --full-hash            Shorthand for --hash=full
  --no-template-cache    Disable caching of the unzipped template
  --cache-dir PATH       Where to keep cache (default: LOCAL_DIR/CACHE)

Actions (interactive menu if none given):
  1) Pack a mission to single-player .h5m (DEV_<Mission>)
  2) Build campaign .h5u patch (single mission)
  3) Build WHOLE campaign .h5u patch (multi-mission)
  4) Compile full MMH55-Cam-Maps.h5u
  5) Apply back to sources (.h5m or .h5u)

Output rules:
- New .h5m → LOCAL_DIR/COMPILED_MAPS; .h5u → LOCAL_DIR/COMPILED_CAMPAIGNS
- Apply/Unpack searches these LOCAL_DIR/* folders

Reference / engine rule (README):
- Shared Lua scripts referenced as doFile("/scripts/...") resolve from the archive ROOT
  for both .h5u and .h5m. Place shared campaign scripts at ROOT /scripts in .h5u.
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
import hashlib
import time as _time
from pathlib import Path
from typing import Optional, Tuple, List, Dict, Iterable

import xml.etree.ElementTree as ET

# ---------- Global knobs (adjusted by CLI flags) ----------
VERBOSE: bool = False              # per-file logs
HASH_MODE: str = "fast"            # "fast" (size+mtime) or "full" (sha1)
USE_TEMPLATE_CACHE: bool = True    # cache unzipped template
CACHE_DIR_OVERRIDE: Optional[Path] = None

def vprint(*a, **k):  # verbose print
    if VERBOSE:
        print(*a, **k)

# ---------- Constants ----------
META_JSON = ".campaigns_pack_meta.json"          # kept for back-compat (.h5m older builds)
META_XML  = "h55_meta.xml"                       # metadata placed at archive ROOT (and per mission for .h5u)
MAP_TAG_XML_FOR_MAP_XDB = '<AdvMapDesc href="map.xdb#xpointer(/AdvMapDesc)"/>'
MAP_TAG_TEMPLATE_FILE = "map-tag-template.xdb"   # optional; placed next to this script

SINGLE_MISSIONS_REL = Path("Maps") / "SingleMissions"
MISSION_RE = re.compile(r'^(?:A(?P<A>\d+))?C(?P<C>\d+)M(?P<M>\d+)$')

# Tolerant href finder (accepts href="...xdb" with optional fragment)
_TAG_RE = re.compile(r'href\s*=\s*"([^"]+?\.xdb)(?:#[^"]*)?"', re.IGNORECASE)

# ---------- Paths helper ----------
class Paths:
    def __init__(self, script_path: Path):
        self.script_path = script_path
        self.script_dir = script_path.parent

        self.repo_root = self._find_repo_root(script_path)
        self.template_h5m = self.repo_root / "DEV_C1M1.h5m"
        self.missions_root = self.repo_root / "UserMODs" / "MMH55-Cam-Maps" / "Maps" / "Scenario"
        self.campaign_scripts_dir = self.repo_root / "UserMODs" / "MMH55-Cam-Maps" / "scripts"
        self.user_mods_root = self.repo_root / "UserMODs"  # repo-local UserMODs root
        self.cam_maps_root = self.user_mods_root / "MMH55-Cam-Maps"
        self.local_dir = self.repo_root / "LOCAL_DIR"
        self.compiled_dir = self.local_dir / "COMPILED_MAPS"                 # .h5m output
        self.compiled_campaigns_dir = self.local_dir / "COMPILED_CAMPAIGNS"  # .h5u output
        self.extracted_dir = self.local_dir / "EXTRACTED"
        self.backups_dir = self.local_dir / "BACKUPS"
        self.cache_dir = (CACHE_DIR_OVERRIDE or (self.local_dir / "CACHE"))

        # Optional, side-by-side with the script
        self.map_tag_template_path = self.script_dir / MAP_TAG_TEMPLATE_FILE

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
        try:
            raw = input("Enter number: ").strip()
        except (EOFError, KeyboardInterrupt):
            print("\nAborted by user.")
            raise SystemExit(1)
        if raw.isdigit():
            idx = int(raw)
            if 1 <= idx <= len(options):
                return idx - 1
        print("Invalid choice. Try again.")

def yes_no(question: str, default: bool = False) -> bool:
    suffix = " [Y/n]: " if default else " [y/N]: "
    try:
        ans = input(question + suffix).strip().lower()
    except (EOFError, KeyboardInterrupt):
        print("\nAborted by user.")
        raise SystemExit(1)
    if ans == "" and default:
        return True
    return ans in ("y", "yes")

# ---------- File I/O helpers ----------
def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")

def write_text(path: Path, text: str) -> None:
    path.write_text(text, encoding="utf-8", newline="\n")

def file_sha1(p: Path) -> str:
    h = hashlib.sha1()
    with open(p, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()

def safe_rename(src: Path, dst: Path) -> None:
    if src.resolve() == dst.resolve():
        return
    if dst.exists():
        dst.unlink()
    src.rename(dst)

def _is_within(base: Path, target: Path) -> bool:
    try:
        target.resolve().relative_to(base.resolve())
        return True
    except Exception:
        return False

def safe_unzip_to_dir(zip_file: Path, dst_dir: Path) -> None:
    """Prevent Zip Slip by validating members before extraction."""
    with zipfile.ZipFile(zip_file, "r") as zf:
        infos = zf.infolist()
        total = len(infos)
        print(f"Extracting {zip_file} -> {dst_dir} ({total} item(s))")
        for i, info in enumerate(infos, 1):
            member = Path(info.filename)
            if member.is_absolute() or ".." in member.parts:
                raise SystemExit(f"[UNZIP SAFETY] Unsafe path in archive: {info.filename}")
            target = dst_dir / member
            if not _is_within(dst_dir, target):
                raise SystemExit(f"[UNZIP SAFETY] Refusing to extract outside target: {info.filename}")
            ensure_dir(target.parent)
            if info.is_dir():
                ensure_dir(target)
            else:
                with zf.open(info) as src, open(target, "wb") as dst:
                    shutil.copyfileobj(src, dst)
            if VERBOSE:
                print(f"  [{i}/{total}] {member}")

# ---------- Signatures (fast vs full) ----------
def _stat_sig(p: Path) -> Tuple[int, int]:
    """Return (size, mtime_sec) for fast comparisons."""
    st = p.stat()
    return (int(st.st_size), int(st.st_mtime))

def _signatures_equal_fast(a: Path, b: Path) -> bool:
    try:
        sa, ma = _stat_sig(a)
        sb, mb = _stat_sig(b)
        return sa == sb and ma == mb
    except FileNotFoundError:
        return False

# ---------- Progress & zipping helpers ----------
def list_files_under(base: Path, sort_files: bool = False) -> List[Path]:
    """Return list of all files under base. Unsorted by default for speed."""
    files: List[Path] = []
    for root, _, fs in os.walk(base):
        rp = Path(root)
        for f in fs:
            files.append(rp / f)
    if sort_files:
        files.sort(key=lambda p: str(p.relative_to(base)).lower())
    return files

def copy_tree_quiet(src: Path, dst: Path) -> int:
    """Fast copy tree without per-file prints. Returns files copied."""
    total = 0
    for root, dirs, files in os.walk(src):
        r = Path(root)
        rel_root = r.relative_to(src)
        target_root = dst / rel_root
        ensure_dir(target_root)
        for d in dirs:
            ensure_dir(target_root / d)
        for f in files:
            shutil.copy2(r / f, target_root / f)
            total += 1
    return total

def copy_tree_with_progress(src: Path, dst: Path, label: str) -> int:
    """Copy src tree to dst; verbose prints per file, quiet prints only summary."""
    if VERBOSE:
        files = list_files_under(src, sort_files=True)
        total = len(files)
        if total == 0:
            ensure_dir(dst)
            print(f"{label}: nothing to copy (0 files).")
            return 0
        print(f"{label}: copying {total} file(s) from\n  {src}\n  -> {dst}")
        for i, sp in enumerate(files, 1):
            rel = sp.relative_to(src)
            dp = dst / rel
            ensure_dir(dp.parent)
            shutil.copy2(sp, dp)
            print(f"  [{i}/{total}] {rel}")
        return total
    else:
        ensure_dir(dst)
        total = copy_tree_quiet(src, dst)
        print(f"{label}: copied {total} file(s).")
        return total

def zip_dir_to_file_progress(src_dir: Path, out_file: Path, label: str = "Zipping") -> None:
    """
    Create zip with dynamic progress in quiet mode and per-file in verbose mode.
    """
    files = list_files_under(src_dir, sort_files=VERBOSE)  # stable order only when verbose
    total = len(files)
    print(f"{label}: {total} file(s) -> {out_file}")
    with zipfile.ZipFile(out_file, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        if VERBOSE:
            for i, abs_f in enumerate(files, 1):
                arc = abs_f.relative_to(src_dir)
                zf.write(abs_f, arcname=str(arc))
                print(f"  [{i}/{total}] {arc}")
        else:
            if total == 0:
                return
            # Update roughly every 1% (at least every 1 file)
            step = max(1, total // 100)
            next_update = step
            t0 = _time.time()
            # Initial line
            sys.stdout.write(f"  0% (0/{total})\r"); sys.stdout.flush()
            for i, abs_f in enumerate(files, 1):
                arc = abs_f.relative_to(src_dir)
                zf.write(abs_f, arcname=str(arc))
                if i >= next_update or i == total:
                    pct = int(i * 100 / total)
                    elapsed = max(0.001, _time.time() - t0)
                    rate = i / elapsed
                    sys.stdout.write(f"  {pct:3d}% ({i}/{total}) {rate:,.0f}/s\r")
                    sys.stdout.flush()
                    next_update += step
            # Finish line
            sys.stdout.write(f"  100% ({total}/{total}) Done.{' ' * 20}\n")
            sys.stdout.flush()

# Backward-compat alias (if any old code calls this)
def zip_dir_to_file(src_dir: Path, out_file: Path) -> None:
    zip_dir_to_file_progress(src_dir, out_file, label="Zipping")

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

def _preview(text: str, limit: int = 400) -> str:
    t = text.replace("\r", " ").replace("\n", " ")
    t = re.sub(r"\s+", " ", t)
    return t.strip()[:limit]

def parse_map_tag_href(map_tag_path: Path) -> Tuple[Optional[str], Optional[str]]:
    """
    Returns (href_basename, error_message).
    Accepts both forms:
      • <AdvMapDesc href="C6M3.xdb#xpointer(/AdvMapDesc)"/>
      • <AdvMapDescTag> ... <AdvMapDesc href="C6M3.xdb#xpointer(/AdvMapDesc)"/> ... </AdvMapDescTag>
    On failure returns (None, descriptive_error_message_with_path_and_preview)
    """
    try:
        raw = read_text(map_tag_path)
    except Exception as e:
        return (None, f"{map_tag_path}: cannot read file: {e}")

    # Try XML parse
    try:
        root = ET.fromstring(raw)
        href = None
        # 1) direct self element
        if isinstance(root.tag, str) and root.tag.endswith("AdvMapDesc") and "href" in root.attrib:
            href = root.attrib.get("href")
        else:
            # 2) nested under any parent, seek first element with tag ...AdvMapDesc and @href
            for e in root.iter():
                if isinstance(e.tag, str) and e.tag.endswith("AdvMapDesc") and "href" in e.attrib:
                    href = e.attrib.get("href"); break
        if href:
            return (Path(href.split("#", 1)[0]).name, None)
        # fallback: tolerant regex
        m = _TAG_RE.search(raw)
        if m:
            return (Path(m.group(1)).name, None)
        return (None,
                f"{map_tag_path}: parsed XML (root=<{root.tag}>), but could not locate AdvMapDesc/@href. "
                f"Preview: { _preview(raw) }")
    except Exception as xml_err:
        # Tolerant regex fallback (handles junk before/after element)
        m = _TAG_RE.search(raw)
        if m:
            return (Path(m.group(1)).name, None)
        return (None,
                f"{map_tag_path}: XML parse error: {xml_err}. Preview: { _preview(raw) }")

def detect_main_xdb(folder: Path, orig_guess: str) -> Path:
    # 1) exact guess
    guess = folder / orig_guess
    if guess.exists():
        return guess
    # 2) via map-tag.xdb
    mt = folder / "map-tag.xdb"
    href, _ = parse_map_tag_href(mt) if mt.exists() else (None, None)
    if href and (folder / href).exists():
        return folder / href
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
    # 4) largest .xdb
    xdbs = list(folder.glob("*.xdb"))
    if not xdbs:
        raise SystemExit("No .xdb files found to select as main map.")
    return max(xdbs, key=lambda p: p.stat().st_size)

def write_map_tag_for_target(map_tag_path: Path, xdb_name: str, template_text: Optional[str] = None) -> None:
    """
    Write a minimal map-tag.xdb pointing to xdb_name.
    If template_text is provided, it can optionally contain placeholders:
      ${HREF} or {{HREF}} — replaced with xdb_name
    Otherwise a default one-liner is used (for map.xdb) or constructed.
    """
    if template_text is not None:
        t = template_text.replace("${HREF}", xdb_name).replace("{{HREF}}", xdb_name).strip()
        write_text(map_tag_path, t + "\n")
        return

    if xdb_name == "map.xdb":
        xml = MAP_TAG_XML_FOR_MAP_XDB  # exact for .h5m single-map template
    else:
        xml = f'<AdvMapDesc href="{xdb_name}#xpointer(/AdvMapDesc)"/>'
    write_text(map_tag_path, xml + "\n")

def get_player2_active(map_xdb_path: Path) -> Optional[bool]:
    try:
        tree = ET.parse(map_xdb_path)
        root = tree.getroot()
    except Exception:
        return None
    players = _find_first_by_suffix(root, "players")
    if players is None:
        return None
    items = list(_iter_children_by_suffix(players, "Item"))
    if len(items) < 2:
        return None
    ap = items[1].find("./ActivePlayer")
    if ap is None or ap.text is None:
        return None
    return ap.text.strip().lower() == "true"

def set_player2_active(map_xdb_path: Path, make_active: bool) -> Tuple[bool, Optional[bool]]:
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
    idx = prompt_choice([d.name for d in subdirs], f"Multiple folders in {SINGLE_MISSIONS_REL}. Pick one:")
    return subdirs[idx]

def list_mission_dirs(missions_root: Path) -> List[Path]:
    if not missions_root.exists():
        return []
    # Few entries; keep sorted for nicer menus
    return sorted([d for d in missions_root.iterdir() if d.is_dir()])

# ---------- Time / conflict helpers ----------
def format_file_time(p: Path) -> Tuple[str, str]:
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

def _file_time_str(p: Path) -> str:
    try:
        return _dt.datetime.fromtimestamp(p.stat().st_mtime).strftime("%Y-%m-%d %H:%M:%S")
    except Exception:
        return "n/a"

def _conflict_stats(src_files: List[Path], dest_dir: Path) -> Tuple[List[Dict], List[Dict]]:
    """Return (identical, different) conflict entries for files that already exist at dest."""
    identical: List[Dict] = []
    different: List[Dict] = []
    for f in src_files:
        dst = dest_dir / f.name
        if not dst.exists():
            continue
        try:
            if HASH_MODE == "full":
                s_sha, d_sha = file_sha1(f), file_sha1(dst)
                s_size, d_size = f.stat().st_size, dst.stat().st_size
                s_time, d_time = _file_time_str(f), _file_time_str(dst)
                entry = {"name": f.name, "src": str(f), "dst": str(dst),
                         "s_sha": s_sha, "d_sha": d_sha,
                         "s_time": s_time, "d_time": d_time,
                         "s_size": s_size, "d_size": d_size}
                if s_sha == d_sha:
                    identical.append(entry)
                else:
                    different.append(entry)
            else:
                # FAST: size+mtime only
                s_size, d_size = f.stat().st_size, dst.stat().st_size
                s_time, d_time = _file_time_str(f), _file_time_str(dst)
                entry = {"name": f.name, "src": str(f), "dst": str(dst),
                         "s_sha": "n/a", "d_sha": "n/a",
                         "s_time": s_time, "d_time": d_time,
                         "s_size": s_size, "d_size": d_size}
                if _signatures_equal_fast(f, dst):
                    identical.append(entry)
                else:
                    different.append(entry)
        except Exception:
            different.append({"name": f.name, "src": str(f), "dst": str(dst),
                              "s_sha": "n/a", "d_sha": "n/a",
                              "s_time": "n/a", "d_time": "n/a",
                              "s_size": -1, "d_size": -1})
    return identical, different

def _print_conflicts(identical: List[Dict], different: List[Dict], dest_dir: Path) -> None:
    if not (identical or different):
        return
    print(f"\nConflicting files in destination:\n  {dest_dir.resolve()}")
    idx = 1
    for r in different:
        print(f"  {idx}. {r['name']}  [DIFFERENT]")
        print(f"     src: {r['src']} ({r['s_size']} B, {r['s_time']}) sha1={r['s_sha']}")
        print(f"     dst: {r['dst']} ({r['d_size']} B, {r['d_time']}) sha1={r['d_sha']}")
        idx += 1
    for r in identical:
        print(f"  {idx}. {r['name']}  [IDENTICAL]")
        print(f"     src: {r['src']} ({r['s_size']} B, {r['s_time']}) sha1={r['s_sha']}")
        print(f"     dst: {r['dst']} ({r['d_size']} B, {r['d_time']}) sha1={r['d_sha']}")
        idx += 1

# ---------- Scripts inclusion for .h5m (INTO MAP FOLDER, no subfolder) ----------
def include_scripts_into_map_folder_interactive(P: Paths, map_folder: Path) -> List[str]:
    included_files: List[str] = []
    src_dir = P.campaign_scripts_dir
    if not src_dir.exists():
        return included_files
    files = sorted([p for p in src_dir.iterdir() if p.is_file()])
    if not files:
        return included_files

    choice = prompt_choice(
        ["Yes, include campaign scripts (choose individually)",
         "Yes, include ALL campaign scripts",
         "No, skip"],
        f"Would you like to include campaign scripts from:\n  {src_dir}\ninto MAP FOLDER:\n  {map_folder.resolve()}"
    )
    if choice == 2:
        return included_files

    print("\nAvailable campaign scripts:")
    for i, f in enumerate(files, 1):
        label, tstr = format_file_time(f)
        print(f"  {i}. {f.name} — {label}: {tstr}")

    dest_dir = map_folder
    ensure_dir(dest_dir)

    if choice == 1:
        confirm = prompt_choice(
            ["Yes, include ALL listed scripts", "No, cancel"],
            f"Include ALL listed scripts into MAP FOLDER:\n  {dest_dir.resolve()}"
        )
        if confirm == 1:
            print("Cancelled including ALL scripts.")
            return included_files

        # Conflict classification
        identical, different = _conflict_stats(files, dest_dir)
        if identical or different:
            _print_conflicts(identical, different, dest_dir)
        if different:
            pol_idx = prompt_choice(
                ["Overwrite ALL different files (identical will be skipped)",
                 "Skip ALL existing files",
                 "Ask per DIFFERENT file",
                 "Force overwrite EVERYTHING (including identical)"],
                f"There are {len(different)} different and {len(identical)} identical file(s) at destination.\nChoose conflict resolution policy:"
            )
            policy = ["overwrite_diff", "skip_all", "ask_diff", "overwrite_all"][pol_idx]
        else:
            # only identical or none -> skip them silently
            policy = "skip_all"

        for f in files:
            dst = dest_dir / f.name
            exists = dst.exists()
            if exists:
                # identical?
                same = False
                try:
                    if HASH_MODE == "full":
                        same = file_sha1(f) == file_sha1(dst)
                    else:
                        same = _signatures_equal_fast(f, dst)
                except Exception:
                    same = False
                if policy == "skip_all":
                    continue
                if policy == "overwrite_diff" and same:
                    # identical -> skip
                    continue
                if policy == "ask_diff" and same:
                    # identical -> skip asking
                    continue
                if policy == "ask_diff" and not same:
                    how = prompt_choice(
                        ["Overwrite this DIFFERENT file", "Skip this file", "Abort the scripts inclusion step"],
                        f"Conflict (DIFFERENT): destination file already exists:\n  {dst}\nSelect resolution:"
                    )
                    if how == 1:
                        continue
                    if how == 2:
                        print("Aborted campaign scripts inclusion by user request.")
                        break
            shutil.copy2(f, dst)
            included_files.append(f.name)
            vprint(f" - Included: {dst}")
        print(f"\nCampaign scripts inclusion complete. Files included: {len(included_files)}")
        return included_files

    # Per-file numeric confirm (kept)
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
            # classify single
            ident, diff = _conflict_stats([f], dest_dir)
            _print_conflicts(ident, diff, dest_dir)
            if ident and not diff:
                # identical -> skip silently
                print(" - Skipping (identical at destination).")
                continue
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
        shutil.copy2(f, dst)
        included_files.append(f.name)
        vprint(f" - Included: {dst}")
    print(f"\nCampaign scripts inclusion complete. Files included: {len(included_files)}")
    return included_files

# ---------- Scripts inclusion at ARCHIVE ROOT (/scripts) for .h5u ----------
def include_scripts_at_root_interactive(P: Paths, stage_root: Path) -> List[str]:
    """Include campaign scripts into stage_root / 'scripts' (archive root). Returns list of included filenames."""
    included_files: List[str] = []
    src_dir = P.campaign_scripts_dir
    if not src_dir.exists():
        return included_files
    files = sorted([p for p in src_dir.iterdir() if p.is_file()])
    if not files:
        return included_files

    dest_dir = stage_root / "scripts"
    ensure_dir(dest_dir)

    choice = prompt_choice(
        ["Include ALL campaign scripts into ROOT /scripts",
         "No, skip"],
        f"Campaign scripts directory:\n  {src_dir}\nDestination (ROOT /scripts):\n  {dest_dir.resolve()}"
    )
    if choice == 1:
        return included_files

    print("\nAvailable campaign scripts:")
    for i, f in enumerate(files, 1):
        label, tstr = format_file_time(f)
        print(f"  {i}. {f.name} — {label}: {tstr}")

    confirm = prompt_choice(
        ["Yes, include ALL listed scripts into ROOT /scripts", "No, cancel"],
        f"Confirm inclusion into ROOT /scripts at:\n  {dest_dir.resolve()}"
    )
    if confirm == 1:
        print("Cancelled ROOT /scripts inclusion.")
        return included_files

    # Conflict classification
    identical, different = _conflict_stats(files, dest_dir)
    if identical or different:
        _print_conflicts(identical, different, dest_dir)

    if different:
        pol_idx = prompt_choice(
            ["Overwrite ALL different files (identical will be skipped)",
             "Skip ALL existing files",
             "Ask per DIFFERENT file",
             "Force overwrite EVERYTHING (including identical)"],
            f"There are {len(different)} different and {len(identical)} identical file(s) in ROOT /scripts.\nChoose conflict resolution policy:"
        )
        policy = ["overwrite_diff", "skip_all", "ask_diff", "overwrite_all"][pol_idx]
    else:
        policy = "skip_all"  # only identical (or none)

    for f in files:
        dst = dest_dir / f.name
        exists = dst.exists()
        same = False
        if exists:
            try:
                if HASH_MODE == "full":
                    same = file_sha1(f) == file_sha1(dst)
                else:
                    same = _signatures_equal_fast(f, dst)
            except Exception:
                same = False
            if policy == "skip_all":
                continue
            if policy == "overwrite_diff" and same:
                continue
            if policy == "ask_diff" and same:
                continue
            if policy == "ask_diff" and not same:
                how = prompt_choice(
                    ["Overwrite this DIFFERENT file", "Skip this file", "Abort inclusion"],
                    f"Conflict (DIFFERENT): destination file already exists:\n  {dst}\nSelect resolution:"
                )
                if how == 1:
                    continue
                if how == 2:
                    print("Aborted ROOT /scripts inclusion by user request.")
                    print(f"Total files included before abort: {len(included_files)}")
                    return included_files
        shutil.copy2(f, dst)
        included_files.append(f.name)
        vprint(f" - Included (ROOT): {dst}")
    print(f"\nROOT /scripts inclusion complete. Files included: {len(included_files)}")
    return included_files

# ---------- h55_meta.xml helpers ----------
def _now_iso() -> str:
    return _dt.datetime.now().strftime("%Y-%m-%dT%H:%M:%S")

def write_meta_h5m(root_dir: Path, mission: str, orig_xdb: str,
                   internal_dev_id: str, flip_applied: bool,
                   p2_prev: Optional[bool], scripts: List[str]) -> None:
    meta = ET.Element("H55Meta", {"type": "h5m", "built_at": _now_iso()})
    ET.SubElement(meta, "SingleMap", {
        "mission": mission,
        "internal_dev_id": internal_dev_id,
        "original_main_xdb": orig_xdb,
        "player2_flip_applied": "true" if flip_applied else "false",
        "player2_active_original": "unknown" if p2_prev is None else ("true" if p2_prev else "false"),
    })
    if scripts:
        s = ET.SubElement(meta, "Scripts")
        for name in scripts:
            ET.SubElement(s, "File", {"name": name})
    ET.ElementTree(meta).write(root_dir / META_XML, encoding="utf-8", xml_declaration=True)

def write_meta_h5u_root(root_dir: Path, kind: str, missions: List[Dict[str, str]],
                        scripts: List[str]) -> None:
    meta = ET.Element("H55Meta", {"type": f"h5u-{kind}", "built_at": _now_iso()})
    ms = ET.SubElement(meta, "Missions")
    for m in missions:
        ET.SubElement(ms, "Mission", {
            "name": m["name"],
            "ref_xdb": m["ref_xdb"],
            "payload": m["payload"],
        })
    if scripts:
        s = ET.SubElement(meta, "Scripts")
        for name in scripts:
            ET.SubElement(s, "File", {"name": name})
    ET.ElementTree(meta).write(root_dir / META_XML, encoding="utf-8", xml_declaration=True)

def write_meta_h5u_mission(stage_mission_dir: Path, mission: str, ref_xdb: str, payload: str) -> None:
    meta = ET.Element("H55Meta", {"type": "mission", "built_at": _now_iso()})
    ET.SubElement(meta, "SingleMission", {"name": mission, "ref_xdb": ref_xdb, "payload": payload})
    ET.ElementTree(meta).write(stage_mission_dir / META_XML, encoding="utf-8", xml_declaration=True)

def read_meta_h5m(root_dir: Path) -> Dict[str, object]:
    """Read our XML; fall back to legacy JSON if present."""
    meta_xml = root_dir / META_XML
    if meta_xml.exists():
        try:
            root = ET.parse(meta_xml).getroot()
            sm = root.find("./SingleMap")
            if sm is not None:
                def _as_bool(s: str) -> Optional[bool]:
                    if s == "unknown": return None
                    return s.lower() == "true"
                return {
                    "mission_folder": sm.attrib.get("mission"),
                    "original_main_xdb": sm.attrib.get("original_main_xdb"),
                    "internal_dev_id": sm.attrib.get("internal_dev_id"),
                    "player2_flip_applied": sm.attrib.get("player2_flip_applied", "false").lower() == "true",
                    "player2_active_original": _as_bool(sm.attrib.get("player2_active_original", "unknown")),
                }
        except Exception:
            pass
    legacy = root_dir / META_JSON
    if legacy.exists():
        try:
            meta = json.loads(read_text(legacy))
            return {
                "mission_folder": meta.get("mission_folder"),
                "original_main_xdb": meta.get("original_main_xdb"),
                "internal_dev_id": meta.get("internal_dev_id"),
                "player2_flip_applied": bool(meta.get("player2_flip_applied", False)),
                "player2_active_original": meta.get("player2_active_original", None),
            }
        except Exception:
            pass
    return {}

# ---------- A2 auto-fix helpers ----------
def _ensure_map_tag_if_h5m_style(mission_dir: Path, mission_name: str) -> Optional[str]:
    """
    If mission_dir contains map.xdb but no map-tag.xdb, create map-tag.xdb pointing to map.xdb.
    Returns the ref_xdb it ended up pointing to (or None if no change).
    """
    tag = mission_dir / "map-tag.xdb"
    mapxdb = mission_dir / "map.xdb"
    if tag.exists():
        href, _err = parse_map_tag_href(tag)
        if href:
            return href
    if mapxdb.exists() and not tag.exists():
        write_map_tag_for_target(tag, "map.xdb")
        print(f" - Auto-created map-tag.xdb for {mission_name} -> map.xdb")
        return "map.xdb"
    return None

def autofix_missing_map_tags(stage_root: Path, only_prefix: Optional[str] = "A2") -> List[Tuple[str, str]]:
    """
    Legacy non-interactive path (kept for compatibility).
    Walk Maps/Scenario under stage_root and auto-create map-tag.xdb for missions that:
      - match prefix (e.g. 'A2')
      - contain map.xdb but no map-tag.xdb
    Returns list of (mission_name, ref_xdb) that were created/fixed.
    """
    base = stage_root / "Maps" / "Scenario"
    out: List[Tuple[str, str]] = []
    if not base.exists():
        return out
    for d in sorted([p for p in base.iterdir() if p.is_dir()], key=lambda p: p.name):
        name = d.name
        if only_prefix is not None and not name.startswith(only_prefix):
            continue
        ref = _ensure_map_tag_if_h5m_style(d, name)
        if ref:
            out.append((name, ref))
    if out:
        print(f"Auto-fix: created {len(out)} map-tag.xdb file(s) for prefix '{only_prefix}'.")
    return out

# New: interactive, templated creation
def _scan_missing_tag_targets(stage_root: Path, only_prefix: Optional[str]) -> List[Path]:
    base = stage_root / "Maps" / "Scenario"
    if not base.exists():
        return []
    out: List[Path] = []
    for d in sorted([p for p in base.iterdir() if p.is_dir()], key=lambda p: p.name):
        if only_prefix and not d.name.startswith(only_prefix):
            continue
        if (d / "map.xdb").exists() and not (d / "map-tag.xdb").exists():
            out.append(d)
    return out

def _load_map_tag_template_text(P: Paths) -> str:
    """
    Load map-tag template placed beside this script. Fallback to the known-good one-liner.
    """
    if P.map_tag_template_path.exists():
        try:
            txt = read_text(P.map_tag_template_path).strip()
            if txt:
                return txt
        except Exception:
            pass
    return MAP_TAG_XML_FOR_MAP_XDB

def interactive_autofix_missing_map_tags(P: Paths, stage_root: Path, only_prefix: Optional[str] = "A2") -> List[Tuple[str, str]]:
    """
    Interactive flow:
      1) List maps missing tag (but having map.xdb).
      2) Ask whether to create from template.
      3) Print template content.
      4) Ask for confirmation.
      5) Write files.
    Returns [(mission_name, 'map.xdb')] for created tags.
    """
    targets = _scan_missing_tag_targets(stage_root, only_prefix)
    if not targets:
        return []

    print(f"\nMaps missing map-tag.xdb (prefix '{only_prefix}'):")
    for d in targets:
        print(f" - {d.name} (map.xdb found)")

    if not yes_no("Create 'map-tag.xdb' from template for ALL listed maps?", default=True):
        print("Skipped map-tag auto-creation.")
        return []

    tmpl = _load_map_tag_template_text(P)
    print("\nTemplate content to be used for each new 'map-tag.xdb':")
    print("-----8<----- map-tag-template.xdb (preview) -----")
    print(tmpl.strip())
    print("-----8<------------------------------------------")

    if not yes_no("Proceed to write this template into each target as 'map-tag.xdb'?", default=True):
        print("Cancelled by user. Nothing written.")
        return []

    created: List[Tuple[str, str]] = []
    for d in targets:
        write_map_tag_for_target(d / "map-tag.xdb", "map.xdb", template_text=tmpl)
        print(f" - Auto-created map-tag.xdb for {d.name} -> map.xdb")
        created.append((d.name, "map.xdb"))

    if created:
        print(f"Auto-fix: created {len(created)} map-tag.xdb file(s) for prefix '{only_prefix}'.")
    return created

# ---------- Sanity checks with self-explaining errors ----------
def sanity_check_h5m_stage(root_dir: Path, internal_dev_id: str) -> None:
    """Verify .h5m staging is correct before zipping."""
    mi = root_dir / SINGLE_MISSIONS_REL / internal_dev_id
    problems = []
    if not mi.exists():
        problems.append(f"Missing folder: {mi}")
    else:
        mp = mi / "map.xdb"
        tg = mi / "map-tag.xdb"
        if not mp.exists():
            problems.append(f"Missing required file: {mp}")
        if not tg.exists():
            problems.append(f"Missing required file: {tg}")
        else:
            href, err = parse_map_tag_href(tg)
            if err:
                problems.append(f"{tg}: {err}")
            elif href != "map.xdb":
                problems.append(f"{tg}: href points to '{href}', but .h5m must point to 'map.xdb'.")
            # strict single-line content (per README)
            txt = read_text(tg).strip()
            if txt != MAP_TAG_XML_FOR_MAP_XDB:
                problems.append(f"{tg}: content must be exactly one line:\n  {MAP_TAG_XML_FOR_MAP_XDB}")
    if problems:
        raise SystemExit("Sanity check for .h5m failed:\n  - " + "\n  - ".join(problems))
    print("✔ .h5m sanity check passed.")

def sanity_check_h5u_stage(root_dir: Path) -> List[Tuple[str, str]]:
    """
    Verify .h5u staging: every mission has map-tag.xdb that points
    to a file present in the same folder. Returns [(mission, ref_xdb)].
    """
    ms: List[Tuple[str, str]] = []
    base = root_dir / "Maps" / "Scenario"
    problems = []
    if not base.exists():
        problems.append(f"Missing folder: {base}")
    else:
        for d in sorted([p for p in base.iterdir() if p.is_dir()], key=lambda p: p.name):
            tg = d / "map-tag.xdb"
            if not tg.exists():
                problems.append(f"{d.name}: missing map-tag.xdb (each mission must have one)")
                continue
            href, err = parse_map_tag_href(tg)
            if err:
                problems.append(f"{d.name}: {err}")
                continue
            if not (d / href).exists():
                problems.append(f"{d.name}: tag references '{href}', but the file is not present in {d}")
                continue
            ms.append((d.name, href))
    if problems:
        raise SystemExit("Sanity check for .h5u failed:\n  - " + "\n  - ".join(problems))
    print(f"✔ .h5u sanity check passed for {len(ms)} mission(s).")
    return ms

# ---------- Shared mission staging for .h5u (NO tag/player modifications) ----------
def _stage_mission_for_h5u(stage_root: Path, mission_src: Path, mission_name: str, mode: str, P: Optional[Paths] = None) -> Tuple[Path, str]:
    tag_src = mission_src / "map-tag.xdb"
    src_map = None
    ref_xdb = None

    if tag_src.exists():
        ref_xdb, err = parse_map_tag_href(tag_src)
        if err:
            raise SystemExit(f"{tag_src}: {err}")
        assert ref_xdb is not None
        src_map = mission_src / ref_xdb
        if not src_map.exists():
            raise SystemExit(f"{tag_src}: href points to '{ref_xdb}', but that file does not exist in:\n  {mission_src}")
    else:
        # No tag in sources: if this looks like an .h5m-style drop (map.xdb present), assume map.xdb
        if (mission_src / "map.xdb").exists():
            ref_xdb = "map.xdb"
            src_map = mission_src / "map.xdb"
            print(f"[NOTE] {mission_name}: no map-tag.xdb in sources; assuming .h5m-style and using map.xdb")
        else:
            raise SystemExit(f"Missing map-tag.xdb in sources: {tag_src}\n"
                             "Every mission folder must contain it, pointing to the main .xdb (e.g., 'C1M3.xdb').")

    stage_mission_dir = stage_root / "Maps" / "Scenario" / mission_name
    ensure_dir(stage_mission_dir)

    if mode == "minimal":
        if tag_src.exists():
            shutil.copy2(tag_src, stage_mission_dir / "map-tag.xdb")
        else:
            # synthesize one now; use template only for map.xdb
            tmpl = _load_map_tag_template_text(P) if (P and ref_xdb == "map.xdb") else None
            write_map_tag_for_target(stage_mission_dir / "map-tag.xdb", ref_xdb, template_text=tmpl)
            print(f"[SYNTH] Wrote map-tag.xdb for {mission_name} -> {ref_xdb}")
        shutil.copy2(src_map, stage_mission_dir / ref_xdb)
        vprint(f"Minimal stage for {mission_name}: 2 files copied.")
    else:
        copied = copy_tree_with_progress(mission_src, stage_mission_dir, label=f"Stage mission '{mission_name}'")
        # ensure tag exists in stage
        if not (stage_mission_dir / "map-tag.xdb").exists():
            tmpl = _load_map_tag_template_text(P) if (P and ref_xdb == "map.xdb") else None
            write_map_tag_for_target(stage_mission_dir / "map-tag.xdb", ref_xdb, template_text=tmpl)
            print(f"[SYNTH] Wrote map-tag.xdb for {mission_name} -> {ref_xdb}")
        if copied == 0 or not (stage_mission_dir / ref_xdb).exists():
            raise SystemExit(f"Verification failed in staged copy for '{mission_name}': tag points to '{ref_xdb}' "
                             f"but it was not found in:\n  {stage_mission_dir}\n"
                             "Either the sources are inconsistent, or a different main .xdb name is used.")

    return stage_mission_dir, ref_xdb

# ---------- .h5u builders ----------
def build_campaign_h5u(P: Paths) -> None:
    ensure_dir(P.compiled_campaigns_dir)

    mission_dirs = list_mission_dirs(P.missions_root)
    if not mission_dirs:
        raise SystemExit(f"No missions found in {P.missions_root}")

    names = [d.name for d in mission_dirs]
    idx = prompt_choice(names, "Select a mission to package as a campaign .h5u patch:")
    mission_name = names[idx]
    mission_src = mission_dirs[idx]

    mode_idx = prompt_choice(
        ["Minimal payload (only map-tag.xdb and the referenced <Mission>.xdb; unchanged)",
         "Full payload (ALL files from the mission folder; unchanged)"],
        "Select .h5u payload mode:"
    )
    mode = "minimal" if mode_idx == 0 else "full"

    print(f"\nBuilding campaign patch (.h5u) for mission: {mission_name}")
    print(f"- Payload mode: {mode} (no tag/players modification)")

    with tempfile.TemporaryDirectory(prefix="h55_h5u_") as tmpdir:
        tmp = Path(tmpdir)
        stage_mission_dir, ref_xdb = _stage_mission_for_h5u(tmp, mission_src, mission_name, mode, P)

        # Scripts for a .h5u must be at ROOT /scripts
        root_scripts = include_scripts_at_root_interactive(P, tmp)

        # Mission-level meta (optional convenience)
        write_meta_h5u_mission(stage_mission_dir, mission_name, ref_xdb, mode)
        # Root meta
        write_meta_h5u_root(tmp, "single", [{"name": mission_name, "ref_xdb": ref_xdb, "payload": mode}], root_scripts)

        # Interactive A2 auto-fix (if any)
        interactive_autofix_missing_map_tags(P, tmp, only_prefix="A2")

        # Sanity check
        sanity_check_h5u_stage(tmp)

        out_h5u = P.compiled_campaigns_dir / f"my_changes_for_{mission_name}.h5u"
        if out_h5u.exists():
            if not yes_no(f"Target file already exists:\n  {out_h5u}\nOverwrite?", default=False):
                print("Aborted by user. Nothing written.")
                return
            out_h5u.unlink()
        zip_dir_to_file_progress(tmp, out_h5u, label="Packing .h5u")

    print(f"\n✅ Campaign patch built: {out_h5u}")

# ---------- Discover dynamic campaign groups ----------
def _discover_campaign_groups(missions_root: Path) -> Dict[Tuple[Optional[int], int], List[Tuple[str, Path, int]]]:
    groups: Dict[Tuple[Optional[int], int], List[Tuple[str, Path, int]]] = {}
    if not missions_root.exists():
        return groups
    for d in missions_root.iterdir():
        if not d.is_dir():
            continue
        m = MISSION_RE.match(d.name)
        if not m:
            continue
        addon = int(m.group('A')) if m.group('A') is not None else None
        camp = int(m.group('C')); ms = int(m.group('M'))
        key = (addon, camp)
        groups.setdefault(key, []).append((d.name, d, ms))
    for k in list(groups.keys()):
        groups[k].sort(key=lambda t: t[2])
    return groups

def _format_campaign_key(key: Tuple[Optional[int], int]) -> str:
    a, c = key
    return f"A{a}C{c}" if a is not None else f"C{c}"

def build_campaign_set_h5u(P: Paths) -> None:
    ensure_dir(P.compiled_campaigns_dir)

    groups = _discover_campaign_groups(P.missions_root)
    if not groups:
        raise SystemExit(f"No missions matching A?C#M# pattern found in {P.missions_root}")

    entries = []
    keys_sorted = sorted(groups.keys(), key=lambda k: (_format_campaign_key(k)))
    for k in keys_sorted:
        label = _format_campaign_key(k)
        missions = [name for (name, _path, _mnum) in groups[k]]
        entries.append(f"{label} — {len(missions)} mission(s): {', '.join(missions)}")

    pick = prompt_choice(entries, "Select a WHOLE campaign to package as a .h5u patch:")
    sel_key = keys_sorted[pick]
    sel_label = _format_campaign_key(sel_key)
    sel_missions = groups[sel_key]

    mode_idx = prompt_choice(
        ["Minimal payload (map-tag.xdb + referenced <Mission>.xdb per mission; unchanged)",
         "Full payload (ALL files from each mission folder; unchanged)"],
        f"Select .h5u payload mode for campaign {sel_label}:"
    )
    mode = "minimal" if mode_idx == 0 else "full"

    print(f"\nBuilding campaign patch (.h5u) for {sel_label}")
    print(f"- Missions: {[name for (name, _p, _m) in sel_missions]}")
    print(f"- Payload mode: {mode}")

    with tempfile.TemporaryDirectory(prefix="h55_h5u_set_") as tmpdir:
        tmp = Path(tmpdir)
        missions_meta: List[Dict[str, str]] = []

        for (name, path, _mnum) in sel_missions:
            stage_mission_dir, ref_xdb = _stage_mission_for_h5u(tmp, path, name, mode, P)
            write_meta_h5u_mission(stage_mission_dir, name, ref_xdb, mode)
            missions_meta.append({"name": name, "ref_xdb": ref_xdb, "payload": mode})

        root_scripts = include_scripts_at_root_interactive(P, tmp)
        write_meta_h5u_root(tmp, "campaign", missions_meta, root_scripts)

        # Interactive auto-fix (A2 group)
        interactive_autofix_missing_map_tags(P, tmp, only_prefix="A2")

        # Sanity check for the whole staged tree
        sanity_check_h5u_stage(tmp)

        out_h5u = P.compiled_campaigns_dir / f"my_changes_for_{sel_label}.h5u"
        if out_h5u.exists():
            if not yes_no(f"Target file already exists:\n  {out_h5u}\nOverwrite?", default=False):
                print("Aborted by user. Nothing written.")
                return
            out_h5u.unlink()
        zip_dir_to_file_progress(tmp, out_h5u, label="Packing .h5u (campaign)")

    print(f"\n✅ Campaign set patch built: {out_h5u}")

# ---------- Compile full MMH55-Cam-Maps.h5u (pack entire mod folder) ----------
def _copy_tree(src: Path, dst: Path, title: str) -> None:
    copy_tree_with_progress(src, dst, title)

def compile_full_cammaps_h5u(P: Paths) -> None:
    """Pack the entire UserMODs/MMH55-Cam-Maps into a single h5u."""
    ensure_dir(P.compiled_campaigns_dir)
    cam_maps_root = P.cam_maps_root
    if not cam_maps_root.exists():
        raise SystemExit(f"Missing folder: {cam_maps_root}")

    print(f"\nCompiling full MMH55-Cam-Maps.h5u from:\n  {cam_maps_root}")

    with tempfile.TemporaryDirectory(prefix="h55_full_") as tmpdir:
        tmp = Path(tmpdir)
        for item in cam_maps_root.iterdir():
            if item.is_dir():
                _copy_tree(item, tmp / item.name, f"Copying tree: {item.name}")
            else:
                ensure_dir((tmp / item.name).parent)
                shutil.copy2(item, tmp / item.name)

        root_scripts = include_scripts_at_root_interactive(P, tmp)
        write_meta_h5u_root(tmp, "full", [], root_scripts)

        # Interactive A2 missions that look like dropped .h5m (map.xdb without tag)
        interactive_autofix_missing_map_tags(P, tmp, only_prefix="A2")

        # sanity
        sanity_check_h5u_stage(tmp)

        out_h5u = P.compiled_campaigns_dir / "MMH55-Cam-Maps.h5u"
        if out_h5u.exists():
            if not yes_no(f"Target file already exists:\n  {out_h5u}\nOverwrite?", default=False):
                print("Aborted by user. Nothing written.")
                return
            out_h5u.unlink()

        zip_dir_to_file_progress(tmp, out_h5u, label="Packing .h5u (full)")

    print(f"\n✅ Full campaign package built: {out_h5u}")

# ---------- Template cache ----------
def _template_cache_root(P: Paths) -> Path:
    return P.cache_dir / "template_h5m_unpacked"

def _template_stamp_path(cache_root: Path) -> Path:
    return cache_root / ".stamp.json"

def _read_json(path: Path) -> Optional[dict]:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return None

def _write_json(path: Path, data: dict) -> None:
    ensure_dir(path.parent)
    path.write_text(json.dumps(data, indent=2), encoding="utf-8")

def _template_stamp_for_file(p: Path) -> dict:
    st = p.stat()
    return {"source": str(p.resolve()), "size": int(st.st_size), "mtime": int(st.st_mtime)}

def _stamp_matches(a: dict, b: dict) -> bool:
    return a and b and a.get("source")==b.get("source") and a.get("size")==b.get("size") and a.get("mtime")==b.get("mtime")

def ensure_template_cache(P: Paths) -> Path:
    """Ensure the template .h5m is unzipped once into cache; return cache dir."""
    cache_root = _template_cache_root(P)
    stamp_path = _template_stamp_path(cache_root)
    want = _template_stamp_for_file(P.template_h5m)
    have = _read_json(stamp_path)

    if USE_TEMPLATE_CACHE and cache_root.exists() and _stamp_matches(want, have):
        vprint(f"Using cached template at {cache_root}")
        return cache_root

    # Refresh cache
    if cache_root.exists():
        shutil.rmtree(cache_root, ignore_errors=True)
    ensure_dir(cache_root)
    print("Preparing template cache (unzipping DEV_C1M1.h5m once)...")
    safe_unzip_to_dir(P.template_h5m, cache_root)
    _write_json(stamp_path, want)
    return cache_root

def materialize_template_to(P: Paths, dst_root: Path) -> None:
    """Copy cached template tree into dst_root (fast, no per-file prints)."""
    if USE_TEMPLATE_CACHE:
        cache_root = ensure_template_cache(P)
        copy_tree_quiet(cache_root, dst_root)
    else:
        safe_unzip_to_dir(P.template_h5m, dst_root)

# ---------- Environment ----------
def verify_environment(P: Paths) -> None:
    missing = []
    if not P.template_h5m.exists():
        missing.append(str(P.template_h5m))
    if not P.missions_root.exists():
        missing.append(str(P.missions_root))
    ensure_dir(P.compiled_dir)
    ensure_dir(P.compiled_campaigns_dir)
    ensure_dir(P.extracted_dir)
    ensure_dir(P.backups_dir)
    ensure_dir(P.cache_dir)

    print("🔎 Verifying environment ...")
    if missing:
        print("❌ Environment problems:")
        for m in missing:
            print(" - Missing:", m)
        if P.campaign_scripts_dir.exists():
            _print_scripts_inventory(P.campaign_scripts_dir)
        else:
            print(" - Optional campaign scripts: (none found)")
        # Template hint even on failure
        if P.map_tag_template_path.exists():
            print(f" - Optional map-tag template: {P.map_tag_template_path}")
        else:
            print(" - Optional map-tag template: (not found, will fallback to one-liner if needed)")
        sys.exit(1)

    print("✅ Environment OK")
    print(f" - Template: {P.template_h5m}")
    print(f" - Missions: {P.missions_root}")
    print(f" - Compiled maps (.h5m): {P.compiled_dir}")
    print(f" - Compiled campaigns (.h5u): {P.compiled_campaigns_dir}")
    print(f" - UserMODs root: {P.user_mods_root} ({'exists' if P.user_mods_root.exists() else 'missing'})")
    if P.campaign_scripts_dir.exists():
        _print_scripts_inventory(P.campaign_scripts_dir)
    else:
        print(" - Optional campaign scripts: (none found)")
    if P.map_tag_template_path.exists():
        print(f" - Optional map-tag template: {P.map_tag_template_path}")
    else:
        print(" - Optional map-tag template: (not found, will fallback to one-liner)")

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

# ---------- .h5m PACK ----------
def pack(P: Paths) -> None:
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
    href_guess, _err = (parse_map_tag_href(map_tag_src) if map_tag_src.exists() else (None, None))
    orig_xdb_guess = href_guess or f"{mission_name}.xdb"

    print(f"\nPacking mission: {mission_name}")
    print(f"- Original main XDB (from sources): {orig_xdb_guess}")
    print(f"- Internal folder in .h5m: {internal_dev_id}")

    with tempfile.TemporaryDirectory(prefix="h55_pack_") as tmpdir:
        tmpdir = Path(tmpdir)

        # 1) Materialize template (cached for speed)
        materialize_template_to(P, tmpdir)

        # 2) Rename internal folder to DEV_<Mission>
        singles_folder = detect_singlemissions_folder(tmpdir)
        new_singles_folder = singles_folder.parent / internal_dev_id
        if singles_folder.name != internal_dev_id:
            if new_singles_folder.exists():
                shutil.rmtree(new_singles_folder)
            singles_folder.rename(new_singles_folder)
        print(f"Internal folder prepared: {new_singles_folder}")

        # 3) Clear working folder
        to_remove = list(new_singles_folder.iterdir())
        print(f"Clearing working folder ({len(to_remove)} item(s)) ...")
        for child in to_remove:
            if child.is_dir():
                shutil.rmtree(child)
            else:
                child.unlink()

        # 4) Copy mission files from sources (progress)
        copy_tree_with_progress(mission_src, new_singles_folder,
                                label=f"Copy mission files {mission_name} -> DEV structure")

        # 4b) Optional scripts INTO MAP FOLDER (no subfolder)
        scripts_added = include_scripts_into_map_folder_interactive(P, new_singles_folder)

        # 5) map.xdb + tag exactly
        src_main_xdb = detect_main_xdb(new_singles_folder, orig_xdb_guess)
        dst_main_xdb = new_singles_folder / "map.xdb"
        if src_main_xdb != dst_main_xdb:
            print(f"Renaming main map: {src_main_xdb.name} -> map.xdb")
        safe_rename(src_main_xdb, dst_main_xdb)
        write_map_tag_for_target(new_singles_folder / "map-tag.xdb", "map.xdb")

        # 6) Optional single-player flip
        flip_applied = False
        player2_prev = None
        if yes_no("Activate Player 2 in map.xdb for single-player start?", default=True):
            ok, prev = set_player2_active(dst_main_xdb, True)
            flip_applied, player2_prev = ok, prev
            print(" - Player 2 set to ActivePlayer=true." if ok else " - Could not edit map.xdb; continuing without flip.")

        # 7) Metadata + sanity
        write_meta_h5m(tmpdir, mission_name, orig_xdb_guess, internal_dev_id,
                       flip_applied, player2_prev, scripts_added)
        sanity_check_h5m_stage(tmpdir, internal_dev_id)

        # 8) Produce .h5m
        out_h5m = P.compiled_dir / f"{internal_dev_id}.h5m"
        if out_h5m.exists():
            if not yes_no(f"Target file already exists:\n  {out_h5m}\nOverwrite?", default=False):
                print("Aborted by user. Nothing written.")
                return
            out_h5m.unlink()
        zip_dir_to_file_progress(tmpdir, out_h5m, label="Packing .h5m")

    print(f"\n✅ Packed: {out_h5m}")
    print("Reminder: keep Instant Travel blocked if it was blocked in the mission.")  # README

# ---------- Apply back ----------
def _timestamp() -> str:
    return _dt.datetime.now().strftime("%Y%m%d-%H%M%S")

def _zip_paths(base: Path, paths: Iterable[Path], out_zip: Path) -> None:
    with zipfile.ZipFile(out_zip, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for p in paths:
            if p.is_file() and p.exists():
                zf.write(p, arcname=str(p.relative_to(base)))

def _scan_files_with_signature(base: Path) -> List[Tuple[Path, Path, int, int, Optional[str]]]:
    """
    Return list of (abs_path, rel_path, size, mtime_sec, sha1_or_None)
    FAST: sha1_or_None is None
    FULL: sha1_or_None is sha1 of file
    """
    files = [p for p in base.rglob("*") if p.is_file() and p.name not in {META_XML, META_JSON}]
    out: List[Tuple[Path, Path, int, int, Optional[str]]] = []
    total = len(files)
    if VERBOSE:
        print(f"Scanning {total} files under {base} ...")
    for i, p in enumerate(files, 1):
        size, mtime = _stat_sig(p)
        sha = file_sha1(p) if HASH_MODE == "full" else None
        rel = p.relative_to(base)
        if VERBOSE:
            msg = f"[{i}/{total}] {rel}"
            if HASH_MODE == "full":
                msg += f" sha1={sha}"
            print(msg)
        out.append((p, rel, size, mtime, sha))
    if VERBOSE:
        print(f"Total files scanned: {total}")
    return out

def _confirm_changes_numeric(changes: List[Tuple[Path, Path, int, int, Optional[str], Optional[str]]], cam_root: Path) -> List[Tuple[Path, Path]]:
    """
    Interactive per-file confirm.
    changes: list of (src, dest, src_size, src_mtime, src_sha_or_None, dest_sha_or_None)
    Returns subset to apply.
    """
    to_apply: List[Tuple[Path, Path]] = []
    n = len(changes)
    if n == 0:
        return to_apply

    if n > 100:
        mode = prompt_choice(
            ["Per-file confirmation (may be long)", "Apply ALL", "Cancel"],
            f"There are {n} changed/new file(s). Choose how to proceed:"
        )
        if mode == 1:
            return [(s, d) for (s, d, *_rest) in changes]
        if mode == 2:
            print("Cancelled."); return []

    apply_rest = None  # None / True / False
    for idx, (src, dst, s_size, s_mt, s_sha, d_sha) in enumerate(changes, 1):
        status = "NEW" if d_sha is None else "CHANGED"
        print(f"\n[{idx}/{n}] {dst.relative_to(cam_root)}  ({status})")
        if HASH_MODE == "full":
            print(f"  src sha1: {s_sha or 'n/a'}")
            if d_sha is not None:
                print(f"  dst sha1: {d_sha or 'n/a'}")
        else:
            # FAST: show size+mtime (seconds)
            print(f"  src size: {s_size} B, mtime: {s_mt}")
            if d_sha is not None:
                try:
                    ds, dm = _stat_sig(dst)
                    print(f"  dst size: {ds} B, mtime: {dm}")
                except Exception:
                    print(f"  dst size/mtime: n/a")

        if apply_rest is True:
            to_apply.append((src, dst)); continue
        if apply_rest is False:
            continue

        act = prompt_choice(
            ["Include this file",
             "Skip this file",
             "Include ALL remaining",
             "Skip ALL remaining",
             "Abort"],
            "Choose:"
        )
        if act == 0:
            to_apply.append((src, dst))
        elif act == 1:
            pass
        elif act == 2:
            apply_rest = True
            to_apply.append((src, dst))
        elif act == 3:
            apply_rest = False
        else:
            print("Aborted by user."); return []
    return to_apply

def _guess_mission_folder_by_xdb(P: Paths, orig_xdb_name: str) -> Optional[Path]:
    stem = Path(orig_xdb_name).stem
    candidates: List[Path] = []
    for d in list_mission_dirs(P.missions_root):
        if d.name == stem:
            return d
        if (d / orig_xdb_name).exists():
            candidates.append(d)
    if len(candidates) == 1:
        return candidates[0]
    if len(candidates) > 1:
        idx = prompt_choice([c.name for c in candidates],
                            f"Multiple mission folders contain {orig_xdb_name}. Pick one:")
        return candidates[idx]
    return None

def apply_back(P: Paths) -> None:
    """Unified apply-back: pick either a .h5m or .h5u and restore/apply to sources."""
    ensure_dir(P.compiled_dir); ensure_dir(P.compiled_campaigns_dir)

    items: List[Tuple[str, Path]] = []
    items += [("MAP", p) for p in sorted(P.compiled_dir.glob("*.h5m")) if p.is_file()]
    items += [("MOD", p) for p in sorted(P.compiled_campaigns_dir.glob("*.h5u")) if p.is_file()]
    if not items:
        raise SystemExit(f"No .h5m in {P.compiled_dir} and no .h5u in {P.compiled_campaigns_dir}")

    names = [f"{kind}: {p.name}" for (kind, p) in items]
    idx = prompt_choice(names, "Select an archive to APPLY back to sources (.h5m or .h5u):")
    kind, chosen = items[idx]

    if kind == "MAP":
        _apply_h5m_back(P, chosen)
    else:
        _apply_h5u_back(P, chosen)

def _apply_h5m_back(P: Paths, h5m_path: Path) -> None:
    print(f"\nUnpacking .h5m: {h5m_path}")
    with tempfile.TemporaryDirectory(prefix="h55_unpack_") as tmpdir:
        tmpdir = Path(tmpdir)
        safe_unzip_to_dir(h5m_path, tmpdir)

        singles_folder = detect_singlemissions_folder(tmpdir)
        dev_folder_name = singles_folder.name

        # Read metadata from XML (or legacy JSON)
        meta = read_meta_h5m(tmpdir)
        mission_folder = meta.get("mission_folder") or dev_folder_name.replace("DEV_", "", 1)
        orig_xdb_name = meta.get("original_main_xdb") or f"{mission_folder}.xdb"
        p2_flip_applied = bool(meta.get("player2_flip_applied", False))
        p2_active_original = meta.get("player2_active_original", None)

        # Revert map.xdb -> <orig_xdb_name>; fix map-tag.xdb if needed
        map_xdb = singles_folder / "map.xdb"
        if map_xdb.exists() and orig_xdb_name != "map.xdb":
            safe_rename(map_xdb, singles_folder / orig_xdb_name)
        tag_p = singles_folder / "map-tag.xdb"
        if tag_p.exists():
            href, _err = parse_map_tag_href(tag_p)
            if href and href != orig_xdb_name:
                write_map_tag_for_target(tag_p, orig_xdb_name)

        # Roll back Player‑2 flip only if metadata says we flipped and current differs
        if p2_flip_applied:
            target_value = bool(p2_active_original) if p2_active_original is not None else False
            curr = get_player2_active(singles_folder / orig_xdb_name)
            if curr is not None and curr != target_value:
                set_player2_active(singles_folder / orig_xdb_name, target_value)

        # Sanity check after revert (must have tag -> orig_xdb present)
        tmp_stage = tempfile.mkdtemp(prefix="h55_h5m_chk_")
        try:
            root_like = Path(tmp_stage)
            stage = root_like / SINGLE_MISSIONS_REL / dev_folder_name
            ensure_dir(stage.parent)
            shutil.copytree(singles_folder, stage, dirs_exist_ok=True)
            sanity_check_h5m_stage(root_like, dev_folder_name)
        finally:
            shutil.rmtree(tmp_stage, ignore_errors=True)

        # Decide destination mission folder (fallback by xdb if needed)
        dest_folder = P.missions_root / mission_folder
        if not dest_folder.exists():
            guess = _guess_mission_folder_by_xdb(P, orig_xdb_name)
            if guess is not None:
                print(f"Guessed mission folder by XDB name: {guess}")
                dest_folder = guess
        print("\nScope:")
        print(f" - Archive scanned: {h5m_path.name} → {singles_folder.relative_to(tmpdir)}")
        print(f" - Applying to sources under: {dest_folder}")
        print(f" - Diff mode: {HASH_MODE} ({'size+mtime' if HASH_MODE=='fast' else 'sha1'})")
        print(" - Policy: identicals are skipped; NEW/CHANGED files are shown for confirmation; subfolders preserved.")
        # Scan files in the extracted .h5m (post-revert) with signatures
        scanned = _scan_files_with_signature(singles_folder)

        cam_root = dest_folder
        changes: List[Tuple[Path, Path, int, int, Optional[str], Optional[str]]] = []
        for src_abs, rel, src_size, src_mt, src_sha in scanned:
            if rel.name in {META_XML, META_JSON}:
                continue
            target = cam_root / rel
            if target.exists():
                try:
                    if HASH_MODE == "full":
                        dst_sha = file_sha1(target)
                        if dst_sha == src_sha:
                            continue
                        changes.append((src_abs, target, src_size, src_mt, src_sha, dst_sha))
                    else:
                        if _signatures_equal_fast(src_abs, target):
                            continue
                        # we don't compute dst sha in fast mode (stay fast)
                        changes.append((src_abs, target, src_size, src_mt, None, "exists"))
                except Exception:
                    changes.append((src_abs, target, src_size, src_mt, None, None))
            else:
                changes.append((src_abs, target, src_size, src_mt, src_sha if HASH_MODE=="full" else None, None))

        if not changes:
            print("No changes detected (all files identical to sources).")
            return

        print(f"\nChanged/new files detected: {len(changes)}")
        to_apply = _confirm_changes_numeric(changes, P.missions_root)
        if not to_apply:
            print("No files selected. Nothing written.")
            return

        # Backup selected targets
        ensure_dir(P.backups_dir)
        bk_zip = P.backups_dir / f"apply_h5m_{h5m_path.stem}_{_timestamp()}.zip"
        to_backup = [dst for (_src, dst) in to_apply if dst.exists()]
        if to_backup:
            print(f" - Backing up {len(to_backup)} existing file(s) to: {bk_zip}")
            _zip_paths(P.missions_root, to_backup, bk_zip)

        # Apply selected changes
        for src, dst in to_apply:
            ensure_dir(dst.parent)
            shutil.copy2(src, dst)
            print(f"   updated: {dst}")

    print("\n✅ .h5m applied back to sources (signature‑based).")

def _apply_h5u_back(P: Paths, h5u_path: Path) -> None:
    """Apply a .h5u back into repo sources, copying only changed files by hash/signature."""
    print(f"\nApplying .h5u: {h5u_path}")
    cam_root = P.cam_maps_root
    if not cam_root.exists():
        raise SystemExit(f"Missing repo mod root: {cam_root}")

    with tempfile.TemporaryDirectory(prefix="h55_apply_") as tmpdir:
        tmpdir = Path(tmpdir)
        safe_unzip_to_dir(h5u_path, tmpdir)

        # sanity (warn-only option)
        try:
            sanity_check_h5u_stage(tmpdir)
        except SystemExit as e:
            print(f"WARNING: {e}\nContinuing only if you confirm.")
            if not yes_no("Proceed despite the warning?", default=False):
                print("Aborted."); return

        print("\nScanning files (signatures) in the extracted .h5u ...")
        print("Scope:")
        print(f" - Archive scanned: {h5u_path.name} (entire tree)")
        print(f" - Applying to sources under: {cam_root}")
        print(f" - Diff mode: {HASH_MODE} ({'size+mtime' if HASH_MODE=='fast' else 'sha1'})")
        print(" - Policy: identicals are skipped; NEW/CHANGED files are shown for confirmation; subfolders preserved.")
        scanned = _scan_files_with_signature(tmpdir)

        changes: List[Tuple[Path, Path, int, int, Optional[str], Optional[str]]] = []
        for src_abs, rel, src_size, src_mt, src_sha in scanned:
            dst = cam_root / rel
            if dst.exists():
                try:
                    if HASH_MODE == "full":
                        dst_sha = file_sha1(dst)
                        if dst_sha == src_sha:
                            continue
                        changes.append((src_abs, dst, src_size, src_mt, src_sha, dst_sha))
                    else:
                        if _signatures_equal_fast(src_abs, dst):
                            continue
                        changes.append((src_abs, dst, src_size, src_mt, None, "exists"))
                except Exception:
                    changes.append((src_abs, dst, src_size, src_mt, None, None))
            else:
                # new file (no hash check required)
                changes.append((src_abs, dst, src_size, src_mt, src_sha if HASH_MODE=="full" else None, None))

        if not changes:
            print("No changes detected (all files identical to sources).")
            return

        print(f"\nChanged/new files detected: {len(changes)}")
        to_apply = _confirm_changes_numeric(changes, cam_root)
        if not to_apply:
            print("No files selected. Nothing written.")
            return

        # Backup selected existing targets
        ensure_dir(P.backups_dir)
        bk_zip = P.backups_dir / f"apply_h5u_{h5u_path.stem}_{_timestamp()}.zip"
        to_backup = [dst for (_src, dst) in to_apply if dst.exists()]
        if to_backup:
            print(f" - Backing up {len(to_backup)} existing file(s) to: {bk_zip}")
            _zip_paths(cam_root, to_backup, bk_zip)

        # Apply selected changes
        for src, dst in to_apply:
            ensure_dir(dst.parent)
            shutil.copy2(src, dst)
            print(f"   updated: {dst}")

    print("\n✅ .h5u applied back to sources (signature‑based).")

# ---------- CLI flags parsing ----------
def _parse_global_flags(argv: List[str]) -> List[str]:
    """
    Extract and apply global flags from argv.
    Returns the remaining argv (command + args).
    """
    global VERBOSE, HASH_MODE, USE_TEMPLATE_CACHE, CACHE_DIR_OVERRIDE
    out: List[str] = []
    i = 0
    while i < len(argv):
        a = argv[i]
        if a in ("--verbose",):
            VERBOSE = True
        elif a in ("--quiet", "--skip-logs"):
            VERBOSE = False
        elif a == "--full-hash":
            HASH_MODE = "full"
        elif a.startswith("--hash="):
            val = a.split("=", 1)[1].strip().lower()
            if val in ("fast", "full"):
                HASH_MODE = val
            else:
                print(f"Unknown --hash mode: {val} (use fast|full)")
        elif a == "--no-template-cache":
            USE_TEMPLATE_CACHE = False
        elif a == "--cache-dir":
            if i + 1 >= len(argv):
                print("--cache-dir needs a path")
            else:
                CACHE_DIR_OVERRIDE = Path(argv[i+1]).resolve()
                i += 1
        else:
            out.append(a)
        i += 1
    return out

# ---------- Menu / entrypoint ----------
def main(argv: List[str]) -> None:
    # Extract & apply global flags first (before command handling)
    argv = _parse_global_flags(argv)

    script_path = Path(__file__).resolve()
    P = Paths(script_path)

    # ALWAYS verify environment on startup
    verify_environment(P)

    # CLI shortcuts
    if len(argv) > 1:
        cmd = argv[1].lower()
        if cmd in {"-h", "--help", "help"}:
            print(__doc__); return
        if cmd == "pack":
            pack(P); return
        if cmd in {"h5u", "patch", "build_h5u"}:
            build_campaign_h5u(P); return
        if cmd in {"campaign", "campaign_h5u", "h5u_campaign", "campaign_set"}:
            build_campaign_set_h5u(P); return
        if cmd in {"full", "full_h5u", "compile_full"}:
            compile_full_cammaps_h5u(P); return
        if cmd in {"apply", "unpack", "restore"}:
            apply_back(P); return
        print(f"Unknown command: {cmd}\nUse: pack | h5u | campaign | full | apply")
        return

    # Interactive menu
    choice = prompt_choice(
        ["Pack a mission to .h5m",
         "Build campaign .h5u patch (single mission)",
         "Build WHOLE campaign .h5u patch (multi-mission)",
         "Compile full MMH55-Cam-Maps.h5u",
         "Apply back to sources (.h5m or .h5u)",
         "Quit"], "Select action:")
    if choice == 0:
        pack(P)
    elif choice == 1:
        build_campaign_h5u(P)
    elif choice == 2:
        build_campaign_set_h5u(P)
    elif choice == 3:
        compile_full_cammaps_h5u(P)
    elif choice == 4:
        apply_back(P)
    else:
        print("Bye.")

if __name__ == "__main__":
    main(sys.argv)
