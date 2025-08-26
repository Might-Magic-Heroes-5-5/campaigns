--[[============================================================================
  h55_enum_framework.lua  –  H55 loader + runtime + ability & immunity helpers
  ------------------------------------------------------------------------------
  Heroes V: Tribes of the East (Lua 4.0)

  • No local functions. Local variables are used only inside functions.
  • Linear imports through _h55_doFile(name, log_level):
        tries "./scripts/<name>" then "./<name>" (no sleeps / loops).
  • _h55_pcall(tag, f, ...) returns TABLE on success (H5-style), nil on failure.
    Works with both H5 table-return and classic Lua boolean-return pcalls.
  • Logging: __h55__print_error(msg) → print() if available + FlyingSign
        Targets (all optional, safe when nil):
          - debug_print_object
          - FLYING_TEXT_DEBUG_OBJECT
          - PRINT_ERRORS_OBJECTS = { obj1, obj2, ... }
  • Readonly helpers: __h55__local_56424_freeze(_shallow) (Lua 4.0)
  • H55_ENUMS_REQUIRE(): try to load both enum files once (idempotent).

  Public helpers built on auto-generated enums:
    HasAbility, CreatureHasAbility, GetAbilitiesList,
    IsImmuneToMind/Frenzy/Hypnosis/Blind/Slow/Curse, IsImmuneToElement, IsImmuneToSpell,
    _H55_GetGrowth
============================================================================]]


-- ============================================================================
-- 0) Logging / globals
-- ============================================================================
if PRINT_ERRORS_OBJECTS == nil then PRINT_ERRORS_OBJECTS = {} end
if debug_print_object == nil then debug_print_object = nil end
if FLYING_TEXT_DEBUG_OBJECT == nil then FLYING_TEXT_DEBUG_OBJECT = debug_print_object end

if not __h55__print_error then
  function __h55__print_error(msg)
    local text = tostring(msg)

    -- log to console if available (H5 doesn’t support write(); print() is best-effort)
    if type(print) == "function" then
      pcall(function() print("[H55] " .. text) end)
    end

    -- flying signs (only if functions / objects exist)
    if type(ShowFlyingSign) == "function" then
      if debug_print_object ~= nil then
        pcall(function() ShowFlyingSign(text, debug_print_object, 5) end)
      end
      if FLYING_TEXT_DEBUG_OBJECT ~= nil and FLYING_TEXT_DEBUG_OBJECT ~= debug_print_object then
        pcall(function() ShowFlyingSign(text, FLYING_TEXT_DEBUG_OBJECT, 5) end)
      end
      if PRINT_ERRORS_OBJECTS then
        local i = 1
        while PRINT_ERRORS_OBJECTS[i] ~= nil do
          pcall(function() ShowFlyingSign(text, PRINT_ERRORS_OBJECTS[i], 5) end)
          i = i + 1
        end
      end
    end
  end
end


-- ============================================================================
-- 1) Safe pcall wrapper → TABLE on success / nil on failure
-- ============================================================================
if not _h55_pcall then
  function _h55_pcall(tag, f, a1, a2, a3, a4, a5, a6, a7, a8)
    local s, r1, r2, r3, r4, r5, r6, r7, r8 = pcall(f, a1, a2, a3, a4, a5, a6, a7, a8)

    -- H5 variant: success comes as a table in 's'
    if type(s) == "table" and r1 == nil then
      return s
    end

    -- Classic Lua variant: success is boolean-ish (1)
    if s then
      local t = {}
      if r1 ~= nil then t[1] = r1 end
      if r2 ~= nil then t[2] = r2 end
      if r3 ~= nil then t[3] = r3 end
      if r4 ~= nil then t[4] = r4 end
      if r5 ~= nil then t[5] = r5 end
      if r6 ~= nil then t[6] = r6 end
      if r7 ~= nil then t[7] = r7 end
      if r8 ~= nil then t[8] = r8 end
      return t
    end

    -- Failure (both forms)
    __h55__print_error("pcall[" .. tostring(tag) .. "] failed: " .. tostring(r1))
    return nil
  end
