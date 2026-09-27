-- anti void

_G.AntiVoid = {Enabled = false,YThreshold = -100,ReturnCFrame = CFrame.new(0, 100, 0)}
local antiVoidRunning = false

Antis:toggle({Name = "Anti Void",Description = "tp back up if you fall below the map.",Default = false,Callback = function(state) AntiVoid.Enabled = state end})
Antis:textbox({Name = "Anti Void Y Threshold",Default = "-100",Callback = function(v) AntiVoid.YThreshold = tonumber(v) or AntiVoid.YThreshold end})

if not antiVoidRunning then
    antiVoidRunning = true
    RunService.Heartbeat:Connect(function()
        if not AntiVoid.Enabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not (hum and root) then return end
        if hum:GetState() == Enum.HumanoidStateType.Freefall and root.Position.Y < AntiVoid.YThreshold then
            root.CFrame = AntiVoid.ReturnCFrame
        end
    end)
end
