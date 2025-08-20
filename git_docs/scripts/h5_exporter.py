#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
HOMM5 Build Helper — single interactive CLI to export:
  • CREATURES .xdb -> h55_enums_creatures.lua (with CREATURE.<TOWN>.<NAME> readonly objects)
  • SPELLS    .xdb -> h55_enums_spells.lua

CHANGES (Lua 4.0 + Heroes V constraints)
----------------------------------------
• No local functions in generated Lua. All pseudo-locals use __h55__local_56424_* prefix.
• Shared helpers moved to ./scripts/h55_enum_runtime.lua and included with:
      doFile("./scripts/h55_enum_runtime.lua")
      while not __h55__local_56424_freeze do end
• Lua 4.0 compatible: no rawget, no setmetatable, no pairs/ipairs, no io.write, no booleans.
• The CLI writes the runtime file once into OUT_DIR/scripts/.

CONVENTIONS
-----------
• All I/O happens inside your repo tree, NOT the installed game.
• Repo root is inferred from this file’s location:
    <repo_root>/git_docs/scripts/h5_exporter.py
    <repo_root>/git_docs/types.xml
    <repo_root>/LOCAL_DIR/Creatures/...   (town subfolders)
    <repo_root>/LOCAL_DIR/MAGIC/...
    <repo_root>/LOCAL_DIR/COMPILED_LUA/...

• Creature ID resolution priority:
    1) types.xml (if resolvable)
    2) HOMM5_IDs_for_Scripts*.pdf  (requires PyPDF2; optional)
    3) h55_enum_framework*.lua      (local authoritative fallback; bundled in repo)

• WeeklyGrowth:
    – saved as BASE_GROWTH on each creature; NOT treated as unique.

• UNKNOWN creature:
    – hardcoded once, id 0, skipped from scanning.

• Abilities:
    – Extracted from each creature .xdb under <Abilities><Item>ABILITY_*</Item>.
    – A global ABILITIES.CREATURES table is generated (complete map if available).

USAGE
-----
  python h5_exporter.py [--strict] [--dry-run]
  (interactive menu follows)

