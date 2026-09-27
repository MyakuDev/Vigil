--!nonstrict
local SVC = _G.Vigil.Services
local Notify = _G.Vigil.Notify
local Carry = _G.Vigil.Carry
local Fly = _G.Vigil.Fly
local Platforms = _G.Vigil.Platforms
local State = _G.Vigil.State.State
local M = {}
local bindCache = {}
local selectedTarget = nil
function M.setSelectedTarget(plr) selectedTarget = plr end
local function keyCodeFromString(str)
    if not str or str == "None" then return nil end
    local ok, key = pcall(function() return Enum.KeyCode[str] end)
    if not ok or not key then return nil end
    return key
end
function M.rebuild()
    bindCache = {}
    local map = {
        [State.keybindVoidAll]       = function() Carry.bulkCarry(Carry.voidCarry, "void carry everyone") end,
        [State.keybindNzAll]         = function() Carry.bulkCarry(Carry.nullzoneCarry, "nullzone carry everyone") end,
        [State.keybindKillAll]       = function() Carry.bulkCarry(Carry.killTarget, "kill everyone") end,
        [State.keybindCarryNear]     = function()
            local nearest, bestDist = nil, 1e9
            local hrp = SVC.LP.Character and SVC.LP.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, plr in ipairs(SVC.Players:GetPlayers()) do
                if plr ~= SVC.LP and plr.Character and Carry.isRagdolled(plr.Character) then
                    local th = plr.Character:FindFirstChild("HumanoidRootPart")
                    if th then
                        local d = (hrp.Position - th.Position).Magnitude
                        if d < bestDist then nearest = plr; bestDist = d end
                    end
                end
            end
            if nearest then task.spawn(Carry.carryTarget, nearest) end
        end,
        [State.keybindReturn] = function() Carry.returnCarry() end,
        [State.keybindReset] = function()
            local head = SVC.LP.Character and SVC.LP.Character:FindFirstChild("Head")
            if head then head:Destroy() end
        end,
        [State.keybindFly] = function()
            State.fly = not State.fly
            Fly.set(State.fly)
            _G.Vigil.State.save()
            Notify.vigil("Fly " .. (State.fly and "on" or "off"), 2)
        end,
        [State.keybindFullbright] = function()
            State.fullbright = not State.fullbright
            _G.Vigil.State.save()
            Notify.vigil("Fullbright " .. (State.fullbright and "on" or "off"), 2)
        end,
        [State.keybindNoRagdoll] = function()
            State.noRagdoll = not State.noRagdoll
            _G.Vigil.State.save()
            Notify.vigil("No-Ragdoll " .. (State.noRagdoll and "on" or "off"), 2)
        end,
        [State.keybindInfiniteJump] = function()
            State.infiniteJump = not State.infiniteJump
            _G.Vigil.State.save()
            Notify.vigil("Infinite Jump " .. (State.infiniteJump and "on" or "off"), 2)
        end,
        [State.keybindAntiFling] = function()
            State.antiFling = not State.antiFling
            _G.Vigil.State.save()
            Notify.vigil("Anti-Fling " .. (State.antiFling and "on" or "off"), 2)
        end,
        [State.keybindSafePlats] = function()
            State.useSafePlatforms = not State.useSafePlatforms
            if not State.useSafePlatforms then Platforms.clear()
            else Platforms.get("void"); Platforms.get("nullzone") end
            _G.Vigil.State.save()
            Notify.vigil("Safe Platforms " .. (State.useSafePlatforms and "on" or "off"), 2)
        end,
        [State.keybindGotoSelect] = function()
            if not selectedTarget or not selectedTarget.Character then Notify.vigil("no target selected", 2); return end
            local th = selectedTarget.Character:FindFirstChild("HumanoidRootPart")
            local mh = SVC.LP.Character and SVC.LP.Character:FindFirstChild("HumanoidRootPart")
            if th and mh then mh.CFrame = th.CFrame + Vector3.new(0, 2, 0) end
        end,
        [State.keybindVoidSelect] = function()
            if not selectedTarget or not selectedTarget.Character then Notify.vigil("no target selected", 2); return end
            task.spawn(Carry.voidCarry, selectedTarget)
        end,
        [State.keybindNzSelect] = function()
            if not selectedTarget or not selectedTarget.Character then Notify.vigil("no target selected", 2); return end
            task.spawn(Carry.nullzoneCarry, selectedTarget)
        end,
        [State.keybindCarrySelect] = function()
            if not selectedTarget or not selectedTarget.Character then Notify.vigil("no target selected", 2); return end
            task.spawn(Carry.carryTarget, selectedTarget)
        end,
    }
    for str, fn in pairs(map) do
        local key = keyCodeFromString(str)
        if key then bindCache[key] = fn end
    end
end
SVC.Input.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if SVC.Input:GetFocusedTextBox() then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local fn = bindCache[input.KeyCode]
    if fn then pcall(fn) end
end)
M.rebuild()
return M