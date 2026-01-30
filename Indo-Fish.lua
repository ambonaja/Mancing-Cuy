-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Player
local player = Players.LocalPlayer

-- Fishing System
local FishingSystem = ReplicatedStorage:WaitForChild("FishingSystem")
local FishingEvents = FishingSystem:WaitForChild("FishingSystemEvents")
local FishGiver = FishingEvents:WaitForChild("FishGiver")

-- Daftar Ikan dari Assets
local allFish = {
    "1x1x1 Comet Shark",
    "1x1x1x1 Shark",
    "Ancient Lochness Monster",
    "Ancient Relic Crocodile",
    "Ancient Whale",
    "Angrylion Fish",
    "Blackcap Basslet",
    "Bleekers Damsel",
    "Boar Fish",
    "Cute Octopus",
    "Cute Octopus Blue",
    "Dead Scary Clownfish",
    "Dead Spooky Koi Fish",
    "ElRetro Gran Maja",
    "Fangtooth",
    "Flying Manta",
    "Frostborn Shark",
    "Frostborn Shark 1x1x1x1",
    "Frostborn Shark BloodMoon",
    "Frostborn Shark MidNight",
    "Frostborn Shark Pink",
    "Ghastly Crab",
    "Glacierfin Snapper",
    "Goliath Tiger",
    "Hermit Crab",
    "Jellyfish",
    "Lion Fish",
    "Lochness Monster",
    "Lochness Monster Pink",
    "Loving Shark",
    "Luminous Fish",
    "Monster Shark",
    "Pink Dolphin",
    "Plasma Shark",
    "Pumpkin Carved Shark",
    "Queen Crab",
    "Robot Kraken",
    "Robot Kraken Pink",
    "Wraithfin Abyssal",
    "Zombie Shark"
}

-- Konfigurasi default
local config = {
    selectedFish = "Pink Dolphin",
    fishingInterval = 1,
    autoSelectRarest = false
}

-- State
local isFarming = false
local isOpen = true
local isDragging = false
local dragOffset = Vector2.new(0, 0)
local currentPage = "main" -- main, fishList
local stats = {
    totalFish = 0,
    startTime = 0,
    lastFishTime = 0
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFishGUIMobilePro"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999

if gethui then
    screenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(screenGui)
    screenGui.Parent = game:GetService("CoreGui")
else
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Main Container dengan Scroll untuk Halaman Utama
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 350, 0, 450) -- Sedikit lebih tinggi
mainContainer.Position = UDim2.new(0.02, 0, 0.02, 0)
mainContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainContainer.BorderSizePixel = 0
mainContainer.Active = true
mainContainer.Draggable = false
mainContainer.ClipsDescendants = true
mainContainer.Parent = screenGui

-- Rounded Corners
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 16)
uiCorner.Parent = mainContainer

-- Drop Shadow
local uiShadow = Instance.new("UIStroke")
uiShadow.Color = Color3.fromRGB(0, 0, 0)
uiShadow.Thickness = 3
uiShadow.Transparency = 0.7
uiShadow.Parent = mainContainer

-- Header (Fixed Position)
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
header.BorderSizePixel = 0
header.ZIndex = 10
header.Parent = mainContainer

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

-- Title dengan Page Indicator
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 70, 0, 0)
title.BackgroundTransparency = 1
title.Text = "AmbonXJule"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 11
title.Parent = header

-- Page Indicator
local pageIndicator = Instance.new("TextLabel")
pageIndicator.Name = "PageIndicator"
pageIndicator.Size = UDim2.new(0, 80, 0, 20)
pageIndicator.Position = UDim2.new(1, -90, 0.5, -10)
pageIndicator.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
pageIndicator.BorderSizePixel = 0
pageIndicator.Text = "MAIN"
pageIndicator.TextColor3 = Color3.fromRGB(180, 220, 255)
pageIndicator.Font = Enum.Font.GothamBold
pageIndicator.TextSize = 12
pageIndicator.ZIndex = 11
pageIndicator.Parent = header

local pageIndicatorCorner = Instance.new("UICorner")
pageIndicatorCorner.CornerRadius = UDim.new(0, 10)
pageIndicatorCorner.Parent = pageIndicator

