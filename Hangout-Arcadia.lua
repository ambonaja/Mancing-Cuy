-- Auto Farm Fishing GUI Mobile Version with Pages
-- Created for Roblox fishing games on Mobile

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

-- Daftar semua ikan dari aset
local FishAssets = {
    "Ancient Crocodile",
    "Ancient Monster Shark", 
    "Ancient Whale",
    "Blackcap Basslet",
    "Boar Fish",
    "Dead Scary Clownfish",
    "Dead Spooky Koi Fish",
    "Fangtooth",
    "Freshwater Piranha",
    "Goliath Tiger",
    "Hermit Crab",
    "Holiday Turtle",
    "Jellyfish",
    "Lion Fish",
    "Loving Shark",
    "Luminous Fish",
    "Pink Dolphin",
    "Plasma Shark",
    "Pumpkin Carved Shark",
    "Queen Crab",
    "Toxic Jellyfish",
    "Transcended Gem",
    "Wraithfin Abyssal",
    "Zombie Shark"
}

-- Daftar rarity ikan
local FishRarities = {
    ["Ancient Crocodile"] = "Secret",
    ["Ancient Monster Shark"] = "Secret",
    ["Ancient Whale"] = "Secret",
    ["Blackcap Basslet"] = "Common",
    ["Boar Fish"] = "Common",
    ["Dead Scary Clownfish"] = "Rare",
    ["Dead Spooky Koi Fish"] = "Rare",
    ["Fangtooth"] = "Uncommon",
    ["Freshwater Piranha"] = "Common",
    ["Goliath Tiger"] = "Epic",
    ["Hermit Crab"] = "Uncommon",
    ["Holiday Turtle"] = "Epic",
    ["Jellyfish"] = "Common",
    ["Lion Fish"] = "Uncommon",
    ["Loving Shark"] = "Rare",
    ["Luminous Fish"] = "Epic",
    ["Pink Dolphin"] = "Legendary",
    ["Plasma Shark"] = "Epic",
    ["Pumpkin Carved Shark"] = "Rare",
    ["Queen Crab"] = "Epic",
    ["Toxic Jellyfish"] = "Uncommon",
    ["Transcended Gem"] = "Mythical",
    ["Wraithfin Abyssal"] = "Mythical",
    ["Zombie Shark"] = "Legendary"
}

-- Konfigurasi default
local Config = {
    AutoCast = false,
    AutoReel = false,
    DelayBeforeCast = 1,
    DelayBeforeReel = 2,
    FishingRod = "Basic Rod",
    RodId = 91,
    SelectedFish = "Boar Fish",
    CastPosition = Vector3.new(-400.7665710449219, 23.65509605407715, -376.24957275390625),
    CastDirection = Vector3.new(0.483612984418869, 12, -17.99350357055664),
    HookPosition = Vector3.new(-400.6742248535156, 16.14996910095215, -382.71539306640625),
    FishWeight = 500
}

-- Referensi RemoteEvents
local NetPath = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local CastReplication = NetPath:WaitForChild("RE/CastReplication")
local CleanupCast = NetPath:WaitForChild("RE/CleanupCast")
local FishGiver = NetPath:WaitForChild("RE/FishGiver")

-- Status
local isFishing = false
local isCasting = false
local isReeling = false
local currentPage = "auto" -- "auto" atau "fish"
local isGUIVisible = false

-- Deteksi device
local isMobile = UserInputService.TouchEnabled

-- Buat GUI khusus mobile dengan pages
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileFishGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

-- Main Container
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(1, 0, 1, 0)
MainContainer.BackgroundTransparency = 1
MainContainer.Parent = ScreenGui

-- Floating Button untuk buka GUI
local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "FloatingButton"
FloatingButton.Size = UDim2.new(0, 70, 0, 70)
FloatingButton.Position = UDim2.new(1, -80, 1, -80)
FloatingButton.AnchorPoint = Vector2.new(1, 1)
FloatingButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
FloatingButton.Text = "🎣"
FloatingButton.Font = Enum.Font.GothamBold
FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingButton.TextSize = 28
FloatingButton.AutoButtonColor = true

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(1, 0)
FloatingCorner.Parent = FloatingButton

