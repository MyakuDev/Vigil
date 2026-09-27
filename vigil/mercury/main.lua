--!nonstrict
-- Vigil Mercury Test UI
-- Buttons that print to console, plus GitHub connection tests.

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
local gui = Library:create{ Theme = Library.Themes.Serika }

-- ============================================================
-- Shared helpers
-- ============================================================
local function log(msg)
    print("[Vigil][Mercury] " .. tostring(msg))
end

local function notify(msg)
    pcall(function() gui:set_status(tostring(msg)) end)
    log(msg)
end

local function ping(label, url)
    local t0 = os.clock()
    local ok, res = pcall(function() return game:HttpGet(url, true) end)
    local dt = math.floor((os.clock() - t0) * 1000)
    if ok and res and #res > 0 then
        print(string.format("[Vigil][CT] %-24s OK   %5dms  (%d bytes)", label, dt, #res))
        return true
    else
        print(string.format("[Vigil][CT] %-24s FAIL %5dms", label, dt))
        return false
    end
end

local function timestamp()
    return os.date("%Y-%m-%d %H:%M:%S")
end

-- ============================================================
-- Tab 1 — Messages
-- ============================================================
local msgTab = gui:tab({ Icon = "rbxassetid://6031075931", Name = "Messages" })

msgTab:button({
    Name = "Print Hello",
    Callback = function()
        log("hello from Mercury UI")
        notify("printed hello")
    end,
})

msgTab:button({
    Name = "Print Timestamp",
    Callback = function()
        log("time: " .. timestamp())
        notify("time printed")
    end,
})

msgTab:button({
    Name = "Print Executor Info",
    Callback = function()
        log("executor: " .. tostring(identifyexecutor and identifyexecutor() or "unknown"))
        log("httpget:  " .. type(game.HttpGet))
        log("writefile:" .. tostring(writefile ~= nil))
        log("isfile:   " .. tostring(isfile ~= nil))
        log("isfolder: " .. tostring(isfolder ~= nil))
        log("readfile: " .. tostring(readfile ~= nil))
        notify("executor info printed")
    end,
})

msgTab:button({
    Name = "Print Player Info",
    Callback = function()
        local lp = game:GetService("Players").LocalPlayer
        log("name:     " .. lp.Name)
        log("display:  " .. lp.DisplayName)
        log("userid:   " .. tostring(lp.UserId))
        log("placeid:  " .. tostring(game.PlaceId))
        log("jobid:    " .. tostring(game.JobId))
        notify("player info printed")
    end,
})

msgTab:button({
    Name = "Print All Players",
    Callback = function()
        local players = game:GetService("Players"):GetPlayers()
        log("players in server: " .. #players)
        for _, p in ipairs(players) do
            log("  " .. p.Name .. " (id " .. p.UserId .. ")")
        end
        notify("printed " .. #players .. " players")
    end,
})

msgTab:textbox({
    Name = "Custom Message",
    Placeholder = "type a message and press enter",
    Callback = function(v)
        if v and v ~= "" then
            log("custom: " .. v)
            notify("printed: " .. v)
        end
    end,
})

-- ============================================================
-- Tab 2 — GitHub Connection Tests
-- ============================================================
local ctTab = gui:tab({ Icon = "rbxassetid://6031094678", Name = "Connection" })

ctTab:button({
    Name = "Test All",
    Callback = function()
        log("========== run all tests ==========")
        local base = "https://raw.githubusercontent.com/MyakuDev/Vigil/main/vigil"
        local checks = {
            { "repo manifest",       base .. "/manifest.json" },
            { "repo main.lua",       base .. "/main.lua" },
            { "repo loader.lua",     base .. "/loader/loader.lua" },
            { "mercury main.lua",    base .. "/mercury/main.lua" },
            { "mercury loader.lua",  base .. "/mercury/loader.lua" },
            { "Fluent SaveManager",  "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua" },
            { "Mercury library",     "https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua" },
        }
        local pass, total = 0, 0
        for _, c in ipairs(checks) do
            total = total + 1
            if ping(c[1], c[2]) then pass = pass + 1 end
            task.wait(0.05)
        end
        log(string.format("========== %d/%d passed ==========", pass, total))
        notify(string.format("tests: %d/%d", pass, total))
    end,
})

ctTab:button({
    Name = "Test Repo Files Only",
    Callback = function()
        local base = "https://raw.githubusercontent.com/MyakuDev/Vigil/main/vigil"
        ping("manifest.json", base .. "/manifest.json")
        ping("main.lua",      base .. "/main.lua")
        ping("loader.lua",    base .. "/loader/loader.lua")
        notify("repo files tested")
    end,
})

ctTab:button({
    Name = "Test Mercury Files Only",
    Callback = function()
        local base = "https://raw.githubusercontent.com/MyakuDev/Vigil/main/vigil"
        ping("mercury/main.lua",   base .. "/mercury/main.lua")
        ping("mercury/loader.lua", base .. "/mercury/loader.lua")
        notify("mercury files tested")
    end,
})

ctTab:button({
    Name = "Test External Libraries",
    Callback = function()
        ping("Fluent SaveManager", "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua")
        ping("Mercury library",    "https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua")
        notify("external libs tested")
    end,
})

ctTab:button({
    Name = "Test API Endpoints",
    Callback = function()
        ping("api.github.com",     "https://api.github.com")
        ping("users.roblox.com",   "https://users.roblox.com/v1/users/1")
        ping("games.roblox.com",   "https://games.roblox.com/v1/games/1")
        notify("api endpoints tested")
    end,
})

-- ============================================================
-- Tab 3 — Local Files
-- ============================================================
local fileTab = gui:tab({ Icon = "rbxassetid://6031280882", Name = "Files" })

fileTab:button({
    Name = "List Vigil/ Files",
    Callback = function()
        local ROOT = "Vigil"
        log("---- local files ----")
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
        log("---------------------")
        notify("files listed")
    end,
})

fileTab:button({
    Name = "Show Workspace Info",
    Callback = function()
        log("workspace: " .. tostring(workspace))
        log("children:  " .. #workspace:GetChildren())
        log("players folder: " .. tostring(workspace:FindFirstChild("PlayersCharacters")))
        notify("workspace info printed")
    end,
})

fileTab:button({
    Name = "Wipe Vigil/ Cache",
    Callback = function()
        local ROOT = "Vigil"
        for _, d in ipairs({ ROOT .. "/ui", ROOT .. "/lib", ROOT .. "/mercury", ROOT }) do
            if isfolder and isfolder(d) then
                local ok, files = pcall(listfiles, d)
                if ok and files then
                    for _, f in ipairs(files) do pcall(delfile, f) end
                end
                pcall(delfolder, d)
            end
        end
        log("cache wiped")
        notify("Vigil/ wiped")
    end,
})

-- ============================================================
-- Tab 4 — Misc
-- ============================================================
local miscTab = gui:tab({ Icon = "rbxassetid://6031265976", Name = "Misc" })

miscTab:button({
    Name = "Print Game Info",
    Callback = function()
        log("place name: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
        log("place id:   " .. tostring(game.PlaceId))
        log("creator id: " .. tostring(game.CreatorId))
        notify("game info printed")
    end,
})

miscTab:button({
    Name = "Print Ping (ms)",
    Callback = function()
        local stats = game:GetService("Stats")
        local ping = stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        log("server ping: " .. string.format("%.1f ms", ping))
        notify(string.format("ping: %.1f ms", ping))
    end,
})

miscTab:button({
    Name = "Print FPS",
    Callback = function()
        local frames = 0
        local t0 = os.clock()
        local conn
        conn = game:GetService("RunService").RenderStepped:Connect(function()
            frames = frames + 1
            if os.clock() - t0 >= 1 then
                conn:Disconnect()
                log("fps: " .. frames)
                notify("fps: " .. frames)
            end
        end)
    end,
})

gui:set_status("Vigil Mercury Test UI loaded")
log("Mercury test UI ready")

return { gui = gui }