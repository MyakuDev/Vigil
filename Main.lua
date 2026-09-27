local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
local gui = Library:create{Theme = Library.Themes.Serika}
_G.Library = Library
_G.gui = gui
_G.Tabs = _G.Tabs or {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

_G.Players = Players
_G.RunService = RunService
_G.UserInputService = UserInputService
_G.ReplicatedStorage = ReplicatedStorage
_G.TeleportService = TeleportService
_G.HttpService = HttpService
_G.VirtualUser = VirtualUser
_G.LocalPlayer = LocalPlayer

_G.Vigil = {Root = ".../", JsonRoot = ".../json", ConfigsDir = ".../configs", Settings = {}}

_G.Notify = function(title, text, duration)
    if gui and gui.Notification then
        local ok = pcall(function() gui:Notification{Title = title or "Vigil", Text = text or "", Duration = duration or 3} end)
        if ok then return end
    end
    if gui and gui.set_status then gui:set_status("[" .. tostring(title) .. "] " .. tostring(text)) end
end
_G.NotifySuccess = function(t) Notify("Success", t, 2) end
_G.NotifyError = function(t) Notify("Error", t, 3) end
_G.NotifyInfo = function(t) Notify("Info", t, 2) end

_G.Main = gui:tab{Icon = "rbxassetid://6034996695", Name = "Main"}
_G.Misc = gui:tab{Icon = "rbxassetid://6031075931", Name = "Misc"}
_G.Abuse = gui:tab{Icon = "rbxassetid://6031091004", Name = "Abuse"}
_G.Movement = gui:tab{Icon = "rbxassetid://6031094667", Name = "Movement"}
_G.Antis = gui:tab{Icon = "rbxassetid://6031280882", Name = "Anti's"}
_G.Troll = gui:tab{Icon = "rbxassetid://6031224157", Name = "Troll"}
_G.Commands = gui:tab{Icon = "rbxassetid://6031224157", Name = "Commands"}
_G.Lists = gui:tab{Icon = "rbxassetid://6031224157", Name = "Lists"}
_G.Configs = gui:tab{Icon = "rbxassetid://6031224157", Name = "Configs"}
_G.Debug = gui:tab{Icon = "rbxassetid://6031224157", Name = "Debug"}
_G.KeybindsTab = gui:tab{Icon = "rbxassetid://6031224157", Name = "Keybinds"}

Tabs.Main = Main
Tabs.Misc = Misc
Tabs.Abuse = Abuse
Tabs.Movement = Movement
Tabs.Antis = Antis
Tabs.Troll = Troll
Tabs.Commands = Commands
Tabs.Lists = Lists
Tabs.Configs = Configs
Tabs.Debug = Debug
Tabs.Keybinds = KeybindsTab

local readJson = function(path)
    local ok, raw = pcall(readfile, path)
    if not ok or not raw or raw == "" then return nil end
    local ok2, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok2 then return nil end
    return decoded
end
local writeJson = function(path, tbl)
    local ok, encoded = pcall(function() return HttpService:JSONEncode(tbl) end)
    if not ok then return false end
    pcall(writefile, path, encoded)
    return true
end
local fileExists = function(path) local ok = pcall(readfile, path) return ok end

local PR_PATH = Vigil.JsonRoot .. "/parser.json"
_G.ParserData = {users = {}, lastUpdated = 0}
_G.ParserCache = {}
_G.ParserSave = function() ParserData.lastUpdated = os.time() writeJson(PR_PATH, ParserData) end
_G.ParserLoad = function()
    local d = readJson(PR_PATH)
    if d and d.users then ParserData = d end
    ParserCache = {}
    for _, e in ipairs(ParserData.users) do if e.userId then ParserCache[e.userId] = e end end
end
_G.ParserAdd = function(userId, name, displayName, source)
    if not userId then return end
    local e = ParserCache[userId]
    if e then
        e.lastSeen = os.time()
        if name then e.name = name end
        if displayName then e.displayName = displayName end
        if source then e.source = source end
    else
        e = {userId = userId, name = name or "unknown", displayName = displayName or name or "unknown", firstSeen = os.time(), lastSeen = os.time(), source = source or "unknown"}
        table.insert(ParserData.users, e)
        ParserCache[userId] = e
    end
    ParserSave()
end
_G.ParserGet = function(userId) return ParserCache[userId] end
_G.ParserRemove = function(userId)
    for i, e in ipairs(ParserData.users) do
        if e.userId == userId then
            table.remove(ParserData.users, i)
            ParserCache[userId] = nil
            ParserSave()
            return true
        end
    end
    return false
end
ParserLoad()
Players.PlayerAdded:Connect(function(p) ParserAdd(p.UserId, p.Name, p.DisplayName, "seen") end)

local WL_PATH = Vigil.JsonRoot .. "/whitelist.json"
local BL_PATH = Vigil.JsonRoot .. "/blacklist.json"
local GR_PATH = Vigil.JsonRoot .. "/groups.json"
_G.ListData = {Root = Vigil.JsonRoot, Whitelist = {users = {}}, Blacklist = {users = {}}, Groups = {groups = {}}}
_G.SaveLists = function()
    writeJson(WL_PATH, ListData.Whitelist)
    writeJson(BL_PATH, ListData.Blacklist)
    writeJson(GR_PATH, ListData.Groups)
end
_G.LoadLists = function()
    local wl = readJson(WL_PATH)
    local bl = readJson(BL_PATH)
    local gr = readJson(GR_PATH)
    ListData.Whitelist = (wl and wl.users) and wl or {users = {}}
    ListData.Blacklist = (bl and bl.users) and bl or {users = {}}
    ListData.Groups = (gr and gr.groups) and gr or {groups = {}}
    for _, u in ipairs(ListData.Whitelist.users) do ParserAdd(u.userId, u.name, u.displayName, "whitelist") end
    for _, u in ipairs(ListData.Blacklist.users) do ParserAdd(u.userId, u.name, u.displayName, "blacklist") end
end
_G.AddToWhitelist = function(userId, name, displayName)
    if not userId then return false end
    for _, e in ipairs(ListData.Whitelist.users) do if e.userId == userId then return false end end
    local entry = {userId = userId, name = name or "unknown", displayName = displayName or name or "unknown"}
    table.insert(ListData.Whitelist.users, entry)
    writeJson(WL_PATH, ListData.Whitelist)
    ParserAdd(userId, entry.name, entry.displayName, "whitelist")
    return true
end
_G.AddToBlacklist = function(userId, name, displayName)
    if not userId then return false end
    for _, e in ipairs(ListData.Blacklist.users) do if e.userId == userId then return false end end
    local entry = {userId = userId, name = name or "unknown", displayName = displayName or name or "unknown"}
    table.insert(ListData.Blacklist.users, entry)
    writeJson(BL_PATH, ListData.Blacklist)
    ParserAdd(userId, entry.name, entry.displayName, "blacklist")
    return true
end
_G.RemoveFromWhitelist = function(userId)
    for i, e in ipairs(ListData.Whitelist.users) do
        if e.userId == userId then
            table.remove(ListData.Whitelist.users, i)
            writeJson(WL_PATH, ListData.Whitelist)
            return true
        end
    end
    return false
end
_G.RemoveFromBlacklist = function(userId)
    for i, e in ipairs(ListData.Blacklist.users) do
        if e.userId == userId then
            table.remove(ListData.Blacklist.users, i)
            writeJson(BL_PATH, ListData.Blacklist)
            return true
        end
    end
    return false
end
_G.IsWhitelisted = function(userId) for _, e in ipairs(ListData.Whitelist.users) do if e.userId == userId then return true end end return false end
_G.IsBlacklisted = function(userId) for _, e in ipairs(ListData.Blacklist.users) do if e.userId == userId then return true end end return false end
LoadLists()

_G.AdminList = {
    {name="NullSights",userId=240800665,role="Lead Developer"},
    {name="F2Gift",userId=1447409159,role="Tester"},
    {name="77sapato",userId=348855220,role="Administrator"},
    {name="vel",userId=4492091455,role="Contributor"},
    {name="ofa",userId=4696436,role="Administrator"},
    {name="CyanStigmata",userId=1975450441,role="Administrator"},
    {name="Hit0master101",role="Administrator (alt of Cyan)"},
    {name="chr2stina",userId=7013975978,role="Administrator"},
    {name="JakeSights",userId=386219771,role="Administrator"},
    {name="bog",userId=386219771,role="Administrator"},
    {name="V1CTOR",userId=7247383691,role="Administrator"},
    {name="pag5ni",userId=8424074921,role="Administrator"},
    {name="Helicixity",userId=89318267,role="Administrator"},
    {name="0fgail",userId=2980319695,role="Administrator"},
    {name="xAltrive",userId=203556764,role="Administrator"},
    {name="AbsoluteScary",userId=143851429,role="Administrator"},
    {name="SCHADEVREUGDE",userId=175157829,role="Community Manager"},
    {name="DewbyDoppler",userId=85691477,role="Developer"},
    {name="AydenSebastian",userId=85691477,role="Developer"},
    {name="Truffle",userId=1182798858,role="Administrator"},
    {name="n11wc",userId=276307286,role="Administrator"},
    {name="Boen",userId=83075074,role="Administrator"},
    {name="Viper",userId=834460465,role="Administrator"},
}
_G.AdminSettings = {Enabled = true, KickMethod = "kick", NotifyOnDetect = true}
_G.IsAdmin = function(userId, name)
    for _, a in ipairs(AdminList) do
        if a.userId and a.userId == userId then return a end
        if a.name and name and a.name:lower() == name:lower() then return a end
    end
    return nil
end
local function onAdmin(plr, admin)
    if AdminSettings.NotifyOnDetect then Notify("ADMIN", plr.Name .. " (" .. admin.role .. ")", 5) end
    if AdminSettings.KickMethod == "shutdown" then game:Shutdown() else LocalPlayer:Kick("Admin: " .. plr.Name) end
end
local function checkAdmin(plr)
    if plr == LocalPlayer or not AdminSettings.Enabled then return end
    local a = IsAdmin(plr.UserId, plr.Name)
    if a then onAdmin(plr, a) end
end
for _, p in ipairs(Players:GetPlayers()) do checkAdmin(p) end
Players.PlayerAdded:Connect(checkAdmin)

local CONFIG_DIR = Vigil.ConfigsDir
local PRESET_DIR = CONFIG_DIR .. "/presets"
local SETTINGS_PATH = CONFIG_DIR .. "/settings.json"
_G.ConfigSystem = {Current = nil, AutoLoad = "", Directory = CONFIG_DIR}
local function snapshot()
    local d = {features = {}, keybinds = {}}
    local capture = function(name, tbl)
        if not tbl then return end
        local c = {}
        for k, v in pairs(tbl) do
            local t = type(v)
            if t ~= "function" and t ~= "userdata" and t ~= "thread" then c[k] = v end
        end
        d.features[name] = c
    end
    capture("Blink", Blink); capture("Fly", Fly); capture("Aura", Aura); capture("SemiShort", SemiShort)
    capture("AntiAFK", AntiAFK); capture("InfiniteJump", InfiniteJump); capture("AutoHeal", AutoHeal); capture("NoFog", NoFog)
    capture("ServerHop", ServerHop); capture("NoRagdoll", NoRagdoll); capture("AntiBearTrap", AntiBearTrap); capture("AntiVoid", AntiVoid)
    capture("CrateESP", CrateESP); capture("C4ESP", C4ESP); capture("VoidCarry", VoidCarry); capture("NullCarry", NullCarry)
    capture("RunAll", RunAll); capture("StopRunAll", StopRunAll); capture("Admin", AdminSettings)
    if _G.Keybinds then
        for k, v in pairs(Keybinds) do if typeof(v) == "EnumItem" then d.keybinds[k] = v.Name end end
    end
    return d
end
local function applyConfig(d)
    if not d or not d.features then return false end
    local restore = function(name, tbl)
        if not tbl then return end
        local s = d.features[name]
        if not s then return end
        for k, v in pairs(s) do pcall(function() tbl[k] = v end) end
    end
    restore("Blink", Blink); restore("Fly", Fly); restore("Aura", Aura); restore("SemiShort", SemiShort)
    restore("AntiAFK", AntiAFK); restore("InfiniteJump", InfiniteJump); restore("AutoHeal", AutoHeal); restore("NoFog", NoFog)
    restore("ServerHop", ServerHop); restore("NoRagdoll", NoRagdoll); restore("AntiBearTrap", AntiBearTrap); restore("AntiVoid", AntiVoid)
    restore("CrateESP", CrateESP); restore("C4ESP", C4ESP); restore("VoidCarry", VoidCarry); restore("NullCarry", NullCarry)
    restore("RunAll", RunAll); restore("StopRunAll", StopRunAll); restore("Admin", AdminSettings)
    if d.keybinds and _G.Keybinds then
        for name, keyName in pairs(d.keybinds) do
            local k = Enum.KeyCode[keyName]
            if k then Keybinds[name] = k if _G.ApplyKeybind then ApplyKeybind(name) end end
        end
    end
    return true
end
_G.ConfigSave = function(name, overwrite)
    name = name or "default"
    local p = CONFIG_DIR .. "/" .. name .. ".json"
    if fileExists(p) and not overwrite then return false, "exists" end
    local d = snapshot()
    d.meta = {name = name, saved = os.time()}
    if writeJson(p, d) then NotifySuccess("saved: " .. name) return true end
    return false, "write failed"
end
_G.ConfigLoad = function(name)
    name = name or "default"
    local p = CONFIG_DIR .. "/" .. name .. ".json"
    if not fileExists(p) then return false, "not found" end
    local d = readJson(p)
    if not d then return false, "parse failed" end
    if applyConfig(d) then ConfigSystem.Current = name NotifySuccess("loaded: " .. name) return true end
    return false, "apply failed"
end
_G.ConfigDelete = function(name)
    name = name or "default"
    local p = CONFIG_DIR .. "/" .. name .. ".json"
    if not fileExists(p) then return false, "not found" end
    local ok = pcall(delfile, p)
    if ok then NotifySuccess("deleted: " .. name) return true end
    return false, "delete failed"
end
_G.ConfigList = function()
    local names = {}
    local ok, files = pcall(listfiles, CONFIG_DIR)
    if not ok or not files then return names end
    for _, p in ipairs(files) do
        local n = p:match("([^/\\]+)%.json$")
        if n and n ~= "settings" then table.insert(names, n) end
    end
    table.sort(names)
    return names
end
_G.ConfigListPresets = function()
    local names = {}
    local ok, files = pcall(listfiles, PRESET_DIR)
    if not ok or not files then return names end
    for _, p in ipairs(files) do
        local n = p:match("([^/\\]+)%.json$")
        if n then table.insert(names, n) end
    end
    table.sort(names)
    return names
end
_G.ConfigLoadPreset = function(name)
    if not name then return false end
    local p = PRESET_DIR .. "/" .. name .. ".json"
    if not fileExists(p) then return false end
    local d = readJson(p)
    if not d then return false end
    if applyConfig(d) then NotifySuccess("preset: " .. name) return true end
    return false
end
_G.ConfigSaveAsPreset = function(name)
    if not name then return false end
    local p = PRESET_DIR .. "/" .. name .. ".json"
    if fileExists(p) then return false, "exists" end
    local d = snapshot()
    d.meta = {name = name, saved = os.time(), user = true}
    if writeJson(p, d) then NotifySuccess("preset saved: " .. name) return true end
    return false
end
_G.LoadSettings = function()
    local s = readJson(SETTINGS_PATH)
    if not s then return false end
    Vigil.Settings = s
    return true
end
LoadSettings()

local KB_PATH = Vigil.JsonRoot .. "/keybinds.json"
_G.Keybinds = _G.Keybinds or {
    MenuToggle = Enum.KeyCode.Z, Blink = Enum.KeyCode.LeftShift,
    Fly = nil, Aura = nil, SemiShort = nil, AntiAFK = nil,
    InfiniteJump = nil, AutoHeal = nil, NoFog = nil,
    Reset = nil, Respawn = nil, Rejoin = nil, ServerHop = nil,
    NoRagdoll = nil, AntiBearTrap = nil, AntiVoid = nil,
    CrateESP = nil, C4ESP = nil, VoidCarry = nil,
    NullCarry = nil, RunAll = nil, StopRunAll = nil,
}
_G.KeybindActions = _G.KeybindActions or {}
_G.KeybindConns = _G.KeybindConns or {}
_G.RegisterKeybind = function(name, action)
    KeybindActions[name] = action
    if Keybinds[name] and _G.ApplyKeybind then ApplyKeybind(name) end
end
_G.ApplyKeybind = function(name)
    local key = Keybinds[name]
    if not key then return end
    local action = KeybindActions[name]
    if not action then return end
    if KeybindConns[name] then pcall(function() KeybindConns[name]:Disconnect() end) end
    KeybindConns[name] = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == key then action() end
    end)
