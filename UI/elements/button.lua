-- element: button

_G.UIButton = function(tab, opts)
    if not tab then return end
    return tab:button({
        Name = opts.Name or "button",
        Description = opts.Description or "",
        Callback = opts.Callback or function() end,
    })
<<<<<<< HEAD
end
=======
end
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
