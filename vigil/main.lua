--!nonstrict
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.Character
repeat task.wait() until game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
repeat task.wait() until workspace.CurrentCamera
task.wait(1)

local ROOT = "Vigil"
local function loadModule(relPath)
    local full = ROOT .. "/" .. relPath
    if not isfile(full) then warn("[Vigil] missing module: " .. full); return nil end
    local src = readfile(full)
    local fn, err = loadstring(src, "@" .. full)
    if not fn then warn("[Vigil] failed to compile " .. full .. ": " .. tostring(err)); return nil end
    local ok, result = pcall(fn)
    if not ok then warn("[Vigil] error loading " .. full .. ": " .. tostring(result)); return nil end
    return result
end

local Updater = loadModule("lib/updater.lua")
if Updater then
    local ok, msg = pcall(Updater.run)
    if ok and msg then print("[Vigil] updater: " .. tostring(msg)) end
end

_G.Vigil = _G.Vigil or {}
local V = _G.Vigil

V.Services  = loadModule("lib/services.lua")
V.Storage   = loadModule("lib/storage.lua")
V.Window    = loadModule("ui/window.lua")
V.Notify    = loadModule("lib/notify.lua")
V.State     = loadModule("lib/state.lua")
V.Lists     = loadModule("lib/lists.lua")
V.API       = loadModule("lib/api.lua")
V.Remotes   = loadModule("lib/remotes.lua")
V.Platforms = loadModule("lib/platforms.lua")
V.Carry     = loadModule("lib/carry.lua")
V.Dummy     = loadModule("lib/dummy.lua")
V.Fly       = loadModule("lib/fly.lua")
V.Commands  = loadModule("lib/commands.lua")
V.Keybinds  = loadModule("lib/keybinds.lua")

loadModule("ui/combat.lua")
loadModule("ui/movement.lua")
loadModule("ui/visuals.lua")
loadModule("ui/player.lua")
loadModule("ui/misc.lua")
loadModule("ui/players.lua")
loadModule("ui/abuse.lua")
loadModule("ui/commands.lua")
loadModule("ui/keybinds.lua")
loadModule("ui/performance.lua")
loadModule("ui/notifications.lua")

V.Services.Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if V.Fly and V.Fly.reapply then pcall(V.Fly.reapply) end
    if V.Platforms and V.Platforms.reapply then pcall(V.Platforms.reapply) end
    if V.Keybinds and V.Keybinds.rebuild then pcall(V.Keybinds.rebuild) end
    if V.Remotes and V.Remotes.refresh then pcall(V.Remotes.refresh) end
end)

local Fluent = V.Window.Fluent
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("Vigil")
SaveManager:SetFolder("Vigil/game")
InterfaceManager:BuildInterfaceSection(V.Window.Tabs.Settings)
SaveManager:BuildConfigSection(V.Window.Tabs.Settings)
V.Window.Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()

V.Notify.vigil("loaded successfully.", 3)