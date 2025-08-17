--[[
  MMH55 ENUM/RESOLVER FRAMEWORK (Lua 4 compatible; NO 'local')
  Сreated: 2025-08-15 16:35:08
  Author: Alexander Logunov
  Source: types.xml

  Provides:
    * Dot-notation enums: HERO_SKILL, HERO_PERK (families), ABILITY, CREATURE
    * Robust resolvers to avoid typos and wrong IDs
    * Convenience wrappers: HeroHasPerk/Skill, AddHeroPerk/Skill, CreatureHasAbility

  Notes:
    - All hero fundamentals and perks are defined by HERO_SKILL_* in MMH55.
    - Creature abilities are enumerated by ABILITY_*.
    - Creature types are enumerated by CREATURE_*.
    - Exact creature→ability mapping is NOT in types.xml; see ACTUAL_DATA below.
]]

HERO_SKILL = {
  ARTIFICIER = { id = 17, name = 'ARTIFICIER', const = 'HERO_SKILL_ARTIFICIER' },
  AVENGER = { id = 16, name = 'AVENGER', const = 'HERO_SKILL_AVENGER' },
  BARBARIAN = { id = 179, name = 'BARBARIAN', const = 'HERO_SKILL_LUCK_OF_THE_BARBARIAN' },
  DARK_MAGIC = { id = 10, name = 'DARK_MAGIC', const = 'HERO_SKILL_DARK_MAGIC' },
  DEFENCE = { id = 7, name = 'DEFENCE', const = 'HERO_SKILL_DEFENCE' },
  DESTRUCTIVE_MAGIC = { id = 9, name = 'DESTRUCTIVE_MAGIC', const = 'HERO_SKILL_DESTRUCTIVE_MAGIC' },
  GATING = { id = 14, name = 'GATING', const = 'HERO_SKILL_GATING' },
  INVOCATION = { id = 18, name = 'INVOCATION', const = 'HERO_SKILL_INVOCATION' },
  LEADERSHIP = { id = 4, name = 'LEADERSHIP', const = 'HERO_SKILL_LEADERSHIP' },
  LIGHT_MAGIC = { id = 11, name = 'LIGHT_MAGIC', const = 'HERO_SKILL_LIGHT_MAGIC' },
  LOGISTICS = { id = 1, name = 'LOGISTICS', const = 'HERO_SKILL_LOGISTICS' },
  LUCK = { id = 5, name = 'LUCK', const = 'HERO_SKILL_LUCK' },
  NECROMANCY = { id = 15, name = 'NECROMANCY', const = 'HERO_SKILL_NECROMANCY' },
  OFFENCE = { id = 6, name = 'OFFENCE', const = 'HERO_SKILL_OFFENCE' },
  RUNELORE = { id = 151, name = 'RUNELORE', const = 'HERO_SKILL_RUNELORE' },
  SHATTER_DARK_MAGIC = { id = 195, name = 'SHATTER_DARK_MAGIC', const = 'HERO_SKILL_SHATTER_DARK_MAGIC' },
  SHATTER_DESTRUCTIVE_MAGIC = { id = 191, name = 'SHATTER_DESTRUCTIVE_MAGIC', const = 'HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC' },
  SHATTER_LIGHT_MAGIC = { id = 199, name = 'SHATTER_LIGHT_MAGIC', const = 'HERO_SKILL_SHATTER_LIGHT_MAGIC' },
  SHATTER_SUMMONING_MAGIC = { id = 203, name = 'SHATTER_SUMMONING_MAGIC', const = 'HERO_SKILL_SHATTER_SUMMONING_MAGIC' },
  SORCERY = { id = 8, name = 'SORCERY', const = 'HERO_SKILL_SORCERY' },
  SUMMONING_MAGIC = { id = 12, name = 'SUMMONING_MAGIC', const = 'HERO_SKILL_SUMMONING_MAGIC' },
  TRAINING = { id = 13, name = 'TRAINING', const = 'HERO_SKILL_TRAINING' },
  WAR_MACHINES = { id = 2, name = 'WAR_MACHINES', const = 'HERO_SKILL_WAR_MACHINES' },
}

HERO_PERK = {
  ABSOLUTE = {
    name = 'ABSOLUTE',
    items = {
      ABSOLUTE_CHARGE = { id = 85, name = 'ABSOLUTE_CHARGE', const = 'HERO_SKILL_ABSOLUTE_CHARGE' },
      ABSOLUTE_GATING = { id = 98, name = 'ABSOLUTE_GATING', const = 'HERO_SKILL_ABSOLUTE_GATING' },
      ABSOLUTE_FEAR = { id = 111, name = 'ABSOLUTE_FEAR', const = 'HERO_SKILL_ABSOLUTE_FEAR' },
      ABSOLUTE_LUCK = { id = 124, name = 'ABSOLUTE_LUCK', const = 'HERO_SKILL_ABSOLUTE_LUCK' },
      ABSOLUTE_WIZARDY = { id = 137, name = 'ABSOLUTE_WIZARDY', const = 'HERO_SKILL_ABSOLUTE_WIZARDY' },
      ABSOLUTE_CHAINS = { id = 150, name = 'ABSOLUTE_CHAINS', const = 'HERO_SKILL_ABSOLUTE_CHAINS' },
      ABSOLUTE_PROTECTION = { id = 167, name = 'ABSOLUTE_PROTECTION', const = 'HERO_SKILL_ABSOLUTE_PROTECTION' },
      ABSOLUTE_RAGE = { id = 176, name = 'ABSOLUTE_RAGE', const = 'HERO_SKILL_ABSOLUTE_RAGE' },
    }
  },
  ACADEMY = {
    name = 'ACADEMY',
    items = {
      ACADEMY_AWARD = { id = 127, name = 'ACADEMY_AWARD', const = 'HERO_SKILL_ACADEMY_AWARD' },
    }
  },
  ANCIENT = {
    name = 'ANCIENT',
    items = {
      ANCIENT_SMITHY = { id = 82, name = 'ANCIENT_SMITHY', const = 'HERO_SKILL_ANCIENT_SMITHY' },
    }
  },
  ARCANE = {
    name = 'ARCANE',
    items = {
      ARCANE_TRAINING = { id = 42, name = 'ARCANE_TRAINING', const = 'HERO_SKILL_ARCANE_TRAINING' },
    }
  },
  ARCHERY = {
    name = 'ARCHERY',
    items = {
      ARCHERY = { id = 35, name = 'ARCHERY', const = 'HERO_SKILL_ARCHERY' },
    }
  },
  ARTIFICIAL = {
    name = 'ARTIFICIAL',
    items = {
      ARTIFICIAL_GLORY = { id = 128, name = 'ARTIFICIAL_GLORY', const = 'HERO_SKILL_ARTIFICIAL_GLORY' },
    }
  },
  BALLISTA = {
    name = 'BALLISTA',
    items = {
      BALLISTA = { id = 23, name = 'BALLISTA', const = 'HERO_SKILL_BALLISTA' },
    }
  },
  BARBARIAN = {
    name = 'BARBARIAN',
    items = {
      BARBARIAN_LEARNING = { id = 183, name = 'BARBARIAN_LEARNING', const = 'HERO_SKILL_BARBARIAN_LEARNING' },
      BARBARIAN_ANCIENT_SMITHY = { id = 208, name = 'BARBARIAN_ANCIENT_SMITHY', const = 'HERO_SKILL_BARBARIAN_ANCIENT_SMITHY' },
      BARBARIAN_WEAKENING_STRIKE = { id = 209, name = 'BARBARIAN_WEAKENING_STRIKE', const = 'HERO_SKILL_BARBARIAN_WEAKENING_STRIKE' },
      BARBARIAN_SOIL_BURN = { id = 210, name = 'BARBARIAN_SOIL_BURN', const = 'HERO_SKILL_BARBARIAN_SOIL_BURN' },
      BARBARIAN_FOG_VEIL = { id = 211, name = 'BARBARIAN_FOG_VEIL', const = 'HERO_SKILL_BARBARIAN_FOG_VEIL' },
      BARBARIAN_INTELLIGENCE = { id = 212, name = 'BARBARIAN_INTELLIGENCE', const = 'HERO_SKILL_BARBARIAN_INTELLIGENCE' },
      BARBARIAN_MYSTICISM = { id = 213, name = 'BARBARIAN_MYSTICISM', const = 'HERO_SKILL_BARBARIAN_MYSTICISM' },
      BARBARIAN_ELITE_CASTERS = { id = 214, name = 'BARBARIAN_ELITE_CASTERS', const = 'HERO_SKILL_BARBARIAN_ELITE_CASTERS' },
      BARBARIAN_STORM_WIND = { id = 215, name = 'BARBARIAN_STORM_WIND', const = 'HERO_SKILL_BARBARIAN_STORM_WIND' },
      BARBARIAN_FIRE_PROTECTION = { id = 216, name = 'BARBARIAN_FIRE_PROTECTION', const = 'HERO_SKILL_BARBARIAN_FIRE_PROTECTION' },
      BARBARIAN_SUN_FIRE = { id = 217, name = 'BARBARIAN_SUN_FIRE', const = 'HERO_SKILL_BARBARIAN_SUN_FIRE' },
      BARBARIAN_DISTRACT = { id = 218, name = 'BARBARIAN_DISTRACT', const = 'HERO_SKILL_BARBARIAN_DISTRACT' },
      BARBARIAN_DARK_REVELATION = { id = 219, name = 'BARBARIAN_DARK_REVELATION', const = 'HERO_SKILL_BARBARIAN_DARK_REVELATION' },
      BARBARIAN_MENTORING = { id = 220, name = 'BARBARIAN_MENTORING', const = 'HERO_SKILL_BARBARIAN_MENTORING' },
    }
  },
  BATTLE = {
    name = 'BATTLE',
    items = {
      BATTLE_ELATION = { id = 178, name = 'BATTLE_ELATION', const = 'HERO_SKILL_BATTLE_ELATION' },
    }
  },
  BODYBUILDING = {
    name = 'BODYBUILDING',
    items = {
      BODYBUILDING = { id = 186, name = 'BODYBUILDING', const = 'HERO_SKILL_BODYBUILDING' },
    }
  },
  CASTER = {
    name = 'CASTER',
    items = {
      CASTER_CERTIFICATE = { id = 81, name = 'CASTER_CERTIFICATE', const = 'HERO_SKILL_CASTER_CERTIFICATE' },
    }
  },
  CATAPULT = {
    name = 'CATAPULT',
    items = {
      CATAPULT = { id = 24, name = 'CATAPULT', const = 'HERO_SKILL_CATAPULT' },
    }
  },
  CHAOTIC = {
    name = 'CHAOTIC',
    items = {
      CHAOTIC_SPELLS = { id = 145, name = 'CHAOTIC_SPELLS', const = 'HERO_SKILL_CHAOTIC_SPELLS' },
    }
  },
  CHILLING = {
    name = 'CHILLING',
    items = {
      CHILLING_STEEL = { id = 104, name = 'CHILLING_STEEL', const = 'HERO_SKILL_CHILLING_STEEL' },
      CHILLING_BONES = { id = 105, name = 'CHILLING_BONES', const = 'HERO_SKILL_CHILLING_BONES' },
    }
  },
  CONSUME = {
    name = 'CONSUME',
    items = {
      CONSUME_CORPSE = { id = 58, name = 'CONSUME_CORPSE', const = 'HERO_SKILL_CONSUME_CORPSE' },
    }
  },
  CORRUPT = {
    name = 'CORRUPT',
    items = {
      CORRUPT_DESTRUCTIVE = { id = 192, name = 'CORRUPT_DESTRUCTIVE', const = 'HERO_SKILL_CORRUPT_DESTRUCTIVE' },
      CORRUPT_DARK = { id = 196, name = 'CORRUPT_DARK', const = 'HERO_SKILL_CORRUPT_DARK' },
      CORRUPT_LIGHT = { id = 200, name = 'CORRUPT_LIGHT', const = 'HERO_SKILL_CORRUPT_LIGHT' },
      CORRUPT_SUMMONING = { id = 204, name = 'CORRUPT_SUMMONING', const = 'HERO_SKILL_CORRUPT_SUMMONING' },
    }
  },
  COUNTERSPELL = {
    name = 'COUNTERSPELL',
    items = {
      COUNTERSPELL = { id = 132, name = 'COUNTERSPELL', const = 'HERO_SKILL_COUNTERSPELL' },
    }
  },
  CRITICAL = {
    name = 'CRITICAL',
    items = {
      CRITICAL_GATING = { id = 90, name = 'CRITICAL_GATING', const = 'HERO_SKILL_CRITICAL_GATING' },
      CRITICAL_STRIKE = { id = 91, name = 'CRITICAL_STRIKE', const = 'HERO_SKILL_CRITICAL_STRIKE' },
    }
  },
  CUNNING = {
    name = 'CUNNING',
    items = {
      CUNNING_OF_THE_WOODS = { id = 114, name = 'CUNNING_OF_THE_WOODS', const = 'HERO_SKILL_CUNNING_OF_THE_WOODS' },
    }
  },
  DARK = {
    name = 'DARK',
    items = {
      DARK_RITUAL = { id = 71, name = 'DARK_RITUAL', const = 'HERO_SKILL_DARK_RITUAL' },
      DARK_REVELATION = { id = 140, name = 'DARK_REVELATION', const = 'HERO_SKILL_DARK_REVELATION' },
    }
  },
  DEAD = {
    name = 'DEAD',
    items = {
      DEAD_LUCK = { id = 103, name = 'DEAD_LUCK', const = 'HERO_SKILL_DEAD_LUCK' },
    }
  },
  DEADLY = {
    name = 'DEADLY',
    items = {
      DEADLY_COLD = { id = 107, name = 'DEADLY_COLD', const = 'HERO_SKILL_DEADLY_COLD' },
    }
  },
  DEATH = {
    name = 'DEATH',
    items = {
      DEATH_SCREAM = { id = 63, name = 'DEATH_SCREAM', const = 'HERO_SKILL_DEATH_SCREAM' },
      DEATH_TREAD = { id = 99, name = 'DEATH_TREAD', const = 'HERO_SKILL_DEATH_TREAD' },
      DEATH_TO_NONEXISTENT = { id = 207, name = 'DEATH_TO_NONEXISTENT', const = 'HERO_SKILL_DEATH_TO_NONEXISTENT' },
    }
  },
  DEFEND = {
    name = 'DEFEND',
    items = {
      DEFEND_US_ALL = { id = 181, name = 'DEFEND_US_ALL', const = 'HERO_SKILL_DEFEND_US_ALL' },
    }
  },
  DEFENSIVE = {
    name = 'DEFENSIVE',
    items = {
      DEFENSIVE_FORMATION = { id = 161, name = 'DEFENSIVE_FORMATION', const = 'HERO_SKILL_DEFENSIVE_FORMATION' },
    }
  },
  DEMONIC = {
    name = 'DEMONIC',
    items = {
      DEMONIC_FIRE = { id = 59, name = 'DEMONIC_FIRE', const = 'HERO_SKILL_DEMONIC_FIRE' },
      DEMONIC_STRIKE = { id = 60, name = 'DEMONIC_STRIKE', const = 'HERO_SKILL_DEMONIC_STRIKE' },
      DEMONIC_RETALIATION = { id = 92, name = 'DEMONIC_RETALIATION', const = 'HERO_SKILL_DEMONIC_RETALIATION' },
      DEMONIC_FLAME = { id = 94, name = 'DEMONIC_FLAME', const = 'HERO_SKILL_DEMONIC_FLAME' },
      DEMONIC_RAGE = { id = 172, name = 'DEMONIC_RAGE', const = 'HERO_SKILL_DEMONIC_RAGE' },
    }
  },
  DETAIN = {
    name = 'DETAIN',
    items = {
      DETAIN_DESTRUCTIVE = { id = 194, name = 'DETAIN_DESTRUCTIVE', const = 'HERO_SKILL_DETAIN_DESTRUCTIVE' },
      DETAIN_DARK = { id = 198, name = 'DETAIN_DARK', const = 'HERO_SKILL_DETAIN_DARK' },
      DETAIN_LIGHT = { id = 202, name = 'DETAIN_LIGHT', const = 'HERO_SKILL_DETAIN_LIGHT' },
      DETAIN_SUMMONING = { id = 206, name = 'DETAIN_SUMMONING', const = 'HERO_SKILL_DETAIN_SUMMONING' },
    }
  },
  DIPLOMACY = {
    name = 'DIPLOMACY',
    items = {
      DIPLOMACY = { id = 30, name = 'DIPLOMACY', const = 'HERO_SKILL_DIPLOMACY' },
    }
  },
  DISGUISE = {
    name = 'DISGUISE',
    items = {
      DISGUISE_AND_RECKON = { id = 112, name = 'DISGUISE_AND_RECKON', const = 'HERO_SKILL_DISGUISE_AND_RECKON' },
    }
  },
  DISTRACT = {
    name = 'DISTRACT',
    items = {
      DISTRACT = { id = 162, name = 'DISTRACT', const = 'HERO_SKILL_DISTRACT' },
    }
  },
  DWARVEN = {
    name = 'DWARVEN',
    items = {
      DWARVEN_LUCK = { id = 159, name = 'DWARVEN_LUCK', const = 'HERO_SKILL_DWARVEN_LUCK' },
    }
  },
  EAGLE = {
    name = 'EAGLE',
    items = {
      EAGLE_EYE = { id = 27, name = 'EAGLE_EYE', const = 'HERO_SKILL_EAGLE_EYE' },
    }
  },
  ELEMENTAL = {
    name = 'ELEMENTAL',
    items = {
      ELEMENTAL_VISION = { id = 72, name = 'ELEMENTAL_VISION', const = 'HERO_SKILL_ELEMENTAL_VISION' },
      ELEMENTAL_BALANCE = { id = 84, name = 'ELEMENTAL_BALANCE', const = 'HERO_SKILL_ELEMENTAL_BALANCE' },
      ELEMENTAL_OVERKILL = { id = 149, name = 'ELEMENTAL_OVERKILL', const = 'HERO_SKILL_ELEMENTAL_OVERKILL' },
    }
  },
  ELITE = {
    name = 'ELITE',
    items = {
      ELITE_CASTERS = { id = 148, name = 'ELITE_CASTERS', const = 'HERO_SKILL_ELITE_CASTERS' },
    }
  },
  ELVEN = {
    name = 'ELVEN',
    items = {
      ELVEN_LUCK = { id = 116, name = 'ELVEN_LUCK', const = 'HERO_SKILL_ELVEN_LUCK' },
    }
  },
  EMPATHY = {
    name = 'EMPATHY',
    items = {
      EMPATHY = { id = 170, name = 'EMPATHY', const = 'HERO_SKILL_EMPATHY' },
    }
  },
  EMPOWERED = {
    name = 'EMPOWERED',
    items = {
      EMPOWERED_SPELLS = { id = 70, name = 'EMPOWERED_SPELLS', const = 'HERO_SKILL_EMPOWERED_SPELLS' },
    }
  },
  ENCOURAGE = {
    name = 'ENCOURAGE',
    items = {
      ENCOURAGE = { id = 75, name = 'ENCOURAGE', const = 'HERO_SKILL_ENCOURAGE' },
    }
  },
  ESTATES = {
    name = 'ESTATES',
    items = {
      ESTATES = { id = 29, name = 'ESTATES', const = 'HERO_SKILL_ESTATES' },
    }
  },
  ETERNAL = {
    name = 'ETERNAL',
    items = {
      ETERNAL_LIGHT = { id = 165, name = 'ETERNAL_LIGHT', const = 'HERO_SKILL_ETERNAL_LIGHT' },
    }
  },
  EVASION = {
    name = 'EVASION',
    items = {
      EVASION = { id = 38, name = 'EVASION', const = 'HERO_SKILL_EVASION' },
    }
  },
  EXPERT = {
    name = 'EXPERT',
    items = {
      EXPERT_TRAINER = { id = 57, name = 'EXPERT_TRAINER', const = 'HERO_SKILL_EXPERT_TRAINER' },
    }
  },
  EXPLODING = {
    name = 'EXPLODING',
    items = {
      EXPLODING_CORPSES = { id = 93, name = 'EXPLODING_CORPSES', const = 'HERO_SKILL_EXPLODING_CORPSES' },
    }
  },
  FAST = {
    name = 'FAST',
    items = {
      FAST_AND_FURIOUS = { id = 141, name = 'FAST_AND_FURIOUS', const = 'HERO_SKILL_FAST_AND_FURIOUS' },
    }
  },
  FINE = {
    name = 'FINE',
    items = {
      FINE_RUNE = { id = 154, name = 'FINE_RUNE', const = 'HERO_SKILL_FINE_RUNE' },
    }
  },
  FIRE = {
    name = 'FIRE',
    items = {
      FIRE_PROTECTION = { id = 96, name = 'FIRE_PROTECTION', const = 'HERO_SKILL_FIRE_PROTECTION' },
      FIRE_AFFINITY = { id = 97, name = 'FIRE_AFFINITY', const = 'HERO_SKILL_FIRE_AFFINITY' },
    }
  },
  FIRST = {
    name = 'FIRST',
    items = {
      FIRST_AID = { id = 22, name = 'FIRST_AID', const = 'HERO_SKILL_FIRST_AID' },
    }
  },
  FOG = {
    name = 'FOG',
    items = {
      FOG_VEIL = { id = 123, name = 'FOG_VEIL', const = 'HERO_SKILL_FOG_VEIL' },
    }
  },
  FOREST = {
    name = 'FOREST',
    items = {
      FOREST_GUARD_EMBLEM = { id = 115, name = 'FOREST_GUARD_EMBLEM', const = 'HERO_SKILL_FOREST_GUARD_EMBLEM' },
      FOREST_RAGE = { id = 117, name = 'FOREST_RAGE', const = 'HERO_SKILL_FOREST_RAGE' },
    }
  },
  FORTUNATE = {
    name = 'FORTUNATE',
    items = {
      FORTUNATE_ADVENTURER = { id = 33, name = 'FORTUNATE_ADVENTURER', const = 'HERO_SKILL_FORTUNATE_ADVENTURER' },
    }
  },
  FRENZY = {
    name = 'FRENZY',
    items = {
      FRENZY = { id = 36, name = 'FRENZY', const = 'HERO_SKILL_FRENZY' },
    }
  },
  GATING = {
    name = 'GATING',
    items = {
      GATING_MASTERY = { id = 89, name = 'GATING_MASTERY', const = 'HERO_SKILL_GATING_MASTERY' },
    }
  },
  GOBLIN = {
    name = 'GOBLIN',
    items = {
      GOBLIN_SUPPORT = { id = 182, name = 'GOBLIN_SUPPORT', const = 'HERO_SKILL_GOBLIN_SUPPORT' },
    }
  },
  GRAIL = {
    name = 'GRAIL',
    items = {
      GRAIL_VISION = { id = 80, name = 'GRAIL_VISION', const = 'HERO_SKILL_GRAIL_VISION' },
    }
  },
  GUARDIAN = {
    name = 'GUARDIAN',
    items = {
      GUARDIAN_ANGEL = { id = 78, name = 'GUARDIAN_ANGEL', const = 'HERO_SKILL_GUARDIAN_ANGEL' },
    }
  },
  HAUNT = {
    name = 'HAUNT',
    items = {
      HAUNT_MINE = { id = 110, name = 'HAUNT_MINE', const = 'HERO_SKILL_HAUNT_MINE' },
    }
  },
  HERALD = {
    name = 'HERALD',
    items = {
      HERALD_OF_DEATH = { id = 102, name = 'HERALD_OF_DEATH', const = 'HERO_SKILL_HERALD_OF_DEATH' },
    }
  },
  HOLD = {
    name = 'HOLD',
    items = {
      HOLD_GROUND = { id = 77, name = 'HOLD_GROUND', const = 'HERO_SKILL_HOLD_GROUND' },
    }
  },
  HOLY = {
    name = 'HOLY',
    items = {
      HOLY_CHARGE = { id = 55, name = 'HOLY_CHARGE', const = 'HERO_SKILL_HOLY_CHARGE' },
    }
  },
  IMBUE = {
    name = 'IMBUE',
    items = {
      IMBUE_ARROW = { id = 66, name = 'IMBUE_ARROW', const = 'HERO_SKILL_IMBUE_ARROW' },
      IMBUE_BALLISTA = { id = 113, name = 'IMBUE_BALLISTA', const = 'HERO_SKILL_IMBUE_BALLISTA' },
    }
  },
  INSIGHTS = {
    name = 'INSIGHTS',
    items = {
      INSIGHTS = { id = 119, name = 'INSIGHTS', const = 'HERO_SKILL_INSIGHTS' },
    }
  },
  INTELLIGENCE = {
    name = 'INTELLIGENCE',
    items = {
      INTELLIGENCE = { id = 25, name = 'INTELLIGENCE', const = 'HERO_SKILL_INTELLIGENCE' },
    }
  },
  LAST = {
    name = 'LAST',
    items = {
      LAST_AID = { id = 100, name = 'LAST_AID', const = 'HERO_SKILL_LAST_AID' },
      LAST_STAND = { id = 118, name = 'LAST_STAND', const = 'HERO_SKILL_LAST_STAND' },
    }
  },
  LEARNING = {
    name = 'LEARNING',
    items = {
      LEARNING = { id = 3, name = 'LEARNING', const = 'HERO_SKILL_LEARNING' },
    }
  },
  LORD = {
    name = 'LORD',
    items = {
      LORD_OF_UNDEAD = { id = 101, name = 'LORD_OF_UNDEAD', const = 'HERO_SKILL_LORD_OF_UNDEAD' },
    }
  },
  LUCKY = {
    name = 'LUCKY',
    items = {
      LUCKY_STRIKE = { id = 32, name = 'LUCKY_STRIKE', const = 'HERO_SKILL_LUCKY_STRIKE' },
      LUCKY_SPELLS = { id = 142, name = 'LUCKY_SPELLS', const = 'HERO_SKILL_LUCKY_SPELLS' },
    }
  },
  MAGIC = {
    name = 'MAGIC',
    items = {
      MAGIC_BOND = { id = 67, name = 'MAGIC_BOND', const = 'HERO_SKILL_MAGIC_BOND' },
      MAGIC_MIRROR = { id = 69, name = 'MAGIC_MIRROR', const = 'HERO_SKILL_MAGIC_MIRROR' },
      MAGIC_CUSHION = { id = 133, name = 'MAGIC_CUSHION', const = 'HERO_SKILL_MAGIC_CUSHION' },
    }
  },
  MARCH = {
    name = 'MARCH',
    items = {
      MARCH_OF_THE_MACHINES = { id = 125, name = 'MARCH_OF_THE_MACHINES', const = 'HERO_SKILL_MARCH_OF_THE_MACHINES' },
    }
  },
  MASTER = {
    name = 'MASTER',
    items = {
      MASTER_OF_ICE = { id = 43, name = 'MASTER_OF_ICE', const = 'HERO_SKILL_MASTER_OF_ICE' },
      MASTER_OF_FIRE = { id = 44, name = 'MASTER_OF_FIRE', const = 'HERO_SKILL_MASTER_OF_FIRE' },
      MASTER_OF_LIGHTNINGS = { id = 45, name = 'MASTER_OF_LIGHTNINGS', const = 'HERO_SKILL_MASTER_OF_LIGHTNINGS' },
      MASTER_OF_CURSES = { id = 46, name = 'MASTER_OF_CURSES', const = 'HERO_SKILL_MASTER_OF_CURSES' },
      MASTER_OF_MIND = { id = 47, name = 'MASTER_OF_MIND', const = 'HERO_SKILL_MASTER_OF_MIND' },
      MASTER_OF_SICKNESS = { id = 48, name = 'MASTER_OF_SICKNESS', const = 'HERO_SKILL_MASTER_OF_SICKNESS' },
      MASTER_OF_BLESSING = { id = 49, name = 'MASTER_OF_BLESSING', const = 'HERO_SKILL_MASTER_OF_BLESSING' },
      MASTER_OF_ABJURATION = { id = 50, name = 'MASTER_OF_ABJURATION', const = 'HERO_SKILL_MASTER_OF_ABJURATION' },
      MASTER_OF_WRATH = { id = 51, name = 'MASTER_OF_WRATH', const = 'HERO_SKILL_MASTER_OF_WRATH' },
      MASTER_OF_QUAKES = { id = 52, name = 'MASTER_OF_QUAKES', const = 'HERO_SKILL_MASTER_OF_QUAKES' },
      MASTER_OF_CREATURES = { id = 53, name = 'MASTER_OF_CREATURES', const = 'HERO_SKILL_MASTER_OF_CREATURES' },
      MASTER_OF_ANIMATION = { id = 54, name = 'MASTER_OF_ANIMATION', const = 'HERO_SKILL_MASTER_OF_ANIMATION' },
      MASTER_OF_SECRETS = { id = 87, name = 'MASTER_OF_SECRETS', const = 'HERO_SKILL_MASTER_OF_SECRETS' },
    }
  },
  MELT = {
    name = 'MELT',
    items = {
      MELT_ARTIFACT = { id = 68, name = 'MELT_ARTIFACT', const = 'HERO_SKILL_MELT_ARTIFACT' },
    }
  },
  MEMORY = {
    name = 'MEMORY',
    items = {
      MEMORY_OF_OUR_BLOOD = { id = 174, name = 'MEMORY_OF_OUR_BLOOD', const = 'HERO_SKILL_MEMORY_OF_OUR_BLOOD' },
    }
  },
  MENTORING = {
    name = 'MENTORING',
    items = {
      MENTORING = { id = 169, name = 'MENTORING', const = 'HERO_SKILL_MENTORING' },
    }
  },
  MIGHT = {
    name = 'MIGHT',
    items = {
      MIGHT_OVER_MAGIC = { id = 173, name = 'MIGHT_OVER_MAGIC', const = 'HERO_SKILL_MIGHT_OVER_MAGIC' },
    }
  },
  MIGHTY = {
    name = 'MIGHTY',
    items = {
      MIGHTY_VOICE = { id = 189, name = 'MIGHTY_VOICE', const = 'HERO_SKILL_MIGHTY_VOICE' },
    }
  },
  MULTISHOT = {
    name = 'MULTISHOT',
    items = {
      MULTISHOT = { id = 64, name = 'MULTISHOT', const = 'HERO_SKILL_MULTISHOT' },
    }
  },
  MYSTICISM = {
    name = 'MYSTICISM',
    items = {
      MYSTICISM = { id = 40, name = 'MYSTICISM', const = 'HERO_SKILL_MYSTICISM' },
    }
  },
  NAVIGATION = {
    name = 'NAVIGATION',
    items = {
      NAVIGATION = { id = 21, name = 'NAVIGATION', const = 'HERO_SKILL_NAVIGATION' },
    }
  },
  NO = {
    name = 'NO',
    items = {
      NO_REST_FOR_THE_WICKED = { id = 62, name = 'NO_REST_FOR_THE_WICKED', const = 'HERO_SKILL_NO_REST_FOR_THE_WICKED' },
    }
  },
  NONE = {
    name = 'NONE',
    items = {
      NONE = { id = 0, name = 'NONE', const = 'HERO_SKILL_NONE' },
    }
  },
  OFFENSIVE = {
    name = 'OFFENSIVE',
    items = {
      OFFENSIVE_FORMATION = { id = 160, name = 'OFFENSIVE_FORMATION', const = 'HERO_SKILL_OFFENSIVE_FORMATION' },
    }
  },
  PARIAH = {
    name = 'PARIAH',
    items = {
      PARIAH = { id = 83, name = 'PARIAH', const = 'HERO_SKILL_PARIAH' },
    }
  },
  PATH = {
    name = 'PATH',
    items = {
      PATH_OF_WAR = { id = 177, name = 'PATH_OF_WAR', const = 'HERO_SKILL_PATH_OF_WAR' },
    }
  },
  PATHFINDING = {
    name = 'PATHFINDING',
    items = {
      PATHFINDING = { id = 19, name = 'PATHFINDING', const = 'HERO_SKILL_PATHFINDING' },
    }
  },
  PAYBACK = {
    name = 'PAYBACK',
    items = {
      PAYBACK = { id = 147, name = 'PAYBACK', const = 'HERO_SKILL_PAYBACK' },
    }
  },
  POWER = {
    name = 'POWER',
    items = {
      POWER_OF_HASTE = { id = 143, name = 'POWER_OF_HASTE', const = 'HERO_SKILL_POWER_OF_HASTE' },
      POWER_OF_STONE = { id = 144, name = 'POWER_OF_STONE', const = 'HERO_SKILL_POWER_OF_STONE' },
      POWER_OF_BLOOD = { id = 184, name = 'POWER_OF_BLOOD', const = 'HERO_SKILL_POWER_OF_BLOOD' },
    }
  },
  POWERFULL = {
    name = 'POWERFULL',
    items = {
      POWERFULL_BLOW = { id = 175, name = 'POWERFULL_BLOW', const = 'HERO_SKILL_POWERFULL_BLOW' },
    }
  },
  PRAYER = {
    name = 'PRAYER',
    items = {
      PRAYER = { id = 56, name = 'PRAYER', const = 'HERO_SKILL_PRAYER' },
    }
  },
  PREPARATION = {
    name = 'PREPARATION',
    items = {
      PREPARATION = { id = 171, name = 'PREPARATION', const = 'HERO_SKILL_PREPARATION' },
    }
  },
  PROTECTION = {
    name = 'PROTECTION',
    items = {
      PROTECTION = { id = 37, name = 'PROTECTION', const = 'HERO_SKILL_PROTECTION' },
    }
  },
  QUICK = {
    name = 'QUICK',
    items = {
      QUICK_GATING = { id = 86, name = 'QUICK_GATING', const = 'HERO_SKILL_QUICK_GATING' },
    }
  },
  QUICKNESS = {
    name = 'QUICKNESS',
    items = {
      QUICKNESS_OF_MIND = { id = 155, name = 'QUICKNESS_OF_MIND', const = 'HERO_SKILL_QUICKNESS_OF_MIND' },
    }
  },
  RAISE = {
    name = 'RAISE',
    items = {
      RAISE_ARCHERS = { id = 61, name = 'RAISE_ARCHERS', const = 'HERO_SKILL_RAISE_ARCHERS' },
    }
  },
  RECRUITMENT = {
    name = 'RECRUITMENT',
    items = {
      RECRUITMENT = { id = 28, name = 'RECRUITMENT', const = 'HERO_SKILL_RECRUITMENT' },
    }
  },
  REFRESH = {
    name = 'REFRESH',
    items = {
      REFRESH_RUNE = { id = 152, name = 'REFRESH_RUNE', const = 'HERO_SKILL_REFRESH_RUNE' },
    }
  },
  REMOTE = {
    name = 'REMOTE',
    items = {
      REMOTE_CONTROL = { id = 126, name = 'REMOTE_CONTROL', const = 'HERO_SKILL_REMOTE_CONTROL' },
    }
  },
  RESISTANCE = {
    name = 'RESISTANCE',
    items = {
      RESISTANCE = { id = 31, name = 'RESISTANCE', const = 'HERO_SKILL_RESISTANCE' },
    }
  },
  RETRIBUTION = {
    name = 'RETRIBUTION',
    items = {
      RETRIBUTION = { id = 76, name = 'RETRIBUTION', const = 'HERO_SKILL_RETRIBUTION' },
    }
  },
  ROAD = {
    name = 'ROAD',
    items = {
      ROAD_HOME = { id = 73, name = 'ROAD_HOME', const = 'HERO_SKILL_ROAD_HOME' },
    }
  },
  RUNIC = {
    name = 'RUNIC',
    items = {
      RUNIC_MACHINES = { id = 156, name = 'RUNIC_MACHINES', const = 'HERO_SKILL_RUNIC_MACHINES' },
      RUNIC_ATTUNEMENT = { id = 158, name = 'RUNIC_ATTUNEMENT', const = 'HERO_SKILL_RUNIC_ATTUNEMENT' },
      RUNIC_ARMOR = { id = 166, name = 'RUNIC_ARMOR', const = 'HERO_SKILL_RUNIC_ARMOR' },
    }
  },
  SCHOLAR = {
    name = 'SCHOLAR',
    items = {
      SCHOLAR = { id = 26, name = 'SCHOLAR', const = 'HERO_SKILL_SCHOLAR' },
    }
  },
  SCOUTING = {
    name = 'SCOUTING',
    items = {
      SCOUTING = { id = 20, name = 'SCOUTING', const = 'HERO_SKILL_SCOUTING' },
    }
  },
  SEAL = {
    name = 'SEAL',
    items = {
      SEAL_OF_PROTECTION = { id = 131, name = 'SEAL_OF_PROTECTION', const = 'HERO_SKILL_SEAL_OF_PROTECTION' },
    }
  },
  SECRETS = {
    name = 'SECRETS',
    items = {
      SECRETS_OF_DESTRUCTION = { id = 146, name = 'SECRETS_OF_DESTRUCTION', const = 'HERO_SKILL_SECRETS_OF_DESTRUCTION' },
    }
  },
  SET = {
    name = 'SET',
    items = {
      SET_AFIRE = { id = 163, name = 'SET_AFIRE', const = 'HERO_SKILL_SET_AFIRE' },
    }
  },
  SHAKE = {
    name = 'SHAKE',
    items = {
      SHAKE_GROUND = { id = 139, name = 'SHAKE_GROUND', const = 'HERO_SKILL_SHAKE_GROUND' },
    }
  },
  SHRUG = {
    name = 'SHRUG',
    items = {
      SHRUG_DARKNESS = { id = 164, name = 'SHRUG_DARKNESS', const = 'HERO_SKILL_SHRUG_DARKNESS' },
    }
  },
  SNATCH = {
    name = 'SNATCH',
    items = {
      SNATCH = { id = 168, name = 'SNATCH', const = 'HERO_SKILL_SNATCH' },
    }
  },
  SNIPE = {
    name = 'SNIPE',
    items = {
      SNIPE_DEAD = { id = 65, name = 'SNIPE_DEAD', const = 'HERO_SKILL_SNIPE_DEAD' },
    }
  },
  SOIL = {
    name = 'SOIL',
    items = {
      SOIL_BURN = { id = 121, name = 'SOIL_BURN', const = 'HERO_SKILL_SOIL_BURN' },
    }
  },
  SPELLPROOF = {
    name = 'SPELLPROOF',
    items = {
      SPELLPROOF_BONES = { id = 106, name = 'SPELLPROOF_BONES', const = 'HERO_SKILL_SPELLPROOF_BONES' },
    }
  },
  SPIRIT = {
    name = 'SPIRIT',
    items = {
      SPIRIT_LINK = { id = 108, name = 'SPIRIT_LINK', const = 'HERO_SKILL_SPIRIT_LINK' },
    }
  },
  SPOILS = {
    name = 'SPOILS',
    items = {
      SPOILS_OF_WAR = { id = 129, name = 'SPOILS_OF_WAR', const = 'HERO_SKILL_SPOILS_OF_WAR' },
    }
  },
  STORM = {
    name = 'STORM',
    items = {
      STORM_WIND = { id = 122, name = 'STORM_WIND', const = 'HERO_SKILL_STORM_WIND' },
    }
  },
  STRONG = {
    name = 'STRONG',
    items = {
      STRONG_RUNE = { id = 153, name = 'STRONG_RUNE', const = 'HERO_SKILL_STRONG_RUNE' },
    }
  },
  STUDENT = {
    name = 'STUDENT',
    items = {
      STUDENT_AWARD = { id = 79, name = 'STUDENT_AWARD', const = 'HERO_SKILL_STUDENT_AWARD' },
    }
  },
  STUNNING = {
    name = 'STUNNING',
    items = {
      STUNNING_BLOW = { id = 180, name = 'STUNNING_BLOW', const = 'HERO_SKILL_STUNNING_BLOW' },
    }
  },
  SUN = {
    name = 'SUN',
    items = {
      SUN_FIRE = { id = 120, name = 'SUN_FIRE', const = 'HERO_SKILL_SUN_FIRE' },
    }
  },
  SUPRESS = {
    name = 'SUPRESS',
    items = {
      SUPRESS_DARK = { id = 134, name = 'SUPRESS_DARK', const = 'HERO_SKILL_SUPRESS_DARK' },
      SUPRESS_LIGHT = { id = 135, name = 'SUPRESS_LIGHT', const = 'HERO_SKILL_SUPRESS_LIGHT' },
    }
  },
  TACTICS = {
    name = 'TACTICS',
    items = {
      TACTICS = { id = 34, name = 'TACTICS', const = 'HERO_SKILL_TACTICS' },
    }
  },
  TAP = {
    name = 'TAP',
    items = {
      TAP_RUNES = { id = 157, name = 'TAP_RUNES', const = 'HERO_SKILL_TAP_RUNES' },
    }
  },
  TELEPORT = {
    name = 'TELEPORT',
    items = {
      TELEPORT_ASSAULT = { id = 138, name = 'TELEPORT_ASSAULT', const = 'HERO_SKILL_TELEPORT_ASSAULT' },
    }
  },
  TOUGHNESS = {
    name = 'TOUGHNESS',
    items = {
      TOUGHNESS = { id = 39, name = 'TOUGHNESS', const = 'HERO_SKILL_TOUGHNESS' },
    }
  },
  TRIPLE = {
    name = 'TRIPLE',
    items = {
      TRIPLE_BALLISTA = { id = 74, name = 'TRIPLE_BALLISTA', const = 'HERO_SKILL_TRIPLE_BALLISTA' },
      TRIPLE_CATAPULT = { id = 88, name = 'TRIPLE_CATAPULT', const = 'HERO_SKILL_TRIPLE_CATAPULT' },
    }
  },
  TWILIGHT = {
    name = 'TWILIGHT',
    items = {
      TWILIGHT = { id = 109, name = 'TWILIGHT', const = 'HERO_SKILL_TWILIGHT' },
    }
  },
  UNSUMMON = {
    name = 'UNSUMMON',
    items = {
      UNSUMMON = { id = 136, name = 'UNSUMMON', const = 'HERO_SKILL_UNSUMMON' },
    }
  },
  VOICE = {
    name = 'VOICE',
    items = {
      VOICE = { id = 187, name = 'VOICE', const = 'HERO_SKILL_VOICE' },
      VOICE_TRAINING = { id = 188, name = 'VOICE_TRAINING', const = 'HERO_SKILL_VOICE_TRAINING' },
      VOICE_OF_RAGE = { id = 190, name = 'VOICE_OF_RAGE', const = 'HERO_SKILL_VOICE_OF_RAGE' },
    }
  },
  WARCRY = {
    name = 'WARCRY',
    items = {
      WARCRY_LEARNING = { id = 185, name = 'WARCRY_LEARNING', const = 'HERO_SKILL_WARCRY_LEARNING' },
    }
  },
  WEAKEN = {
    name = 'WEAKEN',
    items = {
      WEAKEN_DESTRUCTIVE = { id = 193, name = 'WEAKEN_DESTRUCTIVE', const = 'HERO_SKILL_WEAKEN_DESTRUCTIVE' },
      WEAKEN_DARK = { id = 197, name = 'WEAKEN_DARK', const = 'HERO_SKILL_WEAKEN_DARK' },
      WEAKEN_LIGHT = { id = 201, name = 'WEAKEN_LIGHT', const = 'HERO_SKILL_WEAKEN_LIGHT' },
      WEAKEN_SUMMONING = { id = 205, name = 'WEAKEN_SUMMONING', const = 'HERO_SKILL_WEAKEN_SUMMONING' },
    }
  },
  WEAKENING = {
    name = 'WEAKENING',
    items = {
      WEAKENING_STRIKE = { id = 95, name = 'WEAKENING_STRIKE', const = 'HERO_SKILL_WEAKENING_STRIKE' },
    }
  },
  WILDFIRE = {
    name = 'WILDFIRE',
    items = {
      WILDFIRE = { id = 130, name = 'WILDFIRE', const = 'HERO_SKILL_WILDFIRE' },
    }
  },
  WISDOM = {
    name = 'WISDOM',
    items = {
      WISDOM = { id = 41, name = 'WISDOM', const = 'HERO_SKILL_WISDOM' },
    }
  },
}

