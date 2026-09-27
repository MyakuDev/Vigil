-- blink

_G.Blink = {Enabled = false,Speed = 0.2,Distance = 15,VerticalBoost = 5,StillForward = -15,StillUp = 15,StillBack = -5}
local omni_Tick = 0
local blinkRunning = false

Main:toggle({Name = "Blink",Description = "cframe dash. lower speed = faster blinks.",Default = false,Callback = function(state) Blink.Enabled = state end})
Main:textbox({Name = "Blink Speed",Description = "delay between blinks (lower = faster)",Default = "0.2",Callback = function(v) Blink.Speed = tonumber(v) or Blink.Speed end})
Main:textbox({Name = "Blink Distance",Default = "15",Callback = function(v) Blink.Distance = tonumber(v) or Blink.Distance end})
Main:textbox({Name = "Vertical Boost",Default = "5",Callback = function(v) Blink.VerticalBoost = tonumber(v) or Blink.VerticalBoost end})
Main:textbox({Name = "Still Forward",Default = "-15",Callback = function(v) Blink.StillForward = tonumber(v) or Blink.StillForward end})
Main:textbox({Name = "Still Up (Space)",Default = "15",Callback = function(v) Blink.StillUp = tonumber(v) or Blink.StillUp end})
Main:textbox({Name = "Still Back (Space)",Default = "-5",Callback = function(v) Blink.StillBack = tonumber(v) or Blink.StillBack end})

if not blinkRunning then
    blinkRunning = true
    RunService.Heartbeat:Connect(function()
        if not Blink.Enabled then return end
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and humanoid and char.Parent ~= ReplicatedStorage:FindFirstChild("PlayerHold") and (tick() - omni_Tick) >= Blink.Speed then
            omni_Tick = tick()
            local moveDir = humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    hrp.CFrame = hrp.CFrame * CFrame.new(0, Blink.VerticalBoost, 0) + (moveDir.Unit * Blink.Distance)
                else
                    hrp.CFrame = hrp.CFrame + (moveDir.Unit * Blink.Distance)
                end
            else
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, 0, 0) * CFrame.new(0, Blink.StillUp, Blink.StillBack)
                else
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, 0, 0) * CFrame.new(0, 0, Blink.StillForward)
                end
            end
        end
    end)
end
