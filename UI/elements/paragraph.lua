-- element: paragraph

_G.UIParagraph = function(tab, opts)
    if not tab then return end
    return tab:paragraph({
        Title = opts.Title or "",
        Text = opts.Text or "",
    })
end