end


-- ============================================================================
-- 2) Linear loader (no sleeps; bounded)
--     log_level: 0=quiet, 1=errors, 2=info (info via flying text too)
-- ============================================================================
if not _h55_doFile then
  function _h55_doFile(name, log_level)
    local lvl = log_level or 0
    local path1 = "./scripts/" .. tostring(name)
    local path2 = "./" .. tostring(name)

    if not doFile then
      if lvl >= 1 then __h55__print_error("_h55_doFile: doFile not available") end
      return nil
    end

    local r = _h55_pcall("doFile:" .. path1, doFile, path1)
    if r ~= nil then
      if lvl >= 2 then __h55__print_error("Loaded " .. path1) end
      return r
    end

    r = _h55_pcall("doFile:" .. path2, doFile, path2)
    if r ~= nil then
      if lvl >= 2 then __h55__print_error("Loaded " .. path2) end
      return r
    end

    if lvl >= 1 then __h55__print_error("_h55_doFile: failed to load " .. tostring(name)) end
    return nil
  end
end


-- ============================================================================
-- 3) Read-only helpers (Lua 4.0)
-- ============================================================================
if not __h55__local_56424_freeze then
  if newtag then
    __h55__local_56424_RO_TAG = newtag()
    settagmethod(__h55__local_56424_RO_TAG, "settable", function(t, k, v)
      error("read-only table", 2)
    end)
    function __h55__local_56424_freeze(tbl)
      if type(tbl) == "table" then settag(tbl, __h55__local_56424_RO_TAG) end
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
end


-- ============================================================================
-- 4) Optional: require both enums when asked (idempotent)
-- ============================================================================
if not H55_ENUMS_REQUIRE then
  function H55_ENUMS_REQUIRE()
    local ok = 1
    if not CREATURE then
      if _h55_doFile("h55_enums_creatures.lua", 1) == nil then ok = nil end
    end
    if not SPELL then
      if _h55_doFile("h55_enums_spells.lua", 1) == nil then ok = nil end
    end
    return ok
  end
end


-- ============================================================================
-- 5) Caches from enums (lazy)
-- ============================================================================
GT = GT or { BASE=1, CITADEL=2, CASTLE=3 }

__h55_local_837561_CACHE_BUILT     = nil
__h55_local_837561_CRE_BY_ID       = {}
__h55_local_837561_CRE_BY_NAME     = {}
__h55_local_837561_ABSET_BY_NAME   = {}

function __h55__local_837561_is_array(t)
  if type(t) ~= 'table' then return nil end
  local n = getn(t); if n <= 0 then return nil end
  local ok = 1; for i=1,n do if t[i] == nil then ok = nil break end end
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
  if CREATURE == nil then return end
  foreach(CREATURE, function(k, v)
    if type(v) == 'table' then
      if v.name ~= nil and v.ABILITIES ~= nil then cb(v)
      else
        foreach(v, function(k2, v2)
          if type(v2) == 'table' and v2.name ~= nil and v2.ABILITIES ~= nil then cb(v2) end
        end)
      end
    end
  end)
end

function __h55__local_837561_build_cache()
  __h55_local_837561_CRE_BY_ID     = {}
  __h55_local_837561_CRE_BY_NAME   = {}
  __h55_local_837561_ABSET_BY_NAME = {}
  __h55__local_837561_foreach_creatures(function(c)
    __h55_local_837561_CRE_BY_NAME[c.name] = c
    if c.id ~= nil and type(c.id) == 'number' and c.id > 0 then
      __h55_local_837561_CRE_BY_ID[c.id] = c
    end
    __h55_local_837561_ABSET_BY_NAME[c.name] = __h55__local_837561_set_from_array(c.ABILITIES)
  end)
  __h55_local_837561_CACHE_BUILT = 1
