-- configs

local HttpService = game:GetService("HttpService")

local ROOT       = (_G.Vigil and _G.Vigil.Root) or "C:/Users/kirok/OneDrive/Desktop/Yunrine/Lua/Mortem Metallum/Vigil"
local CONFIG_DIR = ROOT .. "/configs"
local MAIN_PATH  = CONFIG_DIR .. "/settings.json"

_G.ConfigSystem = _G.ConfigSystem or {
    Current   = nil,
    AutoLoad  = "",
    Directory = CONFIG_DIR,
}

-- ============================================================
-- json helpers
-- ============================================================
local function readJson(path)
    local ok, raw = pcall(readfile, path)
    if not ok or not raw or raw == "" then return nil end
    local ok2, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok2 then return nil end
    return decoded
end

local function writeJson(path, tbl)
    local ok, encoded = pcall(function() return HttpService:JSONEncode(tbl) end)
    if not ok then return false end
    pcall(writefile, path, encoded)
    return true
end

local function fileExists(path)
    local ok = pcall(readfile, path)
    return ok
end

-- ============================================================
-- snapshot: gather every feature's current state
-- ============================================================
local function snapshot()
    local data = {features = {}}

    local function capture(name, tbl)
        if not tbl then return end
        local copy = {}
        for k, v in pairs(tbl) do
            local t = type(v)
            if t ~= "function" and t ~= "userdata" and t ~= "thread" then
                copy[k] = v
            end
        end
        data.features[name] = copy
    end

    capture("Blink",        _G.Blink)
    capture("Fly",          _G.Fly)
    capture("Aura",         _G.Aura)
    capture("SemiShort",    _G.SemiShort)
    capture("AntiAFK",      _G.AntiAFK)
    capture("InfiniteJump", _G.InfiniteJump)
    capture("AutoHeal",     _G.AutoHeal)
    capture("NoFog",        _G.NoFog)
    capture("ServerHop",    _G.ServerHop)
    capture("NoRagdoll",    _G.NoRagdoll)
    capture("AntiBearTrap", _G.AntiBearTrap)
    capture("AntiVoid",     _G.AntiVoid)
    capture("CrateESP",     _G.CrateESP)
    capture("C4ESP",        _G.C4ESP)
    capture("VoidCarry",    _G.VoidCarry)
    capture("NullCarry",    _G.NullCarry)
    capture("RunAll",       _G.RunAll)
    capture("StopRunAll",   _G.StopRunAll)
    capture("Admin",        _G.AdminSettings)

    data.keybinds = {}
    if _G.Keybinds then
        for k, v in pairs(Keybinds) do
            if typeof(v) == "EnumItem" then
                data.keybinds[k] = v.Name
            end
        end
    end

    return data
end

-- ============================================================
-- apply: restore every feature from a snapshot
-- ============================================================
local function apply(data)
    if not data or not data.features then return false end

    local function restore(name, tbl)
        if not tbl then return end
        local saved = data.features[name]
        if not saved then return end
        for k, v in pairs(saved) do
            pcall(function() tbl[k] = v end)
        end
    end

    restore("Blink",        _G.Blink)
    restore("Fly",          _G.Fly)
    restore("Aura",         _G.Aura)
    restore("SemiShort",    _G.SemiShort)
    restore("AntiAFK",      _G.AntiAFK)
    restore("InfiniteJump", _G.InfiniteJump)
    restore("AutoHeal",     _G.AutoHeal)
    restore("NoFog",        _G.NoFog)
    restore("ServerHop",    _G.ServerHop)
    restore("NoRagdoll",    _G.NoRagdoll)
    restore("AntiBearTrap", _G.AntiBearTrap)
    restore("AntiVoid",     _G.AntiVoid)
    restore("CrateESP",     _G.CrateESP)
    restore("C4ESP",        _G.C4ESP)
    restore("VoidCarry",    _G.VoidCarry)
    restore("NullCarry",    _G.NullCarry)
    restore("RunAll",       _G.RunAll)
    restore("StopRunAll",   _G.StopRunAll)
    restore("Admin",        _G.AdminSettings)

    if data.keybinds and _G.Keybinds then
        for name, keyName in pairs(data.keybinds) do
            local key = Enum.KeyCode[keyName]
            if key then
                Keybinds[name] = key
                if _G.ApplyKeybind then ApplyKeybind(name) end
            end
        end
    end

    return true
end

-- ============================================================
-- public api
-- ============================================================
_G.ConfigSave = function(name, overwrite)
    name = name or "default"
    local path = CONFIG_DIR .. "/" .. name .. ".json"

    if fileExists(path) and not overwrite then
        return false, "exists (pass overwrite=true)"
    end

    local data = snapshot()
    data.meta = {name = name, saved = os.time()}

    if writeJson(path, data) then
        if _G.NotifySuccess then NotifySuccess("saved config: " .. name) end
        return true
    end
    return false, "write failed"
end

_G.ConfigLoad = function(name)
    name = name or "default"
    local path = CONFIG_DIR .. "/" .. name .. ".json"
    if not fileExists(path) then return false, "not found" end

    local data = readJson(path)
    if not data then return false, "parse failed" end

    if apply(data) then
        ConfigSystem.Current = name
        if _G.NotifySuccess then NotifySuccess("loaded config: " .. name) end
        return true
    end
    return false, "apply failed"
