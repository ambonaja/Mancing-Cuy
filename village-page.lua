-- GUI Auto Fishing Farm dengan Fishing Session System
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Deteksi jika di mobile
local isMobile = UserInputService.TouchEnabled

-- Buat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFishGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- TOMBOL TOGGLE UNTUK SHOW/HIDE GUI
local ToggleGUIButton = Instance.new("TextButton")
ToggleGUIButton.Name = "ToggleGUIButton"
ToggleGUIButton.Size = UDim2.new(0, 70, 0, 70)
ToggleGUIButton.Position = UDim2.new(1, -80, 0, 20)
ToggleGUIButton.AnchorPoint = Vector2.new(1, 0)
ToggleGUIButton.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
ToggleGUIButton.BorderSizePixel = 0
ToggleGUIButton.Text = "🎣"
ToggleGUIButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleGUIButton.TextSize = 32
ToggleGUIButton.Font = Enum.Font.GothamBold
ToggleGUIButton.ZIndex = 10
ToggleGUIButton.Parent = ScreenGui

local ToggleButtonCorner = Instance.new("UICorner")
ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
ToggleButtonCorner.Parent = ToggleGUIButton

-- Main Frame (GUI utama)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 500)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Corner untuk frame
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Shadow
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 80)
UIStroke.Thickness = 3
UIStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 12)
TitleBarCorner.Parent = TitleBar

-- Judul
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎣 FISHING SESSION"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -50, 0.5, -20)
CloseButton.AnchorPoint = Vector2.new(0, 0.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 24
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseButtonCorner = Instance.new("UICorner")
CloseButtonCorner.CornerRadius = UDim.new(0, 8)
CloseButtonCorner.Parent = CloseButton

-- Status Container
local StatusContainer = Instance.new("Frame")
StatusContainer.Name = "StatusContainer"
StatusContainer.Size = UDim2.new(1, -20, 0, 90)
StatusContainer.Position = UDim2.new(0, 10, 0, 60)
StatusContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
StatusContainer.BorderSizePixel = 0
StatusContainer.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 10)
StatusCorner.Parent = StatusContainer

-- Status Icon
local StatusIcon = Instance.new("Frame")
StatusIcon.Name = "StatusIcon"
StatusIcon.Size = UDim2.new(0, 50, 0, 50)
StatusIcon.Position = UDim2.new(0, 15, 0.5, -25)
StatusIcon.AnchorPoint = Vector2.new(0, 0.5)
StatusIcon.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
StatusIcon.BorderSizePixel = 0
StatusIcon.Parent = StatusContainer

local StatusIconCorner = Instance.new("UICorner")
StatusIconCorner.CornerRadius = UDim.new(1, 0)
StatusIconCorner.Parent = StatusIcon

-- Status Text
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -90, 0.6, 0)
StatusLabel.Position = UDim2.new(0, 80, 0, 10)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "FARMING SESSION\n<font color='rgb(255,100,100)'>IDLE</font>"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 20
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.RichText = true
StatusLabel.Parent = StatusContainer

-- Session Counter
local SessionCounter = Instance.new("TextLabel")
SessionCounter.Name = "SessionCounter"
SessionCounter.Size = UDim2.new(1, -90, 0.4, 0)
SessionCounter.Position = UDim2.new(0, 80, 0.6, 0)
SessionCounter.BackgroundTransparency = 1
SessionCounter.Text = "Sessions: 0"
SessionCounter.TextColor3 = Color3.fromRGB(150, 200, 255)
SessionCounter.TextSize = 16
SessionCounter.Font = Enum.Font.Gotham
SessionCounter.TextXAlignment = Enum.TextXAlignment.Left
SessionCounter.Parent = StatusContainer

-- Tombol Toggle Auto Farm
local ToggleFarmButton = Instance.new("TextButton")
ToggleFarmButton.Name = "ToggleFarmButton"
ToggleFarmButton.Size = UDim2.new(1, -20, 0, 70)
ToggleFarmButton.Position = UDim2.new(0, 10, 0, 160)
ToggleFarmButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
ToggleFarmButton.BorderSizePixel = 0
ToggleFarmButton.Text = "▶ START SESSION FARM"
ToggleFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleFarmButton.TextSize = 22
ToggleFarmButton.Font = Enum.Font.GothamBold
ToggleFarmButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 12)
ButtonCorner.Parent = ToggleFarmButton

