--!nonstrict
local Http = game:GetService("HttpService")

local M = {
    user   = "MyakuDev",
    repo   = "Vigil",
    branch = "main",
    root   = "Vigil",
    disabled = false,
}

M.remoteBase = string.format(
    "https://raw.githubusercontent.com/%s/%s/%s/vigil",
    M.user, M.repo, M.branch
)
M.manifestURL = M.remoteBase .. "/manifest.json"

local function readLocal(path)
    if not (isfile and readfile and isfile(path)) then return nil end
    local ok, data = pcall(readfile, path)
    if ok and data then return data end
    return nil
end

local function writeLocal(path, data)
    if not writefile then return false end
    return pcall(writefile, path, data)
end

local function fetchRemote(url)
    local ok, resp = pcall(function() return game:HttpGet(url, true) end)
    if not ok or not resp or resp == "" then return nil end
    if resp:sub(1, 15) == "<!DOCTYPE html" then return nil end
    return resp
end

local function loadJson(str)
    if not str or str == "" then return nil end
    local ok, decoded = pcall(function() return Http:JSONDecode(str) end)
    if not ok or type(decoded) ~= "table" then return nil end
    return decoded
end

function M.ensureFolders()
    if isfolder and not isfolder(M.root) then makefolder(M.root) end
    if isfolder and not isfolder(M.root .. "/lib") then makefolder(M.root .. "/lib") end
    if isfolder and not isfolder(M.root .. "/ui") then makefolder(M.root .. "/ui") end
end

function M.run()
    if M.disabled then return false, "disabled" end
    M.ensureFolders()
    local remoteManifest = loadJson(fetchRemote(M.manifestURL))
    if not remoteManifest then return false, "no remote manifest" end
    local remoteFiles = remoteManifest.files or {}
    local downloaded, failed = 0, 0
    for path, _ in pairs(remoteFiles) do
        local url = M.remoteBase .. "/" .. path
        local content = fetchRemote(url)
        if content and #content > 0 then
            if writeLocal(M.root .. "/" .. path, content) then
                downloaded = downloaded + 1
            else
                failed = failed + 1
            end
        else
            failed = failed + 1
        end
        task.wait(0.05)
    end
    writeLocal(M.root .. "/manifest.json", Http:JSONEncode(remoteManifest))
    return true, string.format("updated %d, failed %d", downloaded, failed)
end

return M