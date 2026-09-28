-- void carry

_G.VoidCarry = {Enabled = false,Speed = 0.1}
local voidRunning = false
local voidState = "idle"
local voidSavedCFrame = nil

Troll:toggle({Name = "Void Carry",Description = "carries target then drops them into the void.",Default = false,Callback = function(state)
    VoidCarry.Enabled = state
    if not state then voidState = "idle" voidSavedCFrame = nil end
end})
Troll:textbox({Name = "Void Carry Speed",Default = "0.1",Callback = function(v) VoidCarry.Speed = tonumber(v) or VoidCarry.Speed end})

if not voidRunning then
    voidRunning = true
    task.spawn(function()
        while task.wait(VoidCarry.Speed) do
            if not VoidCarry.Enabled then voidState = "idle" continue end
            local target = TrollTarget.Player
            if not target or not target.Character then continue end
            local myChar = LocalPlayer.Character
            if not myChar then continue end
            local myHrp = myChar:FindFirstChild("HumanoidRootPart")
            local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
            if not (myHrp and targetHrp) then continue end
            local charFunEvent = getCharFunEvent()
            if not charFunEvent then continue end
            if voidState == "idle" then
                voidSavedCFrame = myHrp.CFrame
                myHrp.CFrame = targetHrp.CFrame
                charFunEvent:FireServer("Carry")
                voidState = "carrying"
            elseif voidState == "carrying" then
                myHrp.CFrame = CFrame.new(0, -500, 0)
                voidState = "dropping"
            elseif voidState == "dropping" then
                charFunEvent:FireServer("Carry")
                if voidSavedCFrame then myHrp.CFrame = voidSavedCFrame end
                voidState = "cleanup"
            elseif voidState == "cleanup" then
                local ragdollEvent = getRagdollEvent()
                if ragdollEvent then ragdollEvent:FireServer(false) end
                voidState = "idle"
                voidSavedCFrame = nil
            end
        end
    end)
end