-- Settings Container
local SettingsContainer = Instance.new("Frame")
SettingsContainer.Name = "SettingsContainer"
SettingsContainer.Size = UDim2.new(1, -20, 0, 210)
SettingsContainer.Position = UDim2.new(0, 10, 0, 240)
SettingsContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SettingsContainer.BorderSizePixel = 0
SettingsContainer.Parent = MainFrame

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 12)
SettingsCorner.Parent = SettingsContainer

-- Settings Title
local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Name = "SettingsTitle"
SettingsTitle.Size = UDim2.new(1, 0, 0, 40)
SettingsTitle.Position = UDim2.new(0, 0, 0, 0)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "⚙ SESSION SETTINGS"
SettingsTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
SettingsTitle.TextSize = 18
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.Parent = SettingsContainer

-- ===== DELAY 1: ANTAR CAST EVENT =====
local CastDelayContainer = Instance.new("Frame")
CastDelayContainer.Name = "CastDelayContainer"
CastDelayContainer.Size = UDim2.new(1, -20, 0, 70)
CastDelayContainer.Position = UDim2.new(0, 10, 0, 40)
CastDelayContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
CastDelayContainer.BorderSizePixel = 0
CastDelayContainer.Parent = SettingsContainer

local CastDelayCorner = Instance.new("UICorner")
CastDelayCorner.CornerRadius = UDim.new(0, 8)
CastDelayCorner.Parent = CastDelayContainer

-- Cast Delay Label
local CastDelayLabel = Instance.new("TextLabel")
CastDelayLabel.Name = "CastDelayLabel"
CastDelayLabel.Size = UDim2.new(0.6, 0, 0, 30)
CastDelayLabel.Position = UDim2.new(0, 10, 0, 0)
CastDelayLabel.BackgroundTransparency = 1
CastDelayLabel.Text = "Delay antar cast:"
CastDelayLabel.TextColor3 = Color3.fromRGB(180, 200, 255)
CastDelayLabel.TextSize = 16
CastDelayLabel.Font = Enum.Font.GothamBold
CastDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
CastDelayLabel.Parent = CastDelayContainer

-- Cast Delay Input
local CastDelayInput = Instance.new("TextBox")
CastDelayInput.Name = "CastDelayInput"
CastDelayInput.Size = UDim2.new(0.4, -10, 0, 30)
CastDelayInput.Position = UDim2.new(0.6, 0, 0, 30)
CastDelayInput.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
CastDelayInput.BorderSizePixel = 0
CastDelayInput.Text = "1.5"
CastDelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
CastDelayInput.TextSize = 16
CastDelayInput.Font = Enum.Font.GothamBold
CastDelayInput.PlaceholderText = "seconds"
CastDelayInput.TextXAlignment = Enum.TextXAlignment.Center
CastDelayInput.Parent = CastDelayContainer

local CastInputCorner = Instance.new("UICorner")
CastInputCorner.CornerRadius = UDim.new(0, 6)
CastInputCorner.Parent = CastDelayInput

-- Cast Delay Unit
local CastDelayUnit = Instance.new("TextLabel")
CastDelayUnit.Name = "CastDelayUnit"
CastDelayUnit.Size = UDim2.new(0.6, 0, 0, 30)
CastDelayUnit.Position = UDim2.new(0.4, 10, 0, 30)
CastDelayUnit.BackgroundTransparency = 1
CastDelayUnit.Text = "seconds"
CastDelayUnit.TextColor3 = Color3.fromRGB(150, 150, 150)
CastDelayUnit.TextSize = 14
CastDelayUnit.Font = Enum.Font.Gotham
CastDelayUnit.TextXAlignment = Enum.TextXAlignment.Left
CastDelayUnit.Parent = CastDelayContainer

-- ===== DELAY 2: SEBELUM MINIGAME =====
local MinigameDelayContainer = Instance.new("Frame")
MinigameDelayContainer.Name = "MinigameDelayContainer"
MinigameDelayContainer.Size = UDim2.new(1, -20, 0, 70)
MinigameDelayContainer.Position = UDim2.new(0, 10, 0, 120)
MinigameDelayContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
MinigameDelayContainer.BorderSizePixel = 0
MinigameDelayContainer.Parent = SettingsContainer

