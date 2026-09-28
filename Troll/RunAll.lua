-- run all

_G.RunAll = {Enabled = false,Delay = 0.1,RunValue = 5}
local runAllRunning = false

Troll:toggle({Name = "Run All",Description = "spams Run on all players.",Default = false,Callback = function(state) RunAll.Enabled = state end})
Troll:textbox({Name = "Run All Delay",Default = "0.1",Callback = function(v) RunAll.Delay = tonumber(v) or RunAll.Delay end})
Troll:textbox({Name = "Run All Value",Default = "5",Callback = function(v) RunAll.RunValue = tonumber(v) or RunAll.RunValue end})

if not runAllRunning then
    runAllRunning = true
    task.spawn(function()
        while task.wait(RunAll.Delay) do
            if not RunAll.Enabled then continue end
            local charFunEvent = getCharFunEvent()
            if not charFunEvent then continue end
            charFunEvent:FireServer("Run", RunAll.RunValue)
        end
    end)
end