local FloatingShadow = Instance.new("ImageLabel")
FloatingShadow.Name = "FloatingShadow"
FloatingShadow.Size = UDim2.new(1, 10, 1, 10)
FloatingShadow.Position = UDim2.new(0, -5, 0, -5)
FloatingShadow.BackgroundTransparency = 1
FloatingShadow.Image = "rbxassetid://5554236805"
FloatingShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
FloatingShadow.ImageTransparency = 0.7
FloatingShadow.ScaleType = Enum.ScaleType.Slice
FloatingShadow.SliceCenter = Rect.new(23, 23, 277, 277)
FloatingShadow.Parent = FloatingButton

-- Main Panel
local MainPanel = Instance.new("Frame")
MainPanel.Name = "MainPanel"
MainPanel.Size = UDim2.new(0.85, 0, 0.65, 0)
MainPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
MainPanel.AnchorPoint = Vector2.new(0.5, 0.5)
MainPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainPanel.BorderSizePixel = 0
MainPanel.Visible = false

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 12)
PanelCorner.Parent = MainPanel

local PanelShadow = Instance.new("ImageLabel")
PanelShadow.Name = "PanelShadow"
PanelShadow.Size = UDim2.new(1, 10, 1, 10)
PanelShadow.Position = UDim2.new(0, -5, 0, -5)
PanelShadow.BackgroundTransparency = 1
PanelShadow.Image = "rbxassetid://5554236805"
PanelShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
PanelShadow.ImageTransparency = 0.8
PanelShadow.ScaleType = Enum.ScaleType.Slice
PanelShadow.SliceCenter = Rect.new(23, 23, 277, 277)
PanelShadow.Parent = MainPanel

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Header.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.15, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎣 AUTO FARM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Center

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -45, 0.5, -20)
CloseButton.AnchorPoint = Vector2.new(1, 0.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.AutoButtonColor = true

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Navigation Tabs
local NavTabs = Instance.new("Frame")
NavTabs.Name = "NavTabs"
NavTabs.Size = UDim2.new(1, 0, 0, 50)
NavTabs.Position = UDim2.new(0, 0, 0, 60)
NavTabs.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
NavTabs.BorderSizePixel = 0

local AutoTab = Instance.new("TextButton")
AutoTab.Name = "AutoTab"
AutoTab.Size = UDim2.new(0.5, 0, 1, 0)
AutoTab.Position = UDim2.new(0, 0, 0, 0)
AutoTab.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
AutoTab.Text = "AUTO FARM"
AutoTab.Font = Enum.Font.GothamBold
AutoTab.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoTab.TextSize = 14
AutoTab.AutoButtonColor = false

local FishTab = Instance.new("TextButton")
FishTab.Name = "FishTab"
FishTab.Size = UDim2.new(0.5, 0, 1, 0)
FishTab.Position = UDim2.new(0.5, 0, 0, 0)
FishTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
FishTab.Text = "SELECT FISH"
FishTab.Font = Enum.Font.GothamBold
FishTab.TextColor3 = Color3.fromRGB(200, 200, 200)
FishTab.TextSize = 14
FishTab.AutoButtonColor = false

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, 0, 1, -110)
ContentArea.Position = UDim2.new(0, 0, 0, 110)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true

-- ===== PAGE 1: AUTO FARM =====
local AutoPage = Instance.new("ScrollingFrame")
AutoPage.Name = "AutoPage"
AutoPage.Size = UDim2.new(1, 0, 1, 0)
AutoPage.BackgroundTransparency = 1
AutoPage.ScrollBarThickness = 4
AutoPage.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
AutoPage.CanvasSize = UDim2.new(0, 0, 0, 500)
AutoPage.Visible = true

-- Status Card
local StatusCard = Instance.new("Frame")
StatusCard.Name = "StatusCard"
StatusCard.Size = UDim2.new(1, -20, 0, 80)
StatusCard.Position = UDim2.new(0, 10, 0, 10)
StatusCard.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
StatusCard.BorderSizePixel = 0

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusCard

