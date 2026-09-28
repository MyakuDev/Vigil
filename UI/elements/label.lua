-- element: label

_G.UILabel = function(tab, opts)
    if not tab then return end
    return tab:label({
        Name = opts.Name or "",
        Description = opts.Description or "",
    })
<<<<<<< HEAD
end
=======
end
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
