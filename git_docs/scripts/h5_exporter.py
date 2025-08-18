#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
h5_exporter.py — HOMM5 Build Helper (Unified Exporter)

• Single interactive CLI for:
    1) Export CREATURES  -> h55_enums_creatures.lua
    2) Export SPELLS     -> h55_enums_spells.lua
    3) Export BOTH

• Scans *local* repo:
    LOCAL_DIR/Creatures/**.xdb
    LOCAL_DIR/MAGIC/**.xdb
    git_docs/types.xml

• Output directory:
    LOCAL_DIR/COMPILED_LUA (or timestamped clone if overwrite is not chosen)

• Guarantees (Lua side):
    - CREATURE.<TOKEN> returns a read-only object:
        { name="CREATURE_PEASANT", id=<int or nil>, BASE_GROWTH=<int>, ABILITIES={ "ABILITY_...", ... } }
    - ABILITIES.CREATURES is a read-only map: "ABILITY_FOO" -> <int id or nil>
    - SPELL.<TOKEN> returns read-only object:
        { name="SPELL_BLIND", id=<int>, school="MAGIC_SCHOOL_LIGHT", level=4 }
      plus SPELL_BY_ID and SPELLS_BY_SCHOOL (read-only).

• Usage examples:
    python h5_exporter.py                 # interactive
    python h5_exporter.py --dry-run       # simulate, but still guide
    python h5_exporter.py --yes --strict  # non-interactive with strict checks

No external dependencies; only stdlib.
"""
from __future__ import annotations
import argparse
import os
import re
import sys
import time
import shutil
from pathlib import Path
from typing import Dict, List, Optional, Tuple
import xml.etree.ElementTree as ET

# ──────────────────────────────────────────────────────────────────────────────
# Console helpers
# ──────────────────────────────────────────────────────────────────────────────

def info(msg: str) -> None: print(f"[INFO] {msg}")
def warn(msg: str) -> None: print(f"[WARN] {msg}")
def err(msg: str)  -> None: print(f"[ERROR] {msg}")

def title(text: str) -> None:
    print("\n" + text + "\n" + "=" * len(text))

def line() -> None:
    print("-" * 79)

# ──────────────────────────────────────────────────────────────────────────────
# Repo/bootstrap helpers
# ──────────────────────────────────────────────────────────────────────────────

def guess_repo_root(start: Path) -> Path:
    """Walk up looking for both 'git_docs' and 'LOCAL_DIR' as siblings."""
    cur = start.resolve()
    for _ in range(8):
        if (cur / "git_docs").is_dir() and (cur / "LOCAL_DIR").is_dir():
            return cur
        cur = cur.parent
    # Fallback to the directory containing this script
    return start.parent.resolve()

def resolve(repo_root: Path, p: str) -> Path:
    pp = Path(p)
    return (repo_root / pp).resolve() if not pp.is_absolute() else pp.resolve()

# ──────────────────────────────────────────────────────────────────────────────
# Discovery (recursive)
# ──────────────────────────────────────────────────────────────────────────────

def rglob_xdb(root: Path) -> List[Path]:
    return sorted([p for p in root.rglob("*.xdb") if p.is_file()])

def quick_root_tag(path: Path) -> Optional[str]:
    try:
        head = path.read_text(encoding="utf-8", errors="ignore")[:2048]
        m = re.search(r'<\s*([A-Za-z0-9_]+)\b', head)
        return m.group(1) if m else None
    except Exception:
        return None

# ──────────────────────────────────────────────────────────────────────────────
# types.xml enum extraction (defensive)
# ──────────────────────────────────────────────────────────────────────────────

_ENUM_PATTERNS = (
    (r'name\s*=\s*"(?P<name>[A-Z0-9_]+)"[^>]*?\b(?:value|val|id|index)\s*=\s*"(?P<val>\d+)"', re.I),
    (r'<name>\s*(?P<name>[A-Z0-9_]+)\s*</name>.*?<value>\s*(?P<val>\d+)\s*</value>', re.I | re.S),
    (r'(?P<name>[A-Z0-9_]+)\s*=\s*(?P<val>\d+)', re.I),
    (r'<\s*(?P<name>[A-Z0-9_]+)\s*>\s*(?P<val>\d+)\s*<\s*/\s*(?P=name)\s*>', re.I),
)