local StatusIcon = Instance.new("TextLabel")
StatusIcon.Name = "StatusIcon"
StatusIcon.Size = UDim2.new(0, 40, 0, 40)
StatusIcon.Position = UDim2.new(0, 10, 0.5, -20)
StatusIcon.AnchorPoint = Vector2.new(0, 0.5)
StatusIcon.BackgroundTransparency = 1
StatusIcon.Text = "⏸️"
StatusIcon.TextColor3 = Color3.fromRGB(255, 255, 100)
StatusIcon.Font = Enum.Font.GothamBold
StatusIcon.TextSize = 24
StatusIcon.TextXAlignment = Enum.TextXAlignment.Center

local StatusText = Instance.new("TextLabel")
StatusText.Name = "StatusText"
StatusText.Size = UDim2.new(1, -70, 0, 40)
StatusText.Position = UDim2.new(0, 60, 0.5, -20)
StatusText.AnchorPoint = Vector2.new(0, 0.5)
StatusText.BackgroundTransparency = 1
StatusText.Text = "IDLE\n<font color=\"rgb(180,180,180)\">Boar Fish</font>"
StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 16
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.RichText = true

-- Toggle Controls
local ToggleCard = Instance.new("Frame")
ToggleCard.Name = "ToggleCard"
ToggleCard.Size = UDim2.new(1, -20, 0, 100)
ToggleCard.Position = UDim2.new(0, 10, 0, 100)
ToggleCard.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ToggleCard.BorderSizePixel = 0

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleCard

local ToggleTitle = Instance.new("TextLabel")
ToggleTitle.Name = "ToggleTitle"
ToggleTitle.Size = UDim2.new(1, -20, 0, 25)
ToggleTitle.Position = UDim2.new(0, 10, 0, 5)
ToggleTitle.BackgroundTransparency = 1
ToggleTitle.Text = "⚙️ CONTROLS"
ToggleTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
ToggleTitle.Font = Enum.Font.GothamBold
ToggleTitle.TextSize = 14
ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Auto Cast Toggle
local CastToggleFrame = Instance.new("Frame")
CastToggleFrame.Name = "CastToggleFrame"
CastToggleFrame.Size = UDim2.new(1, -20, 0, 30)
CastToggleFrame.Position = UDim2.new(0, 10, 0, 35)
CastToggleFrame.BackgroundTransparency = 1

local CastLabel = Instance.new("TextLabel")
CastLabel.Name = "CastLabel"
CastLabel.Size = UDim2.new(0.7, 0, 1, 0)
CastLabel.BackgroundTransparency = 1
CastLabel.Text = "Auto Cast"
CastLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CastLabel.Font = Enum.Font.Gotham
CastLabel.TextSize = 14
CastLabel.TextXAlignment = Enum.TextXAlignment.Left

local CastToggle = Instance.new("TextButton")
CastToggle.Name = "CastToggle"
CastToggle.Size = UDim2.new(0, 60, 0, 30)
CastToggle.Position = UDim2.new(1, -60, 0, 0)
CastToggle.AnchorPoint = Vector2.new(1, 0)
CastToggle.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
CastToggle.Text = "OFF"
CastToggle.Font = Enum.Font.GothamBold
CastToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
CastToggle.TextSize = 12
CastToggle.AutoButtonColor = false

local CastToggleCorner = Instance.new("UICorner")
CastToggleCorner.CornerRadius = UDim.new(0, 15)
CastToggleCorner.Parent = CastToggle

-- Auto Reel Toggle
local ReelToggleFrame = Instance.new("Frame")
ReelToggleFrame.Name = "ReelToggleFrame"
ReelToggleFrame.Size = UDim2.new(1, -20, 0, 30)
ReelToggleFrame.Position = UDim2.new(0, 10, 0, 70)
ReelToggleFrame.BackgroundTransparency = 1

local ReelLabel = Instance.new("TextLabel")
ReelLabel.Name = "ReelLabel"
ReelLabel.Size = UDim2.new(0.7, 0, 1, 0)
ReelLabel.BackgroundTransparency = 1
ReelLabel.Text = "Auto Reel"
ReelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ReelLabel.Font = Enum.Font.Gotham
ReelLabel.TextSize = 14
ReelLabel.TextXAlignment = Enum.TextXAlignment.Left

