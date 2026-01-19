-- ============================================
-- [AMBN] FISHING BOT v1.2 - MINIMIZE + ULTRA FAST
-- ============================================

-- CLEAN UP FIRST
for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
    if gui.Name == "FishingBotGUI" or gui.Name == "ScreenGui" then
        gui:Destroy()
    end
end

local FishingBot = {
    Config = {
        Enabled = false,
        AutoFarm = true,
        AutoSell = true,
        InstantCatch = true,
        MaxFish = true,
        SellInterval = 60,
        CastDelayMin = 0.01,  -- NEW: Minimum delay
        CastDelayMax = 0.05,  -- NEW: Maximum delay
        UltraFast = true      -- NEW: Ultra fast mode
    },
    Services = {
        RS = game:GetService("ReplicatedStorage"),
        Players = game:GetService("Players")
    },
    Stats = {
        StartTime = os.time(),
        FishCaught = 0,
        MoneyEarned = 0
    },
    Running = false,
    Minimized = false  -- NEW: Minimize state
}

-- ============ SIMPLE GUI CREATOR WITH MINIMIZE ============
function FishingBot:CreateSimpleGUI()
    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FishingBotGUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Main Frame (simple, visible)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 250, 0, 350)
    MainFrame.Position = UDim2.new(0, 20, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    MainFrame.BorderSizePixel = 0
    MainFrame.BackgroundTransparency = 0
    MainFrame.Visible = true
    MainFrame.Parent = ScreenGui
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = Color3.fromRGB(60, 70, 90)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    -- Title Text
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "TitleText"
    TitleText.Text = "🎣 FISHING BOT"
    TitleText.Size = UDim2.new(1, -70, 1, 0)
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.TextColor3 = Color3.new(1, 1, 1)
    TitleText.Font = Enum.Font.SourceSansBold
    TitleText.TextSize = 18
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- NEW: Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Text = "_"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
    MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
    MinimizeButton.Font = Enum.Font.SourceSansBold
    MinimizeButton.TextSize = 16
    MinimizeButton.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Text = "X"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    CloseButton.TextColor3 = Color3.new(1, 1, 1)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.TextSize = 16
    CloseButton.Parent = TitleBar
    
    -- Status Display
    local StatusBox = Instance.new("Frame")
    StatusBox.Size = UDim2.new(1, -20, 0, 80)
    StatusBox.Position = UDim2.new(0, 10, 0, 50)
    StatusBox.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
    StatusBox.BorderSizePixel = 0
    StatusBox.Parent = MainFrame
    
    local StatusText = Instance.new("TextLabel")
    StatusText.Text = "Status: READY\nFish: 0\nMoney: $0\nDelay: 0.01-0.05s"
    StatusText.Size = UDim2.new(1, -10, 1, -10)
    StatusText.Position = UDim2.new(0, 5, 0, 5)
    StatusText.BackgroundTransparency = 1
    StatusText.TextColor3 = Color3.fromRGB(200, 220, 255)
    StatusText.Font = Enum.Font.SourceSans
    StatusText.TextSize = 14
    StatusText.TextXAlignment = Enum.TextXAlignment.Left
    StatusText.TextYAlignment = Enum.TextYAlignment.Top
    StatusText.Parent = StatusBox
    
    -- Control Buttons
    local ControlsY = 140
    local controlButtons = {
        {name = "START", color = Color3.fromRGB(60, 180, 80), func = "toggle"},
        {name = "AUTO FARM", color = Color3.fromRGB(80, 120, 200), config = "AutoFarm"},
        {name = "AUTO SELL", color = Color3.fromRGB(200, 120, 80), config = "AutoSell"},
        {name = "INSTANT CATCH", color = Color3.fromRGB(180, 80, 180), config = "InstantCatch"},
        {name = "ULTRA FAST", color = Color3.fromRGB(255, 100, 100), config = "UltraFast"},
        {name = "MAX FISH", color = Color3.fromRGB(180, 100, 200), config = "MaxFish"},
        {name = "SELL NOW", color = Color3.fromRGB(80, 180, 120), func = "sell"},
        {name = "GIVE FISH", color = Color3.fromRGB(180, 150, 80), func = "fish"}
    }
    
    for i, btnData in ipairs(controlButtons) do
        local row = math.floor((i-1)/2)
        local col = (i-1) % 2
        
        local button = Instance.new("TextButton")
        button.Text = btnData.name
        button.Size = UDim2.new(0.48, 0, 0, 35)
        button.Position = UDim2.new(col * 0.5, col * 5, 0, ControlsY + (row * 40))
        button.BackgroundColor3 = btnData.color
        
        if btnData.config then
            button.BackgroundColor3 = self.Config[btnData.config] and btnData.color or Color3.fromRGB(100, 100, 100)
        end
        
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.SourceSansBold
        button.TextSize = 11
        button.Parent = MainFrame
        
        -- Button click handler
        button.MouseButton1Click:Connect(function()
            if btnData.func == "toggle" then
                self:ToggleBot()
                button.Text = self.Running and "STOP" or "START"
                button.BackgroundColor3 = self.Running and Color3.fromRGB(220, 80, 80) or Color3.fromRGB(60, 180, 80)
                
            elseif btnData.func == "sell" then
                self:SellAllFish()
                
            elseif btnData.func == "fish" then
                self:GiveMaxFish()
                
            elseif btnData.config then
                self.Config[btnData.config] = not self.Config[btnData.config]
                button.BackgroundColor3 = self.Config[btnData.config] and btnData.color or Color3.fromRGB(100, 100, 100)
                
                -- Update status if UltraFast changed
                if btnData.config == "UltraFast" then
                    self:UpdateStatusText()
                end
            end
        end)
    end
    
    -- NEW: Delay adjustment buttons
    local DelayY = ControlsY + 160
    local delayFrame = Instance.new("Frame")
    delayFrame.Size = UDim2.new(1, -20, 0, 30)
    delayFrame.Position = UDim2.new(0, 10, 0, DelayY)
    delayFrame.BackgroundTransparency = 1
    delayFrame.Parent = MainFrame
    
    local delayLabel = Instance.new("TextLabel")
    delayLabel.Text = "DELAY:"
    delayLabel.Size = UDim2.new(0.3, 0, 1, 0)
    delayLabel.BackgroundTransparency = 1
    delayLabel.TextColor3 = Color3.new(1, 1, 1)
    delayLabel.Font = Enum.Font.SourceSansBold
    delayLabel.TextSize = 12
    delayLabel.TextXAlignment = Enum.TextXAlignment.Left
    delayLabel.Parent = delayFrame
    
    local delayDown = Instance.new("TextButton")
    delayDown.Text = "−"
    delayDown.Size = UDim2.new(0.2, 0, 1, 0)
    delayDown.Position = UDim2.new(0.3, 0, 0, 0)
    delayDown.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    delayDown.TextColor3 = Color3.new(1, 1, 1)
    delayDown.Font = Enum.Font.SourceSansBold
    delayDown.TextSize = 14
    delayDown.Parent = delayFrame
    
    local delayDisplay = Instance.new("TextLabel")
    delayDisplay.Text = string.format("%.03fs", self.Config.CastDelayMin)
    delayDisplay.Size = UDim2.new(0.3, 0, 1, 0)
    delayDisplay.Position = UDim2.new(0.5, 0, 0, 0)
    delayDisplay.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    delayDisplay.TextColor3 = Color3.new(1, 1, 1)
    delayDisplay.Font = Enum.Font.SourceSansBold
    delayDisplay.TextSize = 12
    delayDisplay.Parent = delayFrame
    
    local delayUp = Instance.new("TextButton")
    delayUp.Text = "+"
    delayUp.Size = UDim2.new(0.2, 0, 1, 0)
    delayUp.Position = UDim2.new(0.8, 0, 0, 0)
    delayUp.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    delayUp.TextColor3 = Color3.new(1, 1, 1)
    delayUp.Font = Enum.Font.SourceSansBold
    delayUp.TextSize = 14
    delayUp.Parent = delayFrame
    
    -- Delay adjustment handlers
    delayDown.MouseButton1Click:Connect(function()
        self.Config.CastDelayMin = math.max(0.001, self.Config.CastDelayMin - 0.001)
        delayDisplay.Text = string.format("%.03fs", self.Config.CastDelayMin)
        self:UpdateStatusText()
    end)
    
    delayUp.MouseButton1Click:Connect(function()
        self.Config.CastDelayMin = math.min(1.0, self.Config.CastDelayMin + 0.001)
        delayDisplay.Text = string.format("%.03fs", self.Config.CastDelayMin)
        self:UpdateStatusText()
    end)
    
    -- NEW: Minimize Button Handler
    MinimizeButton.MouseButton1Click:Connect(function()
        self.Minimized = not self.Minimized
        
        if self.Minimized then
            -- Minimize: hanya tampilkan title bar
            StatusBox.Visible = false
            for _, child in pairs(MainFrame:GetChildren()) do
                if child ~= TitleBar then
                    child.Visible = false
                end
            end
            MainFrame.Size = UDim2.new(0, 250, 0, 40)
            MinimizeButton.Text = "□"
        else
            -- Restore: tampilkan semua
            StatusBox.Visible = true
            for _, child in pairs(MainFrame:GetChildren()) do
                child.Visible = true
            end
            MainFrame.Size = UDim2.new(0, 250, 0, 350)
            MinimizeButton.Text = "_"
        end
    end)
    
    -- Close Button Handler
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        FishingBot.Running = false
    end)
    
    -- Drag functionality
    local dragging = false
    local dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                0, math.clamp(startPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - 250),
                0, math.clamp(startPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - (self.Minimized and 40 or 350))
            )
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        dragging = false
    end)
    
    -- Update status
    spawn(function()
        while ScreenGui and ScreenGui.Parent do
            self:UpdateStatusText()
            wait(0.5)
        end
    end)
    
    print("✅ GUI created successfully")
    return ScreenGui
