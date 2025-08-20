-- ./scripts/h55_freeze.lua
-- NOTE: file-scope "locals" are not supported in H5; use prefixed globals.

-- Pseudo-local sentinel to signal the include has finished loading.
__h55_local_56424_freeze_ready = 0

-- Pseudo-local registry for frozen tables (weak keys).
__h55_local_56424_frozen = setmetatable({}, { __mode = 'k' })

-- Formerly: local function freeze(t, deep)
-- Now: uniquely-named global to avoid collisions/redeclarations.
function __h55__local_56424_freeze(t, deep)
  if type(t) ~= 'table' then return t end
  if __h55_local_56424_frozen[t] then return t end

  -- If metamethods are available, make table read-only.
  local getmt = getmetatable
  local setmt = setmetatable
  if getmt and setmt then
    local mt = getmt(t) or {}
    if not mt.__readonly then
      mt.__newindex  = function() error('attempt to modify a frozen table', 2) end
      mt.__metatable = 'locked'
      mt.__readonly  = true
      setmt(t, mt)
    end
  end

  __h55_local_56424_frozen[t] = true

  if deep then
    for _, v in pairs(t) do
      if type(v) == 'table' then __h55__local_56424_freeze(v, true) end
    end
  end
  return t
end

-- Mark include as ready.
__h55_local_56424_freeze_ready = 1