end

function __h55__local_837561_ensure_cache()
  if __h55_local_837561_CACHE_BUILT ~= 1 and CREATURE ~= nil then
    __h55__local_837561_build_cache()
  end
end


-- ============================================================================
-- 6) Normalizers
-- ============================================================================
function __h55__local_837561_resolve_cre(cre)
  __h55__local_837561_ensure_cache()
  local t = type(cre)
  if t == 'table' and cre.name ~= nil and cre.ABILITIES ~= nil then return cre end
  if t == 'number' then return __h55_local_837561_CRE_BY_ID[cre] end
  if t == 'string' then return __h55_local_837561_CRE_BY_NAME[cre] end
  return nil
end

function __h55__local_837561_norm_ability(a)
  if a == nil then return nil end
  local t = type(a)
  if t == 'table' then
    if a.name ~= nil then return a.name end
  elseif t == 'string' then
    if ABILITIES and ABILITIES.CREATURES and ABILITIES.CREATURES[a] ~= nil then return a end
    if string.sub(a, 1, 8) == 'ABILITY_' then return string.sub(a, 9) end
  end
  return nil
end

function __h55__local_837561_norm_spell(s)
  if s == nil then return nil end
  if type(s) == 'table' and s.const ~= nil and s.name ~= nil then return s end
  if type(s) == 'string' and SPELL ~= nil then
    local found = nil
    foreach(SPELL, function(k, v)
      if found ~= nil then return end
      if type(v) == 'table' then
        if v.const == s or v.name == s then found = v end
      end
    end)
    return found
  end
  return nil
end


-- ============================================================================
-- 7) Ability API
-- ============================================================================
function HasAbility(cre, ability)
  __h55__local_837561_ensure_cache()
  if cre == nil or ability == nil then return nil end
  local c = __h55__local_837561_resolve_cre(cre); if c == nil then return nil end
  local aname = __h55__local_837561_norm_ability(ability); if aname == nil then return nil end
  local aset = __h55_local_837561_ABSET_BY_NAME[c.name]; if aset == nil then return nil end
  if aset[aname] ~= nil then return 1 end
  return nil
end

function CreatureHasAbility(cre, ability)  return HasAbility(cre, ability) end

function GetAbilitiesList(cre, as_const)
  __h55__local_837561_ensure_cache()
  local c = __h55__local_837561_resolve_cre(cre); if c == nil then return {} end
  local out = {}
  local n = getn(c.ABILITIES)
  for i=1,n do
    local name = c.ABILITIES[i]
    if as_const ~= nil then
      local obj = ABILITIES and ABILITIES.CREATURES and ABILITIES.CREATURES[name]
      if obj ~= nil and obj.const ~= nil then out[i] = obj.const else out[i] = name end
    else
      out[i] = name
    end
  end
  return out
end


-- ============================================================================
-- 8) Immunities + tags (lazy init)
-- ============================================================================
__h55_local_837561_IMM_NAMES_READY = nil
__h55_local_837561_SPELL_TAG_READY = nil

__h55_local_837561_AB_IMM_MAGIC        = nil
__h55_local_837561_AB_IMM_MIND_CONTROL = nil
__h55_local_837561_AB_UNDEAD           = nil
__h55_local_837561_AB_ELEMENTAL        = nil
__h55_local_837561_AB_MECHANICAL       = nil
__h55_local_837561_AB_IMM_BERSERK      = nil
__h55_local_837561_AB_IMM_HYPNOTIZE    = nil
__h55_local_837561_AB_IMM_BLIND        = nil
__h55_local_837561_AB_IMM_SLOW         = nil
__h55_local_837561_AB_IMM_CURSE        = nil
__h55_local_837561_AB_IMM_FIRE         = nil
__h55_local_837561_AB_IMM_WATER        = nil
__h55_local_837561_AB_IMM_AIR          = nil
__h55_local_837561_AB_IMM_EARTH        = nil

