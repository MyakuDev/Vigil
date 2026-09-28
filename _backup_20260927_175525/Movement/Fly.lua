-- fly

_G.Fly = {Enabled = false,Speed = 50}
local flyRunning = false
local flyConn
local bv, bg

_G.startFly = function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 1000
    bg.D = 50
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp
    flyConn = RunService.Heartbeat:Connect(function()
        if not Fly.Enabled then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not (hrp and bv and bg) then return end
        local moveDir = Vector3.zero
        local cam = workspace.CurrentCamera
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0, 1, 0) end
        if moveDir.Magnitude > 0 then bv.Velocity = moveDir.Unit * Fly.Speed else bv.Velocity = Vector3.zero end
        bg.CFrame = cam.CFrame
    end)
end

_G.stopFly = function()
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
end

Movement:toggle({Name = "Fly",Description = "space = up, left ctrl = down.",Default = false,Callback = function(state)
    Fly.Enabled = state
    if state then startFly() else stopFly() end
end})
Movement:textbox({Name = "Fly Speed",Default = "50",Callback = function(v) Fly.Speed = tonumber(v) or Fly.Speed end})