local MinigameDelayCorner = Instance.new("UICorner")
MinigameDelayCorner.CornerRadius = UDim.new(0, 8)
MinigameDelayCorner.Parent = MinigameDelayContainer

-- Minigame Delay Label
local MinigameDelayLabel = Instance.new("TextLabel")
MinigameDelayLabel.Name = "MinigameDelayLabel"
MinigameDelayLabel.Size = UDim2.new(0.6, 0, 0, 30)
MinigameDelayLabel.Position = UDim2.new(0, 10, 0, 0)
MinigameDelayLabel.BackgroundTransparency = 1
MinigameDelayLabel.Text = "Delay sebelum minigame:"
MinigameDelayLabel.TextColor3 = Color3.fromRGB(180, 200, 255)
MinigameDelayLabel.TextSize = 16
MinigameDelayLabel.Font = Enum.Font.GothamBold
MinigameDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
MinigameDelayLabel.Parent = MinigameDelayContainer

-- Minigame Delay Input
local MinigameDelayInput = Instance.new("TextBox")
MinigameDelayInput.Name = "MinigameDelayInput"
MinigameDelayInput.Size = UDim2.new(0.4, -10, 0, 30)
MinigameDelayInput.Position = UDim2.new(0.6, 0, 0, 30)
MinigameDelayInput.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
MinigameDelayInput.BorderSizePixel = 0
MinigameDelayInput.Text = "1.0"
MinigameDelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
MinigameDelayInput.TextSize = 16
MinigameDelayInput.Font = Enum.Font.GothamBold
MinigameDelayInput.PlaceholderText = "seconds"
MinigameDelayInput.TextXAlignment = Enum.TextXAlignment.Center
MinigameDelayInput.Parent = MinigameDelayContainer

local MinigameInputCorner = Instance.new("UICorner")
MinigameInputCorner.CornerRadius = UDim.new(0, 6)
MinigameInputCorner.Parent = MinigameDelayInput

-- Minigame Delay Unit
local MinigameDelayUnit = Instance.new("TextLabel")
MinigameDelayUnit.Name = "MinigameDelayUnit"
MinigameDelayUnit.Size = UDim2.new(0.6, 0, 0, 30)
MinigameDelayUnit.Position = UDim2.new(0.4, 10, 0, 30)
MinigameDelayUnit.BackgroundTransparency = 1
MinigameDelayUnit.Text = "seconds"
MinigameDelayUnit.TextColor3 = Color3.fromRGB(150, 150, 150)
MinigameDelayUnit.TextSize = 14
MinigameDelayUnit.Font = Enum.Font.Gotham
MinigameDelayUnit.TextXAlignment = Enum.TextXAlignment.Left
MinigameDelayUnit.Parent = MinigameDelayContainer

-- Current Settings Display
local CurrentSettingsLabel = Instance.new("TextLabel")
CurrentSettingsLabel.Name = "CurrentSettingsLabel"
CurrentSettingsLabel.Size = UDim2.new(1, -20, 0, 40)
CurrentSettingsLabel.Position = UDim2.new(0, 10, 0, 460)
CurrentSettingsLabel.BackgroundTransparency = 1
CurrentSettingsLabel.Text = "⏱ Session delay: Cast 1.5s | Minigame 1.0s"
CurrentSettingsLabel.TextColor3 = Color3.fromRGB(150, 200, 150)
CurrentSettingsLabel.TextSize = 14
CurrentSettingsLabel.Font = Enum.Font.Gotham
CurrentSettingsLabel.TextXAlignment = Enum.TextXAlignment.Left
CurrentSettingsLabel.Parent = MainFrame

-- Session Progress Bar Container
local ProgressContainer = Instance.new("Frame")
ProgressContainer.Name = "ProgressContainer"
ProgressContainer.Size = UDim2.new(1, -20, 0, 20)
ProgressContainer.Position = UDim2.new(0, 10, 0, 460)
ProgressContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ProgressContainer.BorderSizePixel = 0
ProgressContainer.Visible = false
ProgressContainer.Parent = MainFrame

local ProgressCorner = Instance.new("UICorner")
ProgressCorner.CornerRadius = UDim.new(1, 0)
ProgressCorner.Parent = ProgressContainer

