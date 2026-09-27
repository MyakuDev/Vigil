-- ui feature: reset

Misc:button({Name = "Reset",Description = "kill character.",Callback = function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
end})
