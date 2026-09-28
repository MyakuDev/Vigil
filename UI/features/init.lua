-- features init

local root = (_G.Vigil and _G.Vigil.Root or "C:/Users/kirok/OneDrive/Desktop/Yunrine/Lua/Mortem Metallum/Vigil") .. "/UI/features"

for _, name in ipairs({
    "blink.lua","fly.lua","aura.lua","semishort.lua",
    "antiafk.lua","infinitejump.lua","autoheal.lua","nofog.lua",
    "rejoin.lua","serverhop.lua","reset.lua","respawn.lua","cratec4esp.lua",
    "noragdoll.lua","antibeartrap.lua","antivoid.lua",
    "targetlist.lua","voidcarry.lua","nullcarry.lua","runall.lua","stoprunall.lua",
    "lists.lua","configs.lua","parser.lua","debug.lua","keybinds.lua","commands.lua",
}) do
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
