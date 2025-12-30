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
    Icon = "solar:planet-2-bold-duotone", 
    Author = "by .0oiwp",
    Folder = "-168",
    Size = UDim2.fromOffset(700, 500), -- Lebar saya tambah sedikit agar 2 kolom muat lega
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

-- === LOGIKA HITUNGAN LOCAL PLAYER ===
local secondsInDay = 86400
local creationTime = os.time() - (LocalPlayer.AccountAge * secondsInDay)
local joinDate = os.date("%d %B %Y", creationTime)

local onlineFriends = 0
for _, friend in pairs(LocalPlayer:GetFriendsOnline()) do
    onlineFriends = onlineFriends + 1
end

-- Link Foto Avatar Local
local avatarImage = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"

-- === TAB ===
local UserTab = Window:Tab({
    Title = "User Profile",
    Icon = "solar:user-circle-bold",
    Locked = false,
})

-- ==========================================
-- KOLOM KIRI: INFO AKUN KAMU (LOCAL PLAYER)
-- ==========================================

-- SECTION HEADER
local MainSection = UserTab:Section({
    Title = "My Identity",
    Side = "Left",
    Box = true
})

MainSection:Paragraph({
    Title = LocalPlayer.DisplayName,
    Desc = "Status: " .. (onlineFriends > 0 and "Online" or "Solo"),
    Image = avatarImage,
    ImageSize = 60,
    Buttons = {
        {
            Title = "Copy Name",
            Icon = "solar:copy-bold",
            Callback = function() setclipboard(LocalPlayer.Name) end
        }
    }
})

-- SECTION DETAIL STATISTIK
local DetailSection = UserTab:Section({
    Title = "My Stats",
    Side = "Left", 
    Box = true
})

DetailSection:Paragraph({
    Title = "Username",
    Desc = "@" .. LocalPlayer.Name,
    Icon = "solar:user-id-bold"
})

DetailSection:Paragraph({
    Title = "Join Date",
    Desc = joinDate,
    Icon = "solar:calendar-date-bold"
})

DetailSection:Paragraph({
    Title = "Account Age",
    Desc = LocalPlayer.AccountAge .. " Days",
    Icon = "solar:history-bold"
})

DetailSection:Paragraph({
    Title = "Friends Online",
    Desc = onlineFriends .. " Active",
    Icon = "solar:users-group-rounded-bold"
})

-- ==========================================
-- KOLOM KANAN: DAFTAR PEMAIN LAIN (SERVER)
-- ==========================================

local PlayerListSection = UserTab:Section({
    Title = "Server Players",
    Side = "Right", -- Ditaruh di kanan biar rapi
    Box = true,
    Icon = "solar:users-group-two-rounded-bold"
})

-- Fungsi untuk menambahkan player ke list
local function AddPlayerToList(player)
    -- Ambil foto profil player lain
    local thumb = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
    
    PlayerListSection:Paragraph({
        Title = player.DisplayName,
        Desc = "@" .. player.Name .. "\nID: " .. player.UserId,
        Image = thumb,
        ImageSize = 45,
        Buttons = {
            {
                Title = "Copy Name",
                Icon = "solar:copy-bold",
                Callback = function() 
                    setclipboard(player.Name)
                    WindUI:Notify({
                        Title = "Copied",
                        Content = "Copied @"..player.Name,
                        Duration = 1.5,
                        Icon = "solar:check-circle-bold"
                    })
                end
            },
            {
                Title = "View Avatar", -- Tombol tambahan seru
                Icon = "solar:camera-bold",
                Callback = function()
                     -- Ini hanya contoh print, krn WindUI tidak punya popup gambar
                     print("Viewing avatar of: " .. player.Name)
                end
            }
        }
    })
end

-- 1. Tambahkan semua pemain yang sudah ada di server (kecuali diri sendiri)
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        AddPlayerToList(player)
    end
end

-- 2. (Opsional) Refresh Button di paling atas kanan jika ada player baru masuk
PlayerListSection:Paragraph({
    Title = "Information",
    Desc = "List shows players currently in server.",
    Icon = "solar:info-circle-bold",
    Buttons = {
        {
            Title = "Refresh List", -- Tombol refresh manual (simple logic)
            Icon = "solar:restart-bold",
            Callback = function()
                WindUI:Notify({
                    Title = "Refresh",
                    Content = "Please re-execute script to update list (Static UI)",
                    Duration = 3,
                    Icon = "solar:info-square-bold"
                })
            end
        }
    }
})

WindUI:Notify({
    Title = "Loaded",
    Content = "User & Server list loaded.",
    Duration = 3, 
    Icon = "solar:check-read-linear"
})