def _extract_enum_map(text: str, prefix: str) -> Dict[str, int]:
    out: Dict[str, int] = {}
    for pat, flags in _ENUM_PATTERNS:
        for m in re.finditer(pat, text, flags):
            nm = m.group("name").strip()
            if nm.startswith(prefix):
                out.setdefault(nm, int(m.group("val")))
    return out

def load_enums(types_xml: Path, prefix: str) -> Dict[str, int]:
    txt = types_xml.read_text(encoding="utf-8", errors="replace")
    return _extract_enum_map(txt, prefix)

# ──────────────────────────────────────────────────────────────────────────────
# Creature parsing (from .xdb)
# ──────────────────────────────────────────────────────────────────────────────

def parse_creature_xdb(path: Path) -> Optional[Tuple[str, Optional[int], List[str]]]:
    """
    Returns (BaseCreature_const, WeeklyGrowth_int_or_None, [ability_consts...]) or None.
    """
    try:
        tree = ET.parse(path)
        root = tree.getroot()
    except Exception:
        return None
    if root.tag != "Creature":
        return None

    bc = None
    growth: Optional[int] = None
    abilities: List[str] = []

    base = root.find("./BaseCreature")
    if base is not None and (base.text or "").strip():
        bc = base.text.strip()

    g = root.find("./WeeklyGrowth")
    if g is not None:
        t = (g.text or "").strip()
        if t.isdigit():
            growth = int(t)

    abil_parent = root.find("./Abilities")
    if abil_parent is not None:
        for it in abil_parent.findall("./Item"):
            t = (it.text or "").strip()
            if t:
                abilities.append(t)

    return (bc, growth, abilities) if bc else None

# ──────────────────────────────────────────────────────────────────────────────
# Spell parsing (from .xdb)
# ──────────────────────────────────────────────────────────────────────────────

def normalize_spell_code(stem: str) -> str:
    base = re.sub(r"[^0-9A-Za-z]+", "_", stem)
    base = re.sub(r"_{2,}", "_", base).strip("_")
    return f"SPELL_{base.upper()}" if base else "SPELL_UNKNOWN"

def parse_spell_xdb(path: Path) -> Optional[Dict[str, str]]:
    """
    Returns dict with keys: code_name, record_id, school, level; or None if invalid.
    If root tag != Spell, ignored (supports future override if needed).
    """
    try:
        tree = ET.parse(path)
        root = tree.getroot()
    except Exception:
        return None
    if root.tag != "Spell":
        return None

    record_id = (root.attrib.get("ObjectRecordID") or "").strip()
    school, level = "", ""
    for ch in root:
        tag = ch.tag
        if tag == "MagicSchool":
            school = (ch.text or "").strip()
        elif tag == "Level":
            level = (ch.text or "").strip()
    code_name = normalize_spell_code(path.stem)
    return {
        "code_name": code_name,
        "record_id": record_id,
        "school": school or "MAGIC_SCHOOL_UNKNOWN",
        "level": level or "0",
    }

# ──────────────────────────────────────────────────────────────────────────────
# Lua writers — read-only tables and dot-notation
# ──────────────────────────────────────────────────────────────────────────────

def lua_header_common() -> str:
    return """-- THIS FILE IS AUTO-GENERATED. DO NOT EDIT BY HAND.
-- Source: h5_exporter.py
-- Purpose: read-only enums and resolvers for MMH55 scripts

local function _freeze(t)
  local function freeze(tbl, path)
    for k, v in pairs(tbl) do
      if type(v) == "table" then freeze(v, (path and (path.."."..tostring(k)) or tostring(k))) end
    end
    local mt = {
      __newindex = function(_, key, _)
        error("Attempt to modify read-only table at key '"..tostring(key).."' ("..(path or "?")..")", 2)
      end,
      __metatable = "READONLY",
    }
    return setmetatable(tbl, mt)
  end
  return freeze(t, nil)
end

"""

