-- Auto Farm Fishing Script dengan GUI - COMPLETE VERSION
-- Made by DeepSeek Assistant

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local AutoFarmEnabled = false
local CastDelay = 1 -- Default delay untuk cast
local ReelDelay = 0.5 -- Default delay untuk reel
local Minimized = false
local IsDragging = false
local DragStart, StartPos

-- Fishing Position (bisa diubah)
local FishingPosition = Vector3.new(214.16717529296875, -17.124069213867188, 325.762451171875)

-- Pastikan LocalPlayer sudah ada
if not LocalPlayer then
    LocalPlayer = Players:GetPlayerFromCharacter(workspace.Camera.Focus)
end

-- Function untuk mendapatkan remote events
local function GetRemotes()
    local success, result = pcall(function()
        local backpack = LocalPlayer:WaitForChild("Backpack")
        local tool = backpack:WaitForChild("Pancingan Cupu")
        local mechanics = tool:WaitForChild("Mechanics")
        local remotes = mechanics:WaitForChild("Remotes")
        local castEvent = remotes:WaitForChild("CastEvent")
        local miniGame = remotes:WaitForChild("MiniGame")
        
        -- Remote dari ReplicatedStorage
        local baitLandedEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BaitLandedEvent")
        
        return {
            CastEvent = castEvent,
            MiniGame = miniGame,
            BaitLandedEvent = baitLandedEvent,
            ToolExists = true
        }
    end)
    
    if success then
        return result
    else
        warn("Gagal mendapatkan remote events: " .. result)
        return {ToolExists = false}
    end
end

-- Function untuk mendapatkan tool dari character
local function GetToolFromCharacter()
    local character = LocalPlayer.Character
    if not character then return nil end
    
    local tool = character:FindFirstChild("Pancingan Cupu")
    if not tool then
        -- Coba cari di backpack juga
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            tool = backpack:FindFirstChild("Pancingan Cupu")
        end
    end
    
    return tool
end

-- Cast fishing rod function
local function CastFishingRod()
    local remotes = GetRemotes()
    if not remotes.ToolExists then 
        warn("Tool tidak ditemukan!")
        return false 
    end
    
    -- Parameter CastEvent
    local args = {
        false,
        89.43420648574829
    }
    
    local success, errorMsg = pcall(function()
        remotes.CastEvent:FireServer(unpack(args))
    end)
    
    if success then
        print("✓ Berhasil casting!")
        
        -- Tunggu sebentar sebelum BaitLandedEvent
        task.wait(0.3)
        
        -- Kirim BaitLandedEvent setelah casting
        SendBaitLandedEvent()
        
        return true
    else
        warn("Gagal casting: " .. tostring(errorMsg))
        return false
    end
end

-- BaitLandedEvent function (NEW)
local function SendBaitLandedEvent()
    local remotes = GetRemotes()
    if not remotes.ToolExists then return false end
    
    local tool = GetToolFromCharacter()
    if not tool then
        warn("Tool tidak ditemukan di character!")
        return false
    end
    
    local args = {
        tool,
        FishingPosition,
        "TerrainWater"
    }
    
    local success, errorMsg = pcall(function()
        remotes.BaitLandedEvent:FireServer(unpack(args))
    end)
    
    if success then
        print("✓ BaitLandedEvent berhasil!")
        return true
    else
        warn("Gagal BaitLandedEvent: " .. tostring(errorMsg))
        return false
    end
end

-- Reel fishing rod function
local function ReelFishingRod()
    local remotes = GetRemotes()
    if not remotes.ToolExists then 
        warn("Tool tidak ditemukan!")
        return false 
    end
    
    local args = {true}
    local success, errorMsg = pcall(function()
        remotes.MiniGame:FireServer(unpack(args))
    end)
    
    if success then
        print("✓ Berhasil reeling!")
        return true
    else
        warn("Gagal reeling: " .. tostring(errorMsg))
        return false
    end
