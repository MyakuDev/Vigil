-- ui feature: infinite jump

Misc:toggle({Name = "Infinite Jump",Description = "hold space to jump infinitely.",Default = false,Callback = function(s)
    InfiniteJump.Enabled = s
    InfiniteJump.State = s and "Enabled" or "Disabled"
end})
