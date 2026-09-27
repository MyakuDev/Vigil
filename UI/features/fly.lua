-- ui feature: fly

Movement:toggle({Name = "Fly",Description = "space = up, left ctrl = down.",Default = false,Callback = function(s)
    Fly.Enabled = s
    Fly.State = s and "Enabled" or "Disabled"
    if s and _G.StartFly then StartFly() end
    if not s and _G.StopFly then StopFly() end
end})
Movement:textbox({Name = "Fly Speed",Default = "50",Callback = function(v) Fly.Speed = tonumber(v) or Fly.Speed end})