-- Close/Open Button
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(0, 5, 0.5, -20)
toggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
toggleButton.BorderSizePixel = 0
toggleButton.Image = "rbxassetid://3926305904"
toggleButton.ImageRectOffset = Vector2.new(924, 724)
toggleButton.ImageRectSize = Vector2.new(36, 36)
toggleButton.ImageColor3 = Color3.fromRGB(220, 220, 220)
toggleButton.ScaleType = Enum.ScaleType.Fit
toggleButton.ZIndex = 11
toggleButton.Parent = header

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Main Content Scrolling Frame (untuk halaman utama)
local mainContentScroll = Instance.new("ScrollingFrame")
mainContentScroll.Name = "MainContentScroll"
mainContentScroll.Size = UDim2.new(1, 0, 1, -50)
mainContentScroll.Position = UDim2.new(0, 0, 0, 50)
mainContentScroll.BackgroundTransparency = 1
mainContentScroll.BorderSizePixel = 0
mainContentScroll.ScrollBarThickness = 6
mainContentScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
mainContentScroll.ScrollingDirection = Enum.ScrollingDirection.Y
mainContentScroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always
mainContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
mainContentScroll.CanvasSize = UDim2.new(0, 0, 0, 500)
mainContentScroll.Parent = mainContainer

-- MAIN PAGE
local mainPage = Instance.new("Frame")
mainPage.Name = "MainPage"
mainPage.Size = UDim2.new(1, 0, 0, 500)
mainPage.BackgroundTransparency = 1
mainPage.Visible = true
mainPage.Parent = mainContentScroll

local mainPageLayout = Instance.new("UIListLayout")
mainPageLayout.Name = "MainPageLayout"
mainPageLayout.Padding = UDim.new(0, 10)
mainPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
mainPageLayout.Parent = mainPage

-- Status Display
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Size = UDim2.new(1, 0, 0, 70)
statusFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
statusFrame.BorderSizePixel = 0
statusFrame.LayoutOrder = 1
statusFrame.Parent = mainPage

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 10)
statusCorner.Parent = statusFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 10)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🔄 STATUS"
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusFrame

local statusValue = Instance.new("TextLabel")
statusValue.Name = "StatusValue"
statusValue.Size = UDim2.new(1, -20, 0, 30)
statusValue.Position = UDim2.new(0, 10, 0, 35)
statusValue.BackgroundTransparency = 1
statusValue.Text = "OFFLINE"
statusValue.TextColor3 = Color3.fromRGB(255, 100, 100)
statusValue.Font = Enum.Font.GothamBold
statusValue.TextSize = 22
statusValue.TextXAlignment = Enum.TextXAlignment.Left
statusValue.Parent = statusFrame

-- Current Fish Display
local currentFishFrame = Instance.new("Frame")
currentFishFrame.Name = "CurrentFishFrame"
currentFishFrame.Size = UDim2.new(1, 0, 0, 100)
currentFishFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
currentFishFrame.BorderSizePixel = 0
currentFishFrame.LayoutOrder = 2
currentFishFrame.Parent = mainPage

local currentFishCorner = Instance.new("UICorner")
currentFishCorner.CornerRadius = UDim.new(0, 10)
currentFishCorner.Parent = currentFishFrame

local currentFishLabel = Instance.new("TextLabel")
currentFishLabel.Name = "CurrentFishLabel"
currentFishLabel.Size = UDim2.new(1, -20, 0, 25)
currentFishLabel.Position = UDim2.new(0, 10, 0, 10)
currentFishLabel.BackgroundTransparency = 1
currentFishLabel.Text = "🎯 IKAN TARGET"
currentFishLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
currentFishLabel.Font = Enum.Font.Gotham
currentFishLabel.TextSize = 14
currentFishLabel.TextXAlignment = Enum.TextXAlignment.Left
currentFishLabel.Parent = currentFishFrame

local fishNameValue = Instance.new("TextLabel")
fishNameValue.Name = "FishNameValue"
fishNameValue.Size = UDim2.new(0.7, -10, 0, 30)
fishNameValue.Position = UDim2.new(0, 10, 0, 35)
fishNameValue.BackgroundTransparency = 1
fishNameValue.Text = config.selectedFish
fishNameValue.TextColor3 = Color3.fromRGB(255, 182, 193)
fishNameValue.Font = Enum.Font.GothamBold
fishNameValue.TextSize = 18
fishNameValue.TextXAlignment = Enum.TextXAlignment.Left
fishNameValue.TextTruncate = Enum.TextTruncate.AtEnd
fishNameValue.Parent = currentFishFrame

