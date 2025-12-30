local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ====================================================
-- 1. KONFIGURASI DATABASE (JSON)
-- ====================================================
-- Masukkan Link RAW JSON kamu di sini
local DatabaseURL = "https://example.com/database.json" 

-- Fungsi Cek Premium
local UserStatus = "Free Script 📂" -- Default
local UserIcon = "solar:box-bold"
local IsPremium = false

-- Simulasi Cek Data (Menggunakan pcall agar script tidak error jika link mati)
local success, response = pcall(function()
    -- Jika kamu belum punya link, bagian ini akan error dan masuk ke catch (Free)
    -- Ganti dengan game:HttpGet(DatabaseURL) jika sudah ada link asli
    
    -- CONTOH DATA DUMMY (Hapus baris ini jika sudah pakai URL asli):
    local dummyDB = {12345, LocalPlayer.UserId, 87878} -- Masukkan ID kamu di sini untuk test
    return HttpService:JSONEncode(dummyDB)
end)

if success then
    local data = HttpService:JSONDecode(response)
    -- Cek apakah UserId kita ada di dalam table data
    if table.find(data, LocalPlayer.UserId) then
        UserStatus = "Premium User 💎"
        UserIcon = "solar:crown-star-bold"
        IsPremium = true
    end
else
    -- Fallback jika link error/belum diisi
    -- (Opsional: Kamu bisa buat whitelist manual disini)
    if LocalPlayer.UserId == 8080406235 then -- Ganti ID mu
        UserStatus = "Developer 🛠️"
        UserIcon = "solar:code-bold"
        IsPremium = true
    end
end

-- ====================================================
-- 2. SETUP UI
-- ====================================================

WindUI:AddTheme({
    Name = "Neon-Purple-Black",
    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#A855F7"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#000000"), Transparency = 0 },
    }, { Rotation = 0 }),
})

local Window = WindUI:CreateWindow({
    Title = "Aiz Hub | Universal",
    Icon = "solar:planet-2-bold-duotone", 
    Author = "by .0oiwp",
    Folder = "-168",
    Size = UDim2.fromOffset(800, 580), -- Lebar ditambah lagi
    Transparent = true,
    Theme = "Neon-Purple-Black",
    Resizable = true,
    HideSearchBar = true, 
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function() setclipboard(LocalPlayer.DisplayName) end,
    },
})

-- === LOGIKA STATISTIK ===
local secondsInDay = 86400
local creationTime = os.time() - (LocalPlayer.AccountAge * secondsInDay)
local joinDate = os.date("%d %B %Y", creationTime)

local onlineFriends = 0
for _, friend in pairs(LocalPlayer:GetFriendsOnline()) do
    onlineFriends = onlineFriends + 1
end

local avatarImage = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"

