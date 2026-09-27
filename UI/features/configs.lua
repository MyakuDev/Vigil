-- ui feature: configs

local ConfigsTab = _G.ConfigsTab

ConfigsTab:textbox({Name = "Save Config",Default = "",Callback = function(v)
    if not v or v == "" then NotifyError("enter a name") return end
    local ok, err = ConfigSave(v, false)
    if not ok then NotifyInfo(err or "save failed") end
end})
ConfigsTab:textbox({Name = "Overwrite Config",Default = "",Callback = function(v)
    if not v or v == "" then NotifyError("enter a name") return end
    ConfigSave(v, true)
end})
ConfigsTab:textbox({Name = "Load Config",Default = "",Callback = function(v)
    if not v or v == "" then NotifyError("enter a name") return end
    local ok, err = ConfigLoad(v)
    if not ok then NotifyError(err or "load failed") end
end})
ConfigsTab:textbox({Name = "Delete Config",Default = "",Callback = function(v)
    if not v or v == "" then NotifyError("enter a name") return end
    ConfigDelete(v)
end})
ConfigsTab:button({Name = "List Configs",Callback = function()
    local list = ConfigList()
    if #list == 0 then NotifyInfo("no configs") else Notify("Configs", table.concat(list, ", "), 8) end
end})
ConfigsTab:button({Name = "Save Default",Callback = function() ConfigSave("default", true) end})
ConfigsTab:button({Name = "Load Default",Callback = function() ConfigLoad("default") end})

ConfigsTab:dropdown({Name = "Presets",StartingText = "select...",Items = ConfigListPresets(),Callback = function(v)
    if v then ConfigLoadPreset(v) end
end})
ConfigsTab:textbox({Name = "Save as Preset",Default = "",Callback = function(v)
    if v and v ~= "" then ConfigSaveAsPreset(v) end
end})

ConfigsTab:textbox({Name = "Auto Load Config",Default = ConfigSystem.AutoLoad or "",Callback = function(v)
    ConfigSystem.AutoLoad = v
    SaveSettings()
    NotifySuccess("autoload set: " .. v)
end})