-- Change Fish Button
local changeFishButton = Instance.new("TextButton")
changeFishButton.Name = "ChangeFishButton"
changeFishButton.Size = UDim2.new(0.25, 0, 0, 30)
changeFishButton.Position = UDim2.new(0.75, 5, 0, 35)
changeFishButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
changeFishButton.BorderSizePixel = 0
changeFishButton.Text = "GANTI"
changeFishButton.TextColor3 = Color3.fromRGB(255, 255, 255)
changeFishButton.Font = Enum.Font.GothamBold
changeFishButton.TextSize = 14
changeFishButton.Parent = currentFishFrame

local changeFishCorner = Instance.new("UICorner")
changeFishCorner.CornerRadius = UDim.new(0, 8)
changeFishCorner.Parent = changeFishButton

-- Stats Display
local statsFrame = Instance.new("Frame")
statsFrame.Name = "StatsFrame"
statsFrame.Size = UDim2.new(1, 0, 0, 70)
statsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
statsFrame.BorderSizePixel = 0
statsFrame.LayoutOrder = 3
statsFrame.Parent = mainPage

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 10)
statsCorner.Parent = statsFrame

local statsLabel = Instance.new("TextLabel")
statsLabel.Name = "StatsLabel"
statsLabel.Size = UDim2.new(1, -20, 0, 25)
statsLabel.Position = UDim2.new(0, 10, 0, 5)
statsLabel.BackgroundTransparency = 1
statsLabel.Text = "📊 STATISTIK"
statsLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
statsLabel.Font = Enum.Font.Gotham
statsLabel.TextSize = 14
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.Parent = statsFrame

local totalFishLabel = Instance.new("TextLabel")
totalFishLabel.Name = "TotalFishLabel"
totalFishLabel.Size = UDim2.new(0.5, -15, 0, 20)
totalFishLabel.Position = UDim2.new(0, 10, 0, 35)
totalFishLabel.BackgroundTransparency = 1
totalFishLabel.Text = "Total: 0"
totalFishLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
totalFishLabel.Font = Enum.Font.Gotham
totalFishLabel.TextSize = 16
totalFishLabel.TextXAlignment = Enum.TextXAlignment.Left
totalFishLabel.Parent = statsFrame

local timeLabel = Instance.new("TextLabel")
timeLabel.Name = "TimeLabel"
timeLabel.Size = UDim2.new(0.5, -15, 0, 20)
timeLabel.Position = UDim2.new(0.5, 5, 0, 35)
timeLabel.BackgroundTransparency = 1
timeLabel.Text = "Waktu: 0s"
timeLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
timeLabel.Font = Enum.Font.Gotham
timeLabel.TextSize = 16
timeLabel.TextXAlignment = Enum.TextXAlignment.Left
timeLabel.Parent = statsFrame

-- Settings Frame
local settingsFrame = Instance.new("Frame")
settingsFrame.Name = "SettingsFrame"
settingsFrame.Size = UDim2.new(1, 0, 0, 50)
settingsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
settingsFrame.BorderSizePixel = 0
settingsFrame.LayoutOrder = 4
settingsFrame.Parent = mainPage

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 10)
settingsCorner.Parent = settingsFrame

local intervalLabel = Instance.new("TextLabel")
intervalLabel.Name = "IntervalLabel"
intervalLabel.Size = UDim2.new(0.6, -10, 1, 0)
intervalLabel.Position = UDim2.new(0, 10, 0, 0)
intervalLabel.BackgroundTransparency = 1
intervalLabel.Text = "Interval: 1 detik"
intervalLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
intervalLabel.Font = Enum.Font.Gotham
intervalLabel.TextSize = 14
intervalLabel.TextXAlignment = Enum.TextXAlignment.Left
intervalLabel.Parent = settingsFrame

local intervalButton = Instance.new("TextButton")
intervalButton.Name = "IntervalButton"
intervalButton.Size = UDim2.new(0.35, -10, 0, 30)
intervalButton.Position = UDim2.new(0.65, 5, 0.5, -15)
intervalButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
intervalButton.BorderSizePixel = 0
intervalButton.Text = "UBAH"
intervalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
intervalButton.Font = Enum.Font.GothamBold
intervalButton.TextSize = 12
intervalButton.Parent = settingsFrame

