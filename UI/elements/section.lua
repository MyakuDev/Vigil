-- element: section

_G.UISection = function(tab, opts)
    if not tab then return end
    return tab:section({
        Name = opts.Name or "section",
    })
end
