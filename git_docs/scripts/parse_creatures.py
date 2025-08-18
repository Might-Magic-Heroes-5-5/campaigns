#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Generate read-only Lua enums/tables for MMH55 creatures and creature abilities.

OUTPUT:
  - h55_enums_creatures.lua

REQUIREMENTS:
  - Python 3.8+
  - A valid Heroes V `types.xml` that contains engine enums with numeric IDs:
      • CREATURE_* (creature types)
      • ABILITY_*  (creature abilities)
  - Creature .xdb files (root tag <Creature>) somewhere under --root.

The script scans *.xdb under --root recursively, keeps only files whose root
tag is <Creature>, extracts:
  • WeeklyGrowth (BASE_GROWTH)
  • Abilities/Item [...] -> ABILITY_* names (verified via types.xml)
…and joins that with engine IDs from types.xml.

We enforce "no placeholders":
  - If `types.xml` is missing, unreadable, or does not contain needed enums,
    the script exits with an ACTUAL_DATA error explaining what's missing.

USAGE:
  python parse_creatures_to_lua.py \
      --root "C:/GOG Galaxy/Games/campaigns" \
      --types "C:/GOG Galaxy/Games/campaigns/types.xml" \
      --out "h55_enums_creatures.lua"

Notes:
  - Enum name matching: a file like "GremlinSaboteur.xdb" is matched with
    `CREATURE_GREMLIN_SABOTEUR` via a slug (lowercased, underscores removed).
  - If a creature XDB is found but no matching engine enum exists in types.xml,
    the script exits with ACTUAL_DATA telling you to add/patch types.xml.
  - ABILITIES.CREATURES is taken from types.xml (not “what creatures happen
    to use”); the per-creature ABILITIES list is the *names* (not numbers),
    since the enum table maps names→ids and is available globally in Lua.

