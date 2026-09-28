-- no fog

_G.NoFog = {Enabled = false,OldFogEnd = nil,OldFogStart = nil,OldFogColor = nil}

Misc:toggle({Name = "No Fog",Description = "removes lighting fog.",Default = false,Callback = function(state)
    NoFog.Enabled = state
    local Lighting = game:GetService("Lighting")
    if state then
        NoFog.OldFogEnd = Lighting.FogEnd
        NoFog.OldFogStart = Lighting.FogStart
        NoFog.OldFogColor = Lighting.FogColor
        Lighting.FogEnd = math.huge
        Lighting.FogStart = math.huge
        Lighting.FogColor = Color3.new(0, 0, 0)
    else
        Lighting.FogEnd = NoFog.OldFogEnd or 100000
        Lighting.FogStart = NoFog.OldFogStart or 0
        Lighting.FogColor = NoFog.OldFogColor or Color3.new(0.5, 0.5, 0.5)
    end
<<<<<<< HEAD
end})
=======
end})
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
