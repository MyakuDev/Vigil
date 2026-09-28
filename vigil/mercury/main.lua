--!nonstrict
-- Vigil Mercury UI — fixed Mercury Library syntax

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
local gui = Library:create{
    Theme = Library.Themes.Serika
}

-- ============================================================
-- Tabs — note: gui:tab{...} with NO parentheses
-- ============================================================
local mainTab = gui:tab{
    Icon = "rbxassetid://6031094678",
    Name = "Main"
}

local connTab = gui:tab{
    Icon = "rbxassetid://6031075931",
    Name = "Connection"
}

-- ============================================================
-- Main tab
-- ============================================================
mainTab:button{
    Name = "Hello",
    Callback = function()
        gui:set_status("hello from Mercury UI")
    end
}

mainTab:button{
    Name = "Print Player Info",
    Callback = function()
        local lp = game:GetService("Players").LocalPlayer
        print("[Vigil][Mercury] name: " .. lp.Name)
        print("[Vigil][Mercury] display: " .. lp.DisplayName)
        print("[Vigil][Mercury] userid: " .. tostring(lp.UserId))
        gui:set_status("printed player info")
    end
}

mainTab:textbox{
    Name = "Custom Message",
    Placeholder = "type and press enter",
    Callback = function(v)
        if v and v ~= "" then
            print("[Vigil][Mercury] " .. v)
            gui:set_status("printed: " .. v)
        end
    end
}

mainTab:dropdown{
    Name = "Preset",
    StartingText = "choose",
    Items = { "hello", "ping", "blank" },
    Callback = function(v)
        gui:set_status("preset: " .. tostring(v))
    end
}

-- ============================================================
-- Connection tab
-- ============================================================
local function ping(label, url)
    local t0 = os.clock()
    local ok, res = pcall(function() return game:HttpGet(url, true) end)
    local dt = math.floor((os.clock() - t0) * 1000)
    if ok and res and #res > 0 then
        print(string.format("[Vigil][CT] %-26s OK   %5dms  (%d bytes)", label, dt, #res))
        return true
    end
    print(string.format("[Vigil][CT] %-26s FAIL %5dms", label, dt))
    return false
end

connTab:button{
    Name = "Run All Tests",
    Callback = function()
        print("[Vigil][CT] ============================================")
        local base = "https://raw.githubusercontent.com/MyakuDev/Vigil/main/vigil"
        local checks = {
            { "manifest.json",   base .. "/manifest.json" },
            { "main.lua",        base .. "/main.lua" },
            { "loader.lua",      base .. "/loader/loader.lua" },
            { "mercury/main",    base .. "/mercury/main.lua" },
            { "mercury/loader",  base .. "/mercury/loader.lua" },
            { "Fluent SaveMgr",  "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua" },
            { "Mercury library", "https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua" },
        }
        local pass = 0
        for _, c in ipairs(checks) do
            if ping(c[1], c[2]) then pass = pass + 1 end
            task.wait(0.05)
        end
        print(string.format("[Vigil][CT] %d/%d passed", pass, #checks))
        gui:set_status(string.format("connections: %d/%d", pass, #checks))
    end
}

connTab:button{
    Name = "Test Raw CDN",
    Callback = function()
        ping("raw CDN", "https://raw.githubusercontent.com/MyakuDev/Vigil/main/vigil/main.lua")
    end
}

connTab:button{
    Name = "List Local Files",
    Callback = function()
        local ROOT = "Vigil"
        print("[Vigil][CT] ---- local files ----")
        for _, d in ipairs({ ROOT, ROOT .. "/lib", ROOT .. "/ui", ROOT .. "/mercury" }) do
            if isfolder and isfolder(d) then
                local ok, files = pcall(listfiles, d)
                if ok and files then
                    for _, f in ipairs(files) do
                        local size = 0
                        local rok, data = pcall(readfile, f)
                        if rok and data then size = #data end
                        print(string.format("[Vigil][CT]   %-45s %d bytes", f, size))
                    end
                end
            end
        end
    end
}

connTab:button{
    Name = "Wipe Local Cache",
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
        gui:set_status("cache wiped")
    end
}

-- ============================================================
-- Startup
-- ============================================================
gui:set_status("Vigil Mercury UI loaded")
print("[Vigil][Mercury] loaded")
return { gui = gui }