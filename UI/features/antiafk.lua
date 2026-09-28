-- ui feature: anti afk

Misc:toggle({Name = "Anti AFK",Description = "fires virtual input every N seconds.",Default = false,Callback = function(s)
    AntiAFK.Enabled = s
    AntiAFK.State = s and "Enabled" or "Disabled"
end})
Misc:textbox({Name = "Anti AFK Interval",Default = "60",Callback = function(v) AntiAFK.Interval = tonumber(v) or AntiAFK.Interval end})
