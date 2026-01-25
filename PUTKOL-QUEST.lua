-- Konfigurasi
local fishingEvent = game:GetService("ReplicatedStorage"):WaitForChild("FishingSystem"):WaitForChild("KasihIkanItu")

-- Data lokasi hook dengan beberapa contoh
local hookLocations = {
    {hookPosition = Vector3.new(-970.92, 128.15, -772.33), name = "Kudasay", rarity = "Mitos", weight = 64},
    {hookPosition = Vector3.new(-1000, 130, -800), name = "Golden Fin", rarity = "Langka", weight = 45},
    {hookPosition = Vector3.new(-950, 125, -750), name = "Shadow Scale", rarity = "Epik", weight = 78},
    {hookPosition = Vector3.new(-1050, 135, -850), name = "Crystal Fish", rarity = "Legenda", weight = 92},
    {hookPosition = Vector3.new(-919.1781616210938, 128.1500244140625, -641.6729736328125), name = "Leviathan Core", rarity = "Secret", weight = 660}
}

-- Variables
local isFishing = false
local selectedLocation = 1
local fishingConnection
local isMinimized = false

-- GUI Setup
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Hapus GUI lama jika ada
if playerGui:FindFirstChild("FishingGUI") then
    playerGui.FishingGUI:Destroy()
end

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FishingGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Frame Utama
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 250)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 150, 200)
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Title Bar dengan tombol kontrol
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎣 Auto Fishing"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Tombol Minimize
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0.5, -15)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
minimizeBtn.Text = "─"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn

-- Tombol Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Container untuk konten (bisa di-minimize)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 35)
statusLabel.Position = UDim2.new(0, 10, 0, 10)
statusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
statusLabel.Text = "Status: ❌ Tidak Aktif"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = contentFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusLabel

-- Location Selector
local locationFrame = Instance.new("Frame")
locationFrame.Size = UDim2.new(1, -20, 0, 60)
locationFrame.Position = UDim2.new(0, 10, 0, 55)
locationFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
locationFrame.Parent = contentFrame

local locCorner = Instance.new("UICorner")
locCorner.CornerRadius = UDim.new(0, 6)
locCorner.Parent = locationFrame

local locationText = Instance.new("TextLabel")
locationText.Size = UDim2.new(0.7, 0, 1, 0)
locationText.Position = UDim2.new(0, 10, 0, 0)
locationText.BackgroundTransparency = 1
locationText.Text = hookLocations[1].name .. "\n" .. hookLocations[1].rarity
locationText.TextColor3 = Color3.fromRGB(0, 200, 255)
locationText.TextSize = 14
locationText.Font = Enum.Font.GothamBold
locationText.TextXAlignment = Enum.TextXAlignment.Left
locationText.TextWrapped = true
locationText.Parent = locationFrame

local nextBtn = Instance.new("TextButton")
nextBtn.Size = UDim2.new(0.25, 0, 0.6, 0)
nextBtn.Position = UDim2.new(0.73, 0, 0.2, 0)
nextBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
nextBtn.Text = "Next"
nextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
nextBtn.TextSize = 12
nextBtn.Font = Enum.Font.GothamBold
nextBtn.Parent = locationFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = nextBtn

-- Delay Setting
local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0.5, 0, 0, 25)
delayLabel.Position = UDim2.new(0, 10, 0, 125)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "Delay (detik):"
delayLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
delayLabel.TextSize = 14
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = contentFrame

local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(0.4, 0, 0, 30)
delayBox.Position = UDim2.new(0.5, 0, 0, 125)
delayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
delayBox.Text = "2"
delayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayBox.TextSize = 14
delayBox.Font = Enum.Font.Gotham
delayBox.Parent = contentFrame

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 6)
delayCorner.Parent = delayBox

-- Start/Stop Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
toggleBtn.Position = UDim2.new(0.1, 0, 1, -55)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
toggleBtn.Text = "▶ START FISHING"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 16
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = contentFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleBtn

-- Fungsi untuk memulai auto fishing
local function startFishing()
    if isFishing then return end
    
    isFishing = true
    toggleBtn.Text = "⏸ STOP FISHING"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(220, 120, 0)
    statusLabel.Text = "Status: 🎣 Sedang Fishing..."
    
    local delayTime = tonumber(delayBox.Text) or 2
    if delayTime < 0.5 then delayTime = 0.5 end
    
    fishingConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not isFishing then return end
        
        local args = {hookLocations[selectedLocation]}
        fishingEvent:FireServer(unpack(args))
        
        task.wait(delayTime)
    end)
end

-- Fungsi untuk menghentikan auto fishing
local function stopFishing()
    if not isFishing then return end
    
    isFishing = false
    toggleBtn.Text = "▶ START FISHING"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
    statusLabel.Text = "Status: ❌ Tidak Aktif"
    
    if fishingConnection then
        fishingConnection:Disconnect()
        fishingConnection = nil
    end
end

-- Fungsi toggle fishing
local function toggleFishing()
    if isFishing then
        stopFishing()
    else
        startFishing()
    end
end

-- Fungsi minimize/maximize
local function toggleMinimize()
    isMinimized = not isMinimized
    
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 300, 0, 40)
        contentFrame.Visible = false
        minimizeBtn.Text = "□"
    else
        mainFrame.Size = UDim2.new(0, 300, 0, 250)
        contentFrame.Visible = true
        minimizeBtn.Text = "─"
    end
end

-- Change location
nextBtn.MouseButton1Click:Connect(function()
    selectedLocation = selectedLocation + 1
    if selectedLocation > #hookLocations then
        selectedLocation = 1
    end
    locationText.Text = hookLocations[selectedLocation].name .. "\n" .. hookLocations[selectedLocation].rarity
end)

-- Start/Stop fishing
toggleBtn.MouseButton1Click:Connect(toggleFishing)

-- Minimize button
minimizeBtn.MouseButton1Click:Connect(toggleMinimize)

-- Close button
closeBtn.MouseButton1Click:Connect(function()
    stopFishing()
    screenGui:Destroy()
end)

-- Close GUI dengan RightControl
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        stopFishing()
        screenGui:Destroy()
    end
end)

-- Make window draggable
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)

-- Notifikasi saat GUI dimuat
statusLabel.Text = "Status: ✅ GUI Siap!"
print("🎣 Auto Fishing GUI Loaded!")
print("Tekan RightControl untuk menutup GUI")