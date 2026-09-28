-- element: paragraph

_G.UIParagraph = function(tab, opts)
    if not tab then return end
    return tab:paragraph({
        Title = opts.Title or "",
        Text = opts.Text or "",
    })
<<<<<<< HEAD
end
=======
end
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
