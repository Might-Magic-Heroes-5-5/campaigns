--[[============================================================================
  h55_enum_framework_v9.lua  –  Abilities, Immunities & Growth via generated enums
  -------------------------------------------------------------------------------
  CHANGES from v8
    • Removed engine dependency on the (non-existent) CreatureHasAbility.
      All checks now use static data from the generated enums.
    • New public API (Lua‑4 style: return 1 or nil):
        HasAbility(cre, ability)
        CreatureHasAbility(cre, ability)            -- alias
        CreatureHasAbility(cre, ability)           -- alias (kept for compat)
        GetAbilitiesList(cre [, as_const])          -- when as_const~=nil → return ABILITY_* constants
        IsImmuneToMind(cre)
        IsImmuneToFrenzy(cre)       -- “Frenzy” = BERSERK
        IsImmuneToHypnosis(cre)     -- HYPNOTIZE
        IsImmuneToBlind(cre)        -- sugar
        IsImmuneToSlow(cre)         -- sugar
        IsImmuneToCurse(cre)        -- sugar
        IsImmuneToElement(cre, element)   -- element ∈ 'FIRE'|'WATER'|'AIR'|'EARTH'
        IsImmuneToSpell(cre, spell) -- generic resolver (uses the enums only)
    • Growth now reads CREATURE.*.BASE_GROWTH from the generated file.

  RUNTIME & LOADING (Lua 4.0 semantics only)
    - No locals for functions (H5 scripting limitation). “Pseudo-locals” use the
      __h55__local_837561_* prefix for helper functions and __h55_local_837561_* for
      file-scope private variables.
    - No rawget/pairs/ipairs/#; only Lua‑4 functions (foreach, foreachi, getn, etc.).
  ============================================================================]]

-- ====== 0) HARD DEPENDENCY LOAD (await doFile) ======
-- Freeze helpers (await until ready). We accept either name you use for the freeze file.
if not __h55__local_56424_freeze then
  -- Your runtime file name (you mentioned both; we try both safely)
  pcall(function() doFile('./scripts/h55_freeze_func.lua') end)
  pcall(function() doFile('./scripts/h55_enum_runtime.lua') end)
end
while not __h55__local_56424_freeze do end

-- Enums (await until tables appear)
doFile('./scripts/h55_enums_creatures.lua')
while (ABILITIES == nil) or (ABILITIES.CREATURES == nil) or (CREATURE == nil) do end

doFile('./scripts/h55_enums_spells.lua')
while (SPELL == nil) do end

if H55_ENUM_FRAMEWORK_V9_LOADED ~= nil then return end
H55_ENUM_FRAMEWORK_V9_LOADED = 1

-- ====== 1) SAFETY / ENUM ACCESS (no strings hardcoded; use your enums) ======
-- Minimal growth type enum (kept if older packs didn’t expose it)
GT = GT or { BASE=1, CITADEL=2, CASTLE=3 }

-- ====== 2) “Pseudo‑local” private state (file scope) ======
__h55_local_837561_CRE_BY_ID     = {}   -- [id]   -> creature object
__h55_local_837561_CRE_BY_NAME   = {}   -- ['CREATURE_*'] -> creature object
__h55_local_837561_ABSET_BY_NAME = {}   -- ['CREATURE_*'] -> { ['IMMUNITY_TO_FIRE']=1, ... }

-- Small helpers (must be global in H5; prefixed)
function __h55__local_837561_is_array(t)
  if type(t) ~= 'table' then return nil end
  local n = getn(t)
  if n <= 0 then return nil end
  local ok = 1
  for i=1,n do if t[i] == nil then ok = nil break end end
  return ok
end

function __h55__local_837561_set_from_array(a)
  local s = {}
  if __h55__local_837561_is_array(a) ~= nil then
    local n = getn(a)
    for i=1,n do s[a[i]] = 1 end
  end
  return s
end

function __h55__local_837561_foreach_creatures(cb)
  -- Walk nested CREATURE table (town groups etc.) and call cb(obj) for each creature object.
  foreach(CREATURE, function(k, v)
    if type(v) == 'table' then
      -- direct creature object? (has 'name' and 'ABILITIES')
      if v.name ~= nil and v.ABILITIES ~= nil then cb(v)
      else
        foreach(v, function(k2, v2)
          if type(v2) == 'table' and v2.name ~= nil and v2.ABILITIES ~= nil then cb(v2) end
        end)
      end
    end
  end)
end

