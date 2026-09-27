-- no ragdoll

_G.NoRagdoll = {Enabled = false}
local noRagRunning = false
local btPart
local function getCharacterParts()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not (hum and hrp) then return nil end
    return char, hum, hrp
end

Antis:toggle({Name = "No Ragdoll",Description = "stay mobile while ragdolled.",Default = false,Callback = function(state) NoRagdoll.Enabled = state end})

if not noRagRunning then
    noRagRunning = true
    RunService.Heartbeat:Connect(function()
        if not NoRagdoll.Enabled then return end
        local char, hum, hrp = getCharacterParts()
        if not char then return end
        if not btPart or btPart.Parent ~= workspace then
            btPart = Instance.new("Part")
            btPart.Name = "VigilNoRagPart"
            btPart.Size = Vector3.new(2, 1, 2)
            btPart.CanCollide = false
            btPart.Anchored = true
            btPart.Transparency = 1
            btPart.Parent = workspace
        end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or hum.PlatformStand then
            btPart.CFrame = hrp.CFrame + Vector3.new(0, -3, 0)
            btPart.Transparency = 1
            hrp.CFrame = btPart.CFrame + Vector3.new(0, 3, 0)
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hrp.Velocity = Vector3.zero
        end
    end)
end
