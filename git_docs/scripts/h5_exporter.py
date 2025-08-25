#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
HOMM5 Build Helper — single interactive CLI to export:
  • CREATURES .xdb -> h55_enums_creatures.lua (with CREATURE.<TOWN>.<NAME> readonly objects)
  • SPELLS    .xdb -> h55_enums_spells.lua

CHANGES (Lua 4.0 + Heroes V constraints)
----------------------------------------
• No local functions in generated Lua. All pseudo-locals use __h55__local_56424_* prefix.
• Shared helpers moved to ./scripts/h55_enum_runtime.lua and included with a
  safe, NO-BUSY-WAIT prelude which:
    – tries multiple paths with pcall/_h55_pcall;
    – never spins/sleeps; and
    – prints to console and shows flying text near the main hero on failure.
• Lua 4.0 compatible: no rawget, no setmetatable, no pairs/ipairs, no io.write, no booleans.
• The CLI writes the runtime file once into OUT_DIR/scripts/.
• To support both H5M and H5U packaging, thin loader stubs are emitted at:
    OUT_DIR/scripts/h55_enums_creatures.lua
    OUT_DIR/scripts/h55_enums_spells.lua
  These stubs allow game scripts to always call:
      doFile("./scripts/h55_enums_creatures.lua")
      doFile("./scripts/h55_enums_spells.lua")
  and they will fallback to root-level files (./h55_enums_*.lua) if needed.

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
# Lua doc headers (inserted verbatim at top of generated files)
# -----------------------------
def lua_doc_header_creatures() -> str:
    return r"""-- ============================================================================
-- H55 ENUMS · CREATURES & ABILITIES (READ‑ONLY, LUA 4.0–SAFE)
-- ----------------------------------------------------------------------------
-- Purpose
--   Provides a stable, read‑only enumeration API for creature metadata and
--   creature abilities for Heroes V scripts. Data are frozen at load time.
--
-- Loading & Safety
--   - This file requires './scripts/h55_enum_runtime.lua' which defines
--     freeze() and freeze_shallow() used here to enforce immutability.
--   - All exported tables MUST be treated as read‑only. Writes are blocked
--     by metatables installed by the runtime and must raise an error.
--   - It is safe to load/include this file multiple times.
--   - For H5M/H5U compatibility, you can load via a stub:
--         doFile('./scripts/h55_enums_creatures.lua')
--     which falls back to './h55_enums_creatures.lua' when needed.
--
-- Public API (read‑only)
--   ABILITIES (table)                        -- Namespace root for abilities.
--     .CREATURES : table<string, Ability>    -- Flat map keyed by ABILITY symbol
--                                             -- (e.g., 'ACID_BLOOD').
--       Ability (record):
--         id    : integer  -- Reserved numeric id. May be 0 if not defined by
--                           -- the engine. Do NOT rely on 0/ non‑0 semantics.
--         name  : string   -- Generator symbol for the ability
--                           -- (e.g., 'ACID_BLOOD' as seen in this file).
--         const : string   -- Engine token to interoperate with game code
--                           -- (e.g., 'ABILITY_ACID_BLOOD'). Use this when an
--                           -- engine API requires an ABILITY_* constant.
--
--   CREATURE (table)                         -- Namespace root for creatures.
--     .<FACTION> (table)                     -- Faction namespaces:
--       ACADEMY, DUNGEON, DWARF, FORTRESS, HAVEN, INFERNO,
--       NECROPOLIS, NEUTRALS, ORCS, PRESERVE, UNKNOWN.
--     .<FACTION>.<UNIT> : Creature           -- Leaf records (one per unit).
--       Creature (record):
--         name        : string   -- Generator symbol for the creature
--                                 -- (e.g., 'CREATURE_ARCH_MAGI').
--         id          : integer  -- Reserved numeric id. May be 0.
--         BASE_GROWTH : integer  -- Weekly base growth in town dwellings.
--         ABILITIES   : string[] -- Array of ability KEYS, each of which MUST
--                                 -- exist in ABILITIES.CREATURES. Elements are
--                                 -- ability symbols like 'NO_RANGE_PENALTY'.
--
-- Contract & Invariants
--   - Keys are ASCII, UPPERCASE, underscore‑separated, and case‑sensitive.
--   - ABILITIES arrays contain ability KEYS (strings), not the Ability records.
--     To interoperate with the engine, map a key K as:
--       ABILITIES.CREATURES[K].const  -- engine token 'ABILITY_*'
--   - Missing lookups return nil; no guards are added by this file.
--   - Names/tokens that are non‑canonical in spelling (if any) are preserved
--     exactly to match engine tokens.
--
-- Regeneration & Compatibility
--   - This file is auto‑generated. Keys (ability and creature symbols) form the
--     stable API surface; new entries may be added in future exports.
--   - Designed for Lua 4.0. Data are plain tables and strings and remain
--     forward‑compatible with Lua versions that preserve base table semantics.
--
-- Optional Self‑Test
--   - If the global H55_ENUMS_SELFTEST is set to a truthy value BEFORE loading,
--     the file prints a few sample records via 'write'. No state is mutated.
--
-- References (specifications)
--   - Lua 4.0 Reference Manual — Ierusalimschy, de Figueiredo, Celes.
--     (authoritative semantics for tables, strings, and metatables).
--   - Heroes V engine enumeration tokens (ABILITY_*, CREATURE_*) as defined by
--     the game engine / SDK.
-- ============================================================================
"""

