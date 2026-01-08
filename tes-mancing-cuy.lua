-- =====================================================
-- AUTO FISH + AUTO SELL (MOBILE FRIENDLY)
-- Author : Ambon
-- =====================================================

-- ========= CLEAN OLD GUI =========
pcall(function()
    if _G.AutoFishGUI then
        _G.AutoFishGUI:Destroy()
    end
end)

-- ========= SERVICES =========
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- ========= STATE =========
local AUTO_FISH = false
local AUTO_SELL = false
local minimized = false

-- ========= CONFIG =========
local LOOP_DELAY = 1.5 -- WAJIB > 0 (mobile safe)

local FISH_REMOTE_NAME = "FishGiver"
local SELL_REMOTE_NAME = "SellSingle"

-- ========= DATA IKAN (EDIT DI SINI) =========
local FISH_DATA = {
    hookPosition = vector.create(
        167.86424255371094,
        16.14996910095215,
        18.95108985900879
    ),
    name = "Ences Maja",
    rarity = "Secret",
    weight = 9999
}

-- ========= GUI =========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFishSellGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")
_G.AutoFishGUI = ScreenGui

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 220, 0, 160)
Main.Position = UDim2.new(0.5, -110, 0.65, 0)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,16)

-- ========= TITLE =========
local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1, -80, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Text = "🎣 AUTO FISH"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ========= HEADER BUTTONS =========
local BtnMin = Instance.new("TextButton")
BtnMin.Parent = Main
BtnMin.Size = UDim2.new(0, 30, 0, 30)
BtnMin.Position = UDim2.new(1, -70, 0, 5)
BtnMin.Text = "–"
BtnMin.Font = Enum.Font.GothamBold
BtnMin.TextScaled = true
BtnMin.TextColor3 = Color3.new(1,1,1)
BtnMin.BackgroundColor3 = Color3.fromRGB(60,60,60)
BtnMin.BorderSizePixel = 0
Instance.new("UICorner", BtnMin).CornerRadius = UDim.new(0,8)

local BtnClose = Instance.new("TextButton")
BtnClose.Parent = Main
BtnClose.Size = UDim2.new(0, 30, 0, 30)
BtnClose.Position = UDim2.new(1, -35, 0, 5)
BtnClose.Text = "X"
BtnClose.Font = Enum.Font.GothamBold
BtnClose.TextScaled = true
BtnClose.TextColor3 = Color3.new(1,1,1)
BtnClose.BackgroundColor3 = Color3.fromRGB(170,60,60)
BtnClose.BorderSizePixel = 0
Instance.new("UICorner", BtnClose).CornerRadius = UDim.new(0,8)

-- ========= BUTTON MAKER =========
local function newBtn(text, y)
    local b = Instance.new("TextButton")
    b.Parent = Main
    b.Size = UDim2.new(1, -30, 0, 45)
    b.Position = UDim2.new(0, 15, 0, y)
    b.Text = text .. " : OFF"
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(170,60,60)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
    return b
end

local FishBtn = newBtn("AUTO FISH", 45)
local SellBtn = newBtn("AUTO SELL", 100)

-- ========= TOGGLE =========
FishBtn.MouseButton1Click:Connect(function()
    AUTO_FISH = not AUTO_FISH
    FishBtn.Text = "AUTO FISH : " .. (AUTO_FISH and "ON" or "OFF")
    FishBtn.BackgroundColor3 = AUTO_FISH and Color3.fromRGB(60,170,90) or Color3.fromRGB(170,60,60)
end)

SellBtn.MouseButton1Click:Connect(function()
    AUTO_SELL = not AUTO_SELL
    SellBtn.Text = "AUTO SELL : " .. (AUTO_SELL and "ON" or "OFF")
    SellBtn.BackgroundColor3 = AUTO_SELL and Color3.fromRGB(60,120,200) or Color3.fromRGB(170,60,60)
end)

-- ========= MINIMIZE =========
local originalSize = Main.Size
BtnMin.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Main.Size = UDim2.new(0, 220, 0, 45)
        FishBtn.Visible = false
        SellBtn.Visible = false
        BtnMin.Text = "+"
    else
        Main.Size = originalSize
        FishBtn.Visible = true
        SellBtn.Visible = true
        BtnMin.Text = "–"
    end
end)

-- ========= CLOSE =========
BtnClose.MouseButton1Click:Connect(function()
    AUTO_FISH = false
    AUTO_SELL = false
    ScreenGui:Destroy()
    _G.AutoFishGUI = nil
end)

-- ========= REMOTE GETTER =========
local function getRemote(name)
    local fs = ReplicatedStorage:FindFirstChild("FishingSystem")
    if not fs then return nil end
    local ev = fs:FindFirstChild("FishingSystemEvents")
    if not ev then return nil end
    return ev:FindFirstChild(name)
end

-- ========= AUTO LOGIC =========
task.spawn(function()
    while ScreenGui.Parent do
        if AUTO_FISH then
            local fishRemote = getRemote(FISH_REMOTE_NAME)
            if fishRemote then
                fishRemote:FireServer({
                    hookPosition = FISH_DATA.hookPosition,
                    name = FISH_DATA.name,
                    rarity = FISH_DATA.rarity,
                    weight = FISH_DATA.weight
                })
            end
        end

        if AUTO_SELL then
            local sellRemote = getRemote(SELL_REMOTE_NAME)
            if sellRemote then
                sellRemote:FireServer()
            end
        end

        task.wait(LOOP_DELAY)
    end
end)

warn("✅ AUTO FISH + AUTO SELL AKTIF")
