-- null carry

_G.NullCarry = {Enabled = false,Speed = 0.1}
local nullRunning = false
local nullState = "idle"
local nullSavedCFrame = nil

Troll:toggle({Name = "Null Carry",Description = "carries target then drops them.",Default = false,Callback = function(state)
    NullCarry.Enabled = state
    if not state then nullState = "idle" nullSavedCFrame = nil end
end})
Troll:textbox({Name = "Null Carry Speed",Default = "0.1",Callback = function(v) NullCarry.Speed = tonumber(v) or NullCarry.Speed end})

if not nullRunning then
    nullRunning = true
    task.spawn(function()
        while task.wait(NullCarry.Speed) do
            if not NullCarry.Enabled then nullState = "idle" continue end
            local target = TrollTarget.Player
            if not target or not target.Character then continue end
            local myChar = LocalPlayer.Character
            if not myChar then continue end
            local myHrp = myChar:FindFirstChild("HumanoidRootPart")
            local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
            if not (myHrp and targetHrp) then continue end
            local charFunEvent = getCharFunEvent()
            if not charFunEvent then continue end
            if nullState == "idle" then
                nullSavedCFrame = myHrp.CFrame
                myHrp.CFrame = targetHrp.CFrame
                charFunEvent:FireServer("Carry")
                nullState = "carrying"
            elseif nullState == "carrying" then
                charFunEvent:FireServer("Carry")
                if nullSavedCFrame then myHrp.CFrame = nullSavedCFrame end
                nullState = "cleanup"
            elseif nullState == "cleanup" then
                local ragdollEvent = getRagdollEvent()
                if ragdollEvent then ragdollEvent:FireServer(false) end
                nullState = "idle"
                nullSavedCFrame = nil
            end
        end
    end)
end
