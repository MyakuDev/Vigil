-- element: label

_G.UILabel = function(tab, opts)
    if not tab then return end
    return tab:label({
        Name = opts.Name or "",
        Description = opts.Description or "",
    })
end