end

-- NEW: Update status text function
function FishingBot:UpdateStatusText()
    local elapsed = os.time() - self.Stats.StartTime
    local minutes = math.floor(elapsed / 60)
    local seconds = elapsed % 60
    
    local status = self.Running and "RUNNING" or "READY"
    local delayText = string.format("Delay: %.03fs", self.Config.CastDelayMin)
    
    -- Update GUI jika ada
    local gui = game:GetService("CoreGui"):FindFirstChild("FishingBotGUI")
    if gui then
        local mainFrame = gui:FindFirstChild("MainFrame")
        if mainFrame then
            local statusBox = mainFrame:FindFirstChild("StatusBox")
            if statusBox then
                local statusText = statusBox:FindFirstChild("StatusText")
                if statusText then
                    statusText.Text = string.format(
                        "Status: %s\nFish: %d\nMoney: $%s\nTime: %02d:%02d\n%s",
                        status,
                        self.Stats.FishCaught,
                        self:FormatNumber(self.Stats.MoneyEarned),
                        minutes, seconds,
                        delayText
                    )
                end
            end
        end
    end
end

-- ============ ULTRA FAST FARMING ============
function FishingBot:StartFarming()
    spawn(function()
        while self.Running do
            if self.Config.AutoFarm then
                self:CastFishingRod()
                
                -- ULTRA FAST DELAY
                local delay = self.Config.CastDelayMin
                if not self.Config.UltraFast then
                    delay = math.random(10, 50) / 1000  -- 0.01-0.05 detik
                else
                    -- Jika UltraFast off, gunakan delay lebih lama
                    delay = math.random(50, 200) / 1000  -- 0.05-0.2 detik
                end
                
                wait(delay)
            else
                wait(1)
            end
        end
    end)
    
    spawn(function()
        while self.Running do
            if self.Config.AutoSell then
                wait(self.Config.SellInterval)
                if self.Running then
                    self:SellAllFish()
                end
            else
                wait(1)
            end
        end
    end)
