-- server hop

_G.ServerHop = {Enabled = false}
local hopRunning = false
local function fetchServers()
    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",game.PlaceId)
    local ok, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
    if not ok or not result or not result.data then return {} end
    return result.data
end
local function hop()
    local servers = fetchServers()
    local candidates = {}
    for _, v in ipairs(servers) do
        if v.id ~= game.JobId and tonumber(v.playing) < tonumber(v.maxPlayers) then
            table.insert(candidates, v.id)
        end
    end
    if #candidates == 0 then return false end
    local target = candidates[math.random(1, #candidates)]
    TeleportService:TeleportToPlaceInstance(game.PlaceId, target, LocalPlayer)
    return true
end

Misc:toggle({Name = "Server Hop",Description = "hops to a random server on a loop.",Default = false,Callback = function(state) ServerHop.Enabled = state end})
Misc:button({Name = "Hop Once",Description = "hop to a random server immediately.",Callback = function() hop() end})

if not hopRunning then
    hopRunning = true
    task.spawn(function()
        while task.wait(2) do
            if not ServerHop.Enabled then continue end
            hop()
        end
    end)
<<<<<<< HEAD
end
=======
end
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
