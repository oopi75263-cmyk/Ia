-- Safe Dead Rails-inspired Roblox UI prototype
-- Designed for both PC and mobile play
-- Press the floating button to open/close the menu on phone

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeadRailsHub"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

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
    label.Parent = parent
    return label
end

local function createButton(parent, text, sizeX, sizeY, posX, posY, bgColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, sizeX, 0, sizeY)
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.BackgroundColor3 = bgColor or Color3.fromRGB(60, 60, 68)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Parent = parent
    makeCorner(btn, 10)
    return btn
end

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 64, 0, 64)
toggleButton.Position = UDim2.new(1, -88, 1, -88)
toggleButton.BackgroundColor3 = Color3.fromRGB(90, 110, 255)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "☰"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 28
toggleButton.Parent = screenGui
makeCorner(toggleButton, 18)
makeStroke(toggleButton, Color3.fromRGB(255, 255, 255), 0.2, 1)

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 560, 0, 360)
main.Position = UDim2.new(0.5, -280, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
main.BorderSizePixel = 0
main.Visible = false
main.Parent = screenGui
makeCorner(main, 18)
makeStroke(main, Color3.fromRGB(75, 75, 85), 0.7, 1)

local showMenu = false

local function setMenuVisible(value)
    showMenu = value
    main.Visible = value
    toggleButton.Text = value and "✕" or "☰"
end

toggleButton.MouseButton1Click:Connect(function()
    setMenuVisible(not showMenu)
end)

-- Optional: also allow PC users to open with F4 when available
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F4 then
        setMenuVisible(not showMenu)
    end
end)

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 56)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
header.BorderSizePixel = 0
header.Parent = main
makeCorner(header, 18)

makeText(header, 22, "DEAD RAILS HUB", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 18, 0, 0), UDim2.new(1, -120, 1, 0))

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(245, 80, 80)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 15
closeBtn.Parent = header
makeCorner(closeBtn, 8)
closeBtn.MouseButton1Click:Connect(function()
    setMenuVisible(false)
end)

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 132, 1, -72)
sidebar.Position = UDim2.new(0, 12, 0, 64)
sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
sidebar.BorderSizePixel = 0
sidebar.Parent = main
makeCorner(sidebar, 12)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -168, 1, -82)
content.Position = UDim2.new(0, 156, 0, 64)
content.BackgroundColor3 = Color3.fromRGB(26, 26, 30)
content.BorderSizePixel = 0
content.Parent = main
makeCorner(content, 12)

local tabs = {
    {name = "Home", button = nil, page = nil},
    {name = "Settings", button = nil, page = nil},
    {name = "Visuals", button = nil, page = nil},
    {name = "About", button = nil, page = nil},
}

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
        if tab.name == selected then
            tab.button.BackgroundColor3 = Color3.fromRGB(80, 110, 255)
        else
            tab.button.BackgroundColor3 = Color3.fromRGB(46, 46, 52)
        end

        if tab.page then
            tab.page.Visible = (tab.name == selected)
        end
    end
end

local homePage = createPage("Home")
local settingsPage = createPage("Settings")
local visualsPage = createPage("Visuals")
local aboutPage = createPage("About")

for idx, tabData in ipairs(tabs) do
    local pageName = tabData.name
    local page = nil

    if pageName == "Home" then
        page = homePage
    elseif pageName == "Settings" then
        page = settingsPage
    elseif pageName == "Visuals" then
        page = visualsPage
    elseif pageName == "About" then
        page = aboutPage
    end

    tabData.page = page

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 34)
    btn.Position = UDim2.new(0, 6, 0, 8 + (idx - 1) * 40)
    btn.BackgroundColor3 = (idx == 1) and Color3.fromRGB(80, 110, 255) or Color3.fromRGB(46, 46, 52)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = pageName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Parent = sidebar
    makeCorner(btn, 8)

    tabData.button = btn
    btn.MouseButton1Click:Connect(function()
        setSelectedTab(pageName)
    end)