local intervalCorner = Instance.new("UICorner")
intervalCorner.CornerRadius = UDim.new(0, 8)
intervalCorner.Parent = intervalButton

-- Main Action Button
local toggleFarmButton = Instance.new("TextButton")
toggleFarmButton.Name = "ToggleFarmButton"
toggleFarmButton.Size = UDim2.new(1, 0, 0, 50)
toggleFarmButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
toggleFarmButton.BorderSizePixel = 0
toggleFarmButton.Text = "▶️ START GENJOT"
toggleFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleFarmButton.Font = Enum.Font.GothamBold
toggleFarmButton.TextSize = 20
toggleFarmButton.AutoButtonColor = false
toggleFarmButton.LayoutOrder = 5
toggleFarmButton.Parent = mainPage

local toggleFarmCorner = Instance.new("UICorner")
toggleFarmCorner.CornerRadius = UDim.new(0, 10)
toggleFarmCorner.Parent = toggleFarmButton

-- Additional Info Frame (Contoh tambahan untuk scroll)
local infoFrame = Instance.new("Frame")
infoFrame.Name = "InfoFrame"
infoFrame.Size = UDim2.new(1, 0, 0, 80)
infoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
infoFrame.BorderSizePixel = 0
infoFrame.LayoutOrder = 6
infoFrame.Parent = mainPage

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 10)
infoCorner.Parent = infoFrame

local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "InfoLabel"
infoLabel.Size = UDim2.new(1, -20, 0, 30)
infoLabel.Position = UDim2.new(0, 10, 0, 10)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "ℹ️ INFORMASI"
infoLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 14
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = infoFrame

local infoText = Instance.new("TextLabel")
infoText.Name = "InfoText"
infoText.Size = UDim2.new(1, -20, 0, 40)
infoText.Position = UDim2.new(0, 10, 0, 40)
infoText.BackgroundTransparency = 1
infoText.Text = "GUI bisa di-scroll untuk melihat lebih banyak konten. Gunakan jari untuk scroll ke atas/bawah."
infoText.TextColor3 = Color3.fromRGB(200, 200, 220)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 12
infoText.TextWrapped = true
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.Parent = infoFrame

-- FISH LIST PAGE (Scrolling Frame terpisah)
local fishListPage = Instance.new("Frame")
fishListPage.Name = "FishListPage"
fishListPage.Size = UDim2.new(1, 0, 1, -50)
fishListPage.Position = UDim2.new(0, 0, 0, 50)
fishListPage.BackgroundTransparency = 1
fishListPage.Visible = false
fishListPage.Parent = mainContainer

-- Search Bar (Fixed di atas)
local searchFrame = Instance.new("Frame")
searchFrame.Name = "SearchFrame"
searchFrame.Size = UDim2.new(1, -20, 0, 40)
searchFrame.Position = UDim2.new(0, 10, 0, 0)
searchFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
searchFrame.BorderSizePixel = 0
searchFrame.ZIndex = 5
searchFrame.Parent = fishListPage

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 10)
searchCorner.Parent = searchFrame

local searchBox = Instance.new("TextBox")
searchBox.Name = "SearchBox"
searchBox.Size = UDim2.new(1, -50, 1, -10)
searchBox.Position = UDim2.new(0, 10, 0, 5)
searchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
searchBox.BorderSizePixel = 0
searchBox.Text = "Pilih janda..."
searchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
searchBox.PlaceholderText = "pilih janda..."
searchBox.ClearTextOnFocus = false
searchBox.ZIndex = 6
searchBox.Parent = searchFrame

local searchBoxCorner = Instance.new("UICorner")
searchBoxCorner.CornerRadius = UDim.new(0, 8)
searchBoxCorner.Parent = searchBox

local searchIcon = Instance.new("ImageLabel")
searchIcon.Name = "SearchIcon"
searchIcon.Size = UDim2.new(0, 25, 0, 25)
searchIcon.Position = UDim2.new(1, -35, 0.5, -12.5)
searchIcon.BackgroundTransparency = 1
searchIcon.Image = "rbxassetid://3926305904"
searchIcon.ImageRectOffset = Vector2.new(964, 324)
searchIcon.ImageRectSize = Vector2.new(36, 36)
searchIcon.ImageColor3 = Color3.fromRGB(180, 180, 200)
searchIcon.ZIndex = 6
searchIcon.Parent = searchFrame

