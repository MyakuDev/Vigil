--!nonstrict
local V = _G.Vigil
local Tabs = V.Window.Tabs
local State = V.State.State
local saveState = V.State.save
local SVC = V.Services
Tabs.Performance:AddToggle("PerfMode", { Title = "Performance Mode", Default = State.performanceMode }):OnChanged(function(v)
    State.performanceMode = v
    if v then
        State.disableParticles = true; State.disableTrails = true; State.disableBeams = true
        State.disableDecals = true; State.disableTextures = true; State.disableFog = true
        State.reduceLighting = true
    end
    saveState()
end)
Tabs.Performance:AddToggle("DisParticles", { Title = "Disable Particles", Default = State.disableParticles }):OnChanged(function(v) State.disableParticles = v; saveState() end)
Tabs.Performance:AddToggle("DisTrails", { Title = "Disable Trails", Default = State.disableTrails }):OnChanged(function(v) State.disableTrails = v; saveState() end)
Tabs.Performance:AddToggle("DisBeams", { Title = "Disable Beams", Default = State.disableBeams }):OnChanged(function(v) State.disableBeams = v; saveState() end)
Tabs.Performance:AddToggle("DisDecals", { Title = "Disable Decals", Default = State.disableDecals }):OnChanged(function(v) State.disableDecals = v; saveState() end)
Tabs.Performance:AddToggle("DisTextures", { Title = "Disable Textures", Default = State.disableTextures }):OnChanged(function(v) State.disableTextures = v; saveState() end)
Tabs.Performance:AddToggle("DisFog", { Title = "Disable Fog", Default = State.disableFog }):OnChanged(function(v) State.disableFog = v; saveState() end)
local function applyPerfTo(v)
    if State.disableParticles and v:IsA("ParticleEmitter") then v.Enabled = false end
    if State.disableTrails and v:IsA("Trail") then v.Enabled = false end
    if State.disableBeams and v:IsA("Beam") then v.Enabled = false end
    if State.disableDecals and v:IsA("Decal") then v.Transparency = 1 end
    if State.disableTextures and v:IsA("Texture") then v.Transparency = 1 end
end
local perfConn = nil
local function restartPerf()
    if perfConn then perfConn:Disconnect(); perfConn = nil end
    local anyOn = State.disableParticles or State.disableTrails or State.disableBeams or State.disableDecals or State.disableTextures
    if not anyOn then return end
    task.spawn(function()
        local count = 0
        for _, v in ipairs(SVC.WS:GetDescendants()) do
            pcall(applyPerfTo, v)
            count = count + 1
            if count % 200 == 0 then task.wait() end
        end
    end)
    perfConn = SVC.WS.DescendantAdded:Connect(function(v) pcall(applyPerfTo, v) end)
end
Tabs.Performance:AddButton({ Title = "Apply Performance Culling", Callback = restartPerf })
SVC.Run.Heartbeat:Connect(function()
    if State.disableFog then SVC.Light.FogEnd = 1e6; SVC.Light.FogStart = 1e6 end
    if State.reduceLighting then
        SVC.Light.EnvironmentDiffuseScale = 0
        SVC.Light.EnvironmentSpecularScale = 0
        SVC.Light.GlobalShadows = false
        SVC.Light.Brightness = 1
    end
end)