local ReelToggle = Instance.new("TextButton")
ReelToggle.Name = "ReelToggle"
ReelToggle.Size = UDim2.new(0, 60, 0, 30)
ReelToggle.Position = UDim2.new(1, -60, 0, 0)
ReelToggle.AnchorPoint = Vector2.new(1, 0)
ReelToggle.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
ReelToggle.Text = "OFF"
ReelToggle.Font = Enum.Font.GothamBold
ReelToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ReelToggle.TextSize = 12
ReelToggle.AutoButtonColor = false

local ReelToggleCorner = Instance.new("UICorner")
ReelToggleCorner.CornerRadius = UDim.new(0, 15)
ReelToggleCorner.Parent = ReelToggle

-- Delay Settings
local DelayCard = Instance.new("Frame")
DelayCard.Name = "DelayCard"
DelayCard.Size = UDim2.new(1, -20, 0, 120)
DelayCard.Position = UDim2.new(0, 10, 0, 210)
DelayCard.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
DelayCard.BorderSizePixel = 0

local DelayCorner = Instance.new("UICorner")
DelayCorner.CornerRadius = UDim.new(0, 8)
DelayCorner.Parent = DelayCard

local DelayTitle = Instance.new("TextLabel")
DelayTitle.Name = "DelayTitle"
DelayTitle.Size = UDim2.new(1, -20, 0, 25)
DelayTitle.Position = UDim2.new(0, 10, 0, 5)
DelayTitle.BackgroundTransparency = 1
DelayTitle.Text = "⏱️ DELAY SETTINGS"
DelayTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
DelayTitle.Font = Enum.Font.GothamBold
DelayTitle.TextSize = 14
DelayTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Cast Delay
local CastDelayFrame = Instance.new("Frame")
CastDelayFrame.Name = "CastDelayFrame"
CastDelayFrame.Size = UDim2.new(1, -20, 0, 40)
CastDelayFrame.Position = UDim2.new(0, 10, 0, 35)
CastDelayFrame.BackgroundTransparency = 1

local CastDelayLabel = Instance.new("TextLabel")
CastDelayLabel.Name = "CastDelayLabel"
CastDelayLabel.Size = UDim2.new(0.6, 0, 1, 0)
CastDelayLabel.BackgroundTransparency = 1
CastDelayLabel.Text = "Cast Delay:"
CastDelayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CastDelayLabel.Font = Enum.Font.Gotham
CastDelayLabel.TextSize = 14
CastDelayLabel.TextXAlignment = Enum.TextXAlignment.Left

local CastDelayBox = Instance.new("TextBox")
CastDelayBox.Name = "CastDelayBox"
CastDelayBox.Size = UDim2.new(0.35, 0, 0, 35)
CastDelayBox.Position = UDim2.new(1, -10, 0.5, -17.5)
CastDelayBox.AnchorPoint = Vector2.new(1, 0.5)
CastDelayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
CastDelayBox.Text = tostring(Config.DelayBeforeCast)
CastDelayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
CastDelayBox.Font = Enum.Font.Gotham
CastDelayBox.TextSize = 14
CastDelayBox.TextXAlignment = Enum.TextXAlignment.Center
CastDelayBox.PlaceholderText = "sec"

local CastDelayCorner = Instance.new("UICorner")
CastDelayCorner.CornerRadius = UDim.new(0, 6)
CastDelayCorner.Parent = CastDelayBox

-- Reel Delay
local ReelDelayFrame = Instance.new("Frame")
ReelDelayFrame.Name = "ReelDelayFrame"
ReelDelayFrame.Size = UDim2.new(1, -20, 0, 40)
ReelDelayFrame.Position = UDim2.new(0, 10, 0, 75)
ReelDelayFrame.BackgroundTransparency = 1

local ReelDelayLabel = Instance.new("TextLabel")
ReelDelayLabel.Name = "ReelDelayLabel"
ReelDelayLabel.Size = UDim2.new(0.6, 0, 1, 0)
ReelDelayLabel.BackgroundTransparency = 1
ReelDelayLabel.Text = "Reel Delay:"
ReelDelayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ReelDelayLabel.Font = Enum.Font.Gotham
ReelDelayLabel.TextSize = 14
ReelDelayLabel.TextXAlignment = Enum.TextXAlignment.Left

