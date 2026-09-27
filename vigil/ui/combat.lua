--!nonstrict
local V = _G.Vigil
local Tabs = V.Window.Tabs
local State = V.State.State
local saveState = V.State.save
local Carry = V.Carry
local SVC = V.Services
Tabs.Combat:AddToggle("CrateNotifier", { Title = "Crate Notifier", Default = State.crateNotifier }):OnChanged(function(v) State.crateNotifier = v; saveState() end)
Tabs.Combat:AddToggle("AutoKick", { Title = "Auto Kick Ragdolled", Default = State.autoKick }):OnChanged(function(v) State.autoKick = v; saveState() end)
Tabs.Combat:AddToggle("AutoCarryV2", { Title = "Auto-Carry V2", Default = State.autoCarryV2 }):OnChanged(function(v) State.autoCarryV2 = v; saveState() end)
Tabs.Combat:AddInput("AutoCarryV2Range", { Title = "Auto-Carry V2 Range", Default = tostring(State.autoCarryV2Range), Numeric = true, Finished = false }):OnChanged(function(v) local n = tonumber(v); if n then State.autoCarryV2Range = n; saveState() end end)
Tabs.Combat:AddToggle("AutoCarryDummy", { Title = "Auto-Carry Dummy", Default = State.autoCarryDummy }):OnChanged(function(v) State.autoCarryDummy = v; saveState() end)
Tabs.Combat:AddToggle("AutoVoidDummy", { Title = "Auto-Void Dummy", Default = State.autoVoidDummy }):OnChanged(function(v) State.autoVoidDummy = v; saveState() end)
Tabs.Combat:AddToggle("AutoNzDummy", { Title = "Auto-Nullzone Dummy", Default = State.autoNzDummy }):OnChanged(function(v) State.autoNzDummy = v; saveState() end)
Tabs.Combat:AddToggle("AutoReviveDummy", { Title = "Auto-Revive Dummy", Default = State.autoReviveDummy }):OnChanged(function(v) State.autoReviveDummy = v; saveState() end)
Tabs.Combat:AddToggle("AutoFollowDummy", { Title = "Auto-Follow Dummy", Default = State.autoFollowDummy }):OnChanged(function(v) State.autoFollowDummy = v; saveState() end)
local carryV2Lock = false
SVC.Run.Heartbeat:Connect(function()
    if not State.autoCarryV2 then return end
    if carryV2Lock then return end
    local myHrp = SVC.LP.Character and SVC.LP.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    local range = tonumber(State.autoCarryV2Range) or 500
    local nearest, bestDist = nil, range
    for _, plr in ipairs(SVC.Players:GetPlayers()) do
        if plr ~= SVC.LP and plr.Character and Carry.isRagdolled(plr.Character) then
            local th = plr.Character:FindFirstChild("HumanoidRootPart")
            if th then
                local d = (myHrp.Position - th.Position).Magnitude
                if d < bestDist then nearest = plr; bestDist = d end
            end
        end
    end
    if not nearest then return end
    carryV2Lock = true
    task.spawn(function() pcall(Carry.carryTarget, nearest); task.wait(0.5); carryV2Lock = false end)
end)