--!nonstrict
local Storage = _G.Vigil.Storage
local M = {}
M.WL, M.BL = {}, {}
M.WL_byId, M.BL_byId = {}, {}
local function rebuildIndex(list, index)
    for k in pairs(index) do index[k] = nil end
    for _, entry in pairs(list) do
        local uid = tonumber(entry.userId)
        if uid then index[uid] = entry end
    end
end
local function loadList(path, list, index)
    for key, entry in pairs(Storage.readJson(path, {})) do
        if type(entry) == "table" then
            local rawKey = tostring(key):lower()
            local keyStr = rawKey
            if tonumber(rawKey) then keyStr = tostring(entry.name or ("id:" .. rawKey)):lower() end
            list[keyStr] = {
                name = tostring(entry.name or keyStr),
                displayName = tostring(entry.displayName or entry.name or keyStr),
                userId = tonumber(entry.userId) or tonumber(key),
                group = entry.group, role = entry.role, relationship = entry.relationship,
            }
        end
    end
    rebuildIndex(list, index)
end
function M.saveWL()
    Storage.writeJson(Storage.PATHS.whitelist, M.WL)
    rebuildIndex(M.WL, M.WL_byId)
end
function M.saveBL()
    Storage.writeJson(Storage.PATHS.blacklist, M.BL)
    rebuildIndex(M.BL, M.BL_byId)
end
function M.isWL(plr)
    if not plr then return false end
    return M.WL[tostring(plr.Name):lower()] ~= nil or M.WL_byId[plr.UserId] ~= nil
end
function M.isBL(plr)
    if not plr then return false end
    return M.BL[tostring(plr.Name):lower()] ~= nil or M.BL_byId[plr.UserId] ~= nil
end
loadList(Storage.PATHS.whitelist, M.WL, M.WL_byId)
loadList(Storage.PATHS.blacklist, M.BL, M.BL_byId)
return M