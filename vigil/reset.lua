--!nonstrict
-- Vigil reset: wipes the Vigil/ sandbox folder, then reloads from GitHub.

local ROOT = "Vigil"
local URL = "https://raw.githubusercontent.com/MyakuDev/Vigil/main/vigil/main.lua"

-- recursive wipe of the folder
local function wipe(folder)
    if not (isfolder and listfiles) then return end
    local ok, entries = pcall(listfiles, folder)
    if not ok or not entries then return end
    for _, entry in ipairs(entries) do
        if entry:match("%.lua$") or entry:match("%.json$") then
            if delfile then pcall(delfile, entry) else pcall(writefile, entry, "") end
        elseif isfolder and isfolder(entry) then
            wipe(entry)
            if delfolder then pcall(delfolder, entry) end
        end
    end
end

print("[Vigil] reset: wiping " .. ROOT .. "/")
wipe(ROOT)
if isfolder and isfolder(ROOT) and delfolder then
    pcall(delfolder, ROOT)
end
print("[Vigil] reset: wiped")

print("[Vigil] reset: fetching main.lua from GitHub...")
local ok, src = pcall(function() return game:HttpGet(URL, true) end)
if not ok or not src or src == "" then
    warn("[Vigil] reset: fetch failed")
    return
end

print("[Vigil] reset: running main.lua")
local fn, err = loadstring(src, "@Vigil/main.lua")
if not fn then
    warn("[Vigil] reset: compile failed: " .. tostring(err))
    return
end
fn()