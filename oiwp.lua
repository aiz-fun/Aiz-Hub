local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

-- ====================================================
-- 1. CONFIG PREMIUM
-- ====================================================
local PremiumList = {
    8080406235,         -- ID Premium
    LocalPlayer.UserId, -- ID Kamu
}

local IsPremium = false
local UserStatus = "Free User"
local StatusIcon = "solar:box-bold"

if table.find(PremiumList, LocalPlayer.UserId) then
    IsPremium = true
    UserStatus = "PREMIUM 👑" 
    StatusIcon = "solar:crown-star-bold"
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
    Icon = IsPremium and "solar:crown-bold" or "solar:planet-2-bold-duotone", 
    Author = IsPremium and "Verified User" or "Free User",
    Folder = "-168",
    Size = UDim2.fromOffset(800, 600), -- Tinggi ditambah sedikit
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

WindUI:Notify({
    Title = "Welcome",
    Content = "Logged in as: " .. UserStatus,
    Duration = 5,
    Icon = StatusIcon
})

-- ====================================================
-- 3. LOGIKA BACKEND (Anti AFK & Data)
-- ====================================================

-- Anti AFK Script
local AntiAfkEnabled = false
LocalPlayer.Idled:Connect(function()
    if AntiAfkEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        WindUI:Notify({Title="Anti-AFK", Content="Prevented Idle Kick", Duration=2, Icon="solar:shield-check-bold"})
    end
end)

-- Data
local secondsInDay = 86400
local creationTime = os.time() - (LocalPlayer.AccountAge * secondsInDay)
local joinDate = os.date("%d %B %Y", creationTime)
local avatarImage = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"
local onlineFriends = 0
for _, friend in pairs(LocalPlayer:GetFriendsOnline()) do onlineFriends = onlineFriends + 1 end

local function TeleportToPlayer(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        WindUI:Notify({Title="Teleport", Content="Teleported to " .. targetPlayer.DisplayName, Duration=2, Icon="solar:map-point-bold"})
    else
        WindUI:Notify({Title="Error", Content="Target not found / Spawned", Duration=2, Icon="solar:danger-circle-bold"})
    end
end

-- ====================================================
-- 4. TAB USER INFO
-- ====================================================

local UserTab = Window:Tab({ Title = "User Profile", Icon = "solar:user-circle-bold", Locked = false })

-- [KIRI 1] IDENTITY
local MainSection = UserTab:Section({ 
    Title = "My Identity", 
    Side = "Left", 
    Box = true, 
    Icon = "solar:card-recieved-bold" 
})

MainSection:Paragraph({
    Title = LocalPlayer.DisplayName,
    Desc = "License: " .. (IsPremium and '<font color="#FFD700"><b>PREMIUM</b></font>' or "Free Version") .. 
           "\nStatus: " .. (onlineFriends > 0 and "Online" or "Solo"),
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

-- [KIRI 2] STATS
local DetailSection = UserTab:Section({ 
    Title = "Account Stats", 
    Side = "Left", 
    Box = true, 
    Icon = "solar:chart-square-bold" 
})

DetailSection:Paragraph({ Title = "Membership", Desc = UserStatus, Icon = StatusIcon })
DetailSection:Paragraph({ Title = "Username", Desc = "@" .. LocalPlayer.Name, Icon = "solar:user-id-bold" })
DetailSection:Paragraph({ Title = "Join Date", Desc = joinDate, Icon = "solar:calendar-date-bold" })
DetailSection:Paragraph({ Title = "Account Age", Desc = LocalPlayer.AccountAge .. " Days", Icon = "solar:history-bold" })
DetailSection:Paragraph({ Title = "Friends", Desc = onlineFriends .. " Online", Icon = "solar:users-group-rounded-bold" })


-- [KANAN 1] SERVER PLAYERS LIST
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
                Title = "Goto", Icon = "solar:map-point-bold",
                Callback = function() TeleportToPlayer(player) end
            },
            {
                Title = "Copy Name", Icon = "solar:copy-linear",
                Callback = function() setclipboard(player.Name) end
            }
        }
    })
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then CreatePlayerUI(player) end
end

Players.PlayerAdded:Connect(function(player)
    task.wait(1)
    CreatePlayerUI(player)
end)


-- ====================================================
-- [KANAN 2] SETTINGS SECTION (BARU)
-- ====================================================

local SettingsSection = UserTab:Section({
    Title = "System Settings",
    Side = "Right", -- Posisi di Kanan, otomatis di bawah Player List
    Box = true,
    Icon = "solar:settings-bold-duotone"
})

-- 1. Ganti Nama (Client Side)
SettingsSection:Input({
    Title = "Spoof Display Name",
    Placeholder = "Enter new name...",
    Default = "",
    Callback = function(text)
        if text and text ~= "" then
            pcall(function()
                LocalPlayer.DisplayName = text
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.DisplayName = text
                end
            end)
            WindUI:Notify({Title="Success", Content="Name changed to: "..text.." (Client Side)", Duration=2, Icon="solar:pen-new-square-bold"})
        end
    end
})

-- 2. Anti AFK Toggle
SettingsSection:Toggle({
    Title = "Anti AFK",
    Default = false,
    Callback = function(value)
        AntiAfkEnabled = value
        WindUI:Notify({
            Title = "Anti AFK",
            Content = value and "Enabled" or "Disabled",
            Duration = 2,
            Icon = value and "solar:shield-check-bold" or "solar:shield-warning-bold"
        })
    end
})

-- 3. FPS Cap Slider
SettingsSection:Slider({
    Title = "Max FPS Cap",
    Min = 30,
    Max = 360,
    Default = 60,
    Callback = function(value)
        setfpscap(math.floor(value))
    end
})

-- 4. Tombol Rejoin & Server Hop
SettingsSection:Paragraph({
    Title = "Server Actions",
    Desc = "Quick actions for server management",
    Icon = "solar:server-bold",
    Buttons = {
        {
            Title = "Rejoin",
            Icon = "solar:restart-circle-bold",
            Callback = function()
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        },
        {
            Title = "Server Hop",
            Icon = "solar:plain-bold",
            Callback = function()
                WindUI:Notify({Title="Server Hop", Content="Finding new server...", Duration=2, Icon="solar:magnifer-bold"})
                -- Simple Hop Logic
                local Http = game:GetService("HttpService")
                local TPS = game:GetService("TeleportService")
                local Api = "https://games.roblox.com/v1/games/"
                local _place,_id = game.PlaceId, game.JobId
                local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
                
                local function ListServers(cursor)
                    local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
                    return Http:JSONDecode(Raw)
                end
            
                local Server, Next; repeat
                    local Servers = ListServers(Next)
                    Server = Servers.data[math.random(1, #Servers.data)]
                    Next = Servers.nextPageCursor
                until Server.playing < Server.maxPlayers and Server.id ~= _id
                
                TPS:TeleportToPlaceInstance(_place, Server.id, LocalPlayer)
            end
        }
    }
})    -- (Opsional: Kamu bisa buat whitelist manual disini)
    if LocalPlayer.UserId == 123456 then -- Ganti ID mu
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
})
