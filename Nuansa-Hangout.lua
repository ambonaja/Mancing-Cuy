-- Auto Fishing Script dengan GUI Multi-Page
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Data ikan yang tersedia (dikelompokkan)
local fishCategories = {
    ["Shark🦈"] = {
        "1x1x1 Comet Shark",
        "1x1x1x1 Shark",
        "Frostborn Shark",
        "Frostborn Shark 1x1x1x1",
        "Frostborn Shark BloodMoon",
        "Frostborn Shark MidNight",
        "Frostborn Shark Pink",
        "Loving Shark",
        "Monster Shark",
        "Plasma Shark",
        "Pumpkin Carved Shark",
        "Zombie Shark"
    },
    ["Monster🐙"] = {
        "Ancient Lochness Monster",
        "Ancient Relic Crocodile",
        "Ancient Whale",
        "Lochness Monster",
        "Lochness Monster Pink",
        "Robot Kraken",
        "Robot Kraken Pink"
    },
    ["Deep Fish🧜‍♂️"] = {
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
        "Ghastly Crab",
        "Glacierfin Snapper",
        "Goliath Tiger",
        "Hermit Crab",
        "Jellyfish",
        "Lion Fish",
        "Luminous Fish",
        "Pink Dolphin",
        "Queen Crab",
        "Wraithfin Abyssal"
    }
}

-- Services
local FishingSystem = ReplicatedStorage:WaitForChild("FishingSystem")
local FishingSystemEvents = FishingSystem:WaitForChild("FishingSystemEvents")
local FishGiver = FishingSystemEvents:WaitForChild("FishGiver")

-- Variabel global
local autoFishEnabled = false
local selectedFish = fishCategories["Sharks"][1]
local hookPosition = Vector3.new(-406.37, 13.15, -98.71)
local player = Players.LocalPlayer
local currentPage = "AutoFarm" -- AutoFarm, FishList, Settings

-- Membuat GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFishingGUI"
ScreenGui.Parent = game:GetService("CoreGui") or player:WaitForChild("PlayerGui")

