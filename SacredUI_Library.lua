--[[
    ════════════════════════════════════════════════════════════════════════════════
    🌌 SACRED PRIV HUB | UI FOUNDATION & ANIMATED BACKGROUND 🌌
    - Pure Liquid Glass Theme with 100% Transparent Surfaces
    - Animated Video Background (ashen-one-monochrome-dark-souls-3-moewalls-com.mp4)
    - Cyber Neon Rain Animation Layer
    - Header: "Sacred priv Hub" with Active Wallpaper Thumbnail Logo
    - Full Close (✕) & Minimize (−) Controls
    - Floating Open Button (Top-Left 0.20 Y)
    - Bottom Dock Navigation Capsule (Clean Roblox Asset Icons)
    - Toast Notification System & Live Theme Manager
    - Clean empty tabs ready to build functions one-by-one
    ════════════════════════════════════════════════════════════════════════════════
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")

local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Safe parent resolver (CoreGui / gethui / PlayerGui)
local parentGui = nil
pcall(function() if gethui then parentGui = gethui() end end)
if not parentGui then pcall(function() parentGui = CoreGui end) end
if not parentGui and lp then pcall(function() parentGui = lp:WaitForChild("PlayerGui", 5) end) end

-- Global cleanup helper
local IsScriptRunning = true
local ActiveConnections = {}
local function trackConn(conn)
    if conn then table.insert(ActiveConnections, conn) end
    return conn
end

-- Cleanup previous instances
pcall(function()
    local target = parentGui or (lp and lp:FindFirstChild("PlayerGui"))
    if target then
        for _, old in ipairs(target:GetChildren()) do
            if old.Name:find("Sacred") or old.Name:find("FOV_System") then
                old:Destroy()
            end
        end
    end
end)

-- ============================================================
-- 🎨 DYNAMIC THEME SYSTEM & WALLPAPERS
-- ============================================================
local THEMES = {
    ["Purple"]   = Color3.fromRGB(168, 85, 247),  -- Neon Violet (#A855F7)
    ["Blue"]     = Color3.fromRGB(59, 130, 246),  -- Electric Blue (#3B82F6)
    ["Cyan"]     = Color3.fromRGB(6, 182, 212),   -- Aqua Cyan (#06B6D4)
    ["Red"]      = Color3.fromRGB(239, 68, 68),   -- Crimson Red (#EF4444)
    ["Emerald"]  = Color3.fromRGB(16, 185, 129),  -- Toxic Emerald (#10B981)
    ["Pink"]     = Color3.fromRGB(236, 72, 153),  -- Hot Pink (#EC4899)
    ["Orange"]   = Color3.fromRGB(249, 115, 22),  -- Sunset Orange (#F97316)
    ["White"]    = Color3.fromRGB(248, 250, 252), -- Snow White (#F8FAFC)
    ["Rainbow"]  = Color3.fromRGB(168, 85, 247)
}

local CurrentThemeName = "Purple"
local CurrentAccent = THEMES["Purple"]
local IsRainbowTheme = false

local ThemeStrokes = {}
local ThemeTexts = {}
local ThemeFills = {}
local ThemeActiveToggles = {}

local function RegisterThemeStroke(stroke)
    table.insert(ThemeStrokes, stroke)
    stroke.Color = CurrentAccent
end

local function RegisterThemeText(label)
    table.insert(ThemeTexts, label)
    label.TextColor3 = CurrentAccent
end

local function RegisterThemeFill(frame)
    table.insert(ThemeFills, frame)
    frame.BackgroundColor3 = CurrentAccent
end

local function ApplyTheme(name)
    CurrentThemeName = name
    IsRainbowTheme = (name == "Rainbow")
    if not IsRainbowTheme then
        CurrentAccent = THEMES[name] or THEMES["Purple"]
        for _, s in ipairs(ThemeStrokes) do if s and s.Parent then s.Color = CurrentAccent end end
        for _, t in ipairs(ThemeTexts) do if t and t.Parent then t.TextColor3 = CurrentAccent end end
        for _, f in ipairs(ThemeFills) do if f and f.Parent then f.BackgroundColor3 = CurrentAccent end end
        for _, t in ipairs(ThemeActiveToggles) do if t and t.Parent then t.BackgroundColor3 = CurrentAccent end end
    end
end

trackConn(RunService.Heartbeat:Connect(function()
    if not IsScriptRunning then return end
    if IsRainbowTheme then
        local hue = (os.clock() * 0.4) % 1
        CurrentAccent = Color3.fromHSV(hue, 0.85, 1)
        for _, s in ipairs(ThemeStrokes) do if s and s.Parent then s.Color = CurrentAccent end end
        for _, t in ipairs(ThemeTexts) do if t and t.Parent then t.TextColor3 = CurrentAccent end end
        for _, f in ipairs(ThemeFills) do if f and f.Parent then f.BackgroundColor3 = CurrentAccent end end
        for _, t in ipairs(ThemeActiveToggles) do if t and t.Parent then t.BackgroundColor3 = CurrentAccent end end
    end
end))

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
    { name = "Anime 8 (Sacred Default)", id = "rbxassetid://103674761222554" },
    { name = "Anime 1 (Dark Glow)", id = "rbxassetid://79345150236270" },
    { name = "Anime 2 (Cyber Red)", id = "rbxassetid://91081822837053" },
    { name = "Anime 3 (Night City)", id = "rbxassetid://109470605984573" },
    { name = "Anime 4 (Purple Vibe)", id = "rbxassetid://135204446064109" },
    { name = "Anime 5 (Neon Blade)", id = "rbxassetid://133381969265590" },
    { name = "Anime 6 (Shadow Ninja)", id = "rbxassetid://102851043691652" },
    { name = "Anime 7 (Moonlight)", id = "rbxassetid://134915662604167" }
}
local currentBgIdx = 1

-- ============================================================
-- 🎬 INTRO CINEMÁTICA ELEGANTE
-- ============================================================
local function playSacredIntro(onFinish)
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "Sacred_IntroGui"
    introGui.DisplayOrder = 999999
    introGui.IgnoreGuiInset = true
    introGui.ResetOnSpawn = false
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(introGui) end
        introGui.Parent = parentGui
    end)

    local bg = Instance.new("Frame", introGui)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(4, 4, 8)
    bg.BackgroundTransparency = 0.2
    bg.BorderSizePixel = 0

    local center = Instance.new("Frame", bg)
    center.AnchorPoint = Vector2.new(0.5, 0.5)
    center.Position = UDim2.new(0.5, 0, 0.5, 0)
    center.Size = UDim2.new(0, 360, 0, 130)
    center.BackgroundTransparency = 1

    local scale = Instance.new("UIScale", center)
    scale.Scale = 0.65

    local logoImg = Instance.new("ImageLabel", center)
    logoImg.Size = UDim2.new(0, 42, 0, 42)
    logoImg.Position = UDim2.new(0.5, -21, 0, 0)
    logoImg.BackgroundTransparency = 1
    logoImg.Image = WALLPAPERS[1].id
    logoImg.ScaleType = Enum.ScaleType.Crop
    Instance.new("UICorner", logoImg).CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel", center)
    title.Size = UDim2.new(1, 0, 0, 34)
    title.Position = UDim2.new(0, 0, 0, 46)
    title.BackgroundTransparency = 1
    title.Text = "Sacred priv Hub"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 26
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextTransparency = 1

    local sub = Instance.new("TextLabel", center)
    sub.Size = UDim2.new(1, 0, 0, 20)
    sub.Position = UDim2.new(0, 0, 0, 80)
    sub.BackgroundTransparency = 1
    sub.Text = "by iSacredRivals"
    sub.Font = Enum.Font.GothamMedium
    sub.TextSize = 11
    sub.TextColor3 = CurrentAccent
    sub.TextTransparency = 1

    local halo = Instance.new("Frame", bg)
    halo.AnchorPoint = Vector2.new(0.5, 0.5)
    halo.Position = UDim2.new(0.5, 0, 0.5, 0)
    halo.Size = UDim2.new(0, 80, 0, 80)
    halo.BackgroundTransparency = 1
    Instance.new("UICorner", halo).CornerRadius = UDim.new(1, 0)
    local haloStroke = Instance.new("UIStroke", halo)
    haloStroke.Color = CurrentAccent
    haloStroke.Thickness = 1.8
    haloStroke.Transparency = 0.2

    task.spawn(function()
        TweenService:Create(scale, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1.0 }):Play()
        TweenService:Create(title, TweenInfo.new(0.45), { TextTransparency = 0 }):Play()
        TweenService:Create(sub, TweenInfo.new(0.45), { TextTransparency = 0 }):Play()
        TweenService:Create(halo, TweenInfo.new(0.85, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(0, 480, 0, 480) }):Play()
        TweenService:Create(haloStroke, TweenInfo.new(0.85), { Transparency = 1 }):Play()

        task.wait(1.2)

        TweenService:Create(scale, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Scale = 1.25 }):Play()
        TweenService:Create(title, TweenInfo.new(0.35), { TextTransparency = 1 }):Play()
        TweenService:Create(sub, TweenInfo.new(0.35), { TextTransparency = 1 }):Play()
        TweenService:Create(logoImg, TweenInfo.new(0.35), { ImageTransparency = 1 }):Play()
        TweenService:Create(bg, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()

        task.wait(0.4)
        introGui:Destroy()
        if onFinish then onFinish() end
    end)
end

-- ============================================================
-- 📱 FRAMEWORK UI: SACRED PREMIUM LIQUID GLASS
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SacredUltimateUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 10000
ScreenGui.IgnoreGuiInset = true
pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = parentGui
end)

-- Sistema Toast de Notificaciones
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

local function Notify(titleText, msgText, duration)
    duration = duration or 3.0
    local toast = Instance.new("Frame", ToastContainer)
    toast.Size = UDim2.new(1, 0, 0, 48)
    toast.BackgroundColor3 = Color3.fromRGB(12, 10, 18)
    toast.BackgroundTransparency = 0.25
    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", toast)
    stroke.Color = CurrentAccent
    stroke.Thickness = 1
    stroke.Transparency = 0.4
    RegisterThemeStroke(stroke)

    local tLbl = Instance.new("TextLabel", toast)
    tLbl.Size = UDim2.new(1, -24, 0, 16)
    tLbl.Position = UDim2.new(0, 12, 0, 8)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = titleText
    tLbl.Font = Enum.Font.GothamBold
    tLbl.TextSize = 11
    tLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    tLbl.TextXAlignment = Enum.TextXAlignment.Left

    local mLbl = Instance.new("TextLabel", toast)
    mLbl.Size = UDim2.new(1, -24, 0, 14)
    mLbl.Position = UDim2.new(0, 12, 0, 24)
    mLbl.BackgroundTransparency = 1
    mLbl.Text = msgText
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

-- Botón Flotante para Abrir la UI (Posición: UDim2.new(0, 15, 0.20, 0))
local FloatingOpen = Instance.new("ImageButton", ScreenGui)
FloatingOpen.Name = "FloatingOpen"
FloatingOpen.Size = UDim2.new(0, 44, 0, 44)
FloatingOpen.Position = UDim2.new(0, 15, 0.20, 0)
FloatingOpen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FloatingOpen.BackgroundTransparency = 0
FloatingOpen.Image = WALLPAPERS[1].id
FloatingOpen.ScaleType = Enum.ScaleType.Crop
FloatingOpen.AutoButtonColor = false
FloatingOpen.Active = true
FloatingOpen.Draggable = true
FloatingOpen.Visible = false
Instance.new("UICorner", FloatingOpen).CornerRadius = UDim.new(0, 8)

local floatStroke = Instance.new("UIStroke", FloatingOpen)
floatStroke.Color = CurrentAccent
floatStroke.Thickness = 1.8
floatStroke.Transparency = 0
RegisterThemeStroke(floatStroke)

-- Ventana Principal (Liquid Glass Compact 440x300)
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "SacredMainWindow"
Main.Size = UDim2.new(0, 440, 0, 300)
Main.Position = UDim2.new(0.5, -220, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BackgroundTransparency = 1 -- Totalmente transparente para mostrar el video animado directamente
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 28)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = CurrentAccent
MainStroke.Thickness = 1.2
MainStroke.Transparency = 0.35
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
RegisterThemeStroke(MainStroke)

-- 🎥 VIDEO ANIMADO MP4 DE FONDO DIRECTO
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
FallbackBg.ImageTransparency = 1 -- Por defecto transparente para no tapar el video
FallbackBg.Image = WALLPAPERS[1].id
FallbackBg.ScaleType = Enum.ScaleType.Crop
FallbackBg.ZIndex = 0
Instance.new("UICorner", FallbackBg).CornerRadius = UDim.new(0, 28)

-- Intentar cargar el video animado local MP4
task.spawn(function()
    pcall(function()
        local vidNames = {
            "ashen-one-monochrome-dark-souls-3-moewalls-com.mp4",
            "ashen-one-monochrome-dark-souls-3-moewalls-com",
            "ashen_one.mp4"
        }
        local asset = nil
        for _, name in ipairs(vidNames) do
            if getcustomasset then
                pcall(function() asset = getcustomasset(name) end)
            elseif getsynasset then
                pcall(function() asset = getsynasset(name) end)
            end
            if asset then break end
        end

        if asset then
            VideoBg.Video = asset
            VideoBg.Visible = true
            VideoBg:Play()
            FallbackBg.ImageTransparency = 1
            print("🎬 Video animado cargado con éxito en VideoFrame!")
        else
            FallbackBg.ImageTransparency = 0
            print("📷 No se encontró el archivo MP4 local, mostrando Wallpaper de alta resolución.")
        end
    end)
end)

-- Capa de Lluvia Cyber Neon Animada
local rainContainer = Instance.new("Frame", Main)
rainContainer.Name = "RainAnimationLayer"
rainContainer.Size = UDim2.new(1, 0, 1, 0)
rainContainer.BackgroundTransparency = 1
rainContainer.ClipsDescendants = true
rainContainer.ZIndex = 1
Instance.new("UICorner", rainContainer).CornerRadius = UDim.new(0, 28)

local activeRainDrops = 0
local function createIntenseRainDrop()
    if not IsScriptRunning or not Main.Visible or activeRainDrops >= 12 then return end
    activeRainDrops = activeRainDrops + 1
    local drop = Instance.new("Frame", rainContainer)
    drop.Size = UDim2.new(0, 2, 0, math.random(14, 26))
    drop.Position = UDim2.new(math.random(1, 99) / 100, 0, -0.15, 0)
    drop.BackgroundColor3 = CurrentAccent
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
    while IsScriptRunning do
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

-- Logo Icon con la miniatura del fondo
local LogoBadge = Instance.new("ImageLabel", Header)
LogoBadge.Name = "HeaderWallpaperLogo"
LogoBadge.Size = UDim2.new(0, 24, 0, 24)
LogoBadge.Position = UDim2.new(0, 16, 0.5, -12)
LogoBadge.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LogoBadge.BackgroundTransparency = 0
LogoBadge.Image = WALLPAPERS[1].id
LogoBadge.ScaleType = Enum.ScaleType.Crop
Instance.new("UICorner", LogoBadge).CornerRadius = UDim.new(0, 7)
local lStroke = Instance.new("UIStroke", LogoBadge)
lStroke.Color = CurrentAccent; lStroke.Thickness = 1
RegisterThemeStroke(lStroke)

local Title = Instance.new("TextLabel", Header)
Title.Position = UDim2.new(0, 48, 0, 6)
Title.Size = UDim2.new(0, 130, 0, 16)
Title.BackgroundTransparency = 1
Title.Text = "Sacred priv Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left

local SubTitle = Instance.new("TextLabel", Header)
SubTitle.Position = UDim2.new(0, 48, 0, 22)
SubTitle.Size = UDim2.new(0, 140, 0, 12)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "by iSacredRivals"
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 8.5
SubTitle.TextColor3 = CurrentAccent
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
RegisterThemeText(SubTitle)

-- Window Controls (Minimize & Close Completo)
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

-- Función para Minimizar
local function minimizeUI()
    TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.25)
    Main.Visible = false
    FloatingOpen.Visible = true
    Notify("Sacred Hub", "Minimizado. Toca el botón flotante para reabrir.")
end

-- Función para Maximizar
local function maximizeUI()
    FloatingOpen.Visible = false
    Main.Visible = true
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 440, 0, 300), Position = UDim2.new(0.5, -220, 0.5, -150)
    }):Play()
end

-- Función para Cerrar Completamente
local function fullCloseUI()
    IsScriptRunning = false
    for _, c in ipairs(ActiveConnections) do pcall(function() c:Disconnect() end) end
    pcall(function() ScreenGui:Destroy() end)
    pcall(function()
        local target = parentGui or (lp and lp:FindFirstChild("PlayerGui"))
        if target then
            for _, old in ipairs(target:GetChildren()) do
                if old.Name:find("Sacred") or old.Name:find("FOV_System") then old:Destroy() end
            end
        end
    end)
    print("🛑 Sacred priv Hub cerrado completamente.")
end

createHeaderBtn("−", -60, Color3.fromRGB(255, 255, 255), minimizeUI)
createHeaderBtn("✕", -30, Color3.fromRGB(255, 75, 75), fullCloseUI)
FloatingOpen.MouseButton1Click:Connect(maximizeUI)

-- Dragging desde Header
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
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

-- Contenedor de Páginas
local PageContainer = Instance.new("Frame", Main)
PageContainer.Name = "PageContainer"
PageContainer.Size = UDim2.new(1, -20, 1, -94)
PageContainer.Position = UDim2.new(0, 10, 0, 44)
PageContainer.BackgroundTransparency = 1
PageContainer.ZIndex = 4

-- Mobile Dock Inferior
local BottomDock = Instance.new("Frame", Main)
BottomDock.Name = "BottomDock"
BottomDock.Size = UDim2.new(0, 320, 0, 36)
BottomDock.Position = UDim2.new(0.5, -160, 1, -40)
BottomDock.BackgroundColor3 = Color3.fromRGB(10, 8, 16)
BottomDock.BackgroundTransparency = 0.5
Instance.new("UICorner", BottomDock).CornerRadius = UDim.new(0, 18)
local dockStroke = Instance.new("UIStroke", BottomDock)
dockStroke.Color = CurrentAccent; dockStroke.Thickness = 1.2; dockStroke.Transparency = 0.4
RegisterThemeStroke(dockStroke)

local DockLayout = Instance.new("UIListLayout", BottomDock)
DockLayout.FillDirection = Enum.FillDirection.Horizontal
DockLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
DockLayout.VerticalAlignment = Enum.VerticalAlignment.Center
DockLayout.Padding = UDim.new(0, 5)

local Pages = {}
local DockButtons = {}

local function RegisterTab(tabId, tabName, iconAsset)
    local page = Instance.new("ScrollingFrame", PageContainer)
    page.Name = tabId .. "Page"
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

    -- Dock Button
    local dockBtn = Instance.new("ImageButton", BottomDock)
    dockBtn.Size = UDim2.new(0, 38, 0, 26)
    dockBtn.BackgroundColor3 = CurrentAccent
    dockBtn.BackgroundTransparency = 1
    dockBtn.AutoButtonColor = false
    Instance.new("UICorner", dockBtn).CornerRadius = UDim.new(0, 8)

    local iconImg = Instance.new("ImageLabel", dockBtn)
    iconImg.Size = UDim2.new(0, 16, 0, 16)
    iconImg.Position = UDim2.new(0.5, -8, 0.5, -8)
    iconImg.BackgroundTransparency = 1
    iconImg.Image = iconAsset
    iconImg.ImageColor3 = Color3.fromRGB(180, 175, 195)

    local function selectTab()
        for id, p in pairs(Pages) do p.Visible = false end
        for _, dbtn in pairs(DockButtons) do
            TweenService:Create(dbtn.btn, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(dbtn.icon, TweenInfo.new(0.2), { ImageColor3 = Color3.fromRGB(180, 175, 195) }):Play()
        end

        page.Visible = true
        TweenService:Create(dockBtn, TweenInfo.new(0.2), { BackgroundTransparency = 0.7 }):Play()
        TweenService:Create(iconImg, TweenInfo.new(0.2), { ImageColor3 = CurrentAccent }):Play()
    end

    dockBtn.MouseButton1Click:Connect(selectTab)

    Pages[tabId] = page
    DockButtons[tabId] = { btn = dockBtn, icon = iconImg }
    return page
end

-- ============================================================
-- 📦 COMPONENTES DE CRISTAL TRANSLÚCIDO
-- ============================================================
local function CreateCard(parentPage, cardTitle)
    local card = Instance.new("Frame", parentPage)
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = Color3.fromRGB(10, 8, 16)
    card.BackgroundTransparency = 0.75 -- Ultra transparente para ver el video animado
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = CurrentAccent
    stroke.Thickness = 0.9
    stroke.Transparency = 0.65
    RegisterThemeStroke(stroke)

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
        header.TextColor3 = CurrentAccent
        header.TextXAlignment = Enum.TextXAlignment.Left
        RegisterThemeText(header)
    end
    return card
end

local function AddToggle(parentCard, titleText, descText, defaultState, callback)
    local state = defaultState or false

    local row = Instance.new("TextButton", parentCard)
    row.Size = UDim2.new(1, 0, 0, descText and 34 or 26)
    row.BackgroundTransparency = 1
    row.Text = ""
    row.AutoButtonColor = false
    row.Active = true

    local tLbl = Instance.new("TextLabel", row)
    tLbl.Size = UDim2.new(1, -45, 0, 14)
    tLbl.Position = UDim2.new(0, 0, 0, 0)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = titleText
    tLbl.Font = Enum.Font.GothamSemibold
    tLbl.TextSize = 10
    tLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Active = false

    if descText then
        local dLbl = Instance.new("TextLabel", row)
        dLbl.Size = UDim2.new(1, -45, 0, 12)
        dLbl.Position = UDim2.new(0, 0, 0, 15)
        dLbl.BackgroundTransparency = 1
        dLbl.Text = descText
        dLbl.Font = Enum.Font.Gotham
        dLbl.TextSize = 8
        dLbl.TextColor3 = Color3.fromRGB(150, 145, 165)
        dLbl.TextXAlignment = Enum.TextXAlignment.Left
        dLbl.Active = false
    end

    local switch = Instance.new("Frame", row)
    switch.Size = UDim2.new(0, 32, 0, 16)
    switch.Position = UDim2.new(1, -34, 0.5, -8)
    switch.BackgroundColor3 = state and CurrentAccent or Color3.fromRGB(35, 35, 48)
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    switch.Active = false

    if state then table.insert(ThemeActiveToggles, switch) end

    local knob = Instance.new("Frame", switch)
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    knob.Active = false

    local function doToggle()
        state = not state
        TweenService:Create(switch, TweenInfo.new(0.2), {
            BackgroundColor3 = state and CurrentAccent or Color3.fromRGB(35, 35, 48)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        }):Play()
        if callback then pcall(callback, state) end
    end

    row.MouseButton1Click:Connect(doToggle)
    return row
end

local function AddButton(parentCard, btnText, callback)
    local btn = Instance.new("TextButton", parentCard)
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
    bStroke.Color = CurrentAccent; bStroke.Thickness = 1
    RegisterThemeStroke(bStroke)

    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundTransparency = 0.2 }):Play()
        task.delay(0.12, function()
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.6 }):Play()
        end)
        if callback then pcall(callback) end
    end)
    return btn
