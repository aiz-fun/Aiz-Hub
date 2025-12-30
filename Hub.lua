local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
WindUI:AddTheme({
    Name = "Neon-Purple-Black",

    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#A855F7"), Transparency = 0 }, -- neon purple
        ["100"] = { Color = Color3.fromHex("#000000"), Transparency = 0 }, -- pure black
    }, {
        Rotation = 0,
    }),
})
local Window = WindUI:CreateWindow({
    Title = "Aiz Hub | Universal",
    Icon = "planet-2-broken", 
    Author = "by .0oiwp dont forget to follow",
    Folder = "-168",
    
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Neon-Purple-Black",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
   
    User = {
    Enabled = true,
    Anonymous = false,
    Callback = function()
        setclipboard(game.Players.LocalPlayer.DisplayName)
    end,
    },
    
})
WindUI:Notify({
    Title = "Welcome to the [Aiz Hub | Universal]",
    Content = "This Script Is Beta, So If You Have A Problem With This Script You Can Repots That In Discord, Have Fun With This Scrip :)",
    Duration = 3, 
    Icon = "notification-unread-lines-broken",
})