end

-- Home Page
makeText(homePage, 18, "Quick Actions", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 14), UDim2.new(1, -32, 0, 30))

local action1 = createButton(homePage, "Lobby Theme", 150, 40, 16, 60, Color3.fromRGB(80, 120, 255))
action1.MouseButton1Click:Connect(function()
    print("Lobby Theme placeholder")
end)

local action2 = createButton(homePage, "Open Journal", 150, 40, 186, 60, Color3.fromRGB(55, 170, 120))
action2.MouseButton1Click:Connect(function()
    print("Journal placeholder")
end)

local action3 = createButton(homePage, "Boost UI", 150, 40, 16, 112, Color3.fromRGB(210, 130, 65))
action3.MouseButton1Click:Connect(function()
    print("Boost UI placeholder")
end)

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -32, 0, 58)
statusText.Position = UDim2.new(0, 16, 0, 180)
statusText.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
statusText.BorderSizePixel = 0
statusText.Font = Enum.Font.Gotham
statusText.Text = "Hub status: Ready\nSafe UI demo loaded successfully."
statusText.TextColor3 = Color3.fromRGB(220, 220, 220)
statusText.TextSize = 14
statusText.TextWrapped = true
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.TextYAlignment = Enum.TextYAlignment.Top
statusText.Parent = homePage
makeCorner(statusText, 10)

-- Settings Page
makeText(settingsPage, 18, "Settings", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 14), UDim2.new(1, -32, 0, 30))

local fpsToggle = createButton(settingsPage, "Toggle FPS Counter", 200, 38, 16, 60, Color3.fromRGB(52, 58, 70))
local fpsEnabled = false
fpsToggle.MouseButton1Click:Connect(function()
    fpsEnabled = not fpsEnabled
    fpsToggle.Text = fpsEnabled and "FPS Counter: ON" or "Toggle FPS Counter"
    print("FPS toggle placeholder:", fpsEnabled)
end)

local themeToggle = createButton(settingsPage, "Switch Accent", 200, 38, 16, 110, Color3.fromRGB(70, 90, 160))
themeToggle.MouseButton1Click:Connect(function()
    print("Accent switch placeholder")
end)

-- Visuals Page
makeText(visualsPage, 18, "Visuals", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 14), UDim2.new(1, -32, 0, 30))

local themeBtn = createButton(visualsPage, "Apply Dark Theme", 200, 38, 16, 60, Color3.fromRGB(140, 80, 255))
themeBtn.MouseButton1Click:Connect(function()
    print("Dark theme placeholder")
end)

local glowBtn = createButton(visualsPage, "Toggle Glow", 200, 38, 16, 110, Color3.fromRGB(85, 160, 120))
glowBtn.MouseButton1Click:Connect(function()
    print("Glow toggle placeholder")
end)

-- About Page
makeText(aboutPage, 18, "About", Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 14), UDim2.new(1, -32, 0, 30))

local aboutText = Instance.new("TextLabel")
aboutText.Size = UDim2.new(1, -32, 1, -60)
aboutText.Position = UDim2.new(0, 16, 0, 54)
aboutText.BackgroundTransparency = 1
aboutText.Font = Enum.Font.Gotham
aboutText.Text = "Dead Rails UI Prototype\n\nThis is a safe cosmetic menu created for learning Roblox UI design.\nIt contains placeholders for actions, settings, and visual toggles."
aboutText.TextColor3 = Color3.fromRGB(220, 220, 220)
aboutText.TextSize = 14
aboutText.TextWrapped = true
aboutText.TextXAlignment = Enum.TextXAlignment.Left
aboutText.TextYAlignment = Enum.TextYAlignment.Top
aboutText.Parent = aboutPage

setSelectedTab("Home")
print("Dead Rails Hub loaded successfully.")