end

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 450)
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎣 Auto Fishing Farm v3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 0)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 20
MinimizeBtn.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = TitleBar

-- Minimized Frame
local MinimizedFrame = Instance.new("Frame")
MinimizedFrame.Name = "MinimizedFrame"
MinimizedFrame.Size = UDim2.new(0, 240, 0, 40)
MinimizedFrame.Position = UDim2.new(0, 20, 0, 20)
MinimizedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MinimizedFrame.BorderSizePixel = 2
MinimizedFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
MinimizedFrame.Visible = false
MinimizedFrame.Active = true
MinimizedFrame.Draggable = true
MinimizedFrame.Parent = ScreenGui

local MinimizedCorner = Instance.new("UICorner")
MinimizedCorner.CornerRadius = UDim.new(0, 10)
MinimizedCorner.Parent = MinimizedFrame

local MinimizedTitle = Instance.new("TextLabel")
MinimizedTitle.Name = "MinimizedTitle"
MinimizedTitle.Size = UDim2.new(0.7, 0, 1, 0)
MinimizedTitle.Position = UDim2.new(0, 10, 0, 0)
MinimizedTitle.BackgroundTransparency = 1
MinimizedTitle.Text = "🎣 Auto OFF"
MinimizedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedTitle.Font = Enum.Font.GothamBold
MinimizedTitle.TextSize = 14
MinimizedTitle.TextXAlignment = Enum.TextXAlignment.Left
MinimizedTitle.Parent = MinimizedFrame

