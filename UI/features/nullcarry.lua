-- ui feature: null carry

Troll:toggle({Name = "Null Carry",Description = "carries then drops target.",Default = false,Callback = function(s)
    NullCarry.Enabled = s
    NullCarry.State = s and "Enabled" or "Disabled"
end})
<<<<<<< HEAD
Troll:textbox({Name = "Null Carry Speed",Default = "0.1",Callback = function(v) NullCarry.Speed = tonumber(v) or NullCarry.Speed end})
=======
Troll:textbox({Name = "Null Carry Speed",Default = "0.1",Callback = function(v) NullCarry.Speed = tonumber(v) or NullCarry.Speed end})
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
