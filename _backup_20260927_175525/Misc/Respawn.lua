-- respawn

Misc:button({Name = "Respawn",Description = "kills + respawns at 0, 50, 0.",Callback = function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
    LocalPlayer.CharacterAdded:Wait()
    task.wait(1)
    local newChar = LocalPlayer.Character
    local hrp = newChar and newChar:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(0, 50, 0) end
end})