ABILITY = {
  NONE = { id = 0, name = 'NONE', const = 'ABILITY_NONE' },
  SHOOTER = { id = 1, name = 'SHOOTER', const = 'ABILITY_SHOOTER' },
  NO_MELEE_PENALTY = { id = 2, name = 'NO_MELEE_PENALTY', const = 'ABILITY_NO_MELEE_PENALTY' },
  NO_RANGE_PENALTY = { id = 3, name = 'NO_RANGE_PENALTY', const = 'ABILITY_NO_RANGE_PENALTY' },
  RANGE_PENALTY = { id = 4, name = 'RANGE_PENALTY', const = 'ABILITY_RANGE_PENALTY' },
  NO_ENEMY_RETALIATION = { id = 5, name = 'NO_ENEMY_RETALIATION', const = 'ABILITY_NO_ENEMY_RETALIATION' },
  UNLIMITED_RETALIATION = { id = 6, name = 'UNLIMITED_RETALIATION', const = 'ABILITY_UNLIMITED_RETALIATION' },
  DOUBLE_ATTACK = { id = 7, name = 'DOUBLE_ATTACK', const = 'ABILITY_DOUBLE_ATTACK' },
  DOUBLE_SHOT = { id = 8, name = 'DOUBLE_SHOT', const = 'ABILITY_DOUBLE_SHOT' },
  MECHANICAL = { id = 9, name = 'MECHANICAL', const = 'ABILITY_MECHANICAL' },
  UNDEAD = { id = 10, name = 'UNDEAD', const = 'ABILITY_UNDEAD' },
  DEMONIC = { id = 11, name = 'DEMONIC', const = 'ABILITY_DEMONIC' },
  ELEMENTAL = { id = 12, name = 'ELEMENTAL', const = 'ABILITY_ELEMENTAL' },
  CURSING_ATTACK = { id = 13, name = 'CURSING_ATTACK', const = 'ABILITY_CURSING_ATTACK' },
  FLESH_AND_BLOOD = { id = 14, name = 'FLESH_AND_BLOOD', const = 'ABILITY_FLESH_AND_BLOOD' },
  ENRAGED = { id = 15, name = 'ENRAGED', const = 'ABILITY_ENRAGED' },
  IMMUNITY_TO_BLIND = { id = 16, name = 'IMMUNITY_TO_BLIND', const = 'ABILITY_IMMUNITY_TO_BLIND' },
  IMMUNITY_TO_MAGIC = { id = 17, name = 'IMMUNITY_TO_MAGIC', const = 'ABILITY_IMMUNITY_TO_MAGIC' },
  IMMUNITY_TO_SLOW = { id = 18, name = 'IMMUNITY_TO_SLOW', const = 'ABILITY_IMMUNITY_TO_SLOW' },
  IMMUNITY_TO_MIND_CONTROL = { id = 19, name = 'IMMUNITY_TO_MIND_CONTROL', const = 'ABILITY_IMMUNITY_TO_MIND_CONTROL' },
  IMMUNITY_TO_AIR = { id = 20, name = 'IMMUNITY_TO_AIR', const = 'ABILITY_IMMUNITY_TO_AIR' },
  IMMUNITY_TO_FIRE = { id = 21, name = 'IMMUNITY_TO_FIRE', const = 'ABILITY_IMMUNITY_TO_FIRE' },
  IMMUNITY_TO_WATER = { id = 22, name = 'IMMUNITY_TO_WATER', const = 'ABILITY_IMMUNITY_TO_WATER' },
  IMMUNITY_TO_EARTH = { id = 23, name = 'IMMUNITY_TO_EARTH', const = 'ABILITY_IMMUNITY_TO_EARTH' },
  MAGIC_PROOF_50 = { id = 24, name = 'MAGIC_PROOF_50', const = 'ABILITY_MAGIC_PROOF_50' },
  PRECISE_SHOT = { id = 25, name = 'PRECISE_SHOT', const = 'ABILITY_PRECISE_SHOT' },
  LARGE_SHIELD = { id = 26, name = 'LARGE_SHIELD', const = 'ABILITY_LARGE_SHIELD' },
  SHIELD_OTHER = { id = 27, name = 'SHIELD_OTHER', const = 'ABILITY_SHIELD_OTHER' },
  JOUSTING = { id = 28, name = 'JOUSTING', const = 'ABILITY_JOUSTING' },
  BASH = { id = 29, name = 'BASH', const = 'ABILITY_BASH' },
  BATTLE_DIVE = { id = 30, name = 'BATTLE_DIVE', const = 'ABILITY_BATTLE_DIVE' },
  MANA_DESTROYER = { id = 31, name = 'MANA_DESTROYER', const = 'ABILITY_MANA_DESTROYER' },
  MANA_STEALER = { id = 32, name = 'MANA_STEALER', const = 'ABILITY_MANA_STEALER' },
  EXPLOSION = { id = 33, name = 'EXPLOSION', const = 'ABILITY_EXPLOSION' },
  RANGED_RETALIATE = { id = 34, name = 'RANGED_RETALIATE', const = 'ABILITY_RANGED_RETALIATE' },
  FEAR = { id = 35, name = 'FEAR', const = 'ABILITY_FEAR' },
  FRIGHT_AURA = { id = 36, name = 'FRIGHT_AURA', const = 'ABILITY_FRIGHT_AURA' },
  VORPAL_SWORD = { id = 37, name = 'VORPAL_SWORD', const = 'ABILITY_VORPAL_SWORD' },
  CHAIN_SHOT = { id = 38, name = 'CHAIN_SHOT', const = 'ABILITY_CHAIN_SHOT' },
  WEAKENING_STRIKE = { id = 39, name = 'WEAKENING_STRIKE', const = 'ABILITY_WEAKENING_STRIKE' },
  INCORPOREAL = { id = 40, name = 'INCORPOREAL', const = 'ABILITY_INCORPOREAL' },
  MANA_DRAIN = { id = 41, name = 'MANA_DRAIN', const = 'ABILITY_MANA_DRAIN' },
  LIFE_DRAIN = { id = 42, name = 'LIFE_DRAIN', const = 'ABILITY_LIFE_DRAIN' },
  DEATH_CLOUD = { id = 43, name = 'DEATH_CLOUD', const = 'ABILITY_DEATH_CLOUD' },
  ELVES_DOUBLE_SHOT = { id = 44, name = 'ELVES_DOUBLE_SHOT', const = 'ABILITY_ELVES_DOUBLE_SHOT' },
  WARDING_ARROWS = { id = 45, name = 'WARDING_ARROWS', const = 'ABILITY_WARDING_ARROWS' },
  BLINDING_ATTACK = { id = 46, name = 'BLINDING_ATTACK', const = 'ABILITY_BLINDING_ATTACK' },
  AURA_OF_MAGIC_RESISTANCE = { id = 47, name = 'AURA_OF_MAGIC_RESISTANCE', const = 'ABILITY_AURA_OF_MAGIC_RESISTANCE' },
  TAKE_ROOTS = { id = 48, name = 'TAKE_ROOTS', const = 'ABILITY_TAKE_ROOTS' },
  ENTANGLING_ROOTS = { id = 49, name = 'ENTANGLING_ROOTS', const = 'ABILITY_ENTANGLING_ROOTS' },
  ACID_BREATH = { id = 50, name = 'ACID_BREATH', const = 'ABILITY_ACID_BREATH' },
  MAGIC_ATTACK = { id = 51, name = 'MAGIC_ATTACK', const = 'ABILITY_MAGIC_ATTACK' },
  ENERGY_CHANNEL = { id = 52, name = 'ENERGY_CHANNEL', const = 'ABILITY_ENERGY_CHANNEL' },
  MAGIC_PROOF_75 = { id = 53, name = 'MAGIC_PROOF_75', const = 'ABILITY_MAGIC_PROOF_75' },
  POISONOUS_ATTACK = { id = 54, name = 'POISONOUS_ATTACK', const = 'ABILITY_POISONOUS_ATTACK' },
  STRIKE_AND_RETURN = { id = 55, name = 'STRIKE_AND_RETURN', const = 'ABILITY_STRIKE_AND_RETURN' },
  BRAVERY = { id = 56, name = 'BRAVERY', const = 'ABILITY_BRAVERY' },
  RIDER_CHARGE = { id = 57, name = 'RIDER_CHARGE', const = 'ABILITY_RIDER_CHARGE' },
  LIZARD_BITE = { id = 58, name = 'LIZARD_BITE', const = 'ABILITY_LIZARD_BITE' },
  SIX_HEADED_ATTACK = { id = 59, name = 'SIX_HEADED_ATTACK', const = 'ABILITY_SIX_HEADED_ATTACK' },
  REGENERATION = { id = 60, name = 'REGENERATION', const = 'ABILITY_REGENERATION' },
  WHIP_STRIKE = { id = 61, name = 'WHIP_STRIKE', const = 'ABILITY_WHIP_STRIKE' },
  FIRE_SHIELD = { id = 62, name = 'FIRE_SHIELD', const = 'ABILITY_FIRE_SHIELD' },
  DEADLY_STRIKE = { id = 63, name = 'DEADLY_STRIKE', const = 'ABILITY_DEADLY_STRIKE' },
  REBIRTH = { id = 64, name = 'REBIRTH', const = 'ABILITY_REBIRTH' },
  FRIGHTFUL_PRESENCE = { id = 65, name = 'FRIGHTFUL_PRESENCE', const = 'ABILITY_FRIGHTFUL_PRESENCE' },
  CRYSTAL_SCALES = { id = 66, name = 'CRYSTAL_SCALES', const = 'ABILITY_CRYSTAL_SCALES' },
  LARGE_CREATURE = { id = 67, name = 'LARGE_CREATURE', const = 'ABILITY_LARGE_CREATURE' },
  FLYER = { id = 68, name = 'FLYER', const = 'ABILITY_FLYER' },
  CASTER = { id = 69, name = 'CASTER', const = 'ABILITY_CASTER' },
  TAXPAYER = { id = 70, name = 'TAXPAYER', const = 'ABILITY_TAXPAYER' },
  SCATTER_SHOT = { id = 71, name = 'SCATTER_SHOT', const = 'ABILITY_SCATTER_SHOT' },
  RESURRECT_ALLIES = { id = 72, name = 'RESURRECT_ALLIES', const = 'ABILITY_RESURRECT_ALLIES' },
  BALOR_SUMMONIG = { id = 73, name = 'BALOR_SUMMONIG', const = 'ABILITY_BALOR_SUMMONIG' },
  SPRAY_ATTACK = { id = 74, name = 'SPRAY_ATTACK', const = 'ABILITY_SPRAY_ATTACK' },
  MANA_FEED = { id = 75, name = 'MANA_FEED', const = 'ABILITY_MANA_FEED' },
  FIRE_BREATH = { id = 76, name = 'FIRE_BREATH', const = 'ABILITY_FIRE_BREATH' },
  HARM_TOUCH = { id = 77, name = 'HARM_TOUCH', const = 'ABILITY_HARM_TOUCH' },
  WAR_DANCE = { id = 78, name = 'WAR_DANCE', const = 'ABILITY_WAR_DANCE' },
  REPAIR = { id = 79, name = 'REPAIR', const = 'ABILITY_REPAIR' },
  RANDOM_CASTER = { id = 80, name = 'RANDOM_CASTER', const = 'ABILITY_RANDOM_CASTER' },
  DASH = { id = 81, name = 'DASH', const = 'ABILITY_DASH' },
  CALL_LIGHTNING = { id = 82, name = 'CALL_LIGHTNING', const = 'ABILITY_CALL_LIGHTNING' },
  LAY_HANDS = { id = 83, name = 'LAY_HANDS', const = 'ABILITY_LAY_HANDS' },
  THREE_HEADED_ATTACK = { id = 84, name = 'THREE_HEADED_ATTACK', const = 'ABILITY_THREE_HEADED_ATTACK' },
  ARMORED = { id = 85, name = 'ARMORED', const = 'ABILITY_ARMORED' },
  SHIELD_WALL = { id = 86, name = 'SHIELD_WALL', const = 'ABILITY_SHIELD_WALL' },
  WOUND = { id = 87, name = 'WOUND', const = 'ABILITY_WOUND' },
  PAW_STRIKE = { id = 88, name = 'PAW_STRIKE', const = 'ABILITY_PAW_STRIKE' },
  BERSERKER_RAGE = { id = 89, name = 'BERSERKER_RAGE', const = 'ABILITY_BERSERKER_RAGE' },
  STORMBOLT = { id = 90, name = 'STORMBOLT', const = 'ABILITY_STORMBOLT' },
  STORMSTRIKE = { id = 91, name = 'STORMSTRIKE', const = 'ABILITY_STORMSTRIKE' },
  MARK_OF_FIRE = { id = 92, name = 'MARK_OF_FIRE', const = 'ABILITY_MARK_OF_FIRE' },
  CROSS_ATTACK = { id = 93, name = 'CROSS_ATTACK', const = 'ABILITY_CROSS_ATTACK' },
  MAGMA_SHIELD = { id = 94, name = 'MAGMA_SHIELD', const = 'ABILITY_MAGMA_SHIELD' },
  PACK_HUNTER = { id = 95, name = 'PACK_HUNTER', const = 'ABILITY_PACK_HUNTER' },
  HOWL = { id = 96, name = 'HOWL', const = 'ABILITY_HOWL' },
  AGILITY = { id = 97, name = 'AGILITY', const = 'ABILITY_AGILITY' },
  HEXING_ATTACK = { id = 98, name = 'HEXING_ATTACK', const = 'ABILITY_HEXING_ATTACK' },
  CLEAVE = { id = 99, name = 'CLEAVE', const = 'ABILITY_CLEAVE' },
  BATTLE_FRENZY = { id = 100, name = 'BATTLE_FRENZY', const = 'ABILITY_BATTLE_FRENZY' },
  PACK_DIVE = { id = 101, name = 'PACK_DIVE', const = 'ABILITY_PACK_DIVE' },
  CHAMPION_CHARGE = { id = 102, name = 'CHAMPION_CHARGE', const = 'ABILITY_CHAMPION_CHARGE' },
  PURGER = { id = 103, name = 'PURGER', const = 'ABILITY_PURGER' },
  BLADE_BARRIER = { id = 104, name = 'BLADE_BARRIER', const = 'ABILITY_BLADE_BARRIER' },
  DEMON_RAGED = { id = 105, name = 'DEMON_RAGED', const = 'ABILITY_DEMON_RAGED' },
  COWARDICE = { id = 106, name = 'COWARDICE', const = 'ABILITY_COWARDICE' },
  TREACHERY = { id = 107, name = 'TREACHERY', const = 'ABILITY_TREACHERY' },
  SET_SNARES = { id = 108, name = 'SET_SNARES', const = 'ABILITY_SET_SNARES' },
  DEFILE_MAGIC = { id = 109, name = 'DEFILE_MAGIC', const = 'ABILITY_DEFILE_MAGIC' },
  MANEURE = { id = 110, name = 'MANEURE', const = 'ABILITY_MANEURE' },
  BRUTALITY = { id = 111, name = 'BRUTALITY', const = 'ABILITY_BRUTALITY' },
  TAUNT = { id = 112, name = 'TAUNT', const = 'ABILITY_TAUNT' },
  FIERCE_RETALIATION = { id = 113, name = 'FIERCE_RETALIATION', const = 'ABILITY_FIERCE_RETALIATION' },
  SACRIFICE_GOBLIN = { id = 114, name = 'SACRIFICE_GOBLIN', const = 'ABILITY_SACRIFICE_GOBLIN' },
  FAST_ATTACK = { id = 115, name = 'FAST_ATTACK', const = 'ABILITY_FAST_ATTACK' },
  PRESENCE_OF_COMMANDER = { id = 116, name = 'PRESENCE_OF_COMMANDER', const = 'ABILITY_PRESENCE_OF_COMMANDER' },
  ORDER_OF_THE_CHIEF = { id = 117, name = 'ORDER_OF_THE_CHIEF', const = 'ABILITY_ORDER_OF_THE_CHIEF' },
  VENOM = { id = 118, name = 'VENOM', const = 'ABILITY_VENOM' },
  SCAVENGER = { id = 119, name = 'SCAVENGER', const = 'ABILITY_SCAVENGER' },
  LIGHTNING_BREATH = { id = 120, name = 'LIGHTNING_BREATH', const = 'ABILITY_LIGHTNING_BREATH' },
  SWALLOW_GOBLIN = { id = 121, name = 'SWALLOW_GOBLIN', const = 'ABILITY_SWALLOW_GOBLIN' },
  GOBLIN_THROWER = { id = 122, name = 'GOBLIN_THROWER', const = 'ABILITY_GOBLIN_THROWER' },
  CRUSHING_BLOW = { id = 123, name = 'CRUSHING_BLOW', const = 'ABILITY_CRUSHING_BLOW' },
  EVIL_EYE = { id = 124, name = 'EVIL_EYE', const = 'ABILITY_EVIL_EYE' },
  RANDOM_CASTER_BLESS = { id = 125, name = 'RANDOM_CASTER_BLESS', const = 'ABILITY_RANDOM_CASTER_BLESS' },
  SYPHON_MANA = { id = 126, name = 'SYPHON_MANA', const = 'ABILITY_SYPHON_MANA' },
  SEARING_AURA = { id = 127, name = 'SEARING_AURA', const = 'ABILITY_SEARING_AURA' },
  AXE_OF_SLAUGHTER = { id = 128, name = 'AXE_OF_SLAUGHTER', const = 'ABILITY_AXE_OF_SLAUGHTER' },
  SUMMON_OTHER = { id = 129, name = 'SUMMON_OTHER', const = 'ABILITY_SUMMON_OTHER' },
  SEDUCE = { id = 130, name = 'SEDUCE', const = 'ABILITY_SEDUCE' },
  LEAP = { id = 131, name = 'LEAP', const = 'ABILITY_LEAP' },
  DEATH_WAIL = { id = 132, name = 'DEATH_WAIL', const = 'ABILITY_DEATH_WAIL' },
  WEAKENING_AURA = { id = 133, name = 'WEAKENING_AURA', const = 'ABILITY_WEAKENING_AURA' },
  AMMO_STEAL = { id = 134, name = 'AMMO_STEAL', const = 'ABILITY_AMMO_STEAL' },
  SLEEPING_STRIKE = { id = 135, name = 'SLEEPING_STRIKE', const = 'ABILITY_SLEEPING_STRIKE' },
  SORROW_STRIKE = { id = 136, name = 'SORROW_STRIKE', const = 'ABILITY_SORROW_STRIKE' },
  HORROR_OF_THE_DEATH = { id = 137, name = 'HORROR_OF_THE_DEATH', const = 'ABILITY_HORROR_OF_THE_DEATH' },
  PIERCING_ARROW = { id = 138, name = 'PIERCING_ARROW', const = 'ABILITY_PIERCING_ARROW' },
  TREEANT_UNION = { id = 139, name = 'TREEANT_UNION', const = 'ABILITY_TREEANT_UNION' },
  RAGE_OF_THE_FOREST = { id = 140, name = 'RAGE_OF_THE_FOREST', const = 'ABILITY_RAGE_OF_THE_FOREST' },
  POWER_FEED = { id = 141, name = 'POWER_FEED', const = 'ABILITY_POWER_FEED' },
  RAINBOW_BREATH = { id = 142, name = 'RAINBOW_BREATH', const = 'ABILITY_RAINBOW_BREATH' },
  BOND_OF_LIGHT = { id = 143, name = 'BOND_OF_LIGHT', const = 'ABILITY_BOND_OF_LIGHT' },
  WHIRLWIND = { id = 144, name = 'WHIRLWIND', const = 'ABILITY_WHIRLWIND' },
  ELDRITCH_AURA = { id = 145, name = 'ELDRITCH_AURA', const = 'ABILITY_ELDRITCH_AURA' },
  AURA_OF_FIRE_VULNERABILITY = { id = 146, name = 'AURA_OF_FIRE_VULNERABILITY', const = 'ABILITY_AURA_OF_FIRE_VULNERABILITY' },
  AURA_OF_ICE_VULNERABILITY = { id = 147, name = 'AURA_OF_ICE_VULNERABILITY', const = 'ABILITY_AURA_OF_ICE_VULNERABILITY' },
  AURA_OF_LIGHTNING_VULNERABILITY = { id = 148, name = 'AURA_OF_LIGHTNING_VULNERABILITY', const = 'ABILITY_AURA_OF_LIGHTNING_VULNERABILITY' },
  AURA_OF_EARTH_VULNERABILITY = { id = 149, name = 'AURA_OF_EARTH_VULNERABILITY', const = 'ABILITY_AURA_OF_EARTH_VULNERABILITY' },
  CALL_STORM = { id = 150, name = 'CALL_STORM', const = 'ABILITY_CALL_STORM' },
  SABOTAGE = { id = 151, name = 'SABOTAGE', const = 'ABILITY_SABOTAGE' },
  LUCK_GAMBLER = { id = 152, name = 'LUCK_GAMBLER', const = 'ABILITY_LUCK_GAMBLER' },
  ENCHANTED_OBSIDIAN = { id = 153, name = 'ENCHANTED_OBSIDIAN', const = 'ABILITY_ENCHANTED_OBSIDIAN' },
  ACID_BLOOD = { id = 154, name = 'ACID_BLOOD', const = 'ABILITY_ACID_BLOOD' },
  AURA_OF_BRAVERY = { id = 155, name = 'AURA_OF_BRAVERY', const = 'ABILITY_AURA_OF_BRAVERY' },
  INCINERATE = { id = 156, name = 'INCINERATE', const = 'ABILITY_INCINERATE' },
  INVISIBILITY = { id = 157, name = 'INVISIBILITY', const = 'ABILITY_INVISIBILITY' },
  RIDE_BY_ATTACK = { id = 158, name = 'RIDE_BY_ATTACK', const = 'ABILITY_RIDE_BY_ATTACK' },
  ANTI_GIANT = { id = 159, name = 'ANTI_GIANT', const = 'ABILITY_ANTI_GIANT' },
  AVENGING_FLAME = { id = 160, name = 'AVENGING_FLAME', const = 'ABILITY_AVENGING_FLAME' },
  PREPARED_POSITION = { id = 161, name = 'PREPARED_POSITION', const = 'ABILITY_PREPARED_POSITION' },
  BATTLE_RAGE = { id = 162, name = 'BATTLE_RAGE', const = 'ABILITY_BATTLE_RAGE' },
  HARPOON_STRIKE = { id = 163, name = 'HARPOON_STRIKE', const = 'ABILITY_HARPOON_STRIKE' },
  BEAR_ROAR = { id = 164, name = 'BEAR_ROAR', const = 'ABILITY_BEAR_ROAR' },
  HOLD_GROUND = { id = 165, name = 'HOLD_GROUND', const = 'ABILITY_HOLD_GROUND' },
  FLAMEWAVE = { id = 166, name = 'FLAMEWAVE', const = 'ABILITY_FLAMEWAVE' },
  FLAMESTRIKE = { id = 167, name = 'FLAMESTRIKE', const = 'ABILITY_FLAMESTRIKE' },
  LIQUID_FLAME_BREATH = { id = 168, name = 'LIQUID_FLAME_BREATH', const = 'ABILITY_LIQUID_FLAME_BREATH' },
  IMMUNITY_TO_CURSE = { id = 169, name = 'IMMUNITY_TO_CURSE', const = 'ABILITY_IMMUNITY_TO_CURSE' },
  IMMUNITY_TO_BERSERK = { id = 170, name = 'IMMUNITY_TO_BERSERK', const = 'ABILITY_IMMUNITY_TO_BERSERK' },
  IMMUNITY_TO_HYPNOTIZE = { id = 171, name = 'IMMUNITY_TO_HYPNOTIZE', const = 'ABILITY_IMMUNITY_TO_HYPNOTIZE' },
  MAGIC_PROOF_25 = { id = 172, name = 'MAGIC_PROOF_25', const = 'ABILITY_MAGIC_PROOF_25' },
  FIRE_PROOF_50 = { id = 173, name = 'FIRE_PROOF_50', const = 'ABILITY_FIRE_PROOF_50' },
  DESTRUCTION_MAGIC_MAGNETISM = { id = 174, name = 'DESTRUCTION_MAGIC_MAGNETISM', const = 'ABILITY_DESTRUCTION_MAGIC_MAGNETISM' },
}