-- Main Container (Background)
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(0, 350, 0, 220)
MainContainer.Position = UDim2.new(0, 20, 0, 20)
MainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainContainer.BorderSizePixel = 0
MainContainer.Active = true
MainContainer.Draggable = true
MainContainer.Parent = ScreenGui

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 35)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Header.BorderSizePixel = 0
Header.Parent = MainContainer

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Ambon Ewe Ariel Tatum🤤"
Title.TextColor3 = Color3.fromRGB(100, 200, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Status Indicator
local StatusIndicator = Instance.new("Frame")
StatusIndicator.Name = "StatusIndicator"
StatusIndicator.Size = UDim2.new(0, 8, 0, 8)
StatusIndicator.Position = UDim2.new(0.62, 0, 0.5, -4)
StatusIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
StatusIndicator.BorderSizePixel = 0
local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(1, 0)
StatusCorner.Parent = StatusIndicator
StatusIndicator.Parent = Header

-- Control Buttons
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.Parent = Header

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(1, -60, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 14
MinimizeButton.Parent = Header

-- Navigation Tabs
local NavigationTabs = Instance.new("Frame")
NavigationTabs.Name = "NavigationTabs"
NavigationTabs.Size = UDim2.new(1, 0, 0, 30)
NavigationTabs.Position = UDim2.new(0, 0, 0, 35)
NavigationTabs.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
NavigationTabs.BorderSizePixel = 0
NavigationTabs.Parent = MainContainer

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabListLayout.Parent = NavigationTabs

-- Tabs
local AutoFarmTab = Instance.new("TextButton")
AutoFarmTab.Name = "AutoFarmTab"
AutoFarmTab.Size = UDim2.new(0, 100, 0, 25)
AutoFarmTab.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
AutoFarmTab.Text = "⚙️ Auto Farm"
AutoFarmTab.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmTab.Font = Enum.Font.GothamMedium
AutoFarmTab.TextSize = 12
AutoFarmTab.Parent = NavigationTabs

local FishListTab = Instance.new("TextButton")
FishListTab.Name = "FishListTab"
FishListTab.Size = UDim2.new(0, 100, 0, 25)
FishListTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
FishListTab.Text = "🐟 Fish List"
FishListTab.TextColor3 = Color3.fromRGB(200, 200, 200)
FishListTab.Font = Enum.Font.GothamMedium
FishListTab.TextSize = 12
FishListTab.Parent = NavigationTabs

local SettingsTab = Instance.new("TextButton")
SettingsTab.Name = "SettingsTab"
SettingsTab.Size = UDim2.new(0, 100, 0, 25)
SettingsTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
SettingsTab.Text = "⚡ Settings"
SettingsTab.TextColor3 = Color3.fromRGB(200, 200, 200)
SettingsTab.Font = Enum.Font.GothamMedium
SettingsTab.TextSize = 12
SettingsTab.Parent = NavigationTabs

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, 0, 1, -65)
ContentArea.Position = UDim2.new(0, 0, 0, 65)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.Parent = MainContainer

-- PAGE 1: AUTO FARM
local AutoFarmPage = Instance.new("Frame")
AutoFarmPage.Name = "AutoFarmPage"
AutoFarmPage.Size = UDim2.new(1, 0, 1, 0)
AutoFarmPage.Position = UDim2.new(0, 0, 0, 0)
AutoFarmPage.BackgroundTransparency = 1
AutoFarmPage.Visible = true
AutoFarmPage.Parent = ContentArea

-- Selected Fish Display
local SelectedFishFrame = Instance.new("Frame")
SelectedFishFrame.Name = "SelectedFishFrame"
SelectedFishFrame.Size = UDim2.new(1, -20, 0, 40)
SelectedFishFrame.Position = UDim2.new(0, 10, 0, 10)
SelectedFishFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
SelectedFishFrame.BorderSizePixel = 1
SelectedFishFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
SelectedFishFrame.Parent = AutoFarmPage

local SelectedFishLabel = Instance.new("TextLabel")
SelectedFishLabel.Name = "SelectedFishLabel"
SelectedFishLabel.Size = UDim2.new(0.7, 0, 1, 0)
SelectedFishLabel.Position = UDim2.new(0, 10, 0, 0)
SelectedFishLabel.BackgroundTransparency = 1
SelectedFishLabel.Text = "Selected: " .. selectedFish
SelectedFishLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectedFishLabel.Font = Enum.Font.Gotham
SelectedFishLabel.TextSize = 12
SelectedFishLabel.TextXAlignment = Enum.TextXAlignment.Left
SelectedFishLabel.TextTruncate = Enum.TextTruncate.AtEnd
SelectedFishLabel.Parent = SelectedFishFrame

local ChangeFishButton = Instance.new("TextButton")
ChangeFishButton.Name = "ChangeFishButton"
ChangeFishButton.Size = UDim2.new(0.25, 0, 0.7, 0)
ChangeFishButton.Position = UDim2.new(0.73, 0, 0.15, 0)
ChangeFishButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ChangeFishButton.Text = "Change"
ChangeFishButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ChangeFishButton.Font = Enum.Font.GothamMedium
ChangeFishButton.TextSize = 11
ChangeFishButton.Parent = SelectedFishFrame

-- Control Buttons
local ControlFrame = Instance.new("Frame")
ControlFrame.Name = "ControlFrame"
ControlFrame.Size = UDim2.new(1, -20, 0, 40)
ControlFrame.Position = UDim2.new(0, 10, 0, 60)
ControlFrame.BackgroundTransparency = 1
ControlFrame.Parent = AutoFarmPage

local StartButton = Instance.new("TextButton")
StartButton.Name = "StartButton"
StartButton.Size = UDim2.new(0.48, 0, 1, 0)
StartButton.Position = UDim2.new(0, 0, 0, 0)
StartButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
StartButton.Text = "▶ START EWE"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.Font = Enum.Font.GothamBold
StartButton.TextSize = 13
StartButton.Parent = ControlFrame

local StopButton = Instance.new("TextButton")
StopButton.Name = "StopButton"
StopButton.Size = UDim2.new(0.48, 0, 1, 0)
StopButton.Position = UDim2.new(0.52, 0, 0, 0)
StopButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
StopButton.Text = "■ STOP EWE"
StopButton.TextColor3 = Color3.fromRGB(180, 180, 180)
StopButton.Font = Enum.Font.GothamBold
StopButton.TextSize = 13
StopButton.Parent = ControlFrame

-- Stats Info
local StatsFrame = Instance.new("Frame")
StatsFrame.Name = "StatsFrame"
StatsFrame.Size = UDim2.new(1, -20, 0, 50)
StatsFrame.Position = UDim2.new(0, 10, 0, 110)
StatsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
StatsFrame.BorderSizePixel = 1
StatsFrame.BorderColor3 = Color3.fromRGB(50, 50, 70)
StatsFrame.Parent = AutoFarmPage

local RarityLabel = Instance.new("TextLabel")
RarityLabel.Name = "RarityLabel"
RarityLabel.Size = UDim2.new(1, -10, 0, 20)
RarityLabel.Position = UDim2.new(0, 5, 0, 5)
RarityLabel.BackgroundTransparency = 1
RarityLabel.Text = "🎯 Rarity: Secret"
RarityLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
RarityLabel.Font = Enum.Font.Gotham
RarityLabel.TextSize = 11
RarityLabel.TextXAlignment = Enum.TextXAlignment.Left
RarityLabel.Parent = StatsFrame

local WeightLabel = Instance.new("TextLabel")
WeightLabel.Name = "WeightLabel"
WeightLabel.Size = UDim2.new(1, -10, 0, 20)
WeightLabel.Position = UDim2.new(0, 5, 0, 25)
WeightLabel.BackgroundTransparency = 1
WeightLabel.Text = "⚖️ Weight: 999"
WeightLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
WeightLabel.Font = Enum.Font.Gotham
WeightLabel.TextSize = 11
WeightLabel.TextXAlignment = Enum.TextXAlignment.Left
WeightLabel.Parent = StatsFrame

-- PAGE 2: FISH LIST
local FishListPage = Instance.new("Frame")
FishListPage.Name = "FishListPage"
FishListPage.Size = UDim2.new(1, 0, 1, 0)
FishListPage.Position = UDim2.new(0, 0, 0, 0)
FishListPage.BackgroundTransparency = 1
FishListPage.Visible = false
FishListPage.Parent = ContentArea

-- Category Tabs for Fish List
local CategoryTabs = Instance.new("Frame")
CategoryTabs.Name = "CategoryTabs"
CategoryTabs.Size = UDim2.new(1, -20, 0, 30)
CategoryTabs.Position = UDim2.new(0, 10, 0, 5)
CategoryTabs.BackgroundTransparency = 1
CategoryTabs.Parent = FishListPage

local CategoryLayout = Instance.new("UIListLayout")
CategoryLayout.Padding = UDim.new(0, 5)
CategoryLayout.FillDirection = Enum.FillDirection.Horizontal
CategoryLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
CategoryLayout.Parent = CategoryTabs

-- Create category buttons
local categoryButtons = {}
for categoryName, _ in pairs(fishCategories) do
    local CategoryButton = Instance.new("TextButton")
    CategoryButton.Name = categoryName .. "Tab"
    CategoryButton.Size = UDim2.new(0, 100, 0, 25)
    CategoryButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    CategoryButton.Text = "🐟 " .. categoryName
    CategoryButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    CategoryButton.Font = Enum.Font.GothamMedium
    CategoryButton.TextSize = 11
    CategoryButton.Parent = CategoryTabs
    
    categoryButtons[categoryName] = CategoryButton
end

-- Set first category as active
if categoryButtons["Sharks"] then
    categoryButtons["Sharks"].BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    categoryButtons["Sharks"].TextColor3 = Color3.fromRGB(255, 255, 255)
end

-- Fish List Container
local FishListContainer = Instance.new("ScrollingFrame")
FishListContainer.Name = "FishListContainer"
FishListContainer.Size = UDim2.new(1, -20, 1, -45)
FishListContainer.Position = UDim2.new(0, 10, 0, 40)
FishListContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
FishListContainer.BorderSizePixel = 1
FishListContainer.BorderColor3 = Color3.fromRGB(50, 50, 70)
FishListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
FishListContainer.ScrollBarThickness = 6
FishListContainer.Parent = FishListPage

local FishListLayout = Instance.new("UIListLayout")
FishListLayout.Padding = UDim.new(0, 5)
FishListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
FishListLayout.Parent = FishListContainer

-- Function to populate fish list
local function populateFishList(category)
    -- Clear existing fish buttons
    for _, child in ipairs(FishListContainer:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local fishList = fishCategories[category] or {}
    local buttonHeight = 30
    local padding = 5
    local totalHeight = (#fishList * (buttonHeight + padding)) + padding
    
    FishListContainer.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    
    -- Create fish buttons
    for i, fishName in ipairs(fishList) do
        local FishButton = Instance.new("TextButton")
        FishButton.Name = fishName
        FishButton.Size = UDim2.new(0.9, 0, 0, buttonHeight)
        FishButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        FishButton.BorderSizePixel = 0
        FishButton.Text = fishName
        FishButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        FishButton.Font = Enum.Font.Gotham
        FishButton.TextSize = 11
        FishButton.TextXAlignment = Enum.TextXAlignment.Left
        FishButton.Parent = FishListContainer
        
        -- Add select icon if this is the selected fish
        if fishName == selectedFish then
            FishButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            local SelectIcon = Instance.new("TextLabel")
            SelectIcon.Name = "SelectIcon"
            SelectIcon.Size = UDim2.new(0, 20, 1, 0)
            SelectIcon.Position = UDim2.new(1, -25, 0, 0)
            SelectIcon.BackgroundTransparency = 1
            SelectIcon.Text = "✓"
            SelectIcon.TextColor3 = Color3.fromRGB(0, 255, 0)
            SelectIcon.Font = Enum.Font.GothamBold
            SelectIcon.TextSize = 12
            SelectIcon.Parent = FishButton
        end
        
        FishButton.MouseButton1Click:Connect(function()
            selectedFish = fishName
            SelectedFishLabel.Text = "Selected: " .. fishName
            
            -- Update all fish buttons to show selection
            for _, btn in ipairs(FishListContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    if btn.Name == fishName then
                        btn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
                        if not btn:FindFirstChild("SelectIcon") then
                            local SelectIcon = Instance.new("TextLabel")
                            SelectIcon.Name = "SelectIcon"
                            SelectIcon.Size = UDim2.new(0, 20, 1, 0)
                            SelectIcon.Position = UDim2.new(1, -25, 0, 0)
                            SelectIcon.BackgroundTransparency = 1
                            SelectIcon.Text = "✓"
                            SelectIcon.TextColor3 = Color3.fromRGB(0, 255, 0)
                            SelectIcon.Font = Enum.Font.GothamBold
                            SelectIcon.TextSize = 12
                            SelectIcon.Parent = btn
                        end
                    else
                        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
                        local icon = btn:FindFirstChild("SelectIcon")
                        if icon then
                            icon:Destroy()
                        end
                    end
                end
            end
            
            -- Switch back to AutoFarm page
            switchPage("AutoFarm")
            
            -- Notifikasi
            game.StarterGui:SetCore("SendNotification", {
                Title = "Fish Selected",
                Text = fishName,
                Icon = "rbxassetid://4483345998",
                Duration = 2
            })
        end)
    end
end

-- Initialize with Sharks category
populateFishList("Sharks")

-- PAGE 3: SETTINGS
local SettingsPage = Instance.new("Frame")
SettingsPage.Name = "SettingsPage"
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.Position = UDim2.new(0, 0, 0, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false
SettingsPage.Parent = ContentArea

-- Settings Content
local SettingsContainer = Instance.new("ScrollingFrame")
SettingsContainer.Name = "SettingsContainer"
SettingsContainer.Size = UDim2.new(1, -20, 1, -10)
SettingsContainer.Position = UDim2.new(0, 10, 0, 5)
SettingsContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
SettingsContainer.BorderSizePixel = 1
SettingsContainer.BorderColor3 = Color3.fromRGB(50, 50, 70)
SettingsContainer.CanvasSize = UDim2.new(0, 0, 0, 150)
SettingsContainer.ScrollBarThickness = 6
SettingsContainer.Parent = SettingsPage

local SettingsLayout = Instance.new("UIListLayout")
SettingsLayout.Padding = UDim.new(0, 10)
SettingsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SettingsLayout.Parent = SettingsContainer

-- Hook Position Setting
local HookPositionFrame = Instance.new("Frame")
HookPositionFrame.Name = "HookPositionFrame"
HookPositionFrame.Size = UDim2.new(0.9, 0, 0, 60)
HookPositionFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
HookPositionFrame.BorderSizePixel = 0
HookPositionFrame.Parent = SettingsContainer

local HookPositionLabel = Instance.new("TextLabel")
HookPositionLabel.Name = "HookPositionLabel"
HookPositionLabel.Size = UDim2.new(1, -10, 0, 20)
HookPositionLabel.Position = UDim2.new(0, 5, 0, 5)
HookPositionLabel.BackgroundTransparency = 1
HookPositionLabel.Text = "🎣 Hook Position:"
HookPositionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HookPositionLabel.Font = Enum.Font.Gotham
HookPositionLabel.TextSize = 12
HookPositionLabel.TextXAlignment = Enum.TextXAlignment.Left
HookPositionLabel.Parent = HookPositionFrame

local PositionDisplay = Instance.new("TextLabel")
PositionDisplay.Name = "PositionDisplay"
PositionDisplay.Size = UDim2.new(1, -10, 0, 30)
PositionDisplay.Position = UDim2.new(0, 5, 0, 25)
PositionDisplay.BackgroundTransparency = 1
PositionDisplay.Text = string.format("X: %.2f, Y: %.2f, Z: %.2f", hookPosition.X, hookPosition.Y, hookPosition.Z)
PositionDisplay.TextColor3 = Color3.fromRGB(100, 200, 255)
PositionDisplay.Font = Enum.Font.Gotham
PositionDisplay.TextSize = 10
PositionDisplay.TextXAlignment = Enum.TextXAlignment.Left
PositionDisplay.TextWrapped = true
PositionDisplay.Parent = HookPositionFrame

-- Hotkey Setting
local HotkeyFrame = Instance.new("Frame")
HotkeyFrame.Name = "HotkeyFrame"
HotkeyFrame.Size = UDim2.new(0.9, 0, 0, 40)
HotkeyFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
HotkeyFrame.BorderSizePixel = 0
HotkeyFrame.Parent = SettingsContainer

local HotkeyLabel = Instance.new("TextLabel")
HotkeyLabel.Name = "HotkeyLabel"
HotkeyLabel.Size = UDim2.new(1, -10, 1, 0)
HotkeyLabel.Position = UDim2.new(0, 5, 0, 0)
HotkeyLabel.BackgroundTransparency = 1
HotkeyLabel.Text = "⌨️ Toggle Hotkey: F6"
HotkeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HotkeyLabel.Font = Enum.Font.Gotham
HotkeyLabel.TextSize = 12
HotkeyLabel.TextXAlignment = Enum.TextXAlignment.Left
HotkeyLabel.Parent = HotkeyFrame

-- Reset Button
local ResetButton = Instance.new("TextButton")
ResetButton.Name = "ResetButton"
ResetButton.Size = UDim2.new(0.9, 0, 0, 30)
ResetButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
ResetButton.Text = "🔄 Reset to Default"
ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetButton.Font = Enum.Font.GothamMedium
ResetButton.TextSize = 12
ResetButton.Parent = SettingsContainer

ResetButton.MouseButton1Click:Connect(function()
    hookPosition = Vector3.new(-406.37, 13.15, -98.71)
    PositionDisplay.Text = string.format("X: %.2f, Y: %.2f, Z: %.2f", hookPosition.X, hookPosition.Y, hookPosition.Z)
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "Settings",
        Text = "Reset to default position",
        Icon = "rbxassetid://4483345998",
        Duration = 2
    })
end)

-- Fungsi untuk memberikan ikan
local function giveFish()
    local args = {
        {
            hookPosition = hookPosition,
            name = selectedFish,
            rarity = "Secret",
            weight = 999
        }
    }
    
    pcall(function()
        FishGiver:FireServer(unpack(args))
    end)
end

-- Auto fishing loop
local connection
local function toggleAutoFishing(enable)
    autoFishEnabled = enable
    
    if autoFishEnabled then
        StatusIndicator.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        StartButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        StopButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        -- Start auto fishing
        if connection then
            connection:Disconnect()
        end
        
        connection = RunService.Heartbeat:Connect(function()
            if autoFishEnabled then
                giveFish()
                task.wait(0.1)
            end
        end)
        
        -- Notifikasi
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Fishing",
            Text = "Started farming " .. selectedFish,
            Icon = "rbxassetid://4483345998",
            Duration = 2
        })
    else
        StatusIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        StartButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        StopButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        StopButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        
        -- Stop auto fishing
        if connection then
            connection:Disconnect()
            connection = nil
        end
        
        -- Notifikasi
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Fishing",
            Text = "Stopped farming",
            Icon = "rbxassetid://4483345998",
            Duration = 2
        })
    end
