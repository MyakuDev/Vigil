-- aura (rapier)

_G.Aura = _G.Aura or {
    Enabled  = false,
    State    = "Disabled",
    Distance = 15,
    Speed    = 0.1,
}

local auraRunning = false
local auraConn

local function getRapier()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("Rapier")
end

local function swing(rapier)
    if not rapier then return end
    local swing = rapier:FindFirstChild("swing")
    if swing then
        pcall(function() swing:FireServer() end)
    end
end

local function hit(rapier, targetHum, targetHrp)
    if not (rapier and targetHum and targetHrp) then return end
    local hit = rapier:FindFirstChild("hit")
    if hit then
        pcall(function()
            hit:FireServer(
                targetHum,
                targetHrp.Position,
                targetHrp,
                targetHrp.CFrame
            )
        end)
    end
end

_G.StartAura = function()
    if auraRunning then return end
    auraRunning = true

    auraConn = RunService.Heartbeat:Connect(function()
        if not Aura.Enabled then return end

        local rapier = getRapier()
        if not rapier then return end

        local char = LocalPlayer.Character
        local myHrp = char and char:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end

        swing(rapier)

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end

            local tChar = plr.Character
            if not tChar then continue end

            local tHum = tChar:FindFirstChildOfClass("Humanoid")
            local tHrp = tChar:FindFirstChild("HumanoidRootPart")
            if not (tHum and tHrp) then continue end
            if tHum.Health <= 0 then continue end

            if (myHrp.Position - tHrp.Position).Magnitude <= Aura.Distance then
                hit(rapier, tHum, tHrp)
            end
        end
    end)

    task.spawn(function()
        while auraRunning and Aura.Enabled do
            task.wait(Aura.Speed)
            if not Aura.Enabled then break end
            local rapier = getRapier()
            if rapier then swing(rapier) end
        end
    end)
end

_G.StopAura = function()
    auraRunning = false
    if auraConn then
        auraConn:Disconnect()
        auraConn = nil
    end
end

task.spawn(function()
    while true do
        task.wait(0.25)
        if Aura.Enabled and not auraRunning then
            StartAura()
        elseif not Aura.Enabled and auraRunning then
            StopAura()
        end
    end
end)

Abuse:toggle({
    Name = "Aura",
    Description = "auto swings + hits with Rapier.",
    Default = false,
    Callback = function(state)
        Aura.Enabled = state
        Aura.State = state and "Enabled" or "Disabled"
    end,
})

Abuse:textbox({
    Name = "Aura Distance",
    Description = "max range in studs",
    Default = tostring(Aura.Distance),
    Callback = function(v)
        Aura.Distance = tonumber(v) or Aura.Distance
    end,
})

Abuse:textbox({
    Name = "Aura Speed",
    Description = "swing interval in seconds",
    Default = tostring(Aura.Speed),
    Callback = function(v)
        Aura.Speed = tonumber(v) or Aura.Speed
    end,
})
