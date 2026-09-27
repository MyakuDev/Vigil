--!nonstrict
local V = _G.Vigil
local Tabs = V.Window.Tabs
local State = V.State.State
local saveState = V.State.save
local SVC = V.Services
local Platforms = V.Platforms
Tabs.Misc:AddToggle("BTW", { Title = "Bear Trap Walkover", Default = State.btw }):OnChanged(function(v) State.btw = v; saveState() end)
Tabs.Misc:AddToggle("AntiAFK", { Title = "Anti-AFK", Default = State.antiAFK }):OnChanged(function(v) State.antiAFK = v; saveState() end)
task.spawn(function()
    while true do
        task.wait(60)
        if State.antiAFK then pcall(function() SVC.VUser:CaptureController(); SVC.VUser:ClickButton2(Vector2.new()) end) end
    end
end)
Tabs.Misc:AddToggle("SafePlats", { Title = "Safe Platforms", Default = State.useSafePlatforms }):OnChanged(function(v)
    State.useSafePlatforms = v
    if not v then Platforms.clear() else Platforms.get("void"); Platforms.get("nullzone") end
    saveState()
end)
Tabs.Misc:AddToggle("AntiFling", { Title = "Anti-Fling", Default = State.antiFling }):OnChanged(function(v) State.antiFling = v; saveState() end)
Tabs.Misc:AddToggle("AutoHeal", { Title = "Auto Heal (Bandage)", Default = State.autoHeal }):OnChanged(function(v) State.autoHeal = v; saveState() end)
Tabs.Misc:AddInput("AutoHealThreshold", { Title = "Auto Heal HP Threshold", Default = tostring(State.autoHealThreshold), Numeric = true, Finished = false }):OnChanged(function(v) local n = tonumber(v); if n then State.autoHealThreshold = n; saveState() end end)
local healCooldown = false
SVC.Run.Heartbeat:Connect(function()
    if not State.autoHeal or healCooldown then return end
    local char = SVC.LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if hum.Health <= 0 then return end
    if hum.Health > (tonumber(State.autoHealThreshold) or 20) then return end
    local backpack = SVC.LP:FindFirstChildOfClass("Backpack")
    if not backpack then return end
    local bandage = char:FindFirstChild("Bandage") or backpack:FindFirstChild("Bandage")
    if not bandage then return end
    healCooldown = true
    task.spawn(function()
        pcall(function()
            if bandage.Parent ~= char then
                local hum2 = char:FindFirstChildOfClass("Humanoid")
                if hum2 then hum2:EquipTool(bandage) end
            end
            task.wait(0.15)
            SVC.VUser:CaptureController()
            SVC.VUser:ClickButton1(Vector2.new(0, 0))
        end)
        task.wait(2)
        healCooldown = false
    end)
end)
SVC.Run.Stepped:Connect(function()
    if not State.antiFling then return end
    local char = SVC.LP.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = false end
    end
end)