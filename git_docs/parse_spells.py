#!/usr/bin/env python3
"""
Parse Heroes V .xdb (XML) spell files and output a table mapping
Spell -> Magic School with code name and engine ID.

Usage:
  python parse_spells.py [root_dir] [--csv out.csv] [--md out.md] [--stdout md|csv] [--lua out.lua] [--root-tag Spell]

- root_dir: directory to search recursively for *.xdb. Default: ./LOCAL_DIR
- --csv: write CSV to the given path (default: spells_by_school.csv in root_dir)
- --md:  write Markdown table to the given path (optional)
- --stdout: print table to stdout in the chosen format (md or csv). Default: md
- --lua: write a Lua table (by_school and by_spell) to the given path (optional)
- --root-tag: only parse files whose root XML tag equals this value (default: Spell)

Notes:
- Only files whose root XML tag is <Spell> are considered (unless --root-tag is changed).
- "Code name" is derived from the file stem (e.g., Blind.xdb -> SPELL_BLIND).
- "ID used" is the ObjectRecordID attribute found on the <Spell> root element.
- The script is robust to minor XML issues and will ignore files it can't parse.
"""

from __future__ import annotations
from pathlib import Path
import sys
import argparse
import xml.etree.ElementTree as ET
import csv
import re
from typing import Dict, List, Optional


def normalize_code_name(file_stem: str) -> str:
    """Build an enum-like code name: SPELL_<UPPER_SNAKE_CASE> from the file name.
    Examples:
      'Disrupting_Ray' -> 'SPELL_DISRUPTING_RAY'
      'Animate Dead'   -> 'SPELL_ANIMATE_DEAD'
    """
    base = re.sub(r"[^0-9A-Za-z]+", "_", file_stem)
    base = re.sub(r"_{2,}", "_", base).strip("_")
    return f"SPELL_{base.upper()}" if base else "SPELL_UNKNOWN"


def parse_spell_xdb(path: Path, root_tag_filter: str = "Spell") -> Optional[Dict[str, str]]:
    """Parse the given .xdb file and extract Spell information.
    Returns a dict with keys: file, relpath, school, level, record_id, code_name, name_ref
    or None if the file is not a <Spell> (or the chosen --root-tag) or couldn't be parsed.
    """
    try:
        tree = ET.parse(path)
        root = tree.getroot()
    except Exception:
        return None

    if root.tag != root_tag_filter:
        return None

    record_id = (root.attrib.get("ObjectRecordID") or "").strip()
    school = None
    level = None
    name_ref = None

    for child in root:
        tag = child.tag
        if tag == "MagicSchool":
            school = (child.text or "").strip()
        elif tag == "Level":
            level = (child.text or "").strip()
        elif tag == "NameFileRef":
            if "href" in child.attrib:
                name_ref = child.attrib["href"]
            else:
                name_ref = (child.text or "").strip()

    code_name = normalize_code_name(path.stem)

    return {
        "file": path.name,
        "relpath": str(path),
        "school": school or "",
        "level": level or "",
        "record_id": record_id,
        "code_name": code_name,
        "name_ref": name_ref or "",
    }


def scan_xdb_files(root_dir: Path, root_tag_filter: str = "Spell") -> List[Dict[str, str]]:
    results: List[Dict[str, str]] = []
    for p in root_dir.rglob("*.xdb"):
        entry = parse_spell_xdb(p, root_tag_filter)
        if entry is not None:
            results.append(entry)

    def sort_key(d: Dict[str, str]):
        try:
            lvl = int(d.get("level") or 0)
        except ValueError:
            lvl = 0
        return (d.get("school") or "", lvl, d.get("code_name") or "", d.get("file") or "")
    results.sort(key=sort_key)
    return results


def write_csv(rows: List[Dict[str, str]], out_csv: Path) -> None:
    out_csv.parent.mkdir(parents=True, exist_ok=True)
    fields = ["school", "level", "code_name", "record_id", "file", "relpath", "name_ref"]
    with out_csv.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        for r in rows:
            w.writerow({k: r.get(k, "") for k in fields})