end

-- ============ ULTRA FAST CASTING ============
function FishingBot:CastFishingRod()
    local fishingSystem = self.Services.RS:FindFirstChild("FishingSystem")
    if not fishingSystem then return end
    
    local char = self.Services.Players.LocalPlayer.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Cast parameters
    local startPos = root.Position
    local endPos = startPos + (root.CFrame.LookVector * 20)
    endPos = Vector3.new(endPos.X, math.max(endPos.Y, 5), endPos.Z)
    
    -- Send cast
    local castRemote = fishingSystem:FindFirstChild("CastReplication")
    if castRemote then
        local args = {startPos, endPos, "Basic Rod", 100}
        pcall(function()
            castRemote:FireServer(unpack(args))
            self.Stats.FishCaught = self.Stats.FishCaught + 1
            
            -- INSTANT CATCH
            if self.Config.InstantCatch then
                -- Give fish if enabled
                if self.Config.MaxFish then
                    self:GiveMaxFish()
                end
                
                -- Cleanup
                local cleanup = fishingSystem:FindFirstChild("CleanupCast")
                if cleanup then
                    cleanup:FireServer()
                end
            end
        end)
    end
end

-- ============ CORE FUNCTIONS ============
function FishingBot:ToggleBot()
    self.Running = not self.Running
    
    if self.Running then
        print("🚀 Fishing Bot STARTED (ULTRA FAST MODE)")
        self:StartFarming()
    else
        print("🛑 Fishing Bot STOPPED")
    end
