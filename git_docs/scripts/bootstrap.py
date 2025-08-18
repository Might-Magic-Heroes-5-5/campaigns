# git_docs/scripts/bootstrap.py
from __future__ import annotations
from pathlib import Path
import sys

def _has_types_xml(p: Path) -> bool:
    gd = p / "git_docs"
    return (gd / "types.xml").exists() or (gd / "Types.xml").exists()

def find_repo_root(start: Path | None = None) -> Path:
    """
    Walk upward from `start` (defaults to this file) until we find a folder
    that contains git_docs/types.xml (case-insensitive check).
    """
    start = (start or Path(__file__)).resolve()
    for candidate in [start] + list(start.parents):
        if _has_types_xml(candidate):
            return candidate
    raise RuntimeError(
        "Could not locate repo root (expected 'git_docs/types.xml'). "
        "Run scripts from within the repository."
    )

REPO_ROOT = find_repo_root()
GIT_DOCS  = REPO_ROOT / "git_docs"
LOCAL_DIR = REPO_ROOT / "LOCAL_DIR"

# Prefer lowercase, fall back to capitalized:
TYPES_XML = (GIT_DOCS / "types.xml") if (GIT_DOCS / "types.xml").exists() else (GIT_DOCS / "Types.xml")

# Convenience paths you mentioned
CREATURES_DIR = LOCAL_DIR / "Creatures"
MAGIC_DIR     = LOCAL_DIR / "MAGIC"

def load_types_xml():
    """
    Parse git_docs/types.xml and return the root element.
    Uses only the repo copy; never reads from an installed game.
    """
    import xml.etree.ElementTree as ET
    if not TYPES_XML.exists():
        raise FileNotFoundError(f"types.xml not found at {TYPES_XML}")
    return ET.parse(TYPES_XML).getroot()

def add_shared_lib(*subdirs: str) -> None:
    """
    Optionally expose a shared helpers folder for imports:
    e.g., add_shared_lib('_lib') => git_docs/scripts/_lib
    """
    lib = GIT_DOCS / "scripts" / Path(*subdirs)
    if lib.exists() and lib.is_dir():
        sys.path.insert(0, str(lib))
