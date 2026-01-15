--==================================================
-- AUTO FARM FISH | FINAL FIX UI + COUNTDOWN (1.0s)
--==================================================

--// SERVICES
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

--// REMOTE
local FishGiver = RS:WaitForChild("FishingSystem"):WaitForChild("FishGivers1")

--// STATE
local autofarm = false
local delayFarm = 1.0

--==================================================
-- FISH LIST
--==================================================
local FishList = {
	"Ciyup Carber","Megalodon Core","Hammer Shark","Jellyfish core",
	"Amber","Voyage","King Monster","Puas Corda","Kuzjuy Shark","Cindera Fish",
	"Doplin Pink","Doplin Blue",
	"Cype Darcoyellow","Cype Darcopink",
	"Joar Cusyu","Mas Fish","Roster Fishs"
}

--==================================================
-- RARITY + WEIGHT
--==================================================
local FishRarity = {
	["Mas Fish"] = "Common",
	["Roster Fishs"] = "Legendary"
}

local WeightByRarity = {
	Common = {25,30},
	Legendary = {50,65},
	Secret = {600,700}
}

local function getWeight(r)
	local w = WeightByRarity[r] or WeightByRarity.Secret
	return math.random(w[1], w[2])
end

--==================================================
-- COORD (COMMON + LEGENDARY = MEGALODON)
--==================================================
local MEGA_POS = Vector3.new(1439,209,-2509)

local FishCoords = {
	["Megalodon Core"] = MEGA_POS,
	["Ciyup Carber"] = MEGA_POS,
	["Mas Fish"] = MEGA_POS,
	["Roster Fishs"] = MEGA_POS
}

local function getHookPos(fish)
	local char = lp.Character
	if FishCoords[fish] then
		return FishCoords[fish]
	end
	if char and char:FindFirstChild("HumanoidRootPart") then
		return char.HumanoidRootPart.Position
	end
end

--==================================================
-- SELECT SYSTEM
--==================================================
local SelectedFish = {}
for _,v in ipairs(FishList) do
	SelectedFish[v] = false
end

local function getRandomFish()
	local pool = {}
	for k,v in pairs(SelectedFish) do
		if v then table.insert(pool, k) end
	end
	return #pool > 0 and pool[math.random(#pool)] or nil
end

--==================================================
-- GUI
--==================================================
pcall(function() game.CoreGui.AutoFarmGUI:Destroy() end)

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AutoFarmGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(320,300)
frame.Position = UDim2.new(0.5,-160,0.5,-150)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.ZIndex = 10
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

-- FLOATING ICON
local floating = Instance.new("TextButton", gui)
floating.Size = UDim2.fromOffset(40,40)
floating.Position = UDim2.new(1,-55,0.5,-20)
floating.Text = "🎣"
floating.TextSize = 20
floating.BackgroundColor3 = Color3.fromRGB(40,40,40)
floating.TextColor3 = Color3.new(1,1,1)
floating.Visible = false
floating.ZIndex = 60
Instance.new("UICorner", floating).CornerRadius = UDim.new(1,0)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,28)
title.Text = "AUTO FARM FISH"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.ZIndex = 11

-- MINIMIZE
local minimize = Instance.new("TextButton", frame)
minimize.Size = UDim2.fromOffset(22,22)
minimize.Position = UDim2.new(1,-26,0,3)
minimize.Text = "–"
minimize.TextSize = 16
minimize.BackgroundColor3 = Color3.fromRGB(45,45,45)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.ZIndex = 50
Instance.new("UICorner", minimize).CornerRadius = UDim.new(1,0)

-- TAB BAR
local tabBar = Instance.new("Frame", frame)
tabBar.Size = UDim2.new(1,-20,0,30)
tabBar.Position = UDim2.fromOffset(10,30)
tabBar.BackgroundTransparency = 1
tabBar.ZIndex = 11

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Padding = UDim.new(0,10)

local Pages = {}
local function createTab(name)
	local b = Instance.new("TextButton", tabBar)
	b.Size = UDim2.fromOffset(90,26)
	b.Text = name
	b.Font = Enum.Font.GothamBold
	b.TextSize = 12
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.ZIndex = 12
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	b.Activated:Connect(function()
		for _,p in pairs(Pages) do p.Visible = false end
		Pages[name].Visible = true
	end)
end