end
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Keybinds.MenuToggle then
        if gui and gui.Toggle then gui:Toggle()
        else
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then for _, v in ipairs(pg:GetChildren()) do if v:IsA("ScreenGui") then v.Enabled = not v.Enabled end end end
        end
    end
end)
_G.KeybindsLoad = function()
    local d = readJson(KB_PATH)
    if not d then return end
    local binds = d.keybinds or d
    for name, entry in pairs(binds) do
        local kn = type(entry) == "table" and entry.Key or entry
        if kn and kn ~= "" and Enum.KeyCode[kn] then
            Keybinds[name] = Enum.KeyCode[kn]
            ApplyKeybind(name)
        end
    end
end
_G.KeybindsSave = function()
    local out = {meta = {format = "v2"}, keybinds = {}}
    for name, key in pairs(Keybinds) do
        if key == nil then out.keybinds[name] = {Key = nil, State = "Disabled"}
        elseif typeof(key) == "EnumItem" then out.keybinds[name] = {Key = key.Name, State = "Enabled"} end
    end
    writeJson(KB_PATH, out)
end
KeybindsLoad()

_G.Blink = {Enabled=false,State="Disabled",Speed=0.2,Distance=15,VerticalBoost=5,StillForward=-15,StillUp=15,StillBack=-5}
_G.Fly = {Enabled=false,State="Disabled",Speed=50}
_G.Aura = {Enabled=false,State="Disabled",Distance=15,Speed=0.1}
_G.SemiShort = {Enabled=false,State="Disabled",HipHeight=-1}
_G.AntiAFK = {Enabled=false,State="Disabled",Interval=60}
_G.InfiniteJump = {Enabled=false,State="Disabled"}
_G.AutoHeal = {Enabled=false,State="Disabled",Threshold=30,Delay=0.1}
_G.NoFog = {Enabled=false,State="Disabled",OldFogEnd=nil,OldFogStart=nil,OldFogColor=nil}
_G.ServerHop = {Enabled=false,State="Disabled"}
_G.NoRagdoll = {Enabled=false,State="Disabled"}
_G.AntiBearTrap = {Enabled=false,State="Disabled"}
_G.AntiVoid = {Enabled=false,State="Disabled",YThreshold=-100}
_G.CrateESP = {Enabled=false,State="Disabled"}
_G.C4ESP = {Enabled=false,State="Disabled",C4Radius=40}
_G.VoidCarry = {Enabled=false,State="Disabled",Speed=0.1}
_G.NullCarry = {Enabled=false,State="Disabled",Speed=0.1}
_G.RunAll = {Enabled=false,State="Disabled",Delay=0.1,RunValue=5}
_G.StopRunAll = {Enabled=false,State="Disabled",Delay=0.1}
_G.TrollTarget = {Player=nil}