This script does not depend on any external library (stdlib only).
"""

from __future__ import annotations
import argparse
import os
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Dict, List, Optional, Tuple

# --------------------------- Utility: fatal & ACTUAL_DATA -------------------- #

def die(msg: str, code: int = 2) -> "NoReturn":  # type: ignore[valid-type]
    sys.stderr.write(msg.strip() + "\n")
    sys.exit(code)

def ad_err(missing: str, hint: str) -> None:
    die(f"ACTUAL_DATA REQUIRED: {missing}\nHINT: {hint}")

# ---------------------- Load & normalize enums from types.xml ---------------- #

_ENUM_PATTERNS = (
    # <Item name="CREATURE_PEASANT" value="777" />
    (r'name\s*=\s*"(?P<name>[A-Z0-9_]+)"[^>]*?\b(?:value|val|id)\s*=\s*"(?P<val>\d+)"', re.I),
    # <name>CREATURE_PEASANT</name> ... <value>777</value>
    (r'<name>\s*(?P<name>[A-Z0-9_]+)\s*</name>.*?<value>\s*(?P<val>\d+)\s*</value>', re.I | re.S),
    # CREATURE_PEASANT = 777 (fallback if present)
    (r'(?P<name>[A-Z0-9_]+)\s*=\s*(?P<val>\d+)', re.I),
)

def _extract_enum_map(text: str, prefix: str) -> Dict[str, int]:
    """Tolerant regex-based extractor for name->id where names start with prefix."""
    out: Dict[str, int] = {}
    for pat, flags in _ENUM_PATTERNS:
        for m in re.finditer(pat, text, flags):
            name = m.group("name")
            if not name.startswith(prefix):
                continue
            val = int(m.group("val"))
            # First one wins to avoid accidental overrides across patterns
            out.setdefault(name, val)
    return out

def load_types_enums(types_xml: Path) -> Tuple[Dict[str, int], Dict[str, int], Dict[str, int]]:
    """
    Returns (creature_map, ability_map, spell_map) from types.xml.

    Each mapping is NAME -> numeric id. Exits with ACTUAL_DATA error if missing.
    """
    if not types_xml.exists():
        ad_err(
            f"types.xml not found at: {types_xml}",
            "Export or copy your game's types.xml and pass its path using --types PATH."
        )

    text = types_xml.read_text(encoding="utf-8", errors="ignore")

    creatures = _extract_enum_map(text, "CREATURE_")
    abilities = _extract_enum_map(text, "ABILITY_")
    spells    = _extract_enum_map(text, "SPELL_")

    if not creatures:
        ad_err("CREATURE_* enums not found in types.xml.",
               "Ensure your types.xml includes creature enum names and numeric values.")
    if not abilities:
        ad_err("ABILITY_* enums not found in types.xml.",
               "Ensure your types.xml includes creature ability enum names and numeric values.")

    # Spells aren't mandatory for this script; we return them to help the spells generator.
    return (creatures, abilities, spells)

# --------------------------- Creature XDB parsing ---------------------------- #

def _read_root_tag(xdb_path: Path) -> Optional[str]:
    try:
        # Fast sniff: read up to first 2KB and extract the first tag after XML decl
        head = xdb_path.read_text(encoding="utf-8", errors="ignore")[:2048]
        m = re.search(r'<\s*([A-Za-z0-9_]+)\b', head)
        return m.group(1) if m else None
    except Exception:
        return None

def parse_creature_xdb(xdb_path: Path) -> Tuple[int, List[str]]:
    """
    Parse a <Creature> .xdb.
    Returns (base_growth, ability_names_list).

    Raises ACTUAL_DATA error if WeeklyGrowth missing.
    """
    txt = xdb_path.read_text(encoding="utf-8", errors="ignore")

    # WeeklyGrowth
    gm = re.search(r'<\s*WeeklyGrowth\s*>\s*(\d+)\s*<\s*/\s*WeeklyGrowth\s*>', txt, re.I)
    if not gm:
        ad_err(f"WeeklyGrowth missing in: {xdb_path}",
               "Open the creature .xdb and confirm <WeeklyGrowth>...</WeeklyGrowth> exists.")

    base_growth = int(gm.group(1))

    # Abilities: <Abilities><Item>ABILITY_...</Item>...</Abilities>
    ability_names: List[str] = []
    ab_block = re.search(r'<\s*Abilities\s*>(.*?)</\s*Abilities\s*>', txt, re.I | re.S)
    if ab_block:
        for m in re.finditer(r'<\s*Item\s*>\s*([A-Z0-9_]+)\s*<\s*/\s*Item\s*>', ab_block.group(1), re.I):
            name = m.group(1).strip()
            # Keep only ABILITY_*; ignore any other accidental tokens
            if name.startswith("ABILITY_"):
                ability_names.append(name)

    return base_growth, ability_names

# ------------------------ Name matching (file <-> enum) ---------------------- #

def slugify(s: str) -> str:
    return re.sub(r'[^a-z0-9]+', '', s.lower())

def best_match_creature_enum(file_stem: str, creature_enums: Dict[str, int]) -> Optional[str]:
    """
    Try to match `GremlinSaboteur` -> CREATURE_GREMLIN_SABOTEUR, `DjinnVizier` -> CREATURE_DJINN_VIZIER, etc.
    """
    fs = slugify(file_stem)
    # precompute lookup: slug("CREATURE_GREMLIN_SABOTEUR") -> "CREATURE_GREMLIN_SABOTEUR"
    # cacheable for speed, but one-shot is fine
    candidates = []
    for name in creature_enums.keys():
        cslug = slugify(name.replace("CREATURE_", ""))
        if cslug == fs:
            return name
        # record closeness for fallback (prefix match)
        if cslug.startswith(fs) or fs.startswith(cslug):
            candidates.append((len(os.path.commonprefix([cslug, fs])), name))
    if candidates:
        # pick the closest
        candidates.sort(reverse=True)
        return candidates[0][1]
    return None

# ------------------------------ Lua emitters -------------------------------- #

def lua_header() -> str:
    return """-- THIS FILE IS AUTO-GENERATED. DO NOT EDIT BY HAND.
-- Source: parse_creatures_to_lua.py
-- Purpose: Read-only creature enums (CREATURE.* objects) and ABILITIES.CREATURES
--          Each creature object contains: name, id, BASE_GROWTH, ABILITIES (list)

-- Deep-readonly (freeze) helper; protects nested tables.
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

def lua_footer() -> str:
    return "\n-- End of auto-generated file.\n"