-- Build caches from the generated enums
__h55__local_837561_foreach_creatures(function(c)
  __h55_local_837561_CRE_BY_NAME[c.name] = c
  if c.id ~= nil and type(c.id) == 'number' and c.id > 0 then
    __h55_local_837561_CRE_BY_ID[c.id] = c
  end
  __h55_local_837561_ABSET_BY_NAME[c.name] = __h55__local_837561_set_from_array(c.ABILITIES)
end)

-- Resolve a creature arg to its enum object
function __h55__local_837561_resolve_cre(cre)
  local t = type(cre)
  if t == 'table' and cre.name ~= nil and cre.ABILITIES ~= nil then return cre end
  if t == 'number' then
    return __h55_local_837561_CRE_BY_ID[cre]
  end
  if t == 'string' then
    -- Accept canonical 'CREATURE_*' names (from enums). No hardcoded strings here.
    local o = __h55_local_837561_CRE_BY_NAME[cre]
    if o ~= nil then return o end
    -- If someone passed town-scoped object key (e.g. CREATURE.HAVEN.ANGEL), the caller should pass that table directly.
  end
  return nil
end

-- Normalize an ability arg to our canonical ability-name key as used in CREATURE.*.ABILITIES
-- Accepted forms:
--   • ABILITIES.CREATURES.IMMUNITY_TO_FIRE            (object)  → 'IMMUNITY_TO_FIRE'
--   • ABILITIES.CREATURES.IMMUNITY_TO_FIRE.const      (string)  → 'IMMUNITY_TO_FIRE'
--   • 'IMMUNITY_TO_FIRE'                              (string)  → 'IMMUNITY_TO_FIRE'  (discouraged but supported)
--   • 'ABILITY_IMMUNITY_TO_FIRE'                      (string)  → 'IMMUNITY_TO_FIRE'  (discouraged but supported)
function __h55__local_837561_norm_ability(a)
  local t = type(a)
  if t == 'table' then
    if a.name ~= nil then
      -- enum stores name without 'ABILITY_' prefix (e.g., 'IMMUNITY_TO_FIRE')
      return a.name
    end
  elseif t == 'string' then
    -- Try direct enum key first (no literals baked here; keys come from your enums)
    if ABILITIES and ABILITIES.CREATURES and ABILITIES.CREATURES[a] ~= nil then return a end
    -- If someone passed 'ABILITY_*', strip prefix:
    -- Lua 4: use string.sub/find safely
    if string.sub(a, 1, 8) == 'ABILITY_' then
      return string.sub(a, 9) -- 'ABILITY_IMMUNITY_TO_FIRE' → 'IMMUNITY_TO_FIRE'
    end
  end
  return nil
end

-- Normalize a spell arg to a SPELL.* object from your enums.
-- Accepted forms:
--   SPELL.BERSERK           (object)
--   SPELL.BERSERK.const     ('SPELL_BERSERK')
--   'SPELL_BERSERK'         (discouraged but supported)
function __h55__local_837561_norm_spell(s)
  local t = type(s)
  if t == 'table' and s.const ~= nil and s.name ~= nil then return s end
  if t == 'string' then
    -- iterate enum table to find by .const or .name
    local found = nil
    foreach(SPELL, function(k, v)
      if found ~= nil then return end
      if type(v) == 'table' then
        if v.const == s or v.name == s then found = v end
      end
    end)
    if found ~= nil then return found end
  end
  return nil
end

-- ====== 3) PUBLIC ABILITY API ======
function HasAbility(cre, ability)
  local c = __h55__local_837561_resolve_cre(cre); if c == nil then return nil end
  local aname = __h55__local_837561_norm_ability(ability); if aname == nil then return nil end
  local aset = __h55_local_837561_ABSET_BY_NAME[c.name]; if aset == nil then return nil end
  if aset[aname] ~= nil then return 1 end
  return nil
end

-- Explicit aliases (compat)
function CreatureHasAbility(cre, ability)  return HasAbility(cre, ability) end

-- GetAbilitiesList(cre [, as_const]) – uses your enums only (no raw strings)
--  Default: returns array of enum “names” like 'IMMUNITY_TO_FIRE'
--  When as_const ~= nil: returns 'ABILITY_*' constants from ABILITIES.CREATURES[*].const
function GetAbilitiesList(cre, as_const)
  local c = __h55__local_837561_resolve_cre(cre); if c == nil then return {} end
  local out = {}
  local n = getn(c.ABILITIES)
  for i=1,n do
    local name = c.ABILITIES[i]
    if as_const ~= nil then
      local obj = ABILITIES.CREATURES[name]
      if obj ~= nil and obj.const ~= nil then out[i] = obj.const else out[i] = name end
    else
      out[i] = name
    end
  end
  return out
