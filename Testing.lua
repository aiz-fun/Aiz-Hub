local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:AddTheme({
    Name = "Neon-Purple-Black",
    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#A855F7"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#000000"), Transparency = 0 },
    }, {
        Rotation = 0,
    }),
})

local Window = WindUI:CreateWindow({
    Title = "Aiz Hub | Universal",
    Icon = "solar:planet-2-broken", 
    Author = "by .0oiwp",
    Folder = "-168",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Neon-Purple-Black",
    Resizable = true,
    HideSearchBar = true, 
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            setclipboard(game.Players.LocalPlayer.DisplayName)
        end,
    },
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- === LOGIKA TANGGAL & TEMAN ===
local secondsInDay = 86400
local creationTime = os.time() - (LocalPlayer.AccountAge * secondsInDay)
local joinDate = os.date("%d %B %Y", creationTime)

local onlineFriends = 0
for _, friend in pairs(LocalPlayer:GetFriendsOnline()) do
    onlineFriends = onlineFriends + 1
end

-- Link untuk mengambil foto Headshot karakter (Avatar)
-- w=420&h=420 adalah resolusi gambar
local avatarImage = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"

-- === MEMBUAT TAB ===
local UserTab = Window:Tab({
    Title = "User Info",
    Icon = "user",
    Locked = false,
})

-- === MEMBUAT SECTION (Dengan Box = true) ===
local InfoSection = UserTab:Section({
    Title = "Profile Information",
    Side = "Left",
    Box = true -- Sesuai permintaan
})

-- === PARAGRAPH DENGAN GAMBAR & TOMBOL ===
InfoSection:Paragraph({
    -- Judul pakai Display Name biar besar
    Title = LocalPlayer.DisplayName,
    
    -- Isi deskripsi digabung menggunakan "\n" (Enter/Baris Baru)
    Desc = "Username: @" .. LocalPlayer.Name .. "\n" ..
           "Status: " .. (onlineFriends > 0 and "Online" or "Solo") .. "\n\n" ..
           "📅 Join: " .. joinDate .. "\n" ..
           "⏳ Umur Akun: " .. LocalPlayer.AccountAge .. " Hari\n" ..
           "👥 Teman Online: " .. onlineFriends,
    
    -- Gambar Avatar
    Image = avatarImage, 
    ImageSize = 70, -- Ukuran gambar avatar (diperbesar agar jelas)
    
    -- Thumbnail kecil di pojok kanan (Opsional, saya kosongkan agar tidak menumpuk)
    Thumbnail = "", 
    ThumbnailSize = 30,
    
    Locked = false,
    
    -- Tombol tambahan di bawah paragraf
    Buttons = {
        {
            Icon = "copy", -- Icon salin
            Title = "Copy Username",
            Callback = function() 
                setclipboard(LocalPlayer.Name)
                WindUI:Notify({
                    Title = "Copied!",
                    Content = "Username telah disalin ke clipboard.",
                    Duration = 2,
                    Icon = "check"
                })
            end,
        },
        {
            Icon = "user-plus", 
            Title = "Rejoin", -- Contoh fitur tombol kedua
            Callback = function()
                game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
            end,
        }
    }
})

WindUI:Notify({
    Title = "Loaded!",
    Content = "Profile Tab berhasil dimuat.",
    Duration = 3, 
    Icon = "check"
})