def emit_lua_creatures(
    out_path: Path,
    creatures_data: Dict[str, Dict],
    abilities_enum: Dict[str, int],
) -> None:
    """
    creatures_data: { "CREATURE_PEASANT": {"id": 1, "BASE_GROWTH": 5, "ABILITIES": ["ABILITY_X", ...]} }
    abilities_enum: { "ABILITY_X": 100, ... }
    """
    lines: List[str] = []
    lines.append(lua_header())

    # ABILITIES.CREATURES
    lines.append("ABILITIES = ABILITIES or {}\n")
    lines.append("ABILITIES.CREATURES = _freeze({\n")
    for name in sorted(abilities_enum.keys()):
        lines.append(f"  {name} = {abilities_enum[name]},\n")
    lines.append("})\n\n")

    # CREATURE and CREATURE_BY_ID
    lines.append("CREATURE = _freeze({})\n")
    lines.append("CREATURE_BY_ID = _freeze({})\n\n")

    # Emit each creature as read-only object, plus reverse lookup
    for cname in sorted(creatures_data.keys()):
        c = creatures_data[cname]
        simple = cname.replace("CREATURE_", "")
        # Abilities list: keep as names; the ABILITIES.CREATURES table maps names->ids globally
        abl = c.get("ABILITIES", [])
        abl_lua = ", ".join(abl) if abl else ""
        lines.append(f"CREATURE.{simple} = _freeze({{\n")
        lines.append(f'  name = "{cname}",\n')
        lines.append(f"  id = {c['id']},\n")
        lines.append(f"  BASE_GROWTH = {c['BASE_GROWTH']},\n")
        lines.append(f"  ABILITIES = _freeze({{{ {abl_lua} }}}),\n")
        lines.append("})\n")
        lines.append(f"CREATURE_BY_ID[{c['id']}] = CREATURE.{simple}\n\n")

    # Freeze the top-level tables again to ensure final lock (idempotent)
    lines.append("CREATURE = _freeze(CREATURE)\n")
    lines.append("CREATURE_BY_ID = _freeze(CREATURE_BY_ID)\n")
    lines.append(lua_footer())

    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text("".join(lines), encoding="utf-8")

# ------------------------------- Main logic --------------------------------- #

def main(argv: Optional[List[str]] = None) -> int:
    ap = argparse.ArgumentParser(description="Generate read-only Lua enums for creatures.")
    ap.add_argument("--root", type=Path, default=Path("."), help="Root directory to scan recursively for creature .xdb")
    ap.add_argument("--types", type=Path, required=True, help="Path to types.xml containing engine enums")
    ap.add_argument("--out", type=Path, default=Path("h55_enums_creatures.lua"), help="Output Lua file")
    args = ap.parse_args(argv)

    creature_map, ability_map, _spell_map = load_types_enums(args.types)

    # Scan *.xdb under root and keep only <Creature> roots
    xdb_files: List[Path] = []
    for p in args.root.rglob("*.xdb"):
        tag = _read_root_tag(p)
        if tag == "Creature":
            xdb_files.append(p)

    if not xdb_files:
        ad_err("No creature .xdb files found under --root.",
               "Point --root to the folder that contains 'Creatures' subdirectories with .xdb files.")

    # Build creatures_data
    creatures_data: Dict[str, Dict] = {}
    unmatched_files: List[Path] = []

    for xdb in xdb_files:
        stem = xdb.stem  # e.g. "GremlinSaboteur"
        growth, abl_names = parse_creature_xdb(xdb)

        # Match file to engine enum name (CREATURE_XXX)
        enum_name = best_match_creature_enum(stem, creature_map)
        if not enum_name:
            unmatched_files.append(xdb)
            continue

        cid = creature_map.get(enum_name)
        if cid is None:
            ad_err(f"Engine id missing for {enum_name} in types.xml.",
                   "Patch your types.xml so all CREATURE_* names have integer values.")

        # Validate abilities against types.xml (warn if unknown)
        valid_abilities: List[str] = []
        unknown_abilities: List[str] = []
        for a in abl_names:
            if a in ability_map:
                valid_abilities.append(a)
            else:
                unknown_abilities.append(a)

        if unknown_abilities:
            ad_err(
                f"Unknown ability enums in {xdb} : {', '.join(unknown_abilities)}",
                "Your types.xml must include all ABILITY_* enums used by creature .xdb files."
            )

        creatures_data[enum_name] = {
            "id": cid,
            "BASE_GROWTH": growth,
            "ABILITIES": valid_abilities,
        }

    if unmatched_files:
        # Fail fast with precise actionable info
        details = "\n  ".join(str(p) for p in unmatched_files[:8])
        more = "" if len(unmatched_files) <= 8 else f"\n  ... and {len(unmatched_files)-8} more."
        ad_err(
            "One or more creature files could not be matched to engine enums in types.xml.",
            "Ensure types.xml contains CREATURE_* names that correspond to your XDB file names "
            "by normalized slug (e.g., 'GremlinSaboteur' -> 'CREATURE_GREMLIN_SABOTEUR').\n"
            f"Unmatched files (first few):\n  {details}{more}"
        )

    # Emit Lua
    emit_lua_creatures(args.out, creatures_data, ability_map)
    print(f"[OK] Wrote {args.out} ({len(creatures_data)} creatures, {len(ability_map)} ability enums).")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
