--!nonstrict
local M = { enabled = true, prefix = "Vigil" }
function M.notify(title, content, duration)
    if not M.enabled then return end
    local F = _G.Vigil.Window and _G.Vigil.Window.Fluent
    if not F then return end
    local t = tostring(title or M.prefix)
    local c = tostring(content or "")
    local d = tonumber(duration) or 3
    pcall(function() F:Notify({ Title = t, Content = c, Duration = d }) end)
end
function M.vigil(content, duration)
    M.notify(M.prefix, tostring(content or ""), tonumber(duration) or 3)
end
return M