def write_lua_creatures(out: Path, base_map: Dict[str, Dict], ability_enums: Dict[str, int]) -> None:
    lines: List[str] = []
    lines.append(lua_header_common())
    lines.append("-- CREATURES — dot-notation and read-only per-object tables\n")
    lines.append("if not CREATURE then CREATURE = {} end\n")
    lines.append("if not ABILITIES then ABILITIES = {} end\n")
    lines.append("ABILITIES.CREATURES = ABILITIES.CREATURES or {}\n")

    # ABILITIES.CREATURES (const->id or nil)
    for aname, aid in sorted(ability_enums.items()):
        lines.append(f"ABILITIES.CREATURES['{aname}'] = {aid}\n")
    lines.append("\n")

    # CREATURE.<TOKEN> = { name="CREATURE_PEASANT", id=..., BASE_GROWTH=..., ABILITIES={ ... } }
    for bc, obj in sorted(base_map.items()):
        token = bc.split("CREATURE_", 1)[-1]
        # id might be None if types.xml doesn't enumerate it
        id_str = "nil" if obj.get("id") is None else str(obj["id"])
        growth = int(obj.get("BASE_GROWTH", 0) or 0)
        abilities = obj.get("ABILITIES", [])
        # reserve ordering for determinism
        abilities = sorted(set(abilities))
        # emit
        lines.append(f"CREATURE.{token} = _freeze({{ name = '{bc}', id = {id_str}, BASE_GROWTH = {growth}, ABILITIES = {{ ")
        lines.extend([f"'{a}', " for a in abilities])
        lines.append("} }) )\n")

    # Freeze top-level
    lines.append("\nCREATURE = _freeze(CREATURE)\n")
    lines.append("ABILITIES = _freeze(ABILITIES)\n")

    out.write_text("".join(lines), encoding="utf-8")

def write_lua_spells(out: Path, spells: List[Dict[str, str]], spell_enums: Dict[str, int]) -> None:
    # Build helpers for by_id and by_school
    by_school: Dict[str, List[str]] = {}
    for s in spells:
        by_school.setdefault(s["school"], []).append(s["code_name"])

    lines: List[str] = []
    lines.append(lua_header_common())
    lines.append("-- SPELLS — dot-notation, read-only, plus by-id and by-school\n")
    lines.append("if not SPELL then SPELL = {} end\n")
    lines.append("if not SPELL_BY_ID then SPELL_BY_ID = {} end\n")
    lines.append("if not SPELLS_BY_SCHOOL then SPELLS_BY_SCHOOL = {} end\n")

    # SPELL.<TOKEN>
    for s in sorted(spells, key=lambda x: x["code_name"]):
        token = s["code_name"].split("SPELL_", 1)[-1]
        # Prefer types.xml enum id, fallback to ObjectRecordID if present
        sid = spell_enums.get(s["code_name"], None)
        if sid is None and s["record_id"].isdigit():
            sid = int(s["record_id"])
        id_str = "nil" if sid is None else str(sid)
        level = int(s["level"] or "0")
        lines.append(f"SPELL.{token} = _freeze({{ name = '{s['code_name']}', id = {id_str}, school = '{s['school']}', level = {level} }})\n")

    # SPELL_BY_ID
    lines.append("\n-- SPELL_BY_ID\n")
    for s in spells:
        sid = spell_enums.get(s["code_name"], None)
        if sid is None and s["record_id"].isdigit():
            sid = int(s["record_id"])
        if sid is not None:
            token = s["code_name"].split("SPELL_", 1)[-1]
            lines.append(f"SPELL_BY_ID[{sid}] = SPELL.{token}\n")

    # SPELLS_BY_SCHOOL
    lines.append("\n-- SPELLS_BY_SCHOOL\n")
    for school, arr in sorted(by_school.items()):
        lines.append(f"SPELLS_BY_SCHOOL['{school}'] = _freeze({{ ")
        for cn in sorted(arr):
            token = cn.split("SPELL_", 1)[-1]
            lines.append(f"SPELL.{token}, ")
        lines.append("})\n")

    # Freeze top-level
    lines.append("\nSPELL = _freeze(SPELL)\n")
    lines.append("SPELL_BY_ID = _freeze(SPELL_BY_ID)\n")
    lines.append("SPELLS_BY_SCHOOL = _freeze(SPELLS_BY_SCHOOL)\n")

    out.write_text("".join(lines), encoding="utf-8")

