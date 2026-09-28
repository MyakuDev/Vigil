-- ui feature: anti beartrap

Antis:toggle({Name = "Anti Beartrap",Description = "spawns walk part over traps.",Default = false,Callback = function(s)
    AntiBearTrap.Enabled = s
    AntiBearTrap.State = s and "Enabled" or "Disabled"
<<<<<<< HEAD
end})
=======
end})
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