_G.ApplyNoFog = function(state)
    if state then
        NoFog.OldFogEnd = Lighting.FogEnd
        NoFog.OldFogStart = Lighting.FogStart
        NoFog.OldFogColor = Lighting.FogColor
        Lighting.FogEnd = math.huge
        Lighting.FogStart = math.huge
        Lighting.FogColor = Color3.new(0,0,0)
    else
        Lighting.FogEnd = NoFog.OldFogEnd or 100000
        Lighting.FogStart = NoFog.OldFogStart or 0
        Lighting.FogColor = NoFog.OldFogColor or Color3.new(0.5,0.5,0.5)
    end
end

_G.HopOnce = function()
    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)
    local ok, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
    if not ok or not result or not result.data then return false end
    local c = {}
    for _, v in ipairs(result.data) do
        if v.id ~= game.JobId and tonumber(v.playing) < tonumber(v.maxPlayers) then table.insert(c, v.id) end
    end
    if #c == 0 then return false end
    TeleportService:TeleportToPlaceInstance(game.PlaceId, c[math.random(1, #c)], LocalPlayer)
    return true
end

_G.getCharFunEvent = function()
    local char = LocalPlayer.Character
    if not char then return nil end
    local cf = char:FindFirstChild("CharacterFun")
    if not cf then return nil end
    return cf:FindFirstChild("CharFunEvent")
end
_G.getRagdollEvent = function()
    local char = LocalPlayer.Character
    if not char then return nil end
    local r = char:FindFirstChild("Ragdoll")
    if not r then return nil end
    return r:FindFirstChild("RemoteEvent")
end

local crPart = Instance.new("Part")
crPart.Name = "VigilCrate"
crPart.Size = Vector3.new(5,5,5)
crPart.Anchored = true
crPart.CanCollide = false
crPart.CanQuery = false
crPart.CanTouch = false
crPart.Transparency = 0.5
crPart.Color = Color3.fromRGB(255,200,0)
crPart.Material = Enum.Material.Neon
crPart.Parent = workspace

local c4Vis = Instance.new("Part")
c4Vis.Name = "VigilC4"
c4Vis.Anchored = true
c4Vis.CanCollide = false
c4Vis.CanQuery = false
c4Vis.CanTouch = false
c4Vis.Transparency = 1
c4Vis.Material = Enum.Material.Neon
c4Vis.Parent = workspace

local omni_Tick = 0
RunService.Heartbeat:Connect(function()
    if Blink.Enabled then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and hum and (tick() - omni_Tick) >= Blink.Speed then
            omni_Tick = tick()
            local md = hum.MoveDirection
            if md.Magnitude > 0 then
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    hrp.CFrame = hrp.CFrame * CFrame.new(0, Blink.VerticalBoost, 0) + (md.Unit * Blink.Distance)
                else
                    hrp.CFrame = hrp.CFrame + (md.Unit * Blink.Distance)
                end
            else
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0,0,0) * CFrame.new(0, Blink.StillUp, Blink.StillBack)
                else
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0,0,0) * CFrame.new(0, 0, Blink.StillForward)
                end
            end
        end
    end
    if InfiniteJump.Enabled and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
    if Fly.Enabled then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = hrp:FindFirstChild("VigilBV") or Instance.new("BodyVelocity")
            bv.Name = "VigilBV"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Parent = hrp
            local bg = hrp:FindFirstChild("VigilBG") or Instance.new("BodyGyro")
            bg.Name = "VigilBG"
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.P = 1000
            bg.D = 50
            bg.Parent = hrp
            local md = Vector3.zero
            local cam = workspace.CurrentCamera
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then md += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then md -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then md -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then md += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then md += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then md -= Vector3.new(0,1,0) end
            bv.Velocity = md.Magnitude > 0 and (md.Unit * Fly.Speed) or Vector3.zero
            bg.CFrame = cam.CFrame
        end
    else
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = hrp:FindFirstChild("VigilBV")
            local bg = hrp:FindFirstChild("VigilBG")
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
    end
    if AntiVoid.Enabled then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum and root and hum:GetState() == Enum.HumanoidStateType.Freefall and root.Position.Y < AntiVoid.YThreshold then
            root.CFrame = CFrame.new(0, 100, 0)
        end
    end
    if NoRagdoll.Enabled then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            local s = hum:GetState()
            if s == Enum.HumanoidStateType.Physics or hum.PlatformStand then
                local bt = workspace:FindFirstChild("VigilNoRag") or Instance.new("Part")
                bt.Name = "VigilNoRag"
                bt.Size = Vector3.new(2,1,2)
                bt.CanCollide = false
                bt.Anchored = true
                bt.Transparency = 1
                bt.Parent = workspace
                bt.CFrame = hrp.CFrame + Vector3.new(0,-3,0)
                hrp.CFrame = bt.CFrame + Vector3.new(0,3,0)
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hrp.Velocity = Vector3.zero
            end
        end
    end
    if SemiShort.Enabled then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum and root then
            hum.HipHeight = SemiShort.HipHeight
            local mh = LocalPlayer:GetMouse().Hit.Position
            local rp = root.Position
            local nc = CFrame.new(mh, Vector3.new(rp.X, mh.Y, rp.Z)) * CFrame.Angles(0, math.pi, 0)
            root.CFrame = nc + Vector3.new(0, hum.HipHeight or 4, 0)
            root.Velocity = Vector3.zero
        end
    end
    if CrateESP.Enabled then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v.Name == "CrateModel" then
                local m = v:FindFirstChild("Model")
                if m then
                    local flare = v:FindFirstChild("Flare")
                    local flareOn = flare and flare:FindFirstChild("On")
                    local at = flareOn and flareOn:FindFirstChild("Attachment")
                    local sz = at and at:FindFirstChild("sizzling")
                    if m:FindFirstChild("Parachute") or (sz and sz.IsPlaying) then
                        local pos = v:GetPivot().Position
                        crPart.CFrame = CFrame.new(pos.X, 100, pos.Z)
                    end
                end
            end
        end
    else
        crPart.CFrame = CFrame.new(9e9, 9e9, 9e9)
    end
    if C4ESP.Enabled then
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myHrp then
            local closest, cDist = nil, math.huge
            for _, v in ipairs(workspace:GetDescendants()) do
                if v.Name == "C4" or v.Name == "C4Model" or v.Name == "C4Explosive" then
                    local pos = v:GetPivot().Position
                    local d = (myHrp.Position - pos).Magnitude
                    if d < cDist then cDist = d closest = v end
                end
            end
            if closest then
                c4Vis.Transparency = 0.7
                c4Vis.CFrame = CFrame.new(closest:GetPivot().Position)
                if cDist >= C4ESP.C4Radius then
                    c4Vis.Color = Color3.new(0,1,0)
                    c4Vis.Size = Vector3.new(82,82,82)
                else
                    local s = cDist * 2
                    c4Vis.Color = Color3.new(1,0,0)
                    c4Vis.Size = Vector3.new(s,s,s)
                end
            else
                c4Vis.Transparency = 1
            end
        end
    else
        c4Vis.Transparency = 1
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if Aura.Enabled then
            local char = LocalPlayer.Character
            local rapier = char and char:FindFirstChild("Rapier")
            local myHrp = char and char:FindFirstChild("HumanoidRootPart")
            if rapier and myHrp then
                local sw = rapier:FindFirstChild("swing")
                if sw then pcall(function() sw:FireServer() end) end
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer then
                        local tc = p.Character
                        local th = tc and tc:FindFirstChildOfClass("Humanoid")
                        local thrp = tc and tc:FindFirstChild("HumanoidRootPart")
                        if th and thrp and th.Health > 0 and (myHrp.Position - thrp.Position).Magnitude <= Aura.Distance then
                            local h = rapier:FindFirstChild("hit")
                            if h then pcall(function() h:FireServer(th, thrp.Position, thrp, thrp.CFrame) end) end
                        end
                    end
                end
            end
        end
        if AutoHeal.Enabled then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health <= AutoHeal.Threshold then
                local bp = LocalPlayer:FindFirstChild("Backpack")
                local bandage = (bp and bp:FindFirstChild("Bandage")) or (char and char:FindFirstChild("Bandage"))
                if bandage then
                    if bandage.Parent ~= char then hum:EquipTool(bandage) end
                    if bandage.Parent == char then
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new())
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(AntiAFK.Interval)
        if AntiAFK.Enabled then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        if ServerHop.Enabled then HopOnce() end
    end
end)

