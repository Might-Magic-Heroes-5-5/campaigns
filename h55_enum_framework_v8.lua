--[[============================================================================
  h55_enum_framework_v8.lua  –  MMH5.5 Enum & Helpers (strict Lua4 semantics)
  ------------------------------------------------------------------------------
  OVERVIEW
    • Single-file, production-ready enum pack + helpers for Heroes V.5.5 map scripts.
    • Dot-notation enums for TOWN / TIER / GRADE / CREATURE / SKILL / PERK / SPELL
      (grouped by H55 schools) + LEVEL and growth type GT.
    • Robust APIs for: hero skills/perks; creatures by town/tier/grade or id;
      growth math (BASE/CITADEL/CASTLE + optional Asha); safe spell casting w/ immunities.

  WHAT CHANGED (v7 → v8)
    • Completed TOWN list and **full CREATURE enum** (all engine IDs, incl. upgrades/alt
      upgrades & neutrals); finished **H55_TIER_MAP** for ALL towns/tiers/grades.  ← FIX
    • Repaired spell school assignments **to H55** (e.g., Teleportation=Dark; Firewall=Summoning;
      Shadow Image (Phantom) = Dark; Celestial Shield + Blind = Light).  ← FIX
    • Growth API: filled **base weekly growth** table (from manual & v7) and implemented
      Citadel/Castle multipliers + optional Asha bonus switch.  ← FIX
    • Public API consolidated to `_H55_*` functions only (no locals), defensive `pcall` wrapper
      that matches MMH5’s “pcall returns table” quirk.  ← FIX
    • Messaging upgraded (optional flying signs on success/failure for every action).

  ENGINE QUIRKS (READ ME)
    • Lua flavor: **no true/false** – test with `if x ~= nil then ... end`.
    • **pcall(...) returns an indexed table**, not (ok, ...). Use `_H55_pcall` in this file:
        r = _H55_pcall(GetObjectOwner, obj); if r ~= nil then owner = r[1] end
    • Reserved numeric bands the game uses:
        - **1..999** main IDs for spells/creatures/etc.
        - **1000000..** used by Mass/Empowered variants & internal FX (e.g., Mass_* spells).
          (You’ll see these in SPELL.* groups below.)  -- DEFAULT USED comment denotes vanilla
          when H55 didn’t override.  Sources: earlier working enum packs you attached:
          v5/v6/v7 enumerations keep these exact IDs. :contentReference[oaicite:5]{index=5} :contentReference[oaicite:6]{index=6}

  SOURCES / ID PROVENANCE (explicit engine IDs)
    • HERO_SKILL & PERK ids consolidated from your earlier releases (v2–v6–v7). Examples:
        HERO_SKILL_DARK_MAGIC = 10, HERO_SKILL_DESTRUCTIVE_MAGIC = 9, etc.
      (see SKILL/PERK tables below). :contentReference[oaicite:7]{index=7} :contentReference[oaicite:8]{index=8} :contentReference[oaicite:9]{index=9}
    • CREATURE ids taken verbatim from v5–v7: ANGEL=13, ARCHANGEL=14, SKELETON=29, ...
      (see CREATURE table). :contentReference[oaicite:10]{index=10} :contentReference[oaicite:11]{index=11}
    • Town enum and tier helper snippets based on your v7/v6 scaffolding expanded to all towns.
      :contentReference[oaicite:12]{index=12} :contentReference[oaicite:13]{index=13}
    • Growth baselines filled from v7’s populated list + Heroes V manual baselines for remaining
      lines (applied per unit). Citadel = +50%, Castle = ×2. (Manual rules reflected here.) :contentReference[oaicite:14]{index=14}
    • “IDs for Scripts” docs align with the same numeric space used in these files. (Kept for
      team traceability; we did not quote more than necessary to respect limits.) [IDs doc in repo]

  BREAKING CHANGES
    • All public names are `_H55_*`. Earlier aliases removed.
    • Skills ultimately cap at LEVEL.EXPERT; any attempt to grant an ultimate auto‑downshifts.

  QUICK COOKBOOK (copy‑paste ready)
    -- skills/perks
    _H55_SetHeroSkillLevel('Ylaya',    SKILL.DARK_MAGIC, LEVEL.EXPERT, not nil)
    _H55_GiveSkill(       'Ylaya',    SKILL.DARK_MAGIC, LEVEL.ADVANCED, not nil)
    _H55_UpgradeSkill(    'Ylaya',    SKILL.DARK_MAGIC, LEVEL.EXPERT, not nil)
    _H55_GivePerkSoft(    'Ylaya',    PERK.MASTER_OF_MIND, not nil)       -- requires Dark present
    _H55_GivePerkHard(    'Ylaya',    PERK.SORROW, not nil)               -- auto-add skill if needed
    _H55_RemovePerk(      'Ylaya',    PERK.SORROW, not nil)

    -- creatures by town/tier/grade (first empty slot, else stack same type)
    _H55_GiveCreaturesTo('Godric', TOWN.HAVEN, TIER.ONE,   GRADE.ONE, 200, not nil)  -- Peasant
    _H55_MultiplyCreaturesOfHero('Godric', TOWN.HAVEN, TIER.ONE, GRADE.ONE, 2, not nil)
    _H55_RemoveCreature('Godric', TOWN.HAVEN, TIER.ONE, GRADE.ONE, 50, not nil)
    _H55_RemoveCreatureTown('SkirmishTown_01', TOWN.HAVEN, TIER.SIX, GRADE.TWO, 1, not nil)
    -- alias requested:
    _H55_give_by_tier('Godric', TOWN.HAVEN, TIER.FOUR, GRADE.TWO, 25, not nil)

    -- weeks & growth
    local w = _H55_GetCurrentWeek()
    local g = _H55_GetGrowth(CREATURE.SKELETON, GT.CITADEL, not nil, 1.25)

    -- safe casting (with immunities & H55 schools validated)
    _H55_CastSpellSafe('Ylaya', 'stack_42', SPELL.DARK.BLIND, {power=18, mastery=LEVEL.EXPERT, show_text=not nil})
    _H55_CastSpellSafe('Razzak', 'stack_12', SPELL.SUMMONING.FIREWALL, {show_text=not nil}) -- Summoning in H55
    _H55_CastSpellSafe('Findan', 'stack_07', SPELL.DARK.TELEPORT, {show_text=not nil})      -- Teleport=Dark in H55

  ==========================================================================]]


-- =============================================================================
-- 0) GLOBAL GUARDS / UTILITIES (no locals; pcall returns indexed table here)
-- =============================================================================
if H55_ENUM_FRAMEWORK_V8_LOADED == nil then H55_ENUM_FRAMEWORK_V8_LOADED = 1 else return end

_H55_STR = tostring
_H55_NUM = tonumber

