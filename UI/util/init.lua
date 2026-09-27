-- util init

local root = (_G.Vigil and _G.Vigil.Root or "C:/Users/kirok/OneDrive/Desktop/Yunrine/Lua/Mortem Metallum/Vigil") .. "/UI/util"

for _, name in ipairs({"notify.lua","settings.lua","theme.lua","format.lua"}) do
    local ok, src = pcall(readfile, root .. "/" .. name)
    if ok and src then
        local fn = loadstring(src)
        if fn then pcall(fn) end
    end
end
