--====================================================
-- AUTO FISH MOBILE FINAL - FULL SYSTEM
--====================================================

pcall(function()
    if _G.FISH_GUI then _G.FISH_GUI:Destroy() end
end)

--================ SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

--================ REMOTES =================
local FishRemote = ReplicatedStorage:WaitForChild("FishingSystem")
    :WaitForChild("FishingSystemEvents")
    :WaitForChild("FishGiver")

local SellRemote = ReplicatedStorage:WaitForChild("FishingSystem")
    :WaitForChild("FishingSystemEvents")
    :WaitForChild("Inventory_SellAll_NPC")

--================ GLOBAL =================
_G.AutoFish = false
_G.AutoSell = false
_G.SafeMode = true
_G.Busy = false
_G.SelectedFish = {}

--================ FISH DATABASE =================
local FishDatabase = {
    ["Ikan Badut"] = {name="Ikan Badut", rarity="Common", weight=1},
    ["Kelomang"] = {name="Kelomang", rarity="Common", weight=2},
    ["Lopster Merah"] = {name="Lopster Merah", rarity="Common", weight=4},
    ["Lopster Biru"] = {name="Lopster Biru", rarity="Common", weight=4},
    ["Ikan Malaikat"] = {name="Ikan Malaikat", rarity="Uncommon", weight=2},
    ["Kepiting Biru"] = {name="Kepiting Biru", rarity="Uncommon", weight=3},
    ["Kepala Ular"] = {name="Kepala Ular", rarity="Rare", weight=5},
    ["Green Gillfish"] = {name="Green Gillfish", rarity="Rare", weight=4},
    ["Dory"] = {name="Dory", rarity="Rare", weight=3},
    ["Domino Damsel"] = {name="Domino Damsel", rarity="Rare", weight=3},
    ["Blackcap Basslet"] = {name="Blackcap Basslet", rarity="Epic", weight=6},
    ["Candy Butterfly"] = {name="Candy Butterfly", rarity="Epic", weight=6},
    ["Volsail Tang"] = {name="Volsail Tang", rarity="Epic", weight=7},
    ["Boar Fish"] = {name="Boar Fish", rarity="Epic", weight=8},
    ["Belut Panther"] = {name="Belut Panther", rarity="Epic", weight=7},
    ["Goliath Tiger"] = {name="Goliath Tiger", rarity="Legendary", weight=15},
    ["Hammerhead Shark"] = {name="Hammerhead Shark", rarity="Legendary", weight=20},
    ["Loggerhead Turtle"] = {name="Loggerhead Turtle", rarity="Legendary", weight=18},
    ["Tuna Lava"] = {name="Tuna Lava", rarity="Legendary", weight=16},
    ["Fangtooth"] = {name="Fangtooth", rarity="Legendary", weight=14},
    ["Hiu Magma"] = {name="Hiu Magma", rarity="Mythical", weight=30},
    ["Gadis Lava"] = {name="Gadis Lava", rarity="Mythical", weight=28},
    ["Kardian Lava"] = {name="Kardian Lava", rarity="Mythical", weight=26},
    ["Kupu-Kupu Lava"] = {name="Kupu-Kupu Lava", rarity="Mythical", weight=24},
    ["Blueflame Ray"] = {name="Blueflame Ray", rarity="Mythical", weight=32},
    ["Frostborn Shark"] = {name="Frostborn Shark", rarity="Secret", weight=999},
    ["Fossilized Shark"] = {name="Fossilized Shark", rarity="Secret", weight=997},
    ["Megalodon"] = {name="Megalodon", rarity="Secret", weight=998},
    ["Purple Megalodon"] = {name="Purple Megalodon", rarity="Secret", weight=979},
    ["Zombie Megalodon"] = {name="Zombie Megalodon", rarity="Secret", weight=986},
    ["Ences Maja"] = {name="Ences Maja", rarity="Secret", weight=990},
    ["El Maja"] = {name="El Maja", rarity="Secret", weight=989},
    ["Ancient Lochness Monster"] = {name="Secret Lochness Monster", rarity="Secret", weight=980},
    ["Ancient Lochness Lava"] = {name="Secret Lochness Lava", rarity="Secret", weight=980},
}

--================ AUTO ADD NEW FISH =================
local DEFAULT_FISH = {rarity="Secret", weight=999}

local FishAssets = ReplicatedStorage:WaitForChild("FishingSystem")
    :WaitForChild("Assets")
    :WaitForChild("Fish")

local function AutoFillFishDatabase()
    for _,fish in ipairs(FishAssets:GetChildren()) do
        if not FishDatabase[fish.Name] then
            FishDatabase[fish.Name] = {
                name = fish.Name,
                rarity = DEFAULT_FISH.rarity,
                weight = DEFAULT_FISH.weight
            }
        end
    end
