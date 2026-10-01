-- Dead Rails Hub - Advanced UI
-- Optimized for mobile + PC
-- Use: loadstring(game:HttpGet("https://raw.githubusercontent.com/oopi75263-cmyk/Ia/main/deadrails.lua"))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeadRailsHubAdvanced"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local Settings = {
    DarkTheme = true,
    Glow = true,
    FPS = false,
    Sound = true,
    Accent = Color3.fromRGB(90, 110, 255),
}

local UI = {
    Accent = Settings.Accent,
    Main = nil,
    Header = nil,
    Sidebar = nil,
    Content = nil,
    Toggle = nil,
    Tabs = {},
    Pages = {},
    SelectedTab = "Home",
    Dragging = false,
    DragStart = Vector2.zero,
    StartPos = UDim2.new(),
}

local function clamp(value, min, max)
    return math.max(min, math.min(value, max))
end

local function lighten(color, amount)
    amount = amount or 0.15
    local r = clamp(color.R + amount, 0, 1)
    local g = clamp(color.G + amount, 0, 1)
    local b = clamp(color.B + amount, 0, 1)
    return Color3.new(r, g, b)
end

local function darken(color, amount)
    amount = amount or 0.15
    local r = clamp(color.R - amount, 0, 1)
    local g = clamp(color.G - amount, 0, 1)
    local b = clamp(color.B - amount, 0, 1)
    return Color3.new(r, g, b)
end

local function makeCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
end

local function makeStroke(parent, color, transparency, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Transparency = transparency
    stroke.Thickness = thickness
    stroke.Parent = parent
end

local function makeText(parent, size, text, font, color, alignment, position, sizeUDim)
    local label = Instance.new("TextLabel")
    label.Size = sizeUDim or UDim2.new(1, 0, 0, size + 10)
    label.Position = position or UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = font or Enum.Font.GothamBold
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.TextSize = size
    label.TextXAlignment = alignment or Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = parent
    return label
end

local function createButton(parent, text, sizeX, sizeY, posX, posY, bgColor, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, sizeX, 0, sizeY)
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.BackgroundColor3 = bgColor or Color3.fromRGB(60, 60, 68)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.AutoButtonColor = false
    btn.Parent = parent
    makeCorner(btn, 12)

    if bgColor then
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.14), {
                BackgroundColor3 = lighten(bgColor, 0.10)
            }):Play()
        end)

        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.14), {
                BackgroundColor3 = bgColor
            }):Play()
        end)
    end

    if callback then
        btn.MouseButton1Click:Connect(callback)
    end

    return btn
end

local function createPage(name)
    local page = Instance.new("Frame")
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = UI.Content
    return page
end

local function setSelectedTab(name)
    UI.SelectedTab = name
    for _, tab in ipairs(UI.Tabs) do
        local isSelected = tab.name == name
        tab.button.BackgroundColor3 = isSelected and Settings.Accent or Color3.fromRGB(32, 35, 45)
        tab.button.TextTransparency = isSelected and 0 or 0.06
        tab.page.Visible = isSelected
    end
end

local function applyThemeColors()
    local bgMain = Settings.DarkTheme and Color3.fromRGB(12, 14, 20) or Color3.fromRGB(245, 246, 250)
    local bgPanel = Settings.DarkTheme and Color3.fromRGB(18, 21, 30) or Color3.fromRGB(231, 234, 242)
    local bgSide = Settings.DarkTheme and Color3.fromRGB(22, 26, 36) or Color3.fromRGB(223, 227, 236)
    local stroke = Settings.DarkTheme and Color3.fromRGB(120, 130, 255) or Color3.fromRGB(90, 110, 255)
    local textPrimary = Settings.DarkTheme and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 28, 35)
    local textSecondary = Settings.DarkTheme and Color3.fromRGB(200, 205, 220) or Color3.fromRGB(78, 85, 100)
    local accent = Settings.Accent

    if UI.Main then
        UI.Main.BackgroundColor3 = bgMain
        if Settings.Glow then
            makeStroke(UI.Main, accent, 0.25, 2)
        else
            makeStroke(UI.Main, stroke, 0.5, 1)
        end
    end

    if UI.Header then
        UI.Header.BackgroundColor3 = bgPanel
    end

    if UI.Sidebar then
        UI.Sidebar.BackgroundColor3 = bgSide
    end

    if UI.Content then
        UI.Content.BackgroundColor3 = bgMain
    end

    for _, tab in ipairs(UI.Tabs) do
        if tab.name == UI.SelectedTab then
            tab.button.BackgroundColor3 = accent
        else
            tab.button.BackgroundColor3 = Settings.DarkTheme and Color3.fromRGB(32, 35, 45) or Color3.fromRGB(235, 238, 245)
        end
        tab.button.TextColor3 = textPrimary
    end
