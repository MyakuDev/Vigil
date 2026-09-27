--!nonstrict
local SVC = _G.Vigil.Services
local M = { CharFunEvent = nil }
function M.refresh()
    local char = SVC.LP.Character
    if not char then return end
    local cf = char:FindFirstChild("CharacterFun")
    if cf then M.CharFunEvent = cf:FindFirstChild("CharFunEvent") end
end
SVC.LP.CharacterAdded:Connect(function() task.wait(0.5); M.refresh() end)
task.wait(0.5)
M.refresh()
return M