createTab("Main")
createTab("Fish")

local holder = Instance.new("Frame", frame)
holder.Size = UDim2.new(1,-20,1,-70)
holder.Position = UDim2.fromOffset(10,65)
holder.BackgroundTransparency = 1
holder.ZIndex = 11

-- MAIN PAGE
Pages.Main = Instance.new("Frame", holder)
Pages.Main.Size = UDim2.new(1,0,1,0)
Pages.Main.BackgroundTransparency = 1
Pages.Main.Visible = true
Pages.Main.ZIndex = 12

local toggle = Instance.new("TextButton", Pages.Main)
toggle.Size = UDim2.fromOffset(220,42)
toggle.Position = UDim2.fromOffset(40,25)
toggle.Text = "AUTO FARM : OFF"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.TextColor3 = Color3.new(1,1,1)
toggle.BackgroundColor3 = Color3.fromRGB(80,0,0)
toggle.ZIndex = 13
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,12)

local countdown = Instance.new("TextLabel", Pages.Main)
countdown.Size = UDim2.fromOffset(220,20)
countdown.Position = UDim2.fromOffset(40,75)
countdown.Text = "Next catch: 1.0s"
countdown.BackgroundTransparency = 1
countdown.TextColor3 = Color3.fromRGB(180,180,180)
countdown.Font = Enum.Font.Gotham
countdown.TextSize = 12
countdown.Visible = false
countdown.ZIndex = 13

toggle.Activated:Connect(function()
	autofarm = not autofarm
	toggle.Text = autofarm and "AUTO FARM : ON" or "AUTO FARM : OFF"
	toggle.BackgroundColor3 = autofarm and Color3.fromRGB(0,90,0) or Color3.fromRGB(80,0,0)
	countdown.Visible = autofarm
end)

-- FISH PAGE
Pages.Fish = Instance.new("Frame", holder)
Pages.Fish.Size = UDim2.new(1,0,1,0)
Pages.Fish.BackgroundTransparency = 1
Pages.Fish.Visible = false
Pages.Fish.ZIndex = 12

local scroll = Instance.new("ScrollingFrame", Pages.Fish)
scroll.Size = UDim2.new(1,0,1,0)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 4
scroll.BackgroundTransparency = 1
scroll.ZIndex = 13

local grid = Instance.new("UIGridLayout", scroll)
grid.CellSize = UDim2.fromOffset(135,30)
grid.CellPadding = UDim2.fromOffset(8,8)
grid.FillDirectionMaxCells = 2

grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0, grid.AbsoluteContentSize.Y + 10)
end)

for _,fish in ipairs(FishList) do
	local b = Instance.new("TextButton", scroll)
	b.Text = "☐ "..fish
	b.Font = Enum.Font.Gotham
	b.TextSize = 11
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.ZIndex = 14
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

	b.Activated:Connect(function()
		SelectedFish[fish] = not SelectedFish[fish]
		b.Text = (SelectedFish[fish] and "☑ " or "☐ ")..fish
		b.BackgroundColor3 = SelectedFish[fish]
			and Color3.fromRGB(0,80,40)
			or Color3.fromRGB(40,40,40)
	end)
end

-- DRAG
local function drag(obj)
	local dragging, startPos, startUI
	obj.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			startPos = i.Position
			startUI = obj.Position
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local d = i.Position - startPos
			obj.Position = UDim2.new(startUI.X.Scale, startUI.X.Offset + d.X, startUI.Y.Scale, startUI.Y.Offset + d.Y)
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
end

drag(frame)
drag(floating)

minimize.Activated:Connect(function()
	frame.Visible = false
	floating.Visible = true
end)
floating.Activated:Connect(function()
	frame.Visible = true
	floating.Visible = false
end)

-- AUTO FARM LOOP + COUNTDOWN
task.spawn(function()
	while true do
		if autofarm then
			local t = delayFarm
			while t > 0 and autofarm do
				countdown.Text = string.format("Next catch: %.1fs", t)
				task.wait(0.1)
				t -= 0.1
			end

			local fish = getRandomFish()
			if fish then
				local rarity = FishRarity[fish] or "Secret"
				FishGiver:FireServer(true,{
					name = fish,
					rarity = rarity,
					weight = getWeight(rarity),
					hookPosition = getHookPos(fish)
				})
			end
		end
		task.wait(0.05)
	end
end)