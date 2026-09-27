--!nonstrict
local V = _G.Vigil
local Tabs = V.Window.Tabs
local State = V.State.State
local saveState = V.State.save
local SVC = V.Services
Tabs.Visuals:AddInput("FOV", { Title = "Field of View", Default = tostring(State.fov), Numeric = true, Finished = false }):OnChanged(function(v) local n = tonumber(v); if n then State.fov = n; saveState() end end)
SVC.Run.RenderStepped:Connect(function()
    if SVC.WS.CurrentCamera then SVC.WS.CurrentCamera.FieldOfView = State.fov end
end)
Tabs.Visuals:AddToggle("Fullbright", { Title = "Fullbright", Default = State.fullbright }):OnChanged(function(v) State.fullbright = v; saveState() end)
SVC.Run.Heartbeat:Connect(function()
    if State.fullbright then
        SVC.Light.Ambient = Color3.fromRGB(178, 178, 178)
        SVC.Light.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
        SVC.Light.Brightness = 3
        SVC.Light.ClockTime = 14
        SVC.Light.FogEnd = 1e6
        SVC.Light.GlobalShadows = false
    end
end)