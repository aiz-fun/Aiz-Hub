local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")

-- ====================================================
-- 1. CONFIG PREMIUM
-- ====================================================
local PremiumList = {
    8080406235,         
    LocalPlayer.UserId, 
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
-- 2. MENDAFTARKAN TEMA WARNA
-- ====================================================
-- Kita buat beberapa tema biar Dropdown Theme berfungsi

-- Tema 1: Ungu (Default)
WindUI:AddTheme({
    Name = "Purple",
    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#A855F7"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#000000"), Transparency = 0 },
    }, { Rotation = 0 }),
})

-- Tema 2: Merah (Red)
WindUI:AddTheme({
    Name = "Red",
    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#FF3333"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#000000"), Transparency = 0 },
    }, { Rotation = 0 }),
})

-- Tema 3: Biru (Blue)
WindUI:AddTheme({
    Name = "Blue",
    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#3366FF"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#000000"), Transparency = 0 },
    }, { Rotation = 0 }),
})

-- Tema 4: Emas (Gold)
WindUI:AddTheme({
    Name = "Gold",
    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#FFD700"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#000000"), Transparency = 0 },
    }, { Rotation = 0 }),
})

-- ====================================================
-- 3. WINDOW SETUP
-- ====================================================

local Window = WindUI:CreateWindow({
    Title = "Aiz Hub | Universal",
    Icon = IsPremium and "solar:crown-bold" or "solar:planet-2-bold-duotone", 
    Author = IsPremium and "Verified User" or "Free User",
    Folder = "-168",
    -- Ukuran diperkecil sedikit agar Scrollbar muncul jika konten panjang
    Size = UDim2.fromOffset(750, 500), 
    Transparent = true,
    Theme = IsPremium and "Gold" or "Purple", -- Auto tema Gold jika premium
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
    Content = "Script Loaded. Scroll Down for Settings.",
    Duration = 4,
    Icon = StatusIcon
})

-- ====================================================
-- 4. TAB & PROFILE
-- ====================================================

local UserTab = Window:Tab({ Title = "User Profile", Icon = "solar:user-circle-bold", Locked = false })

-- === KOLOM KIRI (PROFILE) ===
local MainSection = UserTab:Section({ Title = "My Identity", Side = "Left", Box = true, Icon = "solar:card-recieved-bold" })

local onlineFriends = 0
for _, friend in pairs(LocalPlayer:GetFriendsOnline()) do onlineFriends = onlineFriends + 1 end
local avatarImage = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"

MainSection:Paragraph({
    Title = LocalPlayer.DisplayName,
    Desc = "Status: " .. UserStatus .. "\nFriends: " .. onlineFriends,
    Image = avatarImage,
    ImageSize = 65,
    Buttons = {
        { Title = "Copy Name", Icon = "solar:copy-bold", Callback = function() setclipboard(LocalPlayer.Name) end }
    }
})

-- === KOLOM KANAN (SERVER PLAYER) ===
local PlayerListSection = UserTab:Section({ Title = "Server Players", Side = "Right", Box = true, Icon = "solar:global-bold" })

local function CreatePlayerUI(player)
    local thumb = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
    PlayerListSection:Paragraph({
        Title = player.DisplayName,
        Desc = "@" .. player.Name,
        Image = thumb,
        ImageSize = 45,
        Buttons = {
            { Title = "Goto", Icon = "solar:map-point-bold", Callback = function() 
                if player.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame end
            end }
        }
    })
end
for _, player in ipairs(Players:GetPlayers()) do if player ~= LocalPlayer then CreatePlayerUI(player) end end

-- ====================================================
-- 5. SETTINGS SECTION (PERBAIKAN SLIDER & THEME)
-- ====================================================

local SettingsSection = UserTab:Section({
    Title = "Global Settings",
    Side = "Right",
    Box = true, -- Box True membuat tampilan rapi
    Icon = "solar:settings-bold-duotone"
})

-- [[ FITUR 1: GANTI TEMA ]]
SettingsSection:Dropdown({
    Title = "Change Interface Theme",
    Desc = "Select your favorite color",
    Multi = false,
    Required = true,
    -- Nama item harus sama dengan nama WindUI:AddTheme di atas
    Items = {"Purple", "Red", "Blue", "Gold"},
    Default = IsPremium and "Gold" or "Purple",
    Callback = function(selectedTheme)
        -- Mengganti tema secara langsung
        WindUI:SetTheme(selectedTheme)
        WindUI:Notify({Title="Theme Changed", Content="Applied " .. selectedTheme .. " theme.", Duration=2, Icon="solar:pallete-2-bold"})
    end
})

