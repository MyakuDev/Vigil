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
<<<<<<< HEAD
end
=======
end
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