end

-- ====== 4) IMMUNITY HELPERS (built on enums; no engine calls) ======
-- Magic-immunity ability (use enums explicitly)
__h55_local_837561_AB_IMM_MAGIC          = ABILITIES.CREATURES.IMMUNITY_TO_MAGIC and ABILITIES.CREATURES.IMMUNITY_TO_MAGIC.name
__h55_local_837561_AB_IMM_MIND_CONTROL   = ABILITIES.CREATURES.IMMUNITY_TO_MIND_CONTROL and ABILITIES.CREATURES.IMMUNITY_TO_MIND_CONTROL.name
__h55_local_837561_AB_UNDEAD             = ABILITIES.CREATURES.UNDEAD and ABILITIES.CREATURES.UNDEAD.name
__h55_local_837561_AB_ELEMENTAL          = ABILITIES.CREATURES.ELEMENTAL and ABILITIES.CREATURES.ELEMENTAL.name
__h55_local_837561_AB_MECHANICAL         = ABILITIES.CREATURES.MECHANICAL and ABILITIES.CREATURES.MECHANICAL.name
__h55_local_837561_AB_IMM_BERSERK        = ABILITIES.CREATURES.IMMUNITY_TO_BERSERK and ABILITIES.CREATURES.IMMUNITY_TO_BERSERK.name
__h55_local_837561_AB_IMM_HYPNOTIZE      = ABILITIES.CREATURES.IMMUNITY_TO_HYPNOTIZE and ABILITIES.CREATURES.IMMUNITY_TO_HYPNOTIZE.name
__h55_local_837561_AB_IMM_BLIND          = ABILITIES.CREATURES.IMMUNITY_TO_BLIND and ABILITIES.CREATURES.IMMUNITY_TO_BLIND.name
__h55_local_837561_AB_IMM_SLOW           = ABILITIES.CREATURES.IMMUNITY_TO_SLOW and ABILITIES.CREATURES.IMMUNITY_TO_SLOW.name
__h55_local_837561_AB_IMM_CURSE          = ABILITIES.CREATURES.IMMUNITY_TO_CURSE and ABILITIES.CREATURES.IMMUNITY_TO_CURSE.name
__h55_local_837561_AB_IMM_FIRE           = ABILITIES.CREATURES.IMMUNITY_TO_FIRE and ABILITIES.CREATURES.IMMUNITY_TO_FIRE.name
__h55_local_837561_AB_IMM_WATER          = ABILITIES.CREATURES.IMMUNITY_TO_WATER and ABILITIES.CREATURES.IMMUNITY_TO_WATER.name
__h55_local_837561_AB_IMM_AIR            = ABILITIES.CREATURES.IMMUNITY_TO_AIR and ABILITIES.CREATURES.IMMUNITY_TO_AIR.name
__h55_local_837561_AB_IMM_EARTH          = ABILITIES.CREATURES.IMMUNITY_TO_EARTH and ABILITIES.CREATURES.IMMUNITY_TO_EARTH.name

function __h55__local_837561_magic_immune(cre)
  if __h55_local_837561_AB_IMM_MAGIC and HasAbility(cre, __h55_local_837561_AB_IMM_MAGIC) ~= nil then return 1 end
  return nil
end

function __h55__local_837561_mind_type_immune(cre)
  if __h55_local_837561_AB_IMM_MIND_CONTROL and HasAbility(cre, __h55_local_837561_AB_IMM_MIND_CONTROL) ~= nil then return 1 end
  if __h55_local_837561_AB_UNDEAD       and HasAbility(cre, __h55_local_837561_AB_UNDEAD)       ~= nil then return 1 end
  if __h55_local_837561_AB_ELEMENTAL    and HasAbility(cre, __h55_local_837561_AB_ELEMENTAL)    ~= nil then return 1 end
  if __h55_local_837561_AB_MECHANICAL   and HasAbility(cre, __h55_local_837561_AB_MECHANICAL)   ~= nil then return 1 end
  return nil
end

-- ====== 5) PUBLIC IMMUNITY API ======
function IsImmuneToMind(cre)
  if __h55__local_837561_magic_immune(cre) ~= nil then return 1 end
  if __h55__local_837561_mind_type_immune(cre) ~= nil then return 1 end
  return nil
