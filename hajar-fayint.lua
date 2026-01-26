-- FULL AUTO FISHING GUI + MANUAL DELAY INPUT + ICON FIX
-- By cihuy y 😎

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- ===== CONFIG DEFAULT =====
local OFFSET = 2
local MIN_DELAY = 4
local MAX_DELAY = 6

-- ===== FUNCTIONS =====
local function getRandomOffset()
	return Vector3.new(math.random(-OFFSET*10, OFFSET*10)/10, 0, math.random(-OFFSET*10, OFFSET*10)/10)
end

local function getRandomAngle()
	return math.random(80,100) + math.random(0,99999)/100000
end

local function getRandomDelay()
	return math.random(MIN_DELAY*1000, MAX_DELAY*1000)/1000
end

local function castFish()
	local offset = getRandomOffset()
	RS.FishingSystem.ReplicateVFX:FireServer("StateUpdate", "Casting")

	local castPos = Vector3.new(724.4649658203125, -21.669673919677734, 343.4998474121094) + offset
	local castRot = Vector3.new(28.607955932617188, 112.44473266601562, 0)
	local rodName = "Blue Katana"
	local angle = getRandomAngle()
	local lurePos = Vector3.new(758.7944946289062, -27.999996185302734, 343.4998474121094) + offset
	local baitName = "Starter Bait"

	RS.FishingSystem.CastReplication:FireServer(castPos, castRot, rodName, angle, lurePos, baitName)
	RS.FishingSystem.RequestFishRoll:InvokeServer(castPos)
	return offset
end

local function reelFish(offset)
	RS.FishingSystem.ReplicateVFX:FireServer("StateUpdate", "Reeling")
	RS.FishingSystem.GameSystem_Click:FireServer()
	RS.FishingSystem.ReplicateVFX:FireServer("Blue Katana Dive", Vector3.new(755.354736328125, -27.899999618530273, 346.0526123046875) + offset)
	RS.FishingSystem.ReplicateVFX:FireServer("LootOrb", Vector3.new(755.6141357421875, -27.899999618530273, 343.4998474121094) + offset, "Uncommon")
	RS.FishingSystem.CleanupCast:FireServer()
end

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFishGUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 140)
Frame.Position = UDim2.new(0.5, -110, 0.5, -70)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Frame.BorderColor3 = Color3.fromRGB(0,0,0)
Frame.BorderSizePixel = 2
Frame.Parent = ScreenGui
Frame.ClipsDescendants = true