local ReelDelayBox = Instance.new("TextBox")
ReelDelayBox.Name = "ReelDelayBox"
ReelDelayBox.Size = UDim2.new(0.35, 0, 0, 35)
ReelDelayBox.Position = UDim2.new(1, -10, 0.5, -17.5)
ReelDelayBox.AnchorPoint = Vector2.new(1, 0.5)
ReelDelayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ReelDelayBox.Text = tostring(Config.DelayBeforeReel)
ReelDelayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ReelDelayBox.Font = Enum.Font.Gotham
ReelDelayBox.TextSize = 14
ReelDelayBox.TextXAlignment = Enum.TextXAlignment.Center
ReelDelayBox.PlaceholderText = "sec"

local ReelDelayCorner = Instance.new("UICorner")
ReelDelayCorner.CornerRadius = UDim.new(0, 6)
ReelDelayCorner.Parent = ReelDelayBox

-- Main Action Button
local ActionButton = Instance.new("TextButton")
ActionButton.Name = "ActionButton"
ActionButton.Size = UDim2.new(1, -20, 0, 60)
ActionButton.Position = UDim2.new(0, 10, 0, 340)
ActionButton.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
ActionButton.Text = "▶ START FARMING"
ActionButton.Font = Enum.Font.GothamBold
ActionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ActionButton.TextSize = 16
ActionButton.AutoButtonColor = true

local ActionCorner = Instance.new("UICorner")
ActionCorner.CornerRadius = UDim.new(0, 8)
ActionCorner.Parent = ActionButton