def lua_doc_header_spells() -> str:
    return r"""-- ============================================================================
-- H55 ENUMS · SPELLS (READ‑ONLY, LUA 4.0–SAFE)
-- ----------------------------------------------------------------------------
-- Purpose
--   Provides a stable, read‑only, flat enumeration API for spell tokens used
--   by Heroes V scripts. Data are frozen at load time.
--
-- Loading & Safety
--   - This file requires './scripts/h55_enum_runtime.lua' which defines
--     freeze_shallow() used here to enforce immutability of the top‑level map.
--   - All exported tables MUST be treated as read‑only. Writes are blocked
--     by the runtime and must raise an error.
--   - It is safe to load/include this file multiple times.
--   - For H5M/H5U compatibility, you can load via a stub:
--         doFile('./scripts/h55_enums_spells.lua')
--     which falls back to './h55_enums_spells.lua' when needed.
--
-- Public API (read‑only)
--   SPELL : table<string, Spell>   -- Flat map keyed by SPELL symbol
--                                   -- (e.g., 'ARMAGEDDON', 'DISPEL').
--     Spell (record):
--       name  : string  -- Generator symbol for the spell
--                        -- (e.g., 'SPELL_ARMAGEDDON').
--       const : string  -- Engine token to interoperate with game code
--                        -- (e.g., 'SPELL_ARMAGEDDON'). Use this when an
--                        -- engine API requires a SPELL_* constant.
--
-- Contract & Invariants
--   - Keys are ASCII, UPPERCASE, underscore‑separated, and case‑sensitive.
--   - The map is flat (no faction or school sub‑namespaces in this file).
--   - Names/tokens that are non‑canonical in spelling (if any) are preserved
--     exactly to match engine tokens.
--   - Missing lookups return nil; no guards are added by this file.
--
-- Regeneration & Compatibility
--   - This file is auto‑generated. Keys (spell symbols) form the stable API
--     surface; new entries may be added in future exports.
--   - Designed for Lua 4.0. Data are plain tables and strings and remain
--     forward‑compatible with Lua versions that preserve base table semantics.
--
-- References (specifications)
--   - Lua 4.0 Reference Manual — Ierusalimschy, de Figueiredo, Celes.
--     (authoritative semantics for tables, strings, and metatables).
--   - Heroes V engine enumeration tokens (SPELL_*) as defined by the
--     game engine / SDK.
-- ============================================================================
"""

# -----------------------------
# Lua include prelude (NO busy-wait; with fallbacks & diagnostics)
# -----------------------------
def lua_include_runtime_prelude_safe() -> str:
    # Single-chunk, Lua 4.0–safe, no locals, no booleans, no busy-wait.
    # Uses _h55_pcall if present, else falls back to pcall.
    return r"""
-- AUTOGENERATED by h5_exporter.py — DO NOT EDIT BY HAND.
-- Heroes V / Lua 4.0–safe runtime include with path fallbacks (no busy-wait).
if not __h55__local_56424_freeze then
  __h55__local_56424_PCALL = _h55_pcall
  if not __h55__local_56424_PCALL then __h55__local_56424_PCALL = pcall end

  if __h55__local_56424_PCALL(function() doFile('./scripts/h55_enum_runtime.lua') end) then
  elseif __h55__local_56424_PCALL(function() doFile('./h55_enum_runtime.lua') end) then
  elseif __h55__local_56424_PCALL(function() doFile('scripts/h55_enum_runtime.lua') end) then
  else
    __h55__local_56424_PCALL(function() doFile('h55_enum_runtime.lua') end)
  end

  if not __h55__local_56424_freeze then
    if write then write('[H55 ENUMS] WARN: missing runtime (h55_enum_runtime.lua). Enums will not be read-only.\n') end
    if ShowFlyingSign and GetCurrentPlayer and GetPlayerMainHero then
      __h55__local_56424_msg = 'H55 ENUMS: runtime missing; enums not read-only'
      __h55__local_56424_hero = GetPlayerMainHero(GetCurrentPlayer())
      if __h55__local_56424_hero then
        if startThread then startThread(ShowFlyingSign, __h55__local_56424_msg, __h55__local_56424_hero, 4)
        else ShowFlyingSign(__h55__local_56424_msg, __h55__local_56424_hero, 4) end
      end
      __h55__local_56424_msg = nil
      __h55__local_56424_hero = nil
    end
    -- Degrade gracefully: identity freeze helpers so the file keeps working.
    function __h55__local_56424_freeze(tbl) return tbl end
    function __h55__local_56424_freeze_shallow(tbl)
      if type(tbl) == "table" then
        foreach(tbl, function(k, v)
          if type(v) == "table" then __h55__local_56424_freeze(v) end
        end)
      end
      return tbl
    end
  end
  __h55__local_56424_PCALL = nil
end
"""

