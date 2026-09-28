-- ui feature: semi short

Abuse:toggle({Name = "Semi Short",Description = "hipheight -1 + cam cframe.",Default = false,Callback = function(s)
    SemiShort.Enabled = s
    SemiShort.State = s and "Enabled" or "Disabled"
    if not s then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.HipHeight = 2 end
    end
end})
<<<<<<< HEAD
Abuse:textbox({Name = "Semi Short HipHeight",Default = "-1",Callback = function(v) SemiShort.HipHeight = tonumber(v) or SemiShort.HipHeight end})
=======
Abuse:textbox({Name = "Semi Short HipHeight",Default = "-1",Callback = function(v) SemiShort.HipHeight = tonumber(v) or SemiShort.HipHeight end})
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
