-- ui entry

_G.Tabs = _G.Tabs or {}

local function loadUI(relPath)
    local root = (_G.Vigil and _G.Vigil.Root or "C:/Users/kirok/OneDrive/Desktop/Yunrine/Lua/Mortem Metallum/Vigil")
    local path = root .. "/" .. relPath
    local ok, src = pcall(readfile, path)
    if not ok or not src then warn("[Vigil/UI] missing: " .. path) return end
    local fn = loadstring(src)
    if fn then
        local ok2, err = pcall(fn)
        if not ok2 then warn("[Vigil/UI] " .. path .. " -> " .. tostring(err)) end
    end
end

-- themes
loadUI("UI/themes/init.lua")
loadUI("UI/themes/serika.lua")
loadUI("UI/themes/dark.lua")
loadUI("UI/themes/light.lua")
loadUI("UI/themes/blood.lua")
loadUI("UI/themes/ocean.lua")

-- util
loadUI("UI/util/init.lua")
loadUI("UI/util/notify.lua")
loadUI("UI/util/settings.lua")
loadUI("UI/util/theme.lua")
loadUI("UI/util/format.lua")

-- elements
loadUI("UI/elements/init.lua")

-- tabs
loadUI("UI/tabs/init.lua")

-- features
<<<<<<< HEAD
loadUI("UI/features/init.lua")
=======
loadUI("UI/features/init.lua")
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
