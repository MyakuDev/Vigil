--!nonstrict
local SVC = _G.Vigil.Services
local State = _G.Vigil.State.State
local M = {}
local bv, conn
function M.set(on)
    if conn then conn:Disconnect(); conn = nil end
    if bv then bv:Destroy(); bv = nil end
    if not on then return end
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    conn = SVC.Run.Heartbeat:Connect(function()
        local hrp = SVC.LP.Character and SVC.LP.Character:FindFirstChild("HumanoidRootPart")
        local cam = SVC.WS.CurrentCamera
        if not hrp or not cam then return end
        if not SVC.Tag:HasTag(bv, "AllowedBM") then SVC.Tag:AddTag(bv, "AllowedBM") end
        bv.Parent = hrp
        local dir = Vector3.zero
        if SVC.Input:IsKeyDown(Enum.KeyCode.W) then dir += Vector3.new(0, 0, -1) end
        if SVC.Input:IsKeyDown(Enum.KeyCode.S) then dir += Vector3.new(0, 0, 1) end
        if SVC.Input:IsKeyDown(Enum.KeyCode.A) then dir += Vector3.new(-1, 0, 0) end
        if SVC.Input:IsKeyDown(Enum.KeyCode.D) then dir += Vector3.new(1, 0, 0) end
        if dir.Magnitude > 0 then dir = dir.Unit end
        local vert = Vector3.zero
        if SVC.Input:IsKeyDown(Enum.KeyCode.Space) then vert = Vector3.new(0, 1, 0) end
        if SVC.Input:IsKeyDown(Enum.KeyCode.LeftControl) then vert = Vector3.new(0, -1, 0) end
        bv.Velocity = cam.CFrame:VectorToWorldSpace(dir) * State.flySpeed + vert * State.flySpeed
    end)
end
function M.reapply()
    if State.fly then pcall(M.set, true) end
end
return M