task.spawn(function()
    while task.wait(RunAll.Delay) do
        if RunAll.Enabled then
            local ev = getCharFunEvent()
            if ev then pcall(function() ev:FireServer("Run", RunAll.RunValue) end) end
        end
    end
end)

task.spawn(function()
    while task.wait(StopRunAll.Delay) do
        if StopRunAll.Enabled then
            local ev = getCharFunEvent()
            if ev then pcall(function() ev:FireServer("StopRun") end) end
        end
    end
end)

local voidState, voidSaved, nullState, nullSaved = "idle", nil, "idle", nil
task.spawn(function()
    while task.wait(VoidCarry.Speed) do
        if not VoidCarry.Enabled then voidState = "idle" continue end
        local t = TrollTarget.Player
        if not t or not t.Character then continue end
        local myChar = LocalPlayer.Character
        if not myChar then continue end
        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
        local tHrp = t.Character:FindFirstChild("HumanoidRootPart")
        if not (myHrp and tHrp) then continue end
        local ev = getCharFunEvent()
        if not ev then continue end
        if voidState == "idle" then
            voidSaved = myHrp.CFrame
            myHrp.CFrame = tHrp.CFrame
            ev:FireServer("Carry")
            voidState = "carrying"
        elseif voidState == "carrying" then
            myHrp.CFrame = CFrame.new(0, -500, 0)
            voidState = "dropping"
        elseif voidState == "dropping" then
            ev:FireServer("Carry")
            if voidSaved then myHrp.CFrame = voidSaved end
            voidState = "cleanup"
        elseif voidState == "cleanup" then
            local re = getRagdollEvent()
            if re then re:FireServer(false) end
            voidState = "idle"
            voidSaved = nil
        end
    end
end)