CREATURE = {
  UNKNOWN = { id = 0, name = 'UNKNOWN', const = 'CREATURE_UNKNOWN' },
  PEASANT = { id = 1, name = 'PEASANT', const = 'CREATURE_PEASANT' },
  MILITIAMAN = { id = 2, name = 'MILITIAMAN', const = 'CREATURE_MILITIAMAN' },
  ARCHER = { id = 3, name = 'ARCHER', const = 'CREATURE_ARCHER' },
  MARKSMAN = { id = 4, name = 'MARKSMAN', const = 'CREATURE_MARKSMAN' },
  FOOTMAN = { id = 5, name = 'FOOTMAN', const = 'CREATURE_FOOTMAN' },
  SWORDSMAN = { id = 6, name = 'SWORDSMAN', const = 'CREATURE_SWORDSMAN' },
  GRIFFIN = { id = 7, name = 'GRIFFIN', const = 'CREATURE_GRIFFIN' },
  ROYAL_GRIFFIN = { id = 8, name = 'ROYAL_GRIFFIN', const = 'CREATURE_ROYAL_GRIFFIN' },
  PRIEST = { id = 9, name = 'PRIEST', const = 'CREATURE_PRIEST' },
  CLERIC = { id = 10, name = 'CLERIC', const = 'CREATURE_CLERIC' },
  CAVALIER = { id = 11, name = 'CAVALIER', const = 'CREATURE_CAVALIER' },
  PALADIN = { id = 12, name = 'PALADIN', const = 'CREATURE_PALADIN' },
  ANGEL = { id = 13, name = 'ANGEL', const = 'CREATURE_ANGEL' },
  ARCHANGEL = { id = 14, name = 'ARCHANGEL', const = 'CREATURE_ARCHANGEL' },
  FAMILIAR = { id = 15, name = 'FAMILIAR', const = 'CREATURE_FAMILIAR' },
  IMP = { id = 16, name = 'IMP', const = 'CREATURE_IMP' },
  DEMON = { id = 17, name = 'DEMON', const = 'CREATURE_DEMON' },
  HORNED_DEMON = { id = 18, name = 'HORNED_DEMON', const = 'CREATURE_HORNED_DEMON' },
  HELL_HOUND = { id = 19, name = 'HELL_HOUND', const = 'CREATURE_HELL_HOUND' },
  CERBERI = { id = 20, name = 'CERBERI', const = 'CREATURE_CERBERI' },
  SUCCUBUS = { id = 21, name = 'SUCCUBUS', const = 'CREATURE_SUCCUBUS' },
  INFERNAL_SUCCUBUS = { id = 22, name = 'INFERNAL_SUCCUBUS', const = 'CREATURE_INFERNAL_SUCCUBUS' },
  NIGHTMARE = { id = 23, name = 'NIGHTMARE', const = 'CREATURE_NIGHTMARE' },
  FRIGHTFUL_NIGHTMARE = { id = 24, name = 'FRIGHTFUL_NIGHTMARE', const = 'CREATURE_FRIGHTFUL_NIGHTMARE' },
  PIT_FIEND = { id = 25, name = 'PIT_FIEND', const = 'CREATURE_PIT_FIEND' },
  BALOR = { id = 26, name = 'BALOR', const = 'CREATURE_BALOR' },
  DEVIL = { id = 27, name = 'DEVIL', const = 'CREATURE_DEVIL' },
  ARCHDEVIL = { id = 28, name = 'ARCHDEVIL', const = 'CREATURE_ARCHDEVIL' },
  SKELETON = { id = 29, name = 'SKELETON', const = 'CREATURE_SKELETON' },
  SKELETON_ARCHER = { id = 30, name = 'SKELETON_ARCHER', const = 'CREATURE_SKELETON_ARCHER' },
  WALKING_DEAD = { id = 31, name = 'WALKING_DEAD', const = 'CREATURE_WALKING_DEAD' },
  ZOMBIE = { id = 32, name = 'ZOMBIE', const = 'CREATURE_ZOMBIE' },
  MANES = { id = 33, name = 'MANES', const = 'CREATURE_MANES' },
  GHOST = { id = 34, name = 'GHOST', const = 'CREATURE_GHOST' },
  VAMPIRE = { id = 35, name = 'VAMPIRE', const = 'CREATURE_VAMPIRE' },
  VAMPIRE_LORD = { id = 36, name = 'VAMPIRE_LORD', const = 'CREATURE_VAMPIRE_LORD' },
  LICH = { id = 37, name = 'LICH', const = 'CREATURE_LICH' },
  DEMILICH = { id = 38, name = 'DEMILICH', const = 'CREATURE_DEMILICH' },
  WIGHT = { id = 39, name = 'WIGHT', const = 'CREATURE_WIGHT' },
  WRAITH = { id = 40, name = 'WRAITH', const = 'CREATURE_WRAITH' },
  BONE_DRAGON = { id = 41, name = 'BONE_DRAGON', const = 'CREATURE_BONE_DRAGON' },
  SHADOW_DRAGON = { id = 42, name = 'SHADOW_DRAGON', const = 'CREATURE_SHADOW_DRAGON' },
  PIXIE = { id = 43, name = 'PIXIE', const = 'CREATURE_PIXIE' },
  SPRITE = { id = 44, name = 'SPRITE', const = 'CREATURE_SPRITE' },
  BLADE_JUGGLER = { id = 45, name = 'BLADE_JUGGLER', const = 'CREATURE_BLADE_JUGGLER' },
  WAR_DANCER = { id = 46, name = 'WAR_DANCER', const = 'CREATURE_WAR_DANCER' },
  WOOD_ELF = { id = 47, name = 'WOOD_ELF', const = 'CREATURE_WOOD_ELF' },
  GRAND_ELF = { id = 48, name = 'GRAND_ELF', const = 'CREATURE_GRAND_ELF' },
  DRUID = { id = 49, name = 'DRUID', const = 'CREATURE_DRUID' },
  DRUID_ELDER = { id = 50, name = 'DRUID_ELDER', const = 'CREATURE_DRUID_ELDER' },
  UNICORN = { id = 51, name = 'UNICORN', const = 'CREATURE_UNICORN' },
  WAR_UNICORN = { id = 52, name = 'WAR_UNICORN', const = 'CREATURE_WAR_UNICORN' },
  TREANT = { id = 53, name = 'TREANT', const = 'CREATURE_TREANT' },
  TREANT_GUARDIAN = { id = 54, name = 'TREANT_GUARDIAN', const = 'CREATURE_TREANT_GUARDIAN' },
  GREEN_DRAGON = { id = 55, name = 'GREEN_DRAGON', const = 'CREATURE_GREEN_DRAGON' },
  GOLD_DRAGON = { id = 56, name = 'GOLD_DRAGON', const = 'CREATURE_GOLD_DRAGON' },
  GREMLIN = { id = 57, name = 'GREMLIN', const = 'CREATURE_GREMLIN' },
  MASTER_GREMLIN = { id = 58, name = 'MASTER_GREMLIN', const = 'CREATURE_MASTER_GREMLIN' },
  STONE_GARGOYLE = { id = 59, name = 'STONE_GARGOYLE', const = 'CREATURE_STONE_GARGOYLE' },
  OBSIDIAN_GARGOYLE = { id = 60, name = 'OBSIDIAN_GARGOYLE', const = 'CREATURE_OBSIDIAN_GARGOYLE' },
  IRON_GOLEM = { id = 61, name = 'IRON_GOLEM', const = 'CREATURE_IRON_GOLEM' },
  STEEL_GOLEM = { id = 62, name = 'STEEL_GOLEM', const = 'CREATURE_STEEL_GOLEM' },
  MAGI = { id = 63, name = 'MAGI', const = 'CREATURE_MAGI' },
  ARCH_MAGI = { id = 64, name = 'ARCH_MAGI', const = 'CREATURE_ARCH_MAGI' },
  GENIE = { id = 65, name = 'GENIE', const = 'CREATURE_GENIE' },
  MASTER_GENIE = { id = 66, name = 'MASTER_GENIE', const = 'CREATURE_MASTER_GENIE' },
  RAKSHASA = { id = 67, name = 'RAKSHASA', const = 'CREATURE_RAKSHASA' },
  RAKSHASA_RUKH = { id = 68, name = 'RAKSHASA_RUKH', const = 'CREATURE_RAKSHASA_RUKH' },
  GIANT = { id = 69, name = 'GIANT', const = 'CREATURE_GIANT' },
  TITAN = { id = 70, name = 'TITAN', const = 'CREATURE_TITAN' },
  SCOUT = { id = 71, name = 'SCOUT', const = 'CREATURE_SCOUT' },
  ASSASSIN = { id = 72, name = 'ASSASSIN', const = 'CREATURE_ASSASSIN' },
  WITCH = { id = 73, name = 'WITCH', const = 'CREATURE_WITCH' },
  BLOOD_WITCH = { id = 74, name = 'BLOOD_WITCH', const = 'CREATURE_BLOOD_WITCH' },
  MINOTAUR = { id = 75, name = 'MINOTAUR', const = 'CREATURE_MINOTAUR' },
  MINOTAUR_KING = { id = 76, name = 'MINOTAUR_KING', const = 'CREATURE_MINOTAUR_KING' },
  RIDER = { id = 77, name = 'RIDER', const = 'CREATURE_RIDER' },
  RAVAGER = { id = 78, name = 'RAVAGER', const = 'CREATURE_RAVAGER' },
  HYDRA = { id = 79, name = 'HYDRA', const = 'CREATURE_HYDRA' },
  CHAOS_HYDRA = { id = 80, name = 'CHAOS_HYDRA', const = 'CREATURE_CHAOS_HYDRA' },
  MATRON = { id = 81, name = 'MATRON', const = 'CREATURE_MATRON' },
  MATRIARCH = { id = 82, name = 'MATRIARCH', const = 'CREATURE_MATRIARCH' },
  DEEP_DRAGON = { id = 83, name = 'DEEP_DRAGON', const = 'CREATURE_DEEP_DRAGON' },
  BLACK_DRAGON = { id = 84, name = 'BLACK_DRAGON', const = 'CREATURE_BLACK_DRAGON' },
  FIRE_ELEMENTAL = { id = 85, name = 'FIRE_ELEMENTAL', const = 'CREATURE_FIRE_ELEMENTAL' },
  WATER_ELEMENTAL = { id = 86, name = 'WATER_ELEMENTAL', const = 'CREATURE_WATER_ELEMENTAL' },
  EARTH_ELEMENTAL = { id = 87, name = 'EARTH_ELEMENTAL', const = 'CREATURE_EARTH_ELEMENTAL' },
  AIR_ELEMENTAL = { id = 88, name = 'AIR_ELEMENTAL', const = 'CREATURE_AIR_ELEMENTAL' },
  BLACK_KNIGHT = { id = 89, name = 'BLACK_KNIGHT', const = 'CREATURE_BLACK_KNIGHT' },
  DEATH_KNIGHT = { id = 90, name = 'DEATH_KNIGHT', const = 'CREATURE_DEATH_KNIGHT' },
  PHOENIX = { id = 91, name = 'PHOENIX', const = 'CREATURE_PHOENIX' },
  DEFENDER = { id = 92, name = 'DEFENDER', const = 'CREATURE_DEFENDER' },
  STOUT_DEFENDER = { id = 93, name = 'STOUT_DEFENDER', const = 'CREATURE_STOUT_DEFENDER' },
  AXE_FIGHTER = { id = 94, name = 'AXE_FIGHTER', const = 'CREATURE_AXE_FIGHTER' },
  AXE_THROWER = { id = 95, name = 'AXE_THROWER', const = 'CREATURE_AXE_THROWER' },
  BEAR_RIDER = { id = 96, name = 'BEAR_RIDER', const = 'CREATURE_BEAR_RIDER' },
  BLACKBEAR_RIDER = { id = 97, name = 'BLACKBEAR_RIDER', const = 'CREATURE_BLACKBEAR_RIDER' },
  BROWLER = { id = 98, name = 'BROWLER', const = 'CREATURE_BROWLER' },
  BERSERKER = { id = 99, name = 'BERSERKER', const = 'CREATURE_BERSERKER' },
  RUNE_MAGE = { id = 100, name = 'RUNE_MAGE', const = 'CREATURE_RUNE_MAGE' },
  FLAME_MAGE = { id = 101, name = 'FLAME_MAGE', const = 'CREATURE_FLAME_MAGE' },
  THANE = { id = 102, name = 'THANE', const = 'CREATURE_THANE' },
  WARLORD = { id = 103, name = 'WARLORD', const = 'CREATURE_WARLORD' },
  FIRE_DRAGON = { id = 104, name = 'FIRE_DRAGON', const = 'CREATURE_FIRE_DRAGON' },
  MAGMA_DRAGON = { id = 105, name = 'MAGMA_DRAGON', const = 'CREATURE_MAGMA_DRAGON' },
  LANDLORD = { id = 106, name = 'LANDLORD', const = 'CREATURE_LANDLORD' },
  LONGBOWMAN = { id = 107, name = 'LONGBOWMAN', const = 'CREATURE_LONGBOWMAN' },
  VINDICATOR = { id = 108, name = 'VINDICATOR', const = 'CREATURE_VINDICATOR' },
  BATTLE_GRIFFIN = { id = 109, name = 'BATTLE_GRIFFIN', const = 'CREATURE_BATTLE_GRIFFIN' },
  ZEALOT = { id = 110, name = 'ZEALOT', const = 'CREATURE_ZEALOT' },
  CHAMPION = { id = 111, name = 'CHAMPION', const = 'CREATURE_CHAMPION' },
  SERAPH = { id = 112, name = 'SERAPH', const = 'CREATURE_SERAPH' },
  WOLF = { id = 113, name = 'WOLF', const = 'CREATURE_WOLF' },
  SNOW_APE = { id = 114, name = 'SNOW_APE', const = 'CREATURE_SNOW_APE' },
  MANTICORE = { id = 115, name = 'MANTICORE', const = 'CREATURE_MANTICORE' },
  MUMMY = { id = 116, name = 'MUMMY', const = 'CREATURE_MUMMY' },
  GOBLIN = { id = 117, name = 'GOBLIN', const = 'CREATURE_GOBLIN' },
  GOBLIN_TRAPPER = { id = 118, name = 'GOBLIN_TRAPPER', const = 'CREATURE_GOBLIN_TRAPPER' },
  CENTAUR = { id = 119, name = 'CENTAUR', const = 'CREATURE_CENTAUR' },
  CENTAUR_NOMAD = { id = 120, name = 'CENTAUR_NOMAD', const = 'CREATURE_CENTAUR_NOMAD' },
  ORC_WARRIOR = { id = 121, name = 'ORC_WARRIOR', const = 'CREATURE_ORC_WARRIOR' },
  ORC_SLAYER = { id = 122, name = 'ORC_SLAYER', const = 'CREATURE_ORC_SLAYER' },
  SHAMAN = { id = 123, name = 'SHAMAN', const = 'CREATURE_SHAMAN' },
  SHAMAN_WITCH = { id = 124, name = 'SHAMAN_WITCH', const = 'CREATURE_SHAMAN_WITCH' },
  ORCCHIEF_BUTCHER = { id = 125, name = 'ORCCHIEF_BUTCHER', const = 'CREATURE_ORCCHIEF_BUTCHER' },
  ORCCHIEF_EXECUTIONER = { id = 126, name = 'ORCCHIEF_EXECUTIONER', const = 'CREATURE_ORCCHIEF_EXECUTIONER' },
  WYVERN = { id = 127, name = 'WYVERN', const = 'CREATURE_WYVERN' },
  WYVERN_POISONOUS = { id = 128, name = 'WYVERN_POISONOUS', const = 'CREATURE_WYVERN_POISONOUS' },
  CYCLOP = { id = 129, name = 'CYCLOP', const = 'CREATURE_CYCLOP' },
  CYCLOP_UNTAMED = { id = 130, name = 'CYCLOP_UNTAMED', const = 'CREATURE_CYCLOP_UNTAMED' },
  QUASIT = { id = 131, name = 'QUASIT', const = 'CREATURE_QUASIT' },
  HORNED_LEAPER = { id = 132, name = 'HORNED_LEAPER', const = 'CREATURE_HORNED_LEAPER' },
  FIREBREATHER_HOUND = { id = 133, name = 'FIREBREATHER_HOUND', const = 'CREATURE_FIREBREATHER_HOUND' },
  SUCCUBUS_SEDUCER = { id = 134, name = 'SUCCUBUS_SEDUCER', const = 'CREATURE_SUCCUBUS_SEDUCER' },
  HELLMARE = { id = 135, name = 'HELLMARE', const = 'CREATURE_HELLMARE' },
  PIT_SPAWN = { id = 136, name = 'PIT_SPAWN', const = 'CREATURE_PIT_SPAWN' },
  ARCH_DEMON = { id = 137, name = 'ARCH_DEMON', const = 'CREATURE_ARCH_DEMON' },
  STALKER = { id = 138, name = 'STALKER', const = 'CREATURE_STALKER' },
  BLOOD_WITCH_2 = { id = 139, name = 'BLOOD_WITCH_2', const = 'CREATURE_BLOOD_WITCH_2' },
  MINOTAUR_CAPTAIN = { id = 140, name = 'MINOTAUR_CAPTAIN', const = 'CREATURE_MINOTAUR_CAPTAIN' },
  BLACK_RIDER = { id = 141, name = 'BLACK_RIDER', const = 'CREATURE_BLACK_RIDER' },
  ACIDIC_HYDRA = { id = 142, name = 'ACIDIC_HYDRA', const = 'CREATURE_ACIDIC_HYDRA' },
  SHADOW_MISTRESS = { id = 143, name = 'SHADOW_MISTRESS', const = 'CREATURE_SHADOW_MISTRESS' },
  RED_DRAGON = { id = 144, name = 'RED_DRAGON', const = 'CREATURE_RED_DRAGON' },
  DRYAD = { id = 145, name = 'DRYAD', const = 'CREATURE_DRYAD' },
  BLADE_SINGER = { id = 146, name = 'BLADE_SINGER', const = 'CREATURE_BLADE_SINGER' },
  SHARP_SHOOTER = { id = 147, name = 'SHARP_SHOOTER', const = 'CREATURE_SHARP_SHOOTER' },
  HIGH_DRUID = { id = 148, name = 'HIGH_DRUID', const = 'CREATURE_HIGH_DRUID' },
  WHITE_UNICORN = { id = 149, name = 'WHITE_UNICORN', const = 'CREATURE_WHITE_UNICORN' },
  ANGER_TREANT = { id = 150, name = 'ANGER_TREANT', const = 'CREATURE_ANGER_TREANT' },
  RAINBOW_DRAGON = { id = 151, name = 'RAINBOW_DRAGON', const = 'CREATURE_RAINBOW_DRAGON' },
  SKELETON_WARRIOR = { id = 152, name = 'SKELETON_WARRIOR', const = 'CREATURE_SKELETON_WARRIOR' },
  DISEASE_ZOMBIE = { id = 153, name = 'DISEASE_ZOMBIE', const = 'CREATURE_DISEASE_ZOMBIE' },
  POLTERGEIST = { id = 154, name = 'POLTERGEIST', const = 'CREATURE_POLTERGEIST' },
  NOSFERATU = { id = 155, name = 'NOSFERATU', const = 'CREATURE_NOSFERATU' },
  LICH_MASTER = { id = 156, name = 'LICH_MASTER', const = 'CREATURE_LICH_MASTER' },
  BANSHEE = { id = 157, name = 'BANSHEE', const = 'CREATURE_BANSHEE' },
  HORROR_DRAGON = { id = 158, name = 'HORROR_DRAGON', const = 'CREATURE_HORROR_DRAGON' },
  GREMLIN_SABOTEUR = { id = 159, name = 'GREMLIN_SABOTEUR', const = 'CREATURE_GREMLIN_SABOTEUR' },
  MARBLE_GARGOYLE = { id = 160, name = 'MARBLE_GARGOYLE', const = 'CREATURE_MARBLE_GARGOYLE' },
  OBSIDIAN_GOLEM = { id = 161, name = 'OBSIDIAN_GOLEM', const = 'CREATURE_OBSIDIAN_GOLEM' },
  COMBAT_MAGE = { id = 162, name = 'COMBAT_MAGE', const = 'CREATURE_COMBAT_MAGE' },
  DJINN_VIZIER = { id = 163, name = 'DJINN_VIZIER', const = 'CREATURE_DJINN_VIZIER' },
  RAKSHASA_KSHATRI = { id = 164, name = 'RAKSHASA_KSHATRI', const = 'CREATURE_RAKSHASA_KSHATRI' },
  STORM_LORD = { id = 165, name = 'STORM_LORD', const = 'CREATURE_STORM_LORD' },
  STONE_DEFENDER = { id = 166, name = 'STONE_DEFENDER', const = 'CREATURE_STONE_DEFENDER' },
  HARPOONER = { id = 167, name = 'HARPOONER', const = 'CREATURE_HARPOONER' },
  WHITE_BEAR_RIDER = { id = 168, name = 'WHITE_BEAR_RIDER', const = 'CREATURE_WHITE_BEAR_RIDER' },
  BATTLE_RAGER = { id = 169, name = 'BATTLE_RAGER', const = 'CREATURE_BATTLE_RAGER' },
  FLAME_KEEPER = { id = 170, name = 'FLAME_KEEPER', const = 'CREATURE_FLAME_KEEPER' },
  THUNDER_THANE = { id = 171, name = 'THUNDER_THANE', const = 'CREATURE_THUNDER_THANE' },
  LAVA_DRAGON = { id = 172, name = 'LAVA_DRAGON', const = 'CREATURE_LAVA_DRAGON' },
  GOBLIN_DEFILER = { id = 173, name = 'GOBLIN_DEFILER', const = 'CREATURE_GOBLIN_DEFILER' },
  CENTAUR_MARADEUR = { id = 174, name = 'CENTAUR_MARADEUR', const = 'CREATURE_CENTAUR_MARADEUR' },
  ORC_WARMONGER = { id = 175, name = 'ORC_WARMONGER', const = 'CREATURE_ORC_WARMONGER' },
  SHAMAN_HAG = { id = 176, name = 'SHAMAN_HAG', const = 'CREATURE_SHAMAN_HAG' },
  ORCCHIEF_CHIEFTAIN = { id = 177, name = 'ORCCHIEF_CHIEFTAIN', const = 'CREATURE_ORCCHIEF_CHIEFTAIN' },
  WYVERN_PAOKAI = { id = 178, name = 'WYVERN_PAOKAI', const = 'CREATURE_WYVERN_PAOKAI' },
  CYCLOP_BLOODEYED = { id = 179, name = 'CYCLOP_BLOODEYED', const = 'CREATURE_CYCLOP_BLOODEYED' },
  250 = { id = 250, name = '250', const = 'CREATURE_250' },
  251 = { id = 251, name = '251', const = 'CREATURE_251' },
  252 = { id = 252, name = '252', const = 'CREATURE_252' },
  253 = { id = 253, name = '253', const = 'CREATURE_253' },
  254 = { id = 254, name = '254', const = 'CREATURE_254' },
  255 = { id = 255, name = '255', const = 'CREATURE_255' },
  256 = { id = 256, name = '256', const = 'CREATURE_256' },
  257 = { id = 257, name = '257', const = 'CREATURE_257' },
  258 = { id = 258, name = '258', const = 'CREATURE_258' },
  259 = { id = 259, name = '259', const = 'CREATURE_259' },
  260 = { id = 260, name = '260', const = 'CREATURE_260' },
  261 = { id = 261, name = '261', const = 'CREATURE_261' },
  262 = { id = 262, name = '262', const = 'CREATURE_262' },
  263 = { id = 263, name = '263', const = 'CREATURE_263' },
  264 = { id = 264, name = '264', const = 'CREATURE_264' },
  265 = { id = 265, name = '265', const = 'CREATURE_265' },
  266 = { id = 266, name = '266', const = 'CREATURE_266' },
  267 = { id = 267, name = '267', const = 'CREATURE_267' },
  268 = { id = 268, name = '268', const = 'CREATURE_268' },
  269 = { id = 269, name = '269', const = 'CREATURE_269' },
  270 = { id = 270, name = '270', const = 'CREATURE_270' },
  271 = { id = 271, name = '271', const = 'CREATURE_271' },
  272 = { id = 272, name = '272', const = 'CREATURE_272' },
  273 = { id = 273, name = '273', const = 'CREATURE_273' },
  274 = { id = 274, name = '274', const = 'CREATURE_274' },
  275 = { id = 275, name = '275', const = 'CREATURE_275' },
  276 = { id = 276, name = '276', const = 'CREATURE_276' },
  277 = { id = 277, name = '277', const = 'CREATURE_277' },
  278 = { id = 278, name = '278', const = 'CREATURE_278' },
  279 = { id = 279, name = '279', const = 'CREATURE_279' },
  280 = { id = 280, name = '280', const = 'CREATURE_280' },
  281 = { id = 281, name = '281', const = 'CREATURE_281' },
  282 = { id = 282, name = '282', const = 'CREATURE_282' },
  283 = { id = 283, name = '283', const = 'CREATURE_283' },
  284 = { id = 284, name = '284', const = 'CREATURE_284' },
  285 = { id = 285, name = '285', const = 'CREATURE_285' },
  286 = { id = 286, name = '286', const = 'CREATURE_286' },
  287 = { id = 287, name = '287', const = 'CREATURE_287' },
  288 = { id = 288, name = '288', const = 'CREATURE_288' },
  289 = { id = 289, name = '289', const = 'CREATURE_289' },
  290 = { id = 290, name = '290', const = 'CREATURE_290' },
  291 = { id = 291, name = '291', const = 'CREATURE_291' },
  292 = { id = 292, name = '292', const = 'CREATURE_292' },
  293 = { id = 293, name = '293', const = 'CREATURE_293' },
  294 = { id = 294, name = '294', const = 'CREATURE_294' },
  295 = { id = 295, name = '295', const = 'CREATURE_295' },
  296 = { id = 296, name = '296', const = 'CREATURE_296' },
  297 = { id = 297, name = '297', const = 'CREATURE_297' },
  298 = { id = 298, name = '298', const = 'CREATURE_298' },
  299 = { id = 299, name = '299', const = 'CREATURE_299' },
  300 = { id = 300, name = '300', const = 'CREATURE_300' },
  301 = { id = 301, name = '301', const = 'CREATURE_301' },
  302 = { id = 302, name = '302', const = 'CREATURE_302' },
  303 = { id = 303, name = '303', const = 'CREATURE_303' },
  304 = { id = 304, name = '304', const = 'CREATURE_304' },
  305 = { id = 305, name = '305', const = 'CREATURE_305' },
  306 = { id = 306, name = '306', const = 'CREATURE_306' },
  307 = { id = 307, name = '307', const = 'CREATURE_307' },
  308 = { id = 308, name = '308', const = 'CREATURE_308' },
  309 = { id = 309, name = '309', const = 'CREATURE_309' },
  310 = { id = 310, name = '310', const = 'CREATURE_310' },
  311 = { id = 311, name = '311', const = 'CREATURE_311' },
  312 = { id = 312, name = '312', const = 'CREATURE_312' },
  313 = { id = 313, name = '313', const = 'CREATURE_313' },
  314 = { id = 314, name = '314', const = 'CREATURE_314' },
  315 = { id = 315, name = '315', const = 'CREATURE_315' },
  316 = { id = 316, name = '316', const = 'CREATURE_316' },
  317 = { id = 317, name = '317', const = 'CREATURE_317' },
  318 = { id = 318, name = '318', const = 'CREATURE_318' },
  319 = { id = 319, name = '319', const = 'CREATURE_319' },
  320 = { id = 320, name = '320', const = 'CREATURE_320' },
  321 = { id = 321, name = '321', const = 'CREATURE_321' },
  322 = { id = 322, name = '322', const = 'CREATURE_322' },
  323 = { id = 323, name = '323', const = 'CREATURE_323' },
  324 = { id = 324, name = '324', const = 'CREATURE_324' },
  325 = { id = 325, name = '325', const = 'CREATURE_325' },
  326 = { id = 326, name = '326', const = 'CREATURE_326' },
  327 = { id = 327, name = '327', const = 'CREATURE_327' },
  328 = { id = 328, name = '328', const = 'CREATURE_328' },
  329 = { id = 329, name = '329', const = 'CREATURE_329' },
  330 = { id = 330, name = '330', const = 'CREATURE_330' },
  331 = { id = 331, name = '331', const = 'CREATURE_331' },
  332 = { id = 332, name = '332', const = 'CREATURE_332' },
  333 = { id = 333, name = '333', const = 'CREATURE_333' },
  334 = { id = 334, name = '334', const = 'CREATURE_334' },
  335 = { id = 335, name = '335', const = 'CREATURE_335' },
  336 = { id = 336, name = '336', const = 'CREATURE_336' },
  337 = { id = 337, name = '337', const = 'CREATURE_337' },
  338 = { id = 338, name = '338', const = 'CREATURE_338' },
  339 = { id = 339, name = '339', const = 'CREATURE_339' },
  340 = { id = 340, name = '340', const = 'CREATURE_340' },
  341 = { id = 341, name = '341', const = 'CREATURE_341' },
  342 = { id = 342, name = '342', const = 'CREATURE_342' },
  343 = { id = 343, name = '343', const = 'CREATURE_343' },
  344 = { id = 344, name = '344', const = 'CREATURE_344' },
  345 = { id = 345, name = '345', const = 'CREATURE_345' },
  346 = { id = 346, name = '346', const = 'CREATURE_346' },
  347 = { id = 347, name = '347', const = 'CREATURE_347' },
  348 = { id = 348, name = '348', const = 'CREATURE_348' },
  349 = { id = 349, name = '349', const = 'CREATURE_349' },
  350 = { id = 350, name = '350', const = 'CREATURE_350' },
  351 = { id = 351, name = '351', const = 'CREATURE_351' },
  352 = { id = 352, name = '352', const = 'CREATURE_352' },
  353 = { id = 353, name = '353', const = 'CREATURE_353' },
  354 = { id = 354, name = '354', const = 'CREATURE_354' },
  355 = { id = 355, name = '355', const = 'CREATURE_355' },
  356 = { id = 356, name = '356', const = 'CREATURE_356' },
  357 = { id = 357, name = '357', const = 'CREATURE_357' },
  358 = { id = 358, name = '358', const = 'CREATURE_358' },
  359 = { id = 359, name = '359', const = 'CREATURE_359' },
  360 = { id = 360, name = '360', const = 'CREATURE_360' },
  361 = { id = 361, name = '361', const = 'CREATURE_361' },
  362 = { id = 362, name = '362', const = 'CREATURE_362' },
  363 = { id = 363, name = '363', const = 'CREATURE_363' },
  364 = { id = 364, name = '364', const = 'CREATURE_364' },
  365 = { id = 365, name = '365', const = 'CREATURE_365' },
  366 = { id = 366, name = '366', const = 'CREATURE_366' },
  367 = { id = 367, name = '367', const = 'CREATURE_367' },
  368 = { id = 368, name = '368', const = 'CREATURE_368' },
  369 = { id = 369, name = '369', const = 'CREATURE_369' },
  370 = { id = 370, name = '370', const = 'CREATURE_370' },
  371 = { id = 371, name = '371', const = 'CREATURE_371' },
  372 = { id = 372, name = '372', const = 'CREATURE_372' },
  373 = { id = 373, name = '373', const = 'CREATURE_373' },
  374 = { id = 374, name = '374', const = 'CREATURE_374' },
  375 = { id = 375, name = '375', const = 'CREATURE_375' },
  376 = { id = 376, name = '376', const = 'CREATURE_376' },
  377 = { id = 377, name = '377', const = 'CREATURE_377' },
  378 = { id = 378, name = '378', const = 'CREATURE_378' },
  379 = { id = 379, name = '379', const = 'CREATURE_379' },
  380 = { id = 380, name = '380', const = 'CREATURE_380' },
  381 = { id = 381, name = '381', const = 'CREATURE_381' },
  382 = { id = 382, name = '382', const = 'CREATURE_382' },
  383 = { id = 383, name = '383', const = 'CREATURE_383' },
  384 = { id = 384, name = '384', const = 'CREATURE_384' },
  385 = { id = 385, name = '385', const = 'CREATURE_385' },
  386 = { id = 386, name = '386', const = 'CREATURE_386' },
  387 = { id = 387, name = '387', const = 'CREATURE_387' },
  388 = { id = 388, name = '388', const = 'CREATURE_388' },
  389 = { id = 389, name = '389', const = 'CREATURE_389' },
  390 = { id = 390, name = '390', const = 'CREATURE_390' },
  391 = { id = 391, name = '391', const = 'CREATURE_391' },
  392 = { id = 392, name = '392', const = 'CREATURE_392' },
  393 = { id = 393, name = '393', const = 'CREATURE_393' },
  394 = { id = 394, name = '394', const = 'CREATURE_394' },
  395 = { id = 395, name = '395', const = 'CREATURE_395' },
  396 = { id = 396, name = '396', const = 'CREATURE_396' },
  397 = { id = 397, name = '397', const = 'CREATURE_397' },
  398 = { id = 398, name = '398', const = 'CREATURE_398' },
  399 = { id = 399, name = '399', const = 'CREATURE_399' },
  400 = { id = 400, name = '400', const = 'CREATURE_400' },
  401 = { id = 401, name = '401', const = 'CREATURE_401' },
  402 = { id = 402, name = '402', const = 'CREATURE_402' },
  403 = { id = 403, name = '403', const = 'CREATURE_403' },
  404 = { id = 404, name = '404', const = 'CREATURE_404' },
  405 = { id = 405, name = '405', const = 'CREATURE_405' },
  406 = { id = 406, name = '406', const = 'CREATURE_406' },
  407 = { id = 407, name = '407', const = 'CREATURE_407' },
  408 = { id = 408, name = '408', const = 'CREATURE_408' },
  409 = { id = 409, name = '409', const = 'CREATURE_409' },
  410 = { id = 410, name = '410', const = 'CREATURE_410' },
  411 = { id = 411, name = '411', const = 'CREATURE_411' },
  412 = { id = 412, name = '412', const = 'CREATURE_412' },
  413 = { id = 413, name = '413', const = 'CREATURE_413' },
  414 = { id = 414, name = '414', const = 'CREATURE_414' },
  415 = { id = 415, name = '415', const = 'CREATURE_415' },
  416 = { id = 416, name = '416', const = 'CREATURE_416' },
  417 = { id = 417, name = '417', const = 'CREATURE_417' },
  418 = { id = 418, name = '418', const = 'CREATURE_418' },
  419 = { id = 419, name = '419', const = 'CREATURE_419' },
  420 = { id = 420, name = '420', const = 'CREATURE_420' },
  421 = { id = 421, name = '421', const = 'CREATURE_421' },
  422 = { id = 422, name = '422', const = 'CREATURE_422' },
  423 = { id = 423, name = '423', const = 'CREATURE_423' },
  424 = { id = 424, name = '424', const = 'CREATURE_424' },
  425 = { id = 425, name = '425', const = 'CREATURE_425' },
  426 = { id = 426, name = '426', const = 'CREATURE_426' },
  427 = { id = 427, name = '427', const = 'CREATURE_427' },
  428 = { id = 428, name = '428', const = 'CREATURE_428' },
  429 = { id = 429, name = '429', const = 'CREATURE_429' },
  430 = { id = 430, name = '430', const = 'CREATURE_430' },
  431 = { id = 431, name = '431', const = 'CREATURE_431' },
  432 = { id = 432, name = '432', const = 'CREATURE_432' },
  433 = { id = 433, name = '433', const = 'CREATURE_433' },
  434 = { id = 434, name = '434', const = 'CREATURE_434' },
  435 = { id = 435, name = '435', const = 'CREATURE_435' },
  436 = { id = 436, name = '436', const = 'CREATURE_436' },
  437 = { id = 437, name = '437', const = 'CREATURE_437' },
  438 = { id = 438, name = '438', const = 'CREATURE_438' },
  439 = { id = 439, name = '439', const = 'CREATURE_439' },
  440 = { id = 440, name = '440', const = 'CREATURE_440' },
  441 = { id = 441, name = '441', const = 'CREATURE_441' },
  442 = { id = 442, name = '442', const = 'CREATURE_442' },
  443 = { id = 443, name = '443', const = 'CREATURE_443' },
  444 = { id = 444, name = '444', const = 'CREATURE_444' },
  445 = { id = 445, name = '445', const = 'CREATURE_445' },
  446 = { id = 446, name = '446', const = 'CREATURE_446' },
  447 = { id = 447, name = '447', const = 'CREATURE_447' },
  448 = { id = 448, name = '448', const = 'CREATURE_448' },
  449 = { id = 449, name = '449', const = 'CREATURE_449' },
  450 = { id = 450, name = '450', const = 'CREATURE_450' },
  451 = { id = 451, name = '451', const = 'CREATURE_451' },
  452 = { id = 452, name = '452', const = 'CREATURE_452' },
  453 = { id = 453, name = '453', const = 'CREATURE_453' },
  454 = { id = 454, name = '454', const = 'CREATURE_454' },
  455 = { id = 455, name = '455', const = 'CREATURE_455' },
  456 = { id = 456, name = '456', const = 'CREATURE_456' },
  457 = { id = 457, name = '457', const = 'CREATURE_457' },
  458 = { id = 458, name = '458', const = 'CREATURE_458' },
  459 = { id = 459, name = '459', const = 'CREATURE_459' },
  460 = { id = 460, name = '460', const = 'CREATURE_460' },
  461 = { id = 461, name = '461', const = 'CREATURE_461' },
  462 = { id = 462, name = '462', const = 'CREATURE_462' },
  463 = { id = 463, name = '463', const = 'CREATURE_463' },
  464 = { id = 464, name = '464', const = 'CREATURE_464' },
  465 = { id = 465, name = '465', const = 'CREATURE_465' },
  466 = { id = 466, name = '466', const = 'CREATURE_466' },
  467 = { id = 467, name = '467', const = 'CREATURE_467' },
  468 = { id = 468, name = '468', const = 'CREATURE_468' },
  469 = { id = 469, name = '469', const = 'CREATURE_469' },
  470 = { id = 470, name = '470', const = 'CREATURE_470' },
  471 = { id = 471, name = '471', const = 'CREATURE_471' },
  472 = { id = 472, name = '472', const = 'CREATURE_472' },
  473 = { id = 473, name = '473', const = 'CREATURE_473' },
  474 = { id = 474, name = '474', const = 'CREATURE_474' },
  475 = { id = 475, name = '475', const = 'CREATURE_475' },
  476 = { id = 476, name = '476', const = 'CREATURE_476' },
  477 = { id = 477, name = '477', const = 'CREATURE_477' },
  478 = { id = 478, name = '478', const = 'CREATURE_478' },
  479 = { id = 479, name = '479', const = 'CREATURE_479' },
  480 = { id = 480, name = '480', const = 'CREATURE_480' },
  481 = { id = 481, name = '481', const = 'CREATURE_481' },
  482 = { id = 482, name = '482', const = 'CREATURE_482' },
  483 = { id = 483, name = '483', const = 'CREATURE_483' },
  484 = { id = 484, name = '484', const = 'CREATURE_484' },
  485 = { id = 485, name = '485', const = 'CREATURE_485' },
  486 = { id = 486, name = '486', const = 'CREATURE_486' },
  487 = { id = 487, name = '487', const = 'CREATURE_487' },
  488 = { id = 488, name = '488', const = 'CREATURE_488' },
  489 = { id = 489, name = '489', const = 'CREATURE_489' },
  490 = { id = 490, name = '490', const = 'CREATURE_490' },
  491 = { id = 491, name = '491', const = 'CREATURE_491' },
  492 = { id = 492, name = '492', const = 'CREATURE_492' },
  493 = { id = 493, name = '493', const = 'CREATURE_493' },
  494 = { id = 494, name = '494', const = 'CREATURE_494' },
  495 = { id = 495, name = '495', const = 'CREATURE_495' },
  496 = { id = 496, name = '496', const = 'CREATURE_496' },
  497 = { id = 497, name = '497', const = 'CREATURE_497' },
  498 = { id = 498, name = '498', const = 'CREATURE_498' },
  499 = { id = 499, name = '499', const = 'CREATURE_499' },
  500 = { id = 500, name = '500', const = 'CREATURE_500' },
  501 = { id = 501, name = '501', const = 'CREATURE_501' },
  502 = { id = 502, name = '502', const = 'CREATURE_502' },
  503 = { id = 503, name = '503', const = 'CREATURE_503' },
  504 = { id = 504, name = '504', const = 'CREATURE_504' },
  505 = { id = 505, name = '505', const = 'CREATURE_505' },
  506 = { id = 506, name = '506', const = 'CREATURE_506' },
  507 = { id = 507, name = '507', const = 'CREATURE_507' },
  508 = { id = 508, name = '508', const = 'CREATURE_508' },
  509 = { id = 509, name = '509', const = 'CREATURE_509' },
  510 = { id = 510, name = '510', const = 'CREATURE_510' },
  511 = { id = 511, name = '511', const = 'CREATURE_511' },
  512 = { id = 512, name = '512', const = 'CREATURE_512' },
  513 = { id = 513, name = '513', const = 'CREATURE_513' },
  514 = { id = 514, name = '514', const = 'CREATURE_514' },
  515 = { id = 515, name = '515', const = 'CREATURE_515' },
  516 = { id = 516, name = '516', const = 'CREATURE_516' },
  517 = { id = 517, name = '517', const = 'CREATURE_517' },
  518 = { id = 518, name = '518', const = 'CREATURE_518' },
  519 = { id = 519, name = '519', const = 'CREATURE_519' },
  520 = { id = 520, name = '520', const = 'CREATURE_520' },
  521 = { id = 521, name = '521', const = 'CREATURE_521' },
  522 = { id = 522, name = '522', const = 'CREATURE_522' },
  523 = { id = 523, name = '523', const = 'CREATURE_523' },
  524 = { id = 524, name = '524', const = 'CREATURE_524' },
  525 = { id = 525, name = '525', const = 'CREATURE_525' },
  526 = { id = 526, name = '526', const = 'CREATURE_526' },
  527 = { id = 527, name = '527', const = 'CREATURE_527' },
  528 = { id = 528, name = '528', const = 'CREATURE_528' },
  529 = { id = 529, name = '529', const = 'CREATURE_529' },
  530 = { id = 530, name = '530', const = 'CREATURE_530' },
  531 = { id = 531, name = '531', const = 'CREATURE_531' },
  532 = { id = 532, name = '532', const = 'CREATURE_532' },
  533 = { id = 533, name = '533', const = 'CREATURE_533' },
  534 = { id = 534, name = '534', const = 'CREATURE_534' },
  535 = { id = 535, name = '535', const = 'CREATURE_535' },
  536 = { id = 536, name = '536', const = 'CREATURE_536' },
  537 = { id = 537, name = '537', const = 'CREATURE_537' },
  538 = { id = 538, name = '538', const = 'CREATURE_538' },
  539 = { id = 539, name = '539', const = 'CREATURE_539' },
  540 = { id = 540, name = '540', const = 'CREATURE_540' },
  541 = { id = 541, name = '541', const = 'CREATURE_541' },
  542 = { id = 542, name = '542', const = 'CREATURE_542' },
  543 = { id = 543, name = '543', const = 'CREATURE_543' },
  544 = { id = 544, name = '544', const = 'CREATURE_544' },
  545 = { id = 545, name = '545', const = 'CREATURE_545' },
  546 = { id = 546, name = '546', const = 'CREATURE_546' },
  547 = { id = 547, name = '547', const = 'CREATURE_547' },
  548 = { id = 548, name = '548', const = 'CREATURE_548' },
  549 = { id = 549, name = '549', const = 'CREATURE_549' },
  550 = { id = 550, name = '550', const = 'CREATURE_550' },
  551 = { id = 551, name = '551', const = 'CREATURE_551' },
  552 = { id = 552, name = '552', const = 'CREATURE_552' },
  553 = { id = 553, name = '553', const = 'CREATURE_553' },
  554 = { id = 554, name = '554', const = 'CREATURE_554' },
  555 = { id = 555, name = '555', const = 'CREATURE_555' },
  556 = { id = 556, name = '556', const = 'CREATURE_556' },
  557 = { id = 557, name = '557', const = 'CREATURE_557' },
  558 = { id = 558, name = '558', const = 'CREATURE_558' },
  559 = { id = 559, name = '559', const = 'CREATURE_559' },
  560 = { id = 560, name = '560', const = 'CREATURE_560' },
  561 = { id = 561, name = '561', const = 'CREATURE_561' },
  562 = { id = 562, name = '562', const = 'CREATURE_562' },
  563 = { id = 563, name = '563', const = 'CREATURE_563' },
  564 = { id = 564, name = '564', const = 'CREATURE_564' },
  565 = { id = 565, name = '565', const = 'CREATURE_565' },
  566 = { id = 566, name = '566', const = 'CREATURE_566' },
  567 = { id = 567, name = '567', const = 'CREATURE_567' },
  568 = { id = 568, name = '568', const = 'CREATURE_568' },
  569 = { id = 569, name = '569', const = 'CREATURE_569' },
  570 = { id = 570, name = '570', const = 'CREATURE_570' },
  571 = { id = 571, name = '571', const = 'CREATURE_571' },
  572 = { id = 572, name = '572', const = 'CREATURE_572' },
  573 = { id = 573, name = '573', const = 'CREATURE_573' },
  574 = { id = 574, name = '574', const = 'CREATURE_574' },
  575 = { id = 575, name = '575', const = 'CREATURE_575' },
  576 = { id = 576, name = '576', const = 'CREATURE_576' },
  577 = { id = 577, name = '577', const = 'CREATURE_577' },
  578 = { id = 578, name = '578', const = 'CREATURE_578' },
  579 = { id = 579, name = '579', const = 'CREATURE_579' },
  580 = { id = 580, name = '580', const = 'CREATURE_580' },
  581 = { id = 581, name = '581', const = 'CREATURE_581' },
  582 = { id = 582, name = '582', const = 'CREATURE_582' },
  583 = { id = 583, name = '583', const = 'CREATURE_583' },
  584 = { id = 584, name = '584', const = 'CREATURE_584' },
  585 = { id = 585, name = '585', const = 'CREATURE_585' },
  586 = { id = 586, name = '586', const = 'CREATURE_586' },
  587 = { id = 587, name = '587', const = 'CREATURE_587' },
  588 = { id = 588, name = '588', const = 'CREATURE_588' },
  589 = { id = 589, name = '589', const = 'CREATURE_589' },
  590 = { id = 590, name = '590', const = 'CREATURE_590' },
  591 = { id = 591, name = '591', const = 'CREATURE_591' },
  592 = { id = 592, name = '592', const = 'CREATURE_592' },
  593 = { id = 593, name = '593', const = 'CREATURE_593' },
  594 = { id = 594, name = '594', const = 'CREATURE_594' },
  595 = { id = 595, name = '595', const = 'CREATURE_595' },
  596 = { id = 596, name = '596', const = 'CREATURE_596' },
  597 = { id = 597, name = '597', const = 'CREATURE_597' },
  598 = { id = 598, name = '598', const = 'CREATURE_598' },
  599 = { id = 599, name = '599', const = 'CREATURE_599' },
  600 = { id = 600, name = '600', const = 'CREATURE_600' },
  601 = { id = 601, name = '601', const = 'CREATURE_601' },
  602 = { id = 602, name = '602', const = 'CREATURE_602' },
  603 = { id = 603, name = '603', const = 'CREATURE_603' },
  604 = { id = 604, name = '604', const = 'CREATURE_604' },
  605 = { id = 605, name = '605', const = 'CREATURE_605' },
  606 = { id = 606, name = '606', const = 'CREATURE_606' },
  607 = { id = 607, name = '607', const = 'CREATURE_607' },
  608 = { id = 608, name = '608', const = 'CREATURE_608' },
  609 = { id = 609, name = '609', const = 'CREATURE_609' },
  610 = { id = 610, name = '610', const = 'CREATURE_610' },
  611 = { id = 611, name = '611', const = 'CREATURE_611' },
  612 = { id = 612, name = '612', const = 'CREATURE_612' },
  613 = { id = 613, name = '613', const = 'CREATURE_613' },
  614 = { id = 614, name = '614', const = 'CREATURE_614' },
  615 = { id = 615, name = '615', const = 'CREATURE_615' },
  616 = { id = 616, name = '616', const = 'CREATURE_616' },
  617 = { id = 617, name = '617', const = 'CREATURE_617' },
  618 = { id = 618, name = '618', const = 'CREATURE_618' },
  619 = { id = 619, name = '619', const = 'CREATURE_619' },
  620 = { id = 620, name = '620', const = 'CREATURE_620' },
  621 = { id = 621, name = '621', const = 'CREATURE_621' },
  622 = { id = 622, name = '622', const = 'CREATURE_622' },
  623 = { id = 623, name = '623', const = 'CREATURE_623' },
  624 = { id = 624, name = '624', const = 'CREATURE_624' },
  625 = { id = 625, name = '625', const = 'CREATURE_625' },
  626 = { id = 626, name = '626', const = 'CREATURE_626' },
  627 = { id = 627, name = '627', const = 'CREATURE_627' },
  628 = { id = 628, name = '628', const = 'CREATURE_628' },
  629 = { id = 629, name = '629', const = 'CREATURE_629' },
  630 = { id = 630, name = '630', const = 'CREATURE_630' },
  631 = { id = 631, name = '631', const = 'CREATURE_631' },
  632 = { id = 632, name = '632', const = 'CREATURE_632' },
  633 = { id = 633, name = '633', const = 'CREATURE_633' },
  634 = { id = 634, name = '634', const = 'CREATURE_634' },
  635 = { id = 635, name = '635', const = 'CREATURE_635' },
  636 = { id = 636, name = '636', const = 'CREATURE_636' },
  637 = { id = 637, name = '637', const = 'CREATURE_637' },
  638 = { id = 638, name = '638', const = 'CREATURE_638' },
  639 = { id = 639, name = '639', const = 'CREATURE_639' },
  640 = { id = 640, name = '640', const = 'CREATURE_640' },
  641 = { id = 641, name = '641', const = 'CREATURE_641' },
  642 = { id = 642, name = '642', const = 'CREATURE_642' },
  643 = { id = 643, name = '643', const = 'CREATURE_643' },
  644 = { id = 644, name = '644', const = 'CREATURE_644' },
  645 = { id = 645, name = '645', const = 'CREATURE_645' },
  646 = { id = 646, name = '646', const = 'CREATURE_646' },
  647 = { id = 647, name = '647', const = 'CREATURE_647' },
  648 = { id = 648, name = '648', const = 'CREATURE_648' },
  649 = { id = 649, name = '649', const = 'CREATURE_649' },
  650 = { id = 650, name = '650', const = 'CREATURE_650' },
  651 = { id = 651, name = '651', const = 'CREATURE_651' },
  652 = { id = 652, name = '652', const = 'CREATURE_652' },
  653 = { id = 653, name = '653', const = 'CREATURE_653' },
  654 = { id = 654, name = '654', const = 'CREATURE_654' },
  655 = { id = 655, name = '655', const = 'CREATURE_655' },
  656 = { id = 656, name = '656', const = 'CREATURE_656' },
  657 = { id = 657, name = '657', const = 'CREATURE_657' },
  658 = { id = 658, name = '658', const = 'CREATURE_658' },
  659 = { id = 659, name = '659', const = 'CREATURE_659' },
  660 = { id = 660, name = '660', const = 'CREATURE_660' },
  661 = { id = 661, name = '661', const = 'CREATURE_661' },
  662 = { id = 662, name = '662', const = 'CREATURE_662' },
  663 = { id = 663, name = '663', const = 'CREATURE_663' },
  664 = { id = 664, name = '664', const = 'CREATURE_664' },
  665 = { id = 665, name = '665', const = 'CREATURE_665' },
  666 = { id = 666, name = '666', const = 'CREATURE_666' },
  667 = { id = 667, name = '667', const = 'CREATURE_667' },
  668 = { id = 668, name = '668', const = 'CREATURE_668' },
  669 = { id = 669, name = '669', const = 'CREATURE_669' },
  670 = { id = 670, name = '670', const = 'CREATURE_670' },
  671 = { id = 671, name = '671', const = 'CREATURE_671' },
  672 = { id = 672, name = '672', const = 'CREATURE_672' },
  673 = { id = 673, name = '673', const = 'CREATURE_673' },
  674 = { id = 674, name = '674', const = 'CREATURE_674' },
  675 = { id = 675, name = '675', const = 'CREATURE_675' },
  676 = { id = 676, name = '676', const = 'CREATURE_676' },
  677 = { id = 677, name = '677', const = 'CREATURE_677' },
  678 = { id = 678, name = '678', const = 'CREATURE_678' },
  679 = { id = 679, name = '679', const = 'CREATURE_679' },
  680 = { id = 680, name = '680', const = 'CREATURE_680' },
  681 = { id = 681, name = '681', const = 'CREATURE_681' },
  682 = { id = 682, name = '682', const = 'CREATURE_682' },
  683 = { id = 683, name = '683', const = 'CREATURE_683' },
  684 = { id = 684, name = '684', const = 'CREATURE_684' },
  685 = { id = 685, name = '685', const = 'CREATURE_685' },
  686 = { id = 686, name = '686', const = 'CREATURE_686' },
  687 = { id = 687, name = '687', const = 'CREATURE_687' },
  688 = { id = 688, name = '688', const = 'CREATURE_688' },
  689 = { id = 689, name = '689', const = 'CREATURE_689' },
  690 = { id = 690, name = '690', const = 'CREATURE_690' },
  691 = { id = 691, name = '691', const = 'CREATURE_691' },
  692 = { id = 692, name = '692', const = 'CREATURE_692' },
  693 = { id = 693, name = '693', const = 'CREATURE_693' },
  694 = { id = 694, name = '694', const = 'CREATURE_694' },
  695 = { id = 695, name = '695', const = 'CREATURE_695' },
  696 = { id = 696, name = '696', const = 'CREATURE_696' },
  697 = { id = 697, name = '697', const = 'CREATURE_697' },
  698 = { id = 698, name = '698', const = 'CREATURE_698' },
  699 = { id = 699, name = '699', const = 'CREATURE_699' },
  700 = { id = 700, name = '700', const = 'CREATURE_700' },
  701 = { id = 701, name = '701', const = 'CREATURE_701' },
  702 = { id = 702, name = '702', const = 'CREATURE_702' },
  703 = { id = 703, name = '703', const = 'CREATURE_703' },
  704 = { id = 704, name = '704', const = 'CREATURE_704' },
  705 = { id = 705, name = '705', const = 'CREATURE_705' },
  706 = { id = 706, name = '706', const = 'CREATURE_706' },
  707 = { id = 707, name = '707', const = 'CREATURE_707' },
  708 = { id = 708, name = '708', const = 'CREATURE_708' },
  709 = { id = 709, name = '709', const = 'CREATURE_709' },
  710 = { id = 710, name = '710', const = 'CREATURE_710' },
  711 = { id = 711, name = '711', const = 'CREATURE_711' },
  712 = { id = 712, name = '712', const = 'CREATURE_712' },
  713 = { id = 713, name = '713', const = 'CREATURE_713' },
  714 = { id = 714, name = '714', const = 'CREATURE_714' },
  715 = { id = 715, name = '715', const = 'CREATURE_715' },
  716 = { id = 716, name = '716', const = 'CREATURE_716' },
  717 = { id = 717, name = '717', const = 'CREATURE_717' },
  718 = { id = 718, name = '718', const = 'CREATURE_718' },
  719 = { id = 719, name = '719', const = 'CREATURE_719' },
  720 = { id = 720, name = '720', const = 'CREATURE_720' },
  721 = { id = 721, name = '721', const = 'CREATURE_721' },
  722 = { id = 722, name = '722', const = 'CREATURE_722' },
  723 = { id = 723, name = '723', const = 'CREATURE_723' },
  724 = { id = 724, name = '724', const = 'CREATURE_724' },
  725 = { id = 725, name = '725', const = 'CREATURE_725' },
  726 = { id = 726, name = '726', const = 'CREATURE_726' },
  727 = { id = 727, name = '727', const = 'CREATURE_727' },
  728 = { id = 728, name = '728', const = 'CREATURE_728' },
  729 = { id = 729, name = '729', const = 'CREATURE_729' },
  730 = { id = 730, name = '730', const = 'CREATURE_730' },
  731 = { id = 731, name = '731', const = 'CREATURE_731' },
  732 = { id = 732, name = '732', const = 'CREATURE_732' },
  733 = { id = 733, name = '733', const = 'CREATURE_733' },
  734 = { id = 734, name = '734', const = 'CREATURE_734' },
  735 = { id = 735, name = '735', const = 'CREATURE_735' },
  736 = { id = 736, name = '736', const = 'CREATURE_736' },
  737 = { id = 737, name = '737', const = 'CREATURE_737' },
  738 = { id = 738, name = '738', const = 'CREATURE_738' },
  739 = { id = 739, name = '739', const = 'CREATURE_739' },
  740 = { id = 740, name = '740', const = 'CREATURE_740' },
  741 = { id = 741, name = '741', const = 'CREATURE_741' },
  742 = { id = 742, name = '742', const = 'CREATURE_742' },
  743 = { id = 743, name = '743', const = 'CREATURE_743' },
  744 = { id = 744, name = '744', const = 'CREATURE_744' },
  745 = { id = 745, name = '745', const = 'CREATURE_745' },
  746 = { id = 746, name = '746', const = 'CREATURE_746' },
  747 = { id = 747, name = '747', const = 'CREATURE_747' },
  748 = { id = 748, name = '748', const = 'CREATURE_748' },
  749 = { id = 749, name = '749', const = 'CREATURE_749' },
  750 = { id = 750, name = '750', const = 'CREATURE_750' },
  751 = { id = 751, name = '751', const = 'CREATURE_751' },
  752 = { id = 752, name = '752', const = 'CREATURE_752' },
  753 = { id = 753, name = '753', const = 'CREATURE_753' },
  754 = { id = 754, name = '754', const = 'CREATURE_754' },
  755 = { id = 755, name = '755', const = 'CREATURE_755' },
  756 = { id = 756, name = '756', const = 'CREATURE_756' },
  757 = { id = 757, name = '757', const = 'CREATURE_757' },
  758 = { id = 758, name = '758', const = 'CREATURE_758' },
  759 = { id = 759, name = '759', const = 'CREATURE_759' },
  760 = { id = 760, name = '760', const = 'CREATURE_760' },
  761 = { id = 761, name = '761', const = 'CREATURE_761' },
  762 = { id = 762, name = '762', const = 'CREATURE_762' },
  763 = { id = 763, name = '763', const = 'CREATURE_763' },
  764 = { id = 764, name = '764', const = 'CREATURE_764' },
  765 = { id = 765, name = '765', const = 'CREATURE_765' },
  766 = { id = 766, name = '766', const = 'CREATURE_766' },
  767 = { id = 767, name = '767', const = 'CREATURE_767' },
  768 = { id = 768, name = '768', const = 'CREATURE_768' },
  769 = { id = 769, name = '769', const = 'CREATURE_769' },
  770 = { id = 770, name = '770', const = 'CREATURE_770' },
  771 = { id = 771, name = '771', const = 'CREATURE_771' },
  772 = { id = 772, name = '772', const = 'CREATURE_772' },
  773 = { id = 773, name = '773', const = 'CREATURE_773' },
  774 = { id = 774, name = '774', const = 'CREATURE_774' },
  775 = { id = 775, name = '775', const = 'CREATURE_775' },
  776 = { id = 776, name = '776', const = 'CREATURE_776' },
  777 = { id = 777, name = '777', const = 'CREATURE_777' },
  778 = { id = 778, name = '778', const = 'CREATURE_778' },
  779 = { id = 779, name = '779', const = 'CREATURE_779' },
  780 = { id = 780, name = '780', const = 'CREATURE_780' },
  781 = { id = 781, name = '781', const = 'CREATURE_781' },
  782 = { id = 782, name = '782', const = 'CREATURE_782' },
  783 = { id = 783, name = '783', const = 'CREATURE_783' },
  784 = { id = 784, name = '784', const = 'CREATURE_784' },
  785 = { id = 785, name = '785', const = 'CREATURE_785' },
  786 = { id = 786, name = '786', const = 'CREATURE_786' },
  787 = { id = 787, name = '787', const = 'CREATURE_787' },
  788 = { id = 788, name = '788', const = 'CREATURE_788' },
  789 = { id = 789, name = '789', const = 'CREATURE_789' },
  790 = { id = 790, name = '790', const = 'CREATURE_790' },
  791 = { id = 791, name = '791', const = 'CREATURE_791' },
  792 = { id = 792, name = '792', const = 'CREATURE_792' },
  793 = { id = 793, name = '793', const = 'CREATURE_793' },
  794 = { id = 794, name = '794', const = 'CREATURE_794' },
  795 = { id = 795, name = '795', const = 'CREATURE_795' },
  796 = { id = 796, name = '796', const = 'CREATURE_796' },
  797 = { id = 797, name = '797', const = 'CREATURE_797' },
  798 = { id = 798, name = '798', const = 'CREATURE_798' },
  799 = { id = 799, name = '799', const = 'CREATURE_799' },
  800 = { id = 800, name = '800', const = 'CREATURE_800' },
  801 = { id = 801, name = '801', const = 'CREATURE_801' },
  802 = { id = 802, name = '802', const = 'CREATURE_802' },
  803 = { id = 803, name = '803', const = 'CREATURE_803' },
  804 = { id = 804, name = '804', const = 'CREATURE_804' },
  805 = { id = 805, name = '805', const = 'CREATURE_805' },
  806 = { id = 806, name = '806', const = 'CREATURE_806' },
  807 = { id = 807, name = '807', const = 'CREATURE_807' },
  808 = { id = 808, name = '808', const = 'CREATURE_808' },
  809 = { id = 809, name = '809', const = 'CREATURE_809' },
  810 = { id = 810, name = '810', const = 'CREATURE_810' },
  811 = { id = 811, name = '811', const = 'CREATURE_811' },
  812 = { id = 812, name = '812', const = 'CREATURE_812' },
  813 = { id = 813, name = '813', const = 'CREATURE_813' },
  814 = { id = 814, name = '814', const = 'CREATURE_814' },
  815 = { id = 815, name = '815', const = 'CREATURE_815' },
  816 = { id = 816, name = '816', const = 'CREATURE_816' },
  817 = { id = 817, name = '817', const = 'CREATURE_817' },
  818 = { id = 818, name = '818', const = 'CREATURE_818' },
  819 = { id = 819, name = '819', const = 'CREATURE_819' },
  820 = { id = 820, name = '820', const = 'CREATURE_820' },
  821 = { id = 821, name = '821', const = 'CREATURE_821' },
  822 = { id = 822, name = '822', const = 'CREATURE_822' },
  823 = { id = 823, name = '823', const = 'CREATURE_823' },
  824 = { id = 824, name = '824', const = 'CREATURE_824' },
  825 = { id = 825, name = '825', const = 'CREATURE_825' },
  826 = { id = 826, name = '826', const = 'CREATURE_826' },
  827 = { id = 827, name = '827', const = 'CREATURE_827' },
  828 = { id = 828, name = '828', const = 'CREATURE_828' },
  829 = { id = 829, name = '829', const = 'CREATURE_829' },
  830 = { id = 830, name = '830', const = 'CREATURE_830' },
  831 = { id = 831, name = '831', const = 'CREATURE_831' },
  832 = { id = 832, name = '832', const = 'CREATURE_832' },
  833 = { id = 833, name = '833', const = 'CREATURE_833' },
  834 = { id = 834, name = '834', const = 'CREATURE_834' },
  835 = { id = 835, name = '835', const = 'CREATURE_835' },
  836 = { id = 836, name = '836', const = 'CREATURE_836' },
  837 = { id = 837, name = '837', const = 'CREATURE_837' },
  838 = { id = 838, name = '838', const = 'CREATURE_838' },
  839 = { id = 839, name = '839', const = 'CREATURE_839' },
  840 = { id = 840, name = '840', const = 'CREATURE_840' },
  841 = { id = 841, name = '841', const = 'CREATURE_841' },
  842 = { id = 842, name = '842', const = 'CREATURE_842' },
  843 = { id = 843, name = '843', const = 'CREATURE_843' },
  844 = { id = 844, name = '844', const = 'CREATURE_844' },
  845 = { id = 845, name = '845', const = 'CREATURE_845' },
  846 = { id = 846, name = '846', const = 'CREATURE_846' },
  847 = { id = 847, name = '847', const = 'CREATURE_847' },
  848 = { id = 848, name = '848', const = 'CREATURE_848' },
  849 = { id = 849, name = '849', const = 'CREATURE_849' },
  850 = { id = 850, name = '850', const = 'CREATURE_850' },
  851 = { id = 851, name = '851', const = 'CREATURE_851' },
  852 = { id = 852, name = '852', const = 'CREATURE_852' },
  853 = { id = 853, name = '853', const = 'CREATURE_853' },
  854 = { id = 854, name = '854', const = 'CREATURE_854' },
  855 = { id = 855, name = '855', const = 'CREATURE_855' },
  856 = { id = 856, name = '856', const = 'CREATURE_856' },
  857 = { id = 857, name = '857', const = 'CREATURE_857' },
  858 = { id = 858, name = '858', const = 'CREATURE_858' },
  859 = { id = 859, name = '859', const = 'CREATURE_859' },
  860 = { id = 860, name = '860', const = 'CREATURE_860' },
  861 = { id = 861, name = '861', const = 'CREATURE_861' },
  862 = { id = 862, name = '862', const = 'CREATURE_862' },
  863 = { id = 863, name = '863', const = 'CREATURE_863' },
  864 = { id = 864, name = '864', const = 'CREATURE_864' },
  865 = { id = 865, name = '865', const = 'CREATURE_865' },
  866 = { id = 866, name = '866', const = 'CREATURE_866' },
  867 = { id = 867, name = '867', const = 'CREATURE_867' },
  868 = { id = 868, name = '868', const = 'CREATURE_868' },
  869 = { id = 869, name = '869', const = 'CREATURE_869' },
  870 = { id = 870, name = '870', const = 'CREATURE_870' },
  871 = { id = 871, name = '871', const = 'CREATURE_871' },
  872 = { id = 872, name = '872', const = 'CREATURE_872' },
  873 = { id = 873, name = '873', const = 'CREATURE_873' },
  874 = { id = 874, name = '874', const = 'CREATURE_874' },
  875 = { id = 875, name = '875', const = 'CREATURE_875' },
  876 = { id = 876, name = '876', const = 'CREATURE_876' },
  877 = { id = 877, name = '877', const = 'CREATURE_877' },
  878 = { id = 878, name = '878', const = 'CREATURE_878' },
  879 = { id = 879, name = '879', const = 'CREATURE_879' },
  880 = { id = 880, name = '880', const = 'CREATURE_880' },
  881 = { id = 881, name = '881', const = 'CREATURE_881' },
  882 = { id = 882, name = '882', const = 'CREATURE_882' },
  883 = { id = 883, name = '883', const = 'CREATURE_883' },
  884 = { id = 884, name = '884', const = 'CREATURE_884' },
  885 = { id = 885, name = '885', const = 'CREATURE_885' },
  886 = { id = 886, name = '886', const = 'CREATURE_886' },
  887 = { id = 887, name = '887', const = 'CREATURE_887' },
  888 = { id = 888, name = '888', const = 'CREATURE_888' },
  889 = { id = 889, name = '889', const = 'CREATURE_889' },
  890 = { id = 890, name = '890', const = 'CREATURE_890' },
  891 = { id = 891, name = '891', const = 'CREATURE_891' },
  892 = { id = 892, name = '892', const = 'CREATURE_892' },
  893 = { id = 893, name = '893', const = 'CREATURE_893' },
  894 = { id = 894, name = '894', const = 'CREATURE_894' },
  895 = { id = 895, name = '895', const = 'CREATURE_895' },
  896 = { id = 896, name = '896', const = 'CREATURE_896' },
  897 = { id = 897, name = '897', const = 'CREATURE_897' },
  898 = { id = 898, name = '898', const = 'CREATURE_898' },
  899 = { id = 899, name = '899', const = 'CREATURE_899' },
  900 = { id = 900, name = '900', const = 'CREATURE_900' },
  901 = { id = 901, name = '901', const = 'CREATURE_901' },
  902 = { id = 902, name = '902', const = 'CREATURE_902' },
  903 = { id = 903, name = '903', const = 'CREATURE_903' },
  904 = { id = 904, name = '904', const = 'CREATURE_904' },
  905 = { id = 905, name = '905', const = 'CREATURE_905' },
  906 = { id = 906, name = '906', const = 'CREATURE_906' },
  907 = { id = 907, name = '907', const = 'CREATURE_907' },
  908 = { id = 908, name = '908', const = 'CREATURE_908' },
  909 = { id = 909, name = '909', const = 'CREATURE_909' },
  910 = { id = 910, name = '910', const = 'CREATURE_910' },
  911 = { id = 911, name = '911', const = 'CREATURE_911' },
  912 = { id = 912, name = '912', const = 'CREATURE_912' },
  913 = { id = 913, name = '913', const = 'CREATURE_913' },
  914 = { id = 914, name = '914', const = 'CREATURE_914' },
  915 = { id = 915, name = '915', const = 'CREATURE_915' },
  916 = { id = 916, name = '916', const = 'CREATURE_916' },
  917 = { id = 917, name = '917', const = 'CREATURE_917' },
  918 = { id = 918, name = '918', const = 'CREATURE_918' },
  919 = { id = 919, name = '919', const = 'CREATURE_919' },
  920 = { id = 920, name = '920', const = 'CREATURE_920' },
  921 = { id = 921, name = '921', const = 'CREATURE_921' },
  922 = { id = 922, name = '922', const = 'CREATURE_922' },
  923 = { id = 923, name = '923', const = 'CREATURE_923' },
  924 = { id = 924, name = '924', const = 'CREATURE_924' },
  925 = { id = 925, name = '925', const = 'CREATURE_925' },
  926 = { id = 926, name = '926', const = 'CREATURE_926' },
  927 = { id = 927, name = '927', const = 'CREATURE_927' },
  928 = { id = 928, name = '928', const = 'CREATURE_928' },
  929 = { id = 929, name = '929', const = 'CREATURE_929' },
  930 = { id = 930, name = '930', const = 'CREATURE_930' },
  931 = { id = 931, name = '931', const = 'CREATURE_931' },
  932 = { id = 932, name = '932', const = 'CREATURE_932' },
  933 = { id = 933, name = '933', const = 'CREATURE_933' },
  934 = { id = 934, name = '934', const = 'CREATURE_934' },
  935 = { id = 935, name = '935', const = 'CREATURE_935' },
  936 = { id = 936, name = '936', const = 'CREATURE_936' },
  937 = { id = 937, name = '937', const = 'CREATURE_937' },
  938 = { id = 938, name = '938', const = 'CREATURE_938' },
  939 = { id = 939, name = '939', const = 'CREATURE_939' },
  940 = { id = 940, name = '940', const = 'CREATURE_940' },
  941 = { id = 941, name = '941', const = 'CREATURE_941' },
  942 = { id = 942, name = '942', const = 'CREATURE_942' },
  943 = { id = 943, name = '943', const = 'CREATURE_943' },
  944 = { id = 944, name = '944', const = 'CREATURE_944' },
  945 = { id = 945, name = '945', const = 'CREATURE_945' },
  946 = { id = 946, name = '946', const = 'CREATURE_946' },
  947 = { id = 947, name = '947', const = 'CREATURE_947' },
  948 = { id = 948, name = '948', const = 'CREATURE_948' },
  949 = { id = 949, name = '949', const = 'CREATURE_949' },
  950 = { id = 950, name = '950', const = 'CREATURE_950' },
  951 = { id = 951, name = '951', const = 'CREATURE_951' },
  952 = { id = 952, name = '952', const = 'CREATURE_952' },
  953 = { id = 953, name = '953', const = 'CREATURE_953' },
  954 = { id = 954, name = '954', const = 'CREATURE_954' },
  955 = { id = 955, name = '955', const = 'CREATURE_955' },
  956 = { id = 956, name = '956', const = 'CREATURE_956' },
  957 = { id = 957, name = '957', const = 'CREATURE_957' },
  958 = { id = 958, name = '958', const = 'CREATURE_958' },
  959 = { id = 959, name = '959', const = 'CREATURE_959' },
  960 = { id = 960, name = '960', const = 'CREATURE_960' },
  961 = { id = 961, name = '961', const = 'CREATURE_961' },
  962 = { id = 962, name = '962', const = 'CREATURE_962' },
  963 = { id = 963, name = '963', const = 'CREATURE_963' },
  964 = { id = 964, name = '964', const = 'CREATURE_964' },
  965 = { id = 965, name = '965', const = 'CREATURE_965' },
  966 = { id = 966, name = '966', const = 'CREATURE_966' },
  967 = { id = 967, name = '967', const = 'CREATURE_967' },
  968 = { id = 968, name = '968', const = 'CREATURE_968' },
  969 = { id = 969, name = '969', const = 'CREATURE_969' },
  970 = { id = 970, name = '970', const = 'CREATURE_970' },
  971 = { id = 971, name = '971', const = 'CREATURE_971' },
  972 = { id = 972, name = '972', const = 'CREATURE_972' },
  973 = { id = 973, name = '973', const = 'CREATURE_973' },
  974 = { id = 974, name = '974', const = 'CREATURE_974' },
  975 = { id = 975, name = '975', const = 'CREATURE_975' },
  976 = { id = 976, name = '976', const = 'CREATURE_976' },
  977 = { id = 977, name = '977', const = 'CREATURE_977' },
  978 = { id = 978, name = '978', const = 'CREATURE_978' },
  979 = { id = 979, name = '979', const = 'CREATURE_979' },
  980 = { id = 980, name = '980', const = 'CREATURE_980' },
  981 = { id = 981, name = '981', const = 'CREATURE_981' },
  982 = { id = 982, name = '982', const = 'CREATURE_982' },
  983 = { id = 983, name = '983', const = 'CREATURE_983' },
  984 = { id = 984, name = '984', const = 'CREATURE_984' },
  985 = { id = 985, name = '985', const = 'CREATURE_985' },
  986 = { id = 986, name = '986', const = 'CREATURE_986' },
  987 = { id = 987, name = '987', const = 'CREATURE_987' },
  988 = { id = 988, name = '988', const = 'CREATURE_988' },
  989 = { id = 989, name = '989', const = 'CREATURE_989' },
  990 = { id = 990, name = '990', const = 'CREATURE_990' },
  991 = { id = 991, name = '991', const = 'CREATURE_991' },
  992 = { id = 992, name = '992', const = 'CREATURE_992' },
  993 = { id = 993, name = '993', const = 'CREATURE_993' },
  994 = { id = 994, name = '994', const = 'CREATURE_994' },
  995 = { id = 995, name = '995', const = 'CREATURE_995' },
  996 = { id = 996, name = '996', const = 'CREATURE_996' },
  997 = { id = 997, name = '997', const = 'CREATURE_997' },
  998 = { id = 998, name = '998', const = 'CREATURE_998' },
  999 = { id = 999, name = '999', const = 'CREATURE_999' },
}

