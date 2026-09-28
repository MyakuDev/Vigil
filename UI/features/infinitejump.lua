-- ui feature: infinite jump

Misc:toggle({Name = "Infinite Jump",Description = "hold space to jump infinitely.",Default = false,Callback = function(s)
    InfiniteJump.Enabled = s
    InfiniteJump.State = s and "Enabled" or "Disabled"
<<<<<<< HEAD
end})
=======
end})
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
