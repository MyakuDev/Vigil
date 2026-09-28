-- elements init

local root = (_G.Vigil and _G.Vigil.Root or "C:/Users/kirok/OneDrive/Desktop/Yunrine/Lua/Mortem Metallum/Vigil") .. "/UI/elements"

for _, name in ipairs({
    "button.lua","toggle.lua","textbox.lua","slider.lua",
    "dropdown.lua","keybind.lua","colorpicker.lua","prompt.lua",
    "label.lua","section.lua","paragraph.lua",
}) do
    local ok, src = pcall(readfile, root .. "/" .. name)
    if ok and src then
        local fn = loadstring(src)
        if fn then pcall(fn) end
    end
end
