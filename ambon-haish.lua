-- SERVICES
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer

local FishGiver = RS:WaitForChild("FishingSystem"):WaitForChild("FishGiver")
local SellRemote = RS:WaitForChild("FishingSystem")
	:WaitForChild("InventoryEvents")
	:WaitForChild("Inventory_SellAll")

-- STATE
local AutoFarm = false
local AutoSell = false
local GodMode = false -- false = SAFE, true = GOD

local SafeDelay = 3
local MinDelay = 1
local MaxDelay = 10
local SellDelay = 5

-- DATA IKAN (UPDATED)
local FishArgs = {
	{
		hookPosition = Vector3.new(2075.2829, 450.6968, 182.4050),
		name = "El Maja",
		rarity = "Secret",
		weight = 90000000
	}
}

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AutoFishGUI"
gui.ResetOnSpawn = false
gui.Parent = Player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.32, 0.38)
frame.Position = UDim2.fromScale(0.34, 0.3)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- TITLE (DRAG)
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.15)
title.BackgroundTransparency = 1
title.Text = "AUTO FISH"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local function button(text, pos)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.9, 0.14)
	b.Position = pos
	b.Text = text
	b.TextScaled = true
	b.Font = Enum.Font.Gotham
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	return b
end

local farmBtn = button("AUTO FARM : OFF", UDim2.fromScale(0.05,0.18))
local sellBtn = button("AUTO SELL : OFF", UDim2.fromScale(0.05,0.34))
local modeBtn = button("MODE : SAFE",     UDim2.fromScale(0.05,0.5))

-- SLIDER
local sliderFrame = Instance.new("Frame", frame)
sliderFrame.Size = UDim2.fromScale(0.9, 0.18)
sliderFrame.Position = UDim2.fromScale(0.05,0.68)
sliderFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0,8)

local sliderLabel = Instance.new("TextLabel", sliderFrame)
sliderLabel.Size = UDim2.fromScale(1,0.4)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "SAFE DELAY : 3s"
sliderLabel.TextColor3 = Color3.new(1,1,1)
sliderLabel.TextScaled = true
sliderLabel.Font = Enum.Font.Gotham

local bar = Instance.new("Frame", sliderFrame)
bar.Size = UDim2.fromScale(1,0.25)
bar.Position = UDim2.fromScale(0,0.6)
bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", bar).CornerRadius = UDim.new(0,6)

local fill = Instance.new("Frame", bar)
fill.Size = UDim2.fromScale((SafeDelay-MinDelay)/(MaxDelay-MinDelay),1)
fill.BackgroundColor3 = Color3.fromRGB(0,170,255)
Instance.new("UICorner", fill).CornerRadius = UDim.new(0,6)

-- BUTTON LOGIC
farmBtn.MouseButton1Click:Connect(function()
	AutoFarm = not AutoFarm
	farmBtn.Text = AutoFarm and "AUTO FARM : ON" or "AUTO FARM : OFF"
end)

sellBtn.MouseButton1Click:Connect(function()
	AutoSell = not AutoSell
	sellBtn.Text = AutoSell and "AUTO SELL : ON" or "AUTO SELL : OFF"
end)

modeBtn.MouseButton1Click:Connect(function()
	GodMode = not GodMode
	modeBtn.Text = GodMode and "MODE : GOD" or "MODE : SAFE"
end)

-- SLIDER LOGIC
local draggingSlider = false
bar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = true
	end
end)
bar.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = false
	end
end)

UIS.InputChanged:Connect(function(i)
	if draggingSlider and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		local p = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
		fill.Size = UDim2.fromScale(p,1)
		SafeDelay = math.floor(MinDelay + (MaxDelay-MinDelay)*p)
		sliderLabel.Text = "SAFE DELAY : "..SafeDelay.."s"
	end
end)

-- DRAG GUI
local dragging, dragStart, startPos = false
title.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = i.Position
		startPos = frame.Position
		i.Changed:Connect(function()
			if i.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		local d = i.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)

-- AUTO FARM LOOP
task.spawn(function()
	while true do
		if AutoFarm then
			pcall(function()
				FishGiver:FireServer(unpack(FishArgs))
			end)
			task.wait(GodMode and 0 or SafeDelay)
		else
			task.wait(0.3)
		end
	end
end)

-- AUTO SELL LOOP
task.spawn(function()
	while true do
		if AutoSell then
			pcall(function()
				SellRemote:InvokeServer()
			end)
			task.wait(SellDelay)
		else
			task.wait(0.5)
		end
	end
end)