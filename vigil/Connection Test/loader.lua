-- Connection Test/loader.lua
-- Loads the Connection Test module.
local CT = loadstring(readfile("Vigil/ui/connection_test/init.lua") or "")
if CT then
    CT.start()
end