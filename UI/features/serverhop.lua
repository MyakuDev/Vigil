-- ui feature: server hop

Misc:toggle({Name = "Server Hop",Description = "hops random server on loop.",Default = false,Callback = function(s)
    ServerHop.Enabled = s
    ServerHop.State = s and "Enabled" or "Disabled"
end})
Misc:button({Name = "Hop Once",Description = "hop immediately.",Callback = function()
    if _G.HopOnce then HopOnce() end
end})
