-- anti beartrap

_G.AntiBearTrap = {Enabled = false}
local bearRunning = false

Antis:toggle({Name = "Anti Beartrap",Description = "spawns walk part over traps.",Default = false,Callback = function(state) AntiBearTrap.Enabled = state end})

if not bearRunning then
    bearRunning = true
    local function addWalk(trap)
        local detect = trap:FindFirstChild("detect")
        if not detect then return end
        if detect:FindFirstChild("Walk") then return end
        local WalkOver = Instance.new("Part")
        WalkOver.Name = "Walk"
        WalkOver.Size = Vector3.new(6, 2.89, 6)
        WalkOver.CFrame = detect.CFrame
        WalkOver.Anchored = true
        WalkOver.CanCollide = true
        WalkOver.CanQuery = false
        WalkOver.CanTouch = false
        WalkOver.Transparency = 1
        WalkOver.Parent = detect
    end
    local function removeWalk(trap)
        local detect = trap:FindFirstChild("detect")
        if not detect then return end
        local walk = detect:FindFirstChild("Walk")
        if walk then walk:Destroy() end
    end
    local function scan()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v.Name == "BEARTRAP" and v:FindFirstChild("detect") then
                if AntiBearTrap.Enabled then addWalk(v) else removeWalk(v) end
            end
        end
    end
    workspace.DescendantAdded:Connect(function(v)
        if v.Name == "BEARTRAP" and v:FindFirstChild("detect") and AntiBearTrap.Enabled then addWalk(v) end
    end)
    task.spawn(function()
        while task.wait(1) do scan() end
    end)
end
