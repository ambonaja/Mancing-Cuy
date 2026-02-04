-- Auto Farm Fishing dengan GUI + Delay Manual + Kordinat Dinamis
-- Made by: AI Assistant

local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Konfigurasi fishing
local FishingSystem = ReplicatedStorage:WaitForChild("FishingSystem")
local FishGiver = FishingSystem:WaitForChild("FishGiver")

-- Variabel status
local isFarming = false
local isMinimized = false
local isDragging = false
local dragStartPos = nil
local guiStartPos = nil
local currentDelay = 0.5 -- Default delay
local minDelay = 0.001 -- Minimum delay
local maxDelay = 3.0 -- Maximum delay

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmFishingGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = Player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 300) -- Diperbesar sedikit untuk info posisi
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
mainFrame.Active = true
mainFrame.Draggable = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Corner untuk smoothing
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Drop Shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Parent = mainFrame
shadow.ZIndex = -1

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

-- Judul
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0, 180, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "AmbonXLonely🚯"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Tombol Minimize
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -60, 0, 0)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "_"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Parent = titleBar

-- Tombol Close
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = titleBar

-- Icon Drag
local dragIcon = Instance.new("ImageLabel")
dragIcon.Name = "DragIcon"
dragIcon.Size = UDim2.new(0, 20, 0, 20)
dragIcon.Position = UDim2.new(1, -90, 0, 5)
dragIcon.BackgroundTransparency = 1
dragIcon.Image = "rbxassetid://3926305904"
dragIcon.ImageRectOffset = Vector2.new(884, 4)
dragIcon.ImageRectSize = Vector2.new(36, 36)
dragIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
dragIcon.Parent = titleBar

-- Content Area
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Status Display
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Size = UDim2.new(1, -20, 0, 40)
statusFrame.Position = UDim2.new(0, 10, 0, 10)
statusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
statusFrame.Parent = contentFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0.4, 0, 1, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status:"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusFrame

local statusValue = Instance.new("TextLabel")
statusValue.Name = "StatusValue"
statusValue.Size = UDim2.new(0.6, 0, 1, 0)
statusValue.Position = UDim2.new(0.4, 0, 0, 0)
statusValue.BackgroundTransparency = 1
statusValue.Text = "OFF"
statusValue.TextColor3 = Color3.fromRGB(255, 80, 80)
statusValue.Font = Enum.Font.GothamBold
statusValue.TextSize = 14
statusValue.TextXAlignment = Enum.TextXAlignment.Right
statusValue.Parent = statusFrame

-- Delay Control Frame
local delayFrame = Instance.new("Frame")
delayFrame.Name = "DelayFrame"
delayFrame.Size = UDim2.new(1, -20, 0, 80)
delayFrame.Position = UDim2.new(0, 10, 0, 60)
delayFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
delayFrame.Parent = contentFrame

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 6)
delayCorner.Parent = delayFrame

local delayTitle = Instance.new("TextLabel")
delayTitle.Name = "DelayTitle"
delayTitle.Size = UDim2.new(1, 0, 0, 25)
delayTitle.BackgroundTransparency = 1
delayTitle.Text = "⏱️ Delay Settings"
delayTitle.TextColor3 = Color3.fromRGB(0, 170, 255)
delayTitle.Font = Enum.Font.GothamBold
delayTitle.TextSize = 14
delayTitle.TextXAlignment = Enum.TextXAlignment.Center
delayTitle.Parent = delayFrame

-- Current Delay Display
local currentDelayLabel = Instance.new("TextLabel")
currentDelayLabel.Name = "CurrentDelayLabel"
currentDelayLabel.Size = UDim2.new(1, -20, 0, 20)
currentDelayLabel.Position = UDim2.new(0, 10, 0, 30)
currentDelayLabel.BackgroundTransparency = 1
currentDelayLabel.Text = "Current Delay: 0.5s"
currentDelayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
currentDelayLabel.Font = Enum.Font.Gotham
currentDelayLabel.TextSize = 13
currentDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
currentDelayLabel.Parent = delayFrame

