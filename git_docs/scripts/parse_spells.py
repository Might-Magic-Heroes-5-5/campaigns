#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Parse Heroes V .xdb (XML) spell files and output:
  - CSV / Markdown (optional, for docs)
  - Read-only Lua enums/tables (SPELL, SPELL_BY_ID, SPELLS_BY_SCHOOL)

USAGE (Lua):
  python parse_spells.py --root ./LOCAL_DIR --types ./types.xml --lua h55_enums_spells.lua

REQUIREMENTS:
  - A valid Heroes V `types.xml` (for SPELL_* -> numeric id)
  - *.xdb files whose root tag is <Spell> under --root

The Lua file defines:
  SPELL.BLIND = { name="SPELL_BLIND", id=8, school="MAGIC_SCHOOL_LIGHT", level=4 }
  SPELL_BY_ID[8] = SPELL.BLIND
  SPELLS_BY_SCHOOL.MAGIC_SCHOOL_LIGHT = { SPELL.BLIND, SPELL.WORD_OF_LIGHT, ... }

All tables are deeply **read-only** at runtime.
"""
from __future__ import annotations
import argparse
import csv
import io
import os
import re
import sys
from pathlib import Path
from typing import Dict, List, Optional, Tuple

def die(msg: str, code: int = 2):
    sys.stderr.write(msg.strip() + "\n")
    sys.exit(code)

def ad_err(missing: str, hint: str):
    die(f"ACTUAL_DATA REQUIRED: {missing}\nHINT: {hint}")

# --- types.xml enums -------------------------------------------------------- #

_ENUM_PATTERNS = (
    (r'name\s*=\s*"(?P<name>[A-Z0-9_]+)"[^>]*?\b(?:value|val|id)\s*=\s*"(?P<val>\d+)"', re.I),
    (r'<name>\s*(?P<name>[A-Z0-9_]+)\s*</name>.*?<value>\s*(?P<val>\d+)\s*</value>', re.I | re.S),
    (r'(?P<name>[A-Z0-9_]+)\s*=\s*(?P<val>\d+)', re.I),
)

def _extract_enum_map(text: str, prefix: str) -> Dict[str, int]:
    out: Dict[str, int] = {}
    for pat, flags in _ENUM_PATTERNS:
        for m in re.finditer(pat, text, flags):
            name = m.group("name")
            if not name.startswith(prefix):
                continue
            val = int(m.group("val"))
            out.setdefault(name, val)
    return out

def load_spell_enums(types_xml: Path) -> Dict[str, int]:
    if not types_xml.exists():
        ad_err(f"types.xml not found at: {types_xml}",
               "Export/copy your types.xml and pass it via --types PATH.")
    text = types_xml.read_text(encoding="utf-8", errors="ignore")
    spells = _extract_enum_map(text, "SPELL_")
    if not spells:
        ad_err("SPELL_* enums not found in types.xml.",
               "Ensure types.xml includes all SPELL_* names with integer values.")
    return spells

# --- scanning & parsing ----------------------------------------------------- #

def _root_tag(path: Path) -> Optional[str]:
    try:
        head = path.read_text(encoding="utf-8", errors="ignore")[:2048]
        m = re.search(r'<\s*([A-Za-z0-9_]+)\b', head)
        return m.group(1) if m else None
    except Exception:
        return None

def parse_spell_xdb(xdb: Path) -> Optional[Dict[str, str]]:
    """Returns dict with code_name, record_id, school, level; or None if invalid."""
    txt = xdb.read_text(encoding="utf-8", errors="ignore")
    # ObjectRecordID (attribute)
    rid = re.search(r'ObjectRecordID\s*=\s*"(\d+)"', txt)
    if not rid:
        return None
    school = None
    mschool = re.search(r'<\s*MagicSchool\s*>\s*([A-Z0-9_]+)\s*<\s*/\s*MagicSchool\s*>', txt, re.I)
    if mschool:
        school = mschool.group(1).strip()
    level = None
    mlev = re.search(r'<\s*Level\s*>\s*(\d+)\s*<\s*/\s*Level\s*>', txt, re.I)
    if mlev:
        level = mlev.group(1).strip()
    code_name = "SPELL_" + re.sub(r'[^A-Za-z0-9]+', '_', xdb.stem).upper()
    return {
        "code_name": code_name,
        "record_id": rid.group(1),
        "school": school or "MAGIC_SCHOOL_UNKNOWN",
        "level": level or "0",
    }

# --- Lua writer ------------------------------------------------------------- #

def lua_header() -> str:
    return """-- THIS FILE IS AUTO-GENERATED. DO NOT EDIT BY HAND.
-- Source: parse_spells.py --lua
-- Purpose: read-only spell enums (SPELL), plus SPELL_BY_ID and SPELLS_BY_SCHOOL

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

