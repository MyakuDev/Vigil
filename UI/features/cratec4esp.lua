-- ui feature: crate + c4 esp

Misc:toggle({Name = "Crate ESP",Description = "shows crates.",Default = false,Callback = function(s)
    CrateESP.Enabled = s
    CrateESP.State = s and "Enabled" or "Disabled"
end})
Misc:toggle({Name = "C4 ESP",Description = "highlights C4.",Default = false,Callback = function(s)
    C4ESP.Enabled = s
    C4ESP.State = s and "Enabled" or "Disabled"
end})
Misc:textbox({Name = "C4 ESP Radius",Default = "40",Callback = function(v) C4ESP.C4Radius = tonumber(v) or C4ESP.C4Radius end})