task.spawn(function()
    while task.wait(NullCarry.Speed) do
        if not NullCarry.Enabled then nullState = "idle" continue end
        local t = TrollTarget.Player
        if not t or not t.Character then continue end
        local myChar = LocalPlayer.Character
        if not myChar then continue end
        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
        local tHrp = t.Character:FindFirstChild("HumanoidRootPart")
        if not (myHrp and tHrp) then continue end
        local ev = getCharFunEvent()
        if not ev then continue end
        if nullState == "idle" then
            nullSaved = myHrp.CFrame
            myHrp.CFrame = tHrp.CFrame
            ev:FireServer("Carry")
            nullState = "carrying"
        elseif nullState == "carrying" then
            ev:FireServer("Carry")
            if nullSaved then myHrp.CFrame = nullSaved end
            nullState = "cleanup"
        elseif nullState == "cleanup" then
            local re = getRagdollEvent()
            if re then re:FireServer(false) end
            nullState = "idle"
            nullSaved = nil
        end
    end
end)

Main:toggle({Name="Blink",Default=false,Callback=function(s) Blink.Enabled=s Blink.State=s and "Enabled" or "Disabled" end})
Main:textbox({Name="Blink Speed",Default="0.2",Callback=function(v) Blink.Speed=tonumber(v) or Blink.Speed end})
Main:textbox({Name="Blink Distance",Default="15",Callback=function(v) Blink.Distance=tonumber(v) or Blink.Distance end})
Main:textbox({Name="Vertical Boost",Default="5",Callback=function(v) Blink.VerticalBoost=tonumber(v) or Blink.VerticalBoost end})
Main:textbox({Name="Still Forward",Default="-15",Callback=function(v) Blink.StillForward=tonumber(v) or Blink.StillForward end})
Main:textbox({Name="Still Up",Default="15",Callback=function(v) Blink.StillUp=tonumber(v) or Blink.StillUp end})
Main:textbox({Name="Still Back",Default="-5",Callback=function(v) Blink.StillBack=tonumber(v) or Blink.StillBack end})

Movement:toggle({Name="Fly",Default=false,Callback=function(s) Fly.Enabled=s Fly.State=s and "Enabled" or "Disabled" end})
Movement:textbox({Name="Fly Speed",Default="50",Callback=function(v) Fly.Speed=tonumber(v) or Fly.Speed end})

Abuse:toggle({Name="Aura",Default=false,Callback=function(s) Aura.Enabled=s Aura.State=s and "Enabled" or "Disabled" end})
Abuse:textbox({Name="Aura Distance",Default="15",Callback=function(v) Aura.Distance=tonumber(v) or Aura.Distance end})
Abuse:textbox({Name="Aura Speed",Default="0.1",Callback=function(v) Aura.Speed=tonumber(v) or Aura.Speed end})
Abuse:toggle({Name="Semi Short",Default=false,Callback=function(s) SemiShort.Enabled=s SemiShort.State=s and "Enabled" or "Disabled" end})
Abuse:textbox({Name="Semi Short HipHeight",Default="-1",Callback=function(v) SemiShort.HipHeight=tonumber(v) or SemiShort.HipHeight end})

Misc:toggle({Name="Anti AFK",Default=false,Callback=function(s) AntiAFK.Enabled=s AntiAFK.State=s and "Enabled" or "Disabled" end})
Misc:textbox({Name="Anti AFK Interval",Default="60",Callback=function(v) AntiAFK.Interval=tonumber(v) or AntiAFK.Interval end})
Misc:toggle({Name="Infinite Jump",Default=false,Callback=function(s) InfiniteJump.Enabled=s InfiniteJump.State=s and "Enabled" or "Disabled" end})
Misc:toggle({Name="Auto Heal",Default=false,Callback=function(s) AutoHeal.Enabled=s AutoHeal.State=s and "Enabled" or "Disabled" end})
Misc:textbox({Name="Auto Heal Threshold",Default="30",Callback=function(v) AutoHeal.Threshold=tonumber(v) or AutoHeal.Threshold end})
Misc:toggle({Name="No Fog",Default=false,Callback=function(s) NoFog.Enabled=s NoFog.State=s and "Enabled" or "Disabled" ApplyNoFog(s) end})
Misc:toggle({Name="Crate ESP",Default=false,Callback=function(s) CrateESP.Enabled=s CrateESP.State=s and "Enabled" or "Disabled" end})
Misc:toggle({Name="C4 ESP",Default=false,Callback=function(s) C4ESP.Enabled=s C4ESP.State=s and "Enabled" or "Disabled" end})
Misc:textbox({Name="C4 ESP Radius",Default="40",Callback=function(v) C4ESP.C4Radius=tonumber(v) or C4ESP.C4Radius end})
Misc:toggle({Name="Server Hop",Default=false,Callback=function(s) ServerHop.Enabled=s ServerHop.State=s and "Enabled" or "Disabled" end})
Misc:button({Name="Hop Once",Callback=function() HopOnce() end})
Misc:button({Name="Rejoin",Callback=function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end})
Misc:button({Name="Reset",Callback=function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
end})
Misc:button({Name="Respawn",Callback=function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
    LocalPlayer.CharacterAdded:Wait()
    task.wait(1)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(0,50,0) end
end})

Antis:toggle({Name="No Ragdoll",Default=false,Callback=function(s) NoRagdoll.Enabled=s NoRagdoll.State=s and "Enabled" or "Disabled" end})
Antis:toggle({Name="Anti Beartrap",Default=false,Callback=function(s) AntiBearTrap.Enabled=s AntiBearTrap.State=s and "Enabled" or "Disabled" end})
Antis:toggle({Name="Anti Void",Default=false,Callback=function(s) AntiVoid.Enabled=s AntiVoid.State=s and "Enabled" or "Disabled" end})
Antis:textbox({Name="Anti Void Y Threshold",Default="-100",Callback=function(v) AntiVoid.YThreshold=tonumber(v) or AntiVoid.YThreshold end})