def write_lua(spells: List[Dict[str, str]], spell_enums: Dict[str, int], out_path: Path) -> None:
    # normalize + join with enums (id)
    joined: List[Dict[str, str]] = []
    missing = []
    for s in spells:
        name = s["code_name"]
        sid = spell_enums.get(name)
        if sid is None:
            missing.append(name)
            continue
        joined.append({
            "name": name,
            "id": sid,
            "school": s["school"],
            "level": s["level"],
        })
    if missing:
        ad_err(
            "Spells missing from types.xml: " + ", ".join(missing[:12]) + (" ..." if len(missing) > 12 else ""),
            "Update your types.xml so that all SPELL_* names exist and have numeric values."
        )

    lines: List[str] = []
    lines.append(lua_header())
    lines.append("SPELL = {}\nSPELL_BY_ID = {}\nSPELLS_BY_SCHOOL = {}\n\n")

    # Emit SPELL and BY_ID
    for s in sorted(joined, key=lambda x: x["name"]):
        short = s["name"].replace("SPELL_", "")
        lines.append(f"SPELL.{short} = _freeze({{ name = \"{s['name']}\", id = {s['id']}, school = \"{s['school']}\", level = {s['level']} }})\n")
        lines.append(f"SPELL_BY_ID[{s['id']}] = SPELL.{short}\n")

    # Group by school
    school_map: Dict[str, List[str]] = {}
    for s in joined:
        school_map.setdefault(s["school"], []).append(s["name"].replace("SPELL_", ""))

    lines.append("\n-- Group by school\n")
    for school in sorted(school_map.keys()):
        items = ", ".join([f"SPELL.{n}" for n in sorted(school_map[school])])
        lines.append(f"SPELLS_BY_SCHOOL.{school} = _freeze({{{ {items} }}})\n")

    lines.append("\nSPELL = _freeze(SPELL)\nSPELL_BY_ID = _freeze(SPELL_BY_ID)\nSPELLS_BY_SCHOOL = _freeze(SPELLS_BY_SCHOOL)\n")
    lines.append("-- End of auto-generated file.\n")

    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text("".join(lines), encoding="utf-8")

# --- CLI -------------------------------------------------------------------- #

def main(argv: Optional[List[str]] = None) -> int:
    ap = argparse.ArgumentParser(description="Parse H5 spells -> CSV/MD/Lua.")
    ap.add_argument("--root", type=Path, default=Path("./LOCAL_DIR"), help="Root to scan recursively for *.xdb")
    ap.add_argument("--types", type=Path, required=True, help="Path to types.xml with SPELL_* enums")
    ap.add_argument("--csv", type=Path, default=None, help="Optional CSV output path")
    ap.add_argument("--md", type=Path, default=None, help="Optional Markdown output path")
    ap.add_argument("--lua", type=Path, default=Path("h55_enums_spells.lua"), help="Lua output path")
    ap.add_argument("--stdout", choices=["md", "csv", "none"], default="none", help="Print to stdout")
    args = ap.parse_args(argv)

    spell_enums = load_spell_enums(args.types)

    xdbs = [p for p in args.root.rglob("*.xdb") if (_root_tag(p) == "Spell")]
    if not xdbs:
        ad_err("No <Spell> .xdb files found under --root.",
               "Point --root to the folder with your spell .xdb files.")

    rows: List[Dict[str, str]] = []
    for p in xdbs:
        item = parse_spell_xdb(p)
        if item:
            rows.append(item)

    if args.csv:
        fields = ["school", "level", "code_name", "record_id"]
        with args.csv.open("w", newline="", encoding="utf-8") as f:
            w = csv.DictWriter(f, fieldnames=fields)
            w.writeheader()
            for r in rows:
                w.writerow({k: r.get(k, "") for k in fields})

    if args.md:
        import io
        buf = io.StringIO()
        cols = ["School", "Level", "Code", "RecordID"]
        buf.write("| " + " | ".join(cols) + " |\n")
        buf.write("|" + "|".join(["---"] * len(cols)) + "|\n")
        for r in rows:
            buf.write(f"| {r['school']} | {r['level']} | {r['code_name']} | {r['record_id']} |\n")
        args.md.write_text(buf.getvalue(), encoding="utf-8")

    if args.lua:
        write_lua(rows, spell_enums, args.lua)

    if args.stdout == "md":
        print(Path(args.md or "spells.md").read_text() if args.md else "(stdout md requested but --md not provided)")
    elif args.stdout == "csv":
        print(Path(args.csv or "spells.csv").read_text() if args.csv else "(stdout csv requested but --csv not provided)")

    print(f"[OK] Spells parsed: {len(rows)}; Lua → {args.lua}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