end

FishAssets.ChildAdded:Connect(function(fish)
    if not FishDatabase[fish.Name] then
        FishDatabase[fish.Name] = {
            name = fish.Name,
            rarity = DEFAULT_FISH.rarity,
            weight = DEFAULT_FISH.weight
        }
        task.wait(0.2)
        BuildFishChecklist()
    end
end)

AutoFillFishDatabase()

--================ RATE LIMIT =================
local lastFire = 0
local function CanFire()
    local delay = _G.SafeMode and 0.12 or 0.05
    if tick() - lastFire >= delay then
        lastFire = tick()
        return true
    end
    return false
end

--================ GUI =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.IgnoreGuiInset = true
gui.Name = "AUTO_FISH_GUI"
_G.FISH_GUI = gui

local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0,520,0,300)
Main.Position = UDim2.new(0.5,-260,0.5,-150)
Main.BackgroundColor3 = Color3.fromRGB(22,22,28)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,14)

-- HEADER
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1,0,0,32)
Header.Text = "AMBON EWE TOKYO🥴😜"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 14
Header.TextColor3 = Color3.new(1,1,1)
Header.BackgroundTransparency = 1

-- MINIMIZE
local MiniBtn = Instance.new("TextButton", Main)
MiniBtn.Size = UDim2.new(0,32,0,32)
MiniBtn.Position = UDim2.new(1,-36,0,0)
MiniBtn.Text = "-"
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.TextSize = 20
MiniBtn.BackgroundTransparency = 1
MiniBtn.TextColor3 = Color3.new(1,1,1)

local Mini = Instance.new("TextButton", gui)
Mini.Size = UDim2.new(0,46,0,46)
Mini.Position = UDim2.new(0,20,0.5,-23)
Mini.Text = "🐟"
Mini.TextSize = 22
Mini.Visible = false
Mini.Active = true
Mini.Draggable = true
Mini.BackgroundColor3 = Color3.fromRGB(0,170,255)
Mini.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",Mini).CornerRadius = UDim.new(1,0)

MiniBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    Mini.Visible = true
end)

Mini.MouseButton1Click:Connect(function()
    Main.Visible = true
    Mini.Visible = false
end)

--================ BUTTONS =================
local function Btn(text,y)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0,130,0,34)
    b.Position = UDim2.new(0,10,0,y)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(70,70,80)
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)
    return b
end

local AutoFishBtn = Btn("AUTO EWE😋",40)
local AutoSellBtn = Btn("AUTO JUAL TOKYO🤤",80)
local ModeBtn = Btn("MODE : SAFE",120)

AutoFishBtn.MouseButton1Click:Connect(function()
    _G.AutoFish = not _G.AutoFish
end)

AutoSellBtn.MouseButton1Click:Connect(function()
    _G.AutoSell = not _G.AutoSell
end)

ModeBtn.MouseButton1Click:Connect(function()
    _G.SafeMode = not _G.SafeMode
    ModeBtn.Text = _G.SafeMode and "MODE : SAFE" or "MODE : BRUTAL"
end)

--================ CHECKLIST =================
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0,340,0,230)
Scroll.Position = UDim2.new(0,160,0,40)
Scroll.ScrollBarThickness = 6
Scroll.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0,6)

function BuildFishChecklist()
    for _,v in ipairs(Scroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end

    for name,data in pairs(FishDatabase) do
        _G.SelectedFish[name] = true

        local b = Instance.new("TextButton", Scroll)
        b.Size = UDim2.new(1,-6,0,32)
        b.Text = "☑ "..name.." ["..data.rarity.."]"
        b.Font = Enum.Font.GothamBold
        b.TextSize = 11
        b.TextColor3 = Color3.new(1,1,1)
        b.BackgroundColor3 = Color3.fromRGB(90,90,100)
        Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)

        b.MouseButton1Click:Connect(function()
            _G.SelectedFish[name] = not _G.SelectedFish[name]
            b.Text = (_G.SelectedFish[name] and "☑ " or "☐ ")..name.." ["..data.rarity.."]"
        end)
    end

    task.wait()
    Scroll.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
end

BuildFishChecklist()

--================ AUTO FISH CORE =================
task.spawn(function()
    while task.wait(0.03) do
        if _G.AutoFish and not _G.Busy then
            _G.Busy = true

            for name,data in pairs(FishDatabase) do
                if _G.SelectedFish[name] and CanFire() then
                    FishRemote:FireServer({
                        name = data.name,
                        rarity = data.rarity,
                        weight = data.weight
                    })
                    task.wait()
                end
            end

            if _G.AutoSell then
                pcall(function()
                    SellRemote:InvokeServer()
                end)
            end

            _G.Busy = false
        end
    end
end)

warn("✅ AUTO FISH FINAL – LOADED & READY")
