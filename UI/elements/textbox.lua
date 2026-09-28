-- element: textbox

_G.UITextbox = function(tab, opts)
    if not tab then return end
    return tab:textbox({
        Name = opts.Name or "textbox",
        Description = opts.Description or "",
        Default = opts.Default or "",
        Callback = opts.Callback or function() end,
    })
<<<<<<< HEAD
end
=======
end
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