-- Delay Input Box
local delayInputFrame = Instance.new("Frame")
delayInputFrame.Name = "DelayInputFrame"
delayInputFrame.Size = UDim2.new(1, -20, 0, 25)
delayInputFrame.Position = UDim2.new(0, 10, 0, 50)
delayInputFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
delayInputFrame.Parent = delayFrame

local delayInputCorner = Instance.new("UICorner")
delayInputCorner.CornerRadius = UDim.new(0, 4)
delayInputCorner.Parent = delayInputFrame

local delayTextBox = Instance.new("TextBox")
delayTextBox.Name = "DelayTextBox"
delayTextBox.Size = UDim2.new(0.7, 0, 1, 0)
delayTextBox.BackgroundTransparency = 1
delayTextBox.Text = "0.5"
delayTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayTextBox.Font = Enum.Font.Gotham
delayTextBox.TextSize = 13
delayTextBox.PlaceholderText = "Enter delay (0.1-5.0)"
delayTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
delayTextBox.TextXAlignment = Enum.TextXAlignment.Center
delayTextBox.Parent = delayInputFrame

local delaySetBtn = Instance.new("TextButton")
delaySetBtn.Name = "DelaySetBtn"
delaySetBtn.Size = UDim2.new(0.3, 0, 1, 0)
delaySetBtn.Position = UDim2.new(0.7, 0, 0, 0)
delaySetBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
delaySetBtn.Text = "SET"
delaySetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
delaySetBtn.Font = Enum.Font.GothamBold
delaySetBtn.TextSize = 12
delaySetBtn.Parent = delayInputFrame

local setBtnCorner = Instance.new("UICorner")
setBtnCorner.CornerRadius = UDim.new(0, 4)
setBtnCorner.Parent = delaySetBtn

-- Preset Delay Buttons
local presetFrame = Instance.new("Frame")
presetFrame.Name = "PresetFrame"
presetFrame.Size = UDim2.new(1, -20, 0, 25)
presetFrame.Position = UDim2.new(0, 10, 0, 85)
presetFrame.BackgroundTransparency = 1
presetFrame.Parent = delayFrame

local preset1 = Instance.new("TextButton")
preset1.Name = "Preset1"
preset1.Size = UDim2.new(0.3, -5, 1, 0)
preset1.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
preset1.Text = "0.1s"
preset1.TextColor3 = Color3.fromRGB(255, 255, 255)
preset1.Font = Enum.Font.Gotham
preset1.TextSize = 11
preset1.Parent = presetFrame

local preset2 = Instance.new("TextButton")
preset2.Name = "Preset2"
preset2.Size = UDim2.new(0.3, -5, 1, 0)
preset2.Position = UDim2.new(0.33, 0, 0, 0)
preset2.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
preset2.Text = "0.5s"
preset2.TextColor3 = Color3.fromRGB(255, 255, 255)
preset2.Font = Enum.Font.Gotham
preset2.TextSize = 11
preset2.Parent = presetFrame

local preset3 = Instance.new("TextButton")
preset3.Name = "Preset3"
preset3.Size = UDim2.new(0.3, 0, 1, 0)
preset3.Position = UDim2.new(0.66, 0, 0, 0)
preset3.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
preset3.Text = "1.0s"
preset3.TextColor3 = Color3.fromRGB(255, 255, 255)
preset3.Font = Enum.Font.Gotham
preset3.TextSize = 11
preset3.Parent = presetFrame

-- Apply corners to preset buttons
for _, preset in ipairs({preset1, preset2, preset3}) do
    local presetCorner = Instance.new("UICorner")
    presetCorner.CornerRadius = UDim.new(0, 4)
    presetCorner.Parent = preset
end

-- Position Info Frame
local positionFrame = Instance.new("Frame")
positionFrame.Name = "PositionFrame"
positionFrame.Size = UDim2.new(1, -20, 0, 40)
positionFrame.Position = UDim2.new(0, 10, 0, 150)
positionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
positionFrame.Parent = contentFrame

