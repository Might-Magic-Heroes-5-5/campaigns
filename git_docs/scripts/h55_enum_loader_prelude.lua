-- h55_enum_loader_prelude.lua
-- Runtime loader: try known paths (bounded, no waits). Uses raw pcall ONLY here.
if not __h55__local_56424_freeze then
  __h55__paths = {
    "./scripts/h55_enum_runtime.lua",
    "./h55_enum_runtime.lua",
    "scripts/h55_enum_runtime.lua",
    "h55_enum_runtime.lua",
    "../scripts/h55_enum_runtime.lua",
    "../h55_enum_runtime.lua"
  }
  __h55__i = 1
  while __h55__paths[__h55__i] ~= nil do
    __h55__path = __h55__paths[__h55__i]
    if doFile then
      pcall(function() doFile(__h55__path) end)
      if __h55__local_56424_freeze then break end
    end
    __h55__i = __h55__i + 1
  end
  __h55__paths = nil __h55__i = nil __h55__path = nil
end

-- If helper missing, degrade gracefully: console + flying texts + no-op freezes.
if not __h55__local_56424_freeze then
  if write then write("[H55_ENUMS] h55_enum_runtime.lua not loaded; read-only protections DISABLED\n") end
  if PRINT_ERRORS_OBJECTS == nil then PRINT_ERRORS_OBJECTS = {} end
  if type(ShowFlyingSign) == "function" then
    __h55__j = 1
    if debug_print_object ~= nil then pcall(function() ShowFlyingSign("h55_enum_runtime.lua missing", debug_print_object, 5) end) end
    while PRINT_ERRORS_OBJECTS and PRINT_ERRORS_OBJECTS[__h55__j] ~= nil do
      pcall(function() ShowFlyingSign("h55_enum_runtime.lua missing", PRINT_ERRORS_OBJECTS[__h55__j], 5) end)
      __h55__j = __h55__j + 1
    end
    __h55__j = nil
  end
  function __h55__local_56424_freeze(tbl) return tbl end
  function __h55__local_56424_freeze_shallow(tbl) return tbl end
end