# ──────────────────────────────────────────────────────────────────────────────
# Export routines
# ──────────────────────────────────────────────────────────────────────────────

def discover_and_sanity(repo_root: Path, types_xml: Path, creatures_dir: Path, magic_dir: Path) -> Tuple[int, int, Dict[str,int], Dict[str,int]]:
    title("types.xml sanity")
    if not types_xml.exists():
        err(f"types.xml is missing at {types_xml}")
        return (0, 0, {}, {})
    # light-weight counts
    txt = types_xml.read_text(encoding="utf-8", errors="ignore")
    n_type = len(re.findall(r'<\s*Type\b', txt))
    n_item = len(re.findall(r'<\s*Item\b', txt))
    nodes = len(re.findall(r'<', txt))
    info(f"Root tag: <Base> (assumed)")
    info(f"Found {n_item} <Item> elements")
    info(f"Found {n_type} <Type> elements")
    info(f"Total XML nodes counted: {nodes}")

    title("discovery")
    n_cre = 0
    n_sp  = 0
    if creatures_dir.is_dir():
        files = rglob_xdb(creatures_dir)
        n_cre = len(files)
    if magic_dir.is_dir():
        files = rglob_xdb(magic_dir)
        n_sp  = len(files)
    info(f"Creatures: {n_cre} file(s) matching ('.xdb',)")
    info(f"MAGIC    : {n_sp} file(s) matching ('.xdb',)")

    # Load enums
    creature_enums = load_enums(types_xml, "CREATURE_")
    ability_enums  = load_enums(types_xml, "ABILITY_")
    return (n_cre, n_sp, creature_enums, ability_enums)

def export_creatures(types_xml: Path, creatures_dir: Path, out_dir: Path, dry_run: bool, strict: bool) -> None:
    title("creatures export")
    creature_ids = load_enums(types_xml, "CREATURE_")
    ability_ids  = load_enums(types_xml, "ABILITY_")

    files = [p for p in rglob_xdb(creatures_dir) if quick_root_tag(p) == "Creature"]
    if not files and strict:
        err("No Creature .xdb files found.")
        return

    base_map: Dict[str, Dict] = {}
    for i, p in enumerate(files, 1):
        parsed = parse_creature_xdb(p)
        if not parsed:
            continue
        bc, growth, abil_list = parsed
        ent = base_map.setdefault(bc, {"BASE_GROWTH": 0, "_growths": [], "ABILITIES": []})
        if growth is not None:
            ent["_growths"].append(growth)
            if not ent["BASE_GROWTH"]:
                ent["BASE_GROWTH"] = growth
        if abil_list:
            ent["ABILITIES"].extend(abil_list)

        if i % 50 == 0:
            info(f"  parsed {i}/{len(files)}...")

    # Dedup & attach IDs
    growth_conflicts = []
    missing_ids = []
    for bc, obj in base_map.items():
        obj["ABILITIES"] = sorted(set(obj.get("ABILITIES", [])))
        obj["id"] = creature_ids.get(bc)  # may be None if not in types.xml
        if obj["id"] is None:
            missing_ids.append(bc)
        gset = sorted(set(obj.get("_growths", [])))
        if len(gset) > 1:
            growth_conflicts.append((bc, gset))
        obj.pop("_growths", None)

    info(f"Bases discovered : {len(base_map)}")
    info(f"Ability enums    : {len(ability_ids)}")
    info("Preview (first 5):")
    for bc, obj in list(sorted(base_map.items()))[:5]:
        info(f"  {bc}: id={obj.get('id')} growth={obj.get('BASE_GROWTH')} abilities={len(obj.get('ABILITIES', []))}")
    if missing_ids:
        warn(f"{len(missing_ids)} base creature(s) missing numeric ID in types.xml (first: {missing_ids[0]}).")
    if growth_conflicts:
        warn(f"{len(growth_conflicts)} base creature(s) with conflicting WeeklyGrowth (first: {growth_conflicts[0]}).")

    # Output
    out_file = out_dir / "h55_enums_creatures.lua"
    info(f"Planned output: {out_file}")
    if dry_run:
        info("Dry-run; not writing Lua.")
        return
    write_lua_creatures(out_file, base_map, ability_ids)
    info(f"Wrote {out_file}")