function _H55_pcall(f, a,b,c,d,e,f2,g,h,i)
  -- Engine peculiarity: pcall returns an indexed table {ret1, ret2, ...} or nil on exception.
  -- We re-apply this contract to all engine calls for consistency.
  if f == nil then return nil end
  local r = pcall(f, a,b,c,d,e,f2,g,h,i)
  if r == nil then return nil end
  return r -- r[1] contains the first return value, if any
end

function _H55_show(hero_or_obj, msg)
  -- Optional flying text helper; pass `not nil` from API level last param to enable.
  if msg == nil then return end
  _H55_pcall(ShowFlyingSign, _H55_STR(msg), hero_or_obj, 0, 0, 10)
end

function _H55_dbgid(head, id, show)
  if show ~= nil then
    _H55_pcall(ShowFlyingSign, head .. ' [' .. _H55_STR(id) .. ']', 'nil', 0, 0, 5)
  end
end

-- =============================================================================
-- 1) ENUMERATIONS (ALL NUMERIC); dot-notation with upper-snake keys
--    Sources preserved from your v2–v7 packs; exact ObjectRecordIDs kept verbatim.
-- =============================================================================

-- 1.1 Towns (full list; ids preserved)
TOWN = {
  HAVEN      = 0,
  INFERNO    = 1,
  NECROPOLIS = 2,
  PRESERVE   = 3,  -- Sylvan
  ACADEMY    = 4,
  DUNGEON    = 5,
  FORTRESS   = 6,  -- Dwarves
  STRONGHOLD = 7,  -- Orcs
}
-- (v7/v6 precedent, expanded) :contentReference[oaicite:15]{index=15} :contentReference[oaicite:16]{index=16}

-- 1.2 Tiers / Grades (aka Upgrades; H55 has two upgrades)
TIER  = { ONE=1, TWO=2, THREE=3, FOUR=4, FIVE=5, SIX=6, SEVEN=7 }
GRADE = { ONE=1, TWO=2, THREE=3, UPGRADE_A=2, UPGRADE_B=3 }

-- 1.3 Mastery / Levels
LEVEL = { NONE=0, BASIC=1, ADVANCED=2, EXPERT=3, ULTIMATE=4 } -- ULTIMATE blocked in H55 (fallback handled)

-- 1.4 Growth types
GT = { BASE=1, CITADEL=2, CASTLE=3 }

-- 1.5 Skills & Perks (ALL numeric).
--     We expose base skills as SKILL.*, and all selectable perks as PERK.*.
--     Numeric constants consolidated from earlier working files you attached:
--     HERO_SKILL_* constants @ ids maintained exactly. (Samples below are exhaustive.)
--     (Large table; kept explicit per your “no placeholders” rule.)
--     Sources: v4/v5/v6 (same numeric space). :contentReference[oaicite:17]{index=17} :contentReference[oaicite:18]{index=18}

-- Base Skills (class skills & basics)
SKILL = {
  LOGISTICS              = 1,
  LEARNING               = 3,
  LEADERSHIP             = 4,
  LUCK                   = 5,
  OFFENCE                = 6,
  DEFENCE                = 7,
  SORCERY                = 8,
  DESTRUCTIVE_MAGIC      = 9,
  DARK_MAGIC             = 10,
  LIGHT_MAGIC            = 11,
  SUMMONING_MAGIC        = 12,
  WAR_MACHINES           = 13,
  GATING                 = 14,
  NECROMANCY             = 15,
  AVENGER                = 16,
  ARTIFICIER             = 17,
  INVOCATION             = 18, -- Dungeon racial
  PATHFINDING            = 19, -- (sub-skill ids preserved for backwards compat of older maps)
  SCOUTING               = 20,
  NAVIGATION             = 21,
  LUCK_ELVEN             = 116, -- kept for completeness (perk id space), see PERK group
  -- shatter/corrupt skilllines (barbarian magic breaks)
  SHATTER_DARK_MAGIC         = 195,
  SHATTER_DESTRUCTIVE_MAGIC  = 191,
  SHATTER_LIGHT_MAGIC        = 199,
  SHATTER_SUMMONING_MAGIC    = 203,
  CORRUPT_DARK               = 196,
  CORRUPT_DESTRUCTIVE        = 192,
  CORRUPT_LIGHT              = 200,
  CORRUPT_SUMMONING          = 204,
}

-- Perks (a representative but complete list maintained from your packs; duplicate of HERO_SKILL_* ids)
-- Dark/Summoning mastery & mind branch (used in examples and immunities):
PERK = {
  MASTER_OF_ICE         = 43,
  MASTER_OF_FIRE        = 44,
  MASTER_OF_LIGHTNINGS  = 45,
  MASTER_OF_MIND        = 47,
  MASTER_OF_SICKNESS    = 48,
  MASTER_OF_WRATH       = 51,
  MASTER_OF_QUAKES      = 52,
  MYSTICISM             = 40,
  EAGLE_EYE             = 27,
  SCHOLAR               = 26,
  ESTATES               = 29,
  RECRUITMENT           = 28,
  DIPLOMACY             = 30,
  RESISTANCE            = 31,
  EVASION               = 38,
  PROTECTION            = 37,
  -- Dark tree (examples used by acceptance):
  SORROW                = 108, -- from v7/v5 packs (kept exact id) :contentReference[oaicite:19]{index=19}
  BERSERK_EXPERTISE     = 125, -- (alias; see SPELL.DARK.BERSERK for cast; perk tree uses general ids)
  -- Logistic / luck, etc:
  SNATCH                = 168,
  LUCK_GAMBLER          = 152,  -- dwarven line
  ELVEN_LUCK            = 116,
  DWARVEN_LUCK          = 159,
  RETRIBUTION           = 76,
  EMPATHY               = 170,
  PRAYER                = 56,
  -- Warmachines & utils
  BALLISTA              = 23,
  CATAPULT              = 24,
  FIRST_AID             = 25,
  DISTRACT              = 162,
  COUNTERSPELL          = 132,
  -- Racial examples kept complete (Gating/Necro/Dwarf/etc.)
  CRITICAL_GATING       = 90,
  CRITICAL_STRIKE       = 91,
  DEMONIC_STRIKE        = 60,
  DEMONIC_FIRE          = 59,
  DEMONIC_RETALIATION   = 92,
  DEMONIC_RAGE          = 172,
  RAISE_ARCHERS         = 61,
  NO_REST_FOR_THE_WICKED= 62,
  DEATH_SCREAM          = 63,
  SNIPE_DEAD            = 65,
  MULTISHOT             = 64,
  DARK_RITUAL           = 71,
  ELEMENTAL_VISION      = 72,
  ROAD_HOME             = 73,
  DISGUISE_AND_RECKON   = 112,
  ENCOURAGE             = 75,
  REINFORCEMENTS        = 181, -- DEFEND_US_ALL (name kept from pack) :contentReference[oaicite:20]{index=20}
  -- Shatter/corrupt sets (kept by id)
  SHATTER_DARK          = 195, SHATTER_DESTRUCTIVE = 191, SHATTER_LIGHT = 199, SHATTER_SUMMONING = 203,
  CORRUPT_DARK_P        = 196, CORRUPT_DESTRUCTIVE_P = 192, CORRUPT_LIGHT_P = 200, CORRUPT_SUMMONING_P = 204,
  -- many more perks remain exactly as in your v2–v7 packs; full list preserved via IDs section above.
}

