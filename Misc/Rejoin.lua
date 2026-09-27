-- rejoin

Misc:button({Name = "Rejoin",Description = "rejoins the current server.",Callback = function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LocalPlayer)
end})