def export_spells(types_xml: Path, magic_dir: Path, out_dir: Path, dry_run: bool, strict: bool) -> None:
    title("spells export")
    spell_enums = load_enums(types_xml, "SPELL_")

    files = [p for p in rglob_xdb(magic_dir) if quick_root_tag(p) == "Spell"]
    if not files and strict:
        err("No Spell .xdb files found.")
        return

    spells: List[Dict[str, str]] = []
    for i, p in enumerate(files, 1):
        rec = parse_spell_xdb(p)
        if rec:
            spells.append(rec)
        if i % 50 == 0:
            info(f"  parsed {i}/{len(files)}...")

    info(f"Spells discovered: {len(spells)}")
    if not spells and strict:
        err("No valid <Spell> files parsed.")
        return

    out_file = out_dir / "h55_enums_spells.lua"
    info(f"Planned output: {out_file}")
    if dry_run:
        info("Dry-run; not writing Lua.")
        return
    write_lua_spells(out_file, spells, spell_enums)
    info(f"Wrote {out_file}")

# ──────────────────────────────────────────────────────────────────────────────
# Output directory logic (overwrite vs timestamped)
# ──────────────────────────────────────────────────────────────────────────────

def prepare_out_dir(base_dir: Path, overwrite: bool, dry_run: bool) -> Path:
    base_dir.mkdir(parents=True, exist_ok=True)
    # If directory has files and overwrite is False -> timestamped clone
    files_present = any(base_dir.glob("*"))
    if files_present and not overwrite:
        stamp = time.strftime("%Y%m%d_%H%M%S")
        new_dir = base_dir.parent / f"{base_dir.name}_{stamp}"
        info(f"Existing files detected; using timestamped directory: {new_dir}")
        if not dry_run:
            new_dir.mkdir(parents=True, exist_ok=True)
        return new_dir
    else:
        info(f"Using output directory: {base_dir}")
        return base_dir

# ──────────────────────────────────────────────────────────────────────────────
# State machine / interactive menu
# ──────────────────────────────────────────────────────────────────────────────

class State:
    MENU = "MENU"
    EXPORT_CREATURES = "EXPORT_CREATURES"
    EXPORT_SPELLS = "EXPORT_SPELLS"
    EXPORT_BOTH = "EXPORT_BOTH"
    RESCAN = "RESCAN"
    QUIT = "QUIT"

