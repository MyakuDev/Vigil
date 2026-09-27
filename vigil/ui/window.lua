--!nonstrict
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Vigil",
    SubTitle = "by Vigil",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightAlt,
})
local Tabs = {
    Combat        = Window:AddTab({ Title = "Combat", Icon = "sword" }),
    Movement      = Window:AddTab({ Title = "Movement", Icon = "move" }),
    Visuals       = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    PlayerTab     = Window:AddTab({ Title = "Player", Icon = "user" }),
    Misc          = Window:AddTab({ Title = "Misc", Icon = "wrench" }),
    Players       = Window:AddTab({ Title = "Players", Icon = "users" }),
    Abuse         = Window:AddTab({ Title = "Abuse", Icon = "alert-triangle" }),
    Commands      = Window:AddTab({ Title = "Commands", Icon = "terminal" }),
    Keybinds      = Window:AddTab({ Title = "Keybinds", Icon = "keyboard" }),
    Performance   = Window:AddTab({ Title = "Performance", Icon = "zap" }),
    Notifications = Window:AddTab({ Title = "Notifications", Icon = "bell" }),
    Settings      = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}
return { Fluent = Fluent, Window = Window, Tabs = Tabs, Options = Fluent.Options }