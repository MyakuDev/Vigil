-- anti afk

_G.AntiAFK = {Enabled = false,Interval = 60}
local afkRunning = false

Misc:toggle({Name = "Anti AFK",Description = "fires virtual input every 60s.",Default = false,Callback = function(state) AntiAFK.Enabled = state end})
Misc:textbox({Name = "Anti AFK Interval",Description = "seconds between each anti-afk fire",Default = "60",Callback = function(v) AntiAFK.Interval = tonumber(v) or AntiAFK.Interval end})

if not afkRunning then
    afkRunning = true
    task.spawn(function()
        while task.wait(AntiAFK.Interval) do
            if not AntiAFK.Enabled then continue end
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end
