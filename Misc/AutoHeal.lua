-- auto heal

_G.AutoHeal = {Enabled = false,Threshold = 30,Delay = 0.1}
local healRunning = false

Misc:toggle({Name = "Auto Heal",Description = "uses Bandage at 30 hp.",Default = false,Callback = function(state) AutoHeal.Enabled = state end})
Misc:textbox({Name = "Auto Heal Threshold",Default = "30",Callback = function(v) AutoHeal.Threshold = tonumber(v) or AutoHeal.Threshold end})
Misc:textbox({Name = "Auto Heal Delay",Default = "0.1",Callback = function(v) AutoHeal.Delay = tonumber(v) or AutoHeal.Delay end})

if not healRunning then
    healRunning = true
    task.spawn(function()
        while task.wait(AutoHeal.Delay) do
            if not AutoHeal.Enabled then continue end
            local char = LocalPlayer.Character
            if not char then continue end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then continue end
            if hum.Health > AutoHeal.Threshold then continue end
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local bandage = (backpack and backpack:FindFirstChild("Bandage")) or char:FindFirstChild("Bandage")
            if not bandage then continue end
            if bandage.Parent ~= char then hum:EquipTool(bandage) end
            if bandage.Parent == char then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new())
            end
        end
    end)
end