-- ===== PAGE 2: FISH SELECTION =====
local FishPage = Instance.new("ScrollingFrame")
FishPage.Name = "FishPage"
FishPage.Size = UDim2.new(1, 0, 1, 0)
FishPage.BackgroundTransparency = 1
FishPage.ScrollBarThickness = 4
FishPage.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
FishPage.CanvasSize = UDim2.new(0, 0, 0, math.ceil(#FishAssets / 2) * 70 + 80)
FishPage.Visible = false

-- Search Bar
local SearchCard = Instance.new("Frame")
SearchCard.Name = "SearchCard"
SearchCard.Size = UDim2.new(1, -20, 0, 60)
SearchCard.Position = UDim2.new(0, 10, 0, 10)
SearchCard.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SearchCard.BorderSizePixel = 0

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 8)
SearchCorner.Parent = SearchCard

local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(1, -20, 0, 40)
SearchBox.Position = UDim2.new(0, 10, 0.5, -20)
SearchBox.AnchorPoint = Vector2.new(0, 0.5)
SearchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 14
SearchBox.PlaceholderText = "🔍 Search fish..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false

local SearchBoxCorner = Instance.new("UICorner")
SearchBoxCorner.CornerRadius = UDim.new(0, 6)
SearchBoxCorner.Parent = SearchBox

-- Selected Fish Info
local SelectedCard = Instance.new("Frame")
SelectedCard.Name = "SelectedCard"
SelectedCard.Size = UDim2.new(1, -20, 0, 60)
SelectedCard.Position = UDim2.new(0, 10, 0, 80)
SelectedCard.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
SelectedCard.BorderSizePixel = 0

local SelectedCorner = Instance.new("UICorner")
SelectedCorner.CornerRadius = UDim.new(0, 8)
SelectedCorner.Parent = SelectedCard

local SelectedIcon = Instance.new("TextLabel")
SelectedIcon.Name = "SelectedIcon"
SelectedIcon.Size = UDim2.new(0, 40, 0, 40)
SelectedIcon.Position = UDim2.new(0, 10, 0.5, -20)
SelectedIcon.AnchorPoint = Vector2.new(0, 0.5)
SelectedIcon.BackgroundTransparency = 1
SelectedIcon.Text = "🐟"
SelectedIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectedIcon.Font = Enum.Font.GothamBold
SelectedIcon.TextSize = 24
SelectedIcon.TextXAlignment = Enum.TextXAlignment.Center

local SelectedInfo = Instance.new("TextLabel")
SelectedInfo.Name = "SelectedInfo"
SelectedInfo.Size = UDim2.new(1, -70, 1, -10)
SelectedInfo.Position = UDim2.new(0, 60, 0, 5)
SelectedInfo.BackgroundTransparency = 1
SelectedInfo.Text = "Boar Fish\n<font size=\"12\" color=\"rgb(220,220,255)\">Common</font>"
SelectedInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectedInfo.Font = Enum.Font.Gotham
SelectedInfo.TextSize = 16
SelectedInfo.TextXAlignment = Enum.TextXAlignment.Left
SelectedInfo.RichText = true

-- Fish Grid
local FishGrid = Instance.new("UIGridLayout")
FishGrid.Name = "FishGrid"
FishGrid.CellSize = UDim2.new(0.5, -15, 0, 60)
FishGrid.CellPadding = UDim2.new(0, 10, 0, 10)
FishGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
FishGrid.SortOrder = Enum.SortOrder.LayoutOrder
FishGrid.Parent = FishPage

-- Parent semua elemen
FloatingButton.Parent = MainContainer
MainPanel.Parent = MainContainer

Header.Parent = MainPanel
Title.Parent = Header
CloseButton.Parent = Header

NavTabs.Parent = MainPanel
AutoTab.Parent = NavTabs
FishTab.Parent = NavTabs

ContentArea.Parent = MainPanel
AutoPage.Parent = ContentArea
FishPage.Parent = ContentArea

-- Auto Page elements
StatusCard.Parent = AutoPage
StatusIcon.Parent = StatusCard
StatusText.Parent = StatusCard

ToggleCard.Parent = AutoPage
ToggleTitle.Parent = ToggleCard
CastToggleFrame.Parent = ToggleCard
CastLabel.Parent = CastToggleFrame
CastToggle.Parent = CastToggleFrame
ReelToggleFrame.Parent = ToggleCard
ReelLabel.Parent = ReelToggleFrame
ReelToggle.Parent = ReelToggleFrame

DelayCard.Parent = AutoPage
DelayTitle.Parent = DelayCard
CastDelayFrame.Parent = DelayCard
CastDelayLabel.Parent = CastDelayFrame
CastDelayBox.Parent = CastDelayFrame
ReelDelayFrame.Parent = DelayCard
ReelDelayLabel.Parent = ReelDelayFrame
ReelDelayBox.Parent = ReelDelayFrame

ActionButton.Parent = AutoPage

-- Fish Page elements
SearchCard.Parent = FishPage
SearchBox.Parent = SearchCard
SelectedCard.Parent = FishPage
SelectedIcon.Parent = SelectedCard
SelectedInfo.Parent = SelectedCard

ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Fungsi untuk membuat fish buttons
local function createFishButtons()
    for _, child in pairs(FishPage:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local searchText = string.lower(SearchBox.Text)
    
    for i, fishName in ipairs(FishAssets) do
        if searchText == "" or string.find(string.lower(fishName), searchText) then
            local FishButton = Instance.new("TextButton")
            FishButton.Name = fishName
            FishButton.Size = UDim2.new(0.5, -15, 0, 60)
            FishButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            FishButton.Text = fishName
            FishButton.Font = Enum.Font.Gotham
            FishButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            FishButton.TextSize = 12
            FishButton.TextWrapped = true
            FishButton.AutoButtonColor = true
            
            local rarity = FishRarities[fishName] or "Common"
            local rarityColors = {
                Common = Color3.fromRGB(80, 80, 90),
                Uncommon = Color3.fromRGB(60, 140, 60),
                Rare = Color3.fromRGB(60, 100, 180),
                Epic = Color3.fromRGB(140, 60, 180),
                Legendary = Color3.fromRGB(200, 150, 50),
                Mythical = Color3.fromRGB(200, 60, 60)
            }
            
            FishButton.BackgroundColor3 = rarityColors[rarity] or Color3.fromRGB(60, 60, 70)
            
            if fishName == Config.SelectedFish then
                FishButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
            end
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = FishButton
            
            FishButton.MouseButton1Click:Connect(function()
                Config.SelectedFish = fishName
                updateUI()
                createFishButtons()
            end)
            
            FishButton.Parent = FishPage
        end
    end
end

-- Fungsi untuk update UI
local function updateUI()
    -- Update status
    StatusText.Text = (isFishing and "FARMING..." or "IDLE") .. "\n<font color=\"rgb(180,180,180)\">" .. Config.SelectedFish .. "</font>"
    StatusIcon.Text = isFishing and "🎣" or "⏸️"
    StatusIcon.TextColor3 = isFishing and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 255, 100)
    StatusText.TextColor3 = isFishing and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 255, 100)
    
    -- Update toggles
    CastToggle.Text = Config.AutoCast and "ON" or "OFF"
    CastToggle.BackgroundColor3 = Config.AutoCast and Color3.fromRGB(40, 160, 40) or Color3.fromRGB(120, 40, 40)
    
    ReelToggle.Text = Config.AutoReel and "ON" or "OFF"
    ReelToggle.BackgroundColor3 = Config.AutoReel and Color3.fromRGB(40, 160, 40) or Color3.fromRGB(120, 40, 40)
    
    -- Update action button
    ActionButton.Text = isFishing and "⏹ STOP FARMING" or "▶ START FARMING"
    ActionButton.BackgroundColor3 = isFishing and Color3.fromRGB(220, 60, 60) or Color3.fromRGB(60, 180, 80)
    
    -- Update selected fish info
    local rarity = FishRarities[Config.SelectedFish] or "Common"
    local rarityColors = {
        Common = Color3.fromRGB(200, 200, 200),
        Uncommon = Color3.fromRGB(100, 255, 100),
        Rare = Color3.fromRGB(100, 150, 255),
        Epic = Color3.fromRGB(200, 100, 255),
        Legendary = Color3.fromRGB(255, 200, 50),
        Mythical = Color3.fromRGB(255, 100, 100)
    }
    
    SelectedCard.BackgroundColor3 = rarityColors[rarity] or Color3.fromRGB(50, 120, 200)
    SelectedInfo.Text = Config.SelectedFish .. "\n<font size=\"12\" color=\"rgb(220,220,255)\">" .. rarity .. "</font>"
    
    -- Update tabs
    AutoTab.BackgroundColor3 = currentPage == "auto" and Color3.fromRGB(50, 120, 200) or Color3.fromRGB(60, 60, 70)
    AutoTab.TextColor3 = currentPage == "auto" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    
    FishTab.BackgroundColor3 = currentPage == "fish" and Color3.fromRGB(50, 120, 200) or Color3.fromRGB(60, 60, 70)
    FishTab.TextColor3 = currentPage == "fish" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    
    -- Update pages visibility
    AutoPage.Visible = currentPage == "auto"
    FishPage.Visible = currentPage == "fish"
    
    -- Update fish buttons
    createFishButtons()