H55_HERO_BY_TAIL = {
  ABSOLUTE_CHAINS = { 150 },
  ABSOLUTE_CHARGE = { 85 },
  ABSOLUTE_FEAR = { 111 },
  ABSOLUTE_GATING = { 98 },
  ABSOLUTE_LUCK = { 124 },
  ABSOLUTE_PROTECTION = { 167 },
  ABSOLUTE_RAGE = { 176 },
  ABSOLUTE_WIZARDY = { 137 },
  ACADEMY_AWARD = { 127 },
  ANCIENT_SMITHY = { 82 },
  ARCANE_TRAINING = { 42 },
  ARCHERY = { 35 },
  ARTIFICIAL_GLORY = { 128 },
  ARTIFICIER = { 17 },
  AVENGER = { 16 },
  BALLISTA = { 23 },
  BARBARIAN_ANCIENT_SMITHY = { 208 },
  BARBARIAN_DARK_REVELATION = { 219 },
  BARBARIAN_DISTRACT = { 218 },
  BARBARIAN_ELITE_CASTERS = { 214 },
  BARBARIAN_FIRE_PROTECTION = { 216 },
  BARBARIAN_FOG_VEIL = { 211 },
  BARBARIAN_INTELLIGENCE = { 212 },
  BARBARIAN_LEARNING = { 183 },
  BARBARIAN_MENTORING = { 220 },
  BARBARIAN_MYSTICISM = { 213 },
  BARBARIAN_SOIL_BURN = { 210 },
  BARBARIAN_STORM_WIND = { 215 },
  BARBARIAN_SUN_FIRE = { 217 },
  BARBARIAN_WEAKENING_STRIKE = { 209 },
  BATTLE_ELATION = { 178 },
  BODYBUILDING = { 186 },
  CASTER_CERTIFICATE = { 81 },
  CATAPULT = { 24 },
  CHAOTIC_SPELLS = { 145 },
  CHILLING_BONES = { 105 },
  CHILLING_STEEL = { 104 },
  CONSUME_CORPSE = { 58 },
  CORRUPT_DARK = { 196 },
  CORRUPT_DESTRUCTIVE = { 192 },
  CORRUPT_LIGHT = { 200 },
  CORRUPT_SUMMONING = { 204 },
  COUNTERSPELL = { 132 },
  CRITICAL_GATING = { 90 },
  CRITICAL_STRIKE = { 91 },
  CUNNING_OF_THE_WOODS = { 114 },
  DARK_MAGIC = { 10 },
  DARK_REVELATION = { 140 },
  DARK_RITUAL = { 71 },
  DEADLY_COLD = { 107 },
  DEAD_LUCK = { 103 },
  DEATH_SCREAM = { 63 },
  DEATH_TO_NONEXISTENT = { 207 },
  DEATH_TREAD = { 99 },
  DEFENCE = { 7 },
  DEFEND_US_ALL = { 181 },
  DEFENSIVE_FORMATION = { 161 },
  DEMONIC_FIRE = { 59 },
  DEMONIC_FLAME = { 94 },
  DEMONIC_RAGE = { 172 },
  DEMONIC_RETALIATION = { 92 },
  DEMONIC_STRIKE = { 60 },
  DESTRUCTIVE_MAGIC = { 9 },
  DETAIN_DARK = { 198 },
  DETAIN_DESTRUCTIVE = { 194 },
  DETAIN_LIGHT = { 202 },
  DETAIN_SUMMONING = { 206 },
  DIPLOMACY = { 30 },
  DISGUISE_AND_RECKON = { 112 },
  DISTRACT = { 162 },
  DWARVEN_LUCK = { 159 },
  EAGLE_EYE = { 27 },
  ELEMENTAL_BALANCE = { 84 },
  ELEMENTAL_OVERKILL = { 149 },
  ELEMENTAL_VISION = { 72 },
  ELITE_CASTERS = { 148 },
  ELVEN_LUCK = { 116 },
  EMPATHY = { 170 },
  EMPOWERED_SPELLS = { 70 },
  ENCOURAGE = { 75 },
  ESTATES = { 29 },
  ETERNAL_LIGHT = { 165 },
  EVASION = { 38 },
  EXPERT_TRAINER = { 57 },
  EXPLODING_CORPSES = { 93 },
  FAST_AND_FURIOUS = { 141 },
  FINE_RUNE = { 154 },
  FIRE_AFFINITY = { 97 },
  FIRE_PROTECTION = { 96 },
  FIRST_AID = { 22 },
  FOG_VEIL = { 123 },
  FOREST_GUARD_EMBLEM = { 115 },
  FOREST_RAGE = { 117 },
  FORTUNATE_ADVENTURER = { 33 },
  FRENZY = { 36 },
  GATING = { 14 },
  GATING_MASTERY = { 89 },
  GOBLIN_SUPPORT = { 182 },
  GRAIL_VISION = { 80 },
  GUARDIAN_ANGEL = { 78 },
  HAUNT_MINE = { 110 },
  HERALD_OF_DEATH = { 102 },
  HOLD_GROUND = { 77 },
  HOLY_CHARGE = { 55 },
  IMBUE_ARROW = { 66 },
  IMBUE_BALLISTA = { 113 },
  INSIGHTS = { 119 },
  INTELLIGENCE = { 25 },
  INVOCATION = { 18 },
  LAST_AID = { 100 },
  LAST_STAND = { 118 },
  LEADERSHIP = { 4 },
  LEARNING = { 3 },
  LIGHT_MAGIC = { 11 },
  LOGISTICS = { 1 },
  LORD_OF_UNDEAD = { 101 },
  LUCK = { 5 },
  LUCKY_SPELLS = { 142 },
  LUCKY_STRIKE = { 32 },
  LUCK_OF_THE_BARBARIAN = { 179 },
  MAGIC_BOND = { 67 },
  MAGIC_CUSHION = { 133 },
  MAGIC_MIRROR = { 69 },
  MARCH_OF_THE_MACHINES = { 125 },
  MASTER_OF_ABJURATION = { 50 },
  MASTER_OF_ANIMATION = { 54 },
  MASTER_OF_BLESSING = { 49 },
  MASTER_OF_CREATURES = { 53 },
  MASTER_OF_CURSES = { 46 },
  MASTER_OF_FIRE = { 44 },
  MASTER_OF_ICE = { 43 },
  MASTER_OF_LIGHTNINGS = { 45 },
  MASTER_OF_MIND = { 47 },
  MASTER_OF_QUAKES = { 52 },
  MASTER_OF_SECRETS = { 87 },
  MASTER_OF_SICKNESS = { 48 },
  MASTER_OF_WRATH = { 51 },
  MELT_ARTIFACT = { 68 },
  MEMORY_OF_OUR_BLOOD = { 174 },
  MENTORING = { 169 },
  MIGHTY_VOICE = { 189 },
  MIGHT_OVER_MAGIC = { 173 },
  MULTISHOT = { 64 },
  MYSTICISM = { 40 },
  NAVIGATION = { 21 },
  NECROMANCY = { 15 },
  NONE = { 0 },
  NO_REST_FOR_THE_WICKED = { 62 },
  OFFENCE = { 6 },
  OFFENSIVE_FORMATION = { 160 },
  PARIAH = { 83 },
  PATHFINDING = { 19 },
  PATH_OF_WAR = { 177 },
  PAYBACK = { 147 },
  POWERFULL_BLOW = { 175 },
  POWER_OF_BLOOD = { 184 },
  POWER_OF_HASTE = { 143 },
  POWER_OF_STONE = { 144 },
  PRAYER = { 56 },
  PREPARATION = { 171 },
  PROTECTION = { 37 },
  QUICKNESS_OF_MIND = { 155 },
  QUICK_GATING = { 86 },
  RAISE_ARCHERS = { 61 },
  RECRUITMENT = { 28 },
  REFRESH_RUNE = { 152 },
  REMOTE_CONTROL = { 126 },
  RESISTANCE = { 31 },
  RETRIBUTION = { 76 },
  ROAD_HOME = { 73 },
  RUNELORE = { 151 },
  RUNIC_ARMOR = { 166 },
  RUNIC_ATTUNEMENT = { 158 },
  RUNIC_MACHINES = { 156 },
  SCHOLAR = { 26 },
  SCOUTING = { 20 },
  SEAL_OF_PROTECTION = { 131 },
  SECRETS_OF_DESTRUCTION = { 146 },
  SET_AFIRE = { 163 },
  SHAKE_GROUND = { 139 },
  SHATTER_DARK_MAGIC = { 195 },
  SHATTER_DESTRUCTIVE_MAGIC = { 191 },
  SHATTER_LIGHT_MAGIC = { 199 },
  SHATTER_SUMMONING_MAGIC = { 203 },
  SHRUG_DARKNESS = { 164 },
  SNATCH = { 168 },
  SNIPE_DEAD = { 65 },
  SOIL_BURN = { 121 },
  SORCERY = { 8 },
  SPELLPROOF_BONES = { 106 },
  SPIRIT_LINK = { 108 },
  SPOILS_OF_WAR = { 129 },
  STORM_WIND = { 122 },
  STRONG_RUNE = { 153 },
  STUDENT_AWARD = { 79 },
  STUNNING_BLOW = { 180 },
  SUMMONING_MAGIC = { 12 },
  SUN_FIRE = { 120 },
  SUPRESS_DARK = { 134 },
  SUPRESS_LIGHT = { 135 },
  TACTICS = { 34 },
  TAP_RUNES = { 157 },
  TELEPORT_ASSAULT = { 138 },
  TOUGHNESS = { 39 },
  TRAINING = { 13 },
  TRIPLE_BALLISTA = { 74 },
  TRIPLE_CATAPULT = { 88 },
  TWILIGHT = { 109 },
  UNSUMMON = { 136 },
  VOICE = { 187 },
  VOICE_OF_RAGE = { 190 },
  VOICE_TRAINING = { 188 },
  WARCRY_LEARNING = { 185 },
  WAR_MACHINES = { 2 },
  WEAKENING_STRIKE = { 95 },
  WEAKEN_DARK = { 197 },
  WEAKEN_DESTRUCTIVE = { 193 },
  WEAKEN_LIGHT = { 201 },
  WEAKEN_SUMMONING = { 205 },
  WILDFIRE = { 130 },
  WISDOM = { 41 },
}

