-- ui feature: keybinds tab body

local KeybindList = {
    "MenuToggle",
    "Blink","Fly","Aura","SemiShort",
    "AntiAFK","InfiniteJump","AutoHeal","NoFog",
    "Reset","Respawn","Rejoin","ServerHop",
    "NoRagdoll","AntiBearTrap","AntiVoid",
    "CrateESP","C4ESP",
    "VoidCarry","NullCarry","RunAll","StopRunAll",
}

for _, name in ipairs(KeybindList) do
    KeybindsTab:keybind({
        Name = name,
        Default = Keybinds[name] or Enum.UserInputType.None,
        Callback = function(key)
            Keybinds[name] = key.KeyCode or key
            ApplyKeybind(name)
            if _G.KeybindsSave then KeybindsSave() end
            gui:set_status("bind " .. name .. " -> " .. tostring(Keybinds[name]))
        end,
    })
end

KeybindsTab:button({
    Name = "Clear all keybinds",
    Description = "unbinds every feature (keeps Z for menu)",
    Callback = function()
        for name, _ in pairs(Keybinds) do
            if name ~= "MenuToggle" then
                Keybinds[name] = nil
            end
        end
        gui:set_status("cleared all keybinds")
    end,
})

