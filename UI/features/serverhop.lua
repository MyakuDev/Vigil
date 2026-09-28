-- ui feature: server hop

Misc:toggle({Name = "Server Hop",Description = "hops random server on loop.",Default = false,Callback = function(s)
    ServerHop.Enabled = s
    ServerHop.State = s and "Enabled" or "Disabled"
end})
Misc:button({Name = "Hop Once",Description = "hop immediately.",Callback = function()
    if _G.HopOnce then HopOnce() end
<<<<<<< HEAD
end})
=======
end})
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
