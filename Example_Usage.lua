--[[
    ════════════════════════════════════════════════════════════════════════════════
    📖 EJEMPLO DE USO DE LA LIBRERÍA SACRED UI 
    ════════════════════════════════════════════════════════════════════════════════
]]

-- Cargar la librería (Localmente o desde GitHub raw URL)
local SacredUI = loadstring(readfile("SacredUI_Library.lua"))()
-- En GitHub usarías: local SacredUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/TU_USUARIO/TU_REPO/main/SacredUI_Library.lua"))()

-- 1. Crear Ventana Principal
local Window = SacredUI:CreateWindow({
    Title = "Sacred priv Hub",
    SubTitle = "by iSacredRivals",
    Theme = "Purple", -- "Purple", "Blue", "Cyan", "Red", "Emerald", "Pink", "Orange", "White", "Rainbow"
    VideoBackground = "ashen-one-monochrome-dark-souls-3-moewalls-com.mp4",
    ShowIntro = true
})

-- 2. Crear Pestañas en el Dock Inferior
local HomeTab = Window:CreateTab({ Name = "Home", Icon = "Home" })
local CombatTab = Window:CreateTab({ Name = "Combat", Icon = "Combat" })
local GlitchesTab = Window:CreateTab({ Name = "Glitches", Icon = "Glitches" })
local SettingsTab = Window:CreateTab({ Name = "Settings", Icon = "Settings" })

-- 3. Crear Tarjetas y Componentes en Home
local WelcomeCard = HomeTab:CreateCard({ Title = "Bienvenido" })
WelcomeCard:CreateButton({
    Name = "⚡ Probar Notificación",
    Callback = function()
        Window:Notify({
            Title = "Sacred priv Hub",
            Content = "¡El sistema de toasts funciona de maravilla!",
            Duration = 3
        })
    end
})

-- 4. Crear Tarjetas y Componentes en Combat
local AimCard = CombatTab:CreateCard({ Title = "Silent Aim" })

AimCard:CreateToggle({
    Name = "Player Silent Aim",
    Description = "Aimbot predictivo inteligente a jugadores",
    Default = false,
    Callback = function(state)
        print("Silent Aim State:", state)
    end
})

AimCard:CreateSlider({
    Name = "FOV Radius",
    Min = 30,
    Max = 450,
    Default = 120,
    Step = 10,
    Suffix = " px",
    Callback = function(val)
        print("FOV Radius:", val)
    end
})

AimCard:CreateDropdown({
    Name = "Target Priority",
    Options = {"Nearest", "Low HP", "Lock Player"},
    Default = "Nearest",
    Callback = function(selected)
        print("Priority seleccionada:", selected)
    end
})

-- 5. Crear Widget Flotante Arrastrable
local SanguineWidget = Window:CreateWidget({
    Title = "🩸 SANGUINE Z",
    Position = UDim2.new(0.72, 0, 0.35, 0),
    Callback = function()
        print("Widget Sanguine Z pulsado!")
        Window:Notify({ Title = "Widget", Content = "Boost activado." })
    end
})

-- 6. Selector de Temas en Settings
local ThemeCard = SettingsTab:CreateCard({ Title = "Personalización" })
ThemeCard:CreateDropdown({
    Name = "Tema de Color",
    Options = {"Purple", "Blue", "Cyan", "Red", "Emerald", "Pink", "Orange", "White", "Rainbow"},
    Default = "Purple",
    Callback = function(themeName)
        Window:SetTheme(themeName)
    end
})

print("✅ Ejemplo cargado correctamente.")