-- Fish List Container dengan Scroll
local fishListScroll = Instance.new("ScrollingFrame")
fishListScroll.Name = "FishListScroll"
fishListScroll.Size = UDim2.new(1, 0, 1, -90) -- Meninggalkan ruang untuk search dan back button
fishListScroll.Position = UDim2.new(0, 0, 0, 50)
fishListScroll.BackgroundTransparency = 1
fishListScroll.BorderSizePixel = 0
fishListScroll.ScrollBarThickness = 8
fishListScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
fishListScroll.ScrollingDirection = Enum.ScrollingDirection.Y
fishListScroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always
fishListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
fishListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
fishListScroll.Parent = fishListPage

-- Container untuk item ikan
local fishListContainer = Instance.new("Frame")
fishListContainer.Name = "FishListContainer"
fishListContainer.Size = UDim2.new(1, 0, 0, 0)
fishListContainer.BackgroundTransparency = 1
fishListContainer.Parent = fishListScroll

local listLayout = Instance.new("UIListLayout")
listLayout.Name = "ListLayout"
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.Name
listLayout.Parent = fishListContainer

-- Update canvas size secara otomatis
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    fishListScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    fishListContainer.Size = UDim2.new(1, 0, 0, listLayout.AbsoluteContentSize.Y)
end)

-- Back Button (Fixed di bawah)
local backButton = Instance.new("TextButton")
backButton.Name = "BackButton"
backButton.Size = UDim2.new(1, -20, 0, 40)
backButton.Position = UDim2.new(0, 10, 1, -50)
backButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
backButton.BorderSizePixel = 0
backButton.Text = "⬅️ KEMBALI"
backButton.TextColor3 = Color3.fromRGB(255, 255, 255)
backButton.Font = Enum.Font.GothamBold
backButton.TextSize = 18
backButton.AutoButtonColor = false
backButton.ZIndex = 5
backButton.Parent = fishListPage

local backButtonCorner = Instance.new("UICorner")
backButtonCorner.CornerRadius = UDim.new(0, 10)
backButtonCorner.Parent = backButton

-- Functions
local function createFishListItem(fishName)
    local item = Instance.new("Frame")
    item.Name = fishName
    item.Size = UDim2.new(1, 0, 0, 50)
    item.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    item.BorderSizePixel = 0
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 8)
    itemCorner.Parent = item
    
    local fishText = Instance.new("TextLabel")
    fishText.Name = "FishText"
    fishText.Size = UDim2.new(0.8, -10, 1, 0)
    fishText.Position = UDim2.new(0, 10, 0, 0)
    fishText.BackgroundTransparency = 1
    fishText.Text = fishName
    fishText.TextColor3 = Color3.fromRGB(220, 220, 220)
    fishText.Font = Enum.Font.Gotham
    fishText.TextSize = 14
    fishText.TextXAlignment = Enum.TextXAlignment.Left
    fishText.TextTruncate = Enum.TextTruncate.AtEnd
    fishText.Parent = item
    
    local selectButton = Instance.new("TextButton")
    selectButton.Name = "SelectButton"
    selectButton.Size = UDim2.new(0.15, 0, 0, 30)
    selectButton.Position = UDim2.new(0.85, 5, 0.5, -15)
    selectButton.BackgroundColor3 = Color3.fromRGB(70, 160, 70)
    selectButton.BorderSizePixel = 0
    selectButton.Text = "PILIH"
    selectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    selectButton.Font = Enum.Font.GothamBold
    selectButton.TextSize = 12
    selectButton.Parent = item
    
    local selectCorner = Instance.new("UICorner")
    selectCorner.CornerRadius = UDim.new(0, 6)
    selectCorner.Parent = selectButton
    
    -- Highlight jika ini ikan yang sedang dipilih
    if fishName == config.selectedFish then
        item.BackgroundColor3 = Color3.fromRGB(50, 70, 90)
        fishText.TextColor3 = Color3.fromRGB(255, 255, 255)
        selectButton.BackgroundColor3 = Color3.fromRGB(90, 180, 90)
    end
    
    -- Animasi hover
    selectButton.MouseEnter:Connect(function()
        if fishName ~= config.selectedFish then
            selectButton.BackgroundColor3 = Color3.fromRGB(90, 180, 90)
        end
    end)
    
    selectButton.MouseLeave:Connect(function()
        if fishName ~= config.selectedFish then
            selectButton.BackgroundColor3 = Color3.fromRGB(70, 160, 70)
        end
    end)
    
    selectButton.MouseButton1Click:Connect(function()
        config.selectedFish = fishName
        fishNameValue.Text = fishName
        switchPage("main")
        
        -- Update semua item untuk highlight yang dipilih
        for _, child in pairs(fishListContainer:GetChildren()) do
            if child:IsA("Frame") then
                if child.Name == fishName then
                    child.BackgroundColor3 = Color3.fromRGB(50, 70, 90)
                    child.FishText.TextColor3 = Color3.fromRGB(255, 255, 255)
                    child.SelectButton.BackgroundColor3 = Color3.fromRGB(90, 180, 90)
                else
                    child.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                    child.FishText.TextColor3 = Color3.fromRGB(220, 220, 220)
                    child.SelectButton.BackgroundColor3 = Color3.fromRGB(70, 160, 70)
                end
            end
        end
    end)
    
    return item