end

function IsImmuneToFrenzy(cre) -- (Berserk)
  if __h55__local_837561_magic_immune(cre) ~= nil then return 1 end
  if __h55_local_837561_AB_IMM_BERSERK and HasAbility(cre, __h55_local_837561_AB_IMM_BERSERK) ~= nil then return 1 end
  if IsImmuneToMind(cre) ~= nil then return 1 end
  return nil
end

function IsImmuneToHypnosis(cre)
  if __h55__local_837561_magic_immune(cre) ~= nil then return 1 end
  if __h55_local_837561_AB_IMM_HYPNOTIZE and HasAbility(cre, __h55_local_837561_AB_IMM_HYPNOTIZE) ~= nil then return 1 end
  if IsImmuneToMind(cre) ~= nil then return 1 end
  return nil
end

function IsImmuneToBlind(cre)
  if __h55__local_837561_magic_immune(cre) ~= nil then return 1 end
  if __h55_local_837561_AB_IMM_BLIND and HasAbility(cre, __h55_local_837561_AB_IMM_BLIND) ~= nil then return 1 end
  if IsImmuneToMind(cre) ~= nil then return 1 end
  return nil
end

function IsImmuneToSlow(cre)
  if __h55__local_837561_magic_immune(cre) ~= nil then return 1 end
  if __h55_local_837561_AB_IMM_SLOW and HasAbility(cre, __h55_local_837561_AB_IMM_SLOW) ~= nil then return 1 end
  return nil
end

function IsImmuneToCurse(cre)
  if __h55__local_837561_magic_immune(cre) ~= nil then return 1 end
  if __h55_local_837561_AB_IMM_CURSE and HasAbility(cre, __h55_local_837561_AB_IMM_CURSE) ~= nil then return 1 end
  return nil
end

-- Elements to ability-name (use enums; no raw strings)
__h55_local_837561_ELEM_TO_ABILITY = {
  FIRE  = __h55_local_837561_AB_IMM_FIRE,
  WATER = __h55_local_837561_AB_IMM_WATER,
  AIR   = __h55_local_837561_AB_IMM_AIR,
  EARTH = __h55_local_837561_AB_IMM_EARTH,
}

function IsImmuneToElement(cre, element)
  if __h55__local_837561_magic_immune(cre) ~= nil then return 1 end
  local ab = __h55_local_837561_ELEM_TO_ABILITY[element]
  if ab ~= nil and HasAbility(cre, ab) ~= nil then return 1 end
  return nil
end

-- ====== 6) SPELL to ELEMENT map (explicit via your SPELL enums; no strings) ======
__h55_local_837561_SPELL_TO_ELEM = {}

function __h55__local_837561_tag_elem(spell_obj, elem)
  if spell_obj ~= nil and spell_obj.name ~= nil then
    __h55_local_837561_SPELL_TO_ELEM[spell_obj.name] = elem
  end
end

-- AIR
__h55__local_837561_tag_elem(SPELL.LIGHTNING_BOLT,           'AIR')
__h55__local_837561_tag_elem(SPELL.CHAIN_LIGHTNING_HIT,      'AIR')
__h55__local_837561_tag_elem(SPELL.EMPOWERED_LIGHTNING_BOLT, 'AIR')
__h55__local_837561_tag_elem(SPELL.EMPOWERED_CHAIN_LIGHTNING,'AIR')
-- WATER
__h55__local_837561_tag_elem(SPELL.ICE_BOLT,                 'WATER')
__h55__local_837561_tag_elem(SPELL.FROST_RING,               'WATER')
__h55__local_837561_tag_elem(SPELL.DEEPFREEZE,               'WATER')
__h55__local_837561_tag_elem(SPELL.EMPOWERED_ICE_BOLT,       'WATER')
__h55__local_837561_tag_elem(SPELL.EMPOWERED_FROST_RING,     'WATER')
__h55__local_837561_tag_elem(SPELL.EMPOWERED_DEEPFREEZE,     'WATER')
-- FIRE
__h55__local_837561_tag_elem(SPELL.FIREBALL,                 'FIRE')
__h55__local_837561_tag_elem(SPELL.EMPOWERED_FIREBALL,       'FIRE')
__h55__local_837561_tag_elem(SPELL.ARMAGEDDON,               'FIRE')
__h55__local_837561_tag_elem(SPELL.EMPOWERED_ARMAGEDDON,     'FIRE')
__h55__local_837561_tag_elem(SPELL.FIREWALL,                 'FIRE')
-- EARTH
__h55__local_837561_tag_elem(SPELL.METEOR_SHOWER,            'EARTH')
__h55__local_837561_tag_elem(SPELL.EMPOWERED_METEOR_SHOWER,  'EARTH')
__h55__local_837561_tag_elem(SPELL.STONESPIKES,              'EARTH')
__h55__local_837561_tag_elem(SPELL.EMPOWERED_STONESPIKES,    'EARTH')
__h55__local_837561_tag_elem(SPELL.IMPLOSION,                'EARTH')
__h55__local_837561_tag_elem(SPELL.EMPOWERED_IMPLOSION,      'EARTH')
__h55__local_837561_tag_elem(SPELL.EARTHQUAKE,               'EARTH')
__h55__local_837561_tag_elem(SPELL.LAND_MINE,                'EARTH')

