-- lists (whitelist + blacklist + groups)
-- writes go through parser.lua so parser.json stays in sync

local HttpService = game:GetService("HttpService")
local Players    = game:GetService("Players")

local ROOT = (_G.Vigil and _G.Vigil.JsonRoot)
    or "C:/Users/kirok/OneDrive/Desktop/Yunrine/Lua/Mortem Metallum/Vigil/json"

local WL_PATH = ROOT .. "/whitelist.json"
local BL_PATH = ROOT .. "/blacklist.json"
local GR_PATH = ROOT .. "/groups.json"

_G.ListData = _G.ListData or {
    Root      = ROOT,
    Whitelist = {users = {}},
    Blacklist = {users = {}},
    Groups    = {groups = {}},
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

-- ============================================================
-- guards: only sync if parser is ready
-- ============================================================
local function parserReady()
    return _G.ParserAdd ~= nil
end

local function syncToParser(entry, source)
    if not parserReady() or not entry or not entry.userId then return end
    _G.ParserAdd(entry.userId, entry.name, entry.displayName, source)
end

local function notify(kind, text)
    if _G.Notify then
        _G.Notify(kind, text, 3)
    elseif _G.NotifySuccess and kind == "Success" then
        _G.NotifySuccess(text)
    elseif _G.NotifyError and kind == "Error" then
        _G.NotifyError(text)
    elseif _G.NotifyInfo and kind == "Info" then
        _G.NotifyInfo(text)
    end
end

-- ============================================================
-- load
-- ============================================================
_G.LoadLists = function()
    local wl = readJson(WL_PATH)
    local bl = readJson(BL_PATH)
    local gr = readJson(GR_PATH)

    ListData.Whitelist = (wl and wl.users)  and wl or {users = {}}
    ListData.Blacklist = (bl and bl.users)  and bl or {users = {}}
    ListData.Groups    = (gr and gr.groups) and gr or {groups = {}}

    -- push everything into parser (safe if parser not loaded yet)
    if parserReady() then
        for _, u in ipairs(ListData.Whitelist.users) do
            syncToParser(u, "whitelist")
        end
        for _, u in ipairs(ListData.Blacklist.users) do
            syncToParser(u, "blacklist")
        end
    end
end

-- ============================================================
-- whitelist
-- ============================================================
_G.AddToWhitelist = function(userId, name, displayName)
    if not userId then return false end

    -- dedupe
    for _, e in ipairs(ListData.Whitelist.users) do
        if e.userId == userId then
            notify("Info", "already whitelisted")
            return false
        end
    end

    -- route through parser helper if available
    if _G.WhitelistAdd then
        local ok = _G.WhitelistAdd(userId, name, displayName)
        if ok then
            LoadLists()
            notify("Success", "whitelisted " .. tostring(userId))
        end
        return ok
    end

    -- fallback: write direct + sync parser
    local entry = {
        userId = userId,
        name = name or "unknown",
        displayName = displayName or name or "unknown",
    }
    table.insert(ListData.Whitelist.users, entry)
    writeJson(WL_PATH, ListData.Whitelist)
    syncToParser(entry, "whitelist")
    notify("Success", "whitelisted " .. tostring(userId))
    return true
end

_G.RemoveFromWhitelist = function(userId)
    if _G.WhitelistRemove then
        local ok = _G.WhitelistRemove(userId)
        if ok then LoadLists() end
        return ok
    end
    for i, e in ipairs(ListData.Whitelist.users) do
        if e.userId == userId then
            table.remove(ListData.Whitelist.users, i)
            writeJson(WL_PATH, ListData.Whitelist)
            return true
        end
    end
    return false
end

-- ============================================================
-- blacklist
-- ============================================================
_G.AddToBlacklist = function(userId, name, displayName)
    if not userId then return false end

    for _, e in ipairs(ListData.Blacklist.users) do
        if e.userId == userId then
            notify("Info", "already blacklisted")
            return false
        end
    end

    if _G.BlacklistAdd then
        local ok = _G.BlacklistAdd(userId, name, displayName)
        if ok then
            LoadLists()
            notify("Success", "blacklisted " .. tostring(userId))
        end
        return ok
    end

    local entry = {
        userId = userId,
        name = name or "unknown",
        displayName = displayName or name or "unknown",
    }
    table.insert(ListData.Blacklist.users, entry)
    writeJson(BL_PATH, ListData.Blacklist)
    syncToParser(entry, "blacklist")
    notify("Success", "blacklisted " .. tostring(userId))
    return true
end

_G.RemoveFromBlacklist = function(userId)
    if _G.BlacklistRemove then
        local ok = _G.BlacklistRemove(userId)
        if ok then LoadLists() end
        return ok
    end
    for i, e in ipairs(ListData.Blacklist.users) do
        if e.userId == userId then
            table.remove(ListData.Blacklist.users, i)
            writeJson(BL_PATH, ListData.Blacklist)
            return true
        end
    end
    return false
end

-- ============================================================
-- lookups
-- ============================================================
_G.IsWhitelisted = function(userId)
    if _G.WhitelistHas then
        local ok, result = pcall(_G.WhitelistHas, userId)
        if ok then return result ~= nil end
    end
    for _, e in ipairs(ListData.Whitelist.users) do
        if e.userId == userId then return true end
    end
    for _, g in ipairs(ListData.Groups.groups) do
        local plr = Players:GetPlayerByUserId(userId)
        if plr then
            local ok, inGroup = pcall(function() return plr:IsInGroup(g.groupId) end)
            if ok and inGroup then return true end
        end
    end
    return false
end

_G.IsBlacklisted = function(userId)
    if _G.BlacklistHas then
        local ok, result = pcall(_G.BlacklistHas, userId)
        if ok then return result ~= nil end
    end
    for _, e in ipairs(ListData.Blacklist.users) do
        if e.userId == userId then return true end
    end
    return false
end

-- ============================================================
-- groups
-- ============================================================
_G.AddGroup = function(groupId, name)
    for _, g in ipairs(ListData.Groups.groups) do
        if g.groupId == groupId then return false end
    end
    table.insert(ListData.Groups.groups, {groupId = groupId, name = name or "unnamed"})
    writeJson(GR_PATH, ListData.Groups)
    return true
end

_G.RemoveGroup = function(groupId)
    for i, g in ipairs(ListData.Groups.groups) do
        if g.groupId == groupId then
            table.remove(ListData.Groups.groups, i)
            writeJson(GR_PATH, ListData.Groups)
            return true
        end
    end
    return false
end

-- ============================================================
-- auto-detect on join
-- ============================================================
Players.PlayerAdded:Connect(function(plr)
    if _G.IsBlacklisted and IsBlacklisted(plr.UserId) then
        notify("Blacklist", plr.Name .. " is blacklisted")
    end
    if _G.IsWhitelisted and IsWhitelisted(plr.UserId) then
        notify("Whitelist", plr.Name .. " is whitelisted")
    end
end)

-- initial load
<<<<<<< HEAD
LoadLists()
=======
LoadLists()
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