end

-- Page switching function
local function switchPage(pageName)
    currentPage = pageName
    
    -- Hide all pages
    AutoFarmPage.Visible = false
    FishListPage.Visible = false
    SettingsPage.Visible = false
    
    -- Reset all tab colors
    AutoFarmTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    AutoFarmTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    FishListTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    FishListTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    SettingsTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    SettingsTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    
    -- Show selected page and highlight tab
    if pageName == "AutoFarm" then
        AutoFarmPage.Visible = true
        AutoFarmTab.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        AutoFarmTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif pageName == "FishList" then
        FishListPage.Visible = true
        FishListTab.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        FishListTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif pageName == "Settings" then
        SettingsPage.Visible = true
        SettingsTab.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        SettingsTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Button Event Handlers
StartButton.MouseButton1Click:Connect(function()
    toggleAutoFishing(true)
end)

StopButton.MouseButton1Click:Connect(function()
    toggleAutoFishing(false)
end)

ChangeFishButton.MouseButton1Click:Connect(function()
    switchPage("FishList")
end)

AutoFarmTab.MouseButton1Click:Connect(function()
    switchPage("AutoFarm")
end)

FishListTab.MouseButton1Click:Connect(function()
    switchPage("FishList")
end)

SettingsTab.MouseButton1Click:Connect(function()
    switchPage("Settings")
end)

