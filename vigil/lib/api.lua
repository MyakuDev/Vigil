--!nonstrict
local SVC = _G.Vigil.Services
local Notify = _G.Vigil.Notify
local M = {}
function M.usernameToId(name)
    local ok, resp = pcall(function()
        return game:HttpPost("https://users.roblox.com/v1/usernames/users",
            SVC.Http:JSONEncode({ usernames = { tostring(name) }, excludeBannedUsers = false }),
            "Application/JSON")
    end)
    if not ok or not resp then return nil end
    local ok2, decoded = pcall(function() return SVC.Http:JSONDecode(resp) end)
    if not ok2 or not decoded.data or not decoded.data[1] then return nil end
    local e = decoded.data[1]
    return tonumber(e.id), tostring(e.name or ""), tostring(e.displayName or e.name or "")
end
function M.idToUsername(id)
    local ok, resp = pcall(function()
        return game:HttpGet("https://users.roblox.com/v1/users/" .. tostring(id))
    end)
    if not ok or not resp then return nil end
    local ok2, decoded = pcall(function() return SVC.Http:JSONDecode(resp) end)
    if not ok2 or not decoded.name then return nil end
    return tostring(decoded.name), tostring(decoded.displayName or decoded.name)
end
function M.resolve(query)
    if not query or query == "" then return nil, nil, nil end
    query = tostring(query):match("^%s*(.-)%s*$")
    local num = tonumber(query)
    if num then
        local name, display = M.idToUsername(num)
        return num, tostring(name or ("id:" .. tostring(num))), tostring(display or name or ("id:" .. tostring(num)))
    end
    local id, name, display = M.usernameToId(query)
    if id then
        return id, tostring(name or ("id:" .. tostring(id))), tostring(display or name or ("id:" .. tostring(id)))
    end
    for _, plr in ipairs(SVC.Players:GetPlayers()) do
        if tostring(plr.Name):lower() == tostring(query):lower() or tostring(plr.DisplayName):lower() == tostring(query):lower() then
            return plr.UserId, tostring(plr.Name), tostring(plr.DisplayName)
        end
    end
    return nil, nil, nil
end
function M.addToList(list, saveFn, query)
    local id, name, display = M.resolve(query)
    if not id then Notify.vigil("could not resolve " .. tostring(query), 3); return end
    local uname = tostring(name or ("id:" .. tostring(id)))
    local udisplay = tostring(display or name or ("id:" .. tostring(id)))
    local key = uname:lower()
    list[key] = { name = uname, displayName = udisplay, userId = id }
    saveFn()
    Notify.vigil(string.format("%s (%s)", uname, tostring(id)), 3)
end
function M.removeFromList(list, saveFn, query)
    local key = tostring(query):lower()
    if list[key] then
        list[key] = nil
        saveFn()
        Notify.vigil("removed " .. tostring(query), 3)
        return
    end
    local id = M.resolve(query)
    if id then
        for k, entry in pairs(list) do
            if entry.userId == id then
                list[k] = nil
                saveFn()
                Notify.vigil("removed " .. tostring(query), 3)
                return
            end
        end
    end
    Notify.vigil("not found: " .. tostring(query), 3)
end
return M