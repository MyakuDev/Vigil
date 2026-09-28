-- element: keybind

_G.UIKeybind = function(tab, opts)
    if not tab then return end
    return tab:keybind({
        Name = opts.Name or "keybind",
        Default = opts.Default or Enum.UserInputType.None,
        Callback = opts.Callback or function() end,
    })
end
