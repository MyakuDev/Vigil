-- ui feature: anti afk

Misc:toggle({Name = "Anti AFK",Description = "fires virtual input every N seconds.",Default = false,Callback = function(s)
    AntiAFK.Enabled = s
    AntiAFK.State = s and "Enabled" or "Disabled"
end})
<<<<<<< HEAD
Misc:textbox({Name = "Anti AFK Interval",Default = "60",Callback = function(v) AntiAFK.Interval = tonumber(v) or AntiAFK.Interval end})
=======
Misc:textbox({Name = "Anti AFK Interval",Default = "60",Callback = function(v) AntiAFK.Interval = tonumber(v) or AntiAFK.Interval end})
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
