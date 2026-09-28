-- ui feature: parser tab body

local ParserTab = _G.ParserTab

ParserTab:button({
    Name = "Show Parser Stats",
    Description = "total users tracked + last update",
    Callback = function()
        Notify("Parser", #ParserData.users .. " users tracked | last update " .. tostring(ParserData.lastUpdated), 5)
    end,
})

ParserTab:button({
    Name = "Dump Parser Cache",
    Description = "prints every tracked user",
    Callback = function()
        local out = {}
        for _, u in ipairs(ParserData.users) do
            table.insert(out, (u.name or "?") .. " (" .. tostring(u.userId) .. ") [" .. (u.source or "?") .. "]")
        end
        if #out == 0 then
            NotifyInfo("no users tracked")
        else
            Notify("Parser (" .. #out .. ")", table.concat(out, ", "), 10)
        end
    end,
})

ParserTab:textbox({
    Name = "Lookup UserID",
    Description = "enter a userId to see parser info",
    Default = "",
    Callback = function(v)
        local id = tonumber(v)
        if not id then NotifyError("invalid userId") return end
        local entry = ParserGet(id)
        if entry then
            Notify("User " .. id, entry.name .. " (" .. (entry.displayName or "?") .. ") source: " .. (entry.source or "?"), 5)
        else
            NotifyInfo("not in parser cache")
        end
    end,
})

ParserTab:textbox({
    Name = "Add to Parser",
    Description = "userId name (displayName optional)",
    Default = "",
    Callback = function(v)
        local id, rest = v:match("^(%d+)%s+(.+)$")
        if not id then NotifyError("usage: userId name") return end
        local name, display = rest:match("^(%S+)%s+(.+)$")
        if not name then name = rest end
        ParserAdd(tonumber(id), name, display or name, "manual")
        NotifySuccess("added " .. tostring(id))
    end,
})

ParserTab:textbox({
    Name = "Remove from Parser",
    Description = "userId to remove",
    Default = "",
    Callback = function(v)
        local id = tonumber(v)
        if not id then NotifyError("invalid userId") return end
        if ParserRemove(id) then NotifySuccess("removed " .. id) else NotifyInfo("not found") end
    end,
})

ParserTab:button({
    Name = "Clear Parser",
    Description = "wipe parser cache",
    Callback = function()
        ParserData = {users = {}, lastUpdated = 0}
        ParserCache = {}
        ParserSave()
        NotifySuccess("parser cleared")
    end,
})

-- ----------------------------
-- sync actions
-- ----------------------------
ParserTab:button({
    Name = "Sync Whitelist -> Parser",
    Description = "add every whitelisted user to parser",
    Callback = function()
        local wl = ListData.Whitelist.users
        for _, u in ipairs(wl) do
            ParserAdd(u.userId, u.name, u.displayName, "whitelist")
        end
        NotifySuccess("synced " .. #wl .. " whitelist entries")
    end,
})

ParserTab:button({
    Name = "Sync Blacklist -> Parser",
    Description = "add every blacklisted user to parser",
    Callback = function()
        local bl = ListData.Blacklist.users
        for _, u in ipairs(bl) do
            ParserAdd(u.userId, u.name, u.displayName, "blacklist")
        end
        NotifySuccess("synced " .. #bl .. " blacklist entries")
    end,
})

ParserTab:button({
    Name = "Rebuild All JSONs",
    Description = "re-reads whitelist/blacklist/parser from disk",
    Callback = function()
        ParserLoad()
        if _G.LoadLists then LoadLists() end
        NotifySuccess("rebuilt all")
    end,
})
