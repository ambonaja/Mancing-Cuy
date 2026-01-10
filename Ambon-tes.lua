--==================================================
-- AUTO FARM FISH FINAL (CORE FISH EDITION)
-- SAFE / BRUTAL AUTO ADAPT
-- DELAY INDICATOR + PROGRESS BAR
-- MINIMIZE + FISH ICON
--==================================================

pcall(function()
	if _G.AUTO_FISH_GUI then
		_G.AUTO_FISH_GUI:Destroy()
	end
end)

--================ SERVICES =================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

--================ REMOTES =================
local FishingSystem = ReplicatedStorage:WaitForChild("FishingSystem",5)
local FishGiver = FishingSystem:FindFirstChild("FishGiver")
local CatchEvent = FishingSystem:FindFirstChild("tangkapikanwoy")

if not FishGiver and not CatchEvent then
	warn("❌ FishGiver / tangkapikanwoy tidak ditemukan")
	return
end

--================ STATE =================
local AutoFarm = false
local Mode = "SAFE"
local Minimized = false

local DELAY_SAFE = 1.6

local BRUTAL_DELAY_MIN = 0.08
local BRUTAL_DELAY_MAX = 0.30
local BRUTAL_DELAY = 0.12

--================ CORE FISH DATA =================
local CoreFishList = {
	"Ciyup Carber",
	"Megalodon Core",
	"Hammer Shark",
	"Jellyfish Core",
	"Amber",
	"Voyage",
	"King Monster",
	"Paus Corda",
	"Kuzjuy Shark",
	"Cindera Fish"
}

local CoreIndex = 1

--================ GUI =================
local gui = Instance.new("ScreenGui", Player.PlayerGui)
gui.Name = "AUTO_FISH_GUI"
gui.ResetOnSpawn = false
_G.AUTO_FISH_GUI = gui

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,420,0,210)
main.Position = UDim2.new(0.5,-210,0.7,0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,-50,0,40)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "🐋 AUTO FARM FISH (CORE)"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left

local miniBtn = Instance.new("TextButton", main)
miniBtn.Size = UDim2.new(0,36,0,36)
miniBtn.Position = UDim2.new(1,-40,0,2)
miniBtn.Text = "🐟"
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 20
miniBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
miniBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1,0)

local toggleFarm = Instance.new("TextButton", main)
toggleFarm.Size = UDim2.new(0,260,0,40)
toggleFarm.Position = UDim2.new(0.5,-130,0,55)
toggleFarm.Text = "AUTO FARM : OFF"
toggleFarm.Font = Enum.Font.GothamBold
toggleFarm.TextSize = 15
toggleFarm.BackgroundColor3 = Color3.fromRGB(120,40,40)
toggleFarm.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggleFarm).CornerRadius = UDim.new(0,10)

local toggleMode = Instance.new("TextButton", main)
toggleMode.Size = UDim2.new(0,260,0,40)
toggleMode.Position = UDim2.new(0.5,-130,0,105)
toggleMode.Text = "MODE : SAFE"
toggleMode.Font = Enum.Font.GothamBold
toggleMode.TextSize = 15
toggleMode.BackgroundColor3 = Color3.fromRGB(40,90,140)
toggleMode.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggleMode).CornerRadius = UDim.new(0,10)

local delayLabel = Instance.new("TextLabel", main)
delayLabel.Size = UDim2.new(0,260,0,24)
delayLabel.Position = UDim2.new(0.5,-130,0,150)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "BRUTAL DELAY : --"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 13
delayLabel.TextColor3 = Color3.fromRGB(180,180,180)

local barBG = Instance.new("Frame", main)
barBG.Size = UDim2.new(0,260,0,10)
barBG.Position = UDim2.new(0.5,-130,0,178)
barBG.BackgroundColor3 = Color3.fromRGB(45,45,45)
barBG.BorderSizePixel = 0
Instance.new("UICorner", barBG).CornerRadius = UDim.new(1,0)

local barFill = Instance.new("Frame", barBG)
barFill.Size = UDim2.new(0,0,1,0)
barFill.BackgroundColor3 = Color3.fromRGB(60,220,120)
barFill.BorderSizePixel = 0
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1,0)

