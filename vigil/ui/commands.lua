--!nonstrict
local V = _G.Vigil
local Tabs = V.Window.Tabs
local Commands = V.Commands
Tabs.Commands:AddInput("CmdInput2", { Title = "Command", Default = "", Finished = true }):OnChanged(function(v) if v ~= "" then task.spawn(Commands.execute, v) end end)
Tabs.Commands:AddParagraph({ Title = "Usage", Content = "bring <p>[, <t>] | goto <p> | void <p> | nz <p> | kill <p> | carry <p> | killall | voidall | nzall | help" })
for name, meta in pairs(Commands.Commands) do
    local aliasStr = #meta.aliases > 0 and table.concat(meta.aliases, ", ") or "none"
    Tabs.Commands:AddParagraph({ Title = tostring(name), Content = "aliases: " .. aliasStr })
end