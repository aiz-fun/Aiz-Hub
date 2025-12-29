--[[
    Aiz Hub Universal
    Author: @aiz.fun
    Version: 1.6.42
    Library: WindUI
]]

local success, err = pcall(function()
    -- [ SERVICES ] --
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")

    -- [ CONFIGURATION ] --
    local Version = "1.6.42"
    local WindUIUrl = "https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"
    
    -- [ INITIALIZATION ] --
    local WindUI = loadstring(game:HttpGet(WindUIUrl))()
    
    -- [ DATA GATHERING ] --
    local Player = Players.LocalPlayer
    local UserId = Player.UserId
    local DisplayName = Player.DisplayName
    local AccountAge = Player.AccountAge
    local JoinDate = os.date("%d/%m/%Y", os.time() - (AccountAge * 86400))
    local Thumbnail = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. UserId .. "&width=150&height=150&format=png"
    
    local FriendCount = 0
    pcall(function()
        local info = game:HttpGet("https://friends.roblox.com/v1/users/" .. UserId .. "/friends/count")
        FriendCount = HttpService:JSONDecode(info).count
    end)

    -- [ THEME SETUP ] --
    WindUI:AddTheme({
        Name = "Purple-Gradient",
        Accent = WindUI:Gradient({
            ["0"]   = { Color = Color3.fromHex("#6a0dad"), Transparency = 0 }, -- Royal Purple
            ["100"] = { Color = Color3.fromHex("#111111"), Transparency = 0 }, -- Soft Black
        }, { Rotation = 0 }),
    })

    -- [ WINDOW CREATION ] --
    local Window = WindUI:CreateWindow({
        Title = "Aiz Hub Universal",
        Icon = "globe",
        Author = "By @aiz.fun",
        Folder = "Aiz Hub Universal",
        Size = UDim2.fromOffset(580, 460),
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
            Callback = function() print("User Profile Clicked") end,
        },
    })

    -- [ TOPBAR & TAGS ] --
    Window:AddTopbarButton({
        Title = "Help",
        Icon = "help-circle",
        Callback = function() 
            if setclipboard then setclipboard("https://discord.gg/aiz") end
        end,
    })

    Window:EditTag({
        Title = "PRO VERSION",
        Icon = "check-circle", 
        Color = Color3.fromHex("#6a0dad"),
        Radius = 10, 
    })

    -- [ HOME TAB ] --
    local Home = Window:Tab({
        Title = "Home",
        Icon = "home",
    })

    Home:Paragraph({
        Title = "Welcome, " .. DisplayName .. "!",
        Desc = "Thanks for using Aiz Hub Universal. Join our community for updates and support!",
        Image = Thumbnail,
        ImageSize = 45,
        Buttons = {
            {
                Title = "Discord Server",
                Icon = "message-circle",
                Callback = function()
                    if setclipboard then setclipboard("https://discord.gg/aiz") end
                    WindUI:Notify({ Title = "Aiz Hub", Content = "Discord link copied!", Duration = 3 })
                end
            },
            {
                Title = "Help Center",
                Icon = "help-circle",
                Callback = function()
                    if setclipboard then setclipboard("https://aiz.fun") end
                    WindUI:Notify({ Title = "Aiz Hub", Content = "Website link copied!", Duration = 3 })
                end
            }
        }
    })

    Home:Paragraph({
        Title = "System Updates",
        Desc = "• Added New Player Profile Tab\n• Integrated Real-time Friend Counting\n• Optimized UI Loading Speed\n• Refactored Internal Codebase",
        Icon = "sparkles",
    })

    -- [ PLAYER TAB ] --
    local PlayerTab = Window:Tab({
        Title = "Player",
        Icon = "user",
    })

    PlayerTab:Paragraph({
        Title = DisplayName .. " (@" .. Player.Name .. ")",
        Desc = "• User ID: " .. UserId .. "\n• Account Age: " .. AccountAge .. " days\n• Joined: " .. JoinDate .. "\n• Total Friends: " .. FriendCount,
        Image = Thumbnail,
        ImageSize = 65,
    })

    PlayerTab:Section({ Title = "Movement Settings" })

    PlayerTab:Slider({
        Title = "WalkSpeed",
        Desc = "Boost your character movement speed.",
        Default = 16,
        Min = 16,
        Max = 250,
        Callback = function(Value)
            local Char = Player.Character
            if Char and Char:FindFirstChild("Humanoid") then
                Char.Humanoid.WalkSpeed = Value
            end
        end,
    })

    PlayerTab:Slider({
        Title = "JumpPower",
        Desc = "Increase your vertical jump height.",
        Default = 50,
        Min = 50,
        Max = 500,
        Callback = function(Value)
            local Char = Player.Character
            if Char and Char:FindFirstChild("Humanoid") then
                Char.Humanoid.UseJumpPower = true
                Char.Humanoid.JumpPower = Value
            end
        end,
    })

    -- [ FE SCRIPTS TAB ] --
    local FETab = Window:Tab({
        Title = "FE Scripts",
        Icon = "code-2",
    })

    FETab:Section({ Title = "Script Collection" })

    FETab:Paragraph({
        Title = "Infinite Yield",
        Desc = "The most advanced FE Admin script with 400+ commands.",
        Image = "https://www.roblox.com/asset-thumbnail/image?assetId=13110363242&width=420&height=420&format=png",
        ImageSize = 50,
        Buttons = {
            {
                Title = "Execute",
                Icon = "play",
                Callback = function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
                end,
            }
        }
    })

    FETab:Paragraph({
        Title = "SimpleSpy",
        Desc = "A powerful RemoteEvent and RemoteFunction spy for debugging.",
        Image = "https://www.roblox.com/asset-thumbnail/image?assetId=13110363242&width=420&height=420&format=png",
        ImageSize = 50,
        Buttons = {
            {
                Title = "Execute",
                Icon = "play",
                Callback = function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpy/master/SimpleSpySource.lua"))()
                end,
            }
        }
    })

    FETab:Paragraph({
        Title = "Dex Explorer",
        Desc = "V3/V4 edition of the classic game explorer tool.",
        Image = "https://www.roblox.com/asset-thumbnail/image?assetId=13110363242&width=420&height=420&format=png",
        ImageSize = 50,
        Buttons = {
            {
                Title = "Execute",
                Icon = "play",
                Callback = function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
                end,
            }
        }
    })

    -- [ GAME SCRIPTS TAB ] --
    local GameTab = Window:Tab({
        Title = "Game",
        Icon = "gamepad-2",
    })

    GameTab:Section({ Title = "Popular Game Scripts" })

    GameTab:Paragraph({
        Title = "Blox Fruits",
        Desc = "Best script for Auto Farm, Sea Events, and more.",
        Image = "https://www.roblox.com/asset-thumbnail/image?assetId=13110363242&width=420&height=420&format=png", -- Placeholder image
        ImageSize = 50,
        Buttons = {
            {
                Title = "Execute",
                Icon = "play",
                Callback = function()
                    -- loadstring(game:HttpGet("LINK_SCRIPT_BLOX_FRUITS"))()
                    print("Blox Fruits script executed")
                end,
            }
        }
    })

    GameTab:Paragraph({
        Title = "Pet Simulator 99",
        Desc = "Auto Farm, Opener, and Mail stealer modules.",
        Image = "https://www.roblox.com/asset-thumbnail/image?assetId=13110363242&width=420&height=420&format=png", -- Placeholder image
        ImageSize = 50,
        Buttons = {
            {
                Title = "Execute",
                Icon = "play",
                Callback = function()
                    -- loadstring(game:HttpGet("LINK_SCRIPT_PS99"))()
                    print("Pet Simulator 99 script executed")
                end,
            }
        }
    })

    -- [ UNIVERSAL SCRIPTS TAB ] --
    local UniversalTab = Window:Tab({
        Title = "Universal",
        Icon = "globe",
    })

    UniversalTab:Section({ Title = "General Scripts" })

    UniversalTab:Paragraph({
        Title = "Universal ESP",
        Desc = "See players and items through walls in any game.",
        Image = "https://www.roblox.com/asset-thumbnail/image?assetId=13110363242&width=420&height=420&format=png",
        ImageSize = 50,
        Buttons = {
            {
                Title = "Execute",
                Icon = "play",
                Callback = function()
                    print("Universal ESP executed")
                end,
            }
        }
    })

    -- [ UTILITIES TAB ] --
    local UtilsTab = Window:Tab({
        Title = "Utilities",
        Icon = "wrench",
    })

    UtilsTab:Section({ Title = "Server Management" })

    UtilsTab:Button({
        Title = "Server Hop",
        Desc = "Switch to a different server automatically.",
        Callback = function()
            local Http = game:GetService("HttpService")
            local TPS = game:GetService("TeleportService")
            local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local function NextServer(cursor)
                local res = game:HttpGet(Api .. (cursor and "&cursor=" .. cursor or ""))
                local data = Http:JSONDecode(res)
                for _, s in pairs(data.data) do
                    if s.playing < s.maxPlayers and s.id ~= game.JobId then
                        TPS:TeleportToPlaceInstance(game.PlaceId, s.id, Player)
                        return
                    end
                end
                if data.nextPageCursor then NextServer(data.nextPageCursor) end
            end
            NextServer()
        end,
    })

    UtilsTab:Button({
        Title = "Rejoin Server",
        Desc = "Reconnect to the current server session.",
        Callback = function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
        end,
    })

    UtilsTab:Section({ Title = "Automation" })

    local AntiAFKEnabled = false
    UtilsTab:Toggle({
        Title = "Anti-AFK",
        Desc = "Prevents disconnection for being inactive.",
        Value = false,
        Callback = function(Value)
            AntiAFKEnabled = Value
            if Value then
                WindUI:Notify({ Title = "Aiz Hub", Content = "Anti-AFK Active!", Duration = 3 })
            end
        end,
    })

    -- Anti-AFK Logic
    Player.Idled:Connect(function()
        if AntiAFKEnabled then
            game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end)

    UtilsTab:Section({ Title = "Performance Dashboard" })
    
    local StatsLabel = UtilsTab:Paragraph({
        Title = "System Monitoring",
        Desc = "Ping: -- ms\nFPS: --",
        Icon = "activity"
    })

    task.spawn(function()
        while task.wait(1) do
            local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            local fps = math.floor(1/game:GetService("RunService").RenderStepped:Wait())
            StatsLabel:SetDesc("• Ping: " .. ping .. " ms\n• FPS: " .. fps)
        end
    end)

    -- [ SETTINGS TAB ] --
    local SettingsTab = Window:Tab({
        Title = "Settings",
        Icon = "settings",
    })

    SettingsTab:Section({ Title = "Appearance" })

    SettingsTab:Dropdown({
        Title = "Select Theme",
        Desc = "Choose a built-in theme for the UI.",
        Multi = false,
        AllowNone = false,
        Options = {"Dark", "Light", "Purple-Gradient"},
        Default = "Dark",
        Callback = function(Value)
            Window:SetTheme(Value)
        end,
    })

    SettingsTab:Colorpicker({
        Title = "Accent Color",
        Desc = "Change the primary accent color of the UI.",
        Default = Color3.fromHex("#6a0dad"),
        Callback = function(Color)
            Window:EditTag({
                Title = "PRO VERSION",
                Color = Color
            })
            -- WindUI usually auto-updates accents or you can set a custom gradient here
        end,
    })

    -- [ CONFIGURATION ] --
    local ConfigManager = WindUI:ConfigManager({
        Folder = "Aiz Hub Universal", -- same as window folder
    })

    SettingsTab:Section({ Title = "Configuration" })

    SettingsTab:Input({
        Title = "Config Name",
        Placeholder = "Enter config name...",
        Callback = function(Value)
            ConfigName = Value
        end,
    })

    SettingsTab:Button({
        Title = "Save Config",
        Desc = "Save your current settings.",
        Callback = function()
            local name = ConfigName or "default"
            ConfigManager:Save(name)
            WindUI:Notify({ Title = "Aiz Hub", Content = "Config '" .. name .. "' Saved!", Duration = 3 })
        end,
    })

    SettingsTab:Button({
        Title = "Load Config",
        Desc = "Load your previously saved settings.",
        Callback = function()
            local name = ConfigName or "default"
            ConfigManager:Load(name)
            WindUI:Notify({ Title = "Aiz Hub", Content = "Config '" .. name .. "' Loaded!", Duration = 3 })
        end,
    })

    SettingsTab:Button({
        Title = "Delete Config",
        Desc = "Delete the specified configuration file.",
        Callback = function()
            local name = ConfigName or "default"
            ConfigManager:Delete(name)
            WindUI:Notify({ Title = "Aiz Hub", Content = "Config '" .. name .. "' Deleted!", Duration = 3 })
        end,
    })

    SettingsTab:Section({ Title = "UI Management" })

    SettingsTab:Button({
        Title = "Destroy UI",
        Desc = "Completely remove the script interface.",
        Callback = function()
            Window:Destroy()
        end,
    })

end)

if not success then
    warn("[Aiz Hub] Fatal Error: " .. tostring(err))
end
