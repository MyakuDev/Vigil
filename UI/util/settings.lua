-- util: ui settings

_G.UISettings = _G.UISettings or {
    Theme = "Serika",
    AutoSave = true,
    ShowTooltips = true,
    Animations = true,
    AnimationSpeed = 0.2,
}

_G.UISetSetting = function(key, value)
    UISettings[key] = value
    if _G.UINotify then UINotify(key .. " = " .. tostring(value)) end
end
