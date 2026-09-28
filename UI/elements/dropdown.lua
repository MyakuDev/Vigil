-- element: dropdown

_G.UIDropdown = function(tab, opts)
    if not tab then return end
    return tab:dropdown({
        Name = opts.Name or "dropdown",
        Description = opts.Description or "",
        StartingText = opts.StartingText or "select...",
        Items = opts.Items or {},
        Callback = opts.Callback or function() end,
    })
end
