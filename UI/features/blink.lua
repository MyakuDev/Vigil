-- ui feature: blink

Movement:toggle({Name = "Blink",Description = "cframe dash. lower speed = faster.",Default = false,Callback = function(s)
    Blink.Enabled = s
    Blink.State = s and "Enabled" or "Disabled"
end})
Movement:textbox({Name = "Blink Speed",Default = "0.2",Callback = function(v) Blink.Speed = tonumber(v) or Blink.Speed end})
Movement:textbox({Name = "Blink Distance",Default = "15",Callback = function(v) Blink.Distance = tonumber(v) or Blink.Distance end})
Movement:textbox({Name = "Vertical Boost",Default = "5",Callback = function(v) Blink.VerticalBoost = tonumber(v) or Blink.VerticalBoost end})
Movement:textbox({Name = "Still Forward",Default = "-15",Callback = function(v) Blink.StillForward = tonumber(v) or Blink.StillForward end})
Movement:textbox({Name = "Still Up",Default = "15",Callback = function(v) Blink.StillUp = tonumber(v) or Blink.StillUp end})
Movement:textbox({Name = "Still Back",Default = "-5",Callback = function(v) Blink.StillBack = tonumber(v) or Blink.StillBack end})
