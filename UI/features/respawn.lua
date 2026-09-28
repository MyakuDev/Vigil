-- ui feature: respawn

Misc:button({Name = "Respawn",Description = "kill + respawn at 0,50,0.",Callback = function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
    LocalPlayer.CharacterAdded:Wait()
    task.wait(1)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(0, 50, 0) end
<<<<<<< HEAD
end})
=======
end})
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
