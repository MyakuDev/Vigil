-- ui feature: debug tab body

local DebugTab = _G.DebugTab

-- ----------------------------
-- admin detection
-- ----------------------------
DebugTab:toggle({
    Name = "Admin Detection",
    Description = "auto-detects admins (on by default)",
    Default = AdminSettings.Enabled,
    Callback = function(state) AdminSettings.Enabled = state end,
})

DebugTab:dropdown({
    Name = "Admin Kick Method",
    Description = "what happens when an admin is detected",
    StartingText = "kick",
    Items = {
        {"Kick from game", "kick"},
        {"Shutdown server", "shutdown"},
    },
    Callback = function(v) AdminSettings.KickMethod = v end,
})

DebugTab:toggle({
    Name = "Admin Notify",
    Description = "show a notification when an admin joins",
    Default = AdminSettings.NotifyOnDetect,
    Callback = function(state) AdminSettings.NotifyOnDetect = state end,
})

DebugTab:button({
    Name = "List Admins",
    Description = "prints every tracked admin",
    Callback = function()
        local out = {}
        for _, admin in ipairs(AdminList) do
            table.insert(out, admin.name .. " (" .. admin.role .. ")")
        end
        Notify("Admins", table.concat(out, ", "), 8)
    end,
})

DebugTab:button({
    Name = "Check Current Server",
    Description = "scans current players for admins",
    Callback = function()
        local found = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            local admin = IsAdmin(plr.UserId, plr.Name)
            if admin then
                table.insert(found, plr.Name .. " (" .. admin.role .. ")")
            end
        end
        if #found == 0 then
            NotifyInfo("no admins in server")
        else
            Notify("Admins in server", table.concat(found, ", "), 5)
        end
    end,
})

-- ----------------------------
-- whitelist / blacklist
-- ----------------------------
DebugTab:toggle({
    Name = "Whitelist Enabled",
    Description = "gate features to whitelisted users",
    Default = false,
    Callback = function(state) _G.WhitelistEnabled = state end,
})

DebugTab:toggle({
    Name = "Blacklist Enabled",
    Description = "auto-kick blacklisted users",
    Default = false,
    Callback = function(state) _G.BlacklistEnabled = state end,
})

DebugTab:button({
    Name = "Dump Whitelist",
    Description = "prints every whitelisted user",
    Callback = function()
        local out = {}
        for _, u in ipairs(ListData.Whitelist.users) do
            table.insert(out, (u.name or "?") .. " (" .. tostring(u.userId) .. ")")
        end
        Notify("Whitelist (" .. #out .. ")", table.concat(out, ", "), 10)
    end,
})

DebugTab:button({
    Name = "Dump Blacklist",
    Description = "prints every blacklisted user",
    Callback = function()
        local out = {}
        for _, u in ipairs(ListData.Blacklist.users) do
            table.insert(out, (u.name or "?") .. " (" .. tostring(u.userId) .. ")")
        end
        Notify("Blacklist (" .. #out .. ")", table.concat(out, ", "), 10)
    end,
})

DebugTab:button({
    Name = "Dump Groups",
    Description = "prints every whitelisted group",
    Callback = function()
        local out = {}
        for _, g in ipairs(ListData.Groups.groups) do
            table.insert(out, g.name .. " (" .. tostring(g.groupId) .. ")")
        end
        Notify("Groups (" .. #out .. ")", table.concat(out, ", "), 10)
    end,
})

-- ----------------------------
-- character info
-- ----------------------------
DebugTab:button({
    Name = "Character Info",
    Description = "prints your character state",
    Callback = function()
        local char = LocalPlayer.Character
        if not char then NotifyError("no character") return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local out = {}
        if hum then
            table.insert(out, "hp " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth))
            table.insert(out, "state " .. tostring(hum:GetState()))
            table.insert(out, "hip " .. tostring(hum.HipHeight))
        end
        if hrp then
            table.insert(out, string.format("pos %.1f %.1f %.1f", hrp.Position.X, hrp.Position.Y, hrp.Position.Z))
        end
        Notify("Character", table.concat(out, " | "), 6)
    end,
})

DebugTab:button({
    Name = "Player List",
    Description = "prints every player with id/display",
    Callback = function()
        local out = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            table.insert(out, string.format("%s (%s) [%d]", plr.Name, plr.DisplayName, plr.UserId))
        end
        Notify("Players (" .. #out .. ")", table.concat(out, ", "), 8)
    end,
})

DebugTab:button({
    Name = "Rejoin",
    Description = "rejoin current server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end,
})

DebugTab:button({
    Name = "Server Hop",
    Description = "hop to a random server",
    Callback = function()
        if _G.hop then hop() end
    end,
})

-- ----------------------------
-- error log
-- ----------------------------
_G.DebugLog = _G.DebugLog or {}

DebugTab:textbox({
    Name = "Log Entry",
    Description = "prints a log line",
    Default = "",
    Callback = function(v)
        table.insert(DebugLog, os.date("%H:%M:%S") .. " " .. v)
        Notify("Log", v, 3)
    end,
})

DebugTab:button({
    Name = "Dump Log",
    Description = "print everything in the debug log",
    Callback = function()
        if #DebugLog == 0 then NotifyInfo("log empty") return end
        Notify("Log (" .. #DebugLog .. ")", table.concat(DebugLog, " | "), 10)
    end,
})

DebugTab:button({
    Name = "Clear Log",
    Description = "empty the debug log",
    Callback = function()
        DebugLog = {}
        NotifySuccess("log cleared")
    end,
})
