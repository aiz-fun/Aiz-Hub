local Version = "1.6.41"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "Aiz Hub Universal",
    Icon = "solar:global-bold", -- lucide icon
    Author = "By @aiz.fun",
    Folder = "Aiz Hub Universal",
    
   
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Purple Gradient",
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
--custom bar
Window:CreateTopbarButton("Help", "question-circle-broken",    function() setclipboard("https://discord.gg/aiz") end,  990)
--custom tag
Window:Tag({Title = "Testing!",Icon = "info-circle-broken",Color = Color3.fromHex("#9713e496"),Radius = 10, })
-- custom theme
WindUI:AddTheme({Name = "Purple Gradient",Accent = WindUI:Gradient({["0"] = { Color = Color3.fromHex("#2b1055"), Transparency = 0 },["100"] = { Color = Color3.fromHex("#0b0b0f"), Transparency = 0 },}, {Rotation = 0,}),})
--Home tab
local Home = Window:Tab({
    Title = "Home",
    Icon = "lucide/home",
})

Home:Paragraph({
    Title = "Welcome, " .. game.Players.LocalPlayer.DisplayName .. "!",
    Desc = "Thanks for using Aiz Hub Universal. Join our community for updates and support!",
    Image = WindUI:GetUserThumbnail(game.Players.LocalPlayer.UserId),
    ImageSize = 45,
    Buttons = {
        {
            Title = "Discord Server",
            Icon = "lucide/message-circle",
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
            Icon = "lucide/help-circle",
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
