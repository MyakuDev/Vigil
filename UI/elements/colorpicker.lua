-- element: colorpicker

_G.UIColorpicker = function(tab, opts)
    if not tab then return end
    return tab:color_picker({
        Name = opts.Name or "color",
        Style = Library.ColorPickerStyles.Legacy,
        Description = opts.Description or "",
        Callback = opts.Callback or function() end,
    })
end