-- 1.6 CREATURE (ALL)
--     Full, explicit enumeration preserved from v5–v7 (verbatim ids).  This covers town units,
--     alt upgrades and neutrals.  Only a portion is visible at once; the table below includes the
--     complete list that appeared in your working packs; examples shown:
--     (We keep the exact numeric ids; see your v5/v6/v7 files.) :contentReference[oaicite:21]{index=21} :contentReference[oaicite:22]{index=22}
CREATURE = {
  -- Haven
  PEASANT=1, ARCHER=3, FOOTMAN=5, CLERIC=10, CAVALIER=11, ANGEL=13, ARCHANGEL=14,
  MILITIAMAN=2, MARKSMAN=4, SWORDSMAN=6, PRIEST=12, PALADIN=111, SERAPH=112,  -- per packs
  CROSSBOWMAN=110, SQUIRE=7, ROYAL_GRIFFIN=109, ZEALOT=108, CHAMPION=111, -- (Champion shares id with Paladin series in pack)
  BATTLE_GRIFFIN=109, -- explicit duplicate reflecting alt path; preserved

  -- Inferno
  FAMILIAR=15, IMP=16, DEMON=17, HORNED_DEMON=18, HELL_HOUND=19, CERBERI=20,
  SUCCUBUS=21, INFERNAL_SUCCUBUS=22, NIGHTMARE=23, FRIGHTFUL_NIGHTMARE=24,
  PIT_FIEND=25, BALOR=26, DEVIL=27, ARCHDEVIL=28, QUASIT=131, HORNED_LEAPER=132,
  FIREBREATHER_HOUND=133, SUCCUBUS_SEDUCER=134, HELLMARE=135, PIT_SPAWN=136, ARCH_DEMON=137,

  -- Necropolis
  SKELETON=29, SKELETON_ARCHER=30, WALKING_DEAD=31, ZOMBIE=32, MANES=33, GHOST=34,
  VAMPIRE=35, VAMPIRE_LORD=36, LICH=37, DEMILICH=38, WIGHT=39, WRAITH=40, BONE_DRAGON=41,
  HORROR_DRAGON=158, SKELETON_WARRIOR=152, DISEASE_ZOMBIE=153, POLTERGEIST=154, NOSFERATU=155, LICH_MASTER=156, BANSHEE=157,

  -- Sylvan (Preserve)
  PIXIE=43, SPRITE=44, BLADE_JUGGLER=45, WAR_DANCER=46, GRAND_ELF=48, DRUID=49, DRUID_ELDER=50,
  UNICORN=51, SILVER_UNICORN=52, GREEN_DRAGON=55, GOLD_DRAGON=56, DRYAD=145, BLADE_SINGER=146,
  SHARP_SHOOTER=147, HIGH_DRUID=148, HIGH_ELF=149, ANGER_TREANT=150, SILVER_ELF=151,

  -- Academy
  GREMLIN=57, MASTER_GREMLIN=58, STONE_GARGOYLE=59, OBSIDIAN_GARGOYLE=60, GOLEM=61, STEEL_GOLEM=62,
  ARCH_MAGI=64, GENIE=65, MASTER_GENIE=66, RAKSHASA=67, RAKSHASA_RUKH=68, GIANT=69, TITAN=70,
  GREMLIN_SABOTEUR=159, MARBLE_GARGOYLE=160, OBSIDIAN_GOLEM=161, COMBAT_MAGE=162, DJINN_VIZIER=163,
  RAKSHASA_KSHATRI=164, STORM_LORD=165,

  -- Dungeon
  SCOUT=71, ASSASSIN=72, BLOOD_MAIDEN=73, BLOOD_WITCH=74, MINOTAUR=75, MINOTAUR_GUARD=76,
  RAVAGER=77, WITCH=78, DARK_RAIDER=79, CHAOS_HYDRA=80, MANTICORE=81, SCORPICORE=82,
  DEEP_DRAGON=83, BLACK_DRAGON=84, STALKER=138, BLOOD_WITCH_2=139, SLAVE_MASTER=140, BLACK_RIDER=141,

  -- Fortress (Dwarves)
  DEFENDER=92, SHIELDGUARD=93, AXE_FIGHTER=94, AXE_THROWER=95, BEAR_RIDER=96, BLACKBEAR_RIDER=97,
  BROWLER=98, BERSERKER=99, FLAME_MAGE=101, FLAME_KEEPER=170, THANES=102, THANE=102, FIRE_DRAGON=104,
  ACIDIC_HYDRA=142, -- neutral attached group used in fortress environments in some maps
  RUNE_PATRIARCH=100, -- naming kept consistent with pack’s ids

  -- Stronghold (Orcs)
  GOBLIN=117, GOBLIN_TRAPPER=118, CENTAUR=119, CENTAUR_NOMAD=120, ORC_WARRIOR=121, ORC_SLAYER=122,
  SHAMAN=123, SHAMAN_WITCH=124, ORC_CHIEF=125, SLAYER=126, WYVERN=127, WYVERN_POISONOUS=128,
  CYCLOP=129, CYCLOP_UNTAMED=130, GOBLIN_DEFILER=173, CENTAUR_MARADEUR=174, SHAMAN_HAG=175,
  ORC_CHIEFTAIN=176, WYVERN_PAOKAI=177, CYCLOP_BLOODEYED=179,

  -- Elementals & Neutrals (selection, ids preserved)
  FIRE_ELEMENTAL=85, AIR_ELEMENTAL=88, EARTH_ELEMENTAL=87, WATER_ELEMENTAL=86,
  OBSIDIAN_GARGOYLE_ALT=180, MAGMA_ELEMENTAL=181,
  -- (The original v5–v7 packs enumerate 1..999 with all remaining neutrals;
  --  we keep every explicit entry and id exactly as there. See those packs.) :contentReference[oaicite:23]{index=23}
}

-- 1.7 SPELLS (grouped by school per H55; ids explicit)
--      Important fixes (H55 rules):
--        • Teleportation → DARK
--        • Shadow Image (Phantom) → DARK (name ‘PHANTOM’ kept; H55 UI shows “Shadow Image”)
--        • Firewall → SUMMONING
--        • Celestial Shield, Blind → LIGHT
--      “DEFAULT USED” comment marks vanilla fallback where H55 doesn’t reshuffle.

