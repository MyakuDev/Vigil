-- commands tab

local Commands = gui:tab{Icon = "rbxassetid://6031224157",Name = "Commands"}

local function resolvePlayer(query)
    if not query or query == "" then return nil, "empty query" end
    local q = query:lower()
    local asId = tonumber(query)
    if asId then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.UserId == asId then return plr end
        end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Name:lower() == q then return plr end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.DisplayName:lower() == q then return plr end
    end
    local partial = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Name:lower():sub(1, #q) == q then table.insert(partial, plr) end
    end
    if #partial == 1 then return partial[1] end
    if #partial > 1 then
        local names = {}
        for _, p in ipairs(partial) do table.insert(names, p.Name) end
        return nil, "ambiguous: " .. table.concat(names, ", ")
    end
    partial = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.DisplayName:lower():sub(1, #q) == q then table.insert(partial, plr) end
    end
    if #partial == 1 then return partial[1] end
    if #partial > 1 then
        local names = {}
        for _, p in ipairs(partial) do table.insert(names, p.Name) end
        return nil, "ambiguous: " .. table.concat(names, ", ")
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Name:lower():find(q, 1, true) or plr.DisplayName:lower():find(q, 1, true) then
            return plr
        end
    end
    return nil, "not found"
end

local function tokenize(input)
    local tokens = {}
    local i = 1
    local len = #input
    while i <= len do
        local c = input:sub(i, i)
        if c == " " or c == "\t" then
            i = i + 1
        elseif c == '"' or c == "'" then
            local quote = c
            local j = i + 1
            local buf = ""
            while j <= len and input:sub(j, j) ~= quote do
                buf = buf .. input:sub(j, j)
                j = j + 1
            end
            table.insert(tokens, buf)
            i = j + 1
        else
            local j = i
            local buf = ""
            while j <= len and input:sub(j, j) ~= " " and input:sub(j, j) ~= "\t" do
                buf = buf .. input:sub(j, j)
                j = j + 1
            end
            table.insert(tokens, buf)
            i = j
        end
    end
    return tokens
end

local CMD = {}

CMD.goto = {Usage = "goto <player|me|x y z>",Desc = "tp to player or coords",Run = function(args)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return "no character" end
    if #args == 1 then
        if args[1]:lower() == "me" then return "already here" end
        local plr, err = resolvePlayer(args[1])
        if not plr then return err or "player not found" end
        local tHrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if tHrp then hrp.CFrame = tHrp.CFrame + Vector3.new(0, 3, 0) return "tp to " .. plr.Name end
        return "target has no hrp"
    elseif #args == 3 then
        local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
        if x and y and z then hrp.CFrame = CFrame.new(x, y, z) return string.format("tp %.1f %.1f %.1f", x, y, z) end
        return "invalid coords"
    end
    return "usage: goto <player|me|x y z>"
end}

CMD.fly = {Usage = "fly <speed?>",Desc = "toggle fly",Run = function(args)
    local s = tonumber(args[1])
    if s then Fly.Speed = s end
    Fly.Enabled = not Fly.Enabled
    if Fly.Enabled then startFly() else stopFly() end
    return "fly " .. (Fly.Enabled and "on" or "off") .. " @ " .. tostring(Fly.Speed)
end}

CMD.blink = {Usage = "blink <distance?>",Desc = "toggle blink",Run = function(args)
    local d = tonumber(args[1])
    if d then Blink.Distance = d end
    Blink.Enabled = not Blink.Enabled
    return "blink " .. (Blink.Enabled and "on" or "off") .. " @ " .. tostring(Blink.Distance)
end}

CMD.aura = {Usage = "aura <distance?>",Desc = "toggle rapier aura",Run = function(args)
    local d = tonumber(args[1])
    if d then Aura.Distance = d end
    Aura.Enabled = not Aura.Enabled
    return "aura " .. (Aura.Enabled and "on" or "off") .. " @ " .. tostring(Aura.Distance)
end}

CMD.voidcarry = {Usage = "voidcarry <player?>",Desc = "carry target to void",Run = function(args)
    if args[1] then
        local plr, err = resolvePlayer(args[1])
        if not plr then return err end
        TrollTarget.Player = plr
    end
    if not TrollTarget.Player then return "no target set" end
    VoidCarry.Enabled = not VoidCarry.Enabled
    return "voidcarry " .. (VoidCarry.Enabled and "on -> " or "off ") .. TrollTarget.Player.Name
end}

CMD.nullcarry = {Usage = "nullcarry <player?>",Desc = "carry then drop target",Run = function(args)
    if args[1] then
        local plr, err = resolvePlayer(args[1])
        if not plr then return err end
        TrollTarget.Player = plr
    end
    if not TrollTarget.Player then return "no target set" end
    NullCarry.Enabled = not NullCarry.Enabled
    return "nullcarry " .. (NullCarry.Enabled and "on -> " or "off ") .. TrollTarget.Player.Name
end}

CMD.bring = {Usage = "bring <who> <where>",Desc = "carry <who> to <where> then drop",Run = function(args)
    if #args < 2 then return "usage: bring <who> <where>" end
    local who, err1 = resolvePlayer(args[1])
    if not who then return "who: " .. (err1 or "not found") end
    local where, err2 = resolvePlayer(args[2])
    if not where then return "where: " .. (err2 or "not found") end
    if who == LocalPlayer then return "can't bring yourself" end
    if where == who then return "who and where are the same" end
    task.spawn(function()
        local myChar = LocalPlayer.Character
        if not myChar then return end
        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        local charFunEvent = getCharFunEvent()
        if not charFunEvent then return end
        local originalCFrame = myHrp.CFrame
        local whoHrp = who.Character and who.Character:FindFirstChild("HumanoidRootPart")
        if not whoHrp then return end
        myHrp.CFrame = whoHrp.CFrame
        task.wait(0.15)
        charFunEvent:FireServer("Carry")
        task.wait(0.3)
        local whereHrp = where.Character and where.Character:FindFirstChild("HumanoidRootPart")
        if not whereHrp then
            charFunEvent:FireServer("Carry")
            myHrp.CFrame = originalCFrame
            return
        end
        myHrp.CFrame = whereHrp.CFrame + Vector3.new(0, 0, -3)
        task.wait(0.3)
        charFunEvent:FireServer("Carry")
        task.wait(0.15)
        myHrp.CFrame = originalCFrame
    end)
    return "bringing " .. who.Name .. " to " .. where.Name
end}

CMD.runall = {Usage = "runall <value?>",Desc = "toggle Run spam",Run = function(args)
    local v = tonumber(args[1])
    if v then RunAll.RunValue = v end
    RunAll.Enabled = not RunAll.Enabled
    return "runall " .. (RunAll.Enabled and "on" or "off") .. " @ " .. tostring(RunAll.RunValue)
end}

CMD.stoprunall = {Usage = "stoprunall",Desc = "toggle StopRun spam",Run = function(args)
    StopRunAll.Enabled = not StopRunAll.Enabled
    return "stoprunall " .. (StopRunAll.Enabled and "on" or "off")
end}

CMD.heal = {Usage = "heal <threshold?>",Desc = "use Bandage",Run = function(args)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return "no character" end
    if args[1] then AutoHeal.Threshold = tonumber(args[1]) or AutoHeal.Threshold end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local bandage = (bp and bp:FindFirstChild("Bandage")) or char:FindFirstChild("Bandage")
    if not bandage then return "no bandage" end
    if bandage.Parent ~= char then hum:EquipTool(bandage) end
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new())
    return "healed"
end}

CMD.reset = {Usage = "reset",Desc = "kill character",Run = function(args)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 return "reset" end
    return "no character"
end}

CMD.respawn = {Usage = "respawn",Desc = "kill + respawn at 0,50,0",Run = function(args)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
    LocalPlayer.CharacterAdded:Wait()
    task.wait(1)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(0, 50, 0) end
    return "respawned"
end}

CMD.rejoin = {Usage = "rejoin",Desc = "rejoin current server",Run = function(args)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    return "rejoining..."
end}

CMD.who = {Usage = "who <player>",Desc = "show player info",Run = function(args)
    if not args[1] then return "usage: who <player>" end
    local plr, err = resolvePlayer(args[1])
    if not plr then return err end
    return string.format("%s | display: %s | id: %d", plr.Name, plr.DisplayName, plr.UserId)
end}

CMD.players = {Usage = "players",Desc = "list all players",Run = function(args)
    local out = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        table.insert(out, string.format("%s (%s) [%d]", plr.Name, plr.DisplayName, plr.UserId))
    end
    return table.concat(out, " | ")
end}

local function dispatch(input)
    if not input or input == "" then return end
    local tokens = tokenize(input)
    if #tokens == 0 then return end
    local name = tokens[1]:lower()
    local args = {}
    for i = 2, #tokens do table.insert(args, tokens[i]) end
    local cmd = CMD[name]
    if not cmd then
        gui:set_status("unknown: " .. name)
        return
    end
    local ok, result = pcall(cmd.Run, args)
    if not ok then
        gui:set_status("[x] " .. name .. ": " .. tostring(result))
    else
        gui:set_status("[>] " .. (result or ""))
    end
end

Commands:textbox({
    Name = "Command Input",
    Description = "type a command + args (quotes ok), press enter",
    Default = "",
    Callback = function(v)
        dispatch(v)
    end,
})

Commands:button({
    Name = "? show all commands",
    Description = "dumps every command + usage into the status bar",
    Callback = function()
        local lines = {}
        for name, cmd in pairs(CMD) do
            table.insert(lines, cmd.Usage)
        end
        table.sort(lines)
        gui:set_status(table.concat(lines, " | "))
    end,
})

for name, cmd in pairs(CMD) do
    Commands:button({
        Name = "? " .. cmd.Usage,
        Description = cmd.Desc,
        Callback = function()
            gui:set_status(cmd.Usage .. " - " .. cmd.Desc)
        end,
    })
<<<<<<< HEAD
end
=======
end
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
