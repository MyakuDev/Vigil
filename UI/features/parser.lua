-- ui feature: parser

local ParserTab = _G.ParserTab

ParserTab:button({Name = "Show Stats",Callback = function()
    Notify("Parser", #ParserData.users .. " users tracked", 5)
end})
ParserTab:textbox({Name = "Lookup UserID",Default = "",Callback = function(v)
    local id = tonumber(v)
    if not id then NotifyError("invalid") return end
    local e = ParserGet(id)
    if e then Notify("User " .. id, e.name .. " (" .. (e.displayName or "?") .. ")", 5) else NotifyInfo("not found") end
end})
ParserTab:button({Name = "Dump Parser",Callback = function()
    local out = {}
    for _, u in ipairs(ParserData.users) do table.insert(out, u.name .. " (" .. u.userId .. ")") end
    if #out == 0 then NotifyInfo("empty") else Notify("Parser", table.concat(out, ", "), 10) end
end})
ParserTab:button({Name = "Clear Parser",Callback = function()
    ParserData = {users = {}, lastUpdated = 0}
    ParserCache = {}
    ParserSave()
    NotifySuccess("cleared")
<<<<<<< HEAD
end})
=======
end})
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
