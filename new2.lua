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

