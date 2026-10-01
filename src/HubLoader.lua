-- Main loader for the menu.
-- Place this script in StarterPlayer > StarterPlayerScripts.
-- Safe cosmetic UI project.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Config = require(script.Parent:WaitForChild("Config"))
local UIBuilder = require(script.Parent:WaitForChild("UIBuilder"))

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeadRailsHub"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 70, 0, 70)
toggleButton.Position = UDim2.new(1, -92, 1, -92)
toggleButton.BackgroundColor3 = Config.Menu.Accent
toggleButton.BorderSizePixel = 0
toggleButton.Text = "☰"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 28
toggleButton.Parent = screenGui
UIBuilder.makeCorner(toggleButton, 18)
UIBuilder.makeStroke(toggleButton, Color3.fromRGB(255, 255, 255), 0.2, 1)

local main = UIBuilder.createPanel(
    screenGui,
    UDim2.new(0, Config.Menu.Width, 0, Config.Menu.Height),
    UDim2.new(0.5, -Config.Menu.Width / 2, 0.5, -Config.Menu.Height / 2),
    Config.Menu.Background,
    18
)
main.Visible = false
UIBuilder.makeStroke(main, Color3.fromRGB(75, 75, 85), 0.7, 1)

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

local header = UIBuilder.createPanel(main, UDim2.new(1, 0, 0, 56), UDim2.new(0, 0, 0, 0), Config.Menu.HeaderBackground, 18)
UIBuilder.makeText(header, 22, "DEAD RAILS HUB", Enum.Font.GothamBold, Config.Menu.PanelText, Enum.TextXAlignment.Left, UDim2.new(0, 18, 0, 0), UDim2.new(1, -120, 1, 0))

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.BackgroundColor3 = Config.Colors.Red
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 15
closeBtn.Parent = header
UIBuilder.makeCorner(closeBtn, 8)
closeBtn.MouseButton1Click:Connect(function()
    setMenuVisible(false)
end)

local sidebar = UIBuilder.createPanel(main, UDim2.new(0, 132, 1, -72), UDim2.new(0, 12, 0, 64), Config.Menu.SidebarBackground, 12)
local content = UIBuilder.createPanel(main, UDim2.new(1, -168, 1, -82), UDim2.new(0, 156, 0, 64), Config.Menu.SecondaryBackground, 12)

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
        tab.button.BackgroundColor3 = isSelected and Config.Menu.Accent or Config.Colors.Gray
        tab.page.Visible = isSelected
    end
end

for idx, pageName in ipairs(Config.Pages) do
    local page = createPage(pageName)
    pages[pageName] = page

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 34)
    btn.Position = UDim2.new(0, 6, 0, 8 + (idx - 1) * 40)
    btn.BackgroundColor3 = (idx == 1) and Config.Menu.Accent or Config.Colors.Gray
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = pageName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Parent = sidebar
    UIBuilder.makeCorner(btn, 8)

    btn.MouseButton1Click:Connect(function()
        setSelectedTab(pageName)
    end)

    table.insert(tabs, {
        name = pageName,
        button = btn,
        page = page,
    })
end

local homePage = pages["Home"]
local settingsPage = pages["Settings"]
local visualsPage = pages["Visuals"]
local aboutPage = pages["About"]

UIBuilder.makeText(homePage, 18, "Quick Actions", Enum.Font.GothamBold, Config.Menu.PanelText, Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 14), UDim2.new(1, -32, 0, 30))

local action1 = UIBuilder.createButton(homePage, "Lobby Theme", 150, 40, 16, 60, Config.Colors.Blue)
local action2 = UIBuilder.createButton(homePage, "Open Journal", 150, 40, 186, 60, Config.Colors.Green)
local action3 = UIBuilder.createButton(homePage, "Boost UI", 150, 40, 16, 112, Config.Colors.Orange)

action1.MouseButton1Click:Connect(function()
    print("Lobby Theme placeholder")
end)
action2.MouseButton1Click:Connect(function()
    print("Journal placeholder")
end)
action3.MouseButton1Click:Connect(function()
    print("Boost UI placeholder")
end)

local homeStatus = Instance.new("TextLabel")
homeStatus.Size = UDim2.new(1, -32, 0, 58)
homeStatus.Position = UDim2.new(0, 16, 0, 180)
homeStatus.BackgroundColor3 = Config.Colors.DarkGray
homeStatus.BorderSizePixel = 0
homeStatus.Font = Enum.Font.Gotham
homeStatus.Text = "Hub status: Ready\nSafe UI demo loaded successfully."
homeStatus.TextColor3 = Config.Menu.SubText
homeStatus.TextSize = 14
homeStatus.TextWrapped = true
homeStatus.TextXAlignment = Enum.TextXAlignment.Left
homeStatus.TextYAlignment = Enum.TextYAlignment.Top
homeStatus.Parent = homePage
UIBuilder.makeCorner(homeStatus, 10)

UIBuilder.makeText(settingsPage, 18, "Settings", Enum.Font.GothamBold, Config.Menu.PanelText, Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 14), UDim2.new(1, -32, 0, 30))
local fpsToggle = UIBuilder.createButton(settingsPage, "Toggle FPS Counter", 200, 38, 16, 60, Config.Colors.Gray)
local fpsEnabled = false
fpsToggle.MouseButton1Click:Connect(function()
    fpsEnabled = not fpsEnabled
    fpsToggle.Text = fpsEnabled and "FPS Counter: ON" or "Toggle FPS Counter"
    print("FPS toggle placeholder:", fpsEnabled)
end)

local accentBtn = UIBuilder.createButton(settingsPage, "Switch Accent", 200, 38, 16, 110, Color3.fromRGB(70, 90, 160))
accentBtn.MouseButton1Click:Connect(function()
    print("Accent switch placeholder")
end)

UIBuilder.makeText(visualsPage, 18, "Visuals", Enum.Font.GothamBold, Config.Menu.PanelText, Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 14), UDim2.new(1, -32, 0, 30))
local themeBtn = UIBuilder.createButton(visualsPage, "Apply Dark Theme", 200, 38, 16, 60, Config.Colors.Purple)
local glowBtn = UIBuilder.createButton(visualsPage, "Toggle Glow", 200, 38, 16, 110, Config.Colors.Green)

themeBtn.MouseButton1Click:Connect(function()
    print("Dark theme placeholder")
end)
glowBtn.MouseButton1Click:Connect(function()
    print("Glow toggle placeholder")
end)

UIBuilder.makeText(aboutPage, 18, "About", Enum.Font.GothamBold, Config.Menu.PanelText, Enum.TextXAlignment.Left, UDim2.new(0, 16, 0, 14), UDim2.new(1, -32, 0, 30))

local aboutText = Instance.new("TextLabel")
aboutText.Size = UDim2.new(1, -32, 1, -60)
aboutText.Position = UDim2.new(0, 16, 0, 54)
aboutText.BackgroundTransparency = 1
aboutText.Font = Enum.Font.Gotham
aboutText.Text = "Dead Rails UI Prototype\n\nThis project is a safe cosmetic menu created for learning Roblox UI design.\nIt includes placeholders for actions and menu settings."
aboutText.TextColor3 = Config.Menu.SubText
aboutText.TextSize = 14
aboutText.TextWrapped = true
aboutText.TextXAlignment = Enum.TextXAlignment.Left
aboutText.TextYAlignment = Enum.TextYAlignment.Top
aboutText.Parent = aboutPage

setSelectedTab("Home")
print("Dead Rails Hub loaded successfully.")
