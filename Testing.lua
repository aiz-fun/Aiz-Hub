-- ====================================================
-- KONFIGURASI DATABASE
-- ====================================================
local DatabaseURL = "https://raw.githubusercontent.com/aiz-fun/Aiz-Hub/refs/heads/main/database.json"

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ====================================================
-- 1. SISTEM CEK PREMIUM (VIA DATABASE)
-- ====================================================

local IsPremium = false
local UserStatus = "Free User"
local ThemeColor = "#A855F7" -- Default: Ungu (Neon Purple)
local StatusIcon = "solar:box-bold"

-- Mengambil Data dari Link GitHub
local success, response = pcall(function()
    return game:HttpGet(DatabaseURL)
end)

if success then
    local decodeSuccess, data = pcall(function()
        return HttpService:JSONDecode(response)
    end)

    if decodeSuccess and type(data) == "table" then
        -- Cek apakah UserID pemain ada di dalam daftar JSON
        if table.find(data, LocalPlayer.UserId) then
            IsPremium = true
            UserStatus = "PREMIUM 👑"
            ThemeColor = "#FFD700" -- Ubah tema jadi KUNING EMAS (Gold)
            StatusIcon = "solar:crown-star-bold"
        end
    else
        warn("Gagal decode JSON. Pastikan format di GitHub benar (Array Only).")
    end
else
    warn("Gagal mengambil Database. Cek Link RAW atau koneksi internet.")
end

-- ====================================================
-- 2. SETUP UI (WARNA DINAMIS)
-- ====================================================

WindUI:AddTheme({
    Name = "Dynamic-Theme",
    Accent = WindUI:Gradient({
        -- Warna berubah sesuai status (Kuning jika Premium, Ungu jika Free)
        ["0"] = { Color = Color3.fromHex(ThemeColor), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#000000"), Transparency = 0 },
    }, { Rotation = 0 }),
})

local Window = WindUI:CreateWindow({
    Title = "Aiz Hub | Universal",
    Icon = IsPremium and "solar:crown-bold" or "solar:planet-2-bold-duotone", 
    Author = IsPremium and "Verified User" or "Free User",
    Folder = "-168",
    Size = UDim2.fromOffset(800, 580),
    Transparent = true,
    Theme = "Dynamic-Theme",
    Resizable = true,
    HideSearchBar = true, 
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function() setclipboard(LocalPlayer.DisplayName) end,
    },
})

-- Notifikasi Status Login
WindUI:Notify({
    Title = "Welcome",
    Content = "Logged in as: " .. UserStatus,
    Duration = 5,
    Icon = StatusIcon
})

-- === LOGIKA DATA ===
local secondsInDay = 86400
local creationTime = os.time() - (LocalPlayer.AccountAge * secondsInDay)
local joinDate = os.date("%d %B %Y", creationTime)

local onlineFriends = 0
for _, friend in pairs(LocalPlayer:GetFriendsOnline()) do
    onlineFriends = onlineFriends + 1
end

local avatarImage = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"

-- Fungsi Teleport
local function TeleportToPlayer(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        WindUI:Notify({Title="Teleport", Content="Teleported to " .. targetPlayer.DisplayName, Duration=2, Icon="solar:map-point-bold"})
    else
        WindUI:Notify({Title="Error", Content="Target not found / Spawned", Duration=2, Icon="solar:danger-circle-bold"})
    end
end

-- ====================================================
-- 3. TAB & SECTION UI
-- ====================================================

local UserTab = Window:Tab({ Title = "User Profile", Icon = "solar:user-circle-bold", Locked = false })

-- [KIRI] IDENTITY
local MainSection = UserTab:Section({ 
    Title = "My Identity", 
    Side = "Left", 
    Box = true, 
    Icon = "solar:card-recieved-bold" 
})

MainSection:Paragraph({
    Title = LocalPlayer.DisplayName,
    -- Teks Premium berwarna Emas jika aktif (RichText)
    Desc = "License: " .. (IsPremium and '<font color="#FFD700"><b>PREMIUM</b></font>' or "Free Version") .. 
           "\nStatus: " .. (onlineFriends > 0 and "Online" or "Solo"),
    Image = avatarImage,
    ImageSize = 65,
    Buttons = {
        {
            Title = "Copy Display",
            Icon = "solar:tag-bold",
            Callback = function() 
                setclipboard(LocalPlayer.DisplayName) 
                WindUI:Notify({Title="Copied", Content="Copied Display Name", Duration=1})
            end
        },
        {
            Title = "Copy User",
            Icon = "solar:copy-bold",
            Callback = function() 
                setclipboard(LocalPlayer.Name) 
                WindUI:Notify({Title="Copied", Content="Copied Username", Duration=1})
            end
        }
    }
})

-- [KIRI] STATS
local DetailSection = UserTab:Section({ 
    Title = "Account Stats", 
    Side = "Left", 
    Box = true, 
    Icon = "solar:chart-square-bold" 
})

DetailSection:Paragraph({
    Title = "Membership",
    Desc = UserStatus,
    Icon = StatusIcon
})

DetailSection:Paragraph({ Title = "Username", Desc = "@" .. LocalPlayer.Name, Icon = "solar:user-id-bold" })
DetailSection:Paragraph({ Title = "Join Date", Desc = joinDate, Icon = "solar:calendar-date-bold" })
DetailSection:Paragraph({ Title = "Account Age", Desc = LocalPlayer.AccountAge .. " Days", Icon = "solar:history-bold" })
DetailSection:Paragraph({ Title = "Friends", Desc = onlineFriends .. " Online", Icon = "solar:users-group-rounded-bold" })


-- ====================================================
-- 4. SERVER PLAYERS (KANAN - AUTO UPDATE)
-- ====================================================

local PlayerListSection = UserTab:Section({ 
    Title = "Server Players (Realtime)", 
    Side = "Right", 
    Box = true, 
    Icon = "solar:global-bold" 
})

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

-- 2. Auto Add Player (Jika ada yang join)
Players.PlayerAdded:Connect(function(player)
    task.wait(1)
    WindUI:Notify({Title="New Player", Content=player.DisplayName.." joined!", Duration=3, Icon="solar:user-plus-bold"})
    CreatePlayerUI(player)
end)

-- 3. Info Player Left
Players.PlayerRemoving:Connect(function(player)
    WindUI:Notify({Title="Player Left", Content=player.DisplayName.." left.", Duration=3, Icon="solar:user-minus-linear"})
end)        WindUI:Notify({
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
})
