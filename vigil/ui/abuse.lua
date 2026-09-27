--!nonstrict
local V = _G.Vigil
local Tabs = V.Window.Tabs
local SVC = V.Services
local Notify = V.Notify
local Carry = V.Carry
local Commands = V.Commands
local Dummy = V.Dummy
Tabs.Abuse:AddInput("CmdInput", { Title = "Command", Default = "", Finished = true }):OnChanged(function(v) if v ~= "" then task.spawn(Commands.execute, v) end end)
Tabs.Abuse:AddButton({ Title = "Void Carry Everyone", Callback = function() Carry.bulkCarry(Carry.voidCarry, "void carry everyone") end })
Tabs.Abuse:AddButton({ Title = "Nullzone Carry Everyone", Callback = function() Carry.bulkCarry(Carry.nullzoneCarry, "nullzone carry everyone") end })
Tabs.Abuse:AddButton({ Title = "Kill Everyone", Callback = function() Carry.bulkCarry(Carry.killTarget, "kill everyone") end })
Tabs.Abuse:AddButton({ Title = "Help", Callback = function() Commands.execute("help") end })
Tabs.Abuse:AddButton({ Title = "Void Carry Dummy (Test)", Callback = function()
    local folder = SVC.WS:FindFirstChild("PlayersCharacters")
    if not folder then Notify.vigil("no PlayersCharacters folder", 3); return end
    local dummy = Dummy.findNearest()
    if not dummy then Notify.vigil("no Dummy found", 3); return end
    task.spawn(function() pcall(Dummy.bringTo, dummy, CFrame.new(Carry.VOID_POS), "void") end)
end })