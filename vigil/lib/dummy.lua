--!nonstrict
local SVC = _G.Vigil.Services
local Notify = _G.Vigil.Notify
local Remotes = _G.Vigil.Remotes
local Carry = _G.Vigil.Carry
local State = _G.Vigil.State.State
local M = {}
local VOID_POS = Carry.VOID_POS
local NULLZONE_POS = Carry.NULLZONE_POS
local lastMissing = 0
function M.notifyMissing()
    local now = os.clock()
    if now - lastMissing < 10 then return end
    lastMissing = now
    Notify.vigil("waiting for a Dummy to appear in PlayersCharacters...", 3)
end
function M.findNearest()
    local folder = SVC.WS:FindFirstChild("PlayersCharacters")
    if not folder then return nil end
    local myHrp = SVC.LP.Character and SVC.LP.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil end
    local nearest, bestDist = nil, 1e9
    for _, m in pairs(folder:GetChildren()) do
        if m:IsA("Model") and m.Name == "Dummy" then
            local dh = m:FindFirstChild("HumanoidRootPart")
            if dh then
                local d = (myHrp.Position - dh.Position).Magnitude
                if d < bestDist then nearest = m; bestDist = d end
            end
        end
    end
    return nearest
end
function M.bringTo(dummyModel, destCF, platformKey)
    if not dummyModel or not dummyModel.Parent then return end
    local dHrp = dummyModel:FindFirstChild("HumanoidRootPart")
    if not dHrp or not dHrp.Parent then Notify.vigil("dummy has no hrp", 2); return end
    Carry.saveCarryPos()
    if platformKey then
        local plat = _G.Vigil.Platforms.get(platformKey)
        if plat then plat.CFrame = CFrame.new(destCF.Position) end
    end
    if not Carry.moveTo(dHrp.CFrame + Vector3.new(0, 2, 0), 8, 3) then
        Notify.vigil("could not reach dummy", 2)
        return
    end
    task.wait(0.15)
    Carry.setCarryStat(1)
    Remotes.refresh()
    if Remotes.CharFunEvent then pcall(function() Remotes.CharFunEvent:FireServer("Carry", dummyModel) end) end
    task.wait(0.15)
    if not Carry.moveTo(destCF, 8, 4) then
        Notify.vigil("could not reach destination", 2)
        return
    end
    task.wait(0.15)
    if Remotes.CharFunEvent then pcall(function() Remotes.CharFunEvent:FireServer("Carry", dummyModel) end) end
end
local carryLock = false
SVC.Run.Heartbeat:Connect(function()
    if not State.autoCarryDummy then return end
    if carryLock then return end
    local nearest = M.findNearest()
    if not nearest then M.notifyMissing(); return end
    if not Carry.isRagdolled(nearest) then return end
    carryLock = true
    task.spawn(function()
        pcall(function()
            Carry.saveCarryPos()
            local dh = nearest:FindFirstChild("HumanoidRootPart")
            if not dh or not dh.Parent then return end
            Carry.moveTo(dh.CFrame + Vector3.new(0, 2, 0), 8, 3)
            task.wait(0.15)
            Carry.setCarryStat(1)
            Remotes.refresh()
            if Remotes.CharFunEvent then Remotes.CharFunEvent:FireServer("Carry", nearest) end
        end)
        task.wait(0.5)
        carryLock = false
    end)
end)
local voidLock = false
SVC.Run.Heartbeat:Connect(function()
    if not State.autoVoidDummy then return end
    if voidLock then return end
    local nearest = M.findNearest()
    if not nearest then M.notifyMissing(); return end
    if not Carry.isRagdolled(nearest) then return end
    voidLock = true
    task.spawn(function()
        pcall(M.bringTo, nearest, CFrame.new(VOID_POS), "void")
        task.wait(1)
        voidLock = false
    end)
end)
local nzLock = false
SVC.Run.Heartbeat:Connect(function()
    if not State.autoNzDummy then return end
    if nzLock then return end
    local nearest = M.findNearest()
    if not nearest then M.notifyMissing(); return end
    if not Carry.isRagdolled(nearest) then return end
    nzLock = true
    task.spawn(function()
        pcall(M.bringTo, nearest, CFrame.new(NULLZONE_POS), "nullzone")
        task.wait(1)
        nzLock = false
    end)
end)
local reviveLock = false
SVC.Run.Heartbeat:Connect(function()
    if not State.autoReviveDummy then return end
    if reviveLock then return end
    local folder = SVC.WS:FindFirstChild("PlayersCharacters")
    if not folder then return end
    local dummy = folder:GetChildren()[3]
    if not dummy or not dummy.Parent then return end
    local torso = dummy:FindFirstChild("Torso")
    if not torso or not torso.Parent then return end
    local prompt = torso:FindFirstChild("RevivePrompt")
    if not prompt or not prompt.Parent or not prompt:IsA("ProximityPrompt") then return end
    if not prompt.Enabled then return end
    reviveLock = true
    task.spawn(function()
        pcall(function()
            if not prompt.Parent then return end
            prompt:InputHoldBegin()
            task.wait(prompt.HoldDuration + 0.05)
            if not prompt.Parent then return end
            prompt:InputHoldEnd()
        end)
        task.wait(1)
        reviveLock = false
    end)
end)
local followLock = false
SVC.Run.Heartbeat:Connect(function()
    if not State.autoFollowDummy then return end
    if followLock then return end
    local folder = SVC.WS:FindFirstChild("PlayersCharacters")
    if not folder then return end
    local dummy = folder:GetChildren()[3]
    if not dummy or not dummy.Parent then return end
    local hrp = dummy:FindFirstChild("HumanoidRootPart")
    if not hrp or not hrp.Parent then return end
    local prompt = hrp:FindFirstChild("follow")
    if not prompt or not prompt.Parent or not prompt:IsA("ProximityPrompt") then return end
    if not prompt.Enabled then return end
    followLock = true
    task.spawn(function()
        pcall(function()
            if not prompt.Parent then return end
            prompt:InputHoldBegin()
            task.wait(prompt.HoldDuration + 0.05)
            if not prompt.Parent then return end
            prompt:InputHoldEnd()
        end)
        task.wait(1)
        followLock = false
    end)
end)
return M