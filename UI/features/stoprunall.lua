-- ui feature: stop run all

Troll:toggle({Name = "Stop Run All",Description = "spams StopRun.",Default = false,Callback = function(s)
    StopRunAll.Enabled = s
    StopRunAll.State = s and "Enabled" or "Disabled"
end})
Troll:textbox({Name = "Stop Run All Delay",Default = "0.1",Callback = function(v) StopRunAll.Delay = tonumber(v) or StopRunAll.Delay end})
