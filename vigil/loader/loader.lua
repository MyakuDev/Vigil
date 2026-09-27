--!nonstrict
local URL = "https://raw.githubusercontent.com/MyakuDev/Vigil/main/vigil/main.lua"
print("[Vigil] loader: fetching " .. URL)
local ok, src = pcall(function() return game:HttpGet(URL, true) end)
if not ok or not src or src == "" then warn("[Vigil] loader: fetch failed"); return end
print("[Vigil] loader: executing main.lua")
local fn, err = loadstring(src, "@Vigil/main.lua")
if not fn then warn("[Vigil] loader: compile failed: " .. tostring(err)); return end
local ok2, runErr = pcall(fn)
if not ok2 then warn("[Vigil] loader: runtime error: " .. tostring(runErr)) end