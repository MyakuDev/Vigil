-- reset

Misc:button({Name = "Reset",Description = "resets your character.",Callback = function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
<<<<<<< HEAD
end})
=======
end})
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