-- Progress Bar
local ProgressBar = Instance.new("Frame")
ProgressBar.Name = "ProgressBar"
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.Position = UDim2.new(0, 0, 0, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
ProgressBar.BorderSizePixel = 0
ProgressBar.Parent = ProgressContainer

local ProgressBarCorner = Instance.new("UICorner")
ProgressBarCorner.CornerRadius = UDim.new(1, 0)
ProgressBarCorner.Parent = ProgressBar

-- Progress Text
local ProgressText = Instance.new("TextLabel")
ProgressText.Name = "ProgressText"
ProgressText.Size = UDim2.new(1, 0, 1, 0)
ProgressText.Position = UDim2.new(0, 0, 0, 0)
ProgressText.BackgroundTransparency = 1
ProgressText.Text = "Waiting for next session..."
ProgressText.TextColor3 = Color3.fromRGB(255, 255, 255)
ProgressText.TextSize = 12
ProgressText.Font = Enum.Font.GothamBold
ProgressText.Parent = ProgressContainer

-- Info Text
local InfoText = Instance.new("TextLabel")
InfoText.Name = "InfoText"
InfoText.Size = UDim2.new(1, -20, 0, 60)
InfoText.Position = UDim2.new(0, 10, 0, 490)
InfoText.BackgroundTransparency = 1
InfoText.Text = "📍 Cast position follows player\n🔄 One session = Cast1 → Cast2 → Minigame\n💤 Waits between sessions (no spam)"
InfoText.TextColor3 = Color3.fromRGB(150, 150, 150)
InfoText.TextSize = 14
InfoText.Font = Enum.Font.Gotham
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.Parent = MainFrame

-- Variabel untuk kontrol
local AutoFarmEnabled = false
local CastDelay = 1.5       -- Delay antar cast event
local MinigameDelay = 1.0   -- Delay sebelum minigame
local SessionDelay = 5.0    -- Delay antar session (detik)
local SessionCount = 0      -- Counter session
local Connection
local isExecutingSession = false

-- Fungsi untuk update settings display
function updateSettingsDisplay()
    CurrentSettingsLabel.Text = string.format("⏱ Session delay: Cast %.1fs | Minigame %.1fs", CastDelay, MinigameDelay)
end

-- Fungsi untuk update progress bar
function updateProgressBar(progress, text)
    if progress < 0 then progress = 0 end
    if progress > 1 then progress = 1 end
    
    ProgressBar:TweenSize(
        UDim2.new(progress, 0, 1, 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.3,
        true
    )
    
    ProgressText.Text = text
end

-- Fungsi untuk mendapatkan posisi player
function getPlayerPosition()
    local character = Player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        return character.HumanoidRootPart.Position
    end
    return Vector3.new(0, 0, 0)
end

-- Fungsi untuk mendapatkan alat pancingan
function getFishingTool()
    -- Cek di backpack dulu
    local backpack = Player:FindFirstChild("Backpack")
    if backpack then
        local fishingTool = backpack:FindFirstChild("Pancingan Cupu")
        if fishingTool then
            return fishingTool
        end
    end
    
    -- Cek di character
    local character = Player.Character
    if character then
        local fishingTool = character:FindFirstChild("Pancingan Cupu")
        if fishingTool then
            return fishingTool
        end
    end
    
    return nil
end

-- Fungsi untuk update delay (auto apply saat input berubah)
function updateCastDelay()
    local newDelay = tonumber(CastDelayInput.Text)
    if newDelay and newDelay >= 0.5 then
        CastDelay = newDelay
        CastDelayInput.Text = string.format("%.1f", newDelay)
        CastDelayInput.TextColor3 = Color3.fromRGB(100, 255, 100)
        updateSettingsDisplay()
        
        spawn(function()
            wait(0.3)
            CastDelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        
        return true
    else
        CastDelayInput.Text = string.format("%.1f", CastDelay)
        CastDelayInput.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        spawn(function()
            wait(0.5)
            CastDelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        
        return false
    end
end

function updateMinigameDelay()
    local newDelay = tonumber(MinigameDelayInput.Text)
    if newDelay and newDelay >= 0 then
        MinigameDelay = newDelay
        MinigameDelayInput.Text = string.format("%.1f", newDelay)
        MinigameDelayInput.TextColor3 = Color3.fromRGB(100, 255, 100)
        updateSettingsDisplay()
        
        spawn(function()
            wait(0.3)
            MinigameDelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        
        return true
    else
        MinigameDelayInput.Text = string.format("%.1f", MinigameDelay)
        MinigameDelayInput.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        spawn(function()
            wait(0.5)
            MinigameDelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        
        return false
    end
end

-- Fungsi untuk execute SATU SESSION fishing
function executeFishingSession()
    if not AutoFarmEnabled or isExecutingSession then return end
    
    isExecutingSession = true
    
    -- Update status
    StatusLabel.Text = "FARMING SESSION\n<font color='rgb(100,255,100)'>IN PROGRESS</font>"
    StatusIcon.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
    
    local fishingTool = getFishingTool()
    if not fishingTool then
        warn("Fishing tool not found!")
        isExecutingSession = false
        return
    end
    
    local mechanics = fishingTool:WaitForChild("Mechanics", 5)
    if not mechanics then 
        isExecutingSession = false
        return 
    end
    
    local remotes = mechanics:WaitForChild("Remotes", 5)
    if not remotes then 
        isExecutingSession = false
        return 
    end
    
    local castEvent = remotes:WaitForChild("CastEvent", 5)
    if not castEvent then 
        isExecutingSession = false
        return 
    end
    
    local miniGameEvent = remotes:WaitForChild("MiniGame", 5)
    if not miniGameEvent then 
        isExecutingSession = false
        return 
    end
    
    print("🎣 Starting fishing session...")
    
    -- Show progress bar
    ProgressContainer.Visible = true
    CurrentSettingsLabel.Visible = false
    
    -- Step 1: Cast fishing (true)
    updateProgressBar(0.2, "Casting first line...")
    local args1 = {true}
    pcall(function()
        if Player.Character and Player.Character:FindFirstChild("Pancingan Cupu") then
            Player.Character["Pancingan Cupu"].Mechanics.Remotes.CastEvent:FireServer(unpack(args1))
            print("  ✅ Cast 1 executed")
        end
    end)
    
    -- DELAY ANTAR CAST
    updateProgressBar(0.4, string.format("Waiting %.1f seconds...", CastDelay))
    wait(CastDelay)
    
    -- Step 2: Cast dengan posisi mengikuti player
    updateProgressBar(0.6, "Casting second line...")
    local args2 = {
        false,
        4.273468255996704 -- Default value
    }
    pcall(function()
        if Player.Character and Player.Character:FindFirstChild("Pancingan Cupu") then
            Player.Character["Pancingan Cupu"].Mechanics.Remotes.CastEvent:FireServer(unpack(args2))
            print("  ✅ Cast 2 executed")
        end
    end)
    
    -- DELAY SEBELUM MINIGAME
    updateProgressBar(0.8, string.format("Preparing minigame %.1fs...", MinigameDelay))
    wait(MinigameDelay)
    
    -- Step 3: Minigame (true) - SETELAH DELAY
    updateProgressBar(0.9, "Executing minigame...")
    local args3 = {true}
    pcall(function()
        miniGameEvent:FireServer(unpack(args3))
        print("  ✅ Minigame executed")
    end)
    
    -- Session selesai
    updateProgressBar(1.0, "✅ Session completed!")
    
    -- Update counter
    SessionCount = SessionCount + 1
    SessionCounter.Text = string.format("Sessions: %d", SessionCount)
    
    print(string.format("✅ Fishing session #%d completed!", SessionCount))
    
    -- Tunggu sebentar sebelum reset progress
    wait(0.5)
    
    -- Reset progress bar
    ProgressContainer.Visible = false
    CurrentSettingsLabel.Visible = true
    
    -- Reset status
    StatusLabel.Text = "FARMING SESSION\n<font color='rgb(255,200,100)'>WAITING</font>"
    StatusIcon.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
    
    isExecutingSession = false
end

-- Fungsi untuk auto farm loop dengan session system
function startSessionFarm()
    if not AutoFarmEnabled then return end
    
    while AutoFarmEnabled do
        -- Tunggu delay antar session
        local waitTime = SessionDelay
        
        -- Countdown progress
        if AutoFarmEnabled then
            ProgressContainer.Visible = true
            CurrentSettingsLabel.Visible = false
            
            for i = waitTime, 0, -1 do
                if not AutoFarmEnabled then break end
                
                local progress = 1 - (i / waitTime)
                updateProgressBar(progress, string.format("Next session in: %ds", i))
                
                StatusLabel.Text = string.format("FARMING SESSION\n<font color='rgb(255,200,100)'>WAITING %ds</font>", i)
                
                wait(1)
            end
            
            ProgressContainer.Visible = false
            CurrentSettingsLabel.Visible = true
        end
        
        -- Execute satu session
        if AutoFarmEnabled then
            executeFishingSession()
        end
    end
end

-- Fungsi toggle auto farm
function toggleAutoFarm()
    -- Validasi input sebelum mulai
    if not updateCastDelay() or not updateMinigameDelay() then
        print("❌ Invalid delay values! Please check your inputs.")
        return
    end
    
    AutoFarmEnabled = not AutoFarmEnabled
    
    if AutoFarmEnabled then
        -- ON State
        StatusLabel.Text = "FARMING SESSION\n<font color='rgb(100,255,100)'>STARTING</font>"
        StatusIcon.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        ToggleFarmButton.Text = "⏸ STOP SESSION FARM"
        ToggleFarmButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        
        -- Mulai session farm dalam thread terpisah
        spawn(startSessionFarm)
        
        print("========================================")
        print("🎣 SESSION FARMING STARTED!")
        print("⏰ Session Settings:")
        print("   • Delay antar cast:", CastDelay, "seconds")
        print("   • Delay sebelum minigame:", MinigameDelay, "seconds")
        print("   • Delay antar session:", SessionDelay, "seconds")
        print("📍 One session = Cast1 → Cast2 → Minigame")
        print("========================================")
        
    else
        -- OFF State
        StatusLabel.Text = "FARMING SESSION\n<font color='rgb(255,100,100)'>IDLE</font>"
        StatusIcon.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        ToggleFarmButton.Text = "▶ START SESSION FARM"
        ToggleFarmButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        
        -- Hide progress bar
        ProgressContainer.Visible = false
        CurrentSettingsLabel.Visible = true
        
        print("⏹ Session Farming Stopped")
        print(string.format("📊 Total sessions completed: %d", SessionCount))
    end
end

-- Fungsi show/hide GUI
function toggleGUI()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        ToggleGUIButton.Text = "⬇️"
        ToggleGUIButton.BackgroundColor3 = Color3.fromRGB(200, 100, 60)
    else
        ToggleGUIButton.Text = "🎣"
        ToggleGUIButton.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
    end
end

-- ========== EVENT CONNECTIONS ==========

-- Toggle GUI dengan tombol 🎣
ToggleGUIButton.MouseButton1Click:Connect(toggleGUI)

-- Toggle GUI dengan tombol close
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleGUIButton.Text = "🎣"
    ToggleGUIButton.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
end)

-- Toggle auto farm
ToggleFarmButton.MouseButton1Click:Connect(toggleAutoFarm)

-- Auto apply saat input berubah
CastDelayInput.FocusLost:Connect(function(enterPressed)
    updateCastDelay()
end)

MinigameDelayInput.FocusLost:Connect(function(enterPressed)
    updateMinigameDelay()
end)

-- Efek hover untuk tombol
if not isMobile then
    ToggleFarmButton.MouseEnter:Connect(function()
        if AutoFarmEnabled then
            ToggleFarmButton.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
        else
            ToggleFarmButton.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
        end
    end)
    
    ToggleFarmButton.MouseLeave:Connect(function()
        if AutoFarmEnabled then
            ToggleFarmButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        else
            ToggleFarmButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        end
    end)
end

-- Toggle GUI dengan key F (desktop)
if not isMobile then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.F then
            toggleGUI()
        end
    end)
end

-- Inisialisasi settings display
updateSettingsDisplay()

print("======================================")
print("🎣 FISHING SESSION FARM LOADED!")
print("======================================")
print("✅ Tombol 🎣 muncul di pojok kanan atas")
print("✅ Klik tombol 🎣 untuk buka GUI")
print("✅ Features:")
print("   • ONE SESSION SYSTEM (No Spam)")
print("   • Each session: Cast1 → Cast2 → Minigame")
print("   • 5 seconds delay between sessions")
print("   • Session counter")
print("   • Progress bar visualization")
print("======================================")

-- Pemberitahuan awal
wait(1)
print("\n📱 Klik tombol 🎣 di pojok kanan atas untuk membuka GUI!")