def format_markdown(rows: List[Dict[str, str]]) -> str:
    headers = ["School", "Lvl", "Code name", "ID (ObjectRecordID)", "File"]
    lines = ["| " + " | ".join(headers) + " |",
             "| " + " | ".join("---" for _ in headers) + " |"]
    for r in rows:
        lines.append("| {School} | {Lvl} | `{Code}` | {ID} | {File} |".format(
            School=r.get("school", ""),
            Lvl=r.get("level", ""),
            Code=r.get("code_name", ""),
            ID=r.get("record_id", ""),
            File=r.get("file", ""),
        ))
    return "\n".join(lines)


def write_lua(rows: List[Dict[str, str]], out_lua: Path) -> None:
    """Write a Lua table grouped by school and a by_spell lookup."""
    out_lua.parent.mkdir(parents=True, exist_ok=True)

    # Group by school
    school_to_spells: Dict[str, List[Dict[str, str]]] = {}
    for r in rows:
        school = r.get("school") or "UNKNOWN"
        school_to_spells.setdefault(school, []).append(r)

    lines: List[str] = []
    lines.append("return {")
    # by_school
    lines.append("  by_school = {")
    for school, items in sorted(school_to_spells.items()):
        lines.append(f"    ['{school}'] = {{")
        items_sorted = sorted(items, key=lambda x: (int(x.get('level') or 0), x.get('code_name', '')))
        for it in items_sorted:
            lines.append(f"      '{it.get('code_name','')}',")
        lines.append("    },")
    lines.append("  },")
    # by_spell
    lines.append("  by_spell = {")
    for r in rows:
        level_str = r.get('level') if (r.get('level') and r.get('level').isdigit()) else 'nil'
        obj_id_str = r.get('record_id') if (r.get('record_id') and r.get('record_id').isdigit()) else 'nil'
        lines.append(
            f"    ['{r.get('code_name','')}'] = {{ school = '{r.get('school','')}', level = {level_str}, object_id = {obj_id_str} }},")
    lines.append("  },")
    lines.append("}")
    out_lua.write_text("\n".join(lines), encoding="utf-8")


def main(argv: List[str]) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("root", nargs="?", default=str(Path("../LOCAL_DIR")),
                    help="Root directory to scan (default: ./LOCAL_DIR)")
    ap.add_argument("--csv", default=None, help="Write CSV to this path (default: <root>/spells_by_school.csv)")
    ap.add_argument("--md", default=None, help="Write Markdown table to this path (optional)")
    ap.add_argument("--stdout", choices=["md", "csv"], default="md",
                    help="Print table to stdout in this format (default: md)")
    ap.add_argument("--lua", default=None, help="Write a Lua table to this path (optional)")
    ap.add_argument("--root-tag", default="Spell", help="Only parse files whose root XML tag matches this (default: Spell)")
    args = ap.parse_args(argv)

    root_dir = Path(args.root).resolve()
    if not root_dir.exists():
        print(f"[!] Root directory does not exist: {root_dir}", file=sys.stderr)
        return 2

    rows = scan_xdb_files(root_dir, args.root_tag)
    if not rows:
        print("[i] No matching .xdb files found under", root_dir, file=sys.stderr)

    # Outputs
    if args.csv:
        write_csv(rows, Path(args.csv))
    else:
        write_csv(rows, root_dir / "spells_by_school.csv")  # default

    if args.md:
        Path(args.md).write_text(format_markdown(rows), encoding="utf-8")

    if args.lua:
        write_lua(rows, Path(args.lua))

    # stdout
    if args.stdout == "md":
        print(format_markdown(rows))
    else:
        import io
        fields = ["school", "level", "code_name", "record_id", "file", "relpath", "name_ref"]
        buf = io.StringIO()
        w = csv.DictWriter(buf, fieldnames=fields)
        w.writeheader()
        for r in rows:
            w.writerow({k: r.get(k, "") for k in fields})
        print(buf.getvalue())

    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