H55_HERO_BY_CONST = {
  HERO_SKILL_ABSOLUTE_CHAINS = 150,
  HERO_SKILL_ABSOLUTE_CHARGE = 85,
  HERO_SKILL_ABSOLUTE_FEAR = 111,
  HERO_SKILL_ABSOLUTE_GATING = 98,
  HERO_SKILL_ABSOLUTE_LUCK = 124,
  HERO_SKILL_ABSOLUTE_PROTECTION = 167,
  HERO_SKILL_ABSOLUTE_RAGE = 176,
  HERO_SKILL_ABSOLUTE_WIZARDY = 137,
  HERO_SKILL_ACADEMY_AWARD = 127,
  HERO_SKILL_ANCIENT_SMITHY = 82,
  HERO_SKILL_ARCANE_TRAINING = 42,
  HERO_SKILL_ARCHERY = 35,
  HERO_SKILL_ARTIFICIAL_GLORY = 128,
  HERO_SKILL_ARTIFICIER = 17,
  HERO_SKILL_AVENGER = 16,
  HERO_SKILL_BALLISTA = 23,
  HERO_SKILL_BARBARIAN_ANCIENT_SMITHY = 208,
  HERO_SKILL_BARBARIAN_DARK_REVELATION = 219,
  HERO_SKILL_BARBARIAN_DISTRACT = 218,
  HERO_SKILL_BARBARIAN_ELITE_CASTERS = 214,
  HERO_SKILL_BARBARIAN_FIRE_PROTECTION = 216,
  HERO_SKILL_BARBARIAN_FOG_VEIL = 211,
  HERO_SKILL_BARBARIAN_INTELLIGENCE = 212,
  HERO_SKILL_BARBARIAN_LEARNING = 183,
  HERO_SKILL_BARBARIAN_MENTORING = 220,
  HERO_SKILL_BARBARIAN_MYSTICISM = 213,
  HERO_SKILL_BARBARIAN_SOIL_BURN = 210,
  HERO_SKILL_BARBARIAN_STORM_WIND = 215,
  HERO_SKILL_BARBARIAN_SUN_FIRE = 217,
  HERO_SKILL_BARBARIAN_WEAKENING_STRIKE = 209,
  HERO_SKILL_BATTLE_ELATION = 178,
  HERO_SKILL_BODYBUILDING = 186,
  HERO_SKILL_CASTER_CERTIFICATE = 81,
  HERO_SKILL_CATAPULT = 24,
  HERO_SKILL_CHAOTIC_SPELLS = 145,
  HERO_SKILL_CHILLING_BONES = 105,
  HERO_SKILL_CHILLING_STEEL = 104,
  HERO_SKILL_CONSUME_CORPSE = 58,
  HERO_SKILL_CORRUPT_DARK = 196,
  HERO_SKILL_CORRUPT_DESTRUCTIVE = 192,
  HERO_SKILL_CORRUPT_LIGHT = 200,
  HERO_SKILL_CORRUPT_SUMMONING = 204,
  HERO_SKILL_COUNTERSPELL = 132,
  HERO_SKILL_CRITICAL_GATING = 90,
  HERO_SKILL_CRITICAL_STRIKE = 91,
  HERO_SKILL_CUNNING_OF_THE_WOODS = 114,
  HERO_SKILL_DARK_MAGIC = 10,
  HERO_SKILL_DARK_REVELATION = 140,
  HERO_SKILL_DARK_RITUAL = 71,
  HERO_SKILL_DEADLY_COLD = 107,
  HERO_SKILL_DEAD_LUCK = 103,
  HERO_SKILL_DEATH_SCREAM = 63,
  HERO_SKILL_DEATH_TO_NONEXISTENT = 207,
  HERO_SKILL_DEATH_TREAD = 99,
  HERO_SKILL_DEFENCE = 7,
  HERO_SKILL_DEFEND_US_ALL = 181,
  HERO_SKILL_DEFENSIVE_FORMATION = 161,
  HERO_SKILL_DEMONIC_FIRE = 59,
  HERO_SKILL_DEMONIC_FLAME = 94,
  HERO_SKILL_DEMONIC_RAGE = 172,
  HERO_SKILL_DEMONIC_RETALIATION = 92,
  HERO_SKILL_DEMONIC_STRIKE = 60,
  HERO_SKILL_DESTRUCTIVE_MAGIC = 9,
  HERO_SKILL_DETAIN_DARK = 198,
  HERO_SKILL_DETAIN_DESTRUCTIVE = 194,
  HERO_SKILL_DETAIN_LIGHT = 202,
  HERO_SKILL_DETAIN_SUMMONING = 206,
  HERO_SKILL_DIPLOMACY = 30,
  HERO_SKILL_DISGUISE_AND_RECKON = 112,
  HERO_SKILL_DISTRACT = 162,
  HERO_SKILL_DWARVEN_LUCK = 159,
  HERO_SKILL_EAGLE_EYE = 27,
  HERO_SKILL_ELEMENTAL_BALANCE = 84,
  HERO_SKILL_ELEMENTAL_OVERKILL = 149,
  HERO_SKILL_ELEMENTAL_VISION = 72,
  HERO_SKILL_ELITE_CASTERS = 148,
  HERO_SKILL_ELVEN_LUCK = 116,
  HERO_SKILL_EMPATHY = 170,
  HERO_SKILL_EMPOWERED_SPELLS = 70,
  HERO_SKILL_ENCOURAGE = 75,
  HERO_SKILL_ESTATES = 29,
  HERO_SKILL_ETERNAL_LIGHT = 165,
  HERO_SKILL_EVASION = 38,
  HERO_SKILL_EXPERT_TRAINER = 57,
  HERO_SKILL_EXPLODING_CORPSES = 93,
  HERO_SKILL_FAST_AND_FURIOUS = 141,
  HERO_SKILL_FINE_RUNE = 154,
  HERO_SKILL_FIRE_AFFINITY = 97,
  HERO_SKILL_FIRE_PROTECTION = 96,
  HERO_SKILL_FIRST_AID = 22,
  HERO_SKILL_FOG_VEIL = 123,
  HERO_SKILL_FOREST_GUARD_EMBLEM = 115,
  HERO_SKILL_FOREST_RAGE = 117,
  HERO_SKILL_FORTUNATE_ADVENTURER = 33,
  HERO_SKILL_FRENZY = 36,
  HERO_SKILL_GATING = 14,
  HERO_SKILL_GATING_MASTERY = 89,
  HERO_SKILL_GOBLIN_SUPPORT = 182,
  HERO_SKILL_GRAIL_VISION = 80,
  HERO_SKILL_GUARDIAN_ANGEL = 78,
  HERO_SKILL_HAUNT_MINE = 110,
  HERO_SKILL_HERALD_OF_DEATH = 102,
  HERO_SKILL_HOLD_GROUND = 77,
  HERO_SKILL_HOLY_CHARGE = 55,
  HERO_SKILL_IMBUE_ARROW = 66,
  HERO_SKILL_IMBUE_BALLISTA = 113,
  HERO_SKILL_INSIGHTS = 119,
  HERO_SKILL_INTELLIGENCE = 25,
  HERO_SKILL_INVOCATION = 18,
  HERO_SKILL_LAST_AID = 100,
  HERO_SKILL_LAST_STAND = 118,
  HERO_SKILL_LEADERSHIP = 4,
  HERO_SKILL_LEARNING = 3,
  HERO_SKILL_LIGHT_MAGIC = 11,
  HERO_SKILL_LOGISTICS = 1,
  HERO_SKILL_LORD_OF_UNDEAD = 101,
  HERO_SKILL_LUCK = 5,
  HERO_SKILL_LUCKY_SPELLS = 142,
  HERO_SKILL_LUCKY_STRIKE = 32,
  HERO_SKILL_LUCK_OF_THE_BARBARIAN = 179,
  HERO_SKILL_MAGIC_BOND = 67,
  HERO_SKILL_MAGIC_CUSHION = 133,
  HERO_SKILL_MAGIC_MIRROR = 69,
  HERO_SKILL_MARCH_OF_THE_MACHINES = 125,
  HERO_SKILL_MASTER_OF_ABJURATION = 50,
  HERO_SKILL_MASTER_OF_ANIMATION = 54,
  HERO_SKILL_MASTER_OF_BLESSING = 49,
  HERO_SKILL_MASTER_OF_CREATURES = 53,
  HERO_SKILL_MASTER_OF_CURSES = 46,
  HERO_SKILL_MASTER_OF_FIRE = 44,
  HERO_SKILL_MASTER_OF_ICE = 43,
  HERO_SKILL_MASTER_OF_LIGHTNINGS = 45,
  HERO_SKILL_MASTER_OF_MIND = 47,
  HERO_SKILL_MASTER_OF_QUAKES = 52,
  HERO_SKILL_MASTER_OF_SECRETS = 87,
  HERO_SKILL_MASTER_OF_SICKNESS = 48,
  HERO_SKILL_MASTER_OF_WRATH = 51,
  HERO_SKILL_MELT_ARTIFACT = 68,
  HERO_SKILL_MEMORY_OF_OUR_BLOOD = 174,
  HERO_SKILL_MENTORING = 169,
  HERO_SKILL_MIGHTY_VOICE = 189,
  HERO_SKILL_MIGHT_OVER_MAGIC = 173,
  HERO_SKILL_MULTISHOT = 64,
  HERO_SKILL_MYSTICISM = 40,
  HERO_SKILL_NAVIGATION = 21,
  HERO_SKILL_NECROMANCY = 15,
  HERO_SKILL_NONE = 0,
  HERO_SKILL_NO_REST_FOR_THE_WICKED = 62,
  HERO_SKILL_OFFENCE = 6,
  HERO_SKILL_OFFENSIVE_FORMATION = 160,
  HERO_SKILL_PARIAH = 83,
  HERO_SKILL_PATHFINDING = 19,
  HERO_SKILL_PATH_OF_WAR = 177,
  HERO_SKILL_PAYBACK = 147,
  HERO_SKILL_POWERFULL_BLOW = 175,
  HERO_SKILL_POWER_OF_BLOOD = 184,
  HERO_SKILL_POWER_OF_HASTE = 143,
  HERO_SKILL_POWER_OF_STONE = 144,
  HERO_SKILL_PRAYER = 56,
  HERO_SKILL_PREPARATION = 171,
  HERO_SKILL_PROTECTION = 37,
  HERO_SKILL_QUICKNESS_OF_MIND = 155,
  HERO_SKILL_QUICK_GATING = 86,
  HERO_SKILL_RAISE_ARCHERS = 61,
  HERO_SKILL_RECRUITMENT = 28,
  HERO_SKILL_REFRESH_RUNE = 152,
  HERO_SKILL_REMOTE_CONTROL = 126,
  HERO_SKILL_RESISTANCE = 31,
  HERO_SKILL_RETRIBUTION = 76,
  HERO_SKILL_ROAD_HOME = 73,
  HERO_SKILL_RUNELORE = 151,
  HERO_SKILL_RUNIC_ARMOR = 166,
  HERO_SKILL_RUNIC_ATTUNEMENT = 158,
  HERO_SKILL_RUNIC_MACHINES = 156,
  HERO_SKILL_SCHOLAR = 26,
  HERO_SKILL_SCOUTING = 20,
  HERO_SKILL_SEAL_OF_PROTECTION = 131,
  HERO_SKILL_SECRETS_OF_DESTRUCTION = 146,
  HERO_SKILL_SET_AFIRE = 163,
  HERO_SKILL_SHAKE_GROUND = 139,
  HERO_SKILL_SHATTER_DARK_MAGIC = 195,
  HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC = 191,
  HERO_SKILL_SHATTER_LIGHT_MAGIC = 199,
  HERO_SKILL_SHATTER_SUMMONING_MAGIC = 203,
  HERO_SKILL_SHRUG_DARKNESS = 164,
  HERO_SKILL_SNATCH = 168,
  HERO_SKILL_SNIPE_DEAD = 65,
  HERO_SKILL_SOIL_BURN = 121,
  HERO_SKILL_SORCERY = 8,
  HERO_SKILL_SPELLPROOF_BONES = 106,
  HERO_SKILL_SPIRIT_LINK = 108,
  HERO_SKILL_SPOILS_OF_WAR = 129,
  HERO_SKILL_STORM_WIND = 122,
  HERO_SKILL_STRONG_RUNE = 153,
  HERO_SKILL_STUDENT_AWARD = 79,
  HERO_SKILL_STUNNING_BLOW = 180,
  HERO_SKILL_SUMMONING_MAGIC = 12,
  HERO_SKILL_SUN_FIRE = 120,
  HERO_SKILL_SUPRESS_DARK = 134,
  HERO_SKILL_SUPRESS_LIGHT = 135,
  HERO_SKILL_TACTICS = 34,
  HERO_SKILL_TAP_RUNES = 157,
  HERO_SKILL_TELEPORT_ASSAULT = 138,
  HERO_SKILL_TOUGHNESS = 39,
  HERO_SKILL_TRAINING = 13,
  HERO_SKILL_TRIPLE_BALLISTA = 74,
  HERO_SKILL_TRIPLE_CATAPULT = 88,
  HERO_SKILL_TWILIGHT = 109,
  HERO_SKILL_UNSUMMON = 136,
  HERO_SKILL_VOICE = 187,
  HERO_SKILL_VOICE_OF_RAGE = 190,
  HERO_SKILL_VOICE_TRAINING = 188,
  HERO_SKILL_WARCRY_LEARNING = 185,
  HERO_SKILL_WAR_MACHINES = 2,
  HERO_SKILL_WEAKENING_STRIKE = 95,
  HERO_SKILL_WEAKEN_DARK = 197,
  HERO_SKILL_WEAKEN_DESTRUCTIVE = 193,
  HERO_SKILL_WEAKEN_LIGHT = 201,
  HERO_SKILL_WEAKEN_SUMMONING = 205,
  HERO_SKILL_WILDFIRE = 130,
  HERO_SKILL_WISDOM = 41,
}

H55_ABILITY_BY_TAIL = {
  ACID_BLOOD = { 154 },
  ACID_BREATH = { 50 },
  AGILITY = { 97 },
  AMMO_STEAL = { 134 },
  ANTI_GIANT = { 159 },
  ARMORED = { 85 },
  AURA_OF_BRAVERY = { 155 },
  AURA_OF_EARTH_VULNERABILITY = { 149 },
  AURA_OF_FIRE_VULNERABILITY = { 146 },
  AURA_OF_ICE_VULNERABILITY = { 147 },
  AURA_OF_LIGHTNING_VULNERABILITY = { 148 },
  AURA_OF_MAGIC_RESISTANCE = { 47 },
  AVENGING_FLAME = { 160 },
  AXE_OF_SLAUGHTER = { 128 },
  BALOR_SUMMONIG = { 73 },
  BASH = { 29 },
  BATTLE_DIVE = { 30 },
  BATTLE_FRENZY = { 100 },
  BATTLE_RAGE = { 162 },
  BEAR_ROAR = { 164 },
  BERSERKER_RAGE = { 89 },
  BLADE_BARRIER = { 104 },
  BLINDING_ATTACK = { 46 },
  BOND_OF_LIGHT = { 143 },
  BRAVERY = { 56 },
  BRUTALITY = { 111 },
  CALL_LIGHTNING = { 82 },
  CALL_STORM = { 150 },
  CASTER = { 69 },
  CHAIN_SHOT = { 38 },
  CHAMPION_CHARGE = { 102 },
  CLEAVE = { 99 },
  COWARDICE = { 106 },
  CROSS_ATTACK = { 93 },
  CRUSHING_BLOW = { 123 },
  CRYSTAL_SCALES = { 66 },
  CURSING_ATTACK = { 13 },
  DASH = { 81 },
  DEADLY_STRIKE = { 63 },
  DEATH_CLOUD = { 43 },
  DEATH_WAIL = { 132 },
  DEFILE_MAGIC = { 109 },
  DEMONIC = { 11 },
  DEMON_RAGED = { 105 },
  DESTRUCTION_MAGIC_MAGNETISM = { 174 },
  DOUBLE_ATTACK = { 7 },
  DOUBLE_SHOT = { 8 },
  ELDRITCH_AURA = { 145 },
  ELEMENTAL = { 12 },
  ELVES_DOUBLE_SHOT = { 44 },
  ENCHANTED_OBSIDIAN = { 153 },
  ENERGY_CHANNEL = { 52 },
  ENRAGED = { 15 },
  ENTANGLING_ROOTS = { 49 },
  EVIL_EYE = { 124 },
  EXPLOSION = { 33 },
  FAST_ATTACK = { 115 },
  FEAR = { 35 },
  FIERCE_RETALIATION = { 113 },
  FIRE_BREATH = { 76 },
  FIRE_PROOF_50 = { 173 },
  FIRE_SHIELD = { 62 },
  FLAMESTRIKE = { 167 },
  FLAMEWAVE = { 166 },
  FLESH_AND_BLOOD = { 14 },
  FLYER = { 68 },
  FRIGHTFUL_PRESENCE = { 65 },
  FRIGHT_AURA = { 36 },
  GOBLIN_THROWER = { 122 },
  HARM_TOUCH = { 77 },
  HARPOON_STRIKE = { 163 },
  HEXING_ATTACK = { 98 },
  HOLD_GROUND = { 165 },
  HORROR_OF_THE_DEATH = { 137 },
  HOWL = { 96 },
  IMMUNITY_TO_AIR = { 20 },
  IMMUNITY_TO_BERSERK = { 170 },
  IMMUNITY_TO_BLIND = { 16 },
  IMMUNITY_TO_CURSE = { 169 },
  IMMUNITY_TO_EARTH = { 23 },
  IMMUNITY_TO_FIRE = { 21 },
  IMMUNITY_TO_HYPNOTIZE = { 171 },
  IMMUNITY_TO_MAGIC = { 17 },
  IMMUNITY_TO_MIND_CONTROL = { 19 },
  IMMUNITY_TO_SLOW = { 18 },
  IMMUNITY_TO_WATER = { 22 },
  INCINERATE = { 156 },
  INCORPOREAL = { 40 },
  INVISIBILITY = { 157 },
  JOUSTING = { 28 },
  LARGE_CREATURE = { 67 },
  LARGE_SHIELD = { 26 },
  LAY_HANDS = { 83 },
  LEAP = { 131 },
  LIFE_DRAIN = { 42 },
  LIGHTNING_BREATH = { 120 },
  LIQUID_FLAME_BREATH = { 168 },
  LIZARD_BITE = { 58 },
  LUCK_GAMBLER = { 152 },
  MAGIC_ATTACK = { 51 },
  MAGIC_PROOF_25 = { 172 },
  MAGIC_PROOF_50 = { 24 },
  MAGIC_PROOF_75 = { 53 },
  MAGMA_SHIELD = { 94 },
  MANA_DESTROYER = { 31 },
  MANA_DRAIN = { 41 },
  MANA_FEED = { 75 },
  MANA_STEALER = { 32 },
  MANEURE = { 110 },
  MARK_OF_FIRE = { 92 },
  MECHANICAL = { 9 },
  NONE = { 0 },
  NO_ENEMY_RETALIATION = { 5 },
  NO_MELEE_PENALTY = { 2 },
  NO_RANGE_PENALTY = { 3 },
  ORDER_OF_THE_CHIEF = { 117 },
  PACK_DIVE = { 101 },
  PACK_HUNTER = { 95 },
  PAW_STRIKE = { 88 },
  PIERCING_ARROW = { 138 },
  POISONOUS_ATTACK = { 54 },
  POWER_FEED = { 141 },
  PRECISE_SHOT = { 25 },
  PREPARED_POSITION = { 161 },
  PRESENCE_OF_COMMANDER = { 116 },
  PURGER = { 103 },
  RAGE_OF_THE_FOREST = { 140 },
  RAINBOW_BREATH = { 142 },
  RANDOM_CASTER = { 80 },
  RANDOM_CASTER_BLESS = { 125 },
  RANGED_RETALIATE = { 34 },
  RANGE_PENALTY = { 4 },
  REBIRTH = { 64 },
  REGENERATION = { 60 },
  REPAIR = { 79 },
  RESURRECT_ALLIES = { 72 },
  RIDER_CHARGE = { 57 },
  RIDE_BY_ATTACK = { 158 },
  SABOTAGE = { 151 },
  SACRIFICE_GOBLIN = { 114 },
  SCATTER_SHOT = { 71 },
  SCAVENGER = { 119 },
  SEARING_AURA = { 127 },
  SEDUCE = { 130 },
  SET_SNARES = { 108 },
  SHIELD_OTHER = { 27 },
  SHIELD_WALL = { 86 },
  SHOOTER = { 1 },
  SIX_HEADED_ATTACK = { 59 },
  SLEEPING_STRIKE = { 135 },
  SORROW_STRIKE = { 136 },
  SPRAY_ATTACK = { 74 },
  STORMBOLT = { 90 },
  STORMSTRIKE = { 91 },
  STRIKE_AND_RETURN = { 55 },
  SUMMON_OTHER = { 129 },
  SWALLOW_GOBLIN = { 121 },
  SYPHON_MANA = { 126 },
  TAKE_ROOTS = { 48 },
  TAUNT = { 112 },
  TAXPAYER = { 70 },
  THREE_HEADED_ATTACK = { 84 },
  TREACHERY = { 107 },
  TREEANT_UNION = { 139 },
  UNDEAD = { 10 },
  UNLIMITED_RETALIATION = { 6 },
  VENOM = { 118 },
  VORPAL_SWORD = { 37 },
  WARDING_ARROWS = { 45 },
  WAR_DANCE = { 78 },
  WEAKENING_AURA = { 133 },
  WEAKENING_STRIKE = { 39 },
  WHIP_STRIKE = { 61 },
  WHIRLWIND = { 144 },
  WOUND = { 87 },
}