function __h55__local_837561_ensure_imm_names()
  if __h55_local_837561_IMM_NAMES_READY == 1 then return end
  if not (ABILITIES and ABILITIES.CREATURES) then return end
  local A = ABILITIES.CREATURES
  __h55_local_837561_AB_IMM_MAGIC        = A.IMMUNITY_TO_MAGIC        and A.IMMUNITY_TO_MAGIC.name
  __h55_local_837561_AB_IMM_MIND_CONTROL = A.IMMUNITY_TO_MIND_CONTROL and A.IMMUNITY_TO_MIND_CONTROL.name
  __h55_local_837561_AB_UNDEAD           = A.UNDEAD                   and A.UNDEAD.name
  __h55_local_837561_AB_ELEMENTAL        = A.ELEMENTAL                and A.ELEMENTAL.name
  __h55_local_837561_AB_MECHANICAL       = A.MECHANICAL               and A.MECHANICAL.name
  __h55_local_837561_AB_IMM_BERSERK      = A.IMMUNITY_TO_BERSERK      and A.IMMUNITY_TO_BERSERK.name
  __h55_local_837561_AB_IMM_HYPNOTIZE    = A.IMMUNITY_TO_HYPNOTIZE    and A.IMMUNITY_TO_HYPNOTIZE.name
  __h55_local_837561_AB_IMM_BLIND        = A.IMMUNITY_TO_BLIND        and A.IMMUNITY_TO_BLIND.name
  __h55_local_837561_AB_IMM_SLOW         = A.IMMUNITY_TO_SLOW         and A.IMMUNITY_TO_SLOW.name
  __h55_local_837561_AB_IMM_CURSE        = A.IMMUNITY_TO_CURSE        and A.IMMUNITY_TO_CURSE.name
  __h55_local_837561_AB_IMM_FIRE         = A.IMMUNITY_TO_FIRE         and A.IMMUNITY_TO_FIRE.name
  __h55_local_837561_AB_IMM_WATER        = A.IMMUNITY_TO_WATER        and A.IMMUNITY_TO_WATER.name
  __h55_local_837561_AB_IMM_AIR          = A.IMMUNITY_TO_AIR          and A.IMMUNITY_TO_AIR.name
  __h55_local_837561_AB_IMM_EARTH        = A.IMMUNITY_TO_EARTH        and A.IMMUNITY_TO_EARTH.name
  __h55_local_837561_IMM_NAMES_READY = 1
end

__h55_local_837561_SPELL_TO_ELEM = {}
function __h55__local_837561_tag_elem(spell_obj, elem)
  if spell_obj ~= nil and spell_obj.name ~= nil then
    __h55_local_837561_SPELL_TO_ELEM[spell_obj.name] = elem
  end
end