Author: homm55 toolchain
"""

from __future__ import annotations
import argparse
import os
import re
import sys
import time
from pathlib import Path
from typing import Dict, List, Tuple, Optional, Iterable
import xml.etree.ElementTree as ET

# -----------------------------
# Pretty print helpers
# -----------------------------
def info(msg: str) -> None:
    print(f"[INFO] {msg}")

def warn(msg: str) -> None:
    print(f"[WARN] {msg}")

def err(msg: str) -> None:
    print(f"[ERR ] {msg}")

def header(title: str) -> None:
    print("\n" + title)
    print("=" * len(title))

def subheader(title: str) -> None:
    print("\n" + title)
    print("-" * len(title))

# -----------------------------
# Repo discovery
# -----------------------------
def detect_repo_root(script_path: Path) -> Path:
    """
    Walk upwards until we see a parent with 'git_docs' directory.
    """
    p = script_path.resolve()
    for parent in [p] + list(p.parents):
        if (parent / "git_docs").is_dir():
            return parent
    # fallback to two levels up
    return p.parent.parent

# -----------------------------
# Filesystem helpers
# -----------------------------
def ensure_dir(p: Path) -> None:
    p.mkdir(parents=True, exist_ok=True)

def list_files_recursive(root: Path, suffixes: Tuple[str, ...]) -> List[Path]:
    out: List[Path] = []
    if not root.exists():
        return out
    for base, _, files in os.walk(root):
        for fn in files:
            if fn.lower().endswith(suffixes):
                out.append(Path(base) / fn)
    return out

# -----------------------------
# XML parsing helpers
# -----------------------------
def read_xml(path: Path) -> Optional[ET.ElementTree]:
    try:
        return ET.parse(str(path))
    except Exception as e:
        warn(f"Failed to parse XML '{path}': {e}")
        return None

def text_of(elem: Optional[ET.Element]) -> Optional[str]:
    if elem is None:
        return None
    return elem.text.strip() if elem.text else None

# -----------------------------
# Ability & Creature ID sources
# -----------------------------
def try_load_ids_from_framework(repo_root: Path) -> Tuple[Dict[str, int], Dict[str, int]]:
    """
    Parse h55_enum_framework*.lua to get IDs:
      - creature_ids['CREATURE_ANGEL'] = 13
      - ability_ids['ABILITY_NO_MELEE_PENALTY'] = <num>
    """
    creature_ids: Dict[str, int] = {}
    ability_ids: Dict[str, int] = {}

    pattern_cre = re.compile(r'\bCREATURE_([A-Z0-9_]+)\s*=\s*(\d+)\b')
    pattern_abi = re.compile(r'\bABILITY_([A-Z0-9_]+)\s*=\s*(\d+)\b')

    candidates = list(repo_root.rglob("h55_enum_framework*.lua"))
    for f in candidates:
        try:
            txt = f.read_text(encoding="utf-8", errors="ignore")
        except Exception:
            continue
        for m in pattern_cre.finditer(txt):
            creature_ids[f"CREATURE_{m.group(1)}"] = int(m.group(2))
        for m in pattern_abi.finditer(txt):
            ability_ids[f"ABILITY_{m.group(1)}"] = int(m.group(2))

    return creature_ids, ability_ids

def try_load_ids_from_pdf(repo_root: Path) -> Dict[str, int]:
    """
    OPTIONAL: Parse HOMM5_IDs_for_Scripts*.pdf if PyPDF2 is available.
    Lines look like: CREATURE_ANGEL = 13
    """
    out: Dict[str, int] = {}
    try:
        import PyPDF2  # type: ignore
    except Exception:
        return out

    pdfs = list(repo_root.rglob("HOMM5*_IDs_for_Scripts*.pdf")) + list(repo_root.rglob("HOMM5*_ID*s_for_Scripts*.pdf"))
    if not pdfs:
        p = repo_root / "git_docs" / "HOMM5_IDs_for_Scripts.pdf"
        if p.exists():
            pdfs = [p]

    pattern_cre = re.compile(r'\b(CREATURE_[A-Z0-9_]+)\s*=\s*(\d+)\b')
    for pdf in pdfs:
        try:
            with open(pdf, "rb") as fh:
                reader = PyPDF2.PdfReader(fh)
                for page in reader.pages:
                    text = page.extract_text() or ""
                    for m in pattern_cre.finditer(text):
                        out[m.group(1)] = int(m.group(2))
        except Exception as e:
            warn(f"Failed to parse PDF '{pdf}': {e}")
    return out

# -----------------------------
# types.xml sanity & optional id mining
# -----------------------------
def types_xml_sanity(types_xml: Path) -> Tuple[str, int, int, int]:
    """
    Report counts and root tag for user confidence. Return tuple(root, n_items, n_types, total_nodes).
    """
    try:
        tree = ET.parse(str(types_xml))
        root = tree.getroot()
    except Exception as e:
        raise SystemExit(f"FATAL: cannot parse types.xml at {types_xml}: {e}")

    root_tag = root.tag or "<?>"
    n_item = len(root.findall(".//Item"))
    n_type = len(root.findall(".//Type"))
    total_nodes = sum(1 for _ in root.iter())
    return root_tag, n_item, n_type, total_nodes

# -----------------------------
# Creature parsing
# -----------------------------
def slug_to_enum_tail(name: str) -> str:
    tail = re.sub(r'[^A-Za-z0-9]+', '_', name).strip('_').upper()
    return tail

def parse_creature_xdb(xdb_path: Path) -> Tuple[str, List[str], int]:
    """
    Extract (enum_tail, ability_consts, base_growth)
    """
    enum_tail = slug_to_enum_tail(xdb_path.stem)
    tree = read_xml(xdb_path)
    if tree is None:
        return enum_tail, [], 0

    root = tree.getroot()

    # 1) Abilities
    abilities: List[str] = []
    for abilities_node in root.findall(".//Abilities"):
        for item in abilities_node.findall("./Item"):
            val = text_of(item)
            if val and val.startswith("ABILITY_"):
                abilities.append(val)

    # 2) WeeklyGrowth
    growth = 0
    for tag in ("WeeklyGrowth", "Growth", "BaseGrowth"):
        node = root.find(f".//{tag}")
        if node is not None:
            try:
                growth = int(text_of(node) or "0")
                break
            except Exception:
                pass

    return enum_tail, abilities, growth

# -----------------------------
# Spell parsing
# -----------------------------
def parse_spell_xdb(xdb_path: Path) -> Tuple[str, str]:
    enum_tail = slug_to_enum_tail(xdb_path.stem)
    tree = read_xml(xdb_path)
    if tree is None:
        return enum_tail, f"SPELL_{enum_tail}"

    for tag in ("ID", "SpellID", "Spell", "Name", "Const", "Identifier"):
        node = tree.getroot().find(f".//{tag}")
        val = text_of(node)
        if val and val.startswith("SPELL_"):
            return enum_tail, val

    return enum_tail, f"SPELL_{enum_tail}"

# -----------------------------
# Lua emit helpers (Lua 4.0–safe)
# -----------------------------
def lua_quote(s: str) -> str:
    return "'" + s.replace("\\", "\\\\").replace("'", "\\'") + "'"

def lua_include_runtime_prelude() -> str:
    # No local functions. Await runtime helpers synchronously (busy-wait).
    return r"""
