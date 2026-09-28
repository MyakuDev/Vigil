-- element: prompt

_G.UIPrompt = function(tab, opts)
    if not tab then return end
    return tab:prompt({
        Title = opts.Title or "prompt",
        Text = opts.Text or "",
        Buttons = opts.Buttons or {},
    })
<<<<<<< HEAD
end
=======
end
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
