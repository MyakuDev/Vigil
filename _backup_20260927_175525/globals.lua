-- globals

_G.Vigil = _G.Vigil or {}
_G.Vigil.Version    = "1.0.0"
_G.Vigil.Root       = "C:/Users/kirok/OneDrive/Desktop/Yunrine/Lua/Mortem Metallum/Vigil"
_G.Vigil.JsonRoot   = _G.Vigil.Root .. "/json"
_G.Vigil.ConfigsDir = _G.Vigil.JsonRoot .. "/configs"

-- global toggles
_G.WhitelistEnabled = false
_G.BlacklistEnabled = false
_G.NotificationsEnabled = true

-- global refs (populated by services.lua)
_G.VigilRefs = {
    Players         = nil,
    RunService      = nil,
    UserInputService = nil,
    ReplicatedStorage = nil,
    TeleportService = nil,
    HttpService     = nil,
    VirtualUser     = nil,
    LocalPlayer     = nil,
}

-- global state tables (features populate these)
_G.FeatureState = _G.FeatureState or {}
_G.ParserCache  = _G.ParserCache  or {}   -- userId -> {name, displayName, firstSeen, lastSeen}

-- global utility
_G.DeepCopy = function(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            copy[k] = DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

_G.SafeCall = function(fn, ...)
    local ok, result = pcall(fn, ...)
    if not ok then
        warn("[Vigil] " .. tostring(result))
        return nil
    end
    return result
end
