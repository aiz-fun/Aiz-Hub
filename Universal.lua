local Version = "1.6.41"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"))()

-- custom theme (must be added BEFORE CreateWindow if used in config)
WindUI:AddTheme({
    Name = "Purple-Gradient",
    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#6a0dad"), Transparency = 0 }, -- Royal Purple
        ["100"] = { Color = Color3.fromHex("#111111"), Transparency = 0 }, -- Soft Black
    }, {Rotation = 0}),
})

local Window = WindUI:CreateWindow({
    Title = "Aiz Hub Universal",
    Icon = "lucide:globe",
    Author = "By @aiz.fun",
    Folder = "Aiz Hub Universal",
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
    },
})

-- custom bar (fixed method name)
Window:AddTopbarButton({
    Title = "Help",
    Icon = "lucide:help-circle",
    Callback = function() setclipboard("https://discord.gg/aiz") end,
})

-- custom tag (fixed method name and icon)
Window:EditTag({
    Title = "Testing!",
    Icon = "lucide:info", 
    Color = Color3.fromHex("#9713e496"),
    Radius = 10, 
})

-- Home tab
local Home = Window:Tab({
    Title = "Home",
    Icon = "lucide:home",
})

-- Get user info safely
local Players = game:GetService("Players")
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local UserId = Player.UserId
local DisplayName = Player.DisplayName
local Thumbnail = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. UserId .. "&width=150&height=150&format=png"

Home:Paragraph({
    Title = "Welcome, " .. DisplayName .. "!",
    Desc = "Thanks for using Aiz Hub Universal. Join our community for updates and support!",
    Image = Thumbnail,
    ImageSize = 45,
    Buttons = {
        {
            Title = "Discord Server",
            Icon = "lucide:message-circle",
            Callback = function()
                setclipboard("https://discord.gg/aiz")
                WindUI:Notify({
                    Title = "Aiz Hub",
                    Content = "Discord link copied to clipboard!",
                    Duration = 5
                })
            end
        },
        {
            Title = "Help Center",
            Icon = "lucide:help-circle",
            Callback = function()
                setclipboard("https://aiz.fun")
                WindUI:Notify({
                    Title = "Aiz Hub",
                    Content = "Website link copied to clipboard!",
                    Duration = 5
                })
            end
        }
    }
})