function __h55__local_837561_ensure_spell_tags()
  if __h55_local_837561_SPELL_TAG_READY == 1 then return end
  if SPELL == nil then return end

  -- AIR
  __h55__local_837561_tag_elem(SPELL.LIGHTNING_BOLT,            'AIR')
  __h55__local_837561_tag_elem(SPELL.CHAIN_LIGHTNING_HIT,       'AIR')
  __h55__local_837561_tag_elem(SPELL.EMPOWERED_LIGHTNING_BOLT,  'AIR')
  __h55__local_837561_tag_elem(SPELL.EMPOWERED_CHAIN_LIGHTNING, 'AIR')
  -- WATER
  __h55__local_837561_tag_elem(SPELL.ICE_BOLT,                  'WATER')
  __h55__local_837561_tag_elem(SPELL.FROST_RING,                'WATER')
  __h55__local_837561_tag_elem(SPELL.DEEPFREEZE,                'WATER')
  __h55__local_837561_tag_elem(SPELL.EMPOWERED_ICE_BOLT,        'WATER')
  __h55__local_837561_tag_elem(SPELL.EMPOWERED_FROST_RING,      'WATER')
  __h55__local_837561_tag_elem(SPELL.EMPOWERED_DEEPFREEZE,      'WATER')
  -- FIRE
  __h55__local_837561_tag_elem(SPELL.FIREBALL,                  'FIRE')
  __h55__local_837561_tag_elem(SPELL.EMPOWERED_FIREBALL,        'FIRE')
  __h55__local_837561_tag_elem(SPELL.ARMAGEDDON,                'FIRE')
  __h55__local_837561_tag_elem(SPELL.EMPOWERED_ARMAGEDDON,      'FIRE')
  __h55__local_837561_tag_elem(SPELL.FIREWALL,                  'FIRE')
  -- EARTH
  __h55__local_837561_tag_elem(SPELL.METEOR_SHOWER,             'EARTH')
  __h55__local_837561_tag_elem(SPELL.EMPOWERED_METEOR_SHOWER,   'EARTH')
  __h55__local_837561_tag_elem(SPELL.STONESPIKES,               'EARTH')
  __h55__local_837561_tag_elem(SPELL.EMPOWERED_STONESPIKES,     'EARTH')
  __h55__local_837561_tag_elem(SPELL.IMPLOSION,                 'EARTH')
  __h55__local_837561_tag_elem(SPELL.EMPOWERED_IMPLOSION,       'EARTH')
  __h55__local_837561_tag_elem(SPELL.EARTHQUAKE,                'EARTH')
  __h55__local_837561_tag_elem(SPELL.LAND_MINE,                 'EARTH')

  __h55_local_837561_SPELL_TAG_READY = 1
end


-- ============================================================================
-- 9) Immunity helpers
-- ============================================================================
function __h55__local_837561_magic_immune(cre)
  __h55__local_837561_ensure_imm_names()
  if __h55_local_837561_AB_IMM_MAGIC and HasAbility(cre, __h55_local_837561_AB_IMM_MAGIC) ~= nil then return 1 end
  return nil
end

function __h55__local_837561_mind_type_immune(cre)
  __h55__local_837561_ensure_imm_names()
  if __h55_local_837561_AB_IMM_MIND_CONTROL and HasAbility(cre, __h55_local_837561_AB_IMM_MIND_CONTROL) ~= nil then return 1 end
  if __h55_local_837561_AB_UNDEAD       and HasAbility(cre, __h55_local_837561_AB_UNDEAD)       ~= nil then return 1 end
  if __h55_local_837561_AB_ELEMENTAL    and HasAbility(cre, __h55_local_837561_AB_ELEMENTAL)    ~= nil then return 1 end
  if __h55_local_837561_AB_MECHANICAL   and HasAbility(cre, __h55_local_837561_AB_MECHANICAL)   ~= nil then return 1 end
  return nil
end

function IsImmuneToMind(cre)
  if __h55__local_837561_magic_immune(cre) ~= nil then return 1 end
  if __h55__local_837561_mind_type_immune(cre) ~= nil then return 1 end
  return nil
end

function IsImmuneToFrenzy(cre)
  __h55__local_837561_ensure_imm_names()
  if __h55__local_837561_magic_immune(cre) ~= nil then return 1 end
  if __h55_local_837561_AB_IMM_BERSERK and HasAbility(cre, __h55_local_837561_AB_IMM_BERSERK) ~= nil then return 1 end
  if IsImmuneToMind(cre) ~= nil then return 1 end
  return nil
end

function IsImmuneToHypnosis(cre)
  __h55__local_837561_ensure_imm_names()
  if __h55__local_837561_magic_immune(cre) ~= nil then return 1 end
  if __h55_local_837561_AB_IMM_HYPNOTIZE and HasAbility(cre, __h55_local_837561_AB_IMM_HYPNOTIZE) ~= nil then return 1 end
  if IsImmuneToMind(cre) ~= nil then return 1 end
  return nil
