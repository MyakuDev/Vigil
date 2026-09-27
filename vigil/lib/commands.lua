--!nonstrict
local SVC = _G.Vigil.Services
local Notify = _G.Vigil.Notify
local Carry = _G.Vigil.Carry
local M = {}
local Spectating = nil
local Commands = {
    bring = { aliases = {"b","br"} }, goto = { aliases = {"g","go","tp"} },
    void = { aliases = {"v","vc"} }, nz = { aliases = {"n","nullzone"} },
    kill = { aliases = {"k"} }, carry = { aliases = {"c"} },
    killall = { aliases = {"ka"} }, voidall = { aliases = {"va"} },
    nzall = { aliases = {"na"} }, spectate = { aliases = {"spec","s"} },
    unspectate = { aliases = {"us"} }, list = { aliases = {"ls","l"} },
    help = { aliases = {"?","h"} },
}
local Aliases = {}
for cmd, meta in pairs(Commands) do
    Aliases[cmd] = cmd
    for _, a in ipairs(meta.aliases) do Aliases[a] = cmd end
end
local function resolvePlayer(query)
    if not query or query == "" then return nil end
    query = tostring(query):match("^%s*(.-)%s*$"):lower()
    if query == "me" or query == "self" or query == "lp" then return SVC.LP end
    local num = tonumber(query)
    if num then
        for _, plr in ipairs(SVC.Players:GetPlayers()) do
            if plr.UserId == num then return plr end
        end
    end
    for _, plr in ipairs(SVC.Players:GetPlayers()) do
        if tostring(plr.Name):lower() == query or tostring(plr.DisplayName):lower() == query then return plr end
    end
    for _, plr in ipairs(SVC.Players:GetPlayers()) do
        if tostring(plr.Name):lower():find(query, 1, true) or tostring(plr.DisplayName):lower():find(query, 1, true) then return plr end
    end
    return nil
end
function M.execute(input)
    if not input or input == "" then return end
    local rawCmd, rest = tostring(input):match("^(%S+)%s*(.*)$")
    if not rawCmd then return end
    local cmd = Aliases[tostring(rawCmd):lower()]
    if not cmd then Notify.vigil("unknown command: " .. tostring(rawCmd), 3); return end
    local args = {}
    for piece in tostring(rest):gmatch("[^,]+") do
        local trimmed = tostring(piece):match("^%s*(.-)%s*$")
        if trimmed ~= "" then table.insert(args, trimmed) end
    end
    local a1, a2 = args[1], args[2]
    if cmd == "help" then Notify.vigil("bring <p>[, <t>] | goto <p> | void <p> | nz <p> | kill <p> | carry <p> | killall | voidall | nzall", 15); return end
    if cmd == "list" then
        local names = {}
        for _, plr in ipairs(SVC.Players:GetPlayers()) do
            if plr ~= SVC.LP then table.insert(names, tostring(plr.Name)) end
        end
        Notify.vigil(table.concat(names, ", "), 8); return
    end
    if cmd == "killall" then Carry.bulkCarry(Carry.killTarget, "kill everyone"); return end
    if cmd == "voidall" then Carry.bulkCarry(Carry.voidCarry, "void carry everyone"); return end
    if cmd == "nzall" then Carry.bulkCarry(Carry.nullzoneCarry, "nullzone carry everyone"); return end
    if cmd == "unspectate" then Spectating = nil; return end
    local plr = resolvePlayer(a1)
    if not plr then Notify.vigil("player not found: " .. tostring(a1), 3); return end
    if cmd == "carry" then task.spawn(Carry.carryTarget, plr)
    elseif cmd == "void" then task.spawn(Carry.voidCarry, plr, true)
    elseif cmd == "nz" then task.spawn(Carry.nullzoneCarry, plr, true)
    elseif cmd == "kill" then task.spawn(Carry.killTarget, plr, true)
    elseif cmd == "spectate" then Spectating = plr
    elseif cmd == "goto" then
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        local mine = SVC.LP.Character and SVC.LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp and mine then mine.CFrame = hrp.CFrame + Vector3.new(0, 2, 0) end
    elseif cmd == "bring" then
        if a2 then
            local dest = resolvePlayer(a2)
            if dest and dest.Character then
                local dh = dest.Character:FindFirstChild("HumanoidRootPart")
                if dh then task.spawn(Carry.bringTo, plr, dh.CFrame + Vector3.new(0, 2, 0), nil, true) end
            end
        else
            task.spawn(Carry.carryTarget, plr)
        end
    end
end
SVC.Run.Heartbeat:Connect(function()
    if Spectating and Spectating.Character then
        local hrp = Spectating.Character:FindFirstChild("HumanoidRootPart")
        local cam = SVC.WS.CurrentCamera
        if hrp and cam then cam.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 8, 15), hrp.Position) end
    end
end)
M.Commands = Commands
return M