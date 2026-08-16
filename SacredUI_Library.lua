--[[
    ════════════════════════════════════════════════════════════════════════════════
    🌌 SACRED UI LIBRARY | LIQUID GLASS EDITION (MOBILE & PC) 🌌
    Created by iSacredRivals
    
    A modern, sleek, liquid-glass Roblox UI Library designed for GitHub hosting.
    Features:
    - Translucent Glassmorphism & Cyber Neon Rain
    - VideoFrame / Anime Wallpaper background support
    - Mobile Bottom Dock navigation capsule
    - Floating Draggable Open/Close Button with thumbnail sync
    - Complete Toast Notification system
    - Live dynamic theme customizer (Purple, Blue, Cyan, Red, Emerald, Pink, Orange, White, Rainbow RGB)
    - Components: Tabs, Cards, Toggles, Sliders, Dropdowns, Buttons, TextBoxes, Keybinds, Floating Widgets
    ════════════════════════════════════════════════════════════════════════════════
]]

local SacredUI = {}
SacredUI.__index = SacredUI

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")

local lp = Players.LocalPlayer

-- Safe parent resolver (CoreGui / gethui / PlayerGui)
local parentGui = nil
pcall(function() if gethui then parentGui = gethui() end end)
if not parentGui then pcall(function() parentGui = CoreGui end) end
if not parentGui and lp then pcall(function() parentGui = lp:WaitForChild("PlayerGui", 5) end) end

-- High-Res Clean Roblox Icon Asset IDs
local ICONS = {
    Logo     = "rbxassetid://7733960981",
    Home     = "rbxassetid://7733960981",
    Combat   = "rbxassetid://7733774602",
    Glitches = "rbxassetid://7733799901",
    ESP      = "rbxassetid://7733779610",
    Songs    = "rbxassetid://7733955511",
    Random   = "rbxassetid://7733920644",
    Settings = "rbxassetid://7734053495"
}

-- Wallpapers de Anime
local WALLPAPERS = {
    { name = "Anime 8 (Sacred Default)", id = "rbxassetid://132404081379154" },
    { name = "Anime 1 (Dark Glow)", id = "rbxassetid://79345150236270" },
    { name = "Anime 2 (Cyber Red)", id = "rbxassetid://91081822837053" },
    { name = "Anime 3 (Night City)", id = "rbxassetid://109470605984573" },
    { name = "Anime 4 (Purple Vibe)", id = "rbxassetid://135204446064109" },
    { name = "Anime 5 (Neon Blade)", id = "rbxassetid://133381969265590" },
    { name = "Anime 6 (Shadow Ninja)", id = "rbxassetid://102851043691652" },
    { name = "Anime 7 (Moonlight)", id = "rbxassetid://134915662604167" }
}

local THEMES = {
    ["Purple"]   = Color3.fromRGB(168, 85, 247),
    ["Blue"]     = Color3.fromRGB(59, 130, 246),
    ["Cyan"]     = Color3.fromRGB(6, 182, 212),
    ["Red"]      = Color3.fromRGB(239, 68, 68),
    ["Emerald"]  = Color3.fromRGB(16, 185, 129),
    ["Pink"]     = Color3.fromRGB(236, 72, 153),
    ["Orange"]   = Color3.fromRGB(249, 115, 22),
    ["White"]    = Color3.fromRGB(248, 250, 252),
    ["Rainbow"]  = Color3.fromRGB(168, 85, 247)
}

