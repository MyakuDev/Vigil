-- reset

Misc:button({Name = "Reset",Description = "resets your character.",Callback = function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
end})