end

-- Fungsi untuk switch page
local function switchPage(page)
    currentPage = page
    updateUI()
end

-- Fungsi untuk toggle GUI
local function toggleGUI()
    isGUIVisible = not isGUIVisible
    MainPanel.Visible = isGUIVisible
    
    if isGUIVisible then
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        MainPanel.Size = UDim2.new(0.85, 0, 0.65, 0)
    end
end

-- Fungsi untuk melakukan cast
local function castFishingRod()
    if isCasting then return end
    isCasting = true
    
    local args = {
        Config.CastPosition,
        Config.CastDirection,
        Config.FishingRod,
        Config.RodId
    }
    
    CastReplication:FireServer(unpack(args))
    
    wait(Config.DelayBeforeCast)
    isCasting = false
end

-- Fungsi untuk melakukan reel
local function reelFish()
    if isReeling then return end
    isReeling = true
    
    CleanupCast:FireServer()
    
    local args = {
        {
            hookPosition = Config.HookPosition,
            name = Config.SelectedFish,
            rarity = FishRarities[Config.SelectedFish] or "Common",
            weight = Config.FishWeight
        }
    }
    
    FishGiver:FireServer(unpack(args))
    
    wait(Config.DelayBeforeReel)
    isReeling = false
end

-- Fungsi auto farm
local function startAutoFarm()
    if isFishing then return end
    
    isFishing = true
    updateUI()
    
    spawn(function()
        while isFishing do
            if Config.AutoCast then
                castFishingRod()
            end
            
            if Config.AutoReel then
                reelFish()
            end
            
            wait(0.5)
        end
    end)
end

-- Fungsi stop auto farm
local function stopAutoFarm()
    isFishing = false
    updateUI()
end

