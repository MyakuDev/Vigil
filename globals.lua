-- globals

_G.Vigil = _G.Vigil or {}
_G.Vigil.Version    = "2.0.0"
_G.Vigil.Root       = "C:/Users/kirok/OneDrive/Desktop/Yunrine/Lua/Mortem Metallum/Vigil"
_G.Vigil.JsonRoot   = _G.Vigil.Root .. "/json"
_G.Vigil.ConfigsDir = _G.Vigil.Root .. "/configs"
_G.Vigil.Settings   = _G.Vigil.Settings or {}

_G.WhitelistEnabled     = false
_G.BlacklistEnabled     = false
_G.NotificationsEnabled = true

_G.VigilRefs = _G.VigilRefs or {}
_G.FeatureState = _G.FeatureState or {}
_G.ParserCache  = _G.ParserCache  or {}

_G.DeepCopy = function(t)
    local c = {}
    for k, v in pairs(t) do
        c[k] = type(v) == "table" and DeepCopy(v) or v
    end
    return c
end

_G.SafeCall = function(fn, ...)
    local ok, result = pcall(fn, ...)
    if not ok then warn("[Vigil] " .. tostring(result)) return nil end
    return result
end

_G.VigilState = function(feature)
    if feature == nil then return "Disabled" end
    return feature.Enabled and "Enabled" or "Disabled"
end