local miniIcon = Instance.new("TextButton", gui)
miniIcon.Size = UDim2.new(0,52,0,52)
miniIcon.Position = UDim2.new(0,15,0.6,0)
miniIcon.Text = "🐟"
miniIcon.Font = Enum.Font.GothamBold
miniIcon.TextSize = 26
miniIcon.BackgroundColor3 = Color3.fromRGB(30,30,30)
miniIcon.TextColor3 = Color3.new(1,1,1)
miniIcon.Visible = false
miniIcon.Active = true
miniIcon.Draggable = true
Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(1,0)

--================ UI UPDATE =================
local function UpdateDelayUI()
	if Mode ~= "BRUTAL" then
		delayLabel.Text = "BRUTAL DELAY : --"
		barFill.Size = UDim2.new(0,0,1,0)
		delayLabel.TextColor3 = Color3.fromRGB(180,180,180)
		return
	end

	delayLabel.Text = string.format("BRUTAL DELAY : %.2fs", BRUTAL_DELAY)

	local progress = math.clamp(
		(BRUTAL_DELAY - BRUTAL_DELAY_MIN) /
		(BRUTAL_DELAY_MAX - BRUTAL_DELAY_MIN),
		0,1
	)

	barFill.Size = UDim2.new(progress,0,1,0)

	if BRUTAL_DELAY <= 0.10 then
		delayLabel.TextColor3 = Color3.fromRGB(60,220,120)
		barFill.BackgroundColor3 = Color3.fromRGB(60,220,120)
	elseif BRUTAL_DELAY <= 0.18 then
		delayLabel.TextColor3 = Color3.fromRGB(230,200,80)
		barFill.BackgroundColor3 = Color3.fromRGB(230,200,80)
	else
		delayLabel.TextColor3 = Color3.fromRGB(230,80,80)
		barFill.BackgroundColor3 = Color3.fromRGB(230,80,80)
	end
end

--================ CORE =================
local function FireFish()
	local fishName = CoreFishList[CoreIndex]
	local rarity = "Secret"
	local weight = 600
	local success = true

	CoreIndex += 1
	if CoreIndex > #CoreFishList then
		CoreIndex = 1
	end

	local function fireOnce()
		if FishGiver then
			if not pcall(function()
				FishGiver:FireServer(true,{
					hookPosition = Vector3.new(718.526,128.15,-823.64),
					name = fishName,
					rarity = rarity,
					weight = weight
				})
			end) then success = false end
		end

		if CatchEvent then
			if not pcall(function()
				CatchEvent:FireServer(fishName, weight, rarity)
			end) then success = false end
		end
	end

	if Mode == "SAFE" then
		fireOnce()
	else
		fireOnce()
		fireOnce()

		if success then
			BRUTAL_DELAY = math.max(BRUTAL_DELAY - 0.01, BRUTAL_DELAY_MIN)
		else
			BRUTAL_DELAY = math.min(BRUTAL_DELAY + 0.03, BRUTAL_DELAY_MAX)
		end
	end

	UpdateDelayUI()
end

--================ LOOP =================
task.spawn(function()
	while true do
		if AutoFarm then
			pcall(FireFish)
			task.wait(Mode == "SAFE" and DELAY_SAFE or BRUTAL_DELAY)
		else
			task.wait(0.3)
		end
	end
end)

--================ BUTTONS =================
toggleFarm.MouseButton1Click:Connect(function()
	AutoFarm = not AutoFarm
	toggleFarm.Text = AutoFarm and "AUTO FARM : ON" or "AUTO FARM : OFF"
	toggleFarm.BackgroundColor3 = AutoFarm and Color3.fromRGB(40,140,60) or Color3.fromRGB(120,40,40)
end)

toggleMode.MouseButton1Click:Connect(function()
	Mode = (Mode == "SAFE") and "BRUTAL" or "SAFE"
	toggleMode.Text = "MODE : "..Mode
	toggleMode.BackgroundColor3 = (Mode=="SAFE")
		and Color3.fromRGB(40,90,140)
		or Color3.fromRGB(150,60,60)
	UpdateDelayUI()
end)

miniBtn.MouseButton1Click:Connect(function()
	Minimized = not Minimized
	main.Visible = not Minimized
	miniIcon.Visible = Minimized
end)

miniIcon.MouseButton1Click:Connect(function()
	Minimized = false
	main.Visible = true
	miniIcon.Visible = false
end)

print("✅ AUTO FARM FISH CORE FINAL READY")