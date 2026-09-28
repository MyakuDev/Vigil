-- element: keybind

_G.UIKeybind = function(tab, opts)
    if not tab then return end
    return tab:keybind({
        Name = opts.Name or "keybind",
        Default = opts.Default or Enum.UserInputType.None,
        Callback = opts.Callback or function() end,
    })
<<<<<<< HEAD
end
=======
end
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