end

local function populateFishList()
    -- Clear existing items
    for _, child in pairs(fishListContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Add all fish
    for _, fishName in pairs(allFish) do
        local item = createFishListItem(fishName)
        item.Parent = fishListContainer
    end
end

local function filterFishList(searchText)
    searchText = string.lower(searchText)
    
    for _, child in pairs(fishListContainer:GetChildren()) do
        if child:IsA("Frame") then
            local fishName = string.lower(child.Name)
            if searchText == "" or string.find(fishName, searchText, 1, true) then
                child.Visible = true
            else
                child.Visible = false
            end
        end
    end
end

local function switchPage(pageName)
    currentPage = pageName
    pageIndicator.Text = string.upper(pageName)
    
    if pageName == "main" then
        mainContentScroll.Visible = true
        fishListPage.Visible = false
        mainContentScroll.CanvasPosition = Vector2.new(0, 0) -- Reset scroll position
    elseif pageName == "fishList" then
        mainContentScroll.Visible = false
        fishListPage.Visible = true
        populateFishList()
        fishListScroll.CanvasPosition = Vector2.new(0, 0) -- Reset scroll position
    end
end

local function fish()
    local fishData = {
        hookPosition = Vector3.new(489.07623291015625, 21.149999618530273, -93.75650024414062),
        name = config.selectedFish,
        rarity = "Secret",
        weight = 999
    }
    
    local args = {fishData}
    local success = pcall(function()
        FishGiver:FireServer(unpack(args))
    end)
    
    if success then
        stats.totalFish = stats.totalFish + 1
        stats.lastFishTime = tick()
        totalFishLabel.Text = "Total: " .. stats.totalFish
    end
end

-- Auto Farm Loop
local connection
local function startFarming()
    if connection then
        connection:Disconnect()
    end
    
    isFarming = true
    stats.startTime = tick()
    stats.totalFish = 0
    
    statusValue.Text = "FARMING..."
    statusValue.TextColor3 = Color3.fromRGB(100, 255, 100)
    toggleFarmButton.Text = "⏸️ STOP GENJOT"
    toggleFarmButton.BackgroundColor3 = Color3.fromRGB(60, 160, 60)
    
    -- Fish immediately first time
    fish()
    
    -- Then fish at intervals
    local lastFishTime = tick()
    connection = RunService.Heartbeat:Connect(function()
        -- Update time
        local elapsedTime = math.floor(tick() - stats.startTime)
        local minutes = math.floor(elapsedTime / 60)
        local seconds = elapsedTime % 60
        timeLabel.Text = string.format("Waktu: %d:%02d", minutes, seconds)
        
        -- Fish at interval
        if tick() - lastFishTime >= config.fishingInterval then
            fish()
            lastFishTime = tick()
        end
    end)
end

local function stopFarming()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    isFarming = false
    statusValue.Text = "OFFLINE"
    statusValue.TextColor3 = Color3.fromRGB(255, 100, 100)
    toggleFarmButton.Text = "▶️ START GENJOT"
    toggleFarmButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
end

-- GUI Dragging
local function updateDrag(input)
    if isDragging then
        local delta = input.Position - dragOffset
        mainContainer.Position = UDim2.new(
            0, delta.X,
            0, delta.Y
        )
    end
end

-- Button Animation
local function animateButton(button)
    local originalSize = button.Size
    local originalColor = button.BackgroundColor3
    
    button.MouseButton1Down:Connect(function()
        local tweenIn = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(originalSize.X.Scale * 0.95, originalSize.X.Offset * 0.95, originalSize.Y.Scale * 0.95, originalSize.Y.Offset * 0.95),
            BackgroundColor3 = Color3.fromRGB(
                math.floor(originalColor.R * 255 * 0.8),
                math.floor(originalColor.G * 255 * 0.8),
                math.floor(originalColor.B * 255 * 0.8)
            )
        })
        tweenIn:Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        local tweenOut = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = originalSize,
            BackgroundColor3 = originalColor
        })
        tweenOut:Play()
    end)
