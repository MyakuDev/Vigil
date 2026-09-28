-- semi short

_G.SemiShort = {Enabled = false,HipHeight = -1}
local semiRunning = false
local function getRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

Abuse:toggle({Name = "Semi Short",Description = "hipheight -1 + camera-following cframe.",Default = false,Callback = function(state)
    SemiShort.Enabled = state
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and not state then hum.HipHeight = 2 end
end})
Abuse:textbox({Name = "Semi Short HipHeight",Default = "-1",Callback = function(v) SemiShort.HipHeight = tonumber(v) or SemiShort.HipHeight end})

if not semiRunning then
    semiRunning = true
    RunService.Heartbeat:Connect(function()
        if not SemiShort.Enabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local rootPart = getRoot(char)
        if not (hum and rootPart) then return end
        hum.HipHeight = SemiShort.HipHeight
        local mouseHit = LocalPlayer:GetMouse().Hit.Position
        local rootPos = rootPart.Position
        local newCFrame = CFrame.new(mouseHit,Vector3.new(rootPos.X, mouseHit.Y, rootPos.Z)) * CFrame.Angles(0, math.pi, 0)
        rootPart.CFrame = newCFrame + Vector3.new(0, hum.HipHeight or 4, 0)
        rootPart.Velocity = Vector3.zero
    end)
end