end

function FishingBot:GiveMaxFish()
    local fishingSystem = self.Services.RS:FindFirstChild("FishingSystem")
    if not fishingSystem then return end
    
    local fishGiver = fishingSystem:FindFirstChild("FishGiver")
    if not fishGiver then return end
    
    local char = self.Services.Players.LocalPlayer.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local args = {{
        hookPosition = root.Position,
        name = "El Maja",
        rarity = "Secret",
        weight = 999999999
    }}
    
    pcall(function()
        fishGiver:FireServer(unpack(args))
    end)
end

function FishingBot:SellAllFish()
    local fishingSystem = self.Services.RS:FindFirstChild("FishingSystem")
    if not fishingSystem then return end
    
    local inventoryEvents = fishingSystem:FindFirstChild("InventoryEvents")
    if not inventoryEvents then return end
    
    local sellAll = inventoryEvents:FindFirstChild("Inventory_SellAll")
    if not sellAll then return end
    
    pcall(function()
        sellAll:InvokeServer()
        self.Stats.MoneyEarned = self.Stats.MoneyEarned + (self.Stats.FishCaught * 1000)
        self.Stats.FishCaught = 0
    end)
end

function FishingBot:FormatNumber(num)
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    else
        return tostring(num)
    end
end

-- ============ INITIALIZATION ============
function FishingBot:Start()
    print("==================================")
    print("🎣 FISHING BOT v1.2 - ULTRA FAST")
    print("Delay: 0.01-0.05 seconds")
    print("Minimize feature added")
    print("==================================")
    
    -- Create GUI first
    self:CreateSimpleGUI()
    
    print("✅ GUI with minimize button created")
    print("🎮 Click '_' to minimize, '□' to restore")
    print("⚡ Ultra Fast Mode: " .. tostring(self.Config.UltraFast))
    print("==================================")
    
    -- Console commands
    getgenv().FB = {
        start = function() FishingBot:ToggleBot() return "Started" end,
        stop = function() FishingBot.Running = false return "Stopped" end,
        sell = function() FishingBot:SellAllFish() return "Sold" end,
        fish = function() FishingBot:GiveMaxFish() return "Fish given" end,
        delay = function(ms)
            if ms then
                FishingBot.Config.CastDelayMin = ms / 1000
                return "Delay set to " .. ms .. "ms"
            end
            return "Current delay: " .. (FishingBot.Config.CastDelayMin * 1000) .. "ms"
        end,
        ultra = function(state)
            if state ~= nil then
                FishingBot.Config.UltraFast = state
            else
                FishingBot.Config.UltraFast = not FishingBot.Config.UltraFast
            end
            return "Ultra Fast: " .. (FishingBot.Config.UltraFast and "ON" or "OFF")
        end
    }
end

-- Start the bot
FishingBot:Start()

return FishingBot