end

-- ============================================================
-- 📑 REGISTRO DE PÁGINAS (PLANTILLA LIMPIA Y MODULAR)
-- ============================================================

-- 1. HOME
local HomePage = RegisterTab("Home", "Home", ICONS.Home)
do
    local welcomeCard = CreateCard(HomePage, nil)
    local wTitle = Instance.new("TextLabel", welcomeCard)
    wTitle.Size = UDim2.new(1, 0, 0, 18); wTitle.BackgroundTransparency = 1; wTitle.Text = "Welcome back, " .. lp.Name
    wTitle.Font = Enum.Font.GothamBold; wTitle.TextSize = 13.5; wTitle.TextColor3 = Color3.fromRGB(255, 255, 255); wTitle.TextXAlignment = Enum.TextXAlignment.Left

    local wSub = Instance.new("TextLabel", welcomeCard)
    wSub.Size = UDim2.new(1, 0, 0, 13); wSub.BackgroundTransparency = 1; wSub.Text = "Sacred priv Hub 2.0"
    wSub.Font = Enum.Font.Gotham; wSub.TextSize = 9; wSub.TextColor3 = CurrentAccent; wSub.TextXAlignment = Enum.TextXAlignment.Left
    RegisterThemeText(wSub)

    local statusCard = CreateCard(HomePage, "Estado del Sistema")
    local statusLbl = Instance.new("TextLabel", statusCard)
    statusLbl.Size = UDim2.new(1, 0, 0, 18); statusLbl.BackgroundTransparency = 1; statusLbl.Text = "● Base UI Cargada & Lista para Integrar Funciones"
    statusLbl.Font = Enum.Font.GothamSemibold; statusLbl.TextSize = 9.5; statusLbl.TextColor3 = Color3.fromRGB(34, 197, 94); statusLbl.TextXAlignment = Enum.TextXAlignment.Left