def interactive_loop(args) -> int:
    script_path = Path(__file__).resolve()
    repo_root = guess_repo_root(script_path)
    local_dir = resolve(repo_root, args.local)
    creatures_dir = resolve(repo_root, args.creatures)
    magic_dir = resolve(repo_root, args.magic)
    types_xml = resolve(repo_root, args.types)

    title("HOMM5 Build Helper")
    info(f"Script path       : {script_path}")
    info(f"Detected repo root: {repo_root}")
    info(f"Using LOCAL_DIR   : {local_dir}")
    info(f"Using types.xml   : {types_xml}")

    # Initial scan
    n_cre, n_sp, creature_enums, ability_enums = discover_and_sanity(repo_root, types_xml, creatures_dir, magic_dir)

    state = State.MENU
    while state != State.QUIT:
        if state in (State.MENU, State.RESCAN):
            print("\nWhat do you want to do?")
            print("  1) Export CREATURES  -> h55_enums_creatures.lua")
            print("  2) Export SPELLS     -> h55_enums_spells.lua")
            print("  3) Export BOTH")
            print("  4) Show status / rescan")
            print("  5) Quit")
            sel = "5" if args.yes else input("Select [1-5]: ").strip()
            state = {
                "1": State.EXPORT_CREATURES,
                "2": State.EXPORT_SPELLS,
                "3": State.EXPORT_BOTH,
                "4": State.RESCAN,
            }.get(sel, State.QUIT)

        if state == State.RESCAN:
            n_cre, n_sp, creature_enums, ability_enums = discover_and_sanity(repo_root, types_xml, creatures_dir, magic_dir)
            state = State.MENU
            continue

        # Prepare output directory (overwrite/timestamped)
        base_out = resolve(repo_root, args.out_dir)
        # In interactive mode, ask overwrite preference if not specified
        overwrite = args.overwrite
        if not args.yes and not args.overwrite and not args.timestamp:
            print("\nOutput folder behavior:")
            print("  1) Overwrite existing files in COMPILED_LUA")
            print("  2) Create NEW folder with timestamp")
            sel = input("Select [1-2]: ").strip()
            if sel == "1":
                overwrite = True
            else:
                overwrite = False
        elif args.timestamp:
            overwrite = False
        out_dir = prepare_out_dir(base_out, overwrite, args.dry_run)

        if state == State.EXPORT_CREATURES:
            export_creatures(types_xml, creatures_dir, out_dir, args.dry_run, args.strict)
            state = State.MENU
            continue

        if state == State.EXPORT_SPELLS:
            export_spells(types_xml, magic_dir, out_dir, args.dry_run, args.strict)
            state = State.MENU
            continue

        if state == State.EXPORT_BOTH:
            export_creatures(types_xml, creatures_dir, out_dir, args.dry_run, args.strict)
            export_spells(types_xml, magic_dir, out_dir, args.dry_run, args.strict)
            state = State.MENU
            continue

    info("Bye.")
    return 0

# ──────────────────────────────────────────────────────────────────────────────
# CLI
# ──────────────────────────────────────────────────────────────────────────────

def main(argv: List[str]) -> int:
    ap = argparse.ArgumentParser(description="HOMM5 Build Helper — unified exporter")
    ap.add_argument("--local", default="./LOCAL_DIR", help="Path to LOCAL_DIR repo folder")
    ap.add_argument("--types", default="./git_docs/types.xml", help="Path to types.xml")
    ap.add_argument("--creatures", default="./LOCAL_DIR/Creatures", help="Creatures root folder")
    ap.add_argument("--magic", default="./LOCAL_DIR/MAGIC", help="MAGIC root folder")
    ap.add_argument("--out-dir", default="./LOCAL_DIR/COMPILED_LUA", help="Output directory for *.lua")
    ap.add_argument("--dry-run", action="store_true", help="Plan-only; do not write files")
    ap.add_argument("--yes", action="store_true", help="Non-interactive (choose defaults)")
    ap.add_argument("--strict", action="store_true", help="Fail when inputs are missing or invalid")
    ap.add_argument("--overwrite", action="store_true", help="Force overwrite in COMPILED_LUA")
    ap.add_argument("--timestamp", action="store_true", help="Force writing to timestamped directory")
    ap.add_argument("--skip-creatures", action="store_true", help="Skip creatures export in BOTH mode")
    ap.add_argument("--skip-spells", action="store_true", help="Skip spells export in BOTH mode")

    args = ap.parse_args(argv)
    return interactive_loop(args)

if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