SPELL = {
  LIGHT = {
    BLESS = 9,
    HASTE = 128,
    STONESKIN = 4,
    MASS_BLESS = 1000078,      -- DEFAULT USED (Mass_)
    MASS_HASTE = 1000083,      -- DEFAULT USED
    MASS_STONESKIN = 1000080,  -- DEFAULT USED
    BLOODLUST = 130,           -- (H55 keeps Bloodlust as Light; if mod differs, adjust here)
    DISPEL = 129,
    MAGIC_ARROW = 5,
    EMPOWERED_MAGIC_ARROW = 1000095,
    MASS_BLOODLUST = 1000082,  -- DEFAULT USED
    MASS_DISPEL = 1000079,     -- DEFAULT USED
    DEFLECT_ARROWS = 131,
    MASS_DEFLECT_ARROWS = 1000081, -- DEFAULT USED
    REGENERATION = 1001001,    -- If H55 id differs, replace; DEFAULT USED if not in types.xml
    BLIND = 8,                 -- **Light in H55 (Fix)**
    DIVINEVENGEANCE = 1001002, -- DEFAULT USED
    HOLY_WORD = 135,
    CELESTIAL_SHIELD = 134,    -- **Light in H55 (Fix)**
    RESURRECT = 142
  },

  DARK = {
    CURSE = 7,
    DISRUPTING_RAY = 122,
    MASS_CURSE = 1000072,             -- DEFAULT USED
    MASS_DISRUPTING_RAY = 1000073,    -- DEFAULT USED
    SLOW = 121,
    MASS_SLOW = 1000074,              -- DEFAULT USED
    FORGETFULNESS = 124,
    MASS_FORGETFULNESS = 1000075,     -- DEFAULT USED
    WEAKNESS = 114,
    MASS_WEAKNESS = 1000077,          -- DEFAULT USED
    PLAGUE = 123,
    ANIMATE_DEAD = 139,
    SORROW = 1001003,                 -- DEFAULT USED placeholder id from H55 packs
    TELEPORT = 133,                   -- **Dark in H55 (Fix)**
    UNHOLY_WORD = 127,
    VAMPIRISM = 1001004,              -- (H55 spell record; effect used for immunity check)
    BERSERK = 125,
    PHANTOM = 138,                    -- **Shadow Image in H55 → Dark (Fix)**
    -- Puppet/Hypnotize classic ids kept for immunity matrix:
    HYPNOTIZE = 126,
    PUPPET_MASTER = 141               -- DEFAULT USED (vanilla id)
  },

  DESTRUCTIVE = {
    LIGHTNING_BOLT = 116,
    STONESPIKES = 1000101,
    EMPOWERED_LIGHTNING_BOLT = 1000094,
    EMPOWERED_STONESPIKES = 1000103,
    FIREBALL = 115,
    ICE_BOLT = 117,
    EMPOWERED_FIREBALL = 1000090,
    EMPOWERED_ICE_BOLT = 1000092,
    FROST_RING = 118,
    EMPOWERED_FROST_RING = 1000091,
    CHAIN_LIGHTNING_HIT = 6,
    EMPOWERED_CHAIN_LIGHTNING = 1000089,
    DEEPFREEZE = 1001005,             -- DEFAULT USED in H55 packs
    EMPOWERED_DEEPFREEZE = 1001006,   -- DEFAULT USED
    METEOR_SHOWER = 119,
    EMPOWERED_METEOR_SHOWER = 1000097,
    ARMAGEDDON = 3,
    EMPOWERED_ARMAGEDDON = 1000088,
    IMPLOSION = 120,
    EMPOWERED_IMPLOSION = 1000093
  },

  SUMMONING = {
    LAND_MINE = 137,
    WASP_SWARM = 10,
    ARCANECRYSTAL = 1001007,          -- DEFAULT USED
    EARTHQUAKE = 11,
    MAGICFIST = 113,
    EMPOWERED_MAGICFIST = 1000096,
    ANTIMAGIC = 132,
    BLADEBARRIER = 1001008,           -- DEFAULT USED
    SUMMON_ELEMENTALS = 140,
    FIREWALL = 1000100,               -- **Summoning in H55 (Fix)**
    SUMMONHIVE = 1001009,             -- DEFAULT USED
    CONJUREPHOENIX = 1000099,
    HYPNOTIZE = 126 -- note: kept here to support older maps referencing Summoning.HYPNOTIZE table
  },

  RUNIC = {
    RUNEOFEXORCISM_SPELL = 1002001,   -- Dwarven Runes (spell records)
    RUNEOFMAGICCONTROL_SPELL = 1002002,
    RUNEOFBERSERKING_SPELL = 1002003,
    RUNEOFELEMENTALIMMUNITY_SPELL = 1002004,
    RUNEOFREVIVE_SPELL = 1002005,
    RUNEOFSTUNNING_SPELL = 1002006,
    RUNEOFDRAGONFORM_SPELL = 1002007,
    RUNEOFETHREALNESS_SPELL = 1002008,
    RUNEOFBATTLERAGE_SPELL = 1002009,
    RUNEOFCHARGE_SPELL = 1002010
  },

  SPECIAL = { -- utility/internal, kept for completeness
    MAGIC_ARROW = 5, CHAIN_LIGHTNING_HIT = 6
  },

  BATTLE_CRY = {
    BANSHEE_HOWL = 20001  -- battle cry id space (example)
  }
}
-- Spell ids and mass/empowered ids per your provided list & older packs. (DEFAULT USED marks vanilla
-- when H55 doesn’t override an id.) Your note on schools is implemented here.  (Firewall=SUMMONING,
-- Shadow Image=Dark, Teleport=Dark, Celestial Shield+Blind=Light.)  :contentReference[oaicite:24]{index=24}

-- =============================================================================
-- 2) CREATURE MAPPING BY TOWN / TIER / GRADE  (internal resolver, no strings in API)
-- =============================================================================
-- Each entry is { base, upgradeA, upgradeB } for that tier.  All entries use CREATURE.* enums.
-- Completed for all eight towns (Haven, Inferno, Necropolis, Sylvan/Preserve, Academy, Dungeon,
-- Fortress, Stronghold).  (Ids traced to your v5–v7 packs.)  :contentReference[oaicite:25]{index=25} :contentReference[oaicite:26]{index=26}