-- AUTOGENERATED by h5_exporter.py — DO NOT EDIT BY HAND.
-- Heroes V / Lua 4.0–safe runtime include.
if not __h55__local_56424_freeze then doFile('./scripts/h55_enum_runtime.lua') end
while not __h55__local_56424_freeze do end
"""

def build_lua_abilities_creatures(ability_ids: Dict[str, int]) -> str:
    lines = []
    lines.append("ABILITIES = ABILITIES or {}")
    lines.append("ABILITIES.CREATURES = __h55__local_56424_freeze_shallow({")
    for const, aid in sorted(ability_ids.items(), key=lambda kv: kv[0]):
        tail = const.replace("ABILITY_", "")
        lines.append(f"  {tail} = {{ id = {aid}, name = {lua_quote(tail)}, const = {lua_quote(const)} }},")
    lines.append("})")
    return "\n".join(lines)

def build_lua_creatures_dot(creatures_by_town: Dict[str, Dict[str, Dict]]) -> str:
    """
    Emit CREATURE.<TOWN>.<NAME> = { name='CREATURE_NAME', id=..., BASE_GROWTH=..., ABILITIES={'A','B',...} }
    """
    out = []
    out.append("CREATURE = __h55__local_56424_freeze({})")
    for town in sorted(creatures_by_town.keys()):
        out.append(f"CREATURE.{town} = __h55__local_56424_freeze({{}})")
        for name in sorted(creatures_by_town[town].keys()):
            o = creatures_by_town[town][name]
            const = o['const']
            cid   = o['id']
            baseg = o['BASE_GROWTH']
            abi_list = ", ".join(lua_quote(a.replace("ABILITY_", "")) for a in o['ABILITIES'])
            out.append(
                f"CREATURE.{town}.{name} = __h55__local_56424_freeze({{ "
                f"name = {lua_quote(const)}, id = {cid}, BASE_GROWTH = {baseg}, "
                f"ABILITIES = __h55__local_56424_freeze({{ {abi_list} }}) "
                f"}})"
            )
        out.append("")  # spacer

    out.append("CREATURE.UNKNOWN = __h55__local_56424_freeze({ name = 'CREATURE_UNKNOWN', id = 0, BASE_GROWTH = 0, ABILITIES = __h55__local_56424_freeze({}) })")
    out.append("")
    out.append("-- Optional self-test: set H55_ENUMS_SELFTEST = 1 before doFile() to print samples.")
    out.append("if H55_ENUMS_SELFTEST then")
    out.append("  function __h55__local_56424__arr(t) local s='{' local i=1 while t[i]~=nil do if i>1 then s=s..', ' end s=s..tostring(t[i]) i=i+1 end return s..'}' end")
    out.append("  function __h55__local_56424__dump(obj) write('{ name='..obj.name..', id='..obj.id..', BASE_GROWTH='..obj.BASE_GROWTH..', ABILITIES='..__h55__local_56424__arr(obj.ABILITIES)..' }\\n') end")
    out.append("  if CREATURE.HAVEN and CREATURE.HAVEN.ANGEL then write('CREATURE.HAVEN.ANGEL -> '); __h55__local_56424__dump(CREATURE.HAVEN.ANGEL) end")
    out.append("  if CREATURE.ACADEMY and CREATURE.ACADEMY.DJINN_VIZIER then write('CREATURE.ACADEMY.DJINN_VIZIER -> '); __h55__local_56424__dump(CREATURE.ACADEMY.DJINN_VIZIER) end")
    out.append("  if CREATURE.NECROPOLIS and CREATURE.NECROPOLIS.SKELETON then write('CREATURE.NECROPOLIS.SKELETON -> '); __h55__local_56424__dump(CREATURE.NECROPOLIS.SKELETON) end")
    out.append("end")
    return "\n".join(out)

def build_lua_spells(spells: Dict[str, str]) -> str:
    out = []
    out.append("-- Spells enumeration (flat), read-only (best effort in Lua 4.0)")
    out.append("SPELL = __h55__local_56424_freeze_shallow({")
    for tail, const in sorted(spells.items(), key=lambda kv: kv[0]):
        out.append(f"  {tail} = {{ name = {lua_quote(const)}, const = {lua_quote(const)} }},")
    out.append("})")
    return "\n".join(out)

# -----------------------------
# Runtime file emission
# -----------------------------
def runtime_lua_text_lua40() -> str:
    return r"""-- h55_enum_runtime.lua