local positionCorner = Instance.new("UICorner")
positionCorner.CornerRadius = UDim.new(0, 6)
positionCorner.Parent = positionFrame

local positionLabel = Instance.new("TextLabel")
positionLabel.Name = "PositionLabel"
positionLabel.Size = UDim2.new(1, -10, 1, 0)
positionLabel.Position = UDim2.new(0, 5, 0, 0)
positionLabel.BackgroundTransparency = 1
positionLabel.Text = "📍 Position: Dynamic (Following Player)"
positionLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
positionLabel.Font = Enum.Font.Gotham
positionLabel.TextSize = 11
positionLabel.TextXAlignment = Enum.TextXAlignment.Center
positionLabel.Parent = positionFrame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(1, -20, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 200)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
toggleBtn.Text = "START FARMING"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.Parent = contentFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleBtn

-- Statistik
local statsFrame = Instance.new("Frame")
statsFrame.Name = "StatsFrame"
statsFrame.Size = UDim2.new(1, -20, 0, 60)
statsFrame.Position = UDim2.new(0, 10, 0, 250)
statsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
statsFrame.Parent = contentFrame

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 6)
statsCorner.Parent = statsFrame

local statsTitle = Instance.new("TextLabel")
statsTitle.Name = "StatsTitle"
statsTitle.Size = UDim2.new(1, 0, 0, 20)
statsTitle.BackgroundTransparency = 1
statsTitle.Text = "📊 Statistics"
statsTitle.TextColor3 = Color3.fromRGB(0, 170, 255)
statsTitle.Font = Enum.Font.GothamBold
statsTitle.TextSize = 14
statsTitle.Parent = statsFrame

local fishCountLabel = Instance.new("TextLabel")
fishCountLabel.Name = "FishCountLabel"
fishCountLabel.Size = UDim2.new(1, -10, 0, 20)
fishCountLabel.Position = UDim2.new(0, 10, 0, 25)
fishCountLabel.BackgroundTransparency = 1
fishCountLabel.Text = "Fish Caught: 0"
fishCountLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
fishCountLabel.Font = Enum.Font.Gotham
fishCountLabel.TextSize = 13
fishCountLabel.TextXAlignment = Enum.TextXAlignment.Left
fishCountLabel.Parent = statsFrame

local timeLabel = Instance.new("TextLabel")
timeLabel.Name = "TimeLabel"
timeLabel.Size = UDim2.new(1, -10, 0, 20)
timeLabel.Position = UDim2.new(0, 10, 0, 45)
timeLabel.BackgroundTransparency = 1
timeLabel.Text = "Time: 00:00"
timeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
timeLabel.Font = Enum.Font.Gotham
timeLabel.TextSize = 13
timeLabel.TextXAlignment = Enum.TextXAlignment.Left
timeLabel.Parent = statsFrame

-- Minimized Frame
local minimizedFrame = Instance.new("Frame")
minimizedFrame.Name = "MinimizedFrame"
minimizedFrame.Size = UDim2.new(0, 200, 0, 40)
minimizedFrame.Position = mainFrame.Position
minimizedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
minimizedFrame.BorderSizePixel = 2
minimizedFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
minimizedFrame.Active = true
minimizedFrame.Draggable = false
minimizedFrame.Visible = false
minimizedFrame.Parent = screenGui

local minimizedCorner = Instance.new("UICorner")
minimizedCorner.CornerRadius = UDim.new(0, 8)
minimizedCorner.Parent = minimizedFrame

local minimizedShadow = Instance.new("ImageLabel")
minimizedShadow.Name = "Shadow"
minimizedShadow.Image = "rbxassetid://1316045217"
minimizedShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
minimizedShadow.ImageTransparency = 0.5
minimizedShadow.ScaleType = Enum.ScaleType.Slice
minimizedShadow.SliceCenter = Rect.new(10, 10, 118, 118)
minimizedShadow.Size = UDim2.new(1, 20, 1, 20)
minimizedShadow.Position = UDim2.new(0, -10, 0, -10)
minimizedShadow.BackgroundTransparency = 1
minimizedShadow.Parent = minimizedFrame
minimizedShadow.ZIndex = -1

