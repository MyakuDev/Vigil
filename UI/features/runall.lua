-- ui feature: run all

Troll:toggle({Name = "Run All",Description = "spams Run.",Default = false,Callback = function(s)
    RunAll.Enabled = s
    RunAll.State = s and "Enabled" or "Disabled"
end})
Troll:textbox({Name = "Run All Delay",Default = "0.1",Callback = function(v) RunAll.Delay = tonumber(v) or RunAll.Delay end})
Troll:textbox({Name = "Run All Value",Default = "5",Callback = function(v) RunAll.RunValue = tonumber(v) or RunAll.RunValue end})