end

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 82, 0, 82)
toggleButton.Position = UDim2.new(1, -106, 1, -106)
toggleButton.BackgroundColor3 = Settings.Accent
toggleButton.BorderSizePixel = 0
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Text = "☰"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 32
toggleButton.Parent = screenGui
makeCorner(toggleButton, 22)
makeStroke(toggleButton, Color3.fromRGB(255, 255, 255), 0.12, 2)
UI.Toggle = toggleButton

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 600, 0, 410)
main.Position = UDim2.new(0.5, -300, 0.5, -205)
main.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
main.BorderSizePixel = 0
main.Visible = false
main.Parent = screenGui
makeCorner(main, 22)
makeStroke(main, Settings.Accent, 0.25, 2)
UI.Main = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 74)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(18, 21, 30)
header.BorderSizePixel = 0
header.Parent = main
makeCorner(header, 22)
UI.Header = header

local titleLabel = makeText(header, 25, "⚡ DEAD RAILS HUB", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 18, 0.5, -12), UDim2.new(1, -110, 0, 28))

titleLabel.TextTransparency = 0.08

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 42, 0, 42)
closeBtn.Position = UDim2.new(1, -54, 0.5, -21)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 90, 110)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Parent = header
makeCorner(closeBtn, 12)

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 170, 1, -74)
sidebar.Position = UDim2.new(0, 0, 0, 74)
sidebar.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
sidebar.BorderSizePixel = 0
sidebar.Parent = main
UI.Sidebar = sidebar

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -170, 1, -74)
content.Position = UDim2.new(0, 170, 0, 74)
content.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
content.BorderSizePixel = 0
content.Parent = main
UI.Content = content

header.Active = true
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        UI.Dragging = true
        UI.DragStart = input.Position
        UI.StartPos = main.Position
    end
end)

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        UI.Dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if UI.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - UI.DragStart
        main.Position = UDim2.new(
            UI.StartPos.X.Scale,
            UI.StartPos.X.Offset + delta.X,
            UI.StartPos.Y.Scale,
            UI.StartPos.Y.Offset + delta.Y
        )
    end
end)

local function setMenuVisible(value)
    main.Visible = value
    toggleButton.Text = value and "✕" or "☰"
    if value then
        TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = main.Position
        }):Play()
    end
end

toggleButton.MouseButton1Click:Connect(function()
    setMenuVisible(not main.Visible)
end)

closeBtn.MouseButton1Click:Connect(function()
    setMenuVisible(false)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F4 then
        setMenuVisible(not main.Visible)
    end
end)

local pageNames = {"Home", "Settings", "Visuals", "About"}
for idx, pageName in ipairs(pageNames) do
    local page = createPage(pageName)
    UI.Pages[pageName] = page

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -18, 0, 46)
    btn.Position = UDim2.new(0, 9, 0, 12 + (idx - 1) * 52)
    btn.BackgroundColor3 = (idx == 1) and Settings.Accent or Color3.fromRGB(32, 35, 45)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.Text = pageName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.Parent = sidebar
    makeCorner(btn, 12)

    btn.MouseButton1Click:Connect(function()
        setSelectedTab(pageName)
    end)

    table.insert(UI.Tabs, { name = pageName, button = btn, page = page })