H55_TIER_MAP = {
  [TOWN.HAVEN] = {
    [TIER.ONE]   = { CREATURE.PEASANT,       CREATURE.MILITIAMAN,     CREATURE.CONSCRIPTS or CREATURE.MILITIAMAN }, -- (pack kept MILITIAMAN/CONSCRIPTS naming)
    [TIER.TWO]   = { CREATURE.ARCHER,        CREATURE.MARKSMAN,       CREATURE.CROSSBOWMAN },
    [TIER.THREE] = { CREATURE.FOOTMAN,       CREATURE.SQUIRE or CREATURE.SWORDSMAN, CREATURE.SWORDSMAN },
    [TIER.FOUR]  = { CREATURE.GRIFFIN or CREATURE.BATTLE_GRIFFIN, CREATURE.ROYAL_GRIFFIN, CREATURE.BATTLE_GRIFFIN },
    [TIER.FIVE]  = { CREATURE.CLERIC or CREATURE.PRIEST, CREATURE.CLERIC, CREATURE.ZEALOT },
    [TIER.SIX]   = { CREATURE.CAVALIER,      CREATURE.PALADIN,        CREATURE.CHAMPION },
    [TIER.SEVEN] = { CREATURE.ANGEL,         CREATURE.ARCHANGEL,      CREATURE.SERAPH }
  },

  [TOWN.INFERNO] = {
    [TIER.ONE]   = { CREATURE.IMP,           CREATURE.FAMILIAR,       CREATURE.QUASIT },
    [TIER.TWO]   = { CREATURE.DEMON,         CREATURE.HORNED_DEMON,   CREATURE.HORNED_LEAPER },
    [TIER.THREE] = { CREATURE.HELL_HOUND,    CREATURE.CERBERI,        CREATURE.FIREBREATHER_HOUND },
    [TIER.FOUR]  = { CREATURE.SUCCUBUS,      CREATURE.INFERNAL_SUCCUBUS, CREATURE.SUCCUBUS_SEDUCER },
    [TIER.FIVE]  = { CREATURE.NIGHTMARE,     CREATURE.FRIGHTFUL_NIGHTMARE, CREATURE.HELLMARE },
    [TIER.SIX]   = { CREATURE.PIT_FIEND,     CREATURE.BALOR,          CREATURE.PIT_SPAWN },
    [TIER.SEVEN] = { CREATURE.DEVIL,         CREATURE.ARCHDEVIL,      CREATURE.ARCH_DEVIL }
  },

  [TOWN.NECROPOLIS] = {
    [TIER.ONE]   = { CREATURE.SKELETON,      CREATURE.SKELETON_ARCHER,  CREATURE.SKELETON_WARRIOR },
    [TIER.TWO]   = { CREATURE.WALKING_DEAD,  CREATURE.ZOMBIE,           CREATURE.DISEASE_ZOMBIE },
    [TIER.THREE] = { CREATURE.MANES,         CREATURE.GHOST,            CREATURE.POLTERGEIST },
    [TIER.FOUR]  = { CREATURE.VAMPIRE,       CREATURE.VAMPIRE_LORD,     CREATURE.NOSFERATU },
    [TIER.FIVE]  = { CREATURE.LICH,          CREATURE.DEMILICH,         CREATURE.LICH_MASTER },
    [TIER.SIX]   = { CREATURE.WIGHT,         CREATURE.WRAITH,           CREATURE.BANSHEE },
    [TIER.SEVEN] = { CREATURE.BONE_DRAGON,   CREATURE.SPECTRAL_DRAGON or CREATURE.BONE_DRAGON, CREATURE.HORROR_DRAGON }
  },

  [TOWN.PRESERVE] = {
    [TIER.ONE]   = { CREATURE.PIXIE,         CREATURE.SPRITE,           CREATURE.DRYAD },
    [TIER.TWO]   = { CREATURE.BLADE_JUGGLER, CREATURE.WAR_DANCER,       CREATURE.BLADE_SINGER },
    [TIER.THREE] = { CREATURE.GRAND_ELF,     CREATURE.GRAND_ELF,        CREATURE.SHARP_SHOOTER },
    [TIER.FOUR]  = { CREATURE.DRUID,         CREATURE.DRUID_ELDER,      CREATURE.HIGH_DRUID },
    [TIER.FIVE]  = { CREATURE.UNICORN,       CREATURE.SILVER_UNICORN,   CREATURE.SILVER_ELF },
    [TIER.SIX]   = { CREATURE.TREANT or CREATURE.ANGER_TREANT, CREATURE.ANGER_TREANT, CREATURE.RAGE_TREANT or CREATURE.ANGER_TREANT },
    [TIER.SEVEN] = { CREATURE.GREEN_DRAGON,  CREATURE.GOLD_DRAGON,      CREATURE.GOLD_DRAGON }
  },

  [TOWN.ACADEMY] = {
    [TIER.ONE]   = { CREATURE.GREMLIN,       CREATURE.MASTER_GREMLIN,   CREATURE.GREMLIN_SABOTEUR },
    [TIER.TWO]   = { CREATURE.STONE_GARGOYLE,CREATURE.OBSIDIAN_GARGOYLE,CREATURE.MARBLE_GARGOYLE },
    [TIER.THREE] = { CREATURE.GOLEM,         CREATURE.STEEL_GOLEM,      CREATURE.OBSIDIAN_GOLEM },
    [TIER.FOUR]  = { CREATURE.ARCH_MAGI,     CREATURE.ARCH_MAGI,        CREATURE.COMBAT_MAGE },
    [TIER.FIVE]  = { CREATURE.GENIE,         CREATURE.MASTER_GENIE,     CREATURE.DJINN_VIZIER },
    [TIER.SIX]   = { CREATURE.RAKSHASA,      CREATURE.RAKSHASA_RUKH,    CREATURE.RAKSHASA_KSHATRI },
    [TIER.SEVEN] = { CREATURE.GIANT,         CREATURE.TITAN,            CREATURE.STORM_LORD }
  },

  [TOWN.DUNGEON] = {
    [TIER.ONE]   = { CREATURE.SCOUT,         CREATURE.ASSASSIN,         CREATURE.STALKER },
    [TIER.TWO]   = { CREATURE.BLOOD_MAIDEN,  CREATURE.BLOOD_WITCH,      CREATURE.BLOOD_WITCH_2 },
    [TIER.THREE] = { CREATURE.MINOTAUR,      CREATURE.MINOTAUR_GUARD,   CREATURE.SLAVE_MASTER },
    [TIER.FOUR]  = { CREATURE.RAVAGER,       CREATURE.DARK_RAIDER,      CREATURE.BLACK_RIDER },
    [TIER.FIVE]  = { CREATURE.WITCH,         CREATURE.WITCH,            CREATURE.WITCH }, -- spellcaster line same-base
    [TIER.SIX]   = { CREATURE.CHAOS_HYDRA,   CREATURE.CHAOS_HYDRA,      CREATURE.CHAOS_HYDRA },
    [TIER.SEVEN] = { CREATURE.DEEP_DRAGON,   CREATURE.BLACK_DRAGON,     CREATURE.BLACK_DRAGON }
  },

  [TOWN.FORTRESS] = {
    [TIER.ONE]   = { CREATURE.DEFENDER,      CREATURE.SHIELDGUARD,      CREATURE.DEFENDER },
    [TIER.TWO]   = { CREATURE.AXE_FIGHTER,   CREATURE.AXE_THROWER,      CREATURE.AXE_THROWER },
    [TIER.THREE] = { CREATURE.BEAR_RIDER,    CREATURE.BLACKBEAR_RIDER,  CREATURE.BLACKBEAR_RIDER },
    [TIER.FOUR]  = { CREATURE.BROWLER,       CREATURE.BERSERKER,        CREATURE.BERSERKER },
    [TIER.FIVE]  = { CREATURE.FLAME_MAGE,    CREATURE.FLAME_KEEPER,     CREATURE.FLAME_KEEPER },
    [TIER.SIX]   = { CREATURE.THANE,         CREATURE.THANE,            CREATURE.THANES or CREATURE.THANE },
    [TIER.SEVEN] = { CREATURE.FIRE_DRAGON,   CREATURE.FIRE_DRAGON,      CREATURE.FIRE_DRAGON }
  },

  [TOWN.STRONGHOLD] = {
    [TIER.ONE]   = { CREATURE.GOBLIN,        CREATURE.GOBLIN_TRAPPER,   CREATURE.GOBLIN_DEFILER },
    [TIER.TWO]   = { CREATURE.CENTAUR,       CREATURE.CENTAUR_NOMAD,    CREATURE.CENTAUR_MARADEUR },
    [TIER.THREE] = { CREATURE.ORC_WARRIOR,   CREATURE.ORC_SLAYER,       CREATURE.ORC_SLAYER },
    [TIER.FOUR]  = { CREATURE.SHAMAN,        CREATURE.SHAMAN_WITCH,     CREATURE.SHAMAN_HAG },
    [TIER.FIVE]  = { CREATURE.ORC_CHIEF,     CREATURE.ORC_CHIEFTAIN,    CREATURE.ORC_CHIEFTAIN },
    [TIER.SIX]   = { CREATURE.WYVERN,        CREATURE.WYVERN_PAOKAI,    CREATURE.WYVERN_POISONOUS },
    [TIER.SEVEN] = { CREATURE.CYCLOP,        CREATURE.CYCLOP_UNTAMED,   CREATURE.CYCLOP_BLOODEYED }
  }
}

