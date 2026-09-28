-- ui feature: lists

local ListsTab = _G.ListsTab

ListsTab:textbox({Name = "Whitelist UserID",Default = "",Callback = function(v)
    local id = tonumber(v)
    if not id then NotifyError("invalid userID") return end
    if AddToWhitelist(id) then NotifySuccess("whitelisted " .. id) else NotifyInfo("already whitelisted") end
end})
ListsTab:textbox({Name = "Remove Whitelist",Default = "",Callback = function(v)
    local id = tonumber(v)
    if not id then NotifyError("invalid userID") return end
    if RemoveFromWhitelist(id) then NotifySuccess("removed " .. id) else NotifyInfo("not found") end
end})
ListsTab:button({Name = "Show Whitelist",Callback = function()
    local out = {}
    for _, u in ipairs(ListData.Whitelist.users) do table.insert(out, (u.name or "?") .. " (" .. u.userId .. ")") end
    if #out == 0 then NotifyInfo("empty") else Notify("Whitelist", table.concat(out, ", "), 5) end
end})
ListsTab:button({Name = "Clear Whitelist",Callback = function()
    ListData.Whitelist.users = {}
    SaveLists()
    NotifySuccess("cleared")
end})

ListsTab:textbox({Name = "Blacklist UserID",Default = "",Callback = function(v)
    local id = tonumber(v)
    if not id then NotifyError("invalid userID") return end
    if AddToBlacklist(id) then NotifySuccess("blacklisted " .. id) else NotifyInfo("already blacklisted") end
end})
ListsTab:textbox({Name = "Remove Blacklist",Default = "",Callback = function(v)
    local id = tonumber(v)
    if not id then NotifyError("invalid userID") return end
    if RemoveFromBlacklist(id) then NotifySuccess("removed " .. id) else NotifyInfo("not found") end
end})
ListsTab:button({Name = "Show Blacklist",Callback = function()
    local out = {}
    for _, u in ipairs(ListData.Blacklist.users) do table.insert(out, (u.name or "?") .. " (" .. u.userId .. ")") end
    if #out == 0 then NotifyInfo("empty") else Notify("Blacklist", table.concat(out, ", "), 5) end
end})
ListsTab:button({Name = "Clear Blacklist",Callback = function()
    ListData.Blacklist.users = {}
    SaveLists()
    NotifySuccess("cleared")
end})
