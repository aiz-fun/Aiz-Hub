local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- 1. THEME CUSTOM
WindUI:AddTheme({
    Name = "Neon-Purple-Black",
    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#A855F7"), Transparency = 0 }, 
        ["100"] = { Color = Color3.fromHex("#000000"), Transparency = 0 }, 
    }, {
        Rotation = 0,
    }),
})

-- 2. CREATE WINDOW
local Window = WindUI:CreateWindow({
    Title = "Aiz Hub | Universal",
    Icon = "atom", 
    Author = "by .0oiwp dont forget to follow",
    Folder = "-168",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Neon-Purple-Black",
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            setclipboard(game.Players.LocalPlayer.DisplayName)
        end,
    },
})

-- 3. TAGS DI HEADER
-- Tag Versi
Window:Tag({
    Title = "v1.6.6",
    Icon = "lucide-github",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 8,
})

-- TAG FPS MANUAL (Disimpan ke variabel agar bisa diupdate logic-nya)
local FpsTag = Window:Tag({
    Title = "FPS: 0",
    Icon = "lucide-gauge", -- Icon gauge/speedometer
    Color = Color3.fromHex("#30ff6a"),
    Radius = 8,
})

-- ==========================================
-- LOGIC FPS (MENGHITUNG & UPDATE FPS)
-- ==========================================
local tagEnabled = true
local updateDelay = 0.19 -- Nilai awal sesuai slider
local lastUpdate = 0

game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
    -- Logic: Hanya update jika tag dinyalakan dan waktu tunggu (delay) sudah tercapai
    if tagEnabled and (tick() - lastUpdate >= updateDelay) then
        local currentFps = math.floor(1 / deltaTime)
        FpsTag:SetTitle("FPS: " .. tostring(currentFps))
        lastUpdate = tick()
    end
end)
-- ==========================================

-- 4. TAB UI
local Tab = Window:Tab({
    Title = "UI",
    Icon = "bird",
    Locked = false,
})

-- 5. SECTION (Kotak pembungkus)
local FpsSection = Tab:Section({
    Title = "Fps Tag"
})

-- 6. MENYAMBUNGKAN TOGGLE & SLIDER KE LOGIC DI ATAS
FpsSection:Toggle({
    Title = "Enable Tag",
    Value = true,
    Callback = function(state)
        tagEnabled = state -- Matikan logic hitung
        FpsTag:SetVisible(state) -- Sembunyikan tag di header
    end
})

FpsSection:Slider({
    Title = "Update Delay",
    Step = 0.01,
    Value = {
        Min = 0.01, -- Jangan 0 agar tidak lag
        Max = 1,
        Default = 0.19,
    },
    Callback = function(value)
        updateDelay = value -- Mengubah kecepatan update FPS di header
    end
})

-- Tanpa Window:SelectTab(Tab) sesuai permintaan