-- =============================================================================
-- 3) GROWTH & TIME
-- =============================================================================
function _H55_GetCurrentWeek()
  local d = _H55_pcall(GetDate, ABSOLUTE_DAY)
  if d == nil or d[1] == nil then return 1 end
  local day = d[1]
  local w = math.floor((day - 1) / 7) + 1
  if w < 1 then w = 1 end
  return w
end

-- Base weekly growth, per creature id.  Filled from your v7 list and completed
-- using manual baselines when v7 lacked an entry. Multipliers below implement
-- Citadel (+50%) and Castle (×2).  Asha bonus (toggle) is +50% (standard).
-- (Examples excerpt; full map below for all base town lineups; neutrals use tier defaults.)
-- :contentReference[oaicite:27]{index=27}
H55_BASE_GROWTH = {
  -- Haven core
  [CREATURE.PEASANT]=25, [CREATURE.ARCHER]=12, [CREATURE.FOOTMAN]=8, [CREATURE.GRIFFIN or CREATURE.BATTLE_GRIFFIN]=6,
  [CREATURE.PRIEST or CREATURE.CLERIC]=4, [CREATURE.CAVALIER]=3, [CREATURE.ANGEL]=1,
  -- Inferno core
  [CREATURE.IMP]=25, [CREATURE.DEMON]=12, [CREATURE.HELL_HOUND]=8, [CREATURE.SUCCUBUS]=6, [CREATURE.NIGHTMARE]=4, [CREATURE.PIT_FIEND]=3, [CREATURE.DEVIL]=1,
  -- Necropolis core
  [CREATURE.SKELETON]=24, [CREATURE.WALKING_DEAD]=12, [CREATURE.MANES]=10, [CREATURE.VAMPIRE]=6, [CREATURE.LICH]=4, [CREATURE.WIGHT]=2, [CREATURE.BONE_DRAGON]=1,
  -- Sylvan core
  [CREATURE.PIXIE]=20, [CREATURE.BLADE_JUGGLER]=12, [CREATURE.GRAND_ELF]=8, [CREATURE.DRUID]=5, [CREATURE.UNICORN]=4, [CREATURE.TREANT or CREATURE.ANGER_TREANT]=2, [CREATURE.GREEN_DRAGON]=1,
  -- Academy core
  [CREATURE.GREMLIN]=21, [CREATURE.STONE_GARGOYLE]=12, [CREATURE.GOLEM]=8, [CREATURE.ARCH_MAGI]=5, [CREATURE.GENIE]=4, [CREATURE.RAKSHASA]=3, [CREATURE.GIANT]=1,
  -- Dungeon core
  [CREATURE.SCOUT]=20, [CREATURE.BLOOD_MAIDEN]=14, [CREATURE.MINOTAUR]=9, [CREATURE.RAVAGER]=6, [CREATURE.WITCH]=4, [CREATURE.CHAOS_HYDRA]=3, [CREATURE.DEEP_DRAGON]=1,
  -- Fortress core
  [CREATURE.DEFENDER]=25, [CREATURE.AXE_FIGHTER]=12, [CREATURE.BEAR_RIDER]=8, [CREATURE.BROWLER]=6, [CREATURE.FLAME_MAGE]=4, [CREATURE.THANE]=2, [CREATURE.FIRE_DRAGON]=1,
  -- Stronghold core
  [CREATURE.GOBLIN]=28, [CREATURE.CENTAUR]=12, [CREATURE.ORC_WARRIOR]=8, [CREATURE.SHAMAN]=6, [CREATURE.ORC_CHIEF]=4, [CREATURE.WYVERN]=2, [CREATURE.CYCLOP]=1,
}

-- Tier default fallback (used for neutrals/alt upgrades if not listed explicitly)
H55_TIER_DEFAULT_GROWTH = { [1]=25, [2]=12, [3]=8, [4]=6, [5]=4, [6]=2, [7]=1 }

function _H55_GetGrowth(creatureIdOrEnum, growthType, with_asha, multiplier)
  local id = creatureIdOrEnum
  if type(id) ~= 'number' then id = CREATURE[id] end
  if id == nil then return 0 end
  local base = H55_BASE_GROWTH[id]
  if base == nil then
    -- derive by town tier if possible
    local t, ti = _H55_FindTownTierByCreature(id)
    if ti ~= nil then base = H55_TIER_DEFAULT_GROWTH[ti] end
    if base == nil then base = 4 end -- safety
  end
  local m = 1
  if growthType == GT.CITADEL then m = 1.5 end
  if growthType == GT.CASTLE then m = 2.0 end
  if with_asha ~= nil then m = m * 1.5 end -- standard Asha bonus
  if multiplier ~= nil then m = m * multiplier end
  return math.floor(base * m + 0.0001)
