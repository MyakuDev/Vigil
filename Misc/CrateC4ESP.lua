-- crates + c4 esp

_G.CrateESP = {Enabled = false}
_G.C4ESP = {Enabled = false,C4Radius = 40}
_G.CrateTP = {Enabled = false,Keybind = nil}

local crPart = Instance.new("Part")
crPart.Name = "VigilCrateMarker"
crPart.Size = Vector3.new(5, 5, 5)
crPart.Anchored = true
crPart.CanCollide = false
crPart.CanQuery = false
crPart.CanTouch = false
crPart.Transparency = 0.5
crPart.Color = Color3.fromRGB(255, 200, 0)
crPart.Material = Enum.Material.Neon
crPart.Parent = workspace

local c4Vis = Instance.new("Part")
c4Vis.Name = "VigilC4Marker"
c4Vis.Anchored = true
c4Vis.CanCollide = false
c4Vis.CanQuery = false
c4Vis.CanTouch = false
c4Vis.Transparency = 1
c4Vis.Material = Enum.Material.Neon
c4Vis.Parent = workspace

Misc:toggle({Name = "Crate ESP",Description = "shows crates on the map.",Default = false,Callback = function(state) CrateESP.Enabled = state end})
Misc:toggle({Name = "C4 ESP",Description = "highlights nearby C4.",Default = false,Callback = function(state) C4ESP.Enabled = state end})
Misc:textbox({Name = "C4 ESP Radius",Default = "40",Callback = function(v) C4ESP.C4Radius = tonumber(v) or C4ESP.C4Radius end})

local crateEspRunning = false

if not crateEspRunning then
    crateEspRunning = true
    RunService.Heartbeat:Connect(function()
        local crateFound = false
        for _, v in ipairs(workspace:GetDescendants()) do
            if v.Name == "CrateModel" then
                local model = v:FindFirstChild("Model")
                if model then
                    local flare = v:FindFirstChild("Flare")
                    local flareOn = flare and flare:FindFirstChild("On")
                    local attachment = flareOn and flareOn:FindFirstChild("Attachment")
                    local sizzling = attachment and attachment:FindFirstChild("sizzling")

                    if model:FindFirstChild("Parachute") then
                        crateFound = true
                    elseif sizzling and sizzling.IsPlaying then
                        crateFound = true
                    else
                        crateFound = false
                    end

                    if CrateESP.Enabled and crateFound then
                        local pos = v:GetPivot().Position
                        crPart.CFrame = CFrame.new(pos.X, 100, pos.Z)
                    else
                        crPart.CFrame = CFrame.new(9e9, 9e9, 9e9)
                    end
                end
            end
        end

        local myChar = LocalPlayer.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local closestC4 = nil
        local closestDist = math.huge

        if myHrp then
            for _, v in ipairs(workspace:GetDescendants()) do
                if v.Name == "C4" or v.Name == "C4Model" or v.Name == "C4Explosive" then
                    local pos = v:GetPivot().Position
                    local d = (myHrp.Position - pos).Magnitude
                    if d < closestDist then
                        closestDist = d
                        closestC4 = v
                    end
                end
            end
        end

        if closestC4 and C4ESP.Enabled then
            c4Vis.Transparency = 0.7
            c4Vis.CFrame = CFrame.new(closestC4:GetPivot().Position)
            if closestDist >= C4ESP.C4Radius then
                c4Vis.Color = Color3.new(0, 1, 0)
                c4Vis.Size = Vector3.new(82, 82, 82)
            else
                local size = closestDist * 2
                c4Vis.Color = Color3.new(1, 0, 0)
                c4Vis.Size = Vector3.new(size, size, size)
            end
        else
            c4Vis.Transparency = 1
        end
    end)
end
