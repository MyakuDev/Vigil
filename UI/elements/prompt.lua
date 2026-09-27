-- element: prompt

_G.UIPrompt = function(tab, opts)
    if not tab then return end
    return tab:prompt({
        Title = opts.Title or "prompt",
        Text = opts.Text or "",
        Buttons = opts.Buttons or {},
    })
end
