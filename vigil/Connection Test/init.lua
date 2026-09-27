--!nonstrict
-- Vigil Connection Test module
local V = _G.Vigil

local M = {}

function M.testUrl(label, url)
    local t0 = os.clock()
    local ok, result = pcall(function() return game:HttpGet(url, true) end)
    local dt = math.floor((os.clock() - t0) * 1000)
    if ok and result and #result > 0 then
        print(string.format("[Vigil][CT] %-24s OK   %5dms  (%d bytes)", label, dt, #result))
        return true
    end
    print(string.format("[Vigil][CT] %-24s FAIL %5dms", label, dt))
    return false
end

function M.runAll()
    print("[Vigil][CT] ========================================")
    local base = "https://raw.githubusercontent.com/MyakuDev/Vigil/main/vigil"
    local checks = {
        { "manifest.json",   base .. "/manifest.json" },
        { "main.lua",        base .. "/main.lua" },
        { "loader.lua",      base .. "/loader/loader.lua" },
        { "diagnostics.lua", base .. "/ui/diagnostics.lua" },
        { "mercury main",    base .. "/mercury/main.lua" },
        { "mercury loader",  base .. "/mercury/loader.lua" },
        { "Fluent SaveMgr",  "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua" },
    }
    local pass, total = 0, 0
    for _, c in ipairs(checks) do
        total = total + 1
        if M.testUrl(c[1], c[2]) then pass = pass + 1 end
        task.wait(0.05)
    end
    print(string.format("[Vigil][CT] SUMMARY: %d/%d passed", pass, total))
    if V and V.Notify and V.Notify.vigil then
        V.Notify.vigil(string.format("GitHub: %d/%d", pass, total), 3)
    end
end

function M.listLocal()
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
    print("[Vigil][CT] ----------------------")
end

function M.wipeCache()
    local ROOT = "Vigil"
    for _, d in ipairs({ ROOT .. "/ui", ROOT .. "/lib", ROOT .. "/mercury", ROOT }) do
        if isfolder and isfolder(d) then
            local ok, files = pcall(listfiles, d)
            if ok and files then for _, f in ipairs(files) do pcall(delfile, f) end end
            pcall(delfolder, d)
        end
    end
    print("[Vigil][CT] cache wiped")
end

-- If a Fluent window is available, add a tab
if V and V.Window and V.Window.Window then
    local Tab = V.Window.Window:AddTab({ Title = "Connection", Icon = "wifi" })
    V.Window.Tabs.Connection = Tab

    Tab:AddButton({ Title = "Run All Tests", Description = "Prints to console (F9)", Callback = function() M.runAll() end })
    Tab:AddButton({ Title = "List Local Files", Callback = function() M.listLocal() end })
    Tab:AddButton({ Title = "Wipe Vigil/ Cache", Callback = function() M.wipeCache() end })
    print("[Vigil][CT] Connection tab created")
end

return M