Troll:dropdown({Name="Target Player",StartingText="Select...",Items=(function()
    local n = {}
    for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(n, p.Name) end end
    return n
end)(),Callback=function(v)
    for _, p in ipairs(Players:GetPlayers()) do if p.Name == v then TrollTarget.Player = p break end end
end})
Troll:toggle({Name="Void Carry",Default=false,Callback=function(s) VoidCarry.Enabled=s VoidCarry.State=s and "Enabled" or "Disabled" end})
Troll:textbox({Name="Void Carry Speed",Default="0.1",Callback=function(v) VoidCarry.Speed=tonumber(v) or VoidCarry.Speed end})
Troll:toggle({Name="Null Carry",Default=false,Callback=function(s) NullCarry.Enabled=s NullCarry.State=s and "Enabled" or "Disabled" end})
Troll:textbox({Name="Null Carry Speed",Default="0.1",Callback=function(v) NullCarry.Speed=tonumber(v) or NullCarry.Speed end})
Troll:toggle({Name="Run All",Default=false,Callback=function(s) RunAll.Enabled=s RunAll.State=s and "Enabled" or "Disabled" end})
Troll:textbox({Name="Run All Delay",Default="0.1",Callback=function(v) RunAll.Delay=tonumber(v) or RunAll.Delay end})
Troll:textbox({Name="Run All Value",Default="5",Callback=function(v) RunAll.RunValue=tonumber(v) or RunAll.RunValue end})
Troll:toggle({Name="Stop Run All",Default=false,Callback=function(s) StopRunAll.Enabled=s StopRunAll.State=s and "Enabled" or "Disabled" end})
Troll:textbox({Name="Stop Run All Delay",Default="0.1",Callback=function(v) StopRunAll.Delay=tonumber(v) or StopRunAll.Delay end})

local function resolvePlayer(query)
    if not query or query == "" then return nil, "empty" end
    local q = query:lower()
    local asId = tonumber(query)
    if asId then
        for _, p in ipairs(Players:GetPlayers()) do if p.UserId == asId then return p end end
    end
    for _, p in ipairs(Players:GetPlayers()) do if p.Name:lower() == q then return p end end
    for _, p in ipairs(Players:GetPlayers()) do if p.DisplayName:lower() == q then return p end end
    local partial = {}
    for _, p in ipairs(Players:GetPlayers()) do if p.Name:lower():sub(1,#q) == q then table.insert(partial, p) end end
    if #partial == 1 then return partial[1] end
    if #partial > 1 then
        local n = {}
        for _, p in ipairs(partial) do table.insert(n, p.Name) end
        return nil, "ambiguous: " .. table.concat(n, ", ")
    end
    return nil, "not found"
end

local function tokenize(input)
    local t = {}
    local i, len = 1, #input
    while i <= len do
        local c = input:sub(i,i)
        if c == " " or c == "\t" then
            i = i + 1
        elseif c == '"' or c == "'" then
            local j = i + 1
            local buf = ""
            while j <= len and input:sub(j,j) ~= c do buf = buf .. input:sub(j,j) j = j + 1 end
            table.insert(t, buf)
            i = j + 1
        else
            local j = i
            local buf = ""
            while j <= len and input:sub(j,j) ~= " " and input:sub(j,j) ~= "\t" do buf = buf .. input:sub(j,j) j = j + 1 end
            table.insert(t, buf)
            i = j
        end
    end
    return t
end

local CMD = {}
CMD.goto = {Usage="goto <player|me|x y z>",Desc="tp to player or coords",Run=function(args)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return "no character" end
    if #args == 1 then
        if args[1]:lower() == "me" then return "already here" end
        local p, e = resolvePlayer(args[1])
        if not p then return e or "not found" end
        local th = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if th then hrp.CFrame = th.CFrame + Vector3.new(0,3,0) return "tp " .. p.Name end
        return "no hrp"
    elseif #args == 3 then
        local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
        if x and y and z then hrp.CFrame = CFrame.new(x,y,z) return string.format("tp %.1f %.1f %.1f", x, y, z) end
        return "invalid"
    end
    return "usage: goto <player|me|x y z>"
end}
CMD.fly = {Usage="fly <speed?>",Desc="toggle fly",Run=function(args)
    local s = tonumber(args[1])
    if s then Fly.Speed = s end
    Fly.Enabled = not Fly.Enabled
    Fly.State = Fly.Enabled and "Enabled" or "Disabled"
    return "fly " .. (Fly.Enabled and "on" or "off") .. " @ " .. tostring(Fly.Speed)
end}
CMD.blink = {Usage="blink <distance?>",Desc="toggle blink",Run=function(args)
    local d = tonumber(args[1])
    if d then Blink.Distance = d end
    Blink.Enabled = not Blink.Enabled
    Blink.State = Blink.Enabled and "Enabled" or "Disabled"
    return "blink " .. (Blink.Enabled and "on" or "off")
end}
CMD.aura = {Usage="aura <distance?>",Desc="toggle aura",Run=function(args)
    local d = tonumber(args[1])
    if d then Aura.Distance = d end
    Aura.Enabled = not Aura.Enabled
    Aura.State = Aura.Enabled and "Enabled" or "Disabled"
    return "aura " .. (Aura.Enabled and "on" or "off")
end}
CMD.voidcarry = {Usage="voidcarry <player?>",Desc="void carry",Run=function(args)
    if args[1] then
        local p, e = resolvePlayer(args[1])
        if not p then return e end
        TrollTarget.Player = p
    end
    if not TrollTarget.Player then return "no target" end
    VoidCarry.Enabled = not VoidCarry.Enabled
    return "voidcarry " .. (VoidCarry.Enabled and "on -> " or "off ") .. TrollTarget.Player.Name
end}
CMD.nullcarry = {Usage="nullcarry <player?>",Desc="null carry",Run=function(args)
    if args[1] then
        local p, e = resolvePlayer(args[1])
        if not p then return e end
        TrollTarget.Player = p
    end
    if not TrollTarget.Player then return "no target" end
    NullCarry.Enabled = not NullCarry.Enabled
    return "nullcarry " .. (NullCarry.Enabled and "on -> " or "off ") .. TrollTarget.Player.Name
end}
CMD.bring = {Usage="bring <who> <where>",Desc="carry who to where",Run=function(args)
    if #args < 2 then return "usage: bring <who> <where>" end
    local who, e1 = resolvePlayer(args[1])
    if not who then return "who: " .. (e1 or "?") end
    local where, e2 = resolvePlayer(args[2])
    if not where then return "where: " .. (e2 or "?") end
    if who == LocalPlayer then return "cant bring self" end
    task.spawn(function()
        local myChar = LocalPlayer.Character
        if not myChar then return end
        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        local ev = getCharFunEvent()
        if not ev then return end
        local orig = myHrp.CFrame
        local wHrp = who.Character and who.Character:FindFirstChild("HumanoidRootPart")
        if not wHrp then return end
        myHrp.CFrame = wHrp.CFrame
        task.wait(0.15)
        ev:FireServer("Carry")
        task.wait(0.3)
        local tHrp = where.Character and where.Character:FindFirstChild("HumanoidRootPart")
        if not tHrp then ev:FireServer("Carry") myHrp.CFrame = orig return end
        myHrp.CFrame = tHrp.CFrame + Vector3.new(0,0,-3)
        task.wait(0.3)
        ev:FireServer("Carry")
        task.wait(0.15)
        myHrp.CFrame = orig
    end)
    return "bringing " .. who.Name .. " to " .. where.Name
end}
CMD.runall = {Usage="runall <value?>",Desc="toggle Run spam",Run=function(args)
    local v = tonumber(args[1])
    if v then RunAll.RunValue = v end
    RunAll.Enabled = not RunAll.Enabled
    RunAll.State = RunAll.Enabled and "Enabled" or "Disabled"
    return "runall " .. (RunAll.Enabled and "on" or "off")
end}
CMD.stoprunall = {Usage="stoprunall",Desc="toggle StopRun",Run=function(args)
    StopRunAll.Enabled = not StopRunAll.Enabled
    StopRunAll.State = StopRunAll.Enabled and "Enabled" or "Disabled"
    return "stoprunall " .. (StopRunAll.Enabled and "on" or "off")
end}
CMD.heal = {Usage="heal",Desc="use bandage",Run=function(args)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return "no character" end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local b = (bp and bp:FindFirstChild("Bandage")) or (char and char:FindFirstChild("Bandage"))
    if not b then return "no bandage" end
    if b.Parent ~= char then hum:EquipTool(b) end
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new())
    return "healed"
end}
CMD.reset = {Usage="reset",Desc="kill character",Run=function(args)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 return "reset" end
    return "no character"
end}
CMD.respawn = {Usage="respawn",Desc="respawn",Run=function(args)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
    LocalPlayer.CharacterAdded:Wait()
    task.wait(1)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(0,50,0) end
    return "respawned"
end}
CMD.rejoin = {Usage="rejoin",Desc="rejoin",Run=function(args)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    return "rejoining..."
end}
CMD.who = {Usage="who <player>",Desc="player info",Run=function(args)
    if not args[1] then return "usage: who <player>" end
    local p, e = resolvePlayer(args[1])
    if not p then return e end
    return string.format("%s (%s) [%d]", p.Name, p.DisplayName, p.UserId)
end}
CMD.players = {Usage="players",Desc="list all players",Run=function(args)
    local o = {}
    for _, p in ipairs(Players:GetPlayers()) do table.insert(o, string.format("%s (%s) [%d]", p.Name, p.DisplayName, p.UserId)) end
    return table.concat(o, " | ")
end}
CMD.help = {Usage="help",Desc="list commands",Run=function(args)
    local o = {}
    for name, c in pairs(CMD) do table.insert(o, c.Usage) end
    table.sort(o)
    return table.concat(o, " | ")
end}