-- ====== 7) GENERIC IMMUNITY RESOLVER ======
function IsImmuneToSpell(cre, spell)
  local s = __h55__local_837561_norm_spell(spell); if s == nil then return nil end
  -- universal magic immunity
  if __h55__local_837561_magic_immune(cre) ~= nil then return 1 end

  -- specific mind-control family
  if s == SPELL.BERSERK then return IsImmuneToFrenzy(cre) end
  if s == SPELL.HYPNOTIZE then return IsImmuneToHypnosis(cre) end
  if s == SPELL.BLIND then return IsImmuneToBlind(cre) end

  -- slow / curse (mass variants share same immunity)
  if s == SPELL.SLOW or s == SPELL.MASS_SLOW then return IsImmuneToSlow(cre) end
  if s == SPELL.CURSE or s == SPELL.MASS_CURSE then return IsImmuneToCurse(cre) end

  -- elemental destructive spells
  local elem = __h55_local_837561_SPELL_TO_ELEM[s.name]
  if elem ~= nil then return IsImmuneToElement(cre, elem) end

  -- If we reach here we only block by full magic immunity (already handled)
  return nil
end

-- ====== 8) Optional convenient aliases (if your scripts expect H55 v8 names) ======
_H55_UnitHasAbility = _H55_UnitHasAbility or HasAbility
_H55_IsImmune       = _H55_IsImmune       or IsImmuneToSpell

-- ====== 9) GROWTH (reads BASE_GROWTH from your CREATURE enums) ======
function __h55__local_837561_coerce_growth_type(gt)
  if gt == GT.CITADEL or gt == 2 then return 2 end
  if gt == GT.CASTLE  or gt == 3 then return 3 end
  return 1
end

-- _H55_GetGrowth(cre, growthType, with_asha, multiplier) – numerically stable floor
function _H55_GetGrowth(cre, growthType, with_asha, multiplier)
  local c = __h55__local_837561_resolve_cre(cre); if c == nil then return 0 end
  local base = c.BASE_GROWTH or 0
  local m = 1.0
  local g = __h55__local_837561_coerce_growth_type(growthType)
  if g == 2 then m = 1.5 end
  if g == 3 then m = 2.0 end
  if with_asha ~= nil then m = m * 1.5 end
  if multiplier ~= nil then m = m * multiplier end
  return math.floor(base * m + 0.0001)
end

-- ====== 10) SANITY CHECKS (fail fast with explicit ACTUAL_DATA messages) ======
if ABILITIES == nil or ABILITIES.CREATURES == nil then
  error("[H55 v9] ABILITIES.CREATURES not found. ACTUAL_DATA: ensure './scripts/h55_enums_creatures.lua' is loaded before this file.")
end
if CREATURE == nil then
  error("[H55 v9] CREATURE table not found. ACTUAL_DATA: ensure './scripts/h55_enums_creatures.lua' is loaded before this file.")
end
if SPELL == nil then
  error("[H55 v9] SPELL table not found. ACTUAL_DATA: ensure './scripts/h55_enums_spells.lua' is loaded before this file.")
end

-- Notes / Questions (please confirm, as requested):
--  • ELEMENT argument for IsImmuneToElement currently expects 'FIRE'|'WATER'|'AIR'|'EARTH' strings.
--    If you prefer an enum (e.g. ELEMENT.FIRE), provide ACTUAL_DATA with the canonical table.
--  • Spells: we accept SPELL.* objects (preferred) or their .const strings. If you need numeric-id
--    inputs as well, please confirm an ACTUAL_DATA mapping like SPELL_BY_ID in your Lua‑4 format.

-- ====== end of file ======