end

-- 2. COMBAT
local CombatPage = RegisterTab("Combat", "Skid Combat", ICONS.Combat)
do
    local infoCard = CreateCard(CombatPage, "Skid Combat")
    local lbl = Instance.new("TextLabel", infoCard)
    lbl.Size = UDim2.new(1, 0, 0, 20); lbl.BackgroundTransparency = 1; lbl.Text = "Sección lista para agregar funciones de combate una por una."
    lbl.Font = Enum.Font.Gotham; lbl.TextSize = 9; lbl.TextColor3 = Color3.fromRGB(180, 175, 195); lbl.TextXAlignment = Enum.TextXAlignment.Left
end

-- 3. GLITCHES
local GlitchesPage = RegisterTab("Glitches", "Glitches", ICONS.Glitches)
do
    local infoCard = CreateCard(GlitchesPage, "Glitches")
    local lbl = Instance.new("TextLabel", infoCard)
    lbl.Size = UDim2.new(1, 0, 0, 20); lbl.BackgroundTransparency = 1; lbl.Text = "Sección lista para agregar glitches uno por uno."
    lbl.Font = Enum.Font.Gotham; lbl.TextSize = 9; lbl.TextColor3 = Color3.fromRGB(180, 175, 195); lbl.TextXAlignment = Enum.TextXAlignment.Left