-- Event handlers
FloatingButton.MouseButton1Click:Connect(toggleGUI)
CloseButton.MouseButton1Click:Connect(toggleGUI)

AutoTab.MouseButton1Click:Connect(function()
    switchPage("auto")
end)

FishTab.MouseButton1Click:Connect(function()
    switchPage("fish")
end)

ActionButton.MouseButton1Click:Connect(function()
    if not isFishing then
        startAutoFarm()
    else
        stopAutoFarm()
    end
end)

CastToggle.MouseButton1Click:Connect(function()
    Config.AutoCast = not Config.AutoCast
    updateUI()
end)

ReelToggle.MouseButton1Click:Connect(function()
    Config.AutoReel = not Config.AutoReel
    updateUI()
end)

CastDelayBox.FocusLost:Connect(function()
    local num = tonumber(CastDelayBox.Text)
    if num and num > 0 then
        Config.DelayBeforeCast = num
    else
        CastDelayBox.Text = tostring(Config.DelayBeforeCast)
    end
end)

ReelDelayBox.FocusLost:Connect(function()
    local num = tonumber(ReelDelayBox.Text)
    if num and num > 0 then
        Config.DelayBeforeReel = num
    else
        ReelDelayBox.Text = tostring(Config.DelayBeforeReel)
    end
end)

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    createFishButtons()
end)

-- Tambahkan efek hover untuk tombol (mobile-friendly)
local function addButtonEffect(button)
    button.MouseButton1Down:Connect(function()
        button.BackgroundTransparency = 0.3
    end)
    
    button.MouseButton1Up:Connect(function()
        button.BackgroundTransparency = 0
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundTransparency = 0
    end)
end

-- Terapkan efek ke semua tombol
addButtonEffect(AutoTab)
addButtonEffect(FishTab)
addButtonEffect(CastToggle)
addButtonEffect(ReelToggle)
addButtonEffect(ActionButton)
addButtonEffect(CloseButton)
addButtonEffect(FloatingButton)

-- Update UI pertama kali
createFishButtons()
updateUI()

-- Notifikasi
print("🎣 Mobile Auto Farm v2.0 Loaded!")
print("📱 Pages System: Auto Farm & Fish Selection")
print("👉 Tap the floating button to open GUI")
print("📊 Total Fish: " .. #FishAssets)

-- Simple version untuk execute langsung
local SimpleScript = [[
-- Simple Mobile Auto Farm Script
local FishList = {
    "Ancient Crocodile", "Ancient Monster Shark", "Ancient Whale",
    "Blackcap Basslet", "Boar Fish", "Dead Scary Clownfish",
    "Dead Spooky Koi Fish", "Fangtooth", "Freshwater Piranha",
    "Goliath Tiger", "Hermit Crab", "Holiday Turtle",
    "Jellyfish", "Lion Fish", "Loving Shark",
    "Luminous Fish", "Pink Dolphin", "Plasma Shark",
    "Pumpkin Carved Shark", "Queen Crab", "Toxic Jellyfish",
    "Transcended Gem", "Wraithfin Abyssal", "Zombie Shark"
}

local Config = {
    AutoCast = true,
    AutoReel = true,
    DelayBeforeCast = 1,
    DelayBeforeReel = 2,
    SelectedFish = "Boar Fish",
    FishWeight = 500
}

local NetPath = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local CastReplication = NetPath:WaitForChild("RE/CastReplication")
local CleanupCast = NetPath:WaitForChild("RE/CleanupCast")
local FishGiver = NetPath:WaitForChild("RE/FishGiver")

-- Simple auto farm function
while true do
    if Config.AutoCast then
        local args = {Vector3.new(-400.76, 23.65, -376.25), Vector3.new(0.48, 12, -17.99), "Basic Rod", 91}
        CastReplication:FireServer(unpack(args))
        wait(Config.DelayBeforeCast)
    end
    
    if Config.AutoReel then
        CleanupCast:FireServer()
        local args = {{hookPosition = Vector3.new(-400.67, 16.15, -382.72), name = Config.SelectedFish, rarity = "Common", weight = Config.FishWeight}}
        FishGiver:FireServer(unpack(args))
        wait(Config.DelayBeforeReel)
    end
    
    wait(0.5)
end
]]

print("\n💡 Simple script available in console")