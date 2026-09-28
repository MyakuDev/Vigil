-- themes init

_G.VigilThemes = _G.VigilThemes or {}

_G.VigilThemes.Serika = {
    Name = "Serika",
    Accent = Color3.fromRGB(255, 175, 50),
    Background = Color3.fromRGB(30, 30, 30),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 180),
}

_G.VigilThemes.Dark = {
    Name = "Dark",
    Accent = Color3.fromRGB(130, 130, 130),
    Background = Color3.fromRGB(20, 20, 20),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(150, 150, 150),
}

_G.VigilThemes.Light = {
    Name = "Light",
    Accent = Color3.fromRGB(80, 120, 200),
    Background = Color3.fromRGB(240, 240, 240),
    Text = Color3.fromRGB(30, 30, 30),
    SubText = Color3.fromRGB(100, 100, 100),
}

_G.VigilThemes.Blood = {
    Name = "Blood",
    Accent = Color3.fromRGB(200, 30, 30),
    Background = Color3.fromRGB(25, 10, 10),
    Text = Color3.fromRGB(240, 200, 200),
    SubText = Color3.fromRGB(180, 120, 120),
}

_G.VigilThemes.Ocean = {
    Name = "Ocean",
    Accent = Color3.fromRGB(50, 150, 220),
    Background = Color3.fromRGB(15, 25, 35),
    Text = Color3.fromRGB(220, 240, 255),
    SubText = Color3.fromRGB(140, 170, 200),
}

_G.ActiveTheme = "Serika"

_G.SetTheme = function(name)
    if VigilThemes[name] then
        ActiveTheme = name
        if _G.NotifySuccess then NotifySuccess("theme: " .. name) end
    end
end
