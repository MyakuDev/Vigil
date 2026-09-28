-- admins

_G.AdminList = {
    {name = "NullSights", userId = 240800665, role = "Lead Developer"},
    {name = "F2Gift", userId = nil, role = "Tester"},
    {name = "77sapato", userId = nil, role = "Administrator"},
    {name = "vel", userId = nil, role = "Contributor"},
    {name = "ofa", userId = 4696436, role = "Administrator"},
    {name = "CyanStigmata", userId = nil, role = "Administrator"},
    {name = "Hit0master101", userId = 1975450441, role = "Administrator"},
    {name = "chr2stina", userId = nil, role = "Administrator"},
    {name = "JakeSights", userId = 386219771, role = "Administrator"},
    {name = "bog", userId = 386219771, role = "Administrator"},
    {name = "V1CTOR", userId = 7247383691, role = "Administrator"},
    {name = "pag5ni", userId = 8424074921, role = "Administrator"},
    {name = "Helicixity", userId = 89318267, role = "Administrator"},
    {name = "0fgail", userId = 2980319695, role = "Administrator"},
    {name = "xAltrive", userId = 203556764, role = "Administrator"},
    {name = "AbsoluteScary", userId = 143851429, role = "Administrator"},
    {name = "SCHADEVREUGDE", userId = 175157829, role = "Community Manager"},
    {name = "DewbyDoppler", userId = 85691477, role = "Developer"},
    {name = "AydenSebastian", userId = 85691477, role = "Developer"},
}

_G.AdminSettings = {
    Enabled     = true,       -- on by default
    KickMethod  = "kick",     -- "kick" or "shutdown"
    NotifyOnDetect = true,
}

_G.IsAdmin = function(userId, name)
    for _, admin in ipairs(AdminList) do
        if admin.userId and admin.userId == userId then return admin end
        if admin.name and name and admin.name:lower() == name:lower() then return admin end
    end
    return nil
end

_G.RunAdminDetection = function()
    if not AdminSettings.Enabled then return end

    local function check(plr)
        if plr == LocalPlayer then return end
        local admin = IsAdmin(plr.UserId, plr.Name)
        if admin then
            if AdminSettings.NotifyOnDetect and _G.Notify then
                Notify("ADMIN DETECTED", plr.Name .. " (" .. admin.role .. ")", 5)
            end
            if AdminSettings.KickMethod == "shutdown" then
                game:Shutdown()
            else
                LocalPlayer:Kick("Admin detected: " .. plr.Name)
            end
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        check(plr)
    end
    Players.PlayerAdded:Connect(check)
end

RunAdminDetection()
