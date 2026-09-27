-- ui feature: auto heal

Misc:toggle({Name = "Auto Heal",Description = "uses bandage when low.",Default = false,Callback = function(s)
    AutoHeal.Enabled = s
    AutoHeal.State = s and "Enabled" or "Disabled"
end})
Misc:textbox({Name = "Auto Heal Threshold",Default = "30",Callback = function(v) AutoHeal.Threshold = tonumber(v) or AutoHeal.Threshold end})
Misc:textbox({Name = "Auto Heal Delay",Default = "0.1",Callback = function(v) AutoHeal.Delay = tonumber(v) or AutoHeal.Delay end})
