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
WindUI:Notify({
    Title = "Welcome to the [Aiz Hub | Universal]",
    Content = "This Script Is Beta !",
    Duration = 3, 
    Icon = "info",
})
Window:Tag({
    Title = "v1.6.6",
    Icon = "lucide-github", -- Menggunakan icon lucide github
    Color = Color3.fromHex("#30ff6a"),
    Radius = 8,
})

-- Tag FPS (Otomatis muncul warna hijau di atas)
Window:EditElement("FPS", { 
    Visible = true 
})

-- 3. MEMBUAT TAB (Sidebar Kiri)
local MyTab = Window:Tab({
    Title = "UI",
    Icon = "rbxassetid://10723345661"
})

-- 4. MEMBUAT SECTION (Kotak abu-abu di dalam Tab)
local FpsSection = MyTab:Section({
    Title = "Fps Tag"
})

-- 5. MEMASUKKAN ELEMEN KE DALAM SECTION
-- Toggle Enable Tag
local Toggle = FpsSection:Toggle({
    Title = "Enable Tag",
    Value = true,
    Callback = function(state)
        -- Logika untuk menyalakan/mematikan tag FPS
        Window:EditElement("FPS", { Visible = state })
        print("FPS Tag Enabled:", state)
    end
})

-- Slider Update Delay
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

-- Memilih tab agar langsung terbuka saat script dijalankan
Window:SelectTab(MyTab)