function SacredUI:CreateWindow(config)
    config = config or {}
    local TitleText = config.Title or "Sacred priv Hub"
    local SubTitleText = config.SubTitle or "by iSacredRivals"
    local DefaultTheme = config.Theme or "Purple"
    local VideoAssetFile = config.VideoBackground or "ashen-one-monochrome-dark-souls-3-moewalls-com.mp4"
    local DefaultWallpaper = config.DefaultWallpaper or WALLPAPERS[1].id
    local ShowIntro = config.ShowIntro ~= false
    local KeybindToggle = config.Keybind or Enum.KeyCode.RightControl

    local Window = {
        CurrentTheme = DefaultTheme,
        CurrentAccent = THEMES[DefaultTheme] or THEMES["Purple"],
        IsRainbow = (DefaultTheme == "Rainbow"),
        CurrentWallpaper = DefaultWallpaper,
        CurrentWallpaperIdx = 1,
        IsRunning = true,
        ActiveConnections = {},
        ThemeStrokes = {},
        ThemeTexts = {},
        ThemeFills = {},
        ThemeActiveToggles = {},
        Pages = {},
        DockButtons = {},
        Widgets = {}
    }

    local function trackConn(conn)
        if conn then table.insert(Window.ActiveConnections, conn) end
        return conn
    end

    function Window:RegisterStroke(stroke)
        table.insert(Window.ThemeStrokes, stroke)
        stroke.Color = Window.CurrentAccent
    end

    function Window:RegisterText(label)
        table.insert(Window.ThemeTexts, label)
        label.TextColor3 = Window.CurrentAccent
    end

    function Window:RegisterFill(frame)
        table.insert(Window.ThemeFills, frame)
        frame.BackgroundColor3 = Window.CurrentAccent
    end

    function Window:SetTheme(name)
        Window.CurrentTheme = name
        Window.IsRainbow = (name == "Rainbow")
        if not Window.IsRainbow then
            Window.CurrentAccent = THEMES[name] or THEMES["Purple"]
            for _, s in ipairs(Window.ThemeStrokes) do if s and s.Parent then s.Color = Window.CurrentAccent end end
            for _, t in ipairs(Window.ThemeTexts) do if t and t.Parent then t.TextColor3 = Window.CurrentAccent end end
            for _, f in ipairs(Window.ThemeFills) do if f and f.Parent then f.BackgroundColor3 = Window.CurrentAccent end end
            for _, t in ipairs(Window.ThemeActiveToggles) do if t and t.Parent then t.BackgroundColor3 = Window.CurrentAccent end end
        end
    end

    trackConn(RunService.Heartbeat:Connect(function()
        if not Window.IsRunning then return end
        if Window.IsRainbow then
            local hue = (os.clock() * 0.4) % 1
            Window.CurrentAccent = Color3.fromHSV(hue, 0.85, 1)
            for _, s in ipairs(Window.ThemeStrokes) do if s and s.Parent then s.Color = Window.CurrentAccent end end
            for _, t in ipairs(Window.ThemeTexts) do if t and t.Parent then t.TextColor3 = Window.CurrentAccent end end
            for _, f in ipairs(Window.ThemeFills) do if f and f.Parent then f.BackgroundColor3 = Window.CurrentAccent end end
            for _, t in ipairs(Window.ThemeActiveToggles) do if t and t.Parent then t.BackgroundColor3 = Window.CurrentAccent end end
        end
    end))

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SacredUI_" .. HttpService:GenerateGUID(false):sub(1, 8)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 10000
    ScreenGui.IgnoreGuiInset = true
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
        ScreenGui.Parent = parentGui
    end)
    Window.ScreenGui = ScreenGui

    -- Toast System
    local ToastContainer = Instance.new("Frame", ScreenGui)
    ToastContainer.Name = "ToastContainer"
    ToastContainer.Size = UDim2.new(0, 220, 1, -40)
    ToastContainer.Position = UDim2.new(1, -235, 0, 20)
    ToastContainer.BackgroundTransparency = 1
    ToastContainer.ZIndex = 500

    local ToastList = Instance.new("UIListLayout", ToastContainer)
    ToastList.SortOrder = Enum.SortOrder.LayoutOrder
    ToastList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    ToastList.Padding = UDim.new(0, 8)

    function Window:Notify(nConfig)
        nConfig = type(nConfig) == "table" and nConfig or { Title = "Sacred UI", Content = tostring(nConfig), Duration = 3 }
        local duration = nConfig.Duration or 3.0
        local toast = Instance.new("Frame", ToastContainer)
        toast.Size = UDim2.new(1, 0, 0, 48)
        toast.BackgroundColor3 = Color3.fromRGB(12, 10, 18)
        toast.BackgroundTransparency = 0.25
        Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 12)

        local stroke = Instance.new("UIStroke", toast)
        stroke.Color = Window.CurrentAccent
        stroke.Thickness = 1
        stroke.Transparency = 0.4
        Window:RegisterStroke(stroke)

        local tLbl = Instance.new("TextLabel", toast)
        tLbl.Size = UDim2.new(1, -24, 0, 16)
        tLbl.Position = UDim2.new(0, 12, 0, 8)
        tLbl.BackgroundTransparency = 1
        tLbl.Text = nConfig.Title or "Notificación"
        tLbl.Font = Enum.Font.GothamBold
        tLbl.TextSize = 11
        tLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        tLbl.TextXAlignment = Enum.TextXAlignment.Left

        local mLbl = Instance.new("TextLabel", toast)
        mLbl.Size = UDim2.new(1, -24, 0, 14)
        mLbl.Position = UDim2.new(0, 12, 0, 24)
        mLbl.BackgroundTransparency = 1
        mLbl.Text = nConfig.Content or ""
        mLbl.Font = Enum.Font.Gotham
        mLbl.TextSize = 9.5
        mLbl.TextColor3 = Color3.fromRGB(180, 175, 195)
        mLbl.TextXAlignment = Enum.TextXAlignment.Left

        TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart), { BackgroundTransparency = 0.25 }):Play()
        task.delay(duration, function()
            if toast and toast.Parent then
                TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart), { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0) }):Play()
                task.wait(0.3)
                toast:Destroy()
            end
        end)
    end

    -- Floating Open Button
    local FloatingOpen = Instance.new("ImageButton", ScreenGui)
    FloatingOpen.Name = "FloatingOpen"
    FloatingOpen.Size = UDim2.new(0, 44, 0, 44)
    FloatingOpen.Position = UDim2.new(0, 15, 0.20, 0)
    FloatingOpen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    FloatingOpen.BackgroundTransparency = 0
    FloatingOpen.Image = Window.CurrentWallpaper
    FloatingOpen.ScaleType = Enum.ScaleType.Crop
    FloatingOpen.AutoButtonColor = false
    FloatingOpen.Active = true
    FloatingOpen.Draggable = true
    FloatingOpen.Visible = false
    Instance.new("UICorner", FloatingOpen).CornerRadius = UDim.new(0, 8)

    local floatStroke = Instance.new("UIStroke", FloatingOpen)
    floatStroke.Color = Window.CurrentAccent
    floatStroke.Thickness = 1.8
    floatStroke.Transparency = 0
    Window:RegisterStroke(floatStroke)
    Window.FloatingOpen = FloatingOpen

    -- Main Window
    local Main = Instance.new("Frame", ScreenGui)
    Main.Name = "MainWindow"
    Main.Size = UDim2.new(0, 440, 0, 300)
    Main.Position = UDim2.new(0.5, -220, 0.5, -150)
    Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Main.BackgroundTransparency = 1
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Active = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 28)

    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Window.CurrentAccent
    MainStroke.Thickness = 1.2
    MainStroke.Transparency = 0.35
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Window:RegisterStroke(MainStroke)
    Window.Main = Main

    -- Video Background & Wallpaper Layer
    local VideoBg = Instance.new("VideoFrame", Main)
    VideoBg.Name = "VideoBackground"
    VideoBg.Size = UDim2.new(1, 0, 1, 0)
    VideoBg.Position = UDim2.new(0, 0, 0, 0)
    VideoBg.BackgroundTransparency = 1
    VideoBg.Looped = true
    VideoBg.Volume = 0
    VideoBg.ZIndex = 0
    VideoBg.Visible = true
    Instance.new("UICorner", VideoBg).CornerRadius = UDim.new(0, 28)

    local FallbackBg = Instance.new("ImageLabel", Main)
    FallbackBg.Name = "FallbackBg"
    FallbackBg.Size = UDim2.new(1, 0, 1, 0)
    FallbackBg.Position = UDim2.new(0, 0, 0, 0)
    FallbackBg.BackgroundTransparency = 1
    FallbackBg.ImageTransparency = 1
    FallbackBg.Image = Window.CurrentWallpaper
    FallbackBg.ScaleType = Enum.ScaleType.Crop
    FallbackBg.ZIndex = 0
    Instance.new("UICorner", FallbackBg).CornerRadius = UDim.new(0, 28)
    Window.FallbackBg = FallbackBg

    task.spawn(function()
        pcall(function()
            local asset = nil
            if getcustomasset then pcall(function() asset = getcustomasset(VideoAssetFile) end)
            elseif getsynasset then pcall(function() asset = getsynasset(VideoAssetFile) end) end

            if asset then
                VideoBg.Video = asset
                VideoBg.Visible = true
                VideoBg:Play()
                FallbackBg.ImageTransparency = 1
            else
                FallbackBg.ImageTransparency = 0
            end
        end)
    end)

    -- Cyber Neon Rain
    local rainContainer = Instance.new("Frame", Main)
    rainContainer.Name = "RainAnimationLayer"
    rainContainer.Size = UDim2.new(1, 0, 1, 0)
    rainContainer.BackgroundTransparency = 1
    rainContainer.ClipsDescendants = true
    rainContainer.ZIndex = 1
    Instance.new("UICorner", rainContainer).CornerRadius = UDim.new(0, 28)

    local activeRainDrops = 0
    local function createIntenseRainDrop()
        if not Window.IsRunning or not Main.Visible or activeRainDrops >= 12 then return end
        activeRainDrops = activeRainDrops + 1
        local drop = Instance.new("Frame", rainContainer)
        drop.Size = UDim2.new(0, 2, 0, math.random(14, 26))
        drop.Position = UDim2.new(math.random(1, 99) / 100, 0, -0.15, 0)
        drop.BackgroundColor3 = Window.CurrentAccent
        drop.BackgroundTransparency = math.random(2, 5) / 10
        drop.BorderSizePixel = 0
        Instance.new("UICorner", drop).CornerRadius = UDim.new(1, 0)

        local targetX = drop.Position.X.Scale - (math.random(3, 8) / 100)
        local duration = math.random(4, 9) / 10
        local tw = TweenService:Create(drop, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Position = UDim2.new(targetX, 0, 1.15, 0),
            BackgroundTransparency = 1
        })
        tw:Play()
        tw.Completed:Connect(function() activeRainDrops = activeRainDrops - 1; drop:Destroy() end)
    end

    task.spawn(function()
        while Window.IsRunning do
            task.wait(0.04)
            pcall(createIntenseRainDrop)
        end
    end)

    -- Header
    local Header = Instance.new("Frame", Main)
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 42)
    Header.BackgroundTransparency = 1
    Header.ZIndex = 4

    local LogoBadge = Instance.new("ImageLabel", Header)
    LogoBadge.Name = "HeaderWallpaperLogo"
    LogoBadge.Size = UDim2.new(0, 24, 0, 24)
    LogoBadge.Position = UDim2.new(0, 16, 0.5, -12)
    LogoBadge.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    LogoBadge.BackgroundTransparency = 0
    LogoBadge.Image = Window.CurrentWallpaper
    LogoBadge.ScaleType = Enum.ScaleType.Crop
    Instance.new("UICorner", LogoBadge).CornerRadius = UDim.new(0, 7)
    local lStroke = Instance.new("UIStroke", LogoBadge)
    lStroke.Color = Window.CurrentAccent; lStroke.Thickness = 1
    Window:RegisterStroke(lStroke)
    Window.LogoBadge = LogoBadge

    local Title = Instance.new("TextLabel", Header)
    Title.Position = UDim2.new(0, 48, 0, 6)
    Title.Size = UDim2.new(0, 130, 0, 16)
    Title.BackgroundTransparency = 1
    Title.Text = TitleText
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local SubTitle = Instance.new("TextLabel", Header)
    SubTitle.Position = UDim2.new(0, 48, 0, 22)
    SubTitle.Size = UDim2.new(0, 140, 0, 12)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = SubTitleText
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextSize = 8.5
    SubTitle.TextColor3 = Window.CurrentAccent
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    Window:RegisterText(SubTitle)

    -- Window Controls
    local function createHeaderBtn(symbol, offsetRight, color, callback)
        local btn = Instance.new("TextButton", Header)
        btn.Size = UDim2.new(0, 24, 0, 24)
        btn.Position = UDim2.new(1, offsetRight, 0.5, -12)
        btn.BackgroundColor3 = Color3.fromRGB(15, 12, 22)
        btn.BackgroundTransparency = 0.5
        btn.Text = symbol
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.TextColor3 = color
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
        local str = Instance.new("UIStroke", btn)
        str.Color = color; str.Thickness = 1
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    function Window:Minimize()
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.25)
        Main.Visible = false
        FloatingOpen.Visible = true
        Window:Notify({ Title = TitleText, Content = "Minimizado. Toca el botón flotante para reabrir.", Duration = 2.5 })
    end

    function Window:Maximize()
        FloatingOpen.Visible = false
        Main.Visible = true
        Main.Size = UDim2.new(0, 0, 0, 0)
        Main.Position = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 440, 0, 300), Position = UDim2.new(0.5, -220, 0.5, -150)
        }):Play()
    end

    function Window:Toggle()
        if Main.Visible then Window:Minimize() else Window:Maximize() end
    end

    function Window:Destroy()
        Window.IsRunning = false
        for _, c in ipairs(Window.ActiveConnections) do pcall(function() c:Disconnect() end) end
        pcall(function() ScreenGui:Destroy() end)
        for _, w in ipairs(Window.Widgets) do pcall(function() w:Destroy() end) end
    end

    createHeaderBtn("−", -60, Color3.fromRGB(255, 255, 255), function() Window:Minimize() end)
    createHeaderBtn("✕", -30, Color3.fromRGB(255, 75, 75), function() Window:Destroy() end)
    FloatingOpen.MouseButton1Click:Connect(function() Window:Maximize() end)

    -- Hotkey Toggle
    trackConn(UserInputService.InputBegan:Connect(function(input, gp)
        if gp or UserInputService:GetFocusedTextBox() then return end
        if input.KeyCode == KeybindToggle then Window:Toggle() end
    end))

    -- Dragging
    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)

    -- Page Container
    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Name = "PageContainer"
    PageContainer.Size = UDim2.new(1, -20, 1, -94)
    PageContainer.Position = UDim2.new(0, 10, 0, 44)
    PageContainer.BackgroundTransparency = 1
    PageContainer.ZIndex = 4
    Window.PageContainer = PageContainer

    -- Bottom Dock Capsule
    local BottomDock = Instance.new("Frame", Main)
    BottomDock.Name = "BottomDock"
    BottomDock.Size = UDim2.new(0, 320, 0, 36)
    BottomDock.Position = UDim2.new(0.5, -160, 1, -40)
    BottomDock.BackgroundColor3 = Color3.fromRGB(10, 8, 16)
    BottomDock.BackgroundTransparency = 0.5
    Instance.new("UICorner", BottomDock).CornerRadius = UDim.new(0, 18)
    local dockStroke = Instance.new("UIStroke", BottomDock)
    dockStroke.Color = Window.CurrentAccent; dockStroke.Thickness = 1.2; dockStroke.Transparency = 0.4
    Window:RegisterStroke(dockStroke)

    local DockLayout = Instance.new("UIListLayout", BottomDock)
    DockLayout.FillDirection = Enum.FillDirection.Horizontal
    DockLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    DockLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    DockLayout.Padding = UDim.new(0, 5)
    Window.BottomDock = BottomDock

    -- Create Tab Method
    function Window:CreateTab(tConfig)
        tConfig = tConfig or {}
        local tabName = tConfig.Name or "Tab"
        local tabIcon = tConfig.Icon or ICONS.Home
        if ICONS[tabIcon] then tabIcon = ICONS[tabIcon] end

        local page = Instance.new("ScrollingFrame", PageContainer)
        page.Name = tabName .. "Page"
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 2
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Visible = false
        page.ZIndex = 5

        local pList = Instance.new("UIListLayout", page)
        pList.SortOrder = Enum.SortOrder.LayoutOrder
        pList.Padding = UDim.new(0, 6)
        Instance.new("UIPadding", page).PaddingRight = UDim.new(0, 4)

        local dockBtn = Instance.new("ImageButton", BottomDock)
        dockBtn.Size = UDim2.new(0, 38, 0, 26)
        dockBtn.BackgroundColor3 = Window.CurrentAccent
        dockBtn.BackgroundTransparency = 1
        dockBtn.AutoButtonColor = false
        Instance.new("UICorner", dockBtn).CornerRadius = UDim.new(0, 8)

        local iconImg = Instance.new("ImageLabel", dockBtn)
        iconImg.Size = UDim2.new(0, 16, 0, 16)
        iconImg.Position = UDim2.new(0.5, -8, 0.5, -8)
        iconImg.BackgroundTransparency = 1
        iconImg.Image = tabIcon
        iconImg.ImageColor3 = Color3.fromRGB(180, 175, 195)

        local function selectTab()
            for _, p in pairs(Window.Pages) do p.Visible = false end
            for _, dbtn in pairs(Window.DockButtons) do
                TweenService:Create(dbtn.btn, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
                TweenService:Create(dbtn.icon, TweenInfo.new(0.2), { ImageColor3 = Color3.fromRGB(180, 175, 195) }):Play()
            end
            page.Visible = true
            TweenService:Create(dockBtn, TweenInfo.new(0.2), { BackgroundTransparency = 0.7 }):Play()
            TweenService:Create(iconImg, TweenInfo.new(0.2), { ImageColor3 = Window.CurrentAccent }):Play()
        end

        dockBtn.MouseButton1Click:Connect(selectTab)
        Window.Pages[tabName] = page
        Window.DockButtons[tabName] = { btn = dockBtn, icon = iconImg }

        -- If first tab, select it
        local tabCount = 0
        for _ in pairs(Window.Pages) do tabCount = tabCount + 1 end
        if tabCount == 1 then selectTab() end

        local Tab = { Page = page, Window = Window }

        -- Create Card inside Tab
        function Tab:CreateCard(cConfig)
            cConfig = type(cConfig) == "table" and cConfig or { Title = cConfig }
            local cardTitle = cConfig.Title

            local card = Instance.new("Frame", page)
            card.Size = UDim2.new(1, 0, 0, 0)
            card.AutomaticSize = Enum.AutomaticSize.Y
            card.BackgroundColor3 = Color3.fromRGB(10, 8, 16)
            card.BackgroundTransparency = 0.75
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

            local stroke = Instance.new("UIStroke", card)
            stroke.Color = Window.CurrentAccent
            stroke.Thickness = 0.9
            stroke.Transparency = 0.65
            Window:RegisterStroke(stroke)

            local pad = Instance.new("UIPadding", card)
            pad.PaddingTop = UDim.new(0, 6)
            pad.PaddingBottom = UDim.new(0, 6)
            pad.PaddingLeft = UDim.new(0, 8)
            pad.PaddingRight = UDim.new(0, 8)

            local list = Instance.new("UIListLayout", card)
            list.SortOrder = Enum.SortOrder.LayoutOrder
            list.Padding = UDim.new(0, 5)

            if cardTitle then
                local header = Instance.new("TextLabel", card)
                header.Size = UDim2.new(1, 0, 0, 15)
                header.BackgroundTransparency = 1
                header.Text = "● " .. cardTitle
                header.Font = Enum.Font.GothamBold
                header.TextSize = 10
                header.TextColor3 = Window.CurrentAccent
                header.TextXAlignment = Enum.TextXAlignment.Left
                Window:RegisterText(header)
            end

            local CardObj = { Frame = card, Window = Window }

            -- Create Toggle
            function CardObj:CreateToggle(toggleConfig)
                toggleConfig = toggleConfig or {}
                local title = toggleConfig.Name or "Toggle"
                local desc = toggleConfig.Description
                local state = toggleConfig.Default or false
                local cb = toggleConfig.Callback

                local row = Instance.new("TextButton", card)
                row.Size = UDim2.new(1, 0, 0, desc and 34 or 26)
                row.BackgroundTransparency = 1
                row.Text = ""
                row.AutoButtonColor = false
                row.Active = true

                local tLbl = Instance.new("TextLabel", row)
                tLbl.Size = UDim2.new(1, -45, 0, 14)
                tLbl.Position = UDim2.new(0, 0, 0, 0)
                tLbl.BackgroundTransparency = 1
                tLbl.Text = title
                tLbl.Font = Enum.Font.GothamSemibold
                tLbl.TextSize = 10
                tLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                tLbl.TextXAlignment = Enum.TextXAlignment.Left
                tLbl.Active = false

                if desc then
                    local dLbl = Instance.new("TextLabel", row)
                    dLbl.Size = UDim2.new(1, -45, 0, 12)
                    dLbl.Position = UDim2.new(0, 0, 0, 15)
                    dLbl.BackgroundTransparency = 1
                    dLbl.Text = desc
                    dLbl.Font = Enum.Font.Gotham
                    dLbl.TextSize = 8
                    dLbl.TextColor3 = Color3.fromRGB(150, 145, 165)
                    dLbl.TextXAlignment = Enum.TextXAlignment.Left
                    dLbl.Active = false
                end

                local switch = Instance.new("Frame", row)
                switch.Size = UDim2.new(0, 32, 0, 16)
                switch.Position = UDim2.new(1, -34, 0.5, -8)
                switch.BackgroundColor3 = state and Window.CurrentAccent or Color3.fromRGB(35, 35, 48)
                Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
                switch.Active = false

                if state then table.insert(Window.ThemeActiveToggles, switch) end

                local knob = Instance.new("Frame", switch)
                knob.Size = UDim2.new(0, 12, 0, 12)
                knob.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
                knob.Active = false

                local function setVal(v)
                    state = v
                    TweenService:Create(switch, TweenInfo.new(0.2), {
                        BackgroundColor3 = state and Window.CurrentAccent or Color3.fromRGB(35, 35, 48)
                    }):Play()
                    TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                    }):Play()
                    if cb then pcall(cb, state) end
                end

                row.MouseButton1Click:Connect(function() setVal(not state) end)

                local ToggleObj = {}
                function ToggleObj:Set(v) setVal(v) end
                function ToggleObj:Get() return state end
                return ToggleObj
            end

            -- Create Slider
            function CardObj:CreateSlider(sConfig)
                sConfig = sConfig or {}
                local title = sConfig.Name or "Slider"
                local minVal = sConfig.Min or 0
                local maxVal = sConfig.Max or 100
                local defaultVal = sConfig.Default or minVal
                local stepVal = sConfig.Step or 1
                local suffix = sConfig.Suffix or ""
                local cb = sConfig.Callback
                local val = defaultVal

                local row = Instance.new("Frame", card)
                row.Size = UDim2.new(1, 0, 0, 32)
                row.BackgroundTransparency = 1

                local tLbl = Instance.new("TextLabel", row)
                tLbl.Size = UDim2.new(0.7, 0, 0, 14)
                tLbl.BackgroundTransparency = 1
                tLbl.Text = title
                tLbl.Font = Enum.Font.GothamSemibold
                tLbl.TextSize = 10
                tLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                tLbl.TextXAlignment = Enum.TextXAlignment.Left

                local vLbl = Instance.new("TextLabel", row)
                vLbl.Size = UDim2.new(0.3, 0, 0, 14)
                vLbl.Position = UDim2.new(0.7, 0, 0, 0)
                vLbl.BackgroundTransparency = 1
                vLbl.Text = tostring(val) .. suffix
                vLbl.Font = Enum.Font.GothamBold
                vLbl.TextSize = 9.5
                vLbl.TextColor3 = Window.CurrentAccent
                vLbl.TextXAlignment = Enum.TextXAlignment.Right
                Window:RegisterText(vLbl)

                local track = Instance.new("Frame", row)
                track.Size = UDim2.new(1, 0, 0, 5)
                track.Position = UDim2.new(0, 0, 0, 19)
                track.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
                Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

                local fill = Instance.new("Frame", track)
                fill.Size = UDim2.new((val - minVal) / (maxVal - minVal), 0, 1, 0)
                fill.BackgroundColor3 = Window.CurrentAccent
                Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
                Window:RegisterFill(fill)

                local handle = Instance.new("Frame", track)
                handle.Size = UDim2.new(0, 10, 0, 10)
                handle.AnchorPoint = Vector2.new(0.5, 0.5)
                handle.Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0)
                handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)

                local isSliding = false
                local function updateFromPos(inputX)
                    local rel = math.clamp((inputX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    val = math.clamp(math.floor((minVal + rel * (maxVal - minVal)) / stepVal + 0.5) * stepVal, minVal, maxVal)
                    vLbl.Text = tostring(val) .. suffix
                    fill.Size = UDim2.new((val - minVal) / (maxVal - minVal), 0, 1, 0)
                    handle.Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0)
                    if cb then pcall(cb, val) end
                end

                track.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        isSliding = true; updateFromPos(inp.Position.X)
                    end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if isSliding and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                        updateFromPos(inp.Position.X)
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        isSliding = false
                    end
                end)

                local SliderObj = {}
                function SliderObj:Set(v)
                    val = math.clamp(v, minVal, maxVal)
                    vLbl.Text = tostring(val) .. suffix
                    fill.Size = UDim2.new((val - minVal) / (maxVal - minVal), 0, 1, 0)
                    handle.Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0)
                    if cb then pcall(cb, val) end
                end
                function SliderObj:Get() return val end
                return SliderObj
            end

            -- Create Dropdown
            function CardObj:CreateDropdown(dConfig)
                dConfig = dConfig or {}
                local title = dConfig.Name or "Dropdown"
                local options = dConfig.Options or {"Option 1"}
                local defaultOpt = dConfig.Default or options[1]
                local cb = dConfig.Callback

                local curIdx = 1
                for i, o in ipairs(options) do if o == defaultOpt then curIdx = i break end end

                local btn = Instance.new("TextButton", card)
                btn.Size = UDim2.new(1, 0, 0, 26)
                btn.BackgroundColor3 = Color3.fromRGB(18, 15, 26)
                btn.BackgroundTransparency = 0.6
                btn.Text = title .. ": " .. tostring(options[curIdx])
                btn.Font = Enum.Font.GothamSemibold
                btn.TextSize = 9.5
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.AutoButtonColor = false
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
                local bStroke = Instance.new("UIStroke", btn)
                bStroke.Color = Window.CurrentAccent; bStroke.Thickness = 0.9; bStroke.Transparency = 0.65
                Window:RegisterStroke(bStroke)

                btn.MouseButton1Click:Connect(function()
                    curIdx = (curIdx % #options) + 1
                    local selected = options[curIdx]
                    btn.Text = title .. ": " .. tostring(selected)
                    if cb then pcall(cb, selected) end
                end)

                local DropdownObj = {}
                function DropdownObj:Set(selected)
                    for i, o in ipairs(options) do
                        if o == selected then
                            curIdx = i; btn.Text = title .. ": " .. tostring(selected)
                            if cb then pcall(cb, selected) end
                            break
                        end
                    end
                end
                function DropdownObj:Refresh(newOptions)
                    options = newOptions
                    curIdx = 1
                    btn.Text = title .. ": " .. tostring(options[1] or "None")
                end
                return DropdownObj
            end

            -- Create Button
            function CardObj:CreateButton(bConfig)
                bConfig = type(bConfig) == "table" and bConfig or { Name = bConfig }
                local btnText = bConfig.Name or "Button"
                local cb = bConfig.Callback

                local btn = Instance.new("TextButton", card)
                btn.Size = UDim2.new(1, 0, 0, 26)
                btn.BackgroundColor3 = Color3.fromRGB(20, 18, 30)
                btn.BackgroundTransparency = 0.6
                btn.Text = btnText
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 10
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.AutoButtonColor = false
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
                local bStroke = Instance.new("UIStroke", btn)
                bStroke.Color = Window.CurrentAccent; bStroke.Thickness = 1
                Window:RegisterStroke(bStroke)

                btn.MouseButton1Click:Connect(function()
                    TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundTransparency = 0.2 }):Play()
                    task.delay(0.12, function()
                        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.6 }):Play()
                    end)
                    if cb then pcall(cb) end
                end)
                return btn
            end

            -- Create TextBox
            function CardObj:CreateTextBox(tbConfig)
                tbConfig = tbConfig or {}
                local title = tbConfig.Name or "Input"
                local placeholder = tbConfig.Placeholder or "Enter text..."
                local defaultText = tbConfig.Default or ""
                local cb = tbConfig.Callback

                local box = Instance.new("TextBox", card)
                box.Size = UDim2.new(1, 0, 0, 26)
                box.BackgroundColor3 = Color3.fromRGB(18, 15, 26)
                box.BackgroundTransparency = 0.6
                box.PlaceholderText = placeholder
                box.Text = defaultText
                box.Font = Enum.Font.GothamMedium
                box.TextSize = 9.5
                box.TextColor3 = Color3.fromRGB(255, 255, 255)
                box.PlaceholderColor3 = Color3.fromRGB(150, 145, 165)
                Instance.new("UICorner", box).CornerRadius = UDim.new(0, 7)
                local bStroke = Instance.new("UIStroke", box)
                bStroke.Color = Color3.fromRGB(50, 45, 70); bStroke.Thickness = 1

                box.FocusLost:Connect(function(enterPressed)
                    if cb then pcall(cb, box.Text, enterPressed) end
                end)
                return box
            end

            return CardObj
        end

        return Tab
    end

    -- Create Floating Draggable Widget Method
    function Window:CreateWidget(wConfig)
        wConfig = wConfig or {}
        local wTitle = wConfig.Title or "Widget"
        local wPos = wConfig.Position or UDim2.new(0.72, 0, 0.35, 0)
        local cb = wConfig.Callback

        local widgetGui = Instance.new("ScreenGui")
        widgetGui.Name = "SacredUI_Widget"
        widgetGui.ResetOnSpawn = false
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(widgetGui) end widgetGui.Parent = parentGui end)

        local btn = Instance.new("TextButton", widgetGui)
        btn.Size = UDim2.new(0, 115, 0, 36)
        btn.Position = wPos
        btn.BackgroundColor3 = Color3.fromRGB(14, 12, 22)
        btn.BackgroundTransparency = 0.35
        btn.Text = wTitle
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10.5
        btn.TextColor3 = Window.CurrentAccent
        btn.Active = true
        btn.Draggable = true
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        local sStroke = Instance.new("UIStroke", btn)
        sStroke.Color = Window.CurrentAccent; sStroke.Thickness = 1.2
        Window:RegisterStroke(sStroke)
        Window:RegisterText(btn)

        btn.MouseButton1Click:Connect(function()
            if cb then pcall(cb) end
        end)

        table.insert(Window.Widgets, widgetGui)
        local WidgetObj = { Gui = widgetGui, Button = btn }
        function WidgetObj:Destroy() widgetGui:Destroy() end
        function WidgetObj:SetVisible(v) btn.Visible = v end
        return WidgetObj
    end

    -- Play Intro and Open
    if ShowIntro then
        playSacredIntro(function()
            Window:Maximize()
            Window:Notify({ Title = TitleText, Content = "UI cargada con éxito.", Duration = 2.5 })
        end)
    else
        Window:Maximize()
    end

    return Window
end

return SacredUI