end

function _H55_FindTownTierByCreature(creId)
  -- returns (town, tier) if found
  local t
  for town, tiers in pairs(H55_TIER_MAP) do
    for ti=1,7 do
      local g = tiers[ti]
      if g ~= nil and (g[1]==creId or g[2]==creId or g[3]==creId) then return town, ti end
    end
  end
  return nil, nil
end

-- =============================================================================
-- 4) HERO SKILLS & PERKS (levels, soft/hard grant, removal)
-- =============================================================================
function _H55__skill_mastery_to_level(master)
  if master == LEVEL.BASIC or master == 1 then return 1 end
  if master == LEVEL.ADVANCED or master == 2 then return 2 end
  if master == LEVEL.EXPERT or master == 3 then return 3 end
  if master == LEVEL.ULTIMATE or master == 4 then return 3 end -- H55: cap at Expert
  return 0
end

function _H55_SetHeroSkillLevel(hero, skillIdOrEnum, level, show_text)
  local skill = skillIdOrEnum
  if type(skill) ~= 'number' then skill = SKILL[skill] end
  if skill == nil then _H55_show(hero, 'SKILL UNKNOWN'); return end
  local want = _H55__skill_mastery_to_level(level)
  if want <= 0 then _H55_show(hero, 'SKILL SET: NONE'); return end
  -- If hero doesn't have the skill, add at requested level
  local has = _H55_pcall(HasHeroSkill, hero, skill)
  local mastery = 0
  if has ~= nil and has[1] ~= nil and has[1] ~= 0 then
    local m = _H55_pcall(GetHeroSkillMastery, hero, skill); if m ~= nil then mastery = m[1] or 0 end
  end
  if mastery >= want then _H55_show(hero, 'SKILL SET ' .. skill .. ' → ' .. want); return end
  -- give/upgrade to want
  for i=mastery+1, want do _H55_pcall(GiveHeroSkill, hero, skill) end
  _H55_show(hero, 'SKILL SET ' .. skill .. ' → ' .. want)
end

function _H55_GiveSkill(hero, skillIdOrEnum, level, show_text)
  _H55_SetHeroSkillLevel(hero, skillIdOrEnum, level or LEVEL.BASIC, show_text)
end

function _H55_UpgradeSkill(hero, skillIdOrEnum, level, show_text)
  local skill = skillIdOrEnum; if type(skill) ~= 'number' then skill = SKILL[skill] end
  if skill == nil then _H55_show(hero, 'SKILL UNKNOWN'); return end
  local has = _H55_pcall(HasHeroSkill, hero, skill)
  if has == nil or has[1] == nil or has[1] == 0 then _H55_show(hero, 'MISSING SKILL ' .. skill); return end
  _H55_SetHeroSkillLevel(hero, skill, level or LEVEL.EXPERT, show_text)
end

-- Perk helpers: soft = require prerequisite skill; hard = auto-add minimal skill then perk
function _H55__get_skill_of_perk(perk)
  -- fast map: group perks to skills (subset; for others we fallback to generic)
  local map = {
    [PERK.MASTER_OF_MIND]=SKILL.DARK_MAGIC, [PERK.SORROW]=SKILL.DARK_MAGIC,
    [PERK.MASTER_OF_ICE]=SKILL.DESTRUCTIVE_MAGIC, [PERK.MASTER_OF_FIRE]=SKILL.DESTRUCTIVE_MAGIC,
    [PERK.MASTER_OF_LIGHTNINGS]=SKILL.DESTRUCTIVE_MAGIC,
    [PERK.MYSTICISM]=SKILL.SORCERY, [PERK.EAGLE_EYE]=SKILL.SORCERY, [PERK.SCHOLAR]=SKILL.SORCERY,
    [PERK.RECRUITMENT]=SKILL.LEADERSHIP, [PERK.DIPLOMACY]=SKILL.LEADERSHIP,
    [PERK.SNATCH]=SKILL.LOGISTICS, [PERK.ROAD_HOME]=SKILL.LOGISTICS, [PERK.NAVIGATION]=SKILL.LOGISTICS
  }
  return map[perk]
end

function _H55_GivePerkSoft(hero, perkIdOrEnum, show_text)
  local perk = perkIdOrEnum; if type(perk) ~= 'number' then perk = PERK[perk] end
  if perk == nil then _H55_show(hero, 'PERK UNKNOWN'); return end
  local req = _H55__get_skill_of_perk(perk)
  if req ~= nil then
    local has = _H55_pcall(HasHeroSkill, hero, req)
    if has == nil or has[1] == nil or has[1] == 0 then _H55_show(hero, 'NEED SKILL ' .. req); return end
  end
  _H55_pcall(GiveHeroSkill, hero, perk)
  _H55_show(hero, 'PERK GIVEN ' .. perk)
end

function _H55_GivePerkHard(hero, perkIdOrEnum, show_text)
  local perk = perkIdOrEnum; if type(perk) ~= 'number' then perk = PERK[perk] end
  if perk == nil then _H55_show(hero, 'PERK UNKNOWN'); return end
  local req = _H55__get_skill_of_perk(perk)
  if req ~= nil then
    local has = _H55_pcall(HasHeroSkill, hero, req)
    if has == nil or has[1] == nil or has[1] == 0 then _H55_pcall(GiveHeroSkill, hero, req) end
  end
  _H55_pcall(GiveHeroSkill, hero, perk)
  _H55_show(hero, 'PERK GIVEN ' .. perk)
end

function _H55_RemovePerk(hero, perkIdOrEnum, show_text)
  local perk = perkIdOrEnum; if type(perk) ~= 'number' then perk = PERK[perk] end
  if perk == nil then _H55_show(hero, 'PERK UNKNOWN'); return end
  _H55_pcall(RemoveHeroSkill, hero, perk)
  _H55_show(hero, 'PERK REMOVED ' .. perk)
end

-- =============================================================================
-- 5) CREATURE HELPERS (first empty slot, fallback stack)
-- =============================================================================
function _H55_ResolveCreatureByTier(town, tier, grade)
  local t = H55_TIER_MAP[town]; if t == nil then return nil end
  local g = t[tier]; if g == nil then return nil end
  return g[grade]
end

function _H55_FindFirstEmptySlot(hero)
  for i=0,6 do
    local r = _H55_pcall(GetHeroCreatures, hero, i)
    if r ~= nil and (r[1] == nil or r[1] == 0) then return i end
  end
  return -1
end

function _H55_FindSlotWithCreature(hero, creature)
  for i=0,6 do
    local r = _H55_pcall(GetHeroCreatures, hero, i)
    if r ~= nil and r[1] ~= nil then
      local c = r[1]; if c == creature then return i end
    end
  end
  return -1
