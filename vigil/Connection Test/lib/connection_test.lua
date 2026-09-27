--!nonstrict
-- Connection Test / lib/connection_test.lua
local M = {}

function M.ping(url)
    local t0 = os.clock()
    local ok, result = pcall(function() return game:HttpGet(url, true) end)
    local dt = math.floor((os.clock() - t0) * 1000)
    return ok and result and #result > 0, dt, result and #result or 0
end

function M.report(urls)
    for label, url in pairs(urls) do
        local ok, dt, size = M.ping(url)
        print(string.format("[Vigil][CT] %-24s %s  %5dms  (%d bytes)",
            label, ok and "OK  " or "FAIL", dt, size))
    end
end

return M