-- target list

_G.TrollTarget = {Player = nil}

local function refreshPlayerList()
    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(names, plr.Name)
        end
    end
    return names
end

local trollDropdown = Troll:dropdown({
    Name = "Target Player",
    Description = "select a player to carry.",
    StartingText = "Select...",
    Items = refreshPlayerList(),
    Callback = function(v)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Name == v then
                TrollTarget.Player = plr
                break
            end
        end
    end,
})

Players.PlayerAdded:Connect(function(plr)
    if trollDropdown and trollDropdown.Refresh then trollDropdown:Refresh(refreshPlayerList()) end
end)

Players.PlayerRemoving:Connect(function(plr)
    if plr == TrollTarget.Player then TrollTarget.Player = nil end
    if trollDropdown and trollDropdown.Refresh then trollDropdown:Refresh(refreshPlayerList()) end
end)

_G.getCharFunEvent = function()
    local char = LocalPlayer.Character
    if not char then return nil end
    local charFun = char:FindFirstChild("CharacterFun")
    if not charFun then return nil end
    return charFun:FindFirstChild("CharFunEvent")
end

_G.getRagdollEvent = function()
    local char = LocalPlayer.Character
    if not char then return nil end
    local ragdoll = char:FindFirstChild("Ragdoll")
    if not ragdoll then return nil end
    return ragdoll:FindFirstChild("RemoteEvent")
end
