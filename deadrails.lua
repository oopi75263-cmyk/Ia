-- Dead Rails Hub Premium UI
-- Safe visual-only Roblox menu
-- Works on PC and mobile
-- Press the floating button or F4 to open/close

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeadRailsHubPremium"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local Settings = {
    Dark = true,
    Glow = true,
    Accent = Color3.fromRGB(118, 128, 255),
    FPS = false,
    Sound = true,
}

local UI = {
    Tabs = {},
    Pages = {},
    Dragging = false,
    DragStart = Vector2.zero,
    StartPos = UDim2.new(),
    SelectedTab = "Home",
}

local function clamp(value, minValue, maxValue)
    return math.max(minValue, math.min(value, maxValue))
end

local function lighten(color, amount)
    amount = amount or 0.12
    return Color3.new(
        clamp(color.R + amount, 0, 1),
        clamp(color.G + amount, 0, 1),
        clamp(color.B + amount, 0, 1)
    )
end

local function darken(color, amount)
    amount = amount or 0.12
    return Color3.new(
        clamp(color.R - amount, 0, 1),
        clamp(color.G - amount, 0, 1),
        clamp(color.B - amount, 0, 1)
    )
end

local function makeCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function makeStroke(parent, color, transparency, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Transparency = transparency
    stroke.Thickness = thickness
    stroke.Parent = parent
    return stroke
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
    btn.BackgroundColor3 = bgColor or Color3.fromRGB(90, 110, 255)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.AutoButtonColor = false
    btn.Parent = parent
    makeCorner(btn, 12)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {
            BackgroundColor3 = lighten(btn.BackgroundColor3, 0.08)
        }):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {
            BackgroundColor3 = bgColor or Color3.fromRGB(90, 110, 255)
        }):Play()
    end)

    if callback then
        btn.MouseButton1Click:Connect(callback)
    end

    return btn
end

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 84, 0, 84)
toggleButton.Position = UDim2.new(1, -104, 1, -104)
toggleButton.BackgroundColor3 = Settings.Accent
toggleButton.BorderSizePixel = 0
toggleButton.Text = "☰"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 30
toggleButton.Parent = screenGui
makeCorner(toggleButton, 20)
local toggleStroke = makeStroke(toggleButton, Color3.fromRGB(255, 255, 255), 0.15, 2)

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 610, 0, 420)
main.Position = UDim2.new(0.5, -305, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
main.BorderSizePixel = 0
main.Visible = false
main.Parent = screenGui
makeCorner(main, 24)
local mainStroke = makeStroke(main, Settings.Accent, 0.2, 2)

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 76)
header.BackgroundColor3 = Color3.fromRGB(18, 21, 30)
header.BorderSizePixel = 0
header.Parent = main
makeCorner(header, 24)

local title = makeText(header, 25, "⚡ DEAD RAILS HUB", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 18, 0.5, -12), UDim2.new(1, -120, 0, 30))
title.TextTransparency = 0.08

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
sidebar.Size = UDim2.new(0, 170, 1, -76)
sidebar.Position = UDim2.new(0, 0, 0, 76)
sidebar.BackgroundColor3 = Color3.fromRGB(22, 26, 35)
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -170, 1, -76)
content.Position = UDim2.new(0, 170, 0, 76)
content.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
content.BorderSizePixel = 0
content.Parent = main

local function createPage(name)
    local page = Instance.new("Frame")
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = content
    return page
end

local function setSelectedTab(name)
    UI.SelectedTab = name
    for _, tab in ipairs(UI.Tabs) do
        local isSelected = tab.name == name
        tab.button.BackgroundColor3 = isSelected and Settings.Accent or Color3.fromRGB(31, 35, 45)
        tab.button.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(220, 225, 235)
        tab.page.Visible = isSelected
    end
end