H55_ABILITY_BY_CONST = {
  ABILITY_ACID_BLOOD = 154,
  ABILITY_ACID_BREATH = 50,
  ABILITY_AGILITY = 97,
  ABILITY_AMMO_STEAL = 134,
  ABILITY_ANTI_GIANT = 159,
  ABILITY_ARMORED = 85,
  ABILITY_AURA_OF_BRAVERY = 155,
  ABILITY_AURA_OF_EARTH_VULNERABILITY = 149,
  ABILITY_AURA_OF_FIRE_VULNERABILITY = 146,
  ABILITY_AURA_OF_ICE_VULNERABILITY = 147,
  ABILITY_AURA_OF_LIGHTNING_VULNERABILITY = 148,
  ABILITY_AURA_OF_MAGIC_RESISTANCE = 47,
  ABILITY_AVENGING_FLAME = 160,
  ABILITY_AXE_OF_SLAUGHTER = 128,
  ABILITY_BALOR_SUMMONIG = 73,
  ABILITY_BASH = 29,
  ABILITY_BATTLE_DIVE = 30,
  ABILITY_BATTLE_FRENZY = 100,
  ABILITY_BATTLE_RAGE = 162,
  ABILITY_BEAR_ROAR = 164,
  ABILITY_BERSERKER_RAGE = 89,
  ABILITY_BLADE_BARRIER = 104,
  ABILITY_BLINDING_ATTACK = 46,
  ABILITY_BOND_OF_LIGHT = 143,
  ABILITY_BRAVERY = 56,
  ABILITY_BRUTALITY = 111,
  ABILITY_CALL_LIGHTNING = 82,
  ABILITY_CALL_STORM = 150,
  ABILITY_CASTER = 69,
  ABILITY_CHAIN_SHOT = 38,
  ABILITY_CHAMPION_CHARGE = 102,
  ABILITY_CLEAVE = 99,
  ABILITY_COWARDICE = 106,
  ABILITY_CROSS_ATTACK = 93,
  ABILITY_CRUSHING_BLOW = 123,
  ABILITY_CRYSTAL_SCALES = 66,
  ABILITY_CURSING_ATTACK = 13,
  ABILITY_DASH = 81,
  ABILITY_DEADLY_STRIKE = 63,
  ABILITY_DEATH_CLOUD = 43,
  ABILITY_DEATH_WAIL = 132,
  ABILITY_DEFILE_MAGIC = 109,
  ABILITY_DEMONIC = 11,
  ABILITY_DEMON_RAGED = 105,
  ABILITY_DESTRUCTION_MAGIC_MAGNETISM = 174,
  ABILITY_DOUBLE_ATTACK = 7,
  ABILITY_DOUBLE_SHOT = 8,
  ABILITY_ELDRITCH_AURA = 145,
  ABILITY_ELEMENTAL = 12,
  ABILITY_ELVES_DOUBLE_SHOT = 44,
  ABILITY_ENCHANTED_OBSIDIAN = 153,
  ABILITY_ENERGY_CHANNEL = 52,
  ABILITY_ENRAGED = 15,
  ABILITY_ENTANGLING_ROOTS = 49,
  ABILITY_EVIL_EYE = 124,
  ABILITY_EXPLOSION = 33,
  ABILITY_FAST_ATTACK = 115,
  ABILITY_FEAR = 35,
  ABILITY_FIERCE_RETALIATION = 113,
  ABILITY_FIRE_BREATH = 76,
  ABILITY_FIRE_PROOF_50 = 173,
  ABILITY_FIRE_SHIELD = 62,
  ABILITY_FLAMESTRIKE = 167,
  ABILITY_FLAMEWAVE = 166,
  ABILITY_FLESH_AND_BLOOD = 14,
  ABILITY_FLYER = 68,
  ABILITY_FRIGHTFUL_PRESENCE = 65,
  ABILITY_FRIGHT_AURA = 36,
  ABILITY_GOBLIN_THROWER = 122,
  ABILITY_HARM_TOUCH = 77,
  ABILITY_HARPOON_STRIKE = 163,
  ABILITY_HEXING_ATTACK = 98,
  ABILITY_HOLD_GROUND = 165,
  ABILITY_HORROR_OF_THE_DEATH = 137,
  ABILITY_HOWL = 96,
  ABILITY_IMMUNITY_TO_AIR = 20,
  ABILITY_IMMUNITY_TO_BERSERK = 170,
  ABILITY_IMMUNITY_TO_BLIND = 16,
  ABILITY_IMMUNITY_TO_CURSE = 169,
  ABILITY_IMMUNITY_TO_EARTH = 23,
  ABILITY_IMMUNITY_TO_FIRE = 21,
  ABILITY_IMMUNITY_TO_HYPNOTIZE = 171,
  ABILITY_IMMUNITY_TO_MAGIC = 17,
  ABILITY_IMMUNITY_TO_MIND_CONTROL = 19,
  ABILITY_IMMUNITY_TO_SLOW = 18,
  ABILITY_IMMUNITY_TO_WATER = 22,
  ABILITY_INCINERATE = 156,
  ABILITY_INCORPOREAL = 40,
  ABILITY_INVISIBILITY = 157,
  ABILITY_JOUSTING = 28,
  ABILITY_LARGE_CREATURE = 67,
  ABILITY_LARGE_SHIELD = 26,
  ABILITY_LAY_HANDS = 83,
  ABILITY_LEAP = 131,
  ABILITY_LIFE_DRAIN = 42,
  ABILITY_LIGHTNING_BREATH = 120,
  ABILITY_LIQUID_FLAME_BREATH = 168,
  ABILITY_LIZARD_BITE = 58,
  ABILITY_LUCK_GAMBLER = 152,
  ABILITY_MAGIC_ATTACK = 51,
  ABILITY_MAGIC_PROOF_25 = 172,
  ABILITY_MAGIC_PROOF_50 = 24,
  ABILITY_MAGIC_PROOF_75 = 53,
  ABILITY_MAGMA_SHIELD = 94,
  ABILITY_MANA_DESTROYER = 31,
  ABILITY_MANA_DRAIN = 41,
  ABILITY_MANA_FEED = 75,
  ABILITY_MANA_STEALER = 32,
  ABILITY_MANEURE = 110,
  ABILITY_MARK_OF_FIRE = 92,
  ABILITY_MECHANICAL = 9,
  ABILITY_NONE = 0,
  ABILITY_NO_ENEMY_RETALIATION = 5,
  ABILITY_NO_MELEE_PENALTY = 2,
  ABILITY_NO_RANGE_PENALTY = 3,
  ABILITY_ORDER_OF_THE_CHIEF = 117,
  ABILITY_PACK_DIVE = 101,
  ABILITY_PACK_HUNTER = 95,
  ABILITY_PAW_STRIKE = 88,
  ABILITY_PIERCING_ARROW = 138,
  ABILITY_POISONOUS_ATTACK = 54,
  ABILITY_POWER_FEED = 141,
  ABILITY_PRECISE_SHOT = 25,
  ABILITY_PREPARED_POSITION = 161,
  ABILITY_PRESENCE_OF_COMMANDER = 116,
  ABILITY_PURGER = 103,
  ABILITY_RAGE_OF_THE_FOREST = 140,
  ABILITY_RAINBOW_BREATH = 142,
  ABILITY_RANDOM_CASTER = 80,
  ABILITY_RANDOM_CASTER_BLESS = 125,
  ABILITY_RANGED_RETALIATE = 34,
  ABILITY_RANGE_PENALTY = 4,
  ABILITY_REBIRTH = 64,
  ABILITY_REGENERATION = 60,
  ABILITY_REPAIR = 79,
  ABILITY_RESURRECT_ALLIES = 72,
  ABILITY_RIDER_CHARGE = 57,
  ABILITY_RIDE_BY_ATTACK = 158,
  ABILITY_SABOTAGE = 151,
  ABILITY_SACRIFICE_GOBLIN = 114,
  ABILITY_SCATTER_SHOT = 71,
  ABILITY_SCAVENGER = 119,
  ABILITY_SEARING_AURA = 127,
  ABILITY_SEDUCE = 130,
  ABILITY_SET_SNARES = 108,
  ABILITY_SHIELD_OTHER = 27,
  ABILITY_SHIELD_WALL = 86,
  ABILITY_SHOOTER = 1,
  ABILITY_SIX_HEADED_ATTACK = 59,
  ABILITY_SLEEPING_STRIKE = 135,
  ABILITY_SORROW_STRIKE = 136,
  ABILITY_SPRAY_ATTACK = 74,
  ABILITY_STORMBOLT = 90,
  ABILITY_STORMSTRIKE = 91,
  ABILITY_STRIKE_AND_RETURN = 55,
  ABILITY_SUMMON_OTHER = 129,
  ABILITY_SWALLOW_GOBLIN = 121,
  ABILITY_SYPHON_MANA = 126,
  ABILITY_TAKE_ROOTS = 48,
  ABILITY_TAUNT = 112,
  ABILITY_TAXPAYER = 70,
  ABILITY_THREE_HEADED_ATTACK = 84,
  ABILITY_TREACHERY = 107,
  ABILITY_TREEANT_UNION = 139,
  ABILITY_UNDEAD = 10,
  ABILITY_UNLIMITED_RETALIATION = 6,
  ABILITY_VENOM = 118,
  ABILITY_VORPAL_SWORD = 37,
  ABILITY_WARDING_ARROWS = 45,
  ABILITY_WAR_DANCE = 78,
  ABILITY_WEAKENING_AURA = 133,
  ABILITY_WEAKENING_STRIKE = 39,
  ABILITY_WHIP_STRIKE = 61,
  ABILITY_WHIRLWIND = 144,
  ABILITY_WOUND = 87,
}

H55_CREATURE_BY_TAIL = {
  250 = { 250 },
  251 = { 251 },
  252 = { 252 },
  253 = { 253 },
  254 = { 254 },
  255 = { 255 },
  256 = { 256 },
  257 = { 257 },
  258 = { 258 },
  259 = { 259 },
  260 = { 260 },
  261 = { 261 },
  262 = { 262 },
  263 = { 263 },
  264 = { 264 },
  265 = { 265 },
  266 = { 266 },
  267 = { 267 },
  268 = { 268 },
  269 = { 269 },
  270 = { 270 },
  271 = { 271 },
  272 = { 272 },
  273 = { 273 },
  274 = { 274 },
  275 = { 275 },
  276 = { 276 },
  277 = { 277 },
  278 = { 278 },
  279 = { 279 },
  280 = { 280 },
  281 = { 281 },
  282 = { 282 },
  283 = { 283 },
  284 = { 284 },
  285 = { 285 },
  286 = { 286 },
  287 = { 287 },
  288 = { 288 },
  289 = { 289 },
  290 = { 290 },
  291 = { 291 },
  292 = { 292 },
  293 = { 293 },
  294 = { 294 },
  295 = { 295 },
  296 = { 296 },
  297 = { 297 },
  298 = { 298 },
  299 = { 299 },
  300 = { 300 },
  301 = { 301 },
  302 = { 302 },
  303 = { 303 },
  304 = { 304 },
  305 = { 305 },
  306 = { 306 },
  307 = { 307 },
  308 = { 308 },
  309 = { 309 },
  310 = { 310 },
  311 = { 311 },
  312 = { 312 },
  313 = { 313 },
  314 = { 314 },
  315 = { 315 },
  316 = { 316 },
  317 = { 317 },
  318 = { 318 },
  319 = { 319 },
  320 = { 320 },
  321 = { 321 },
  322 = { 322 },
  323 = { 323 },
  324 = { 324 },
  325 = { 325 },
  326 = { 326 },
  327 = { 327 },
  328 = { 328 },
  329 = { 329 },
  330 = { 330 },
  331 = { 331 },
  332 = { 332 },
  333 = { 333 },
  334 = { 334 },
  335 = { 335 },
  336 = { 336 },
  337 = { 337 },
  338 = { 338 },
  339 = { 339 },
  340 = { 340 },
  341 = { 341 },
  342 = { 342 },
  343 = { 343 },
  344 = { 344 },
  345 = { 345 },
  346 = { 346 },
  347 = { 347 },
  348 = { 348 },
  349 = { 349 },
  350 = { 350 },
  351 = { 351 },
  352 = { 352 },
  353 = { 353 },
  354 = { 354 },
  355 = { 355 },
  356 = { 356 },
  357 = { 357 },
  358 = { 358 },
  359 = { 359 },
  360 = { 360 },
  361 = { 361 },
  362 = { 362 },
  363 = { 363 },
  364 = { 364 },
  365 = { 365 },
  366 = { 366 },
  367 = { 367 },
  368 = { 368 },
  369 = { 369 },
  370 = { 370 },
  371 = { 371 },
  372 = { 372 },
  373 = { 373 },
  374 = { 374 },
  375 = { 375 },
  376 = { 376 },
  377 = { 377 },
  378 = { 378 },
  379 = { 379 },
  380 = { 380 },
  381 = { 381 },
  382 = { 382 },
  383 = { 383 },
  384 = { 384 },
  385 = { 385 },
  386 = { 386 },
  387 = { 387 },
  388 = { 388 },
  389 = { 389 },
  390 = { 390 },
  391 = { 391 },
  392 = { 392 },
  393 = { 393 },
  394 = { 394 },
  395 = { 395 },
  396 = { 396 },
  397 = { 397 },
  398 = { 398 },
  399 = { 399 },
  400 = { 400 },
  401 = { 401 },
  402 = { 402 },
  403 = { 403 },
  404 = { 404 },
  405 = { 405 },
  406 = { 406 },
  407 = { 407 },
  408 = { 408 },
  409 = { 409 },
  410 = { 410 },
  411 = { 411 },
  412 = { 412 },
  413 = { 413 },
  414 = { 414 },
  415 = { 415 },
  416 = { 416 },
  417 = { 417 },
  418 = { 418 },
  419 = { 419 },
  420 = { 420 },
  421 = { 421 },
  422 = { 422 },
  423 = { 423 },
  424 = { 424 },
  425 = { 425 },
  426 = { 426 },
  427 = { 427 },
  428 = { 428 },
  429 = { 429 },
  430 = { 430 },
  431 = { 431 },
  432 = { 432 },
  433 = { 433 },
  434 = { 434 },
  435 = { 435 },
  436 = { 436 },
  437 = { 437 },
  438 = { 438 },
  439 = { 439 },
  440 = { 440 },
  441 = { 441 },
  442 = { 442 },
  443 = { 443 },
  444 = { 444 },
  445 = { 445 },
  446 = { 446 },
  447 = { 447 },
  448 = { 448 },
  449 = { 449 },
  450 = { 450 },
  451 = { 451 },
  452 = { 452 },
  453 = { 453 },
  454 = { 454 },
  455 = { 455 },
  456 = { 456 },
  457 = { 457 },
  458 = { 458 },
  459 = { 459 },
  460 = { 460 },
  461 = { 461 },
  462 = { 462 },
  463 = { 463 },
  464 = { 464 },
  465 = { 465 },
  466 = { 466 },
  467 = { 467 },
  468 = { 468 },
  469 = { 469 },
  470 = { 470 },
  471 = { 471 },
  472 = { 472 },
  473 = { 473 },
  474 = { 474 },
  475 = { 475 },
  476 = { 476 },
  477 = { 477 },
  478 = { 478 },
  479 = { 479 },
  480 = { 480 },
  481 = { 481 },
  482 = { 482 },
  483 = { 483 },
  484 = { 484 },
  485 = { 485 },
  486 = { 486 },
  487 = { 487 },
  488 = { 488 },
  489 = { 489 },
  490 = { 490 },
  491 = { 491 },
  492 = { 492 },
  493 = { 493 },
  494 = { 494 },
  495 = { 495 },
  496 = { 496 },
  497 = { 497 },
  498 = { 498 },
  499 = { 499 },
  500 = { 500 },
  501 = { 501 },
  502 = { 502 },
  503 = { 503 },
  504 = { 504 },
  505 = { 505 },
  506 = { 506 },
  507 = { 507 },
  508 = { 508 },
  509 = { 509 },
  510 = { 510 },
  511 = { 511 },
  512 = { 512 },
  513 = { 513 },
  514 = { 514 },
  515 = { 515 },
  516 = { 516 },
  517 = { 517 },
  518 = { 518 },
  519 = { 519 },
  520 = { 520 },
  521 = { 521 },
  522 = { 522 },
  523 = { 523 },
  524 = { 524 },
  525 = { 525 },
  526 = { 526 },
  527 = { 527 },
  528 = { 528 },
  529 = { 529 },
  530 = { 530 },
  531 = { 531 },
  532 = { 532 },
  533 = { 533 },
  534 = { 534 },
  535 = { 535 },
  536 = { 536 },
  537 = { 537 },
  538 = { 538 },
  539 = { 539 },
  540 = { 540 },
  541 = { 541 },
  542 = { 542 },
  543 = { 543 },
  544 = { 544 },
  545 = { 545 },
  546 = { 546 },
  547 = { 547 },
  548 = { 548 },
  549 = { 549 },
  550 = { 550 },
  551 = { 551 },
  552 = { 552 },
  553 = { 553 },
  554 = { 554 },
  555 = { 555 },
  556 = { 556 },
  557 = { 557 },
  558 = { 558 },
  559 = { 559 },
  560 = { 560 },
  561 = { 561 },
  562 = { 562 },
  563 = { 563 },
  564 = { 564 },
  565 = { 565 },
  566 = { 566 },
  567 = { 567 },
  568 = { 568 },
  569 = { 569 },
  570 = { 570 },
  571 = { 571 },
  572 = { 572 },
  573 = { 573 },
  574 = { 574 },
  575 = { 575 },
  576 = { 576 },
  577 = { 577 },
  578 = { 578 },
  579 = { 579 },
  580 = { 580 },
  581 = { 581 },
  582 = { 582 },
  583 = { 583 },
  584 = { 584 },
  585 = { 585 },
  586 = { 586 },
  587 = { 587 },
  588 = { 588 },
  589 = { 589 },
  590 = { 590 },
  591 = { 591 },
  592 = { 592 },
  593 = { 593 },
  594 = { 594 },
  595 = { 595 },
  596 = { 596 },
  597 = { 597 },
  598 = { 598 },
  599 = { 599 },
  600 = { 600 },
  601 = { 601 },
  602 = { 602 },
  603 = { 603 },
  604 = { 604 },
  605 = { 605 },
  606 = { 606 },
  607 = { 607 },
  608 = { 608 },
  609 = { 609 },
  610 = { 610 },
  611 = { 611 },
  612 = { 612 },
  613 = { 613 },
  614 = { 614 },
  615 = { 615 },
  616 = { 616 },
  617 = { 617 },
  618 = { 618 },
  619 = { 619 },
  620 = { 620 },
  621 = { 621 },
  622 = { 622 },
  623 = { 623 },
  624 = { 624 },
  625 = { 625 },
  626 = { 626 },
  627 = { 627 },
  628 = { 628 },
  629 = { 629 },
  630 = { 630 },
  631 = { 631 },
  632 = { 632 },
  633 = { 633 },
  634 = { 634 },
  635 = { 635 },
  636 = { 636 },
  637 = { 637 },
  638 = { 638 },
  639 = { 639 },
  640 = { 640 },
  641 = { 641 },
  642 = { 642 },
  643 = { 643 },
  644 = { 644 },
  645 = { 645 },
  646 = { 646 },
  647 = { 647 },
  648 = { 648 },
  649 = { 649 },
  650 = { 650 },
  651 = { 651 },
  652 = { 652 },
  653 = { 653 },
  654 = { 654 },
  655 = { 655 },
  656 = { 656 },
  657 = { 657 },
  658 = { 658 },
  659 = { 659 },
  660 = { 660 },
  661 = { 661 },
  662 = { 662 },
  663 = { 663 },
  664 = { 664 },
  665 = { 665 },
  666 = { 666 },
  667 = { 667 },
  668 = { 668 },
  669 = { 669 },
  670 = { 670 },
  671 = { 671 },
  672 = { 672 },
  673 = { 673 },
  674 = { 674 },
  675 = { 675 },
  676 = { 676 },
  677 = { 677 },
  678 = { 678 },
  679 = { 679 },
  680 = { 680 },
  681 = { 681 },
  682 = { 682 },
  683 = { 683 },
  684 = { 684 },
  685 = { 685 },
  686 = { 686 },
  687 = { 687 },
  688 = { 688 },
  689 = { 689 },
  690 = { 690 },
  691 = { 691 },
  692 = { 692 },
  693 = { 693 },
  694 = { 694 },
  695 = { 695 },
  696 = { 696 },
  697 = { 697 },
  698 = { 698 },
  699 = { 699 },
  700 = { 700 },
  701 = { 701 },
  702 = { 702 },
  703 = { 703 },
  704 = { 704 },
  705 = { 705 },
  706 = { 706 },
  707 = { 707 },
  708 = { 708 },
  709 = { 709 },
  710 = { 710 },
  711 = { 711 },
  712 = { 712 },
  713 = { 713 },
  714 = { 714 },
  715 = { 715 },
  716 = { 716 },
  717 = { 717 },
  718 = { 718 },
  719 = { 719 },
  720 = { 720 },
  721 = { 721 },
  722 = { 722 },
  723 = { 723 },
  724 = { 724 },
  725 = { 725 },
  726 = { 726 },
  727 = { 727 },
  728 = { 728 },
  729 = { 729 },
  730 = { 730 },
  731 = { 731 },
  732 = { 732 },
  733 = { 733 },
  734 = { 734 },
  735 = { 735 },
  736 = { 736 },
  737 = { 737 },
  738 = { 738 },
  739 = { 739 },
  740 = { 740 },
  741 = { 741 },
  742 = { 742 },
  743 = { 743 },
  744 = { 744 },
  745 = { 745 },
  746 = { 746 },
  747 = { 747 },
  748 = { 748 },
  749 = { 749 },
  750 = { 750 },
  751 = { 751 },
  752 = { 752 },
  753 = { 753 },
  754 = { 754 },
  755 = { 755 },
  756 = { 756 },
  757 = { 757 },
  758 = { 758 },
  759 = { 759 },
  760 = { 760 },
  761 = { 761 },
  762 = { 762 },
  763 = { 763 },
  764 = { 764 },
  765 = { 765 },
  766 = { 766 },
  767 = { 767 },
  768 = { 768 },
  769 = { 769 },
  770 = { 770 },
  771 = { 771 },
  772 = { 772 },
  773 = { 773 },
  774 = { 774 },
  775 = { 775 },
  776 = { 776 },
  777 = { 777 },
  778 = { 778 },
  779 = { 779 },
  780 = { 780 },
  781 = { 781 },
  782 = { 782 },
  783 = { 783 },
  784 = { 784 },
  785 = { 785 },
  786 = { 786 },
  787 = { 787 },
  788 = { 788 },
  789 = { 789 },
  790 = { 790 },
  791 = { 791 },
  792 = { 792 },
  793 = { 793 },
  794 = { 794 },
  795 = { 795 },
  796 = { 796 },
  797 = { 797 },
  798 = { 798 },
  799 = { 799 },
  800 = { 800 },
  801 = { 801 },
  802 = { 802 },
  803 = { 803 },
  804 = { 804 },
  805 = { 805 },
  806 = { 806 },
  807 = { 807 },
  808 = { 808 },
  809 = { 809 },
  810 = { 810 },
  811 = { 811 },
  812 = { 812 },
  813 = { 813 },
  814 = { 814 },
  815 = { 815 },
  816 = { 816 },
  817 = { 817 },
  818 = { 818 },
  819 = { 819 },
  820 = { 820 },
  821 = { 821 },
  822 = { 822 },
  823 = { 823 },
  824 = { 824 },
  825 = { 825 },
  826 = { 826 },
  827 = { 827 },
  828 = { 828 },
  829 = { 829 },
  830 = { 830 },
  831 = { 831 },
  832 = { 832 },
  833 = { 833 },
  834 = { 834 },
  835 = { 835 },
  836 = { 836 },
  837 = { 837 },
  838 = { 838 },
  839 = { 839 },
  840 = { 840 },
  841 = { 841 },
  842 = { 842 },
  843 = { 843 },
  844 = { 844 },
  845 = { 845 },
  846 = { 846 },
  847 = { 847 },
  848 = { 848 },
  849 = { 849 },
  850 = { 850 },
  851 = { 851 },
  852 = { 852 },
  853 = { 853 },
  854 = { 854 },
  855 = { 855 },
  856 = { 856 },
  857 = { 857 },
  858 = { 858 },
  859 = { 859 },
  860 = { 860 },
  861 = { 861 },
  862 = { 862 },
  863 = { 863 },
  864 = { 864 },
  865 = { 865 },
  866 = { 866 },
  867 = { 867 },
  868 = { 868 },
  869 = { 869 },
  870 = { 870 },
  871 = { 871 },
  872 = { 872 },
  873 = { 873 },
  874 = { 874 },
  875 = { 875 },
  876 = { 876 },
  877 = { 877 },
  878 = { 878 },
  879 = { 879 },
  880 = { 880 },
  881 = { 881 },
  882 = { 882 },
  883 = { 883 },
  884 = { 884 },
  885 = { 885 },
  886 = { 886 },
  887 = { 887 },
  888 = { 888 },
  889 = { 889 },
  890 = { 890 },
  891 = { 891 },
  892 = { 892 },
  893 = { 893 },
  894 = { 894 },
  895 = { 895 },
  896 = { 896 },
  897 = { 897 },
  898 = { 898 },
  899 = { 899 },
  900 = { 900 },
  901 = { 901 },
  902 = { 902 },
  903 = { 903 },
  904 = { 904 },
  905 = { 905 },
  906 = { 906 },
  907 = { 907 },
  908 = { 908 },
  909 = { 909 },
  910 = { 910 },
  911 = { 911 },
  912 = { 912 },
  913 = { 913 },
  914 = { 914 },
  915 = { 915 },
  916 = { 916 },
  917 = { 917 },
  918 = { 918 },
  919 = { 919 },
  920 = { 920 },
  921 = { 921 },
  922 = { 922 },
  923 = { 923 },
  924 = { 924 },
  925 = { 925 },
  926 = { 926 },
  927 = { 927 },
  928 = { 928 },
  929 = { 929 },
  930 = { 930 },
  931 = { 931 },
  932 = { 932 },
  933 = { 933 },
  934 = { 934 },
  935 = { 935 },
  936 = { 936 },
  937 = { 937 },
  938 = { 938 },
  939 = { 939 },
  940 = { 940 },
  941 = { 941 },
  942 = { 942 },
  943 = { 943 },
  944 = { 944 },
  945 = { 945 },
  946 = { 946 },
  947 = { 947 },
  948 = { 948 },
  949 = { 949 },
  950 = { 950 },
  951 = { 951 },
  952 = { 952 },
  953 = { 953 },
  954 = { 954 },
  955 = { 955 },
  956 = { 956 },
  957 = { 957 },
  958 = { 958 },
  959 = { 959 },
  960 = { 960 },
  961 = { 961 },
  962 = { 962 },
  963 = { 963 },
  964 = { 964 },
  965 = { 965 },
  966 = { 966 },
  967 = { 967 },
  968 = { 968 },
  969 = { 969 },
  970 = { 970 },
  971 = { 971 },
  972 = { 972 },
  973 = { 973 },
  974 = { 974 },
  975 = { 975 },
  976 = { 976 },
  977 = { 977 },
  978 = { 978 },
  979 = { 979 },
  980 = { 980 },
  981 = { 981 },
  982 = { 982 },
  983 = { 983 },
  984 = { 984 },
  985 = { 985 },
  986 = { 986 },
  987 = { 987 },
  988 = { 988 },
  989 = { 989 },
  990 = { 990 },
  991 = { 991 },
  992 = { 992 },
  993 = { 993 },
  994 = { 994 },
  995 = { 995 },
  996 = { 996 },
  997 = { 997 },
  998 = { 998 },
  999 = { 999 },
  ACIDIC_HYDRA = { 142 },
  AIR_ELEMENTAL = { 88 },
  ANGEL = { 13 },
  ANGER_TREANT = { 150 },
  ARCHANGEL = { 14 },
  ARCHDEVIL = { 28 },
  ARCHER = { 3 },
  ARCH_DEMON = { 137 },
  ARCH_MAGI = { 64 },
  ASSASSIN = { 72 },
  AXE_FIGHTER = { 94 },
  AXE_THROWER = { 95 },
  BALOR = { 26 },
  BANSHEE = { 157 },
  BATTLE_GRIFFIN = { 109 },
  BATTLE_RAGER = { 169 },
  BEAR_RIDER = { 96 },
  BERSERKER = { 99 },
  BLACKBEAR_RIDER = { 97 },
  BLACK_DRAGON = { 84 },
  BLACK_KNIGHT = { 89 },
  BLACK_RIDER = { 141 },
  BLADE_JUGGLER = { 45 },
  BLADE_SINGER = { 146 },
  BLOOD_WITCH = { 74 },
  BLOOD_WITCH_2 = { 139 },
  BONE_DRAGON = { 41 },
  BROWLER = { 98 },
  CAVALIER = { 11 },
  CENTAUR = { 119 },
  CENTAUR_MARADEUR = { 174 },
  CENTAUR_NOMAD = { 120 },
  CERBERI = { 20 },
  CHAMPION = { 111 },
  CHAOS_HYDRA = { 80 },
  CLERIC = { 10 },
  COMBAT_MAGE = { 162 },
  CYCLOP = { 129 },
  CYCLOP_BLOODEYED = { 179 },
  CYCLOP_UNTAMED = { 130 },
  DEATH_KNIGHT = { 90 },
  DEEP_DRAGON = { 83 },
  DEFENDER = { 92 },
  DEMILICH = { 38 },
  DEMON = { 17 },
  DEVIL = { 27 },
  DISEASE_ZOMBIE = { 153 },
  DJINN_VIZIER = { 163 },
  DRUID = { 49 },
  DRUID_ELDER = { 50 },
  DRYAD = { 145 },
  EARTH_ELEMENTAL = { 87 },
  FAMILIAR = { 15 },
  FIREBREATHER_HOUND = { 133 },
  FIRE_DRAGON = { 104 },
  FIRE_ELEMENTAL = { 85 },
  FLAME_KEEPER = { 170 },
  FLAME_MAGE = { 101 },
  FOOTMAN = { 5 },
  FRIGHTFUL_NIGHTMARE = { 24 },
  GENIE = { 65 },
  GHOST = { 34 },
  GIANT = { 69 },
  GOBLIN = { 117 },
  GOBLIN_DEFILER = { 173 },
  GOBLIN_TRAPPER = { 118 },
  GOLD_DRAGON = { 56 },
  GRAND_ELF = { 48 },
  GREEN_DRAGON = { 55 },
  GREMLIN = { 57 },
  GREMLIN_SABOTEUR = { 159 },
  GRIFFIN = { 7 },
  HARPOONER = { 167 },
  HELLMARE = { 135 },
  HELL_HOUND = { 19 },
  HIGH_DRUID = { 148 },
  HORNED_DEMON = { 18 },
  HORNED_LEAPER = { 132 },
  HORROR_DRAGON = { 158 },
  HYDRA = { 79 },
  IMP = { 16 },
  INFERNAL_SUCCUBUS = { 22 },
  IRON_GOLEM = { 61 },
  LANDLORD = { 106 },
  LAVA_DRAGON = { 172 },
  LICH = { 37 },
  LICH_MASTER = { 156 },
  LONGBOWMAN = { 107 },
  MAGI = { 63 },
  MAGMA_DRAGON = { 105 },
  MANES = { 33 },
  MANTICORE = { 115 },
  MARBLE_GARGOYLE = { 160 },
  MARKSMAN = { 4 },
  MASTER_GENIE = { 66 },
  MASTER_GREMLIN = { 58 },
  MATRIARCH = { 82 },
  MATRON = { 81 },
  MILITIAMAN = { 2 },
  MINOTAUR = { 75 },
  MINOTAUR_CAPTAIN = { 140 },
  MINOTAUR_KING = { 76 },
  MUMMY = { 116 },
  NIGHTMARE = { 23 },
  NOSFERATU = { 155 },
  OBSIDIAN_GARGOYLE = { 60 },
  OBSIDIAN_GOLEM = { 161 },
  ORCCHIEF_BUTCHER = { 125 },
  ORCCHIEF_CHIEFTAIN = { 177 },
  ORCCHIEF_EXECUTIONER = { 126 },
  ORC_SLAYER = { 122 },
  ORC_WARMONGER = { 175 },
  ORC_WARRIOR = { 121 },
  PALADIN = { 12 },
  PEASANT = { 1 },
  PHOENIX = { 91 },
  PIT_FIEND = { 25 },
  PIT_SPAWN = { 136 },
  PIXIE = { 43 },
  POLTERGEIST = { 154 },
  PRIEST = { 9 },
  QUASIT = { 131 },
  RAINBOW_DRAGON = { 151 },
  RAKSHASA = { 67 },
  RAKSHASA_KSHATRI = { 164 },
  RAKSHASA_RUKH = { 68 },
  RAVAGER = { 78 },
  RED_DRAGON = { 144 },
  RIDER = { 77 },
  ROYAL_GRIFFIN = { 8 },
  RUNE_MAGE = { 100 },
  SCOUT = { 71 },
  SERAPH = { 112 },
  SHADOW_DRAGON = { 42 },
  SHADOW_MISTRESS = { 143 },
  SHAMAN = { 123 },
  SHAMAN_HAG = { 176 },
  SHAMAN_WITCH = { 124 },
  SHARP_SHOOTER = { 147 },
  SKELETON = { 29 },
  SKELETON_ARCHER = { 30 },
  SKELETON_WARRIOR = { 152 },
  SNOW_APE = { 114 },
  SPRITE = { 44 },
  STALKER = { 138 },
  STEEL_GOLEM = { 62 },
  STONE_DEFENDER = { 166 },
  STONE_GARGOYLE = { 59 },
  STORM_LORD = { 165 },
  STOUT_DEFENDER = { 93 },
  SUCCUBUS = { 21 },
  SUCCUBUS_SEDUCER = { 134 },
  SWORDSMAN = { 6 },
  THANE = { 102 },
  THUNDER_THANE = { 171 },
  TITAN = { 70 },
  TREANT = { 53 },
  TREANT_GUARDIAN = { 54 },
  UNICORN = { 51 },
  UNKNOWN = { 0 },
  VAMPIRE = { 35 },
  VAMPIRE_LORD = { 36 },
  VINDICATOR = { 108 },
  WALKING_DEAD = { 31 },
  WARLORD = { 103 },
  WAR_DANCER = { 46 },
  WAR_UNICORN = { 52 },
  WATER_ELEMENTAL = { 86 },
  WHITE_BEAR_RIDER = { 168 },
  WHITE_UNICORN = { 149 },
  WIGHT = { 39 },
  WITCH = { 73 },
  WOLF = { 113 },
  WOOD_ELF = { 47 },
  WRAITH = { 40 },
  WYVERN = { 127 },
  WYVERN_PAOKAI = { 178 },
  WYVERN_POISONOUS = { 128 },
  ZEALOT = { 110 },
  ZOMBIE = { 32 },
}

