local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- 1. SETTING THEME CUSTOM
WindUI:AddTheme({
    Name = "Neon-Purple-Black",
    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#A855F7"), Transparency = 0 }, -- neon purple
        ["100"] = { Color = Color3.fromHex("#000000"), Transparency = 0 }, -- pure black
    }, {
        Rotation = 0,
    }),
})

-- 2. MEMBUAT WINDOW UTAMA
local Window = WindUI:CreateWindow({
    Title = "Aiz Hub | Universal",
    Icon = "atom", 
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

-- 3. NOTIFIKASI AWAL
WindUI:Notify({
    Title = "Welcome to the [Aiz Hub | Universal]",
    Content = "This Script Is Beta !",
    Duration = 3, 
    Icon = "info",
})

-- 4. TAG DI ATAS (HEADER)
Window:Tag({
    Title = "v1.6.6",
    Icon = "lucide-github",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 8,
})

Window:EditElement("FPS", { 
    Visible = true 
})

-- 5. MEMBUAT TAB "UI"
local MyTab = Window:Tab({
    Title = "UI",
    Icon = "rbxassetid://10723345661"
})

-- 6. MEMBUAT SECTION "FPS TAG" (Kotak pembungkus)
local FpsSection = MyTab:Section({
    Title = "Fps Tag"
})

-- 7. MENAMBAHKAN ELEMEN KE DALAM SECTION
local Toggle = FpsSection:Toggle({
    Title = "Enable Tag",
    Value = true,
    Callback = function(state)
        Window:EditElement("FPS", { Visible = state })
        print("FPS Tag Enabled:", state)
    end
})

local Slider = FpsSection:Slider({
    Title = "Update Delay",
    Step = 0.01,
    Value = {
        Min = 0,
        Max = 1,
        Default = 0.19,
    },
    Callback = function(value)
        print("Update Delay set to:", value)
    end
})