local function applyTheme()
    local bgMain = Settings.Dark and Color3.fromRGB(12, 14, 20) or Color3.fromRGB(244, 247, 251)
    local bgHeader = Settings.Dark and Color3.fromRGB(18, 21, 30) or Color3.fromRGB(233, 238, 247)
    local bgSidebar = Settings.Dark and Color3.fromRGB(22, 26, 35) or Color3.fromRGB(223, 229, 240)
    local bgContent = Settings.Dark and Color3.fromRGB(12, 14, 20) or Color3.fromRGB(238, 242, 248)
    local textMain = Settings.Dark and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(24, 28, 36)

    main.BackgroundColor3 = bgMain
    header.BackgroundColor3 = bgHeader
    sidebar.BackgroundColor3 = bgSidebar
    content.BackgroundColor3 = bgContent

    mainStroke.Color = Settings.Accent
    mainStroke.Transparency = Settings.Glow and 0.2 or 0.5
    mainStroke.Thickness = Settings.Glow and 2 or 1

    toggleButton.BackgroundColor3 = Settings.Accent
    toggleStroke.Color = Settings.Glow and Color3.fromRGB(255, 255, 255) or Settings.Accent

    for _, tab in ipairs(UI.Tabs) do
        local selected = tab.name == UI.SelectedTab
        tab.button.BackgroundColor3 = selected and Settings.Accent or (Settings.Dark and Color3.fromRGB(31, 35, 45) or Color3.fromRGB(220, 224, 233))
        tab.button.TextColor3 = selected and Color3.fromRGB(255, 255, 255) or textMain
    end
end

local pageNames = {"Home", "Settings", "Visuals", "About"}
for idx, pageName in ipairs(pageNames) do
    local page = createPage(pageName)
    UI.Pages[pageName] = page

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -18, 0, 46)
    btn.Position = UDim2.new(0, 9, 0, 12 + (idx - 1) * 52)
    btn.BackgroundColor3 = idx == 1 and Settings.Accent or Color3.fromRGB(31, 35, 45)
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
statCards.Position = UDim2.new(0, 16, 0, 50)
statCards.BackgroundTransparency = 1
statCards.Parent = homePage

local function makeCard(parent, x, y, w, h, titleText, valueText, accentColor)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, w, 0, h)
    card.Position = UDim2.new(0, x, 0, y)
    card.BackgroundColor3 = Color3.fromRGB(28, 32, 42)
    card.BorderSizePixel = 0
    card.Parent = parent
    makeCorner(card, 14)

    local title = makeText(card, 11, titleText, Enum.Font.Gotham, Color3.fromRGB(170, 180, 200), Enum.TextXAlignment.Left, UDim2.new(0, 12, 0, 10), UDim2.new(1, -24, 0, 20))
    title.TextTransparency = 0.15

    local value = makeText(card, 22, valueText, Enum.Font.GothamBold, accentColor or Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 12, 0, 34), UDim2.new(1, -24, 0, 30))
    return value
end