local RestoreBtn = Instance.new("TextButton")
RestoreBtn.Name = "RestoreBtn"
RestoreBtn.Size = UDim2.new(0, 40, 0, 40)
RestoreBtn.Position = UDim2.new(1, -50, 0, 0)
RestoreBtn.BackgroundTransparency = 1
RestoreBtn.Text = "↑"
RestoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RestoreBtn.Font = Enum.Font.GothamBold
RestoreBtn.TextSize = 20
RestoreBtn.Parent = MinimizedFrame

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Status Indicator
local StatusFrame = Instance.new("Frame")
StatusFrame.Name = "StatusFrame"
StatusFrame.Size = UDim2.new(1, 0, 0, 40)
StatusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
StatusFrame.BorderSizePixel = 0
StatusFrame.Parent = ContentFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(0.5, 0, 1, 0)
StatusLabel.Position = UDim2.new(0, 10, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: OFF"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusFrame

local StatusToggle = Instance.new("TextButton")
StatusToggle.Name = "StatusToggle"
StatusToggle.Size = UDim2.new(0, 80, 0, 30)
StatusToggle.Position = UDim2.new(1, -90, 0.5, -15)
StatusToggle.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
StatusToggle.Text = "START"
StatusToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusToggle.Font = Enum.Font.GothamBold
StatusToggle.TextSize = 14
StatusToggle.Parent = StatusFrame

local StatusToggleCorner = Instance.new("UICorner")
StatusToggleCorner.CornerRadius = UDim.new(0, 6)
StatusToggleCorner.Parent = StatusToggle

-- MANUAL BUTTONS FRAME
local ManualFrame = Instance.new("Frame")
ManualFrame.Name = "ManualFrame"
ManualFrame.Size = UDim2.new(1, 0, 0, 90)
ManualFrame.Position = UDim2.new(0, 0, 0, 50)
ManualFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ManualFrame.BorderSizePixel = 0
ManualFrame.Parent = ContentFrame

local ManualCorner = Instance.new("UICorner")
ManualCorner.CornerRadius = UDim.new(0, 8)
ManualCorner.Parent = ManualFrame

local ManualTitle = Instance.new("TextLabel")
ManualTitle.Name = "ManualTitle"
ManualTitle.Size = UDim2.new(1, -20, 0, 30)
ManualTitle.Position = UDim2.new(0, 10, 0, 0)
ManualTitle.BackgroundTransparency = 1
ManualTitle.Text = "🎮 Manual Controls"
ManualTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
ManualTitle.Font = Enum.Font.GothamBold
ManualTitle.TextSize = 14
ManualTitle.TextXAlignment = Enum.TextXAlignment.Left
ManualTitle.Parent = ManualFrame

-- Cast Button
local CastButton = Instance.new("TextButton")
CastButton.Name = "CastButton"
CastButton.Size = UDim2.new(0.45, 0, 0, 35)
CastButton.Position = UDim2.new(0.025, 0, 0, 35)
CastButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
CastButton.Text = "CAST"
CastButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CastButton.Font = Enum.Font.GothamBold
CastButton.TextSize = 14
CastButton.Parent = ManualFrame

local CastButtonCorner = Instance.new("UICorner")
CastButtonCorner.CornerRadius = UDim.new(0, 6)
CastButtonCorner.Parent = CastButton

-- Reel Button
local ReelButton = Instance.new("TextButton")
ReelButton.Name = "ReelButton"
ReelButton.Size = UDim2.new(0.45, 0, 0, 35)
ReelButton.Position = UDim2.new(0.525, 0, 0, 35)
ReelButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
ReelButton.Text = "REEL"
ReelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ReelButton.Font = Enum.Font.GothamBold
ReelButton.TextSize = 14
ReelButton.Parent = ManualFrame

local ReelButtonCorner = Instance.new("UICorner")
ReelButtonCorner.CornerRadius = UDim.new(0, 6)
ReelButtonCorner.Parent = ReelButton

-- Bait Landed Test Button (NEW)
local BaitButton = Instance.new("TextButton")
BaitButton.Name = "BaitButton"
BaitButton.Size = UDim2.new(0.3, 0, 0, 25)
BaitButton.Position = UDim2.new(0.35, 0, 0, 5)
BaitButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
BaitButton.Text = "TEST BAIT"
BaitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BaitButton.Font = Enum.Font.GothamBold
BaitButton.TextSize = 12
BaitButton.Visible = true
BaitButton.Parent = ManualFrame

local BaitButtonCorner = Instance.new("UICorner")
BaitButtonCorner.CornerRadius = UDim.new(0, 4)
BaitButtonCorner.Parent = BaitButton

-- FISHING POSITION SETTINGS
local PositionFrame = Instance.new("Frame")
PositionFrame.Name = "PositionFrame"
PositionFrame.Size = UDim2.new(1, 0, 0, 120)
PositionFrame.Position = UDim2.new(0, 0, 0, 150)
PositionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
PositionFrame.BorderSizePixel = 0
PositionFrame.Parent = ContentFrame

local PositionCorner = Instance.new("UICorner")
PositionCorner.CornerRadius = UDim.new(0, 8)
PositionCorner.Parent = PositionFrame

local PositionTitle = Instance.new("TextLabel")
PositionTitle.Name = "PositionTitle"
PositionTitle.Size = UDim2.new(1, -20, 0, 25)
PositionTitle.Position = UDim2.new(0, 10, 0, 5)
PositionTitle.BackgroundTransparency = 1
PositionTitle.Text = "📍 Fishing Position"
PositionTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
PositionTitle.Font = Enum.Font.GothamBold
PositionTitle.TextSize = 14
PositionTitle.TextXAlignment = Enum.TextXAlignment.Left
PositionTitle.Parent = PositionFrame

-- X Coordinate
local XLabel = Instance.new("TextLabel")
XLabel.Name = "XLabel"
XLabel.Size = UDim2.new(0.3, -5, 0, 25)
XLabel.Position = UDim2.new(0, 10, 0, 35)
XLabel.BackgroundTransparency = 1
XLabel.Text = "X:"
XLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
XLabel.Font = Enum.Font.Gotham
XLabel.TextSize = 13
XLabel.TextXAlignment = Enum.TextXAlignment.Left
XLabel.Parent = PositionFrame

local XSlider = Instance.new("TextBox")
XSlider.Name = "XSlider"
XSlider.Size = UDim2.new(0.7, -15, 0, 25)
XSlider.Position = UDim2.new(0.3, 0, 0, 35)
XSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
XSlider.BorderSizePixel = 0
XSlider.Text = tostring(FishingPosition.X)
XSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
XSlider.Font = Enum.Font.Gotham
XSlider.TextSize = 13
XSlider.PlaceholderText = "X coordinate"
XSlider.Parent = PositionFrame

local XSliderCorner = Instance.new("UICorner")
XSliderCorner.CornerRadius = UDim.new(0, 6)
XSliderCorner.Parent = XSlider

-- Y Coordinate
local YLabel = Instance.new("TextLabel")
YLabel.Name = "YLabel"
YLabel.Size = UDim2.new(0.3, -5, 0, 25)
YLabel.Position = UDim2.new(0, 10, 0, 65)
YLabel.BackgroundTransparency = 1
YLabel.Text = "Y:"
YLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
YLabel.Font = Enum.Font.Gotham
YLabel.TextSize = 13
YLabel.TextXAlignment = Enum.TextXAlignment.Left
YLabel.Parent = PositionFrame

local YSlider = Instance.new("TextBox")
YSlider.Name = "YSlider"
YSlider.Size = UDim2.new(0.7, -15, 0, 25)
YSlider.Position = UDim2.new(0.3, 0, 0, 65)
YSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
YSlider.BorderSizePixel = 0
YSlider.Text = tostring(FishingPosition.Y)
YSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
YSlider.Font = Enum.Font.Gotham
YSlider.TextSize = 13
YSlider.PlaceholderText = "Y coordinate"
YSlider.Parent = PositionFrame

local YSliderCorner = Instance.new("UICorner")
YSliderCorner.CornerRadius = UDim.new(0, 6)
YSliderCorner.Parent = YSlider

-- Z Coordinate
local ZLabel = Instance.new("TextLabel")
ZLabel.Name = "ZLabel"
ZLabel.Size = UDim2.new(0.3, -5, 0, 25)
ZLabel.Position = UDim2.new(0, 10, 0, 95)
ZLabel.BackgroundTransparency = 1
ZLabel.Text = "Z:"
ZLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ZLabel.Font = Enum.Font.Gotham
ZLabel.TextSize = 13
ZLabel.TextXAlignment = Enum.TextXAlignment.Left
ZLabel.Parent = PositionFrame

local ZSlider = Instance.new("TextBox")
ZSlider.Name = "ZSlider"
ZSlider.Size = UDim2.new(0.7, -15, 0, 25)
ZSlider.Position = UDim2.new(0.3, 0, 0, 95)
ZSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
ZSlider.BorderSizePixel = 0
ZSlider.Text = tostring(FishingPosition.Z)
ZSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
ZSlider.Font = Enum.Font.Gotham
ZSlider.TextSize = 13
ZSlider.PlaceholderText = "Z coordinate"
ZSlider.Parent = PositionFrame

local ZSliderCorner = Instance.new("UICorner")
ZSliderCorner.CornerRadius = UDim.new(0, 6)
ZSliderCorner.Parent = ZSlider

-- AUTO FARM SETTINGS
local AutoFrame = Instance.new("Frame")
AutoFrame.Name = "AutoFrame"
AutoFrame.Size = UDim2.new(1, 0, 0, 100)
AutoFrame.Position = UDim2.new(0, 0, 0, 280)
AutoFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
AutoFrame.BorderSizePixel = 0
AutoFrame.Parent = ContentFrame

local AutoCorner = Instance.new("UICorner")
AutoCorner.CornerRadius = UDim.new(0, 8)
AutoCorner.Parent = AutoFrame

local AutoTitle = Instance.new("TextLabel")
AutoTitle.Name = "AutoTitle"
AutoTitle.Size = UDim2.new(1, -20, 0, 25)
AutoTitle.Position = UDim2.new(0, 10, 0, 5)
AutoTitle.BackgroundTransparency = 1
AutoTitle.Text = "🤖 Auto Farm Settings"
AutoTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
AutoTitle.Font = Enum.Font.GothamBold
AutoTitle.TextSize = 14
AutoTitle.TextXAlignment = Enum.TextXAlignment.Left
AutoTitle.Parent = AutoFrame

-- Cast Delay
local CastDelayLabel = Instance.new("TextLabel")
CastDelayLabel.Name = "CastDelayLabel"
CastDelayLabel.Size = UDim2.new(0.5, -10, 0, 25)
CastDelayLabel.Position = UDim2.new(0, 10, 0, 35)
CastDelayLabel.BackgroundTransparency = 1
CastDelayLabel.Text = "Cast Delay: 1s"
CastDelayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CastDelayLabel.Font = Enum.Font.Gotham
CastDelayLabel.TextSize = 13
CastDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
CastDelayLabel.Parent = AutoFrame

local CastDelaySlider = Instance.new("TextBox")
CastDelaySlider.Name = "CastDelaySlider"
CastDelaySlider.Size = UDim2.new(0.5, -10, 0, 25)
CastDelaySlider.Position = UDim2.new(0.5, 0, 0, 35)
CastDelaySlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
CastDelaySlider.BorderSizePixel = 0
CastDelaySlider.Text = "1"
CastDelaySlider.TextColor3 = Color3.fromRGB(255, 255, 255)
CastDelaySlider.Font = Enum.Font.Gotham
CastDelaySlider.TextSize = 13
CastDelaySlider.PlaceholderText = "Seconds"
CastDelaySlider.Parent = AutoFrame

local CastDelaySliderCorner = Instance.new("UICorner")
CastDelaySliderCorner.CornerRadius = UDim.new(0, 6)
CastDelaySliderCorner.Parent = CastDelaySlider

-- Reel Delay
local ReelDelayLabel = Instance.new("TextLabel")
ReelDelayLabel.Name = "ReelDelayLabel"
ReelDelayLabel.Size = UDim2.new(0.5, -10, 0, 25)
ReelDelayLabel.Position = UDim2.new(0, 10, 0, 65)
ReelDelayLabel.BackgroundTransparency = 1
ReelDelayLabel.Text = "Reel Delay: 0.5s"
ReelDelayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ReelDelayLabel.Font = Enum.Font.Gotham
ReelDelayLabel.TextSize = 13
ReelDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
ReelDelayLabel.Parent = AutoFrame

local ReelDelaySlider = Instance.new("TextBox")
ReelDelaySlider.Name = "ReelDelaySlider"
ReelDelaySlider.Size = UDim2.new(0.5, -10, 0, 25)
ReelDelaySlider.Position = UDim2.new(0.5, 0, 0, 65)
ReelDelaySlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
ReelDelaySlider.BorderSizePixel = 0
ReelDelaySlider.Text = "0.5"
ReelDelaySlider.TextColor3 = Color3.fromRGB(255, 255, 255)
ReelDelaySlider.Font = Enum.Font.Gotham
ReelDelaySlider.TextSize = 13
ReelDelaySlider.PlaceholderText = "Seconds"
ReelDelaySlider.Parent = AutoFrame

local ReelDelaySliderCorner = Instance.new("UICorner")
ReelDelaySliderCorner.CornerRadius = UDim.new(0, 6)
ReelDelaySliderCorner.Parent = ReelDelaySlider

-- LOG FRAME
local LogFrame = Instance.new("Frame")
LogFrame.Name = "LogFrame"
LogFrame.Size = UDim2.new(1, 0, 0, 90)
LogFrame.Position = UDim2.new(0, 0, 0, 390)
LogFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
LogFrame.BorderSizePixel = 0
LogFrame.Parent = ContentFrame

local LogCorner = Instance.new("UICorner")
LogCorner.CornerRadius = UDim.new(0, 8)
LogCorner.Parent = LogFrame

local LogTitle = Instance.new("TextLabel")
LogTitle.Name = "LogTitle"
LogTitle.Size = UDim2.new(1, -20, 0, 25)
LogTitle.Position = UDim2.new(0, 10, 0, 5)
LogTitle.BackgroundTransparency = 1
LogTitle.Text = "📝 Activity Log"
LogTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
LogTitle.Font = Enum.Font.GothamBold
LogTitle.TextSize = 14
LogTitle.TextXAlignment = Enum.TextXAlignment.Left
LogTitle.Parent = LogFrame

local LogText = Instance.new("TextLabel")
LogText.Name = "LogText"
LogText.Size = UDim2.new(1, -20, 0, 60)
LogText.Position = UDim2.new(0, 10, 0, 30)
LogText.BackgroundTransparency = 1
LogText.Text = "Ready to fish...\nPosition: " .. tostring(FishingPosition)
LogText.TextColor3 = Color3.fromRGB(200, 200, 200)
LogText.Font = Enum.Font.Gotham
LogText.TextSize = 11
LogText.TextXAlignment = Enum.TextXAlignment.Left
LogText.TextYAlignment = Enum.TextYAlignment.Top
LogText.TextWrapped = true
LogText.Parent = LogFrame

-- Update Log Function
local function UpdateLog(message)
    local time = os.date("%H:%M:%S")
    LogText.Text = "[" .. time .. "] " .. message .. "\n" .. string.sub(LogText.Text, 1, 300)
end

-- Update Position Function
local function UpdatePosition()
    FishingPosition = Vector3.new(
        tonumber(XSlider.Text) or FishingPosition.X,
        tonumber(YSlider.Text) or FishingPosition.Y,
        tonumber(ZSlider.Text) or FishingPosition.Z
    )
    UpdateLog("Position updated: " .. tostring(FishingPosition))
end

-- MANUAL BUTTON FUNCTIONS
CastButton.MouseButton1Click:Connect(function()
    UpdateLog("Manual Casting...")
    local success = CastFishingRod()
    if success then
        UpdateLog("✓ Cast successful!")
    else
        UpdateLog("✗ Cast failed!")
    end
end)

ReelButton.MouseButton1Click:Connect(function()
    UpdateLog("Manual Reeling...")
    local success = ReelFishingRod()
    if success then
        UpdateLog("✓ Reel successful!")
    else
        UpdateLog("✗ Reel failed!")
    end
end)

BaitButton.MouseButton1Click:Connect(function()
    UpdateLog("Testing BaitLandedEvent...")
    local success = SendBaitLandedEvent()
    if success then
        UpdateLog("✓ BaitLandedEvent successful!")
    else
        UpdateLog("✗ BaitLandedEvent failed!")
    end
end)

-- Update position coordinates
XSlider.FocusLost:Connect(function()
    UpdatePosition()
end)

YSlider.FocusLost:Connect(function()
    UpdatePosition()
end)

ZSlider.FocusLost:Connect(function()
    UpdatePosition()
end)

-- AUTO FARM SYSTEM
local FarmConnection
local function StartAutoFarm()
    if FarmConnection then 
        FarmConnection:Disconnect() 
        FarmConnection = nil
    end
    
    FarmConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not AutoFarmEnabled then return end
        
        UpdateLog("Auto: Starting fishing cycle...")
        
        -- Cast fishing rod
        local castSuccess = CastFishingRod()
        if castSuccess then
            UpdateLog("Auto: Cast ✓")
            
            -- Tunggu sebelum reel (termasuk waktu untuk BaitLandedEvent)
            local waitStart = tick()
            while tick() - waitStart < CastDelay do
                if not AutoFarmEnabled then break end
                task.wait(0.1)
            end
            
            if AutoFarmEnabled then
                -- Reel fishing rod
                local reelSuccess = ReelFishingRod()
                if reelSuccess then
                    UpdateLog("Auto: Reel ✓")
                    
                    -- Tunggu sebelum cast berikutnya
                    waitStart = tick()
                    while tick() - waitStart < ReelDelay do
                        if not AutoFarmEnabled then break end
                        task.wait(0.1)
                    end
                    
                    UpdateLog("Auto: Cycle completed. Next in " .. (CastDelay + ReelDelay) .. "s")
                else
                    UpdateLog("Auto: Reel failed, retrying...")
                end
            end
        else
            UpdateLog("Auto: Cast failed, retrying...")
            task.wait(1)
        end
    end)
