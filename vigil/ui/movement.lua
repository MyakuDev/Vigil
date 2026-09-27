--!nonstrict
local V = _G.Vigil
local Tabs = V.Window.Tabs
local State = V.State.State
local saveState = V.State.save
local SVC = V.Services
local Fly = V.Fly
local omniHeld, omniThread = false, nil
local function stopOmni() omniHeld = false; omniThread = nil end
local function startOmni()
    if omniThread then return end
    omniHeld = true
    omniThread = task.spawn(function()
        while omniHeld do
            local char = SVC.LP.Character
            local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum then
                local d = hum.MoveDirection
                if d.Magnitude > 0 then hrp.CFrame += Vector3.new(d.X * State.omniSpeed, 0, d.Z * State.omniSpeed) end
            end
            SVC.Run.Heartbeat:Wait()
        end
        omniThread = nil
    end)
end
SVC.Input.InputBegan:Connect(function(input, gpe)
    if gpe or SVC.Input:GetFocusedTextBox() then return end
    if State.omni and input.KeyCode == Enum.KeyCode.LeftShift then startOmni() end
end)
SVC.Input.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then stopOmni() end
end)
Tabs.Movement:AddToggle("OmniDash", { Title = "Omni-Dash (LShift)", Default = State.omni }):OnChanged(function(v) State.omni = v; if not v then stopOmni() end; saveState() end)
Tabs.Movement:AddInput("OmniSpeed", { Title = "Omni-Dash Speed", Default = tostring(State.omniSpeed), Numeric = true, Finished = false }):OnChanged(function(v) local n = tonumber(v); if n then State.omniSpeed = n; saveState() end end)
Tabs.Movement:AddToggle("InfiniteJump", { Title = "Infinite Jump", Default = State.infiniteJump }):OnChanged(function(v) State.infiniteJump = v; saveState() end)
SVC.Input.JumpRequest:Connect(function()
    if not State.infiniteJump then return end
    local hum = SVC.LP.Character and SVC.LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
Tabs.Movement:AddToggle("Fly", { Title = "Fly", Default = State.fly }):OnChanged(function(v) State.fly = v; Fly.set(v); saveState() end)
Tabs.Movement:AddInput("FlySpeed", { Title = "Fly Speed", Default = tostring(State.flySpeed), Numeric = true, Finished = false }):OnChanged(function(v) local n = tonumber(v); if n then State.flySpeed = n; saveState() end end)