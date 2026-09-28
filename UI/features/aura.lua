-- ui feature: aura

Abuse:toggle({Name = "Aura",Description = "auto rapier swing + hit.",Default = false,Callback = function(s)
    Aura.Enabled = s
    Aura.State = s and "Enabled" or "Disabled"
end})
Abuse:textbox({Name = "Aura Distance",Default = "15",Callback = function(v) Aura.Distance = tonumber(v) or Aura.Distance end})
<<<<<<< HEAD
Abuse:textbox({Name = "Aura Speed",Default = "0.1",Callback = function(v) Aura.Speed = tonumber(v) or Aura.Speed end})
=======
Abuse:textbox({Name = "Aura Speed",Default = "0.1",Callback = function(v) Aura.Speed = tonumber(v) or Aura.Speed end})
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