end

-- 4. ESP
local ESPPage = RegisterTab("ESP", "ESP", ICONS.ESP)
do
    local infoCard = CreateCard(ESPPage, "ESP")
    local lbl = Instance.new("TextLabel", infoCard)
    lbl.Size = UDim2.new(1, 0, 0, 20); lbl.BackgroundTransparency = 1; lbl.Text = "Sección lista para agregar el motor ESP."
    lbl.Font = Enum.Font.Gotham; lbl.TextSize = 9; lbl.TextColor3 = Color3.fromRGB(180, 175, 195); lbl.TextXAlignment = Enum.TextXAlignment.Left
end

-- 5. SONGS
local SongsPage = RegisterTab("Songs", "Songs", ICONS.Songs)
do
    local infoCard = CreateCard(SongsPage, "Songs")
    local lbl = Instance.new("TextLabel", infoCard)
    lbl.Size = UDim2.new(1, 0, 0, 20); lbl.BackgroundTransparency = 1; lbl.Text = "Sección lista para agregar el reproductor de música."
    lbl.Font = Enum.Font.Gotham; lbl.TextSize = 9; lbl.TextColor3 = Color3.fromRGB(180, 175, 195); lbl.TextXAlignment = Enum.TextXAlignment.Left
end

-- 6. RANDOM THINGS
local RandomPage = RegisterTab("Random", "Random things", ICONS.Random)
do
    local infoCard = CreateCard(RandomPage, "Random things")
    local lbl = Instance.new("TextLabel", infoCard)
    lbl.Size = UDim2.new(1, 0, 0, 20); lbl.BackgroundTransparency = 1; lbl.Text = "Sección lista para agregar Sacred VFX y Random Skills."
    lbl.Font = Enum.Font.Gotham; lbl.TextSize = 9; lbl.TextColor3 = Color3.fromRGB(180, 175, 195); lbl.TextXAlignment = Enum.TextXAlignment.Left