end

local homePage = UI.Pages["Home"]
local settingsPage = UI.Pages["Settings"]
local visualsPage = UI.Pages["Visuals"]
local aboutPage = UI.Pages["About"]

makeText(homePage, 18, "Quick Actions", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 18), UDim2.new(1, -32, 0, 28))

local statCards = Instance.new("Frame")
statCards.Size = UDim2.new(1, -32, 0, 150)
statCards.Position = UDim2.new(0, 16, 0, 52)
statCards.BackgroundTransparency = 1
statCards.Parent = homePage

local function makeInfoCard(parent, x, y, w, h, title, value, color)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, w, 0, h)
    card.Position = UDim2.new(0, x, 0, y)
    card.BackgroundColor3 = Color3.fromRGB(28, 32, 42)
    card.BorderSizePixel = 0
    card.Parent = parent
    makeCorner(card, 14)

    local titleLabel = makeText(card, 12, title, Enum.Font.Gotham, Color3.fromRGB(180, 185, 200), Enum.TextXAlignment.Left, UDim2.new(0, 12, 0, 10), UDim2.new(1, -24, 0, 20))
    titleLabel.TextTransparency = 0.1

    local valueLabel = makeText(card, 22, value, Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 12, 0, 34), UDim2.new(1, -24, 0, 32))
    valueLabel.TextColor3 = color

    return card
end

