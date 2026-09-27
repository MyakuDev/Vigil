--!nonstrict
local SVC = _G.Vigil.Services
local ROOT = "Vigil"
local M = {}
M.ROOT = ROOT
M.PATHS = {
    whitelist   = ROOT .. "/whitelist.json",
    blacklist   = ROOT .. "/blacklist.json",
    groupCache  = ROOT .. "/groupcache.json",
    friendCache = ROOT .. "/friendcache.json",
    settings    = ROOT .. "/settings.json",
    logs        = ROOT .. "/logs.json",
    remotes     = ROOT .. "/remotes.json",
}
function M.ensureFolder()
    if isfolder and not isfolder(ROOT) then makefolder(ROOT) end
    if isfolder and not isfolder(ROOT .. "/lib") then makefolder(ROOT .. "/lib") end
    if isfolder and not isfolder(ROOT .. "/ui") then makefolder(ROOT .. "/ui") end
end
function M.readJson(path, fallback)
    if not (isfile and readfile and isfile(path)) then return fallback end
    local ok, raw = pcall(readfile, path)
    if not ok or not raw or raw == "" then return fallback end
    local ok2, decoded = pcall(function() return SVC.Http:JSONDecode(raw) end)
    if not ok2 or type(decoded) ~= "table" then return fallback end
    return decoded
end
function M.writeJson(path, tbl)
    if not writefile then return end
    local ok, encoded = pcall(function() return SVC.Http:JSONEncode(tbl) end)
    if ok then pcall(writefile, path, encoded) end
end
M.ensureFolder()
for _, path in pairs(M.PATHS) do
    if isfile and not isfile(path) then M.writeJson(path, {}) end
end
return M