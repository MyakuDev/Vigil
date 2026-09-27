--!nonstrict
local SVC = _G.Vigil.Services
local Notify = _G.Vigil.Notify
local Remotes = _G.Vigil.Remotes
local Platforms = _G.Vigil.Platforms
local M = {}
local VOID_POS = Vector3.new(100, 4500000, 100)
local NULLZONE_POS = Vector3.new(9e8, 9e8, 9e8)
local CTU = nil
local CRP = CFrame.new(0, 0, 0)
function M.getCarryValues()
    local char = SVC.LP.Character
    if not char then return nil end
    local info = char:FindFirstChild("CharacterInformation")
    if not info then return nil end
    return {
        CanCarry = info:FindFirstChild("CanCarry"),
        PlrCarrying = info:FindFirstChild("PlrCarrying"),
        IsCarryingSomeone = info:FindFirstChild("IsCarryingSomeone"),
    }
end
function M.setCarryStat(v)
    local vals = M.getCarryValues()
    if not vals or not vals.CanCarry then return false end
    pcall(function() vals.CanCarry.Value = v end)
    return true
end
function M.isRagdolled(char)
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local st = hum:GetState()
    return st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.FallingDown or hum.PlatformStand
end
function M.isStanding(char)
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local st = hum:GetState()
    return st == Enum.HumanoidStateType.Running or st == Enum.HumanoidStateType.RunningNoPhysics
        or st == Enum.HumanoidStateType.GettingUp or st == Enum.HumanoidStateType.Landed
end
function M.fireCarry(targetChar)
    M.setCarryStat(1)
    Remotes.refresh()
    if not Remotes.CharFunEvent then return false end
    return pcall(function() Remotes.CharFunEvent:FireServer("Carry", targetChar) end)
end
function M.fireUncarry(targetChar)
    Remotes.refresh()
    if not Remotes.CharFunEvent then return false end
    return pcall(function() Remotes.CharFunEvent:FireServer("Carry", targetChar) end)
end
function M.saveCarryPos()
    local hrp = SVC.LP.Character and SVC.LP.Character:FindFirstChild("HumanoidRootPart")
    if hrp then CRP = hrp.CFrame end
end
function M.moveTo(targetCF, tolerance, timeout)
    tolerance = tolerance or 8
    timeout = timeout or 3
    local hrp = SVC.LP.Character and SVC.LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    hrp.CFrame = targetCF
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    local t = os.clock()
    while os.clock() - t < timeout do
        hrp = SVC.LP.Character and SVC.LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        if (hrp.Position - targetCF.Position).Magnitude <= tolerance then return true end
        hrp.CFrame = targetCF
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        SVC.Run.Heartbeat:Wait()
    end
    return false
end
function M.waitForRagdoll(plr, timeout)
    timeout = timeout or 30
    local t = os.clock()
    while os.clock() - t < timeout do
        if not plr or not plr.Character then return false end
        if M.isRagdolled(plr.Character) then return true end
        SVC.Run.Heartbeat:Wait()
    end
    return false
end
function M.carryTarget(plr)
    if not plr or not plr.Character then return end
    local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not targetHrp then return end
    M.saveCarryPos()
    CTU = plr
    if not M.moveTo(targetHrp.CFrame + Vector3.new(0, 2, 0), 8, 3) then
        Notify.vigil("could not reach " .. tostring(plr.Name), 2)
        return
    end
    task.wait(0.15)
    M.fireCarry(plr.Character)
    Notify.vigil("carrying " .. tostring(plr.Name), 2)
end
function M.bringTo(plr, destCF, platformKey, waitRagdoll)
    if not plr or not plr.Character then return end
    if waitRagdoll then
        Notify.vigil("waiting for " .. tostring(plr.Name) .. " to ragdoll...", 3)
        if not M.waitForRagdoll(plr, 30) then
            Notify.vigil(tostring(plr.Name) .. " never ragdolled", 3)
            return
        end
    end
    if not M.isRagdolled(plr.Character) then
        Notify.vigil(tostring(plr.Name) .. " is not ragdolled", 2)
        return
    end
    local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not targetHrp then return end
    M.saveCarryPos()
    CTU = plr
    if platformKey then
        local plat = Platforms.get(platformKey)
        if plat then plat.CFrame = CFrame.new(destCF.Position) end
    end
    if not M.moveTo(targetHrp.CFrame + Vector3.new(0, 2, 0), 8, 3) then
        Notify.vigil("could not reach " .. tostring(plr.Name), 2)
        return
    end
    task.wait(0.15)
    M.fireCarry(plr.Character)
    task.wait(0.15)
    if not M.moveTo(destCF, 8, 4) then
        Notify.vigil("could not reach destination", 2)
        M.fireUncarry(plr.Character)
        return
    end
    task.wait(0.15)
    M.fireUncarry(plr.Character)
end
function M.returnCarry()
    local hrp = SVC.LP.Character and SVC.LP.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CRP end
    if CTU and CTU.Character then
        local th = CTU.Character:FindFirstChild("HumanoidRootPart")
        if th and hrp then th.CFrame = hrp.CFrame + Vector3.new(0, 0, -3) end
    end
    Notify.vigil("returned carry", 2)
end
function M.voidCarry(plr, waitRagdoll)
    if not plr then return end
    M.bringTo(plr, CFrame.new(VOID_POS), "void", waitRagdoll)
    Notify.vigil("void carrying " .. tostring(plr.Name), 2)
end
function M.nullzoneCarry(plr, waitRagdoll)
    if not plr then return end
    M.bringTo(plr, CFrame.new(NULLZONE_POS), "nullzone", waitRagdoll)
    Notify.vigil("nullzone carrying " .. tostring(plr.Name), 2)
end
function M.killTarget(plr, waitRagdoll)
    if not plr then return end
    M.voidCarry(plr, waitRagdoll)
    Notify.vigil("killing " .. tostring(plr.Name), 2)
end
function M.bulkCarry(fn, name)
    Notify.vigil(tostring(name) .. " started", 3)
    task.spawn(function()
        local seen = {}
        while true do
            local target
            for _, plr in ipairs(SVC.Players:GetPlayers()) do
                if plr ~= SVC.LP and plr.Character and M.isRagdolled(plr.Character) and not seen[plr.UserId] then
                    target = plr
                    break
                end
            end
            if not target then break end
            seen[target.UserId] = true
            pcall(fn, target)
            task.wait(1.2)
        end
    end)
end
M.VOID_POS = VOID_POS
M.NULLZONE_POS = NULLZONE_POS
return M