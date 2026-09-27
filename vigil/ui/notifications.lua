--!nonstrict
local V = _G.Vigil
local Tabs = V.Window.Tabs
local Notify = V.Notify
Tabs.Notifications:AddToggle("NotifMaster", { Title = "Notifications Enabled", Default = true }):OnChanged(function(v) Notify.enabled = v end)