-- Lua 4.0–compatible “readonly” helpers for Heroes V scripts.
if __h55__local_56424_freeze then
  __h55__local_56424_READY = 1
  return
end
if newtag then
  __h55__local_56424_RO_TAG = newtag()
  settagmethod(__h55__local_56424_RO_TAG, "settable", function(t, k, v)
    error("read-only table", 2)
  end)
  function __h55__local_56424_freeze(tbl)
    if type(tbl) == "table" then
      settag(tbl, __h55__local_56424_RO_TAG)
    end
    return tbl
  end
  function __h55__local_56424_freeze_shallow(tbl)
    if type(tbl) == "table" then
      foreach(tbl, function(k, v)
        if type(v) == "table" then __h55__local_56424_freeze(v) end
      end)
      settag(tbl, __h55__local_56424_RO_TAG)
    end
    return tbl
  end
else
  function __h55__local_56424_freeze(tbl)
    return tbl
  end
  function __h55__local_56424_freeze_shallow(tbl)
    if type(tbl) == "table" then
      foreach(tbl, function(k, v)
        if type(v) == "table" then __h55__local_56424_freeze(v) end
      end)
    end
    return tbl
  end
end
__h55__local_56424_READY = 1
"""

def ensure_runtime_lua(out_dir: Path) -> Path:
    scripts_dir = out_dir / "scripts"
    ensure_dir(scripts_dir)
    out_path = scripts_dir / "h55_enum_runtime.lua"
    # Always write/refresh to ensure consistency
    out_path.write_text(runtime_lua_text_lua40(), encoding="utf-8")
    info(f"Wrote runtime helpers: {out_path}")
    return out_path

# -----------------------------
# Exporters
# -----------------------------
def export_creatures(repo_root: Path, local_dir: Path, types_xml: Path,
                     out_dir: Path, dry_run: bool, strict: bool) -> None:
    header("creatures export")

    creatures_root = local_dir / "Creatures"
    xdbs = [p for p in list_files_recursive(creatures_root, (".xdb",)) if p.name.lower() != "none.xdb"]

    creatures_tmp: List[Tuple[str, str, List[str], int]] = []
    n = len(xdbs)
    for i, p in enumerate(xdbs, 1):
        if i % 50 == 0 or i == n:
            info(f"  parsed {i}/{n}...")
        rel = p.relative_to(creatures_root)
        parts = rel.parts
        if len(parts) < 2:
            continue
        town = slug_to_enum_tail(parts[0])
        enum_tail, abilities, growth = parse_creature_xdb(p)
        if enum_tail == "UNKNOWN":
            continue
        creatures_tmp.append((town, enum_tail, abilities, growth))

    framework_cre_ids, framework_abi_ids = try_load_ids_from_framework(repo_root)
    pdf_ids = try_load_ids_from_pdf(repo_root)

    creatures_by_town: Dict[str, Dict[str, Dict]] = {}
    for town, enum_tail, abilities, growth in creatures_tmp:
        const = f"CREATURE_{enum_tail}"
        cid = framework_cre_ids.get(const)
        if cid is None:
            cid = pdf_ids.get(const)
        if cid is None:
            if strict:
                err(f"Missing creature id for {const}; cannot continue in --strict.")
                raise SystemExit(2)
            else:
                warn(f"Missing creature id for {const}; using 0.")
                cid = 0

        abilities = sorted(set(abilities))
        creatures_by_town.setdefault(town, {})
        creatures_by_town[town][enum_tail] = dict(
            const=const,
            id=cid,
            BASE_GROWTH=int(growth or 0),
            ABILITIES=abilities,
        )

    ability_ids = framework_abi_ids or {a: 0 for _, _, A, _ in creatures_tmp for a in A}

    # Prepare Lua
    lua_chunks = []
    lua_chunks.append(lua_include_runtime_prelude())
    lua_chunks.append(build_lua_abilities_creatures(ability_ids))
    lua_chunks.append("")
    lua_chunks.append(build_lua_creatures_dot(creatures_by_town))
    lua_text = "\n".join(lua_chunks).strip() + "\n"

    ensure_dir(out_dir)
    # also ensure runtime helpers exist
    if not dry_run:
        ensure_runtime_lua(out_dir)
    out_path = out_dir / "h55_enums_creatures.lua"
    info(f"Planned output: {out_path}")
    if not dry_run:
        out_path.write_text(lua_text, encoding="utf-8")
        info(f"Wrote {out_path}")
    else:
        info("Dry-run; not writing Lua.")

    # Textual preview (Python side)
    info("Lua preview (3 samples):")
    for (town, name) in [("HAVEN", "ANGEL"), ("ACADEMY", "DJINN_VIZIER"), ("NECROPOLIS", "SKELETON")]:
        obj = creatures_by_town.get(town, {}).get(name)
        if not obj:
            continue
        abilities_tail = [a.replace("ABILITY_", "") for a in obj["ABILITIES"]]
        print(f"  CREATURE.{town}.{name} -> "
              f"{{ name='{obj['const']}', id={obj['id']}, BASE_GROWTH={obj['BASE_GROWTH']}, ABILITIES={abilities_tail} }}")

def export_spells(repo_root: Path, local_dir: Path, out_dir: Path, dry_run: bool) -> None:
    header("spells export")
    magic_root = local_dir / "MAGIC"
    xdbs = list_files_recursive(magic_root, (".xdb",))
    n = len(xdbs)
    spells: Dict[str, str] = {}
    for i, p in enumerate(xdbs, 1):
        if i % 50 == 0 or i == n:
            info(f"  parsed {i}/{n}...")
        tail, const = parse_spell_xdb(p)
        spells[tail] = const

    lua_chunks = []
    lua_chunks.append(lua_include_runtime_prelude())
    lua_chunks.append(build_lua_spells(spells))
    lua_text = "\n".join(lua_chunks).strip() + "\n"

    ensure_dir(out_dir)
    # also ensure runtime helpers exist
    if not dry_run:
        ensure_runtime_lua(out_dir)
    out_path = out_dir / "h55_enums_spells.lua"
    info(f"Planned output: {out_path}")
    if not dry_run:
        out_path.write_text(lua_text, encoding="utf-8")
        info(f"Wrote {out_path}")
    else:
        info("Dry-run; not writing Lua.")

# -----------------------------
# Output directory policy
# -----------------------------
def choose_output_dir(local_dir: Path) -> Path:
    print("\nOutput folder behavior:")
    print("  1) Overwrite existing files in COMPILED_LUA")
    print("  2) Create NEW folder with timestamp")
    while True:
        sel = input("Select [1-2]: ").strip()
        if sel == "1":
            out = local_dir / "COMPILED_LUA"
            ensure_dir(out)
            info(f"Using output directory: {out}")
            return out
        if sel == "2":
            ts = time.strftime("%Y%m%d_%H%M%S")
            out = local_dir / f"COMPILED_LUA_{ts}"
            ensure_dir(out)
            info(f"Using output directory: {out}")
            return out
        print("Please enter 1 or 2.")

# -----------------------------
# Interactive menu
# -----------------------------
def interactive_menu() -> int:
    print("\nWhat do you want to do?")
    print("  1) Export CREATURES  -> h55_enums_creatures.lua")
    print("  2) Export SPELLS     -> h55_enums_spells.lua")
    print("  3) Export BOTH")
    print("  4) Show status / rescan")
    print("  5) Quit")
    while True:
        sel = input("Select [1-5]: ").strip()
        if sel in {"1","2","3","4","5"}:
            return int(sel)

def rescan_status(types_xml: Path, creatures_dir: Path, magic_dir: Path) -> None:
    header("types.xml sanity")
    root_tag, n_item, n_type, total_nodes = types_xml_sanity(types_xml)
    print(f"[INFO] Root tag: <{root_tag}> (assumed)")
    print(f"[INFO] Found {n_item} <Item> elements")
    print(f"[INFO] Found {n_type} <Type> elements")
    print(f"[INFO] Total XML nodes counted: {total_nodes}")

    header("discovery")
    n_cre = len(list_files_recursive(creatures_dir, (".xdb",)))
    n_mag = len(list_files_recursive(magic_dir, (".xdb",)))
    print(f"[INFO] Creatures: {n_cre} file(s) matching ('.xdb',)")
    print(f"[INFO] MAGIC    : {n_mag} file(s) matching ('.xdb',)")

# -----------------------------
# Main
# -----------------------------
def main() -> int:
    parser = argparse.ArgumentParser(description="HOMM5 Build Helper")
    parser.add_argument("--strict", action="store_true", help="fail if any required id cannot be resolved")
    parser.add_argument("--dry-run", action="store_true", help="parse and plan, but do not write files")
    args = parser.parse_args()

    print("\nHOMM5 Build Helper")
    print("==================")
    script_path = Path(__file__).resolve()
    print(f"[INFO] Script path       : {script_path}")

    repo_root = detect_repo_root(script_path)
    print(f"[INFO] Detected repo root: {repo_root}")

    local_dir = repo_root / "LOCAL_DIR"
    print(f"[INFO] Using LOCAL_DIR   : {local_dir}")

    types_xml = repo_root / "git_docs" / "types.xml"
    print(f"[INFO] Using types.xml   : {types_xml}")

    # Initial status
    rescan_status(types_xml, local_dir / "Creatures", local_dir / "MAGIC")

    # interactive loop
    while True:
        sel = interactive_menu()
        if sel == 5:
            info("Bye.")
            break
        elif sel == 4:
            rescan_status(types_xml, local_dir / "Creatures", local_dir / "MAGIC")
            continue

        out_dir = choose_output_dir(local_dir)

        if sel in (1, 3):
            export_creatures(repo_root, local_dir, types_xml, out_dir, args.dry_run, args.strict)
        if sel in (2, 3):
            export_spells(repo_root, local_dir, out_dir, args.dry_run)

    return 0

if __name__ == "__main__":
    raise SystemExit(main())