end

-- Update Status Function
local function UpdateStatus()
    if AutoFarmEnabled then
        StatusLabel.Text = "Status: ON"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        StatusToggle.Text = "STOP"
        StatusToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        MinimizedTitle.Text = "🎣 Auto ON"
        UpdateLog("=== AUTO FARM STARTED ===")
        StartAutoFarm()
    else
        StatusLabel.Text = "Status: OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        StatusToggle.Text = "START"
        StatusToggle.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        MinimizedTitle.Text = "🎣 Auto OFF"
        UpdateLog("=== AUTO FARM STOPPED ===")
        if FarmConnection then
            FarmConnection:Disconnect()
            FarmConnection = nil
        end
    end
    
    CastDelayLabel.Text = "Cast Delay: " .. CastDelay .. "s"
    ReelDelayLabel.Text = "Reel Delay: " .. ReelDelay .. "s"
end

-- Toggle Auto Farm
StatusToggle.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    UpdateStatus()
end)

-- Update delays from input
CastDelaySlider.FocusLost:Connect(function(enterPressed)
    local value = tonumber(CastDelaySlider.Text)
    if value and value > 0 and value <= 10 then
        CastDelay = value
        CastDelayLabel.Text = "Cast Delay: " .. CastDelay .. "s"
        UpdateLog("Cast delay set to " .. value .. "s")
    else
        CastDelaySlider.Text = tostring(CastDelay)
        UpdateLog("Invalid cast delay!")
    end
end)