local function dispatch(input)
    if not input or input == "" then return end
    local tokens = tokenize(input)
    if #tokens == 0 then return end
    local name = tokens[1]:lower()
    local args = {}
    for i = 2, #tokens do table.insert(args, tokens[i]) end
    local c = CMD[name]
    if not c then NotifyError("unknown: " .. name) return end
    local ok, result = pcall(c.Run, args)
    if not ok then NotifyError(name .. ": " .. tostring(result))
    else NotifySuccess(result or "") end
end

Commands:textbox({Name="Command Input",Description="type command + args",Default="",Callback=function(v) dispatch(v) end})
Commands:button({Name="Show All Commands",Callback=function()
    local o = {}
    for _, c in pairs(CMD) do table.insert(o, c.Usage) end
    table.sort(o)
    Notify("Commands", table.concat(o, " | "), 10)
end})
for name, c in pairs(CMD) do
    Commands:button({Name="? " .. c.Usage,Description=c.Desc,Callback=function() Notify("Command", c.Usage .. " - " .. c.Desc, 5) end})
end

Lists:textbox({Name="Whitelist UserID",Default="",Callback=function(v)
    local id = tonumber(v)
    if not id then NotifyError("invalid") return end
    if AddToWhitelist(id) then NotifySuccess("whitelisted " .. id) else NotifyInfo("already") end
end})
Lists:textbox({Name="Remove Whitelist",Default="",Callback=function(v)
    local id = tonumber(v)
    if not id then NotifyError("invalid") return end
    if RemoveFromWhitelist(id) then NotifySuccess("removed") else NotifyInfo("not found") end
end})
Lists:button({Name="Show Whitelist",Callback=function()
    local o = {}
    for _, u in ipairs(ListData.Whitelist.users) do table.insert(o, (u.name or "?") .. " (" .. u.userId .. ")") end
    if #o == 0 then NotifyInfo("empty") else Notify("Whitelist (" .. #o .. ")", table.concat(o, ", "), 8) end
end})
Lists:button({Name="Clear Whitelist",Callback=function()
    ListData.Whitelist.users = {}
    SaveLists()
    NotifySuccess("cleared")
end})
Lists:textbox({Name="Blacklist UserID",Default="",Callback=function(v)
    local id = tonumber(v)
    if not id then NotifyError("invalid") return end
    if AddToBlacklist(id) then NotifySuccess("blacklisted " .. id) else NotifyInfo("already") end
end})
Lists:textbox({Name="Remove Blacklist",Default="",Callback=function(v)
    local id = tonumber(v)
    if not id then NotifyError("invalid") return end
    if RemoveFromBlacklist(id) then NotifySuccess("removed") else NotifyInfo("not found") end
end})
Lists:button({Name="Show Blacklist",Callback=function()
    local o = {}
    for _, u in ipairs(ListData.Blacklist.users) do table.insert(o, (u.name or "?") .. " (" .. u.userId .. ")") end
    if #o == 0 then NotifyInfo("empty") else Notify("Blacklist (" .. #o .. ")", table.concat(o, ", "), 8) end
end})
Lists:button({Name="Clear Blacklist",Callback=function()
    ListData.Blacklist.users = {}
    SaveLists()
    NotifySuccess("cleared")
end})
Lists:button({Name="Whitelist Everyone",Callback=function()
    for _, p in ipairs(Players:GetPlayers()) do AddToWhitelist(p.UserId, p.Name) end
    NotifySuccess("done")
end})
Lists:button({Name="Blacklist Everyone",Callback=function()
    for _, p in ipairs(Players:GetPlayers()) do AddToBlacklist(p.UserId, p.Name) end
    NotifySuccess("done")
end})

Configs:textbox({Name="Save Config",Default="",Callback=function(v)
    if not v or v == "" then NotifyError("enter a name") return end
    local ok, err = ConfigSave(v, false)
    if not ok then NotifyInfo(err or "save failed") end
end})
Configs:textbox({Name="Overwrite Config",Default="",Callback=function(v)
    if not v or v == "" then NotifyError("enter a name") return end
    ConfigSave(v, true)
end})
Configs:textbox({Name="Load Config",Default="",Callback=function(v)
    if not v or v == "" then NotifyError("enter a name") return end
    local ok, err = ConfigLoad(v)
    if not ok then NotifyError(err or "load failed") end
end})
Configs:textbox({Name="Delete Config",Default="",Callback=function(v)
    if not v or v == "" then NotifyError("enter a name") return end
    ConfigDelete(v)
end})
Configs:button({Name="List Configs",Callback=function()
    local l = ConfigList()
    if #l == 0 then NotifyInfo("none") else Notify("Configs", table.concat(l, ", "), 8) end
end})
Configs:button({Name="Save Default",Callback=function() ConfigSave("default", true) end})
Configs:button({Name="Load Default",Callback=function() ConfigLoad("default") end})
Configs:dropdown({Name="Presets",StartingText="select...",Items=ConfigListPresets(),Callback=function(v)
    if v then ConfigLoadPreset(v) end
end})
Configs:textbox({Name="Save as Preset",Default="",Callback=function(v)
    if v and v ~= "" then ConfigSaveAsPreset(v) end
end})
Configs:textbox({Name="Auto Load Config",Default=ConfigSystem.AutoLoad or "",Callback=function(v)
    ConfigSystem.AutoLoad = v
    NotifySuccess("autoload: " .. v)
end})

