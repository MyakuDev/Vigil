-- loader

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
local gui = Library:create{Theme = Library.Themes.Serika}

_G.Library = Library
_G.gui = gui

local function loadFile(path)
    local ok, src = pcall(readfile, path)
    if not ok or not src then warn("[Vigil] missing: " .. path) return end
    local fn = loadstring(src)
    if fn then
        local ok2, err = pcall(fn)
        if not ok2 then warn("[Vigil] " .. path .. " -> " .. tostring(err)) end
    end
end

local root = "C:/Users/kirok/OneDrive/Desktop/Yunrine/Lua/Mortem Metallum/Vigil"

loadFile(root .. "/globals.lua")
loadFile(root .. "/services.lua")
loadFile(root .. "/notifications.lua")
loadFile(root .. "/tabs.lua")
loadFile(root .. "/parser.lua")
loadFile(root .. "/lists.lua")
loadFile(root .. "/admins.lua")
loadFile(root .. "/configs.lua")
loadFile(root .. "/keybinds.lua")

loadFile(root .. "/Main/Blink.lua")

loadFile(root .. "/Misc/AntiAFK.lua")
loadFile(root .. "/Misc/InfiniteJump.lua")
loadFile(root .. "/Misc/AutoHeal.lua")
loadFile(root .. "/Misc/NoFog.lua")
loadFile(root .. "/Misc/Rejoin.lua")
loadFile(root .. "/Misc/ServerHop.lua")
loadFile(root .. "/Misc/Reset.lua")
loadFile(root .. "/Misc/Respawn.lua")
loadFile(root .. "/Misc/CrateC4ESP.lua")

loadFile(root .. "/Abuse/Aura.lua")
loadFile(root .. "/Abuse/SemiShort.lua")

loadFile(root .. "/Movement/Fly.lua")

loadFile(root .. "/Anti's/NoRagdoll.lua")
loadFile(root .. "/Anti's/AntiBearTrap.lua")
loadFile(root .. "/Anti's/AntiVoid.lua")

loadFile(root .. "/Troll/TargetList.lua")
loadFile(root .. "/Troll/VoidCarry.lua")
loadFile(root .. "/Troll/NullCarry.lua")
loadFile(root .. "/Troll/RunAll.lua")
loadFile(root .. "/Troll/StopRunAll.lua")

loadFile(root .. "/UI/init.lua")
<<<<<<< HEAD
loadFile(root .. "/Commands.lua")
=======
loadFile(root .. "/Commands.lua")
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
