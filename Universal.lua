local success, err = pcall(function()
    print("Aiz Hub Loading...")

    local Version = "1.6.42"
    local WindUIUrl = "https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"
    
    local success_get, content = pcall(game.HttpGet, game, WindUIUrl)
    if not success_get or not content or content:find("404") then
        error("Failed to connect to WindUI GitHub! Check your connection or version.")
    end

    local WindUI_func, parse_err = loadstring(content)
    if not WindUI_func then error("Failed to parse WindUI: " .. tostring(parse_err)) end
    
    local WindUI = WindUI_func()
    if not WindUI then error("Failed to load WindUI Library!") end

    print("WindUI Library Loaded!")

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

    print("Window Created!")

    -- custom bar
    Window:AddTopbarButton({
        Title = "Help",
        Icon = "lucide:help-circle",
        Callback = function() 
            if setclipboard then setclipboard("https://discord.gg/aiz") end
        end,
    })

    -- custom tag
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
    local Player = Players.LocalPlayer
    local UserId = Player and Player.UserId or 1
    local DisplayName = Player and Player.DisplayName or "User"
    local Thumbnail = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. UserId .. "&width=150&height=150&format=png"

    print("User Info Loaded: " .. DisplayName)

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
                    if setclipboard then setclipboard("https://discord.gg/aiz") end
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
                    if setclipboard then setclipboard("https://aiz.fun") end
                    WindUI:Notify({
                        Title = "Aiz Hub",
                        Content = "Website link copied to clipboard!",
                        Duration = 5
                    })
                end
            }
        }
    })

    print("Aiz Hub Successfully Loaded!")
end)

if not success then
    warn("Aiz Hub Error: " .. tostring(err))
    if game:GetService("RunService"):IsClient() then
        print("Please report this error in our Discord.")
    end
end