local minimizedTitle = Instance.new("TextLabel")
minimizedTitle.Name = "Title"
minimizedTitle.Size = UDim2.new(0, 120, 1, 0)
minimizedTitle.Position = UDim2.new(0, 10, 0, 0)
minimizedTitle.BackgroundTransparency = 1
minimizedTitle.Text = "🎣 Auto Fish"
minimizedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizedTitle.Font = Enum.Font.GothamBold
minimizedTitle.TextSize = 14
minimizedTitle.TextXAlignment = Enum.TextXAlignment.Left
minimizedTitle.Parent = minimizedFrame

local minimizedStatus = Instance.new("TextLabel")
minimizedStatus.Name = "Status"
minimizedStatus.Size = UDim2.new(0, 40, 1, 0)
minimizedStatus.Position = UDim2.new(1, -50, 0, 0)
minimizedStatus.BackgroundTransparency = 1
minimizedStatus.Text = "OFF"
minimizedStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
minimizedStatus.Font = Enum.Font.GothamBold
minimizedStatus.TextSize = 14
minimizedStatus.Parent = minimizedFrame

local restoreBtn = Instance.new("TextButton")
restoreBtn.Name = "RestoreBtn"
restoreBtn.Size = UDim2.new(0, 40, 1, 0)
restoreBtn.Position = UDim2.new(1, -90, 0, 0)
restoreBtn.BackgroundTransparency = 1
restoreBtn.Text = "↗"
restoreBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
restoreBtn.Font = Enum.Font.GothamBold
restoreBtn.TextSize = 16
restoreBtn.Parent = minimizedFrame

-- Variabel untuk statistik
local fishCount = 0
local startTime = 0
local connection = nil

-- Fungsi untuk mendapatkan posisi player yang tepat untuk fishing
local function getFishingPosition()
    local character = Player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Ambil posisi player dan tambahkan offset untuk fishing
            local playerPos = humanoidRootPart.Position
            
            -- Buat posisi fishing di depan player (bisa disesuaikan)
            local lookVector = humanoidRootPart.CFrame.LookVector
            local fishingOffset = Vector3.new(0, -1, -5) -- 5 unit di depan dan sedikit di bawah
            
            -- Rotasikan offset sesuai arah player
            local rotatedOffset = humanoidRootPart.CFrame:VectorToWorldSpace(fishingOffset)
            
            return playerPos + rotatedOffset
        end
    end
    -- Fallback ke posisi player jika tidak ada character
    return Vector3.new(0, 0, 0)
end

-- Fungsi untuk update delay display
local function updateDelayDisplay()
    currentDelayLabel.Text = string.format("Current Delay: %.1fs", currentDelay)
    delayTextBox.Text = tostring(currentDelay)
end

-- Fungsi untuk set delay
local function setDelay(newDelay)
    -- Validasi input
    local numDelay = tonumber(newDelay)
    
    if numDelay then
        -- Clamp ke range yang aman
        numDelay = math.clamp(numDelay, minDelay, maxDelay)
        currentDelay = numDelay
        updateDelayDisplay()
        
        -- Update warna preset buttons
        for _, preset in ipairs({preset1, preset2, preset3}) do
            preset.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            if preset.Text:sub(1, -2) == tostring(numDelay) then
                preset.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
            end
        end
        
        print("Delay set to: " .. currentDelay .. " seconds")
        return true
    else
        -- Flash error pada textbox
        delayTextBox.TextColor3 = Color3.fromRGB(255, 100, 100)
        task.wait(0.3)
        delayTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        delayTextBox.Text = tostring(currentDelay)
        return false
    end
end

-- Fungsi untuk format waktu
local function formatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%02d:%02d", minutes, secs)
end

