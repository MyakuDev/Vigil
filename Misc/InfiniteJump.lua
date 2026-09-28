-- infinite jump

_G.InfiniteJump = {Enabled = false}
local ijRunning = false

Misc:toggle({Name = "Infinite Jump",Description = "hold space to jump infinitely.",Default = false,Callback = function(state) InfiniteJump.Enabled = state end})

if not ijRunning then
    ijRunning = true
    RunService.Heartbeat:Connect(function()
        if not InfiniteJump.Enabled then return end
        if not UserInputService:IsKeyDown(Enum.KeyCode.Space) then return end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end
