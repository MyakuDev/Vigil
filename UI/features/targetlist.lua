-- ui feature: target list

local function refreshPlayerList()
    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then table.insert(names, plr.Name) end
    end
    return names
end

local dd = Troll:dropdown({Name = "Target Player",Description = "player to carry.",StartingText = "Select...",Items = refreshPlayerList(),Callback = function(v)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Name == v then TrollTarget.Player = plr break end
    end
end})

Players.PlayerAdded:Connect(function()
    if dd and dd.Refresh then dd:Refresh(refreshPlayerList()) end
end)

Players.PlayerRemoving:Connect(function(plr)
    if plr == TrollTarget.Player then TrollTarget.Player = nil end
    if dd and dd.Refresh then dd:Refresh(refreshPlayerList()) end
end)