-- Category button handlers
for categoryName, button in pairs(categoryButtons) do
    button.MouseButton1Click:Connect(function()
        -- Reset all category buttons
        for _, catBtn in pairs(categoryButtons) do
            catBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            catBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        
        -- Highlight selected category
        button.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        -- Populate fish list for selected category
        populateFishList(categoryName)
    end)
end

CloseButton.MouseButton1Click:Connect(function()
    if connection then
        connection:Disconnect()
    end
    ScreenGui:Destroy()
end)

-- Minimize Function
local isMinimized = false
local originalSize = MainContainer.Size
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        MainContainer.Size = UDim2.new(0, 350, 0, 35)
        ContentArea.Visible = false
        NavigationTabs.Visible = false
        MinimizeButton.Text = "□"
        MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
    else
        MainContainer.Size = originalSize
        ContentArea.Visible = true
        NavigationTabs.Visible = true
        MinimizeButton.Text = "_"
        MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
end)

-- Hotkey untuk toggle (F6)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F6 then
        toggleAutoFishing(not autoFishEnabled)
    end
end)

-- Cleanup ketika GUI dihancurkan
ScreenGui.Destroying:Connect(function()
    if connection then
        connection:Disconnect()
    end
end)

-- Notifikasi startup
game.StarterGui:SetCore("SendNotification", {
    Title = "Auto Fishing Pro",
    Text = "Multi-Page GUI Loaded!\nPress F6 to toggle auto fishing",
    Icon = "rbxassetid://4483345998",
    Duration = 4
})

print("Multi-Page Auto Fishing GUI loaded successfully!")