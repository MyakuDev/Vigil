--!nonstrict
local V = _G.Vigil
local Tabs = V.Window.Tabs
local State = V.State.State
local saveState = V.State.save
local SVC = V.Services
local Carry = V.Carry
local Notify = V.Notify
Tabs.PlayerTab:AddToggle("NoRagdoll", { Title = "No-Ragdoll", Default = State.noRagdoll }):OnChanged(function(v) State.noRagdoll = v; saveState() end)
local noRagHeld = false
local btp = Instance.new("Part")
btp.Size = Vector3.new(4, 4, 4)
btp.Anchored = true
btp.CanCollide = false
btp.CanQuery = false
btp.CanTouch = false
btp.Transparency = 1
btp.CFrame = CFrame.new(9e9, 9e9, 9e9)
btp.Parent = SVC.WS
SVC.Run.Heartbeat:Connect(function()
    if not State.noRagdoll then btp.CFrame = CFrame.new(9e9, 9e9, 9e9); noRagHeld = false; return end
    local hrp = SVC.LP.Character and SVC.LP.Character:FindFirstChild("HumanoidRootPart")
    local hum = SVC.LP.Character and SVC.LP.Character:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    local st = hum:GetState()
    if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.FallingDown or hum.PlatformStand then noRagHeld = true end
    if noRagHeld and (hrp.Position - btp.Position).Magnitude >= 20 then
        hrp.CFrame = btp.CFrame + Vector3.new(0, 3, 0)
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        noRagHeld = false
    end
    btp.CFrame = hrp.CFrame + Vector3.new(0, -3, 0)
end)
local carryPara = Tabs.PlayerTab:AddParagraph({ Title = "Carry Values", Content = "loading..." })
task.spawn(function()
    while true do
        task.wait(0.5)
        local v = Carry.getCarryValues()
        if not v then carryPara:SetDesc("no CharacterInformation")
        else
            local can = v.CanCarry and tostring(v.CanCarry.Value) or "nil"
            local car = "nil"
            if v.PlrCarrying and v.PlrCarrying.Value then
                car = v.PlrCarrying.Value:IsA("Player") and tostring(v.PlrCarrying.Value.Name)
                    or v.PlrCarrying.Value:IsA("Model") and tostring(v.PlrCarrying.Value.Name)
                    or tostring(v.PlrCarrying.Value)
            end
            local isc = v.IsCarryingSomeone and tostring(v.IsCarryingSomeone.Value) or "nil"
            carryPara:SetDesc(string.format("cancarry: %s | plrcarrying: %s | iscarrying: %s", can, car, isc))
        end
    end
end)
Tabs.PlayerTab:AddButton({ Title = "Force CanCarry = 1", Callback = function() if Carry.setCarryStat(1) then Notify.vigil("CanCarry = 1", 2) end end })
Tabs.PlayerTab:AddButton({ Title = "Force CanCarry = 0", Callback = function() if Carry.setCarryStat(0) then Notify.vigil("CanCarry = 0", 2) end end })
Tabs.PlayerTab:AddButton({ Title = "Reset", Callback = function() local head = SVC.LP.Character and SVC.LP.Character:FindFirstChild("Head"); if head then head:Destroy() end end })
Tabs.PlayerTab:AddButton({ Title = "Return Carry", Callback = function() Carry.returnCarry() end })
Tabs.PlayerTab:AddButton({ Title = "Rejoin", Callback = function() pcall(function() SVC.TP:TeleportToPlaceInstance(game.PlaceId, game.JobId, SVC.LP) end) end })
Tabs.PlayerTab:AddButton({ Title = "Server Hop", Callback = function()
    local ok, resp = pcall(function() return SVC.Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")) end)
    if not ok or not resp or not resp.data then return end
    for _, s in ipairs(resp.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            pcall(function() SVC.TP:TeleportToPlaceInstance(game.PlaceId, s.id, SVC.LP) end)
            return
        end
    end
end })