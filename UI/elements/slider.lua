-- element: slider

_G.UISlider = function(tab, opts)
    if not tab then return end
    return tab:slider({
        Name = opts.Name or "slider",
        Description = opts.Description or "",
        Min = opts.Min or 0,
        Max = opts.Max or 100,
        Default = opts.Default or 50,
        Callback = opts.Callback or function() end,
    })
<<<<<<< HEAD
end
=======
end
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