-- Fungsi untuk update statistik
local function updateStats()
    fishCountLabel.Text = "Fish Caught: " .. fishCount
    
    if isFarming and startTime > 0 then
        local elapsed = os.time() - startTime
        timeLabel.Text = "Time: " .. formatTime(elapsed)
    else
        timeLabel.Text = "Time: 00:00"
    end
end

-- Fungsi untuk update position display
local function updatePositionDisplay()
    local fishingPos = getFishingPosition()
    positionLabel.Text = string.format("📍 Position: (%.1f, %.1f, %.1f)", 
        fishingPos.X, fishingPos.Y, fishingPos.Z)
end

-- Fungsi untuk toggle farming
local function toggleFarming()
    isFarming = not isFarming
    
    if isFarming then
        -- Mulai farming
        statusValue.Text = "ON"
        statusValue.TextColor3 = Color3.fromRGB(80, 255, 80)
        toggleBtn.Text = "STOP FARMING"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        minimizedStatus.Text = "ON"
        minimizedStatus.TextColor3 = Color3.fromRGB(80, 255, 80)
        
        fishCount = 0
        startTime = os.time()
        
        -- Mulai loop fishing dengan delay custom
        connection = RunService.Heartbeat:Connect(function()
            if isFarming then
                -- Dapatkan posisi player saat ini
                local fishingPos = getFishingPosition()
                
                -- Persiapkan args dengan posisi dinamis
                local args = {
                    {
                        hookPosition = fishingPos,
                        powerPercent = 0
                    }
                }
                
                -- Kirim request fishing
                pcall(function()
                    FishGiver:FireServer(unpack(args))
                    fishCount = fishCount + 1
                    updateStats()
                    
                    -- Update position display
                    updatePositionDisplay()
                end)
                
                -- Tunggu sesuai delay yang di-set
                wait(currentDelay)
            end
        end)
        
        print("Auto fishing started! Delay: " .. currentDelay .. "s")
        print("Using dynamic position following player")
    else
        -- Stop farming
        statusValue.Text = "OFF"
        statusValue.TextColor3 = Color3.fromRGB(255, 80, 80)
        toggleBtn.Text = "START FARMING"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        minimizedStatus.Text = "OFF"
        minimizedStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
        
        if connection then
            connection:Disconnect()
            connection = nil
        end
        
        print("Auto fishing stopped!")
    end
    
    updateStats()
end

-- Fungsi untuk minimize/maximize
local function toggleMinimize()
    isMinimized = not isMinimized
    
    if isMinimized then
        mainFrame.Visible = false
        minimizedFrame.Visible = true
        minimizedFrame.Position = mainFrame.Position
    else
        mainFrame.Visible = true
        minimizedFrame.Visible = false
        mainFrame.Position = minimizedFrame.Position
    end
end

-- Fungsi untuk drag GUI
local function startDrag(frame)
    isDragging = true
    dragStartPos = Vector2.new(Mouse.X, Mouse.Y)
    guiStartPos = frame.Position
end

local function updateDrag(frame)
    if isDragging then
        local delta = Vector2.new(Mouse.X, Mouse.Y) - dragStartPos
        frame.Position = UDim2.new(
            guiStartPos.X.Scale, 
            guiStartPos.X.Offset + delta.X,
            guiStartPos.Y.Scale, 
            guiStartPos.Y.Offset + delta.Y
        )
    end
end

local function stopDrag()
    isDragging = false
end

-- Event Listeners untuk Main Frame
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        startDrag(mainFrame)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDrag(mainFrame)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        stopDrag()
    end
end)

-- Event Listeners untuk Minimized Frame
minimizedFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        startDrag(minimizedFrame)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
        if isMinimized then
            updateDrag(minimizedFrame)
        end
    end
end)

-- Tombol Events
toggleBtn.MouseButton1Click:Connect(toggleFarming)

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)

restoreBtn.MouseButton1Click:Connect(function()
    isMinimized = false
    mainFrame.Visible = true
    minimizedFrame.Visible = false
    mainFrame.Position = minimizedFrame.Position
end)

