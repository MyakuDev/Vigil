-- ui feature: rejoin

Misc:button({Name = "Rejoin",Description = "rejoin current server.",Callback = function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end})
