--!nonstrict
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.Character
repeat task.wait() until game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
repeat task.wait() until workspace.CurrentCamera
task.wait(1)

local ROOT = "Vigil"
local USER, REPO, BRANCH = "MyakuDev", "Vigil", "main"
local SUBDIR = "vigil"
local Http = game:GetService("HttpService")

local base = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", USER, REPO, BRANCH, SUBDIR)

if isfolder then
    if not isfolder(ROOT) then makefolder(ROOT) end
    if not isfolder(ROOT .. "/lib") then makefolder(ROOT .. "/lib") end
    if not isfolder(ROOT .. "/ui") then makefolder(ROOT .. "/ui") end
end

-- bootstrap: download any missing or empty files
local ok, raw = pcall(function() return game:HttpGet(base .. "/manifest.json", true) end)
if ok and raw and raw ~= "" then
    local ok2, manifest = pcall(function() return Http:JSONDecode(raw) end)
    if ok2 and type(manifest) == "table" and manifest.files then
        local downloaded, skipped = 0, 0
        for path, _ in pairs(manifest.files) do
            local full = ROOT .. "/" .. path
            local needsDownload = true
            if isfile and isfile(full) then
                local ok3, existing = pcall(readfile, full)
                if ok3 and existing and #existing > 0 then
                    needsDownload = false
                end
            end
            if needsDownload then
                local ok4, content = pcall(function() return game:HttpGet(base .. "/" .. path, true) end)
                if ok4 and content and content ~= "" then
                    pcall(writefile, full, content)
                    downloaded = downloaded + 1
                end
                task.wait(0.03)
            else
                skipped = skipped + 1
            end
        end
        if downloaded > 0 then
            print(string.format("[Vigil] bootstrap: downloaded %d, kept %d", downloaded, skipped))
        end
    end
end

-- update the local manifest
if ok and raw then
    pcall(writefile, ROOT .. "/manifest.json", raw)
end

local function loadModule(relPath)
    local full = ROOT .. "/" .. relPath
    if not isfile(full) then warn("[Vigil] missing module: " .. full); return nil end
    local src = readfile(full)
    local fn, err = loadstring(src, "@" .. full)
    if not fn then warn("[Vigil] failed to compile " .. full .. ": " .. tostring(err)); return nil end
    local ok2, result = pcall(fn)
    if not ok2 then warn("[Vigil] error loading " .. full .. ": " .. tostring(result)); return nil end
    return result
end

local Updater = loadModule("lib/updater.lua")
if Updater then
    local ok2, msg = pcall(Updater.run)
    if ok2 and msg then print("[Vigil] updater: " .. tostring(msg)) end
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
-- Connection Test module
pcall(function()
    local ctSrc = readfile("Vigil/ui/connection_test/init.lua")
    if ctSrc then
        local CT = loadstring(ctSrc, "@Vigil/ui/connection_test/init.lua")()
        if CT and CT.start then CT.start() end
    end
end)

loadModule("ui/diagnostics.lua")
