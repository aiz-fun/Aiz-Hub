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

-- === LOGIKA HITUNG TANGGAL JOIN ===
local secondsInDay = 86400
local creationTime = os.time() - (LocalPlayer.AccountAge * secondsInDay)
local joinDate = os.date("%d %B %Y", creationTime)

-- === LOGIKA TEMAN ONLINE ===
-- (Roblox membatasi script untuk melihat Total Teman, jadi kita pakai Teman Online)
local onlineFriends = 0
for _, friend in pairs(LocalPlayer:GetFriendsOnline()) do
    onlineFriends = onlineFriends + 1
end

-- === MEMBUAT TAB ===
local UserTab = Window:Tab({
    Title = "User Info",
    Icon = "user",
    Locked = false,
})

-- === MEMBUAT SECTION (Wajib biar rapi di WindUI) ===
local InfoSection = UserTab:Section({
    Title = "Statistik Pemain",
    Side = "Left" 
})

-- === MENAMBAHKAN KONTEN (Gunakan Paragraph) ===

-- Header Sapaan
InfoSection:Paragraph({
    Title = "Selamat Datang!",
    Content = "Halo, " .. LocalPlayer.DisplayName .. ". Berikut data akunmu."
})

-- Display Name
InfoSection:Paragraph({
    Title = "Display Name",
    Content = LocalPlayer.DisplayName
})

-- Username
InfoSection:Paragraph({
    Title = "Username",
    Content = "@" .. LocalPlayer.Name
})

-- Tanggal Join
InfoSection:Paragraph({
    Title = "Tanggal Bergabung",
    Content = joinDate
})

-- Umur Akun
InfoSection:Paragraph({
    Title = "Umur Akun",
    Content = LocalPlayer.AccountAge .. " Hari"
})

-- Teman Online
InfoSection:Paragraph({
    Title = "Teman Sedang Online",
    Content = onlineFriends .. " Orang"
})

-- Notifikasi saat script dimuat
WindUI:Notify({
    Title = "Loaded!",
    Content = "User Info Tab berhasil dibuat.",
    Duration = 3, 
    Icon = "check"
})-- Karena sulit mengambil total teman tanpa HTTP Proxy,
-- kita bisa menampilkan teman yang sedang online saja sebagai alternatif.
local onlineFriends = 0
for _, friend in pairs(LocalPlayer:GetFriendsOnline()) do
    onlineFriends = onlineFriends + 1
end

UserTab:label({
    Title = "Teman Online: " .. onlineFriends .. " Orang",
    Icon = "users"
})
