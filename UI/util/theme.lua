-- util: theme switcher

_G.UIApplyTheme = function(name)
    if _G.VigilThemes and VigilThemes[name] then
        _G.ActiveTheme = name
        if _G.NotifySuccess then NotifySuccess("theme: " .. name) end
        return true
    end
    return false
end

_G.UIListThemes = function()
    local out = {}
    if _G.VigilThemes then
        for name, _ in pairs(VigilThemes) do table.insert(out, name) end
    end
    table.sort(out)
    return out
<<<<<<< HEAD
end
=======
end
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
