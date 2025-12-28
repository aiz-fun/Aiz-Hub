local Version = "1.6.42"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Aiz Hub Universal",
    Icon = "lucide:globe",
    Author = "By @aiz.fun",
    Folder = "Aiz Hub Universal",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
})

local Home = Window:Tab({
    Title = "Home",
    Icon = "lucide:home",
})

print("Minimal script loaded!")