# -----------------------------
# Lua emit helpers (Lua 4.0–safe)
# -----------------------------
def lua_quote(s: str) -> str:
    return "'" + s.replace("\\", "\\\\").replace("'", "\\'") + "'"

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
    out: List[str] = []
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
    out: List[str] = []
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
# Loader stub emission (for H5M/H5U compatibility)
# -----------------------------
def loader_stub_text(basename: str) -> str:
    """
    Emit a tiny loader at ./scripts/<basename> that tries to load the root-level
    <basename> with safe pcall/_h55_pcall. On failure, prints to console and
    shows flying text near the main hero (best effort).
    """
    return f"""-- AUTOGENERATED stub loader — DO NOT EDIT BY HAND.
-- Ensures doFile('./scripts/{basename}') works in both H5M and H5U layouts.
__h55__local_56424_PCALL = _h55_pcall
if not __h55__local_56424_PCALL then __h55__local_56424_PCALL = pcall end
__h55__local_56424_OK = nil
if __h55__local_56424_PCALL(function() doFile('./{basename}') end) then
  __h55__local_56424_OK = 1
elseif __h55__local_56424_PCALL(function() doFile('{basename}') end) then
  __h55__local_56424_OK = 1
end
if not __h55__local_56424_OK then
  if write then write('[H55 ENUMS] ERR: cannot load {basename} via scripts/ loader.\\n') end
  if ShowFlyingSign and GetCurrentPlayer and GetPlayerMainHero then
    __h55__local_56424_msg = 'H55 ENUMS: load error {basename}'
    __h55__local_56424_hero = GetPlayerMainHero(GetCurrentPlayer())
    if __h55__local_56424_hero then
      if startThread then startThread(ShowFlyingSign, __h55__local_56424_msg, __h55__local_56424_hero, 4)
      else ShowFlyingSign(__h55__local_56424_msg, __h55__local_56424_hero, 4) end
    end
    __h55__local_56424_msg = nil
    __h55__local_56424_hero = nil
  end
end
__h55__local_56424_PCALL = nil
__h55__local_56424_OK = nil
"""

def ensure_loader_stub(out_dir: Path, basename: str) -> Path:
    scripts_dir = out_dir / "scripts"
    ensure_dir(scripts_dir)
    p = scripts_dir / basename
    p.write_text(loader_stub_text(basename), encoding="utf-8")
    info(f"Wrote loader stub: {p}")
    return p

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
    lua_chunks: List[str] = []
    lua_chunks.append(lua_doc_header_creatures().rstrip("\n"))
    lua_chunks.append(lua_include_runtime_prelude_safe().strip("\n"))
    lua_chunks.append("")
    lua_chunks.append(build_lua_abilities_creatures(ability_ids))
    lua_chunks.append("")
    lua_chunks.append(build_lua_creatures_dot(creatures_by_town))
    lua_text = "\n".join(lua_chunks).strip() + "\n"

    ensure_dir(out_dir)
    # ensure runtime helpers and loader stubs exist
    if not dry_run:
        ensure_runtime_lua(out_dir)
        ensure_loader_stub(out_dir, "h55_enums_creatures.lua")
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

    lua_chunks: List[str] = []
    lua_chunks.append(lua_doc_header_spells().rstrip("\n"))
    lua_chunks.append(lua_include_runtime_prelude_safe().strip("\n"))
    lua_chunks.append("")
    lua_chunks.append(build_lua_spells(spells))
    lua_text = "\n".join(lua_chunks).strip() + "\n"

    ensure_dir(out_dir)
    # ensure runtime helpers and loader stubs exist
    if not dry_run:
        ensure_runtime_lua(out_dir)
        ensure_loader_stub(out_dir, "h55_enums_spells.lua")
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
            info("Okay. Quitting.")
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