H55_CREATURE_BY_CONST = {
  CREATURE_250 = 250,
  CREATURE_251 = 251,
  CREATURE_252 = 252,
  CREATURE_253 = 253,
  CREATURE_254 = 254,
  CREATURE_255 = 255,
  CREATURE_256 = 256,
  CREATURE_257 = 257,
  CREATURE_258 = 258,
  CREATURE_259 = 259,
  CREATURE_260 = 260,
  CREATURE_261 = 261,
  CREATURE_262 = 262,
  CREATURE_263 = 263,
  CREATURE_264 = 264,
  CREATURE_265 = 265,
  CREATURE_266 = 266,
  CREATURE_267 = 267,
  CREATURE_268 = 268,
  CREATURE_269 = 269,
  CREATURE_270 = 270,
  CREATURE_271 = 271,
  CREATURE_272 = 272,
  CREATURE_273 = 273,
  CREATURE_274 = 274,
  CREATURE_275 = 275,
  CREATURE_276 = 276,
  CREATURE_277 = 277,
  CREATURE_278 = 278,
  CREATURE_279 = 279,
  CREATURE_280 = 280,
  CREATURE_281 = 281,
  CREATURE_282 = 282,
  CREATURE_283 = 283,
  CREATURE_284 = 284,
  CREATURE_285 = 285,
  CREATURE_286 = 286,
  CREATURE_287 = 287,
  CREATURE_288 = 288,
  CREATURE_289 = 289,
  CREATURE_290 = 290,
  CREATURE_291 = 291,
  CREATURE_292 = 292,
  CREATURE_293 = 293,
  CREATURE_294 = 294,
  CREATURE_295 = 295,
  CREATURE_296 = 296,
  CREATURE_297 = 297,
  CREATURE_298 = 298,
  CREATURE_299 = 299,
  CREATURE_300 = 300,
  CREATURE_301 = 301,
  CREATURE_302 = 302,
  CREATURE_303 = 303,
  CREATURE_304 = 304,
  CREATURE_305 = 305,
  CREATURE_306 = 306,
  CREATURE_307 = 307,
  CREATURE_308 = 308,
  CREATURE_309 = 309,
  CREATURE_310 = 310,
  CREATURE_311 = 311,
  CREATURE_312 = 312,
  CREATURE_313 = 313,
  CREATURE_314 = 314,
  CREATURE_315 = 315,
  CREATURE_316 = 316,
  CREATURE_317 = 317,
  CREATURE_318 = 318,
  CREATURE_319 = 319,
  CREATURE_320 = 320,
  CREATURE_321 = 321,
  CREATURE_322 = 322,
  CREATURE_323 = 323,
  CREATURE_324 = 324,
  CREATURE_325 = 325,
  CREATURE_326 = 326,
  CREATURE_327 = 327,
  CREATURE_328 = 328,
  CREATURE_329 = 329,
  CREATURE_330 = 330,
  CREATURE_331 = 331,
  CREATURE_332 = 332,
  CREATURE_333 = 333,
  CREATURE_334 = 334,
  CREATURE_335 = 335,
  CREATURE_336 = 336,
  CREATURE_337 = 337,
  CREATURE_338 = 338,
  CREATURE_339 = 339,
  CREATURE_340 = 340,
  CREATURE_341 = 341,
  CREATURE_342 = 342,
  CREATURE_343 = 343,
  CREATURE_344 = 344,
  CREATURE_345 = 345,
  CREATURE_346 = 346,
  CREATURE_347 = 347,
  CREATURE_348 = 348,
  CREATURE_349 = 349,
  CREATURE_350 = 350,
  CREATURE_351 = 351,
  CREATURE_352 = 352,
  CREATURE_353 = 353,
  CREATURE_354 = 354,
  CREATURE_355 = 355,
  CREATURE_356 = 356,
  CREATURE_357 = 357,
  CREATURE_358 = 358,
  CREATURE_359 = 359,
  CREATURE_360 = 360,
  CREATURE_361 = 361,
  CREATURE_362 = 362,
  CREATURE_363 = 363,
  CREATURE_364 = 364,
  CREATURE_365 = 365,
  CREATURE_366 = 366,
  CREATURE_367 = 367,
  CREATURE_368 = 368,
  CREATURE_369 = 369,
  CREATURE_370 = 370,
  CREATURE_371 = 371,
  CREATURE_372 = 372,
  CREATURE_373 = 373,
  CREATURE_374 = 374,
  CREATURE_375 = 375,
  CREATURE_376 = 376,
  CREATURE_377 = 377,
  CREATURE_378 = 378,
  CREATURE_379 = 379,
  CREATURE_380 = 380,
  CREATURE_381 = 381,
  CREATURE_382 = 382,
  CREATURE_383 = 383,
  CREATURE_384 = 384,
  CREATURE_385 = 385,
  CREATURE_386 = 386,
  CREATURE_387 = 387,
  CREATURE_388 = 388,
  CREATURE_389 = 389,
  CREATURE_390 = 390,
  CREATURE_391 = 391,
  CREATURE_392 = 392,
  CREATURE_393 = 393,
  CREATURE_394 = 394,
  CREATURE_395 = 395,
  CREATURE_396 = 396,
  CREATURE_397 = 397,
  CREATURE_398 = 398,
  CREATURE_399 = 399,
  CREATURE_400 = 400,
  CREATURE_401 = 401,
  CREATURE_402 = 402,
  CREATURE_403 = 403,
  CREATURE_404 = 404,
  CREATURE_405 = 405,
  CREATURE_406 = 406,
  CREATURE_407 = 407,
  CREATURE_408 = 408,
  CREATURE_409 = 409,
  CREATURE_410 = 410,
  CREATURE_411 = 411,
  CREATURE_412 = 412,
  CREATURE_413 = 413,
  CREATURE_414 = 414,
  CREATURE_415 = 415,
  CREATURE_416 = 416,
  CREATURE_417 = 417,
  CREATURE_418 = 418,
  CREATURE_419 = 419,
  CREATURE_420 = 420,
  CREATURE_421 = 421,
  CREATURE_422 = 422,
  CREATURE_423 = 423,
  CREATURE_424 = 424,
  CREATURE_425 = 425,
  CREATURE_426 = 426,
  CREATURE_427 = 427,
  CREATURE_428 = 428,
  CREATURE_429 = 429,
  CREATURE_430 = 430,
  CREATURE_431 = 431,
  CREATURE_432 = 432,
  CREATURE_433 = 433,
  CREATURE_434 = 434,
  CREATURE_435 = 435,
  CREATURE_436 = 436,
  CREATURE_437 = 437,
  CREATURE_438 = 438,
  CREATURE_439 = 439,
  CREATURE_440 = 440,
  CREATURE_441 = 441,
  CREATURE_442 = 442,
  CREATURE_443 = 443,
  CREATURE_444 = 444,
  CREATURE_445 = 445,
  CREATURE_446 = 446,
  CREATURE_447 = 447,
  CREATURE_448 = 448,
  CREATURE_449 = 449,
  CREATURE_450 = 450,
  CREATURE_451 = 451,
  CREATURE_452 = 452,
  CREATURE_453 = 453,
  CREATURE_454 = 454,
  CREATURE_455 = 455,
  CREATURE_456 = 456,
  CREATURE_457 = 457,
  CREATURE_458 = 458,
  CREATURE_459 = 459,
  CREATURE_460 = 460,
  CREATURE_461 = 461,
  CREATURE_462 = 462,
  CREATURE_463 = 463,
  CREATURE_464 = 464,
  CREATURE_465 = 465,
  CREATURE_466 = 466,
  CREATURE_467 = 467,
  CREATURE_468 = 468,
  CREATURE_469 = 469,
  CREATURE_470 = 470,
  CREATURE_471 = 471,
  CREATURE_472 = 472,
  CREATURE_473 = 473,
  CREATURE_474 = 474,
  CREATURE_475 = 475,
  CREATURE_476 = 476,
  CREATURE_477 = 477,
  CREATURE_478 = 478,
  CREATURE_479 = 479,
  CREATURE_480 = 480,
  CREATURE_481 = 481,
  CREATURE_482 = 482,
  CREATURE_483 = 483,
  CREATURE_484 = 484,
  CREATURE_485 = 485,
  CREATURE_486 = 486,
  CREATURE_487 = 487,
  CREATURE_488 = 488,
  CREATURE_489 = 489,
  CREATURE_490 = 490,
  CREATURE_491 = 491,
  CREATURE_492 = 492,
  CREATURE_493 = 493,
  CREATURE_494 = 494,
  CREATURE_495 = 495,
  CREATURE_496 = 496,
  CREATURE_497 = 497,
  CREATURE_498 = 498,
  CREATURE_499 = 499,
  CREATURE_500 = 500,
  CREATURE_501 = 501,
  CREATURE_502 = 502,
  CREATURE_503 = 503,
  CREATURE_504 = 504,
  CREATURE_505 = 505,
  CREATURE_506 = 506,
  CREATURE_507 = 507,
  CREATURE_508 = 508,
  CREATURE_509 = 509,
  CREATURE_510 = 510,
  CREATURE_511 = 511,
  CREATURE_512 = 512,
  CREATURE_513 = 513,
  CREATURE_514 = 514,
  CREATURE_515 = 515,
  CREATURE_516 = 516,
  CREATURE_517 = 517,
  CREATURE_518 = 518,
  CREATURE_519 = 519,
  CREATURE_520 = 520,
  CREATURE_521 = 521,
  CREATURE_522 = 522,
  CREATURE_523 = 523,
  CREATURE_524 = 524,
  CREATURE_525 = 525,
  CREATURE_526 = 526,
  CREATURE_527 = 527,
  CREATURE_528 = 528,
  CREATURE_529 = 529,
  CREATURE_530 = 530,
  CREATURE_531 = 531,
  CREATURE_532 = 532,
  CREATURE_533 = 533,
  CREATURE_534 = 534,
  CREATURE_535 = 535,
  CREATURE_536 = 536,
  CREATURE_537 = 537,
  CREATURE_538 = 538,
  CREATURE_539 = 539,
  CREATURE_540 = 540,
  CREATURE_541 = 541,
  CREATURE_542 = 542,
  CREATURE_543 = 543,
  CREATURE_544 = 544,
  CREATURE_545 = 545,
  CREATURE_546 = 546,
  CREATURE_547 = 547,
  CREATURE_548 = 548,
  CREATURE_549 = 549,
  CREATURE_550 = 550,
  CREATURE_551 = 551,
  CREATURE_552 = 552,
  CREATURE_553 = 553,
  CREATURE_554 = 554,
  CREATURE_555 = 555,
  CREATURE_556 = 556,
  CREATURE_557 = 557,
  CREATURE_558 = 558,
  CREATURE_559 = 559,
  CREATURE_560 = 560,
  CREATURE_561 = 561,
  CREATURE_562 = 562,
  CREATURE_563 = 563,
  CREATURE_564 = 564,
  CREATURE_565 = 565,
  CREATURE_566 = 566,
  CREATURE_567 = 567,
  CREATURE_568 = 568,
  CREATURE_569 = 569,
  CREATURE_570 = 570,
  CREATURE_571 = 571,
  CREATURE_572 = 572,
  CREATURE_573 = 573,
  CREATURE_574 = 574,
  CREATURE_575 = 575,
  CREATURE_576 = 576,
  CREATURE_577 = 577,
  CREATURE_578 = 578,
  CREATURE_579 = 579,
  CREATURE_580 = 580,
  CREATURE_581 = 581,
  CREATURE_582 = 582,
  CREATURE_583 = 583,
  CREATURE_584 = 584,
  CREATURE_585 = 585,
  CREATURE_586 = 586,
  CREATURE_587 = 587,
  CREATURE_588 = 588,
  CREATURE_589 = 589,
  CREATURE_590 = 590,
  CREATURE_591 = 591,
  CREATURE_592 = 592,
  CREATURE_593 = 593,
  CREATURE_594 = 594,
  CREATURE_595 = 595,
  CREATURE_596 = 596,
  CREATURE_597 = 597,
  CREATURE_598 = 598,
  CREATURE_599 = 599,
  CREATURE_600 = 600,
  CREATURE_601 = 601,
  CREATURE_602 = 602,
  CREATURE_603 = 603,
  CREATURE_604 = 604,
  CREATURE_605 = 605,
  CREATURE_606 = 606,
  CREATURE_607 = 607,
  CREATURE_608 = 608,
  CREATURE_609 = 609,
  CREATURE_610 = 610,
  CREATURE_611 = 611,
  CREATURE_612 = 612,
  CREATURE_613 = 613,
  CREATURE_614 = 614,
  CREATURE_615 = 615,
  CREATURE_616 = 616,
  CREATURE_617 = 617,
  CREATURE_618 = 618,
  CREATURE_619 = 619,
  CREATURE_620 = 620,
  CREATURE_621 = 621,
  CREATURE_622 = 622,
  CREATURE_623 = 623,
  CREATURE_624 = 624,
  CREATURE_625 = 625,
  CREATURE_626 = 626,
  CREATURE_627 = 627,
  CREATURE_628 = 628,
  CREATURE_629 = 629,
  CREATURE_630 = 630,
  CREATURE_631 = 631,
  CREATURE_632 = 632,
  CREATURE_633 = 633,
  CREATURE_634 = 634,
  CREATURE_635 = 635,
  CREATURE_636 = 636,
  CREATURE_637 = 637,
  CREATURE_638 = 638,
  CREATURE_639 = 639,
  CREATURE_640 = 640,
  CREATURE_641 = 641,
  CREATURE_642 = 642,
  CREATURE_643 = 643,
  CREATURE_644 = 644,
  CREATURE_645 = 645,
  CREATURE_646 = 646,
  CREATURE_647 = 647,
  CREATURE_648 = 648,
  CREATURE_649 = 649,
  CREATURE_650 = 650,
  CREATURE_651 = 651,
  CREATURE_652 = 652,
  CREATURE_653 = 653,
  CREATURE_654 = 654,
  CREATURE_655 = 655,
  CREATURE_656 = 656,
  CREATURE_657 = 657,
  CREATURE_658 = 658,
  CREATURE_659 = 659,
  CREATURE_660 = 660,
  CREATURE_661 = 661,
  CREATURE_662 = 662,
  CREATURE_663 = 663,
  CREATURE_664 = 664,
  CREATURE_665 = 665,
  CREATURE_666 = 666,
  CREATURE_667 = 667,
  CREATURE_668 = 668,
  CREATURE_669 = 669,
  CREATURE_670 = 670,
  CREATURE_671 = 671,
  CREATURE_672 = 672,
  CREATURE_673 = 673,
  CREATURE_674 = 674,
  CREATURE_675 = 675,
  CREATURE_676 = 676,
  CREATURE_677 = 677,
  CREATURE_678 = 678,
  CREATURE_679 = 679,
  CREATURE_680 = 680,
  CREATURE_681 = 681,
  CREATURE_682 = 682,
  CREATURE_683 = 683,
  CREATURE_684 = 684,
  CREATURE_685 = 685,
  CREATURE_686 = 686,
  CREATURE_687 = 687,
  CREATURE_688 = 688,
  CREATURE_689 = 689,
  CREATURE_690 = 690,
  CREATURE_691 = 691,
  CREATURE_692 = 692,
  CREATURE_693 = 693,
  CREATURE_694 = 694,
  CREATURE_695 = 695,
  CREATURE_696 = 696,
  CREATURE_697 = 697,
  CREATURE_698 = 698,
  CREATURE_699 = 699,
  CREATURE_700 = 700,
  CREATURE_701 = 701,
  CREATURE_702 = 702,
  CREATURE_703 = 703,
  CREATURE_704 = 704,
  CREATURE_705 = 705,
  CREATURE_706 = 706,
  CREATURE_707 = 707,
  CREATURE_708 = 708,
  CREATURE_709 = 709,
  CREATURE_710 = 710,
  CREATURE_711 = 711,
  CREATURE_712 = 712,
  CREATURE_713 = 713,
  CREATURE_714 = 714,
  CREATURE_715 = 715,
  CREATURE_716 = 716,
  CREATURE_717 = 717,
  CREATURE_718 = 718,
  CREATURE_719 = 719,
  CREATURE_720 = 720,
  CREATURE_721 = 721,
  CREATURE_722 = 722,
  CREATURE_723 = 723,
  CREATURE_724 = 724,
  CREATURE_725 = 725,
  CREATURE_726 = 726,
  CREATURE_727 = 727,
  CREATURE_728 = 728,
  CREATURE_729 = 729,
  CREATURE_730 = 730,
  CREATURE_731 = 731,
  CREATURE_732 = 732,
  CREATURE_733 = 733,
  CREATURE_734 = 734,
  CREATURE_735 = 735,
  CREATURE_736 = 736,
  CREATURE_737 = 737,
  CREATURE_738 = 738,
  CREATURE_739 = 739,
  CREATURE_740 = 740,
  CREATURE_741 = 741,
  CREATURE_742 = 742,
  CREATURE_743 = 743,
  CREATURE_744 = 744,
  CREATURE_745 = 745,
  CREATURE_746 = 746,
  CREATURE_747 = 747,
  CREATURE_748 = 748,
  CREATURE_749 = 749,
  CREATURE_750 = 750,
  CREATURE_751 = 751,
  CREATURE_752 = 752,
  CREATURE_753 = 753,
  CREATURE_754 = 754,
  CREATURE_755 = 755,
  CREATURE_756 = 756,
  CREATURE_757 = 757,
  CREATURE_758 = 758,
  CREATURE_759 = 759,
  CREATURE_760 = 760,
  CREATURE_761 = 761,
  CREATURE_762 = 762,
  CREATURE_763 = 763,
  CREATURE_764 = 764,
  CREATURE_765 = 765,
  CREATURE_766 = 766,
  CREATURE_767 = 767,
  CREATURE_768 = 768,
  CREATURE_769 = 769,
  CREATURE_770 = 770,
  CREATURE_771 = 771,
  CREATURE_772 = 772,
  CREATURE_773 = 773,
  CREATURE_774 = 774,
  CREATURE_775 = 775,
  CREATURE_776 = 776,
  CREATURE_777 = 777,
  CREATURE_778 = 778,
  CREATURE_779 = 779,
  CREATURE_780 = 780,
  CREATURE_781 = 781,
  CREATURE_782 = 782,
  CREATURE_783 = 783,
  CREATURE_784 = 784,
  CREATURE_785 = 785,
  CREATURE_786 = 786,
  CREATURE_787 = 787,
  CREATURE_788 = 788,
  CREATURE_789 = 789,
  CREATURE_790 = 790,
  CREATURE_791 = 791,
  CREATURE_792 = 792,
  CREATURE_793 = 793,
  CREATURE_794 = 794,
  CREATURE_795 = 795,
  CREATURE_796 = 796,
  CREATURE_797 = 797,
  CREATURE_798 = 798,
  CREATURE_799 = 799,
  CREATURE_800 = 800,
  CREATURE_801 = 801,
  CREATURE_802 = 802,
  CREATURE_803 = 803,
  CREATURE_804 = 804,
  CREATURE_805 = 805,
  CREATURE_806 = 806,
  CREATURE_807 = 807,
  CREATURE_808 = 808,
  CREATURE_809 = 809,
  CREATURE_810 = 810,
  CREATURE_811 = 811,
  CREATURE_812 = 812,
  CREATURE_813 = 813,
  CREATURE_814 = 814,
  CREATURE_815 = 815,
  CREATURE_816 = 816,
  CREATURE_817 = 817,
  CREATURE_818 = 818,
  CREATURE_819 = 819,
  CREATURE_820 = 820,
  CREATURE_821 = 821,
  CREATURE_822 = 822,
  CREATURE_823 = 823,
  CREATURE_824 = 824,
  CREATURE_825 = 825,
  CREATURE_826 = 826,
  CREATURE_827 = 827,
  CREATURE_828 = 828,
  CREATURE_829 = 829,
  CREATURE_830 = 830,
  CREATURE_831 = 831,
  CREATURE_832 = 832,
  CREATURE_833 = 833,
  CREATURE_834 = 834,
  CREATURE_835 = 835,
  CREATURE_836 = 836,
  CREATURE_837 = 837,
  CREATURE_838 = 838,
  CREATURE_839 = 839,
  CREATURE_840 = 840,
  CREATURE_841 = 841,
  CREATURE_842 = 842,
  CREATURE_843 = 843,
  CREATURE_844 = 844,
  CREATURE_845 = 845,
  CREATURE_846 = 846,
  CREATURE_847 = 847,
  CREATURE_848 = 848,
  CREATURE_849 = 849,
  CREATURE_850 = 850,
  CREATURE_851 = 851,
  CREATURE_852 = 852,
  CREATURE_853 = 853,
  CREATURE_854 = 854,
  CREATURE_855 = 855,
  CREATURE_856 = 856,
  CREATURE_857 = 857,
  CREATURE_858 = 858,
  CREATURE_859 = 859,
  CREATURE_860 = 860,
  CREATURE_861 = 861,
  CREATURE_862 = 862,
  CREATURE_863 = 863,
  CREATURE_864 = 864,
  CREATURE_865 = 865,
  CREATURE_866 = 866,
  CREATURE_867 = 867,
  CREATURE_868 = 868,
  CREATURE_869 = 869,
  CREATURE_870 = 870,
  CREATURE_871 = 871,
  CREATURE_872 = 872,
  CREATURE_873 = 873,
  CREATURE_874 = 874,
  CREATURE_875 = 875,
  CREATURE_876 = 876,
  CREATURE_877 = 877,
  CREATURE_878 = 878,
  CREATURE_879 = 879,
  CREATURE_880 = 880,
  CREATURE_881 = 881,
  CREATURE_882 = 882,
  CREATURE_883 = 883,
  CREATURE_884 = 884,
  CREATURE_885 = 885,
  CREATURE_886 = 886,
  CREATURE_887 = 887,
  CREATURE_888 = 888,
  CREATURE_889 = 889,
  CREATURE_890 = 890,
  CREATURE_891 = 891,
  CREATURE_892 = 892,
  CREATURE_893 = 893,
  CREATURE_894 = 894,
  CREATURE_895 = 895,
  CREATURE_896 = 896,
  CREATURE_897 = 897,
  CREATURE_898 = 898,
  CREATURE_899 = 899,
  CREATURE_900 = 900,
  CREATURE_901 = 901,
  CREATURE_902 = 902,
  CREATURE_903 = 903,
  CREATURE_904 = 904,
  CREATURE_905 = 905,
  CREATURE_906 = 906,
  CREATURE_907 = 907,
  CREATURE_908 = 908,
  CREATURE_909 = 909,
  CREATURE_910 = 910,
  CREATURE_911 = 911,
  CREATURE_912 = 912,
  CREATURE_913 = 913,
  CREATURE_914 = 914,
  CREATURE_915 = 915,
  CREATURE_916 = 916,
  CREATURE_917 = 917,
  CREATURE_918 = 918,
  CREATURE_919 = 919,
  CREATURE_920 = 920,
  CREATURE_921 = 921,
  CREATURE_922 = 922,
  CREATURE_923 = 923,
  CREATURE_924 = 924,
  CREATURE_925 = 925,
  CREATURE_926 = 926,
  CREATURE_927 = 927,
  CREATURE_928 = 928,
  CREATURE_929 = 929,
  CREATURE_930 = 930,
  CREATURE_931 = 931,
  CREATURE_932 = 932,
  CREATURE_933 = 933,
  CREATURE_934 = 934,
  CREATURE_935 = 935,
  CREATURE_936 = 936,
  CREATURE_937 = 937,
  CREATURE_938 = 938,
  CREATURE_939 = 939,
  CREATURE_940 = 940,
  CREATURE_941 = 941,
  CREATURE_942 = 942,
  CREATURE_943 = 943,
  CREATURE_944 = 944,
  CREATURE_945 = 945,
  CREATURE_946 = 946,
  CREATURE_947 = 947,
  CREATURE_948 = 948,
  CREATURE_949 = 949,
  CREATURE_950 = 950,
  CREATURE_951 = 951,
  CREATURE_952 = 952,
  CREATURE_953 = 953,
  CREATURE_954 = 954,
  CREATURE_955 = 955,
  CREATURE_956 = 956,
  CREATURE_957 = 957,
  CREATURE_958 = 958,
  CREATURE_959 = 959,
  CREATURE_960 = 960,
  CREATURE_961 = 961,
  CREATURE_962 = 962,
  CREATURE_963 = 963,
  CREATURE_964 = 964,
  CREATURE_965 = 965,
  CREATURE_966 = 966,
  CREATURE_967 = 967,
  CREATURE_968 = 968,
  CREATURE_969 = 969,
  CREATURE_970 = 970,
  CREATURE_971 = 971,
  CREATURE_972 = 972,
  CREATURE_973 = 973,
  CREATURE_974 = 974,
  CREATURE_975 = 975,
  CREATURE_976 = 976,
  CREATURE_977 = 977,
  CREATURE_978 = 978,
  CREATURE_979 = 979,
  CREATURE_980 = 980,
  CREATURE_981 = 981,
  CREATURE_982 = 982,
  CREATURE_983 = 983,
  CREATURE_984 = 984,
  CREATURE_985 = 985,
  CREATURE_986 = 986,
  CREATURE_987 = 987,
  CREATURE_988 = 988,
  CREATURE_989 = 989,
  CREATURE_990 = 990,
  CREATURE_991 = 991,
  CREATURE_992 = 992,
  CREATURE_993 = 993,
  CREATURE_994 = 994,
  CREATURE_995 = 995,
  CREATURE_996 = 996,
  CREATURE_997 = 997,
  CREATURE_998 = 998,
  CREATURE_999 = 999,
  CREATURE_ACIDIC_HYDRA = 142,
  CREATURE_AIR_ELEMENTAL = 88,
  CREATURE_ANGEL = 13,
  CREATURE_ANGER_TREANT = 150,
  CREATURE_ARCHANGEL = 14,
  CREATURE_ARCHDEVIL = 28,
  CREATURE_ARCHER = 3,
  CREATURE_ARCH_DEMON = 137,
  CREATURE_ARCH_MAGI = 64,
  CREATURE_ASSASSIN = 72,
  CREATURE_AXE_FIGHTER = 94,
  CREATURE_AXE_THROWER = 95,
  CREATURE_BALOR = 26,
  CREATURE_BANSHEE = 157,
  CREATURE_BATTLE_GRIFFIN = 109,
  CREATURE_BATTLE_RAGER = 169,
  CREATURE_BEAR_RIDER = 96,
  CREATURE_BERSERKER = 99,
  CREATURE_BLACKBEAR_RIDER = 97,
  CREATURE_BLACK_DRAGON = 84,
  CREATURE_BLACK_KNIGHT = 89,
  CREATURE_BLACK_RIDER = 141,
  CREATURE_BLADE_JUGGLER = 45,
  CREATURE_BLADE_SINGER = 146,
  CREATURE_BLOOD_WITCH = 74,
  CREATURE_BLOOD_WITCH_2 = 139,
  CREATURE_BONE_DRAGON = 41,
  CREATURE_BROWLER = 98,
  CREATURE_CAVALIER = 11,
  CREATURE_CENTAUR = 119,
  CREATURE_CENTAUR_MARADEUR = 174,
  CREATURE_CENTAUR_NOMAD = 120,
  CREATURE_CERBERI = 20,
  CREATURE_CHAMPION = 111,
  CREATURE_CHAOS_HYDRA = 80,
  CREATURE_CLERIC = 10,
  CREATURE_COMBAT_MAGE = 162,
  CREATURE_CYCLOP = 129,
  CREATURE_CYCLOP_BLOODEYED = 179,
  CREATURE_CYCLOP_UNTAMED = 130,
  CREATURE_DEATH_KNIGHT = 90,
  CREATURE_DEEP_DRAGON = 83,
  CREATURE_DEFENDER = 92,
  CREATURE_DEMILICH = 38,
  CREATURE_DEMON = 17,
  CREATURE_DEVIL = 27,
  CREATURE_DISEASE_ZOMBIE = 153,
  CREATURE_DJINN_VIZIER = 163,
  CREATURE_DRUID = 49,
  CREATURE_DRUID_ELDER = 50,
  CREATURE_DRYAD = 145,
  CREATURE_EARTH_ELEMENTAL = 87,
  CREATURE_FAMILIAR = 15,
  CREATURE_FIREBREATHER_HOUND = 133,
  CREATURE_FIRE_DRAGON = 104,
  CREATURE_FIRE_ELEMENTAL = 85,
  CREATURE_FLAME_KEEPER = 170,
  CREATURE_FLAME_MAGE = 101,
  CREATURE_FOOTMAN = 5,
  CREATURE_FRIGHTFUL_NIGHTMARE = 24,
  CREATURE_GENIE = 65,
  CREATURE_GHOST = 34,
  CREATURE_GIANT = 69,
  CREATURE_GOBLIN = 117,
  CREATURE_GOBLIN_DEFILER = 173,
  CREATURE_GOBLIN_TRAPPER = 118,
  CREATURE_GOLD_DRAGON = 56,
  CREATURE_GRAND_ELF = 48,
  CREATURE_GREEN_DRAGON = 55,
  CREATURE_GREMLIN = 57,
  CREATURE_GREMLIN_SABOTEUR = 159,
  CREATURE_GRIFFIN = 7,
  CREATURE_HARPOONER = 167,
  CREATURE_HELLMARE = 135,
  CREATURE_HELL_HOUND = 19,
  CREATURE_HIGH_DRUID = 148,
  CREATURE_HORNED_DEMON = 18,
  CREATURE_HORNED_LEAPER = 132,
  CREATURE_HORROR_DRAGON = 158,
  CREATURE_HYDRA = 79,
  CREATURE_IMP = 16,
  CREATURE_INFERNAL_SUCCUBUS = 22,
  CREATURE_IRON_GOLEM = 61,
  CREATURE_LANDLORD = 106,
  CREATURE_LAVA_DRAGON = 172,
  CREATURE_LICH = 37,
  CREATURE_LICH_MASTER = 156,
  CREATURE_LONGBOWMAN = 107,
  CREATURE_MAGI = 63,
  CREATURE_MAGMA_DRAGON = 105,
  CREATURE_MANES = 33,
  CREATURE_MANTICORE = 115,
  CREATURE_MARBLE_GARGOYLE = 160,
  CREATURE_MARKSMAN = 4,
  CREATURE_MASTER_GENIE = 66,
  CREATURE_MASTER_GREMLIN = 58,
  CREATURE_MATRIARCH = 82,
  CREATURE_MATRON = 81,
  CREATURE_MILITIAMAN = 2,
  CREATURE_MINOTAUR = 75,
  CREATURE_MINOTAUR_CAPTAIN = 140,
  CREATURE_MINOTAUR_KING = 76,
  CREATURE_MUMMY = 116,
  CREATURE_NIGHTMARE = 23,
  CREATURE_NOSFERATU = 155,
  CREATURE_OBSIDIAN_GARGOYLE = 60,
  CREATURE_OBSIDIAN_GOLEM = 161,
  CREATURE_ORCCHIEF_BUTCHER = 125,
  CREATURE_ORCCHIEF_CHIEFTAIN = 177,
  CREATURE_ORCCHIEF_EXECUTIONER = 126,
  CREATURE_ORC_SLAYER = 122,
  CREATURE_ORC_WARMONGER = 175,
  CREATURE_ORC_WARRIOR = 121,
  CREATURE_PALADIN = 12,
  CREATURE_PEASANT = 1,
  CREATURE_PHOENIX = 91,
  CREATURE_PIT_FIEND = 25,
  CREATURE_PIT_SPAWN = 136,
  CREATURE_PIXIE = 43,
  CREATURE_POLTERGEIST = 154,
  CREATURE_PRIEST = 9,
  CREATURE_QUASIT = 131,
  CREATURE_RAINBOW_DRAGON = 151,
  CREATURE_RAKSHASA = 67,
  CREATURE_RAKSHASA_KSHATRI = 164,
  CREATURE_RAKSHASA_RUKH = 68,
  CREATURE_RAVAGER = 78,
  CREATURE_RED_DRAGON = 144,
  CREATURE_RIDER = 77,
  CREATURE_ROYAL_GRIFFIN = 8,
  CREATURE_RUNE_MAGE = 100,
  CREATURE_SCOUT = 71,
  CREATURE_SERAPH = 112,
  CREATURE_SHADOW_DRAGON = 42,
  CREATURE_SHADOW_MISTRESS = 143,
  CREATURE_SHAMAN = 123,
  CREATURE_SHAMAN_HAG = 176,
  CREATURE_SHAMAN_WITCH = 124,
  CREATURE_SHARP_SHOOTER = 147,
  CREATURE_SKELETON = 29,
  CREATURE_SKELETON_ARCHER = 30,
  CREATURE_SKELETON_WARRIOR = 152,
  CREATURE_SNOW_APE = 114,
  CREATURE_SPRITE = 44,
  CREATURE_STALKER = 138,
  CREATURE_STEEL_GOLEM = 62,
  CREATURE_STONE_DEFENDER = 166,
  CREATURE_STONE_GARGOYLE = 59,
  CREATURE_STORM_LORD = 165,
  CREATURE_STOUT_DEFENDER = 93,
  CREATURE_SUCCUBUS = 21,
  CREATURE_SUCCUBUS_SEDUCER = 134,
  CREATURE_SWORDSMAN = 6,
  CREATURE_THANE = 102,
  CREATURE_THUNDER_THANE = 171,
  CREATURE_TITAN = 70,
  CREATURE_TREANT = 53,
  CREATURE_TREANT_GUARDIAN = 54,
  CREATURE_UNICORN = 51,
  CREATURE_UNKNOWN = 0,
  CREATURE_VAMPIRE = 35,
  CREATURE_VAMPIRE_LORD = 36,
  CREATURE_VINDICATOR = 108,
  CREATURE_WALKING_DEAD = 31,
  CREATURE_WARLORD = 103,
  CREATURE_WAR_DANCER = 46,
  CREATURE_WAR_UNICORN = 52,
  CREATURE_WATER_ELEMENTAL = 86,
  CREATURE_WHITE_BEAR_RIDER = 168,
  CREATURE_WHITE_UNICORN = 149,
  CREATURE_WIGHT = 39,
  CREATURE_WITCH = 73,
  CREATURE_WOLF = 113,
  CREATURE_WOOD_ELF = 47,
  CREATURE_WRAITH = 40,
  CREATURE_WYVERN = 127,
  CREATURE_WYVERN_PAOKAI = 178,
  CREATURE_WYVERN_POISONOUS = 128,
  CREATURE_ZEALOT = 110,
  CREATURE_ZOMBIE = 32,
}

-- ACTUAL_DATA: Fill creature→ability ids for precise checks
CREATURE_ABILITY_MAP = CREATURE_ABILITY_MAP or {
  -- [CREATURE.IMP.id] = { ABILITY.NO_RETALIATION.id, ABILITY.UNDEAD.id },
}

    function _H55_ToUpper(s)
      if s == nil then return nil end
      return string.upper(s)
    end

-- Lua 4-compatible table length (array part)
function _H55_Getn(t)
  if t == nil then return 0 end
  H55_N = 0
  while t[H55_N + 1] ~= nil do H55_N = H55_N + 1 end
  return H55_N
end

-- Lua 4-compatible join for simple string arrays
function _H55_Join(t, sep)
  if t == nil then return '' end
  H55_BUF = ''
  H55_I = 1
  H55_N = _H55_Getn(t)
  while H55_I <= H55_N do
    H55_BUF = H55_BUF .. t[H55_I]
    if H55_I < H55_N then H55_BUF = H55_BUF .. sep end
    H55_I = H55_I + 1
  end
  return H55_BUF
end

function _H55_ParseToken(s)
  if s == nil then return nil, nil end
  s = _H55_ToUpper(s)
  H55_TMP_DOT = string.find(s, '%.')
  if H55_TMP_DOT then
    H55_TMP_LEFT = string.sub(s, 1, H55_TMP_DOT-1)
    H55_TMP_RIGHT = string.sub(s, H55_TMP_DOT+1)
    return H55_TMP_LEFT, H55_TMP_RIGHT
  end
  if string.find(s, 'HERO_SKILL_') == 1 then return 'HERO', s end
  if string.find(s, 'ABILITY_') == 1 then return 'ABILITY', s end
  if string.find(s, 'CREATURE_') == 1 then return 'CREATURE', s end
  return nil, s
end

function _H55_Suggest(domain, tail)
  H55_RES = {}
  H55_MAP = nil
  if domain == 'HERO' then H55_MAP = H55_HERO_BY_TAIL
  elseif domain == 'ABILITY' then H55_MAP = H55_ABILITY_BY_TAIL
  elseif domain == 'CREATURE' then H55_MAP = H55_CREATURE_BY_TAIL
  else return H55_RES end
  H55_KEY = next(H55_MAP, nil)
  while H55_KEY do
    if string.find(H55_KEY, tail, 1, true) then
      H55_RES[_H55_Getn(H55_RES)+1] = H55_KEY
      if _H55_Getn(H55_RES) >= 10 then return H55_RES end
    end
    H55_KEY = next(H55_MAP, H55_KEY)
  end
  return H55_RES
end

function _H55_Resolve(domain, token)
  if type(token) == 'number' then return token end
  H55_D, H55_T = _H55_ParseToken(token)
  if H55_D == 'HERO' or (domain == 'HERO' and H55_D == nil) then
    if H55_D == 'HERO' then
      H55_ID = H55_HERO_BY_CONST[H55_T]
      if H55_ID then return H55_ID end
      error('Unknown hero skill const: '..H55_T)
    end
    H55_IDS = H55_HERO_BY_TAIL[H55_T]
    if H55_IDS and H55_IDS[1] then
      if _H55_Getn(H55_IDS) > 1 then error('Ambiguous hero skill tail '..H55_T..' matches multiple IDs; pass full const or domain prefix') end
      return H55_IDS[1]
    end
    H55_SUG = _H55_Suggest('HERO', H55_T)
    error('Unknown hero skill/perk tail: '..H55_T..' ; suggestions: '.._H55_Join(H55_SUG, ', '))
  elseif H55_D == 'ABILITY' or domain == 'ABILITY' then
    if H55_D == 'ABILITY' then
      H55_ID = H55_ABILITY_BY_CONST[H55_T]
      if H55_ID then return H55_ID end
      error('Unknown ability const: '..H55_T)
    end
    H55_IDS = H55_ABILITY_BY_TAIL[H55_T]
    if H55_IDS and H55_IDS[1] then
      if _H55_Getn(H55_IDS) > 1 then error('Ambiguous ability tail '..H55_T) end
      return H55_IDS[1]
    end
    H55_SUG = _H55_Suggest('ABILITY', H55_T)
    error('Unknown ability tail: '..H55_T..' ; suggestions: '.._H55_Join(H55_SUG, ', '))
  elseif H55_D == 'CREATURE' or domain == 'CREATURE' then
    if H55_D == 'CREATURE' then
      H55_ID = H55_CREATURE_BY_CONST[H55_T]
      if H55_ID then return H55_ID end
      error('Unknown creature const: '..H55_T)
    end
    H55_IDS = H55_CREATURE_BY_TAIL[H55_T]
    if H55_IDS and H55_IDS[1] then
      if _H55_Getn(H55_IDS) > 1 then error('Ambiguous creature tail '..H55_T) end
      return H55_IDS[1]
    end
    H55_SUG = _H55_Suggest('CREATURE', H55_T)
    error('Unknown creature tail: '..H55_T..' ; suggestions: '.._H55_Join(H55_SUG, ', '))
  else
    H55_OK, H55_ID = pcall(H55_Resolve, 'HERO', H55_T)
    if H55_OK then return H55_ID end
    H55_OK, H55_ID = pcall(H55_Resolve, 'ABILITY', H55_T)
    if H55_OK then return H55_ID end
    H55_OK, H55_ID = pcall(H55_Resolve, 'CREATURE', H55_T)
    if H55_OK then return H55_ID end
    error('Cannot resolve token: '..H55_T)
  end