ReelDelaySlider.FocusLost:Connect(function(enterPressed)
    local value = tonumber(ReelDelaySlider.Text)
    if value and value > 0 and value <= 10 then
        ReelDelay = value
        ReelDelayLabel.Text = "Reel Delay: " .. ReelDelay .. "s"
        UpdateLog("Reel delay set to " .. value .. "s")
    else
        ReelDelaySlider.Text = tostring(ReelDelay)
        UpdateLog("Invalid reel delay!")
    end
end)

-- Minimize/Restore functionality
MinimizeBtn.MouseButton1Click:Connect(function()
    Minimized = true
    MainFrame.Visible = false
    MinimizedFrame.Visible = true
    UpdateLog("GUI Minimized")
end)

RestoreBtn.MouseButton1Click:Connect(function()
    Minimized = false
    MainFrame.Visible = true
    MinimizedFrame.Visible = false
    UpdateLog("GUI Restored")
end)

CloseBtn.MouseButton1Click:Connect(function()
    AutoFarmEnabled = false
    UpdateStatus()
    ScreenGui.Enabled = false
    UpdateLog("GUI Closed - Run script again to reopen")
end)

-- Initialize
UpdateStatus()
UpdateLog("Script initialized successfully!")
UpdateLog("Fishing Position: " .. tostring(FishingPosition))

