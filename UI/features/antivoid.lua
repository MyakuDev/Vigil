-- ui feature: anti void

Antis:toggle({Name = "Anti Void",Description = "tp back if you fall below map.",Default = false,Callback = function(s)
    AntiVoid.Enabled = s
    AntiVoid.State = s and "Enabled" or "Disabled"
end})
Antis:textbox({Name = "Anti Void Y Threshold",Default = "-100",Callback = function(v) AntiVoid.YThreshold = tonumber(v) or AntiVoid.YThreshold end})