end

_G.ConfigDelete = function(name)
    name = name or "default"
    local path = CONFIG_DIR .. "/" .. name .. ".json"
    if not fileExists(path) then return false, "not found" end
    local ok = pcall(delfile, path)
    if ok then
        if _G.NotifySuccess then NotifySuccess("deleted config: " .. name) end
        return true
    end
    return false, "delete failed"
end

_G.ConfigList = function()
    local names = {}
    local ok, files = pcall(listfiles, CONFIG_DIR)
    if not ok or not files then return names end
    for _, path in ipairs(files) do
        local name = path:match("([^/\\]+)%.json$")
        if name and name ~= "settings" then
            table.insert(names, name)
        end
    end
    table.sort(names)
    return names
end

_G.ConfigRename = function(old, new)
    local oldPath = CONFIG_DIR .. "/" .. old .. ".json"
    local newPath = CONFIG_DIR .. "/" .. new .. ".json"
    if not fileExists(oldPath) then return false, "old not found" end
    if fileExists(newPath) then return false, "new already exists" end
    local data = readJson(oldPath)
    if not data then return false, "parse failed" end
    if not writeJson(newPath, data) then return false, "write failed" end
    pcall(delfile, oldPath)
    return true
end

_G.ConfigExists  = fileExists
_G.ConfigSnapshot = snapshot
_G.ConfigApply   = apply

-- ============================================================
-- settings load / save
-- ============================================================
_G.LoadSettings = function()
    local s = readJson(MAIN_PATH)
    if not s then return false end

    if _G.Vigil then
        _G.Vigil.Settings = s
    end

    _G.WhitelistEnabled     = s.whitelistEnabled or false
    _G.BlacklistEnabled     = s.blacklistEnabled or false
    _G.NotificationsEnabled = s.notifications ~= false

    if s.adminDetection and _G.AdminSettings then
        AdminSettings.Enabled        = s.adminDetection.enabled ~= false
        AdminSettings.KickMethod     = s.adminDetection.kickMethod or "kick"
        AdminSettings.NotifyOnDetect = s.adminDetection.notifyOnDetect ~= false
    end

    return true
end

_G.SaveSettings = function()
    local s = readJson(MAIN_PATH) or {}
    s.theme             = s.theme or "Serika"
    s.menuKey           = s.menuKey or "Z"
    s.notifications     = _G.NotificationsEnabled ~= false
    s.whitelistEnabled  = _G.WhitelistEnabled or false
    s.blacklistEnabled  = _G.BlacklistEnabled or false
    s.autoLoadConfig    = ConfigSystem.AutoLoad or ""
    s.adminDetection    = s.adminDetection or {
        enabled = AdminSettings and AdminSettings.Enabled,
        kickMethod = AdminSettings and AdminSettings.KickMethod,
        notifyOnDetect = AdminSettings and AdminSettings.NotifyOnDetect,
    }
    s.ui                = s.ui or {animations = true, animationSpeed = 0.2, showTooltips = true}
    return writeJson(MAIN_PATH, s)
end

-- ============================================================
-- autoload
-- ============================================================
_G.ConfigInit = function()
    LoadSettings()
    local s = readJson(MAIN_PATH)
    if s and s.autoLoadConfig and s.autoLoadConfig ~= "" then
        ConfigSystem.AutoLoad = s.autoLoadConfig
        task.defer(function()
            task.wait(2)
            ConfigLoad(s.autoLoadConfig)
        end)
    end
end

ConfigInit()

-- ============================================================
-- presets
-- ============================================================
_G.ConfigListPresets = function()
    local names = {}
    local ok, files = pcall(listfiles, PRESET_DIR)
    if not ok or not files then return names end
    for _, path in ipairs(files) do
        local name = path:match("([^/\\]+)%.json$")
        if name then table.insert(names, name) end
    end
    table.sort(names)
    return names
end

_G.ConfigLoadPreset = function(name)
    if not name then return false, "no name" end
    local path = PRESET_DIR .. "/" .. name .. ".json"
    if not fileExists(path) then return false, "preset not found" end

    local data = readJson(path)
    if not data then return false, "parse failed" end

    if apply(data) then
        if _G.NotifySuccess then NotifySuccess("loaded preset: " .. name) end
        return true
    end
    return false, "apply failed"
end

_G.ConfigSaveAsPreset = function(name)
    if not name then return false, "no name" end
    local path = PRESET_DIR .. "/" .. name .. ".json"
    if fileExists(path) then return false, "preset already exists" end

    local data = snapshot()
    data.meta = {name = name, saved = os.time(), user = true}

    if writeJson(path, data) then
        if _G.NotifySuccess then NotifySuccess("saved preset: " .. name) end
        return true
    end
    return false, "write failed"
end

_G.ConfigDeletePreset = function(name)
    if not name then return false, "no name" end
    local path = PRESET_DIR .. "/" .. name .. ".json"
    if not fileExists(path) then return false, "not found" end
    local ok = pcall(delfile, path)
    if ok then
        if _G.NotifySuccess then NotifySuccess("deleted preset: " .. name) end
        return true
    end
    return false, "delete failed"
end
