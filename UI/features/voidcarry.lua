-- ui feature: void carry

Troll:toggle({Name = "Void Carry",Description = "carries target then drops into void.",Default = false,Callback = function(s)
    VoidCarry.Enabled = s
    VoidCarry.State = s and "Enabled" or "Disabled"
end})
<<<<<<< HEAD
Troll:textbox({Name = "Void Carry Speed",Default = "0.1",Callback = function(v) VoidCarry.Speed = tonumber(v) or VoidCarry.Speed end})
=======
Troll:textbox({Name = "Void Carry Speed",Default = "0.1",Callback = function(v) VoidCarry.Speed = tonumber(v) or VoidCarry.Speed end})
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
