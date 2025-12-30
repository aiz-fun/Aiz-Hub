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
    Icon = "solar:planet-2-broken", 
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
    Icon = "solar:notification-unread-lines-broken",
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- LOGIKA MENGHITUNG TANGGAL JOIN
local secondsInDay = 86400
local creationTime = os.time() - (LocalPlayer.AccountAge * secondsInDay)
local joinDate = os.date("%d %B %Y", creationTime)

-- --- MULAI SETUP UI ---

-- 1. Buat Tab
local UserTab = Window:Tab({
    Title = "User Info",
    Icon = "user",
    Locked = false,
})

-- 2. PENTING: Buat Section terlebih dahulu!
-- Banyak library seperti WindUI/Fluent membutuhkan Section agar elemen bisa muncul.
local InfoSection = UserTab:Section({
    Title = "Statistik Akun",
    Side = "Left" -- Opsional: Left atau Right (tergantung library)
})

-- 3. Tambahkan Elemen ke dalam SECTION (bukan Tab langsung)

-- Display Name & Header
InfoSection:Paragraph({
    Title = "Halo, " .. LocalPlayer.DisplayName,
    Content = "Berikut adalah data akun kamu saat ini."
})

-- Username
InfoSection:Label({
    Title = "Username: @" .. LocalPlayer.Name,
    Icon = "at-sign"
})

-- Tanggal Join
InfoSection:Label({
    Title = "Join Tanggal: " .. joinDate,
    Icon = "calendar"
})

-- Umur Akun
InfoSection:Label({
    Title = "Umur Akun: " .. LocalPlayer.AccountAge .. " Hari",
    Icon = "clock"
})

-- Teman Online
local onlineFriends = 0
for _, friend in pairs(LocalPlayer:GetFriendsOnline()) do
    onlineFriends = onlineFriends + 1
end

InfoSection:Label({
    Title = "Teman Online: " .. onlineFriends,
    Icon = "users"
})
