-- stop run all

_G.StopRunAll = {Enabled = false,Delay = 0.1}
local stopRunRunning = false

Troll:toggle({Name = "Stop Run All",Description = "spams StopRun on all players.",Default = false,Callback = function(state) StopRunAll.Enabled = state end})
Troll:textbox({Name = "Stop Run All Delay",Default = "0.1",Callback = function(v) StopRunAll.Delay = tonumber(v) or StopRunAll.Delay end})

if not stopRunRunning then
    stopRunRunning = true
    task.spawn(function()
        while task.wait(StopRunAll.Delay) do
            if not StopRunAll.Enabled then continue end
            local charFunEvent = getCharFunEvent()
            if not charFunEvent then continue end
            charFunEvent:FireServer("StopRun")
        end
    end)
<<<<<<< HEAD
end
=======
end
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