local Shadow = Instance.new("UIStroke")
Shadow.Parent = Frame
Shadow.Color = Color3.fromRGB(0,0,0)
Shadow.Thickness = 2
Shadow.Transparency = 0.5

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,25)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "🎣 Auto Fishing"
Title.TextColor3 = Color3.fromRGB(200,200,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Frame

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.Position = UDim2.new(1, -26, 0, 1)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
MinBtn.BorderSizePixel = 0
MinBtn.Parent = Frame

local Icon = Instance.new("TextButton")
Icon.Size = UDim2.new(0, 40, 0, 25)
Icon.Position = UDim2.new(0.5, -20, 0.5, -12)
Icon.Text = "🎣"
Icon.TextColor3 = Color3.fromRGB(255,255,255)
Icon.BackgroundColor3 = Color3.fromRGB(50,50,50)
Icon.BorderSizePixel = 0
Icon.Visible = false
Icon.Parent = ScreenGui

local AutoBtn = Instance.new("TextButton")
AutoBtn.Size = UDim2.new(1, -28, 0, 40)
AutoBtn.Position = UDim2.new(0, 2, 0, 30)
AutoBtn.Text = "Auto Fish: OFF"
AutoBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoBtn.Font = Enum.Font.GothamBold
AutoBtn.TextSize = 16
AutoBtn.BackgroundColor3 = Color3.fromRGB(80,80,120)
AutoBtn.BorderSizePixel = 0
AutoBtn.Parent = Frame

-- ===== MANUAL DELAY INPUT =====
local MinLabel = Instance.new("TextLabel")
MinLabel.Size = UDim2.new(0, 100, 0, 20)
MinLabel.Position = UDim2.new(0, 10, 0, 75)
MinLabel.Text = "Min Delay:"
MinLabel.TextColor3 = Color3.fromRGB(200,200,255)
MinLabel.BackgroundTransparency = 1
MinLabel.Font = Enum.Font.Gotham
MinLabel.TextSize = 14
MinLabel.Parent = Frame

local MinInput = Instance.new("TextBox")
MinInput.Size = UDim2.new(0, 50, 0, 20)
MinInput.Position = UDim2.new(0, 110, 0, 75)
MinInput.Text = tostring(MIN_DELAY)
MinInput.TextColor3 = Color3.fromRGB(255,255,255)
MinInput.BackgroundColor3 = Color3.fromRGB(60,60,80)
MinInput.Font = Enum.Font.Gotham
MinInput.TextSize = 14
MinInput.ClearTextOnFocus = false
MinInput.Parent = Frame

local MaxLabel = Instance.new("TextLabel")
MaxLabel.Size = UDim2.new(0, 100, 0, 20)
MaxLabel.Position = UDim2.new(0, 10, 0, 100)
MaxLabel.Text = "Max Delay:"
MaxLabel.TextColor3 = Color3.fromRGB(200,200,255)
MaxLabel.BackgroundTransparency = 1
MaxLabel.Font = Enum.Font.Gotham
MaxLabel.TextSize = 14
MaxLabel.Parent = Frame

local MaxInput = Instance.new("TextBox")
MaxInput.Size = UDim2.new(0, 50, 0, 20)
MaxInput.Position = UDim2.new(0, 110, 0, 100)
MaxInput.Text = tostring(MAX_DELAY)
MaxInput.TextColor3 = Color3.fromRGB(255,255,255)
MaxInput.BackgroundColor3 = Color3.fromRGB(60,60,80)
MaxInput.Font = Enum.Font.Gotham
MaxInput.TextSize = 14
MaxInput.ClearTextOnFocus = false
MaxInput.Parent = Frame

local function updateDelays()
	local minVal = tonumber(MinInput.Text)
	local maxVal = tonumber(MaxInput.Text)
	if minVal and maxVal and minVal <= maxVal then
		MIN_DELAY = minVal
		MAX_DELAY = maxVal
	end
end

MinInput.FocusLost:Connect(updateDelays)
MaxInput.FocusLost:Connect(updateDelays)

-- ===== DRAG LOGIC (FRAME & ICON) =====
local function makeDraggable(frame)
	local dragging = false
	local dragInput, mousePos, framePos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	RunService.RenderStepped:Connect(function()
		if dragging and dragInput then
			local delta = dragInput.Position - mousePos
			frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X,
										framePos.Y.Scale, framePos.Y.Offset + delta.Y)
		end
	end)
end

makeDraggable(Title)
makeDraggable(Icon)

-- ===== MINIMIZE LOGIC FIX =====
local Minimized = false
MinBtn.MouseButton1Click:Connect(function()
	Minimized = not Minimized
	Frame.Visible = not Minimized
	if Minimized then
		-- letakkan icon di dekat posisi frame
		Icon.Position = Frame.Position + UDim2.new(0, Frame.Size.X.Offset/2 - 20, 0, Frame.Size.Y.Offset/2 - 12)
	end
	Icon.Visible = Minimized
end)

Icon.MouseButton1Click:Connect(function()
	Minimized = false
	Frame.Visible = true
	Icon.Visible = false
end)

-- ===== AUTO FISH LOGIC =====
local AutoFishing = false
AutoBtn.MouseButton1Click:Connect(function()
	AutoFishing = not AutoFishing
	AutoBtn.Text = AutoFishing and "Auto Fish: ON" or "Auto Fish: OFF"
	RS.FishingSystem.ToggleAutoFishing:FireServer(AutoFishing)
	RS.FishingSystem.GameSystem_ToggleAuto:FireServer(AutoFishing)
end)

-- ===== AUTO LOOP =====
spawn(function()
	while true do
		RunService.Heartbeat:Wait()
		if AutoFishing then
			local offset = castFish()
			wait(getRandomDelay())
			reelFish(offset)
		else
			wait(0.5)
		end
	end
end)