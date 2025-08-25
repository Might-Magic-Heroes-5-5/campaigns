-- h55_enum_runtime.lua
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
