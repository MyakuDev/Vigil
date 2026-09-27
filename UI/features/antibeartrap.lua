-- ui feature: anti beartrap

Antis:toggle({Name = "Anti Beartrap",Description = "spawns walk part over traps.",Default = false,Callback = function(s)
    AntiBearTrap.Enabled = s
    AntiBearTrap.State = s and "Enabled" or "Disabled"
end})