-- Tool check notification
spawn(function()
    task.wait(1)
    local remotes = GetRemotes()
    if remotes.ToolExists then
        UpdateLog("✅ Tool 'Pancingan Cupu' ditemukan!")
        UpdateLog("✅ All remotes loaded successfully")
        CastButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        ReelButton.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
        BaitButton.BackgroundColor3 = Color3.fromRGB(100, 220, 100)
    else
        UpdateLog("❌ Tool 'Pancingan Cupu' tidak ditemukan!")
        CastButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        ReelButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        BaitButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        CastButton.Text = "NO TOOL"
        ReelButton.Text = "NO TOOL"
        BaitButton.Text = "NO TOOL"
    end
end)

-- Drag functionality untuk minimized frame
local function MinimizedDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        IsDragging = true
        DragStart = input.Position
        StartPos = MinimizedFrame.Position
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                IsDragging = false
                connection:Disconnect()
            end
        end)
    end
end

MinimizedFrame.InputBegan:Connect(MinimizedDrag)

UserInputService.InputChanged:Connect(function(input)
    if IsDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - DragStart
        MinimizedFrame.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + delta.Y
        )
    end
end)

-- Hotkey untuk manual controls
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- F1 untuk Cast
    if input.KeyCode == Enum.KeyCode.F1 then
        CastFishingRod()
        UpdateLog("Hotkey: Cast (F1)")
    
    -- F2 untuk Reel  
    elseif input.KeyCode == Enum.KeyCode.F2 then
        ReelFishingRod()
        UpdateLog("Hotkey: Reel (F2)")
    
    -- F3 untuk BaitLandedEvent
    elseif input.KeyCode == Enum.KeyCode.F3 then
        SendBaitLandedEvent()
        UpdateLog("Hotkey: BaitLanded (F3)")
    
    -- F4 untuk toggle Auto Farm
    elseif input.KeyCode == Enum.KeyCode.F4 then
        AutoFarmEnabled = not AutoFarmEnabled
        UpdateStatus()
        UpdateLog("Hotkey: Toggle Auto (F4)")
    end