-- === FUNGSI TELEPORT ===
local function TeleportToPlayer(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        WindUI:Notify({
            Title = "Teleport Success",
            Content = "Teleported to " .. targetPlayer.DisplayName,
            Duration = 2,
            Icon = "solar:map-point-bold"
        })
    else
        WindUI:Notify({
            Title = "Failed",
            Content = "Target not found or not spawned.",
            Duration = 2,
            Icon = "solar:danger-circle-bold"
        })
    end
end

-- ====================================================
-- 3. TAB & SECTION
-- ====================================================

local UserTab = Window:Tab({ Title = "User Profile", Icon = "solar:user-circle-bold", Locked = false })

-- [KIRI] IDENTITY & LICENSE
local MainSection = UserTab:Section({ Title = "My Identity", Side = "Left", Box = true, Icon = "solar:card-recieved-bold" })

MainSection:Paragraph({
    Title = LocalPlayer.DisplayName,
    -- Menampilkan STATUS LISENSI DISINI
    Desc = "License: " .. UserStatus .. "\nStatus: " .. (onlineFriends > 0 and "Online" or "Solo"),
    Image = avatarImage,
    ImageSize = 65,
    Buttons = {
        {
            Title = "Copy Display",
            Icon = "solar:tag-bold",
            Callback = function() setclipboard(LocalPlayer.DisplayName) end
        },
        {
            Title = "Copy User",
            Icon = "solar:copy-bold",
            Callback = function() setclipboard(LocalPlayer.Name) end
        }
    }
})

-- [KIRI] STATS
local DetailSection = UserTab:Section({ Title = "Account Stats", Side = "Left", Box = true, Icon = "solar:chart-square-bold" })

-- Tambahan visualisasi status lisensi di stats
DetailSection:Paragraph({
    Title = "Script License",
    Desc = UserStatus,
    Icon = UserIcon -- Icon berubah sesuai status (Crown/Box)
})

DetailSection:Paragraph({ Title = "Username", Desc = "@" .. LocalPlayer.Name, Icon = "solar:user-id-bold" })
DetailSection:Paragraph({ Title = "Join Date", Desc = joinDate, Icon = "solar:calendar-date-bold" })
DetailSection:Paragraph({ Title = "Account Age", Desc = LocalPlayer.AccountAge .. " Days", Icon = "solar:history-bold" })
DetailSection:Paragraph({ Title = "Friends", Desc = onlineFriends .. " Online", Icon = "solar:users-group-rounded-bold" })


-- ====================================================
-- 4. SERVER PLAYERS (AUTO UPDATE)
-- ====================================================

local PlayerListSection = UserTab:Section({ Title = "Server Players (Realtime)", Side = "Right", Box = true, Icon = "solar:global-bold" })

-- Fungsi membuat elemen UI untuk player
local function CreatePlayerUI(player)
    local thumb = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
    
    PlayerListSection:Paragraph({
        Title = player.DisplayName,
        Desc = "@" .. player.Name,
        Image = thumb,
        ImageSize = 45,
        Buttons = {
            {
                Title = "Goto",
                Icon = "solar:map-point-bold",
                Callback = function() TeleportToPlayer(player) end
            },
            {
                Title = "Copy Name",
                Icon = "solar:copy-linear",
                Callback = function() 
                    setclipboard(player.Name)
                    WindUI:Notify({Title="Copied", Content="Copied @"..player.Name, Duration=1})
                end
            }
        }
    })
end

-- 1. Load player yang sudah ada
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreatePlayerUI(player)
    end
end

-- 2. AUTO UPDATE: Deteksi Player Baru Masuk (Join)
Players.PlayerAdded:Connect(function(player)
    -- Tunggu sebentar agar data player load
    task.wait(1) 
    WindUI:Notify({
        Title = "New Player",
        Content = player.DisplayName .. " joined the server!",
        Duration = 3,
        Icon = "solar:user-plus-bold"
    })
    CreatePlayerUI(player)
end)

-- 3. Deteksi Player Keluar (Info Saja)
Players.PlayerRemoving:Connect(function(player)
    WindUI:Notify({
        Title = "Player Left",
        Content = player.DisplayName .. " left the server.",
        Duration = 3,
        Icon = "solar:user-minus-linear"
    })
    -- Catatan: WindUI tidak support hapus paragraf spesifik secara dinamis
    -- Jadi kita hanya beri notif. List akan reset jika script di re-run.
end)

WindUI:Notify({
    Title = "System Ready",
    Content = "User Data & License Loaded: " .. (IsPremium and "PREMIUM" or "FREE"),
    Duration = 4, 
    Icon = "solar:shield-check-bold"
}) CreatePlayerUI(player)
    end
end

-- 2. AUTO UPDATE: Deteksi Player Baru Masuk (Join)
Players.PlayerAdded:Connect(function(player)
    -- Tunggu sebentar agar data player load
    task.wait(1) 
    WindUI:Notify({
        Title = "New Player",
        Content = player.DisplayName .. " joined the server!",
        Duration = 3,
        Icon = "solar:user-plus-bold"
    })
    CreatePlayerUI(player)
end)

-- 3. Deteksi Player Keluar (Info Saja)
Players.PlayerRemoving:Connect(function(player)
    WindUI:Notify({
        Title = "Player Left",
        Content = player.DisplayName .. " left the server.",
        Duration = 3,
        Icon = "solar:user-minus-linear"
    })
    -- Catatan: WindUI tidak support hapus paragraf spesifik secara dinamis
    -- Jadi kita hanya beri notif. List akan reset jika script di re-run.
end)

WindUI:Notify({
    Title = "System Ready",
    Content = "User Data & License Loaded: " .. (IsPremium and "PREMIUM" or "FREE"),
    Duration = 4, 
    Icon = "solar:shield-check-bold"
})
