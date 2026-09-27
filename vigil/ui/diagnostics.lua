--!nonstrict
local V = _G.Vigil
local Fluent = V.Window.Fluent

local DiagTab = V.Window.Window:AddTab({ Title = "Diagnostics", Icon = "activity" })
V.Window.Tabs.Diagnostics = DiagTab

local function testUrl(label, url)
    local t0 = os.clock()
    local ok, result = pcall(function() return game:HttpGet(url, true) end)
    local dt = math.floor((os.clock() - t0) * 1000)
    if ok and result and #result > 0 then
        print(string.format("[Vigil][Diag] %-22s OK   %4dms  (%d bytes)", label, dt, #result))
        return true
    end
    print(string.format("[Vigil][Diag] %-22s FAIL %4dms", label, dt))
    return false
end

local function runAll()
    print("[Vigil][Diag] ========================================")
    local base = "https://raw.githubusercontent.com/MyakuDev/Vigil/main/vigil"
    local checks = {
        { "manifest.json",   base .. "/manifest.json" },
        { "main.lua",        base .. "/main.lua" },
        { "loader.lua",      base .. "/loader/loader.lua" },
        { "diagnostics.lua", base .. "/ui/diagnostics.lua" },
        { "Fluent SaveMgr",  "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua" },
    }
    local pass, total = 0, 0
    for _, c in ipairs(checks) do
        total = total + 1
        if testUrl(c[1], c[2]) then pass = pass + 1 end
        task.wait(0.05)
    end
    print(string.format("[Vigil][Diag] SUMMARY: %d/%d passed", pass, total))
    if V.Notify and V.Notify.vigil then
        V.Notify.vigil(string.format("GitHub: %d/%d", pass, total), 3)
    end
end

local function listLocal()
    local ROOT = "Vigil"
    for _, d in ipairs({ ROOT, ROOT .. "/lib", ROOT .. "/ui" }) do
        if isfolder and isfolder(d) then
            local ok, files = pcall(listfiles, d)
            if ok and files then
                for _, f in ipairs(files) do
                    local size = 0
                    local rok, data = pcall(readfile, f)
                    if rok and data then size = #data end
                    print(string.format("[Vigil][Diag]   %-40s %d bytes", f, size))
                end
            end
        end
    end
end

local function wipeCache()
    local ROOT = "Vigil"
    for _, d in ipairs({ ROOT .. "/ui", ROOT .. "/lib", ROOT }) do
        if isfolder and isfolder(d) then
            local ok, files = pcall(listfiles, d)
            if ok and files then for _, f in ipairs(files) do pcall(delfile, f) end end
            pcall(delfolder, d)
        end
    end
    if V.Notify and V.Notify.vigil then V.Notify.vigil("Local cache wiped.", 3) end
end

DiagTab:AddButton({ Title = "Run All Connection Tests", Description = "Prints to console (F9)", Callback = runAll })
DiagTab:AddButton({ Title = "Test Manifest Only", Callback = function()
    testUrl("manifest.json", "https://raw.githubusercontent.com/MyakuDev/Vigil/main/vigil/manifest.json")
end })
DiagTab:AddButton({ Title = "Test Fluent Dependency", Callback = function()
    testUrl("Fluent SaveManager", "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua")
end })
DiagTab:AddButton({ Title = "List Local Vigil Files", Callback = listLocal })
DiagTab:AddButton({ Title = "Delete Local Cache", Callback = wipeCache })

print("[Vigil] diagnostics loaded")