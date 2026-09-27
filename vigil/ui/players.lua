--!nonstrict
local V = _G.Vigil
local Tabs = V.Window.Tabs
local State = V.State.State
local saveState = V.State.save
local SVC = V.Services
local API = V.API
local Lists = V.Lists
local Carry = V.Carry
Tabs.Players:AddInput("WLInput", { Title = "Whitelist by Username", Default = "", Finished = true }):OnChanged(function(v) if v ~= "" then task.spawn(API.addToList, Lists.WL, Lists.saveWL, v) end end)
Tabs.Players:AddInput("UnWLInput", { Title = "Remove from Whitelist", Default = "", Finished = true }):OnChanged(function(v) if v ~= "" then task.spawn(API.removeFromList, Lists.WL, Lists.saveWL, v) end end)
Tabs.Players:AddInput("BLInput", { Title = "Blacklist by Username", Default = "", Finished = true }):OnChanged(function(v) if v ~= "" then task.spawn(API.addToList, Lists.BL, Lists.saveBL, v) end end)
Tabs.Players:AddInput("UnBLInput", { Title = "Remove from Blacklist", Default = "", Finished = true }):OnChanged(function(v) if v ~= "" then task.spawn(API.removeFromList, Lists.BL, Lists.saveBL, v) end end)
Tabs.Players:AddButton({ Title = "Clear Whitelist", Callback = function() for k in pairs(Lists.WL) do Lists.WL[k] = nil end; Lists.saveWL() end })
Tabs.Players:AddButton({ Title = "Clear Blacklist", Callback = function() for k in pairs(Lists.BL) do Lists.BL[k] = nil end; Lists.saveBL() end })
Tabs.Players:AddToggle("WLO", { Title = "Whitelist Only", Default = State.whitelistOnly }):OnChanged(function(v) State.whitelistOnly = v; saveState() end)
Tabs.Players:AddToggle("AutoCarry", { Title = "Auto-Carry Whitelist", Default = State.autoCarry }):OnChanged(function(v) State.autoCarry = v; saveState() end)
Tabs.Players:AddToggle("VoidBL", { Title = "Void Carry Blacklist", Default = State.voidCarry }):OnChanged(function(v) State.voidCarry = v; saveState() end)
Tabs.Players:AddToggle("NZBL", { Title = "Nullzone Carry Blacklist", Default = State.nzCarry }):OnChanged(function(v) State.nzCarry = v; saveState() end)
local carryLocks = {}
local function tryAuto(plr, fn)
    if carryLocks[plr.UserId] then return end
    carryLocks[plr.UserId] = true
    task.spawn(function() pcall(fn, plr); task.wait(1); carryLocks[plr.UserId] = nil end)
end
SVC.Run.Heartbeat:Connect(function()
    for _, plr in ipairs(SVC.Players:GetPlayers()) do
        if plr == SVC.LP or not plr.Character then continue end
        if State.autoCarry and Lists.isWL(plr) then
            local hrp = SVC.LP.Character and SVC.LP.Character:FindFirstChild("HumanoidRootPart")
            local th = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp and th and (hrp.Position - th.Position).Magnitude <= 4 then
                if not Carry.isStanding(plr.Character) or Carry.isRagdolled(plr.Character) then Carry.fireCarry(plr.Character) end
            end
        end
        if State.voidCarry and Lists.isBL(plr) then tryAuto(plr, Carry.voidCarry) end
        if State.nzCarry and Lists.isBL(plr) then tryAuto(plr, Carry.nullzoneCarry) end
    end
end)