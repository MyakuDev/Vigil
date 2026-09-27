-- keybinds

local HttpService = game:GetService("HttpService")
local KB_PATH = (_G.Vigil and _G.Vigil.JsonRoot or "C:/Users/kirok/OneDrive/Desktop/Yunrine/Lua/Mortem Metallum/Vigil/json") .. "/keybinds.json"

_G.Keybinds = _G.Keybinds or {
    MenuToggle   = Enum.KeyCode.Z,
    Blink        = Enum.KeyCode.LeftShift,
    Fly          = nil,
    Aura         = nil,
    SemiShort    = nil,
    AntiAFK      = nil,
    InfiniteJump = nil,
    AutoHeal     = nil,
    NoFog        = nil,
    Reset        = nil,
    Respawn      = nil,
    Rejoin       = nil,
    ServerHop    = nil,
    NoRagdoll    = nil,
    AntiBearTrap = nil,
    AntiVoid     = nil,
    CrateESP     = nil,
    C4ESP        = nil,
    VoidCarry    = nil,
    NullCarry    = nil,
    RunAll       = nil,
    StopRunAll   = nil,
}

_G.KeybindActions = _G.KeybindActions or {}
_G.KeybindConns   = _G.KeybindConns   or {}

_G.RegisterKeybind = function(name, action)
    KeybindActions[name] = action
    if Keybinds[name] then ApplyKeybind(name) end
end

_G.ApplyKeybind = function(name)
    local key = Keybinds[name]
    if not key then return end
    local action = KeybindActions[name]
    if not action then return end

    if KeybindConns[name] then
        pcall(function() KeybindConns[name]:Disconnect() end)
    end

    KeybindConns[name] = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == key then action() end
    end)
end

-- menu toggle
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Keybinds.MenuToggle then
        if gui and gui.Toggle then
            gui:Toggle()
        else
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                for _, v in ipairs(pg:GetChildren()) do
                    if v:IsA("ScreenGui") then v.Enabled = not v.Enabled end
                end
            end
        end
    end
end)

-- defaults
RegisterKeybind("Blink", function() if _G.Blink then Blink.Enabled = not Blink.Enabled end end)
RegisterKeybind("Fly", function()
    if _G.Fly then
        Fly.Enabled = not Fly.Enabled
        if Fly.Enabled and _G.startFly then
            startFly()
        elseif _G.stopFly then
            stopFly()
        end
    end
end)
RegisterKeybind("Aura", function() if _G.Aura then Aura.Enabled = not Aura.Enabled end end)
RegisterKeybind("SemiShort", function() if _G.SemiShort then SemiShort.Enabled = not SemiShort.Enabled end end)
RegisterKeybind("AntiAFK", function() if _G.AntiAFK then AntiAFK.Enabled = not AntiAFK.Enabled end end)
RegisterKeybind("InfiniteJump", function() if _G.InfiniteJump then InfiniteJump.Enabled = not InfiniteJump.Enabled end end)
RegisterKeybind("AutoHeal", function() if _G.AutoHeal then AutoHeal.Enabled = not AutoHeal.Enabled end end)
RegisterKeybind("NoFog", function() if _G.NoFog then NoFog.Enabled = not NoFog.Enabled end end)
RegisterKeybind("NoRagdoll", function() if _G.NoRagdoll then NoRagdoll.Enabled = not NoRagdoll.Enabled end end)
RegisterKeybind("AntiBearTrap", function() if _G.AntiBearTrap then AntiBearTrap.Enabled = not AntiBearTrap.Enabled end end)
RegisterKeybind("AntiVoid", function() if _G.AntiVoid then AntiVoid.Enabled = not AntiVoid.Enabled end end)
RegisterKeybind("CrateESP", function() if _G.CrateESP then CrateESP.Enabled = not CrateESP.Enabled end end)
RegisterKeybind("C4ESP", function() if _G.C4ESP then C4ESP.Enabled = not C4ESP.Enabled end end)
RegisterKeybind("VoidCarry", function() if _G.VoidCarry then VoidCarry.Enabled = not VoidCarry.Enabled end end)
RegisterKeybind("NullCarry", function() if _G.NullCarry then NullCarry.Enabled = not NullCarry.Enabled end end)
RegisterKeybind("RunAll", function() if _G.RunAll then RunAll.Enabled = not RunAll.Enabled end end)
RegisterKeybind("StopRunAll", function() if _G.StopRunAll then StopRunAll.Enabled = not StopRunAll.Enabled end end)
RegisterKeybind("Reset", function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
end)
RegisterKeybind("Respawn", function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
    LocalPlayer.CharacterAdded:Wait()
    task.wait(1)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(0, 50, 0) end
end)
RegisterKeybind("Rejoin", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- ============================================================
-- json persistence (v2 format)
-- ============================================================
_G.KeybindsLoad = function()
    local ok, raw = pcall(readfile, KB_PATH)
    if not ok or not raw or raw == "" then return end
    local ok2, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok2 or not decoded then return end

    -- v2 format: { "keybinds": { "Blink": { "Key": "LeftShift", "State": "Enabled" }, ... } }
    local binds = decoded.keybinds or decoded

    for name, entry in pairs(binds) do
        local keyName
        if type(entry) == "table" then
            keyName = entry.Key
        elseif type(entry) == "string" then
            -- v1 fallback
            keyName = entry
        end

        if keyName and keyName ~= "" and Enum.KeyCode[keyName] then
            Keybinds[name] = Enum.KeyCode[keyName]
            ApplyKeybind(name)
        end
    end
end

_G.KeybindsSave = function()
    local out = {
        meta = {
            format = "v2",
            description = "global keybinds. null = unbound"
        },
        keybinds = {}
    }

    for name, key in pairs(Keybinds) do
        if key == nil then
            out.keybinds[name] = {Key = nil, State = "Disabled"}
        elseif typeof(key) == "EnumItem" then
            out.keybinds[name] = {Key = key.Name, State = "Enabled"}
        end
    end

    local ok, encoded = pcall(function() return HttpService:JSONEncode(out) end)
    if ok then pcall(writefile, KB_PATH, encoded) end
end

KeybindsLoad()