end

-- 7. SETTINGS & THEMES
local SettingsPage = RegisterTab("Settings", "Themes", ICONS.Settings)
do
    local themeCard = CreateCard(SettingsPage, "Color Theme Manager")
    local tGrid = Instance.new("Frame", themeCard)
    tGrid.Size = UDim2.new(1, 0, 0, 64); tGrid.BackgroundTransparency = 1
    local tgLayout = Instance.new("UIGridLayout", tGrid); tgLayout.CellSize = UDim2.new(0, 48, 0, 24); tgLayout.CellPadding = UDim.new(0, 5, 0, 4)

    for name, col in pairs(THEMES) do
        local tBtn = Instance.new("TextButton", tGrid)
        tBtn.BackgroundColor3 = col
        tBtn.Text = name:sub(1, 4)
        tBtn.TextColor3 = (name == "White") and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        tBtn.Font = Enum.Font.GothamBold; tBtn.TextSize = 8.5
        Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 6)
        tBtn.MouseButton1Click:Connect(function()
            ApplyTheme(name)
            Notify("Tema", "Tema actualizado a " .. name)
        end)
    end

    local wpCard = CreateCard(SettingsPage, "Anime Wallpapers (Fondos)")
    local wpBtn = Instance.new("TextButton", wpCard)
    wpBtn.Size = UDim2.new(1, 0, 0, 28)
    wpBtn.BackgroundColor3 = Color3.fromRGB(18, 15, 26)
    wpBtn.BackgroundTransparency = 0.5
    wpBtn.Text = "📷 Fondo: " .. WALLPAPERS[1].name
    wpBtn.Font = Enum.Font.GothamBold
    wpBtn.TextSize = 9.5
    wpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", wpBtn).CornerRadius = UDim.new(0, 7)
    local wpStr = Instance.new("UIStroke", wpBtn)
    wpStr.Color = CurrentAccent; wpStr.Thickness = 1
    RegisterThemeStroke(wpStr)

    wpBtn.MouseButton1Click:Connect(function()
        currentBgIdx = (currentBgIdx % #WALLPAPERS) + 1
        local sel = WALLPAPERS[currentBgIdx]
        wpBtn.Text = "📷 Fondo: " .. sel.name
        FallbackBg.Image = sel.id
        FallbackBg.ImageTransparency = 0
        FloatingOpen.Image = sel.id
        LogoBadge.Image = sel.id
        pcall(function() ContentProvider:PreloadAsync({FallbackBg, FloatingOpen, LogoBadge}) end)
        Notify("Fondo", "Wallpaper cambiado a " .. sel.name)
    end)
end

-- ============================================================
-- 🚀 INICIALIZACIÓN
-- ============================================================
DockButtons["Home"].btn.BackgroundTransparency = 0.7
DockButtons["Home"].icon.ImageColor3 = CurrentAccent
Pages["Home"].Visible = true

playSacredIntro(function()
    maximizeUI()
    Notify("Sacred priv Hub", "Base UI cargada. Lista para integrar funciones.")
end)

print("🌌 SACRED PRIV HUB | Base UI Clean Foundation Loaded!")
