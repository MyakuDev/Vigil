-- util init

local root = (_G.Vigil and _G.Vigil.Root or "C:/Users/kirok/OneDrive/Desktop/Yunrine/Lua/Mortem Metallum/Vigil") .. "/UI/util"

for _, name in ipairs({"notify.lua","settings.lua","theme.lua","format.lua"}) do
    local ok, src = pcall(readfile, root .. "/" .. name)
    if ok and src then
        local fn = loadstring(src)
        if fn then pcall(fn) end
    end
<<<<<<< HEAD
end
=======
end
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
