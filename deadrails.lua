-- Dead Rails Hub - Advanced Loadstring Version
-- Safe cosmetic UI prototype for mobile and PC
-- Use: loadstring(game:HttpGet("https://raw.githubusercontent.com/oopi75263-cmyk/Ia/main/deadrails.lua"))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeadRailsHubAdvanced"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

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
    label.Parent = parent
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
    btn.Parent = parent
    makeCorner(btn, 12)

    if callback then
        btn.MouseButton1Click:Connect(callback)
    end

    return btn
end

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 80, 0, 80)
toggleButton.Position = UDim2.new(1, -100, 1, -100)
toggleButton.BackgroundColor3 = Color3.fromRGB(90, 110, 255)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "☰"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 32
toggleButton.Parent = screenGui
makeCorner(toggleButton, 20)
makeStroke(toggleButton, Color3.fromRGB(255, 255, 255), 0.1, 2)

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 580, 0, 400)
main.Position = UDim2.new(0.5, -290, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.BorderSizePixel = 0
main.Visible = false
main.Parent = screenGui
makeCorner(main, 20)
makeStroke(main, Color3.fromRGB(100, 120, 255), 0.5, 2)

local showMenu = false

local function setMenuVisible(value)
    showMenu = value
    main.Visible = value
    toggleButton.Text = value and "✕" or "☰"
end

toggleButton.MouseButton1Click:Connect(function()
    setMenuVisible(not showMenu)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F4 then
        setMenuVisible(not showMenu)
    end
end)

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 70)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
header.BorderSizePixel = 0
header.Parent = main
makeCorner(header, 20)
makeStroke(header, Color3.fromRGB(100, 120, 255), 0.3, 1)

makeText(header, 26, "⚡ DEAD RAILS HUB", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 20, 0.5, -13), UDim2.new(1, -100, 0, 30))

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -50, 0.5, -20)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 100)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Parent = header
makeCorner(closeBtn, 10)

closeBtn.MouseButton1Click:Connect(function()
    setMenuVisible(false)
end)

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 160, 1, -80)
sidebar.Position = UDim2.new(0, 0, 0, 70)
sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
sidebar.BorderSizePixel = 0
sidebar.Parent = main
makeCorner(sidebar, 0)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -170, 1, -80)
content.Position = UDim2.new(0, 160, 0, 70)
content.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
content.BorderSizePixel = 0
content.Parent = main
makeCorner(content, 0)

local tabs = {}
local pages = {}

local function createPage(name)
    local page = Instance.new("Frame")
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = content
    return page
end

local function setSelectedTab(selected)
    for _, tab in ipairs(tabs) do
        local isSelected = (tab.name == selected)
        tab.button.BackgroundColor3 = isSelected and Color3.fromRGB(90, 110, 255) or Color3.fromRGB(30, 30, 40)
        tab.page.Visible = isSelected
    end
end

local pageNames = {"Home", "Settings", "Visuals", "About"}

for idx, pageName in ipairs(pageNames) do
    local page = createPage(pageName)
    pages[pageName] = page

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 50)
    btn.Position = UDim2.new(0, 8, 0, 10 + (idx - 1) * 56)
    btn.BackgroundColor3 = (idx == 1) and Color3.fromRGB(90, 110, 255) or Color3.fromRGB(30, 30, 40)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.Text = pageName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Parent = sidebar
    makeCorner(btn, 12)

    btn.MouseButton1Click:Connect(function()
        setSelectedTab(pageName)
    end)

    table.insert(tabs, { name = pageName, button = btn, page = page })
end

local homePage = pages["Home"]
local settingsPage = pages["Settings"]
local visualsPage = pages["Visuals"]
local aboutPage = pages["About"]

makeText(homePage, 20, "Quick Actions", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 14), UDim2.new(1, -32, 0, 30))

createButton(homePage, "🎨 Lobby Theme", 160, 50, 16, 60, Color3.fromRGB(80, 120, 255), function()
    print("Lobby Theme placeholder")
end)

createButton(homePage, "📖 Open Journal", 160, 50, 190, 60, Color3.fromRGB(55, 170, 120), function()
    print("Journal placeholder")
end)

createButton(homePage, "⚡ Boost UI", 160, 50, 16, 125, Color3.fromRGB(210, 130, 65), function()
    print("Boost UI placeholder")
end)

createButton(homePage, "🔧 Settings", 160, 50, 190, 125, Color3.fromRGB(200, 100, 150), function()
    setSelectedTab("Settings")
end)

local homeStatus = Instance.new("TextLabel")
homeStatus.Size = UDim2.new(1, -32, 0, 70)
homeStatus.Position = UDim2.new(0, 16, 0, 200)
homeStatus.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
homeStatus.BorderSizePixel = 0
homeStatus.Font = Enum.Font.Gotham
homeStatus.Text = "✓ Hub status: Ready\n✓ Safe UI loaded\n✓ Phone optimized"
homeStatus.TextColor3 = Color3.fromRGB(150, 200, 150)
homeStatus.TextSize = 14
homeStatus.TextWrapped = true
homeStatus.TextXAlignment = Enum.TextXAlignment.Left
homeStatus.TextYAlignment = Enum.TextYAlignment.Top
homeStatus.Parent = homePage
makeCorner(homeStatus, 12)

makeText(settingsPage, 20, "Settings", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 14), UDim2.new(1, -32, 0, 30))

createButton(settingsPage, "📊 FPS Counter", 200, 45, 16, 65, Color3.fromRGB(52, 100, 150), function()
    print("FPS toggle placeholder")
end)

createButton(settingsPage, "🎨 Switch Accent", 200, 45, 16, 125, Color3.fromRGB(150, 80, 180), function()
    print("Accent switch placeholder")
end)

createButton(settingsPage, "🔊 Toggle Sound", 200, 45, 16, 185, Color3.fromRGB(100, 150, 80), function()
    print("Sound toggle placeholder")
end)

makeText(visualsPage, 20, "Visuals", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 14), UDim2.new(1, -32, 0, 30))

createButton(visualsPage, "🌙 Dark Theme", 200, 45, 16, 65, Color3.fromRGB(140, 80, 255), function()
    print("Dark theme placeholder")
end)

createButton(visualsPage, "✨ Toggle Glow", 200, 45, 16, 125, Color3.fromRGB(255, 180, 80), function()
    print("Glow toggle placeholder")
end)

createButton(visualsPage, "🎆 Particles", 200, 45, 16, 185, Color3.fromRGB(100, 200, 200), function()
    print("Particles placeholder")
end)

makeText(aboutPage, 20, "About", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 14), UDim2.new(1, -32, 0, 30))

local aboutText = Instance.new("TextLabel")
aboutText.Size = UDim2.new(1, -32, 1, -60)
aboutText.Position = UDim2.new(0, 16, 0, 54)
aboutText.BackgroundTransparency = 1
aboutText.Font = Enum.Font.Gotham
aboutText.Text = "Dead Rails UI Prototype v2\n\n✓ Mobile & PC optimized\n✓ Smooth animations\n✓ Premium dark theme\n✓ Safe cosmetic UI only\n\nPress F4 or tap ☰ to toggle"
aboutText.TextColor3 = Color3.fromRGB(200, 200, 200)
aboutText.TextSize = 14
aboutText.TextWrapped = true
aboutText.TextXAlignment = Enum.TextXAlignment.Left
aboutText.TextYAlignment = Enum.TextYAlignment.Top
aboutText.Parent = aboutPage
makeCorner(aboutText, 12)

setSelectedTab("Home")
print("Dead Rails Hub Advanced loaded successfully!")