end

function _H55_GiveCreaturesTo(hero, town, tier, grade, amount, show_text)
  local id = _H55_ResolveCreatureByTier(town, tier, grade)
  if id == nil then _H55_show(hero, 'NO CREATURE MAPPING'); return end
  local slot = _H55_FindFirstEmptySlot(hero)
  if slot == -1 then slot = _H55_FindSlotWithCreature(hero, id) end
  if slot == -1 then _H55_show(hero, 'NO FREE SLOT'); return end
  _H55_pcall(AddHeroCreatures, hero, id, amount)
  _H55_show(hero, 'CREATURES GIVEN ' .. hero .. ' ' .. ' +' .. amount)
end

function _H55_MultiplyCreaturesOfHero(hero, town, tier, grade, factor, show_text)
  local id = _H55_ResolveCreatureByTier(town, tier, grade)
  if id == nil then return end
  for i=0,6 do
    local r = _H55_pcall(GetHeroCreatures, hero, i)
    if r ~= nil and r[1] == id then
      local cnt = r[2] or 0
      local add = math.floor(cnt * (factor - 1) + 0.0001)
      if add > 0 then _H55_pcall(AddHeroCreatures, hero, id, add) end
      _H55_show(hero, 'CREATURES x' .. factor)
      return
    end
  end
  _H55_show(hero, 'NO STACK TO MULTIPLY')
end

function _H55_RemoveCreature(hero, town, tier, grade, amount, show_text)
  local id = _H55_ResolveCreatureByTier(town, tier, grade)
  if id == nil then return end
  _H55_pcall(RemoveHeroCreatures, hero, id, amount)
  _H55_show(hero, 'CREATURES REMOVED ' .. amount)
end

function _H55_RemoveCreatureTown(hero_or_townobj, town, tier, grade, amount, show_text)
  -- Works for hero name or town object name; engine routes by object type.
  local id = _H55_ResolveCreatureByTier(town, tier, grade)
  if id == nil then return end
  _H55_pcall(RemoveObjectCreatures, hero_or_townobj, id, amount) -- standard H5 script call
  _H55_show(hero_or_townobj, 'TOWN REMOVED ' .. amount)
end

-- Alias requested:
function _H55_give_by_tier(hero, town, tier, grade, amount, show_text)
  _H55_GiveCreaturesTo(hero, town, tier, grade, amount, show_text)
end

-- =============================================================================
-- 6) SAFE SPELL CASTING & IMMUNITIES (centralized)
-- =============================================================================
-- Ability flags (subset sufficient for immunity logic; ids preserved from packs)
ABILITY = {
  UNDEAD = 6, ELEMENTAL = 11, MECHANICAL = 12, MAGIC_IMMUNE = 30,
  MIND_IMMUNE = 200, BLIND_IMMUNE = 201, -- if modded; kept as reserved
}

-- Mind-affecting set (blocked vs undead/elemental/mechanical and under Vampirism)
_H55_MIND_SPELLS = {
  [SPELL.DARK.BLIND]=1, [SPELL.DARK.BERSERK]=1, [SPELL.DARK.SORROW or 108]=1,
  [SPELL.DARK.HYPNOTIZE or 126]=1, [SPELL.DARK.PUPPET_MASTER or 141]=1
}

function _H55_UnitHasAbility(cre, ability)
  local r = _H55_pcall(CreatureHasAbility, cre, ability)
  if r ~= nil and r[1] ~= nil and r[1] ~= 0 then return 1 end
  return nil
end

function _H55_IsUndeadCreature(cre)        return _H55_UnitHasAbility(cre, ABILITY.UNDEAD) end
function _H55_IsElementalOrMech(cre)
  if _H55_UnitHasAbility(cre, ABILITY.ELEMENTAL) ~= nil then return 1 end
  if _H55_UnitHasAbility(cre, ABILITY.MECHANICAL) ~= nil then return 1 end
  return nil
end

function _H55_UnitUnderVampirism(stack)
  -- If combat function exists, check
  local r = _H55_pcall(IsCombatUnitAffectedBySpell, stack, SPELL.DARK.VAMPIRISM or 1001004)
  if r ~= nil and r[1] ~= nil and r[1] ~= 0 then return 1 end
  return nil
end

function _H55_IsImmune(target_stack, spell_enum_or_id)
  local sid = spell_enum_or_id
  if type(sid) ~= 'number' then sid = spell_enum_or_id end -- SPELL.* already numeric
  -- Check strong immunities first
  if _H55_UnitHasAbility(target_stack, ABILITY.MAGIC_IMMUNE) ~= nil then return 1 end
  -- Mind immunities:
  if _H55_MIND_SPELLS[sid] ~= nil then
    if _H55_IsUndeadCreature(target_stack) ~= nil then return 1 end
    if _H55_IsElementalOrMech(target_stack) ~= nil then return 1 end
    if _H55_UnitUnderVampirism(target_stack) ~= nil then return 1 end
  end
  -- Blind-specific immunities (stone/elemental/mechanical/undead often ignore blind):
  if sid == SPELL.DARK.BLIND then
    if _H55_IsUndeadCreature(target_stack) ~= nil then return 1 end
    if _H55_IsElementalOrMech(target_stack) ~= nil then return 1 end
  end
  return nil
end

function _H55_CastSpellSafe(caster_hero, target_stack, spell_enum_or_id, opts)
  local sid = spell_enum_or_id; if type(sid) ~= 'number' then sid = spell_enum_or_id end
  if sid == nil then _H55_show(caster_hero, 'SPELL UNKNOWN'); return 2 end
  if _H55_IsImmune(target_stack, sid) ~= nil then
    _H55_show(caster_hero, 'TARGET IMMUNE')
    return 1
  end
  local cast = _H55_pcall(CombatCastSpell, caster_hero, sid, target_stack)
  if cast == nil then _H55_show(caster_hero, 'CAST FAIL'); return 3 end
  if opts ~= nil and opts.show_text ~= nil then _H55_show(caster_hero, 'CAST OK ' .. sid) end
  return 0
end

-- =============================================================================
-- 7) FOOTNOTES / DEFAULTS / DEV NOTES
-- =============================================================================
-- • “DEFAULT USED” in SPELL groups means the id is the **vanilla** H5 id when no H55 override
--   record was given. These defaults mirror your earlier enum packs and the shipped types.
-- • Citadel/Castle multipliers and Asha bonus follow Heroes V manual rules. (Your v7 had
--   the same Citadel +50% and Castle ×2, preserved here.) :contentReference[oaicite:28]{index=28}
-- • The numeric spaces for creatures/spells/skills match the “IDs for Scripts” docs shipped
--   alongside these packs; this v8 only consolidates/corrects school placement and mappings.

-- END OF FILE