makeInfoCard(statCards, 0, 0, 165, 70, "Players", tostring(#Players:GetPlayers()), Color3.fromRGB(110, 180, 255))
makeInfoCard(statCards, 175, 0, 165, 70, "Map", tostring(game.PlaceId), Color3.fromRGB(90, 220, 155))
makeInfoCard(statCards, 0, 80, 165, 70, "Status", "Ready", Color3.fromRGB(120, 210, 110))
makeInfoCard(statCards, 175, 80, 165, 70, "Theme", Settings.DarkTheme and "Dark" or "Light", Color3.fromRGB(255, 176, 85))

createButton(homePage, "🎨 Change Theme", 160, 48, 16, 220, Color3.fromRGB(88, 122, 255), function()
    Settings.DarkTheme = not Settings.DarkTheme
    applyThemeColors()
end)

createButton(homePage, "📊 Toggle FPS", 160, 48, 190, 220, Color3.fromRGB(60, 180, 130), function()
    Settings.FPS = not Settings.FPS
end)

createButton(homePage, "⚡ Game Info", 160, 48, 16, 280, Color3.fromRGB(210, 130, 65), function()
    print("Game PlaceId:", game.PlaceId)
    print("User:", player.Name)
end)

createButton(homePage, "🔧 Open Settings", 160, 48, 190, 280, Color3.fromRGB(200, 100, 160), function()
    setSelectedTab("Settings")
end)

local homeStatus = Instance.new("TextLabel")
homeStatus.Size = UDim2.new(1, -32, 0, 80)
homeStatus.Position = UDim2.new(0, 16, 0, 342)
homeStatus.BackgroundColor3 = Color3.fromRGB(27, 31, 42)
homeStatus.BorderSizePixel = 0
homeStatus.Font = Enum.Font.Gotham
homeStatus.Text = "✓ Hub online\n✓ Drag from header to move\n✓ Press F4 to toggle"
homeStatus.TextColor3 = Color3.fromRGB(170, 220, 170)
homeStatus.TextSize = 13
homeStatus.TextWrapped = true
homeStatus.TextXAlignment = Enum.TextXAlignment.Left
homeStatus.TextYAlignment = Enum.TextYAlignment.Top
homeStatus.Parent = homePage
makeCorner(homeStatus, 12)

makeText(settingsPage, 18, "Settings", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 18), UDim2.new(1, -32, 0, 28))

local fpsToggle = createButton(settingsPage, "📊 FPS Counter: OFF", 200, 46, 16, 70, Color3.fromRGB(52, 100, 150), function()
    Settings.FPS = not Settings.FPS
    fpsToggle.Text = Settings.FPS and "📊 FPS Counter: ON" or "📊 FPS Counter: OFF"
end)

local soundToggle = createButton(settingsPage, "🔊 Sound: ON", 200, 46, 16, 130, Color3.fromRGB(100, 150, 80), function()
    Settings.Sound = not Settings.Sound
    soundToggle.Text = Settings.Sound and "🔊 Sound: ON" or "🔊 Sound: OFF"
end)

createButton(settingsPage, "🎨 Switch Accent", 200, 46, 16, 190, Color3.fromRGB(150, 80, 180), function()
    local colors = {
        Color3.fromRGB(90, 110, 255),
        Color3.fromRGB(255, 100, 100),
        Color3.fromRGB(100, 255, 100),
        Color3.fromRGB(255, 170, 80),
        Color3.fromRGB(130, 90, 255)
    }
    Settings.Accent = colors[math.random(1, #colors)]
    applyThemeColors()
end)

makeText(visualsPage, 18, "Visuals", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 18), UDim2.new(1, -32, 0, 28))

local themeBtn = createButton(visualsPage, "🌙 Dark Theme: ON", 200, 46, 16, 70, Color3.fromRGB(140, 80, 255), function()
    Settings.DarkTheme = not Settings.DarkTheme
    themeBtn.Text = Settings.DarkTheme and "🌙 Dark Theme: ON" or "🌙 Dark Theme: OFF"
    applyThemeColors()
end)

local glowBtn = createButton(visualsPage, "✨ Glow: ON", 200, 46, 16, 130, Color3.fromRGB(255, 180, 80), function()
    Settings.Glow = not Settings.Glow
    glowBtn.Text = Settings.Glow and "✨ Glow: ON" or "✨ Glow: OFF"
    applyThemeColors()
end)

createButton(visualsPage, "🎆 FX Demo", 200, 46, 16, 190, Color3.fromRGB(100, 200, 200), function()
    print("FX demo activated")
end)

makeText(aboutPage, 18, "About", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 18), UDim2.new(1, -32, 0, 28))

local aboutText = Instance.new("TextLabel")
aboutText.Size = UDim2.new(1, -32, 1, -60)
aboutText.Position = UDim2.new(0, 16, 0, 54)
aboutText.BackgroundTransparency = 1
aboutText.Font = Enum.Font.Gotham
aboutText.Text = "Dead Rails Hub v3.0\n\n✓ Advanced modern UI\n✓ Improved theme system\n✓ Smooth toggle animations\n✓ Mobile & PC optimized\n\nF4 = Toggle | Drag header to move"
aboutText.TextColor3 = Color3.fromRGB(200, 200, 200)
aboutText.TextSize = 14
aboutText.TextWrapped = true
aboutText.TextXAlignment = Enum.TextXAlignment.Left
aboutText.TextYAlignment = Enum.TextYAlignment.Top
aboutText.Parent = aboutPage
makeCorner(aboutText, 12)

local fpsLabel = makeText(homePage, 12, "FPS: --", Enum.Font.Gotham, Color3.fromRGB(170, 180, 210), Enum.TextXAlignment.Right, UDim2.new(1, -140, 0, 18), UDim2.new(0, 120, 0, 20))

local function updateFPS()
    local fps = math.floor(1 / workspace:GetService("RunService").RenderStepped:Wait())
    if Settings.FPS then
        fpsLabel.Text = "FPS: " .. tostring(fps)
    else
        fpsLabel.Text = "FPS: --"
    end
end

RunService.RenderStepped:Connect(function()
    if Settings.FPS then
        fpsLabel.Text = "FPS: " .. tostring(math.floor(1 / workspace:GetService("RunService").RenderStepped:Wait()))
    end
end)

setSelectedTab("Home")
applyThemeColors()
print("Dead Rails Hub v3.0 loaded successfully!")