end)

-- Visual feedback untuk buttons
CastButton.MouseEnter:Connect(function()
    if CastButton.Text ~= "NO TOOL" then
        CastButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end
end)

CastButton.MouseLeave:Connect(function()
    if CastButton.Text ~= "NO TOOL" then
        CastButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    end
end)

ReelButton.MouseEnter:Connect(function()
    if ReelButton.Text ~= "NO TOOL" then
        ReelButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    end
end)

ReelButton.MouseLeave:Connect(function()
    if ReelButton.Text ~= "NO TOOL" then
        ReelButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    end
end)

BaitButton.MouseEnter:Connect(function()
    if BaitButton.Text ~= "NO TOOL" then
        BaitButton.BackgroundColor3 = Color3.fromRGB(120, 240, 120)
    end
end)

BaitButton.MouseLeave:Connect(function()
    if BaitButton.Text ~= "NO TOOL" then
        BaitButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    end
end)

-- Get Current Position Button
local GetPosBtn = Instance.new("TextButton")
GetPosBtn.Name = "GetPosBtn"
GetPosBtn.Size = UDim2.new(0.2, 0, 0, 20)
GetPosBtn.Position = UDim2.new(0.8, 0, 0, 10)
GetPosBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
GetPosBtn.Text = "📍"
GetPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetPosBtn.Font = Enum.Font.GothamBold
GetPosBtn.TextSize = 12
GetPosBtn.Visible = true
GetPosBtn.Parent = PositionFrame

local GetPosBtnCorner = Instance.new("UICorner")
GetPosBtnCorner.CornerRadius = UDim.new(0, 4)
GetPosBtnCorner.Parent = GetPosBtn

GetPosBtn.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        FishingPosition = pos
        XSlider.Text = tostring(math.floor(pos.X * 1000) / 1000)
        YSlider.Text = tostring(math.floor(pos.Y * 1000) / 1000)
        ZSlider.Text = tostring(math.floor(pos.Z * 1000) / 1000)
        UpdateLog("Position set to character location: " .. tostring(pos))
    else
        UpdateLog("Character not found!")
    end
end)

-- Notify user
print("======================================")
print("🎣 Auto Fishing Farm Script Loaded!")
print("• Complete fishing system with BaitLandedEvent")
print("• Manual Controls: Cast, Reel, Bait Test")
print("• Adjustable Fishing Position")
print("• Hotkeys: F1=Cast, F2=Reel, F3=Bait, F4=Auto")
print("======================================")
UpdateLog("Script loaded successfully!")
UpdateLog("System ready with BaitLandedEvent")