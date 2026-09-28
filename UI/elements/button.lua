-- element: button

_G.UIButton = function(tab, opts)
    if not tab then return end
    return tab:button({
        Name = opts.Name or "button",
        Description = opts.Description or "",
        Callback = opts.Callback or function() end,
    })
end