end

function _H55_ConstById(domain, id)
  if domain == 'HERO' then
    H55_K = next(H55_HERO_BY_CONST, nil)
    while H55_K do if H55_HERO_BY_CONST[H55_K] == id then return H55_K end; H55_K = next(H55_HERO_BY_CONST, H55_K) end
  elseif domain == 'ABILITY' then
    H55_K = next(H55_ABILITY_BY_CONST, nil)
    while H55_K do if H55_ABILITY_BY_CONST[H55_K] == id then return H55_K end; H55_K = next(H55_ABILITY_BY_CONST, H55_K) end
  elseif domain == 'CREATURE' then
    H55_K = next(H55_CREATURE_BY_CONST, nil)
    while H55_K do if H55_CREATURE_BY_CONST[H55_K] == id then return H55_K end; H55_K = next(H55_CREATURE_BY_CONST, H55_K) end
  end
  return nil
end

--[[ Usage: if _H55_HeroHas('Agrael','PATHFINDING') then ... end ]]
function _H55_HeroHas(heroName, token)
  H55_ID = _H55_Resolve('HERO', token)
  return HasHeroSkill(heroName, H55_ID)
end

--[[ Usage: _H55_AddHeroPerk('Agrael','PATHFINDING') ]]
function _H55_AddHeroPerk(heroName, token)
  H55_ID = _H55_Resolve('HERO', token)
  GiveHeroSkill(heroName, H55_ID)
end

--[[ Usage: _H55_AddHeroSkill('Agrael','TACTICS') ]]
function _H55_AddHeroSkill(heroName, token)
  H55_ID = _H55_Resolve('HERO', token)
  GiveHeroSkill(heroName, H55_ID)
end

--[[ Usage: _H55_EnsureHeroHas('Agrael','HERO_SKILL_TACTICS') ]]
function _H55_EnsureHeroHas(heroName, token)
  H55_ID = _H55_Resolve('HERO', token)
  if not HasHeroSkill(heroName, H55_ID) then GiveHeroSkill(heroName, H55_ID) end
end

--[[ Usage: _H55_CreatureHasAbility('IMP','NO_RETALIATION') ]]
function _H55_CreatureHasAbility(creatureToken, abilityToken)
  H55_CID = _H55_Resolve('CREATURE', creatureToken)
  H55_AID = _H55_Resolve('ABILITY', abilityToken)
  H55_SET = CREATURE_ABILITY_MAP[H55_CID]
  if H55_SET == nil then return false end
  if type(H55_SET) == 'table' then
    H55_I = 1
    while H55_SET[H55_I] do if H55_SET[H55_I] == H55_AID then return true end; H55_I = H55_I + 1 end
    if H55_SET[H55_AID] ~= nil then return true end
  end
  return false
end




-- =====================================================================
-- Backward-compatibility aliases (DEPRECATED):
-- Old H55_* names continue to work by forwarding to _H55_* implementations.
-- You can remove this section once all scripts have migrated.
-- =====================================================================

-- DEPRECATED: use _H55_ToUpper(...)
function H55_ToUpper(...)
  return _H55_ToUpper(...)
end

-- DEPRECATED: use _H55_Getn(...)
function H55_Getn(...)
  return _H55_Getn(...)
end

-- DEPRECATED: use _H55_Join(...)
function H55_Join(...)
  return _H55_Join(...)
end

-- DEPRECATED: use _H55_ParseToken(...)
function H55_ParseToken(...)
  return _H55_ParseToken(...)
end

-- DEPRECATED: use _H55_Suggest(...)
function H55_Suggest(...)
  return _H55_Suggest(...)
end

-- DEPRECATED: use _H55_Resolve(...)
function H55_Resolve(...)
  return _H55_Resolve(...)
end

-- DEPRECATED: use _H55_ConstById(...)
function H55_ConstById(...)
  return _H55_ConstById(...)
end

-- DEPRECATED: use _H55_HeroHas(...)
function H55_HeroHas(...)
  return _H55_HeroHas(...)
end

-- DEPRECATED: use _H55_AddHeroPerk(...)
function H55_AddHeroPerk(...)
  return _H55_AddHeroPerk(...)
end

-- DEPRECATED: use _H55_AddHeroSkill(...)
function H55_AddHeroSkill(...)
  return _H55_AddHeroSkill(...)
end

-- DEPRECATED: use _H55_EnsureHeroHas(...)
function H55_EnsureHeroHas(...)
  return _H55_EnsureHeroHas(...)
end

-- DEPRECATED: use _H55_CreatureHasAbility(...)
function H55_CreatureHasAbility(...)
  return _H55_CreatureHasAbility(...)
end



-- =====================================================================
-- H55 SKILL ⇢ PERKS TABLE (single source of truth for UI & logic)
--
-- Each row starts with a base skill token, followed by its perks.
-- Tokens can be either strings (e.g., 'LOGISTICS','PATHFINDING') or
-- numeric IDs. At runtime we normalize with _H55_Resolve('HERO_SKILL',token).
-- NOTE: This list is intentionally partial. Extend safely by adding rows.
-- =====================================================================
H55_HERO_SKILL_TREE_ROWS = H55_HERO_SKILL_TREE_ROWS or {
  -- LOGISTICS
  { 'LOGISTICS', 'PATHFINDING', 'SCOUTING', 'NAVIGATION', 'SNATCH', 'ROAD_HOME' },
  -- DEFENCE
  { 'DEFENCE', 'EVASION', 'PROTECTION', 'TOUGHNESS', 'DEFENSIVE_FORMATION', 'HOLD_GROUND' },
  -- OFFENCE
  { 'OFFENCE', 'BATTLE_FRENZY', 'ARCHERY', 'Tactics', 'Payback', 'Preparation' }, -- 'ARCHERY','TACTICS','PAYBACK','PREPARATION' exist in H55; check IDs
  -- LEADERSHIP
  { 'LEADERSHIP', 'RECRUITMENT', 'ESTATES', 'DIPLOMACY', 'GUARDIAN_ANGEL', 'EMPATHY' },
  -- LUCK
  { 'LUCK', 'ELVEN_LUCK', 'DWARVEN_LUCK', 'LUCKY_STRIKE', 'LUCKY_SPELLS', 'FORTUNATE_ADVENTURER' },
  -- SORCERY
  { 'SORCERY', 'QUICKNESS_OF_MIND', 'SUPRESS_DARK', 'SUPRESS_LIGHT', 'COUNTERSPELL' },
  -- LIGHT MAGIC
  { 'LIGHT_MAGIC', 'ETERNAL_LIGHT', 'MASTER_OF_ABJURATION', 'MASTER_OF_BLESSING', 'GUARDIAN_ANGEL' },
  -- DARK MAGIC
  { 'DARK_MAGIC', 'ELEMENTAL_BALANCE', 'MIND_BREAKER', 'CORRUPT_LIGHT', 'WEAKEN_LIGHT' },
  -- DESTRUCTIVE MAGIC
  { 'DESTRUCTIVE_MAGIC', 'FIRE_AFFINITY', 'SECRETS_OF_DESTRUCTION', 'MASTER_OF_FIRE', 'MASTER_OF_ICE', 'MASTER_OF_LIGHTNINGS' },
  -- SUMMONING MAGIC
  { 'SUMMONING_MAGIC', 'ELEMENTAL_VISION', 'MASTER_OF_CREATURES', 'MASTER_OF_ANIMATION', 'MASTER_OF_QUAKES' },
  -- WAR MACHINES
  { 'WAR_MACHINES', 'FIRST_AID', 'CATAPULT', 'BALLISTA', 'TRIPLE_BALLISTA', 'TRIPLE_CATAPULT' },
  -- TRAINING (HAVEN)
  { 'TRAINING', 'EXPERT_TRAINER', 'HOLY_CHARGE', 'MENTORING', 'RETRIBUTION' },
  -- ARTIFICIER (ACADEMY)
  { 'ARTIFICIER', 'MARCH_OF_THE_MACHINES', 'REMOTE_CONTROL', 'LAST_AID', 'ACADEMY_AFFINITY' },
  -- AVENGER (SYLVAN)
  { 'AVENGER', 'FOREST_RAGE', 'CUNNING_OF_THE_WOODS', 'FOREST_GUARD_EMBLEM' },
  -- NECROMANCY
  { 'NECROMANCY', 'HAUNT_MINE', 'LORD_OF_UNDEAD', 'SPELLPROOF_BONES', 'DEATH_TREAD' },
  -- RUNELORE (FORTRESS)
  { 'RUNELORE', 'RUNIC_ARMOR', 'STRONG_RUNE', 'REFRESH_RUNE', 'FINE_RUNE', 'TAP_RUNES' },
  -- BARBARIAN SHATTERS
  { 'SHATTER_DESTRUCTIVE_MAGIC', 'CORRUPT_DESTRUCTIVE', 'WEAKEN_DESTRUCTIVE' },
  { 'SHATTER_LIGHT_MAGIC', 'CORRUPT_LIGHT', 'WEAKEN_LIGHT' },
  { 'SHATTER_DARK_MAGIC', 'CORRUPT_DARK', 'WEAKEN_DARK' },
  { 'SHATTER_SUMMONING_MAGIC', 'CORRUPT_SUMMONING', 'WEAKEN_SUMMONING' },
}

-- Converts H55_HERO_SKILL_TREE_ROWS into two fast lookup maps:
--   H55_PERKS_BY_SKILL[id(skill)] = { id(perk1)=true, id(perk2)=true, ... }
--   H55_SKILL_OF_PERK[id(perk)] = id(skill)
-- Call this once on load.
function _H55_BuildSkillTrees()
  H55_PERKS_BY_SKILL = {}
  H55_SKILL_OF_PERK = {}
  H55_I = 1
  while H55_HERO_SKILL_TREE_ROWS[H55_I] do
    H55_ROW = H55_HERO_SKILL_TREE_ROWS[H55_I]
    -- row[1] is base skill
    H55_SK_TOKEN = H55_ROW[1]
    H55_SK_ID = _H55_Resolve('HERO_SKILL', H55_SK_TOKEN)
    if H55_SK_ID then
      if H55_PERKS_BY_SKILL[H55_SK_ID] == nil then H55_PERKS_BY_SKILL[H55_SK_ID] = {} end
      -- iterate over perks columns: 2..n
      H55_J = 2
      while H55_ROW[H55_J] do
        H55_PK_TOKEN = H55_ROW[H55_J]
        H55_PK_ID = _H55_Resolve('HERO_SKILL', H55_PK_TOKEN)  -- perks share HERO_SKILL id space
        if H55_PK_ID then
          H55_PERKS_BY_SKILL[H55_SK_ID][H55_PK_ID] = true
          H55_SKILL_OF_PERK[H55_PK_ID] = H55_SK_ID
        end
        H55_J = H55_J + 1
      end
    end
    H55_I = H55_I + 1
  end
end

-- =====================================================================
-- Safe pcall wrapper for Lua 3.8/4 where pcall returns an indexed table.
-- Returns: ok(bool), ret1, ret2, ...
-- =====================================================================
function _H55_PCall(f, a1,a2,a3,a4,a5,a6,a7,a8,a9)
  if f == nil then return false, "nil function" end
  H55_R = pcall(f, a1,a2,a3,a4,a5,a6,a7,a8,a9)
  if type(H55_R) == 'table' then
    return H55_R[1], H55_R[2], H55_R[3], H55_R[4], H55_R[5], H55_R[6], H55_R[7], H55_R[8], H55_R[9], H55_R[10]
  end
  return false, "pcall did not return a table"
end

-- =====================================================================
-- Safe call by name (only if global exists). Uses _H55_PCall internally.
-- Example:
--   _H55_SafeCallByName('AddHeroCreatures','Agrael','IMP',50)
-- =====================================================================
function _H55_SafeCallByName(name, a1,a2,a3,a4,a5,a6,a7,a8,a9)
  H55_F = _G and _G[name] or nil
  if H55_F == nil then
    -- Lua 4 might not have _G; try fallback via rawget of the current env
    -- If getglobal exists (Lua 4), prefer it.
    if type(getglobal) == 'function' then
      H55_F = getglobal(name)
    end
  end
  if type(H55_F) ~= 'function' then
    print('_H55_SafeCallByName: missing function: '..tostring(name))
    return false, 'missing function'
  end
  return _H55_PCall(H55_F, a1,a2,a3,a4,a5,a6,a7,a8,a9)
end

-- =====================================================================
-- HERO helpers (skill/perk presence & granting)
-- All accept tokens or numeric IDs. Use HERO_SKILL id space for both.
-- =====================================================================

--[[
_H55_HeroHas(heroName, token) -> boolean

Example:
  if _H55_HeroHas('Agrael','ESTATES') then ... end
  if _H55_HeroHas('Ylaya', 50) then ... end -- direct numeric id
]]
function _H55_HeroHas(heroName, token)
  H55_ID = _H55_Resolve('HERO_SKILL', token)
  if H55_ID == nil then return false end
  -- Engine API: HasHeroSkill(heroName, skillID) -> bool
  return HasHeroSkill(heroName, H55_ID)
end

--[[
_H55_AddHeroPerk(heroName, perkToken) -> boolean granted
Adds a *perk* (or skill) to hero using GiveHeroSkill. Returns true if granted.
Example:
  _H55_AddHeroPerk('Agrael','SNATCH')
  _H55_AddHeroPerk('Vittorio','MENTORING')
]]
function _H55_AddHeroPerk(heroName, perkToken)
  H55_ID = _H55_Resolve('HERO_SKILL', perkToken)
  if H55_ID == nil then print('_H55_AddHeroPerk: unknown token '..tostring(perkToken)); return false end
  if HasHeroSkill(heroName, H55_ID) then return false end
  -- Engine: GiveHeroSkill(heroName, skillID)
  GiveHeroSkill(heroName, H55_ID)
  return true
end

--[[
_H55_AddHeroSkill(heroName, skillToken) -> boolean granted
Semantically identical to _H55_AddHeroPerk (the engine uses same API).
Provided for readability where you conceptually add a "skill".
]]
function _H55_AddHeroSkill(heroName, skillToken)
  return _H55_AddHeroPerk(heroName, skillToken)
end

--[[
_H55_EnsureHeroHas(heroName, tokensTable) -> number countAdded
Iterates a string/number array of tokens and grants each one if missing.
Example:
  _H55_EnsureHeroHas('Agrael', {'LOGISTICS','PATHFINDING','SNATCH'})
]]
function _H55_EnsureHeroHas(heroName, tokensTable)
  H55_COUNT = 0
  H55_I = 1
  while tokensTable and tokensTable[H55_I] do
    if _H55_AddHeroPerk(heroName, tokensTable[H55_I]) then H55_COUNT = H55_COUNT + 1 end
    H55_I = H55_I + 1
  end
  return H55_COUNT
end

-- =====================================================================
-- CREATURE ability helper (requires CREATURE_ABILITY_MAP to be filled)
-- =====================================================================
--[[
_H55_CreatureHasAbility(creatureToken, abilityToken) -> boolean

Example:
  if _H55_CreatureHasAbility('SKELETON','UNDEAD') then ... end
]]
-- (the implementation was already present; the name is now prefixed)
-- end of section

-- =====================================================================
-- SPELL casting safety helpers
-- =====================================================================

-- Core predicate used by safe-cast: checks if a creature is Undead by
-- 1) CREATURE_ABILITY_MAP, or 2) a conservative built-in set.
H55__KNOWN_UNDEAD = H55__KNOWN_UNDEAD or {
  SKELETON=true, SKELETON_ARCHER=true, ZOMBIE=true, PLAGUE_ZOMBIE=true,
  GHOST=true, SPECTRE=true, LICH=true, LICH_MASTER=true, WIGHT=true, WRAITH=true,
  VAMPIRE=true, VAMPIRE_LORD=true, BONE_DRAGON=true, BLACK_KNIGHT=true, DEATH_KNIGHT=true,
}
function _H55_IsUndeadCreature(creatureToken)
  H55_CID = _H55_Resolve('CREATURE', creatureToken)
  if H55_CID then
    H55_ABS = CREATURE_ABILITY_MAP[H55_CID]
    if type(H55_ABS) == 'table' then
      H55_I = 1
      while H55_ABS[H55_I] do
        if H55_ABS[H55_I] == ABILITY.UNDEAD.id then return true end
        H55_I = H55_I + 1
      end
      if H55_ABS[ABILITY.UNDEAD.id] then return true end
    end
  end
  -- try token-name membership last
  H55_T = _H55_ToUpper(creatureToken)
  if type(H55_T) == 'string' and H55__KNOWN_UNDEAD[H55_T] then return true end
  return false
end

--[[
_H55_SafeCastSpell(casterHero, spellIdOrToken, targetSpec1, targetSpec2) -> ok, err

Casts a combat spell via CombatCastSpell in a protected manner so an invalid
target (e.g., resurrection on undead) prints an error and does NOT crash.

Arguments:
  casterHero    - hero name string (e.g., 'Agrael')
  spellIdOrToken- numeric id or string token; if string we pass-through
  targetSpec1   - depends on engine; commonly, x or unit id
  targetSpec2   - depends on engine; commonly, y or nil

Usage examples:
  _H55_SafeCastSpell('Ylaya','LIGHTNING_BOLT',  hexX, hexY)
  _H55_SafeCastSpell('Zehir','RESURRECTION',    allyUnitId)

Note on undead protection:
  If a "raise/resurrect" spell is detected and the target creature is undead
  (by _H55_IsUndeadCreature), the cast is skipped with a message.
]]
function _H55_SafeCastSpell(casterHero, spellIdOrToken, targetSpec1, targetSpec2)
  -- detect "raise/resurrect" intent heuristically (works for tokens/strings)
  H55_STOK = spellIdOrToken
  if type(H55_STOK) == 'string' then H55_STOK = _H55_ToUpper(H55_STOK) end
  H55_IS_RAISE = false
  if type(H55_STOK) == 'string' then
    if string.find(H55_STOK, 'RAISE', 1, true) or string.find(H55_STOK, 'RESUR', 1, true) then
      H55_IS_RAISE = true
    end
  end

  -- optional undead target check if we can resolve a creature id from targetSpec1
  if H55_IS_RAISE and targetSpec1 ~= nil then
    -- If targetSpec1 is a creature token/id, try that path.
    if _H55_IsUndeadCreature(targetSpec1) then
      print('_H55_SafeCastSpell: deny raise on undead target for spell '..tostring(spellIdOrToken))
      return false, 'undead target'
    end
  end

  -- Use safe pcall on CombatCastSpell if available
  if type(CombatCastSpell) ~= 'function' then
    print('_H55_SafeCastSpell: CombatCastSpell not available in this context')
    return false, 'no CombatCastSpell'
  end
  H55_OK, H55_R1 = _H55_PCall(CombatCastSpell, casterHero, spellIdOrToken, targetSpec1, targetSpec2)
  if not H55_OK then
    print('_H55_SafeCastSpell: engine rejected cast: '..tostring(H55_R1))
  end
  return H55_OK, H55_R1
end

-- =====================================================================
-- DATE / WEEK helpers
-- =====================================================================

--[[
_H55_GetWeekNumber() -> 1-based week index since day 1.
Equivalent to: floor(GetDate(ABSOLUTE_DAY) / 7) + 1
Example:
  if _H55_GetWeekNumber() >= 3 then ... end
]]
function _H55_GetWeekNumber()
  H55_DAY = GetDate(ABSOLUTE_DAY)
  if not H55_DAY then return 1 end
  H55_W = math.floor(H55_DAY / 7) + 1
  return H55_W
end

-- =====================================================================
-- GROWTH helpers (town/neutral math)
-- =====================================================================

-- Optional base growth table (per creature). Fill as needed to be exact.
H55_BASE_GROWTH = H55_BASE_GROWTH or {
  -- Example seeds only; extend with real values per your mod balance.
  -- ['PEASANT'] = 25, ['SKELETON'] = 12, ['IMP'] = 18,
}

--[[
_H55_ComputeGrowth(creatureToken, hasCitadel, hasCastle, hasAsha, multiplier) -> number

Returns weekly growth for a town dwelling configuration. This is a *pure*
calculator (no engine calls); pass boolean flags manually (true/false).

Assumptions (common across Heroes V/HoMM heritage):
  Citadel: +50% base growth
  Castle:  +50% base growth (on top of Citadel, total +100% with both)
  Tear of Asha building (grail): +50% base growth

If H55_BASE_GROWTH lacks a value for the creature, returns 0 unless
`multiplier` is supplied alongside a direct base value via override.
Usage:
  _H55_ComputeGrowth('IMP', true, true, false)          -- uses H55_BASE_GROWTH['IMP']
  _H55_ComputeGrowth('SKELETON', true, false, true, 1)  -- with Asha
]]
function _H55_ComputeGrowth(creatureToken, hasCitadel, hasCastle, hasAsha, multiplier)
  H55_CNAME = _H55_ToUpper(creatureToken)
  H55_BASE = H55_BASE_GROWTH[H55_CNAME]
  if not H55_BASE then
    -- allow numeric creature id keys too
    H55_CID = _H55_Resolve('CREATURE', creatureToken)
    if H55_CID then H55_BASE = H55_BASE_GROWTH[H55_CID] end
  end
  if not H55_BASE then
    -- if multiplier given as a number and caller passed a base in multiplier (rare), accept
    if type(multiplier) == 'number' and multiplier > 0 and multiplier < 100 and H55_BASE == nil then
    end
  end
  if not H55_BASE then H55_BASE = 0 end

  H55_MUL = 1.0
  if hasCitadel then H55_MUL = H55_MUL + 0.5 end
  if hasCastle then H55_MUL = H55_MUL + 0.5 end
  if hasAsha then H55_MUL = H55_MUL + 0.5 end
  if type(multiplier) == 'number' then H55_MUL = H55_MUL * multiplier end

  H55_VAL = math.floor(H55_BASE * H55_MUL + 0.00001)
  return H55_VAL
end

-- =====================================================================
-- ADD CREATURES helpers
-- =====================================================================

--[[
_H55_AddCreaturesFirstEmpty(heroName, creatureToken, count) -> ok
Adds to the hero; engine picks the first empty slot automatically.
Example:
  _H55_AddCreaturesFirstEmpty('Agrael','IMP', 30)
]]
function _H55_AddCreaturesFirstEmpty(heroName, creatureToken, count)
  H55_CID = _H55_Resolve('CREATURE', creatureToken)
  if not H55_CID then print('_H55_AddCreaturesFirstEmpty: unknown creature '..tostring(creatureToken)); return false end
  AddHeroCreatures(heroName, H55_CID, count or 0)
  return true
end

--[[
_H55_AddCreaturesAtSlot(heroName, slotIndex, creatureToken, count) -> ok
If the engine expose SetObjectArmySlotCreature/Quantity, we use it; otherwise
falls back to AddHeroCreatures.
Example:
  _H55_AddCreaturesAtSlot('Agrael', 1, 'IMP', 30)
]]
function _H55_AddCreaturesAtSlot(heroName, slotIndex, creatureToken, count)
  H55_CID = _H55_Resolve('CREATURE', creatureToken)
  if not H55_CID then print('_H55_AddCreaturesAtSlot: unknown creature '..tostring(creatureToken)); return false end

  if type(SetObjectArmySlotCreature) == 'function' and type(SetObjectArmySlotQuantity) == 'function' then
    _H55_SafeCallByName('SetObjectArmySlotCreature', heroName, slotIndex, H55_CID)
    _H55_SafeCallByName('SetObjectArmySlotQuantity', heroName, slotIndex, count or 0)
    return true
  end

  -- Fallback: just add (engine will use first empty or merge)
  AddHeroCreatures(heroName, H55_CID, count or 0)
  return true
end

-- =====================================================================
-- FINALIZATION
-- Build the skill-tree lookup tables now.
-- =====================================================================
_H55_BuildSkillTrees()

-- =====================================================================
-- END OF v2 framework extension
-- =====================================================================


-- =====================================================================
-- v3 EXTENSIONS (Lua 4 compatible; NO 'local')  -- Generated: 2025-08-15 21:06:31 UTC
-- Additions over v2:
--   * Explicit RESERVED/placeholder ID notes for engine-facing enums.
--   * New enums: TOWN, TIER, GRADE (internal, human-friendly).
--   * Tier-to-creature mapping table + safe helper: _H55_GiveByTier(...).
--   * Lightweight resolvers for TOWN/TIER/GRADE tokens.
--   * Back-compat aliases: give_by_tier -> _H55_GiveByTier.
--
-- All functions and global helpers are prefixed with _H55 to satisfy
-- strict Lua 4 environments used by H55 scripting.
-- =====================================================================

-- ---------------------------------------------------------------------
-- RESERVED/PLACEHOLDER ID NOTES (ENGINE)
-- ---------------------------------------------------------------------
-- These constants (and numeric IDs) are reserved by the game engine.
-- Do NOT reuse them for custom content. Where possible we annotate them
-- in the enum blocks above; this section centralizes the key rules:
--   • CREATURE id 0   => CREATURE_UNKNOWN (placeholder / none).
--   • Many engine lists treat 0 as "NONE" (no entity). Keep 0 unused
--     in your custom enumerations for safety.
--   • Hero skills/perks: use the concrete numeric IDs supplied by the
--     game. Do not manufacture new IDs; add new content via scripts.
--   • Spell IDs: 0 is typically 'NO_SPELL' (engine placeholder).
--   • Town/Tier/Grade enums declared below are *internal* to this
--     framework and are *not* engine IDs; they exist to keep authoring
--     readable and resilient. Their number values are arbitrary.
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Developer-facing enums: TOWN, TIER, GRADE
-- NOTE: These are FRAMEWORK enums (not engine). Numbers are arbitrary.
-- We still reserve 0 for 'NONE' to avoid accidental collisions.
-- ---------------------------------------------------------------------

TOWN = TOWN or {
  -- 0 is intentionally reserved (placeholder)
  NONE        = 0,   -- RESERVED placeholder
  HAVEN       = 1,
  INFERNO     = 2,
  NECROPOLIS  = 3,
  ACADEMY     = 4,
  DUNGEON     = 5,
  SYLVAN      = 6,
  FORTRESS    = 7,
  STRONGHOLD  = 8,
  NEUTRAL     = 9,   -- helper bucket for neutral picks
}

TIER = TIER or {
  -- 0 is intentionally reserved (placeholder)
  NONE  = 0,   -- RESERVED placeholder
  ONE   = 1,
  TWO   = 2,
  THREE = 3,
  FOUR  = 4,
  FIVE  = 5,
  SIX   = 6,
  SEVEN = 7,
}

GRADE = GRADE or {
  -- 0 is intentionally reserved (placeholder)
  NONE       = 0,   -- RESERVED placeholder
  ONE        = 1,   -- base (no upgrade)
  UPGRADE_A  = 2,   -- first upgrade / alternative
  UPGRADE_B  = 3,   -- second upgrade / alternative (ToE / H55)
}

-- ---------------------------------------------------------------------
-- Utility: uppercase helper (duplicate-safe)
-- ---------------------------------------------------------------------
if not _H55_ToUpper then
function _H55_ToUpper(s)
  if type(s) ~= 'string' then return s end
  return string.upper(s)
end
end

-- ---------------------------------------------------------------------
-- Lightweight resolvers for TOWN / TIER / GRADE (accept number or token)
-- Examples:
--   _H55_ResolveTown('haven') -> TOWN.HAVEN
--   _H55_ResolveTier('five')  -> 5
--   _H55_ResolveGrade('upgrade_b') -> 3
-- ---------------------------------------------------------------------
function _H55_ResolveTown(v)
  if type(v) == 'number' then return v end
  H55_T = _H55_ToUpper(v)
  if TOWN[H55_T] then return TOWN[H55_T] end
  if H55_T == 'NECRO' then return TOWN.NECROPOLIS end
  return nil
end

function _H55_ResolveTier(v)
  if type(v) == 'number' then return v end
  H55_T = _H55_ToUpper(v)
  if TIER[H55_T] then return TIER[H55_T] end
  if H55_T == 'I' or H55_T == 'T1' or H55_T == 'TIER1' then return 1 end
  if H55_T == 'II' or H55_T == 'T2' or H55_T == 'TIER2' then return 2 end
  if H55_T == 'III' or H55_T == 'T3' or H55_T == 'TIER3' then return 3 end
  if H55_T == 'IV' or H55_T == 'T4' or H55_T == 'TIER4' then return 4 end
  if H55_T == 'V' or H55_T == 'T5' or H55_T == 'TIER5' then return 5 end
  if H55_T == 'VI' or H55_T == 'T6' or H55_T == 'TIER6' then return 6 end
  if H55_T == 'VII' or H55_T == 'T7' or H55_T == 'TIER7' then return 7 end
  return nil
end

function _H55_ResolveGrade(v)
  if type(v) == 'number' then return v end
  H55_T = _H55_ToUpper(v)
  if GRADE[H55_T] then return GRADE[H55_T] end
  if H55_T == 'BASE' or H55_T == 'NO_UPGRADE' then return 1 end
  if H55_T == 'A' or H55_T == 'U1' or H55_T == 'ALT1' then return 2 end
  if H55_T == 'B' or H55_T == 'U2' or H55_T == 'ALT2' then return 3 end
  return nil
end

-- ---------------------------------------------------------------------
-- Tier mapping table: H55_TIER_MAP[TOWN][TIER][GRADE] = CREATURE_ID
-- NOTES:
--   • Uses CREATURE.*.id from the big enum table generated earlier.
--   • Only a conservative, safe subset is prefilled (HAVEN). For other
--     towns, the framework falls back to grade ONE when a specific grade
--     is not provided. Expand as needed for your mod.
--   • If you are unsure about an entry, leave it nil and the helper will
--     auto-fallback to base.
-- ---------------------------------------------------------------------
H55_TIER_MAP = H55_TIER_MAP or {}

-- HAVEN
H55_TIER_MAP[TOWN.HAVEN] = H55_TIER_MAP[TOWN.HAVEN] or {}
H55_TIER_MAP[TOWN.HAVEN][TIER.ONE] = {
  [GRADE.ONE]       = CREATURE.PEASANT and CREATURE.PEASANT.id or nil,
  [GRADE.UPGRADE_A] = CREATURE.MILITIAMAN and CREATURE.MILITIAMAN.id or nil,
  -- [GRADE.UPGRADE_B] -- OPTIONAL: fill if your build has a 2nd alt
}
H55_TIER_MAP[TOWN.HAVEN][TIER.TWO] = {
  [GRADE.ONE]       = CREATURE.ARCHER and CREATURE.ARCHER.id or nil,
  [GRADE.UPGRADE_A] = CREATURE.MARKSMAN and CREATURE.MARKSMAN.id or nil,
}
H55_TIER_MAP[TOWN.HAVEN][TIER.THREE] = {
  [GRADE.ONE]       = CREATURE.FOOTMAN and CREATURE.FOOTMAN.id or nil,
  [GRADE.UPGRADE_A] = CREATURE.SWORDSMAN and CREATURE.SWORDSMAN.id or nil,
}
H55_TIER_MAP[TOWN.HAVEN][TIER.FOUR] = {
  [GRADE.ONE]       = CREATURE.GRIFFIN and CREATURE.GRIFFIN.id or nil,
  [GRADE.UPGRADE_A] = CREATURE.ROYAL_GRIFFIN and CREATURE.ROYAL_GRIFFIN.id or nil,
}
H55_TIER_MAP[TOWN.HAVEN][TIER.FIVE] = {
  [GRADE.ONE]       = CREATURE.PRIEST and CREATURE.PRIEST.id or nil,
  [GRADE.UPGRADE_A] = CREATURE.CLERIC and CREATURE.CLERIC.id or nil,
  [GRADE.UPGRADE_B] = CREATURE.ZEALOT and CREATURE.ZEALOT.id or nil, -- ToE/H55 alt
}
H55_TIER_MAP[TOWN.HAVEN][TIER.SIX] = {
  [GRADE.ONE]       = CREATURE.CAVALIER and CREATURE.CAVALIER.id or nil,
  [GRADE.UPGRADE_A] = CREATURE.PALADIN and CREATURE.PALADIN.id or nil,
}
H55_TIER_MAP[TOWN.HAVEN][TIER.SEVEN] = {
  [GRADE.ONE]       = CREATURE.ANGEL and CREATURE.ANGEL.id or nil,
  -- [GRADE.UPGRADE_A] = CREATURE.ARCHANGEL and CREATURE.ARCHANGEL.id or nil, -- if present in your build
}

-- You may prefill other towns here similarly (INFERNO, NECROPOLIS, etc.).
-- Leave entries nil if uncertain; the helper will gracefully fallback.

-- ---------------------------------------------------------------------
-- Helper: resolve from TOWN/TIER/GRADE to a creature id
-- Returns numeric creature id or nil.
-- ---------------------------------------------------------------------
function _H55_ResolveCreatureByTier(town, tier, grade)
  H55_TOWN = _H55_ResolveTown(town)
  H55_TIER = _H55_ResolveTier(tier)
  H55_GRADE = _H55_ResolveGrade(grade)
  if not H55_TOWN or not H55_TIER then return nil end
  if not H55_GRADE or H55_GRADE == 0 then H55_GRADE = GRADE.ONE end

  H55_TIERS = H55_TIER_MAP[H55_TOWN]
  if type(H55_TIERS) ~= 'table' then return nil end
  H55_GRADES = H55_TIERS[H55_TIER]
  if type(H55_GRADES) ~= 'table' then return nil end

  H55_CID = H55_GRADES[H55_GRADE]
  if not H55_CID then
    -- fallback to base grade
    H55_CID = H55_GRADES[GRADE.ONE]
  end
  return H55_CID
end

-- ---------------------------------------------------------------------
-- Primary convenience: add creatures by TOWN/TIER/GRADE into first empty
-- slot (or merges the stack if same creature is already present)
--
-- Usage examples:
--   _H55_GiveByTier('Agrael', TOWN.HAVEN, TIER.TWO, GRADE.UPGRADE_A, 25)
--   _H55_GiveByTier('Agrael', 'Haven', 'Two', 'One', 12)  -- token-friendly
--   give_by_tier('Agrael', TOWN.HAVEN, TIER.ONE, GRADE.ONE, 40) -- alias
--
-- Returns true on success, false otherwise.
-- ---------------------------------------------------------------------
function _H55_GiveByTier(heroName, town, tier, grade, amount)
  H55_CID = _H55_ResolveCreatureByTier(town, tier, grade)
  if not H55_CID then
    print('_H55_GiveByTier: cannot resolve TOWN/TIER/GRADE to creature (town='..tostring(town)..', tier='..tostring(tier)..', grade='..tostring(grade)..')')
    return false
  end
  return _H55_AddCreaturesFirstEmpty(heroName, H55_CID, amount or 0)
end

-- Back-compat alias without underscore (requested helper name)
if not give_by_tier then
  function give_by_tier(heroName, town, tier, grade, amount)
    return _H55_GiveByTier(heroName, town, tier, grade, amount)
  end
end

-- ---------------------------------------------------------------------
-- END OF v3 EXTENSIONS
-- ---------------------------------------------------------------------
