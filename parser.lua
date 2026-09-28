-- parser (user tracking + json sync)

local HttpService = game:GetService("HttpService")

local JSON_ROOT  = _G.Vigil.JsonRoot
local WL_PATH    = JSON_ROOT .. "/whitelist.json"
local BL_PATH    = JSON_ROOT .. "/blacklist.json"
local PR_PATH    = JSON_ROOT .. "/parser.json"

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
-- parser cache (userId -> info)
-- ============================================================
_G.ParserData = _G.ParserData or {users = {}, lastUpdated = 0}

_G.ParserLoad = function()
    local data = readJson(PR_PATH)
    if data and data.users then
        ParserData = data
    else
        ParserData = {users = {}, lastUpdated = 0}
        ParserSave()
    end

    -- rebuild lookup cache
    ParserCache = {}
    for _, entry in ipairs(ParserData.users) do
        if entry.userId then
            ParserCache[entry.userId] = entry
        end
    end
end

_G.ParserSave = function()
    ParserData.lastUpdated = os.time()
    writeJson(PR_PATH, ParserData)
end

_G.ParserAdd = function(userId, name, displayName, source)
    if not userId then return end
    local entry = ParserCache[userId]
    if entry then
        entry.lastSeen = os.time()
        if name and name ~= "" then entry.name = name end
        if displayName and displayName ~= "" then entry.displayName = displayName end
        if source then entry.source = source end
    else
        entry = {
            userId = userId,
            name = name or "unknown",
            displayName = displayName or name or "unknown",
            firstSeen = os.time(),
            lastSeen = os.time(),
            source = source or "unknown",
        }
        table.insert(ParserData.users, entry)
        ParserCache[userId] = entry
    end
    ParserSave()
end

_G.ParserRemove = function(userId)
    for i, entry in ipairs(ParserData.users) do
        if entry.userId == userId then
            table.remove(ParserData.users, i)
            ParserCache[userId] = nil
            ParserSave()
            return true
        end
    end
    return false
end

_G.ParserGet = function(userId)
    return ParserCache[userId]
end

-- ============================================================
-- resolve name / displayName for a userId
-- ============================================================
local function resolveName(userId)
    local cached = ParserCache[userId]
    if cached and cached.name and cached.name ~= "unknown" then
        return cached.name, cached.displayName
    end

    local plr = Players:GetPlayerByUserId(userId)
    if plr then
        return plr.Name, plr.DisplayName
    end

    local ok, name = pcall(function()
        return Players:GetNameFromUserIdAsync(userId)
    end)
    if ok and name then
        return name, name
    end
    return "unknown_" .. tostring(userId), "unknown"
end

-- ============================================================
-- sync: any add/remove updates ALL three json files
-- ============================================================
_G.WhitelistAdd = function(userId, name, displayName)
    if not userId then return false end
    local wl = readJson(WL_PATH) or {users = {}}
    for _, entry in ipairs(wl.users) do
        if entry.userId == userId then return false end
    end

    local n, d = resolveName(userId)
    local entry = {
        userId = userId,
        name = name or n,
        displayName = displayName or d,
    }
    table.insert(wl.users, entry)
    writeJson(WL_PATH, wl)

    -- also add to parser with source=whitelist
    ParserAdd(userId, entry.name, entry.displayName, "whitelist")
    return true
end

_G.WhitelistRemove = function(userId)
    local wl = readJson(WL_PATH) or {users = {}}
    for i, entry in ipairs(wl.users) do
        if entry.userId == userId then
            table.remove(wl.users, i)
            writeJson(WL_PATH, wl)
            return true
        end
    end
    return false
end

_G.BlacklistAdd = function(userId, name, displayName)
    if not userId then return false end
    local bl = readJson(BL_PATH) or {users = {}}
    for _, entry in ipairs(bl.users) do
        if entry.userId == userId then return false end
    end

    local n, d = resolveName(userId)
    local entry = {
        userId = userId,
        name = name or n,
        displayName = displayName or d,
    }
    table.insert(bl.users, entry)
    writeJson(BL_PATH, bl)

    ParserAdd(userId, entry.name, entry.displayName, "blacklist")
    return true
end

_G.BlacklistRemove = function(userId)
    local bl = readJson(BL_PATH) or {users = {}}
    for i, entry in ipairs(bl.users) do
        if entry.userId == userId then
            table.remove(bl.users, i)
            writeJson(BL_PATH, bl)
            return true
        end
    end
    return false
end

-- ============================================================
-- lookup: is user whitelisted / blacklisted
-- ============================================================
_G.WhitelistHas = function(userId)
    local wl = readJson(WL_PATH) or {users = {}}
    for _, entry in ipairs(wl.users) do
        if entry.userId == userId then return entry end
    end
    -- also check groups
    local plr = Players:GetPlayerByUserId(userId)
    if plr then
        local gr = readJson(JSON_ROOT .. "/groups.json") or {groups = {}}
        for _, g in ipairs(gr.groups) do
            local ok, inGroup = pcall(function() return plr:IsInGroup(g.groupId) end)
            if ok and inGroup then return {userId = userId, name = plr.Name, group = g.name} end
        end
    end
    return nil
end

_G.BlacklistHas = function(userId)
    local bl = readJson(BL_PATH) or {users = {}}
    for _, entry in ipairs(bl.users) do
        if entry.userId == userId then return entry end
    end
    return nil
end

-- ============================================================
-- watch: track every player the script encounters
-- ============================================================
_G.ParserWatchPlayers = function()
    local function track(plr)
        ParserAdd(plr.UserId, plr.Name, plr.DisplayName, "seen")
    end

    for _, plr in ipairs(Players:GetPlayers()) do track(plr) end
    Players.PlayerAdded:Connect(track)
end

ParserLoad()
<<<<<<< HEAD
ParserWatchPlayers()
=======
ParserWatchPlayers()
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
