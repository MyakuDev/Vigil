-- ui feature: debug

local DebugTab = _G.DebugTab

DebugTab:toggle({Name = "Admin Detection",Default = AdminSettings.Enabled,Callback = function(s) AdminSettings.Enabled = s end})
DebugTab:dropdown({Name = "Admin Kick Method",StartingText = "kick",Items = {{"Kick","kick"},{"Shutdown","shutdown"}},Callback = function(v) AdminSettings.KickMethod = v end})
DebugTab:toggle({Name = "Admin Notify",Default = AdminSettings.NotifyOnDetect,Callback = function(s) AdminSettings.NotifyOnDetect = s end})
DebugTab:button({Name = "Check Current Server",Callback = function()
    local found = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        local a = IsAdmin(plr.UserId, plr.Name)
        if a then table.insert(found, plr.Name .. " (" .. a.role .. ")") end
    end
    if #found == 0 then NotifyInfo("no admins") else Notify("Admins", table.concat(found, ", "), 5) end
end})
DebugTab:button({Name = "Dump Whitelist",Callback = function()
    local out = {}
    for _, u in ipairs(ListData.Whitelist.users) do table.insert(out, u.name .. " (" .. u.userId .. ")") end
    Notify("Whitelist (" .. #out .. ")", table.concat(out, ", "), 10)
end})
DebugTab:button({Name = "Character Info",Callback = function()
    local char = LocalPlayer.Character
    if not char then NotifyError("no character") return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local out = {}
    if hum then
        table.insert(out, "hp " .. math.floor(hum.Health))
        table.insert(out, "state " .. tostring(hum:GetState()))
    end
    if hrp then table.insert(out, string.format("pos %.1f %.1f %.1f", hrp.Position.X, hrp.Position.Y, hrp.Position.Z)) end
    Notify("Character", table.concat(out, " | "), 6)
end})
DebugTab:button({Name = "Player List",Callback = function()
    local out = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        table.insert(out, string.format("%s (%s) [%d]", plr.Name, plr.DisplayName, plr.UserId))
    end
    Notify("Players (" .. #out .. ")", table.concat(out, ", "), 8)
<<<<<<< HEAD
end})
=======
end})
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
