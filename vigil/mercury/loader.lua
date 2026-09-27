--!nonstrict
local URL = "https://raw.githubusercontent.com/MyakuDev/Vigil/main/vigil/mercury/main.lua"
print("[Vigil][Mercury] fetching " .. URL)
local ok, src = pcall(function() return game:HttpGet(URL, true) end)
if not ok or not src or src == "" then
    warn("[Vigil][Mercury] fetch failed")
    return
end
print("[Vigil][Mercury] compiling...")
local fn, err = loadstring(src, "@Vigil/mercury/main.lua")
if not fn then
    warn("[Vigil][Mercury] compile failed: " .. tostring(err))
    return
end
local ok2, runErr = pcall(fn)
if not ok2 then
    warn("[Vigil][Mercury] runtime error: " .. tostring(runErr))
    return
end
print("[Vigil][Mercury] loaded")