Debug:toggle({Name="Admin Detection",Default=AdminSettings.Enabled,Callback=function(s) AdminSettings.Enabled = s end})
Debug:dropdown({Name="Admin Kick Method",StartingText="kick",Items={{"Kick","kick"},{"Shutdown","shutdown"}},Callback=function(v) AdminSettings.KickMethod = v end})
Debug:toggle({Name="Admin Notify",Default=AdminSettings.NotifyOnDetect,Callback=function(s) AdminSettings.NotifyOnDetect = s end})
Debug:button({Name="Check Current Server",Callback=function()
    local found = {}
    for _, p in ipairs(Players:GetPlayers()) do
        local a = IsAdmin(p.UserId, p.Name)
        if a then table.insert(found, p.Name .. " (" .. a.role .. ")") end
    end
    if #found == 0 then NotifyInfo("no admins") else Notify("Admins", table.concat(found, ", "), 5) end
end})
Debug:button({Name="Dump Whitelist",Callback=function()
    local o = {}
    for _, u in ipairs(ListData.Whitelist.users) do table.insert(o, (u.name or "?") .. " (" .. u.userId .. ")") end
    Notify("Whitelist (" .. #o .. ")", table.concat(o, ", "), 10)
end})
Debug:button({Name="Dump Parser",Callback=function()
    local o = {}
    for _, u in ipairs(ParserData.users) do table.insert(o, u.name .. " (" .. u.userId .. ")") end
    Notify("Parser (" .. #o .. ")", table.concat(o, ", "), 10)
end})
Debug:button({Name="Character Info",Callback=function()
    local char = LocalPlayer.Character
    if not char then NotifyError("no character") return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local o = {}
    if hum then table.insert(o, "hp " .. math.floor(hum.Health)) table.insert(o, "state " .. tostring(hum:GetState())) end
    if hrp then table.insert(o, string.format("pos %.1f %.1f %.1f", hrp.Position.X, hrp.Position.Y, hrp.Position.Z)) end
    Notify("Character", table.concat(o, " | "), 6)
end})
Debug:button({Name="Player List",Callback=function()
    local o = {}
    for _, p in ipairs(Players:GetPlayers()) do table.insert(o, string.format("%s (%s) [%d]", p.Name, p.DisplayName, p.UserId)) end
    Notify("Players (" .. #o .. ")", table.concat(o, ", "), 8)
end})

local KeybindList = {"MenuToggle","Blink","Fly","Aura","SemiShort","AntiAFK","InfiniteJump","AutoHeal","NoFog","Reset","Respawn","Rejoin","ServerHop","NoRagdoll","AntiBearTrap","AntiVoid","CrateESP","C4ESP","VoidCarry","NullCarry","RunAll","StopRunAll"}
for _, name in ipairs(KeybindList) do
    KeybindsTab:keybind({Name=name,Default=Keybinds[name] or Enum.UserInputType.None,Callback=function(key)
        Keybinds[name] = key.KeyCode or key
        ApplyKeybind(name)
        KeybindsSave()
        NotifySuccess("bind " .. name .. " -> " .. tostring(Keybinds[name]))
    end})
end
KeybindsTab:button({Name="Clear All Keybinds",Callback=function()
    for name, _ in pairs(Keybinds) do
        if name ~= "MenuToggle" then Keybinds[name] = nil end
    end
    KeybindsSave()
    NotifySuccess("cleared")
end})

RegisterKeybind("Blink", function() Blink.Enabled = not Blink.Enabled Blink.State = Blink.Enabled and "Enabled" or "Disabled" end)
RegisterKeybind("Fly", function() Fly.Enabled = not Fly.Enabled Fly.State = Fly.Enabled and "Enabled" or "Disabled" end)
RegisterKeybind("Aura", function() Aura.Enabled = not Aura.Enabled Aura.State = Aura.Enabled and "Enabled" or "Disabled" end)
RegisterKeybind("SemiShort", function() SemiShort.Enabled = not SemiShort.Enabled SemiShort.State = SemiShort.Enabled and "Enabled" or "Disabled" end)
RegisterKeybind("AntiAFK", function() AntiAFK.Enabled = not AntiAFK.Enabled AntiAFK.State = AntiAFK.Enabled and "Enabled" or "Disabled" end)
RegisterKeybind("InfiniteJump", function() InfiniteJump.Enabled = not InfiniteJump.Enabled InfiniteJump.State = InfiniteJump.Enabled and "Enabled" or "Disabled" end)
RegisterKeybind("AutoHeal", function() AutoHeal.Enabled = not AutoHeal.Enabled AutoHeal.State = AutoHeal.Enabled and "Enabled" or "Disabled" end)
RegisterKeybind("NoFog", function() NoFog.Enabled = not NoFog.Enabled NoFog.State = NoFog.Enabled and "Enabled" or "Disabled" ApplyNoFog(NoFog.Enabled) end)
RegisterKeybind("NoRagdoll", function() NoRagdoll.Enabled = not NoRagdoll.Enabled NoRagdoll.State = NoRagdoll.Enabled and "Enabled" or "Disabled" end)
RegisterKeybind("AntiBearTrap", function() AntiBearTrap.Enabled = not AntiBearTrap.Enabled AntiBearTrap.State = AntiBearTrap.Enabled and "Enabled" or "Disabled" end)
RegisterKeybind("AntiVoid", function() AntiVoid.Enabled = not AntiVoid.Enabled AntiVoid.State = AntiVoid.Enabled and "Enabled" or "Disabled" end)
RegisterKeybind("CrateESP", function() CrateESP.Enabled = not CrateESP.Enabled CrateESP.State = CrateESP.Enabled and "Enabled" or "Disabled" end)
RegisterKeybind("C4ESP", function() C4ESP.Enabled = not C4ESP.Enabled C4ESP.State = C4ESP.Enabled and "Enabled" or "Disabled" end)
RegisterKeybind("VoidCarry", function() VoidCarry.Enabled = not VoidCarry.Enabled VoidCarry.State = VoidCarry.Enabled and "Enabled" or "Disabled" end)
RegisterKeybind("NullCarry", function() NullCarry.Enabled = not NullCarry.Enabled NullCarry.State = NullCarry.Enabled and "Enabled" or "Disabled" end)
RegisterKeybind("RunAll", function() RunAll.Enabled = not RunAll.Enabled RunAll.State = RunAll.Enabled and "Enabled" or "Disabled" end)
RegisterKeybind("StopRunAll", function() StopRunAll.Enabled = not StopRunAll.Enabled StopRunAll.State = StopRunAll.Enabled and "Enabled" or "Disabled" end)
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
    if hrp then hrp.CFrame = CFrame.new(0,50,0) end
end)
RegisterKeybind("Rejoin", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

if _G.NotifySuccess then NotifySuccess("Vigil loaded") end