closeBtn.MouseButton1Click:Connect(function()
    -- Hanya minimize, tidak close sepenuhnya
    toggleMinimize()
end)

-- Delay Set Button
delaySetBtn.MouseButton1Click:Connect(function()
    setDelay(delayTextBox.Text)
end)

-- Enter key untuk set delay
delayTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        setDelay(delayTextBox.Text)
    end
end)

-- Preset Delay Buttons
preset1.MouseButton1Click:Connect(function()
    setDelay(0.1)
end)

preset2.MouseButton1Click:Connect(function()
    setDelay(0.5)
end)

preset3.MouseButton1Click:Connect(function()
    setDelay(1.0)
end)

-- Icon drag tooltip
dragIcon.MouseEnter:Connect(function()
    -- Buat tooltip sederhana
    local tooltip = Instance.new("TextLabel")
    tooltip.Name = "DragTooltip"
    tooltip.Size = UDim2.new(0, 80, 0, 30)
    tooltip.Position = UDim2.new(0, 0, 1, 5)
    tooltip.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    tooltip.Text = "Drag Me"
    tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
    tooltip.Font = Enum.Font.Gotham
    tooltip.TextSize = 12
    tooltip.BorderSizePixel = 1
    tooltip.BorderColor3 = Color3.fromRGB(0, 170, 255)
    tooltip.ZIndex = 100
    tooltip.Parent = dragIcon
    
    local tooltipCorner = Instance.new("UICorner")
    tooltipCorner.CornerRadius = UDim.new(0, 4)
    tooltipCorner.Parent = tooltip
end)

dragIcon.MouseLeave:Connect(function()
    if dragIcon:FindFirstChild("DragTooltip") then
        dragIcon.DragTooltip:Destroy()
    end
end)

-- Hotkey untuk toggle (Ctrl+F)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.F and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            toggleFarming()
        elseif input.KeyCode == Enum.KeyCode.M and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            toggleMinimize()
        elseif input.KeyCode == Enum.KeyCode.D and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            -- Ctrl+D untuk focus ke delay input
            delayTextBox:CaptureFocus()
        end
    end
end)

-- Update statistik secara berkala
RunService.Heartbeat:Connect(function()
    updateStats()
    
    -- Update position display saat farming
    if isFarming then
        updatePositionDisplay()
    end
end)

-- Info hotkey
local hotkeyInfo = Instance.new("TextLabel")
hotkeyInfo.Name = "HotkeyInfo"
hotkeyInfo.Size = UDim2.new(1, -20, 0, 30)
hotkeyInfo.Position = UDim2.new(0, 10, 0, 315)
hotkeyInfo.BackgroundTransparency = 1
hotkeyInfo.Text = "Hotkeys: Ctrl+F=Toggle, Ctrl+M=Minimize, Ctrl+D=Delay"
hotkeyInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
hotkeyInfo.Font = Enum.Font.Gotham
hotkeyInfo.TextSize = 10
hotkeyInfo.TextXAlignment = Enum.TextXAlignment.Center
hotkeyInfo.Parent = contentFrame

-- Inisialisasi
updateDelayDisplay()
setDelay(0.5) -- Set default delay dan highlight preset 2
updatePositionDisplay() -- Tampilkan posisi awal

print("==========================================")
print("Auto Farm Fishing GUI v2.1 Loaded!")
print("==========================================")
print("Features:")
print("- Dynamic Position (Following Player)")
print("- Manual Delay Input (0.1s - 5.0s)")
print("- 3 Preset Delays (0.1s, 0.5s, 1.0s)")
print("- Drag & Drop GUI")
print("- Minimize/Maximize")
print("- Real-time Statistics & Position Display")
print("==========================================")
print("Hotkeys:")
print("Ctrl+F = Toggle Farming")
print("Ctrl+M = Minimize GUI")
print("Ctrl+D = Focus Delay Input")
print("==========================================")
print("Note: Fishing position now follows player!")
print("==========================================")
