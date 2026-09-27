--!nonstrict
-- Connection Test / ui/diagnostics.lua
-- Thin wrapper that loads the Connection Test module.
local V = _G.Vigil
local M = nil
pcall(function()
    M = loadstring(readfile("Vigil/Connection Test/init.lua") or "")()
end)
if M and M.runAll then M.runAll() end
return M