end

-- Smooth Scroll untuk Mobile
local function setupSmoothScroll(scrollFrame)
    local scrollSpeed = 50
    local isScrolling = false
    local lastTouchPosition = nil
    
    if UserInputService.TouchEnabled then
        -- Touch scrolling
        scrollFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                isScrolling = true
                lastTouchPosition = input.Position
            end
        end)
        
        scrollFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch and isScrolling and lastTouchPosition then
                local delta = lastTouchPosition.Y - input.Position.Y
                scrollFrame.CanvasPosition = Vector2.new(
                    0,
                    math.clamp(scrollFrame.CanvasPosition.Y + delta * 2, 0, scrollFrame.CanvasSize.Y.Offset - scrollFrame.AbsoluteWindowSize.Y)
                )
                lastTouchPosition = input.Position
            end
        end)
        
        scrollFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                isScrolling = false
                lastTouchPosition = nil
            end
        end)
    end
end

-- Input Handling
local function setupInput()
    -- Drag header untuk memindahkan GUI
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragOffset = input.Position
        end
    end)
    
    header.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and isDragging then
            updateDrag(input)
        end
    end)
    
    header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
end

-- Event Connections
toggleButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    
    if isOpen then
        toggleButton.ImageRectOffset = Vector2.new(924, 724)
        mainContainer:TweenSize(
            UDim2.new(0, 350, 0, 450),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.3,
            true
        )
    else
        toggleButton.ImageRectOffset = Vector2.new(964, 284)
        mainContainer:TweenSize(
            UDim2.new(0, 350, 0, 50),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.3,
            true
        )
    end
end)

toggleFarmButton.MouseButton1Click:Connect(function()
    if isFarming then
        stopFarming()
    else
        startFarming()
    end
end)

changeFishButton.MouseButton1Click:Connect(function()
    switchPage("fishList")
end)

backButton.MouseButton1Click:Connect(function()
    switchPage("main")
end)

intervalButton.MouseButton1Click:Connect(function()
    -- Simple interval changer
    if config.fishingInterval == 1 then
        config.fishingInterval = 2
        intervalLabel.Text = "Interval: 2 detik"
    elseif config.fishingInterval == 2 then
        config.fishingInterval = 0.5
        intervalLabel.Text = "Interval: 0.5 detik"
    else
        config.fishingInterval = 1
        intervalLabel.Text = "Interval: 1 detik"
    end
end)

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    filterFishList(searchBox.Text)
end)

searchBox.Focused:Connect(function()
    if searchBox.Text == "Pilih janda..." then
        searchBox.Text = ""
        searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

searchBox.FocusLost:Connect(function()
    if searchBox.Text == "" then
        searchBox.Text = "Pilih janda..."
        searchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- Apply animations
animateButton(toggleFarmButton)
animateButton(changeFishButton)
animateButton(intervalButton)
animateButton(backButton)

-- Setup smooth scroll
setupSmoothScroll(mainContentScroll)
setupSmoothScroll(fishListScroll)

-- Setup input
setupInput()

-- Initialize
statusValue.Text = "OFFLINE"
statusValue.TextColor3 = Color3.fromRGB(255, 100, 100)
toggleFarmButton.Text = "▶️ START GENJOT"
toggleFarmButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
totalFishLabel.Text = "Total: 0"
timeLabel.Text = "Waktu: 0s"
intervalLabel.Text = "Interval: " .. config.fishingInterval .. " detik"
fishNameValue.Text = config.selectedFish

print("🎣 Auto Fish Farm Pro dengan Scroll Loaded!")
print("📱 GUI memiliki scroll smooth untuk semua halaman")
print("👆 Halaman utama bisa di-scroll")
print("🐟 Halaman daftar ikan dengan scroll smooth")
print("🔍 " .. #allFish .. " jenis ikan tersedia")