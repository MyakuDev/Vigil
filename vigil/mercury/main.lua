--!nonstrict
-- Vigil Mercury UI — with GitHub tools

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
local gui = Library:create{ Theme = Library.Themes.Serika }

local function log(msg) print("[Vigil][Mercury] " .. tostring(msg)) end
local function notify(msg) pcall(function() gui:set_status(tostring(msg)) end); log(msg) end

local function ping(label, url)
    local t0 = os.clock()
    local ok, res = pcall(function() return game:HttpGet(url, true) end)
    local dt = math.floor((os.clock() - t0) * 1000)
    if ok and res and #res > 0 then
        print(string.format("[Vigil][CT] %-28s OK   %5dms  (%d bytes)", label, dt, #res))
        return true, res
    end
    print(string.format("[Vigil][CT] %-28s FAIL %5dms", label, dt))
    return false, nil
end

local function copy(t)
    if setclipboard then pcall(setclipboard, t); return true end
    return false
end

local function ts() return os.date("%Y-%m-%d %H:%M:%S") end
local BASE = "https://raw.githubusercontent.com/MyakuDev/Vigil/main/vigil"

-- Tab 1 — Messages
local msgTab = gui:tab({ Icon = "rbxassetid://6031075931", Name = "Messages" })
msgTab:button({ Name = "Print Hello", Callback = function() log("hello"); notify("hello") end })
msgTab:button({ Name = "Print Timestamp", Callback = function() log("time: " .. ts()); notify("time printed") end })
msgTab:button({ Name = "Print Executor Info", Callback = function()
    log("executor:   " .. tostring(identifyexecutor and identifyexecutor() or "unknown"))
    log("httpget:    " .. type(game.HttpGet))
    log("writefile:  " .. tostring(writefile ~= nil))
    log("isfile:     " .. tostring(isfile ~= nil))
    log("isfolder:   " .. tostring(isfolder ~= nil))
    log("readfile:   " .. tostring(readfile ~= nil))
    log("listfiles:  " .. tostring(listfiles ~= nil))
    log("delfile:    " .. tostring(delfile ~= nil))
    log("setclipboard:" .. tostring(setclipboard ~= nil))
    notify("executor info printed")
end })
msgTab:button({ Name = "Print Player Info", Callback = function()
    local lp = game:GetService("Players").LocalPlayer
    log("name:    " .. lp.Name)
    log("display: " .. lp.DisplayName)
    log("userid:  " .. tostring(lp.UserId))
    log("placeid: " .. tostring(game.PlaceId))
    log("jobid:   " .. tostring(game.JobId))
    notify("player info printed")
end })
msgTab:button({ Name = "Print All Players", Callback = function()
    local players = game:GetService("Players"):GetPlayers()
    log("players: " .. #players)
    for _, p in ipairs(players) do log("  " .. p.Name .. " (" .. p.UserId .. ")") end
    notify("printed " .. #players .. " players")
end })
msgTab:textbox({ Name = "Custom Message", Placeholder = "type and press enter", Callback = function(v)
    if v and v ~= "" then log("custom: " .. v); notify("printed: " .. v) end
end })
msgTab:textbox({ Name = "Repeat Count", Placeholder = "how many", Callback = function(v)
    local n = tonumber(v); if n then log("repeat: " .. n) end
end })

-- Tab 2 — GitHub
local ghTab = gui:tab({ Icon = "rbxassetid://6031094678", Name = "GitHub" })

ghTab:textbox({ Name = "URL to Test", Placeholder = BASE .. "/manifest.json", Callback = function(v)
    if v and v ~= "" then ghTab._url = v; log("url saved: " .. v) end
end })
ghTab:button({ Name = "Test URL", Callback = function()
    local url = ghTab._url or (BASE .. "/manifest.json")
    local ok, res = ping("custom url", url)
    if ok then notify("200 OK, " .. #res .. " bytes") else notify("failed") end
end })
ghTab:button({ Name = "Fetch and Print URL", Callback = function()
    local url = ghTab._url or (BASE .. "/manifest.json")
    log("fetching " .. url)
    local ok, res = pcall(function() return game:HttpGet(url, true) end)
    if ok and res then
        local lines = 0
        for line in res:gmatch("[^\n]+") do
            lines = lines + 1
            if lines > 50 then break end
            print("[Vigil][GH] " .. line)
        end
        notify("printed " .. math.min(lines, 50) .. " lines")
    else notify("fetch failed") end
end })
ghTab:button({ Name = "Copy URL to Clipboard", Callback = function()
    local url = ghTab._url or (BASE .. "/manifest.json")
    if copy(url) then notify("copied") else notify("no clipboard") end
end })
ghTab:button({ Name = "Test manifest.json", Callback = function() ping("manifest.json", BASE .. "/manifest.json") end })
ghTab:button({ Name = "Test main.lua",       Callback = function() ping("main.lua", BASE .. "/main.lua") end })
ghTab:button({ Name = "Test loader.lua",     Callback = function() ping("loader.lua", BASE .. "/loader/loader.lua") end })
ghTab:button({ Name = "Test mercury/main.lua", Callback = function() ping("mercury/main.lua", BASE .. "/mercury/main.lua") end })
ghTab:button({ Name = "Test all repo files", Callback = function()
    local checks = {
        { "manifest.json",   BASE .. "/manifest.json" },
        { "main.lua",        BASE .. "/main.lua" },
        { "loader.lua",      BASE .. "/loader/loader.lua" },
        { "mercury/main",    BASE .. "/mercury/main.lua" },
        { "mercury/loader",  BASE .. "/mercury/loader.lua" },
    }
    local pass, total = 0, 0
    for _, c in ipairs(checks) do
        total = total + 1
        if ping(c[1], c[2]) then pass = pass + 1 end
        task.wait(0.05)
    end
    notify(string.format("repo: %d/%d", pass, total))
end })
ghTab:button({ Name = "Test external libs", Callback = function()
    ping("Fluent SaveManager", "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua")
    ping("Fluent Interface",   "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua")
    ping("Mercury library",    "https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua")
    notify("external libs tested")
end })
ghTab:button({ Name = "Test all APIs", Callback = function()
    ping("api.github.com",   "https://api.github.com")
    ping("users.roblox.com", "https://users.roblox.com/v1/users/1")
    ping("games.roblox.com", "https://games.roblox.com/v1/games/1")
    notify("apis tested")
end })
ghTab:button({ Name = "Copy repo URL", Callback = function()
    copy("https://github.com/MyakuDev/Vigil"); notify("copied repo url")
end })
ghTab:button({ Name = "Copy raw base", Callback = function()
    copy(BASE); notify("copied raw base")
end })

-- Tab 3 — Loaders
local loadTab = gui:tab({ Icon = "rbxassetid://6031145841", Name = "Loaders" })

loadTab:textbox({ Name = "Loader URL", Placeholder = BASE .. "/mercury/loader.lua", Callback = function(v)
    if v and v ~= "" then loadTab._url = v; log("loader url saved") end
end })
loadTab:button({ Name = "Run Custom Loader", Callback = function()
    local url = loadTab._url
    if not url then notify("no URL"); return end
    local ok, src = pcall(function() return game:HttpGet(url, true) end)
    if not ok or not src or src == "" then notify("fetch failed"); return end
    local fn, err = loadstring(src, "@custom")
    if not fn then notify("compile failed: " .. tostring(err)); return end
    local ok2, runErr = pcall(fn)
    if not ok2 then notify("runtime: " .. tostring(runErr)) end
end })
loadTab:button({ Name = "Load Vigil Main", Callback = function()
    loadstring(game:HttpGet(BASE .. "/loader/loader.lua?t=" .. os.time()))()
end })
loadTab:button({ Name = "Load Mercury (fresh)", Callback = function()
    loadstring(game:HttpGet(BASE .. "/mercury/loader.lua?t=" .. os.time()))()
end })
loadTab:button({ Name = "Copy Vigil Loadstring", Callback = function()
    copy('loadstring(game:HttpGet("' .. BASE .. '/loader/loader.lua?t=" .. os.time()))()')
    notify("copied Vigil loadstring")
end })
loadTab:button({ Name = "Copy Mercury Loadstring", Callback = function()
    copy('loadstring(game:HttpGet("' .. BASE .. '/mercury/loader.lua?t=" .. os.time()))()')
    notify("copied Mercury loadstring")
end })

-- Tab 4 — Files
local fileTab = gui:tab({ Icon = "rbxassetid://6031280882", Name = "Files" })

fileTab:button({ Name = "List Vigil/ Files", Callback = function()
    local ROOT = "Vigil"
    log("---- files ----")
    for _, d in ipairs({ ROOT, ROOT .. "/lib", ROOT .. "/ui", ROOT .. "/mercury" }) do
        if isfolder and isfolder(d) then
            local ok, files = pcall(listfiles, d)
            if ok and files then
                for _, f in ipairs(files) do
                    local size = 0
                    local rok, data = pcall(readfile, f)
                    if rok and data then size = #data end
                    log(string.format("  %-45s %d bytes", f, size))
                end
            end
        end
    end
    notify("files listed")
end })
fileTab:textbox({ Name = "Read File", Placeholder = "Vigil/manifest.json", Callback = function(v)
    if not v or v == "" then return end
    local ok, data = pcall(readfile, v)
    if ok and data then
        local lines = 0
        for line in data:gmatch("[^\n]+") do
            lines = lines + 1
            if lines > 30 then break end
            print("[Vigil][File] " .. line)
        end
        notify("read " .. math.min(lines, 30) .. " lines")
    else notify("cannot read " .. v) end
end })
fileTab:textbox({ Name = "Write Path", Placeholder = "Vigil/test.txt", Callback = function(v)
    if v and v ~= "" then fileTab._path = v; log("path set") end
end })
fileTab:textbox({ Name = "Write Contents", Placeholder = "text", Callback = function(v)
    fileTab._content = v; log("content set")
end })
fileTab:button({ Name = "Save File", Callback = function()
    if not fileTab._path or not fileTab._content then notify("set path and content"); return end
    if writefile then
        local ok = pcall(writefile, fileTab._path, fileTab._content)
        if ok then notify("wrote " .. fileTab._path) else notify("write failed") end
    else notify("no writefile") end
end })
fileTab:button({ Name = "Wipe Vigil/ Cache", Callback = function()
    local ROOT = "Vigil"
    for _, d in ipairs({ ROOT .. "/ui", ROOT .. "/lib", ROOT .. "/mercury", ROOT }) do
        if isfolder and isfolder(d) then
            local ok, files = pcall(listfiles, d)
            if ok and files then for _, f in ipairs(files) do pcall(delfile, f) end end
            pcall(delfolder, d)
        end
    end
    notify("cache wiped")
end })

-- Tab 5 — Misc
local miscTab = gui:tab({ Icon = "rbxassetid://6031265976", Name = "Misc" })
miscTab:button({ Name = "Print Game Info", Callback = function()
    log("placeid: " .. game.PlaceId)
    log("creator: " .. tostring(game.CreatorId))
    notify("game info printed")
end })
miscTab:button({ Name = "Print Ping", Callback = function()
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
    log(string.format("ping: %.1f ms", ping))
    notify(string.format("ping: %.1f ms", ping))
end })
miscTab:button({ Name = "Print FPS", Callback = function()
    local frames, t0 = 0, os.clock()
    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function()
        frames = frames + 1
        if os.clock() - t0 >= 1 then
            conn:Disconnect()
            log("fps: " .. frames)
            notify("fps: " .. frames)
        end
    end)
end })
miscTab:button({ Name = "Copy JobId", Callback = function() copy(game.JobId); notify("copied jobid") end })
miscTab:button({ Name = "Copy PlaceId", Callback = function() copy(tostring(game.PlaceId)); notify("copied placeid") end })

gui:set_status("Vigil Mercury UI loaded")
log("Mercury UI ready")
return { gui = gui }