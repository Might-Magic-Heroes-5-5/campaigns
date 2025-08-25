# HOMM5 Build Helper — Unified Exporter

**Entry point:** `git_docs/scripts/h5_exporter.py`

This tool parses **local** Heroes V `.xdb` files (XML content) into **read-only Lua enums/tables**:

- `CREATURE.<TOKEN> = { name="CREATURE_...", id=<int|nil>, BASE_GROWTH=<int>, ABILITIES={ "ABILITY_...", ... } }`
- `ABILITIES.CREATURES["ABILITY_..."] = <int|nil>`
- `SPELL.<TOKEN> = { name="SPELL_...", id=<int|nil>, school="MAGIC_SCHOOL_...", level=<int> }`
- `SPELL_BY_ID[id] = SPELL.<TOKEN>`
- `SPELLS_BY_SCHOOL["MAGIC_SCHOOL_..."] = { SPELL.XXX, ... }`

All Lua tables are **deeply read‑only** and support **dot notation**.

---

## Inputs (relative to repo root by default)

- `./git_docs/types.xml` — required for numeric IDs (`CREATURE_*`, `ABILITY_*`, `SPELL_*`).
- `./LOCAL_DIR/Creatures/**.xdb` — creature records.  
  - Abilities are read from `<Abilities><Item>ABILITY_...</Item></Abilities>`.  
  - Growth is read from `<WeeklyGrowth>`.
- `./LOCAL_DIR/MAGIC/**.xdb` — spells.  
  - Spell school: `<MagicSchool>`.  
  - Spell level: `<Level>`.  
  - ID: prefers `types.xml` enum; falls back to `ObjectRecordID` if present.

> **Note**: No game installation is touched; everything runs from your repo.  

---

## Outputs

- Default directory: `./LOCAL_DIR/COMPILED_LUA`  
  - `h55_enums_creatures.lua`  
  - `h55_enums_spells.lua`  

If the output directory already has files, you can choose to **Overwrite** or create a **timestamped** directory, e.g. `COMPILED_LUA_20250819_004341`.

---

## Usage

Interactive (recommended):
```sh
python git_docs/scripts/h5_exporter.py
