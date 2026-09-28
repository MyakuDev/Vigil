-- ui feature: no fog

Misc:toggle({Name = "No Fog",Description = "removes lighting fog.",Default = false,Callback = function(s)
    NoFog.Enabled = s
    NoFog.State = s and "Enabled" or "Disabled"
    if _G.ApplyNoFog then ApplyNoFog(s) end
<<<<<<< HEAD
end})
=======
end})
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