makeCard(statCards, 0, 0, 170, 68, "Players", tostring(#Players:GetPlayers()), Color3.fromRGB(110, 180, 255))
makeCard(statCards, 180, 0, 170, 68, "Theme", Settings.Dark and "Dark" or "Light", Color3.fromRGB(110, 230, 150))
makeCard(statCards, 0, 80, 170, 68, "Status", "Ready", Color3.fromRGB(120, 220, 130))
makeCard(statCards, 180, 80, 170, 68, "Mobile", "Optimized", Color3.fromRGB(255, 176, 85))

createButton(homePage, "🎨 Change Theme", 160, 46, 16, 220, Color3.fromRGB(110, 124, 255), function()
    Settings.Dark = not Settings.Dark
    applyTheme()
end)

createButton(homePage, "📊 Toggle FPS", 160, 46, 190, 220, Color3.fromRGB(78, 190, 134), function()
    Settings.FPS = not Settings.FPS
    print("FPS overlay:", Settings.FPS)
end)

createButton(homePage, "⚡ UI Demo", 160, 46, 16, 280, Color3.fromRGB(230, 142, 72), function()
    print("Premium UI demo activated")
end)

createButton(homePage, "🔧 Settings", 160, 46, 190, 280, Color3.fromRGB(216, 108, 165), function()
    setSelectedTab("Settings")
end)

local homeStatus = Instance.new("TextLabel")
homeStatus.Size = UDim2.new(1, -32, 0, 70)
homeStatus.Position = UDim2.new(0, 16, 0, 340)
homeStatus.BackgroundColor3 = Color3.fromRGB(26, 30, 42)
homeStatus.BorderSizePixel = 0
homeStatus.Font = Enum.Font.Gotham
homeStatus.Text = "✓ Premium UI active\n✓ Drag header to move\n✓ Press F4 to toggle"
homeStatus.TextColor3 = Color3.fromRGB(170, 220, 170)
homeStatus.TextSize = 13
homeStatus.TextWrapped = true
homeStatus.TextXAlignment = Enum.TextXAlignment.Left
homeStatus.TextYAlignment = Enum.TextYAlignment.Top
homeStatus.Parent = homePage
makeCorner(homeStatus, 12)

makeText(settingsPage, 18, "Settings", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 18), UDim2.new(1, -32, 0, 28))

local fpsBtn = createButton(settingsPage, "📊 FPS Counter: OFF", 200, 46, 16, 70, Color3.fromRGB(52, 100, 150), function()
    Settings.FPS = not Settings.FPS
    fpsBtn.Text = Settings.FPS and "📊 FPS Counter: ON" or "📊 FPS Counter: OFF"
end)

local soundBtn = createButton(settingsPage, "🔊 Sound: ON", 200, 46, 16, 130, Color3.fromRGB(100, 150, 80), function()
    Settings.Sound = not Settings.Sound
    soundBtn.Text = Settings.Sound and "🔊 Sound: ON" or "🔊 Sound: OFF"
end)

createButton(settingsPage, "🎨 Accent Color", 200, 46, 16, 190, Color3.fromRGB(150, 80, 180), function()
    local colors = {
        Color3.fromRGB(118, 128, 255),
        Color3.fromRGB(255, 105, 105),
        Color3.fromRGB(88, 220, 150),
        Color3.fromRGB(255, 170, 90),
        Color3.fromRGB(130, 90, 255),
    }
    Settings.Accent = colors[math.random(1, #colors)]
    applyTheme()
end)

makeText(visualsPage, 18, "Visuals", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 18), UDim2.new(1, -32, 0, 28))

local glowBtn = createButton(visualsPage, "✨ Glow: ON", 200, 46, 16, 70, Color3.fromRGB(255, 180, 80), function()
    Settings.Glow = not Settings.Glow
    glowBtn.Text = Settings.Glow and "✨ Glow: ON" or "✨ Glow: OFF"
    applyTheme()
end)

local themeBtn = createButton(visualsPage, "🌙 Theme: DARK", 200, 46, 16, 130, Color3.fromRGB(140, 80, 255), function()
    Settings.Dark = not Settings.Dark
    themeBtn.Text = Settings.Dark and "🌙 Theme: DARK" or "🌙 Theme: LIGHT"
    applyTheme()
end)

createButton(visualsPage, "🎆 FX Demo", 200, 46, 16, 190, Color3.fromRGB(90, 200, 200), function()
    print("FX demo activated")
end)

makeText(aboutPage, 18, "About", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 18), UDim2.new(1, -32, 0, 28))

local aboutText = Instance.new("TextLabel")
aboutText.Size = UDim2.new(1, -32, 1, -60)
aboutText.Position = UDim2.new(0, 16, 0, 54)
aboutText.BackgroundTransparency = 1
aboutText.Font = Enum.Font.Gotham
aboutText.Text = "Dead Rails Hub v3.1\n\n✓ Premium modern design\n✓ Smooth tabs and theme control\n✓ Mobile + PC friendly\n✓ Safe visual-only configuration\n\nF4 = Toggle | Drag the header to move"
aboutText.TextColor3 = Color3.fromRGB(200, 200, 200)
aboutText.TextSize = 14
aboutText.TextWrapped = true
aboutText.TextXAlignment = Enum.TextXAlignment.Left
aboutText.TextYAlignment = Enum.TextYAlignment.Top
aboutText.Parent = aboutPage
makeCorner(aboutText, 12)

local fpsLabel = makeText(homePage, 12, "FPS: --", Enum.Font.Gotham, Color3.fromRGB(170, 180, 210), Enum.TextXAlignment.Right, UDim2.new(1, -130, 0, 18), UDim2.new(0, 120, 0, 20))

RunService.RenderStepped:Connect(function(dt)
    if Settings.FPS and dt > 0 then
        fpsLabel.Text = "FPS: " .. tostring(math.floor(1 / dt))
    else
        fpsLabel.Text = "FPS: --"
    end
end)

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
        toggleButton.BackgroundColor3 = Settings.Accent
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

setSelectedTab("Home")
applyTheme()
print("Dead Rails Hub Premium UI loaded successfully.")
