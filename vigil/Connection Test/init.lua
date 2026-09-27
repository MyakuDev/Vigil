-- Connection Test/init.lua
-- Entry point for the connection test module.
local ConnectionTest = {}

ConnectionTest.Version = "1.0.0"
ConnectionTest.Name    = "Vigil Connection Test"

function ConnectionTest.start()
    local V = _G.Vigil
    if not V then warn("[Vigil][CT] _G.Vigil not set"); return end
    if not V.Window or not V.Window.Window then
        warn("[Vigil][CT] V.Window not ready"); return
    end

    local Tab = V.Window.Window:AddTab("Connection Test")
    local G   = Tab:AddLeftGroupbox("GitHub Connection")

    G:AddButton({
        Title = "Run Connection Test",
        Description = "Prints results to the console (F9)",
        Callback = function()
            ConnectionTest.run(V)
        end
    })

    G:AddButton({
        Title = "List Local Files",
        Description = "Prints every file under Vigil/ with size",
        Callback = function()
            ConnectionTest.listLocal()
        end
    })

    print("[Vigil][CT] connection test tab created")
end

function ConnectionTest.run(V)
    local ROOT = "Vigil"
    local base = "https://raw.githubusercontent.com/MyakuDev/Vigil/main/vigil"

    print("[Vigil][CT] ======================================")
    print("[Vigil][CT] Running connection test...")
    print("[Vigil][CT] ======================================")

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
        local t0 = os.clock()
        local ok, res = pcall(function() return game:HttpGet(c[2], true) end)
        local dt = math.floor((os.clock() - t0) * 1000)
        if ok and res and #res > 0 then
            print(string.format("[Vigil][CT] %-20s OK   %4dms  (%d bytes)", c[1], dt, #res))
            pass = pass + 1
        else
            print(string.format("[Vigil][CT] %-20s FAIL %4dms", c[1], dt))
        end
        task.wait(0.05)
    end

    print("[Vigil][CT] --------------------------------------")
    print(string.format("[Vigil][CT] executor : %s", identifyexecutor and identifyexecutor() or "unknown"))
    print(string.format("[Vigil][CT] httpget  : %s", type(game.HttpGet)))
    print(string.format("[Vigil][CT] isfile   : %s", tostring(isfile ~= nil)))
    print(string.format("[Vigil][CT] writefile: %s", tostring(writefile ~= nil)))
    print(string.format("[Vigil][CT] SUMMARY  : %d/%d passed", pass, total))
    print("[Vigil][CT] ======================================")

    if V.Notify and V.Notify.vigil then
        V.Notify.vigil(string.format("Connection: %d/%d", pass, total), 3)
    end
end

function ConnectionTest.listLocal()
    local ROOT = "Vigil"
    print("[Vigil][CT] ---- local tree ----")
    for _, d in ipairs({ ROOT, ROOT .. "/lib", ROOT .. "/ui" }) do
        if isfolder and isfolder(d) then
            local ok, files = pcall(listfiles, d)
            if ok and files then
                for _, f in ipairs(files) do
                    local size = 0
                    local rok, data = pcall(readfile, f)
                    if rok and data then size = #data end
                    print(string.format("[Vigil][CT]   %-40s %d bytes", f, size))
                end
            end
        end
    end
    print("[Vigil][CT] ----------------------")
end

return ConnectionTest