-- element: toggle

_G.UIToggle = function(tab, opts)
    if not tab then return end
    return tab:toggle({
        Name = opts.Name or "toggle",
        Description = opts.Description or "",
        Default = opts.Default or false,
        Callback = opts.Callback or function() end,
    })
<<<<<<< HEAD
end
=======
end
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