-- [[ FITUR 2: SLIDER YANG SUDAH DIPERBAIKI ]]
-- Perhatikan: Jangan pakai Value = { ... }, langsung tulis Min, Max, Default
SettingsSection:Slider({
    Title = "WalkSpeed Modifier",
    Desc = "Control your character speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Step = 1, -- Step 1 artinya naik per 1 angka
    Callback = function(value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

SettingsSection:Slider({
    Title = "JumpPower Modifier",
    Desc = "Control your jump height",
    Min = 50,
    Max = 350,
    Default = 50,
    Step = 1,
    Callback = function(value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.UseJumpPower = true
            LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end
})

SettingsSection:Slider({
    Title = "Field of View (FOV)",
    Desc = "Camera Zoom distance",
    Min = 70,
    Max = 120,
    Default = 70,
    Step = 1,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
    end
})

-- [[ FITUR 3: BUTTONS ]]
SettingsSection:Paragraph({
    Title = "World Control",
    Desc = "Manage environment",
    Icon = "solar:earth-bold",
    Buttons = {
        {
            Title = "Unlock FPS",
            Icon = "solar:monitor-smartphone-bold",
            Callback = function()
                setfpscap(999)
                WindUI:Notify({Title="Success", Content="FPS Unlocked", Duration=2})
            end
        },
        {
            Title = "Rejoin Server",
            Icon = "solar:restart-circle-bold",
            Callback = function()
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        }
    }
})

-- [[ CARA MENGATASI MASALAH SCROLL ]]
-- Saya menambahkan paragraf kosong di paling bawah
-- Ini trik agar scrollbar "dipaksa" muncul jika konten tertutup
SettingsSection:Paragraph({
    Title = "",
    Desc = "                                           ",
})        ["0"] = { Color = Color3.fromHex(ThemeColor), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#000000"), Transparency = 0 },
    }, { Rotation = 0 }),
})

local Window = WindUI:CreateWindow({
    Title = "Aiz Hub | Universal",
    Icon = IsPremium and "solar:crown-bold" or "solar:planet-2-bold-duotone", 
    Author = IsPremium and "Verified User" or "Free User",
    Folder = "-168",
    Size = UDim2.fromOffset(800, 550),
    Transparent = true,
    Theme = "Dynamic-Theme",
    Resizable = true,
    HideSearchBar = true,
    -- [[ PERBAIKAN PENTING DI SINI ]] --
    ScrollBarEnabled = true,   -- Mengaktifkan Scroll agar bisa geser ke bawah
    ScrollBarWidth = 6,        -- Lebar scrollbar
    ScrollBarTransparency = 0, -- Scrollbar terlihat
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
-- 3. LOGIKA BACKEND
-- ====================================================

-- Anti AFK
local AntiAfkEnabled = false
LocalPlayer.Idled:Connect(function()
    if AntiAfkEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        WindUI:Notify({Title="Anti-AFK", Content="Prevented Idle Kick", Duration=2, Icon="solar:shield-check-bold"})
    end
end)

-- Data Helper
local secondsInDay = 86400
local creationTime = os.time() - (LocalPlayer.AccountAge * secondsInDay)
local joinDate = os.date("%d %B %Y", creationTime)
local avatarImage = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"
local onlineFriends = 0
for _, friend in pairs(LocalPlayer:GetFriendsOnline()) do onlineFriends = onlineFriends + 1 end

local function TeleportToPlayer(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        WindUI:Notify({Title="Teleport", Content="Teleported to " .. targetPlayer.DisplayName, Duration=2, Icon="solar:map-point-bold"})
    else
        WindUI:Notify({Title="Error", Content="Target not found", Duration=2, Icon="solar:danger-circle-bold"})
    end
end

-- ====================================================
-- 4. TAB & SECTIONS
-- ====================================================

local UserTab = Window:Tab({ Title = "User Profile", Icon = "solar:user-circle-bold", Locked = false })

-- === KOLOM KIRI ===

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

-- === KOLOM KANAN ===

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
            { Title = "Goto", Icon = "solar:map-point-bold", Callback = function() TeleportToPlayer(player) end },
            { Title = "Copy Name", Icon = "solar:copy-linear", Callback = function() setclipboard(player.Name) end }
        }
    })
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then CreatePlayerUI(player) end
end
Players.PlayerAdded:Connect(function(player) task.wait(1) CreatePlayerUI(player) end)


-- === KOLOM KANAN (SETTING TAMBAHAN) ===

local SettingsSection = UserTab:Section({
    Title = "Game Settings",
    Side = "Right",
    Box = true,
    Icon = "solar:settings-bold-duotone"
})

-- 1. Anti AFK
SettingsSection:Toggle({
    Title = "Anti AFK",
    Default = false,
    Callback = function(value)
        AntiAfkEnabled = value
    end
})

-- 2. Character Mods (Speed & Jump)
SettingsSection:Slider({
    Title = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

SettingsSection:Slider({
    Title = "JumpPower",
    Min = 50,
    Max = 300,
    Default = 50,
    Callback = function(value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.UseJumpPower = true
            LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end
})

-- 3. Camera FOV
SettingsSection:Slider({
    Title = "Field of View (FOV)",
    Min = 70,
    Max = 120,
    Default = 70,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
    end
})

-- 4. Server & Time Actions
SettingsSection:Paragraph({
    Title = "Server Manager",
    Desc = "Time & Server Control",
    Icon = "solar:server-bold",
    Buttons = {
        {
            Title = "Rejoin",
            Icon = "solar:restart-circle-bold",
            Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end
        },
        {
            Title = "Server Hop",
            Icon = "solar:plain-bold",
            Callback = function()
                WindUI:Notify({Title="Server Hop", Content="Finding server...", Duration=2})
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
        },
        {
            Title = "Set Day",
            Icon = "solar:sun-2-bold",
            Callback = function() Lighting.ClockTime = 14 end
        },
        {
            Title = "Set Night",
            Icon = "solar:moon-bold",
            Callback = function() Lighting.ClockTime = 0 end
        }
    }
})