end

function IsImmuneToBlind(cre)
  __h55__local_837561_ensure_imm_names()
  if __h55__local_837561_magic_immune(cre) ~= nil then return 1 end
  if __h55_local_837561_AB_IMM_BLIND and HasAbility(cre, __h55_local_837561_AB_IMM_BLIND) ~= nil then return 1 end
  if IsImmuneToMind(cre) ~= nil then return 1 end
  return nil
end

function IsImmuneToSlow(cre)
  __h55__local_837561_ensure_imm_names()
  if __h55__local_837561_magic_immune(cre) ~= nil then return 1 end
  if __h55_local_837561_AB_IMM_SLOW and HasAbility(cre, __h55_local_837561_AB_IMM_SLOW) ~= nil then return 1 end
  return nil
end

function IsImmuneToCurse(cre)
  __h55__local_837561_ensure_imm_names()
  if __h55__local_837561_magic_immune(cre) ~= nil then return 1 end
  if __h55_local_837561_AB_IMM_CURSE and HasAbility(cre, __h55_local_837561_AB_IMM_CURSE) ~= nil then return 1 end
  return nil
end

__h55_local_837561_ELEM_TO_ABILITY = {
  FIRE  = function() __h55__local_837561_ensure_imm_names(); return __h55_local_837561_AB_IMM_FIRE  end,
  WATER = function() __h55__local_837561_ensure_imm_names(); return __h55_local_837561_AB_IMM_WATER end,
  AIR   = function() __h55__local_837561_ensure_imm_names(); return __h55_local_837561_AB_IMM_AIR   end,
  EARTH = function() __h55__local_837561_ensure_imm_names(); return __h55_local_837561_AB_IMM_EARTH end,
}

function IsImmuneToElement(cre, element)
  if __h55__local_837561_magic_immune(cre) ~= nil then return 1 end
  local get = __h55_local_837561_ELEM_TO_ABILITY[element]
  if get ~= nil then
    local ab = get()
    if ab ~= nil and HasAbility(cre, ab) ~= nil then return 1 end
  end
  return nil
end

function IsImmuneToSpell(cre, spell)
  __h55__local_837561_ensure_spell_tags()
  local s = __h55__local_837561_norm_spell(spell); if s == nil then return nil end
  if __h55__local_837561_magic_immune(cre) ~= nil then return 1 end

  if SPELL and s == SPELL.BERSERK   then return IsImmuneToFrenzy(cre) end
  if SPELL and s == SPELL.HYPNOTIZE then return IsImmuneToHypnosis(cre) end
  if SPELL and s == SPELL.BLIND     then return IsImmuneToBlind(cre) end

  if SPELL and (s == SPELL.SLOW or s == SPELL.MASS_SLOW) then return IsImmuneToSlow(cre) end
  if SPELL and (s == SPELL.CURSE or s == SPELL.MASS_CURSE) then return IsImmuneToCurse(cre) end

  local elem = __h55_local_837561_SPELL_TO_ELEM[s.name]
  if elem ~= nil then return IsImmuneToElement(cre, elem) end
  return nil
end


-- ============================================================================
-- 10) Growth (BASE_GROWTH)
-- ============================================================================
function __h55__local_837561_coerce_growth_type(gt)
  if gt == GT.CITADEL or gt == 2 then return 2 end
  if gt == GT.CASTLE  or gt == 3 then return 3 end
  return 1
end

function _H55_GetGrowth(cre, growthType, with_asha, multiplier)
  __h55__local_837561_ensure_cache()
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

_H55_UnitHasAbility = _H55_UnitHasAbility or HasAbility
_H55_IsImmune       = _H55_IsImmune       or IsImmuneToSpell

-- Guard
H55_ENUM_FRAMEWORK_V9_LOADED = 1
-- ============================================================================ end
