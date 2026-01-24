-- AUTO LOOP BC -> SUMMIT -> RESET CHECKPOINT (VALID)
-- MT GEMI PINK 300

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- REMOTE RESET (VALID)
local ResetRemote = ReplicatedStorage
	:WaitForChild("CheckpointRemotes")
	:WaitForChild("ResetCheckpoint")

-- POSISI
local BC_POS = Vector3.new(1242.7627, 646.5, 1794.6067)
local SUMMIT_POS = Vector3.new(-6680, 3063, -782)

-- STATE
local running = false
local delayTime = 2
local ARRIVE_RADIUS = 10
local STUCK_TIME = 3

-- GROUND SCAN
local function ground(pos)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = {}

	local r = workspace:Raycast(pos + Vector3.new(0,80,0), Vector3.new(0,-500,0), params)
	if r then
		return r.Position + Vector3.new(0,3,0)
	end
	return pos
end

-- SAFE TP (ANTI STUCK)
local function safeTP(hrp, pos)
	local target = ground(pos)
	hrp.CFrame = CFrame.new(target)

	local start = os.clock()
	while (hrp.Position - target).Magnitude > ARRIVE_RADIUS do
		if os.clock() - start > STUCK_TIME then
			hrp.CFrame = CFrame.new(target) -- paksa ulang
			start = os.clock()
		end
		task.wait(0.1)
	end
end

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AutoBCSummit_ResetRemote"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,190)
frame.Position = UDim2.new(0.5,-130,0.5,-95)
frame.BackgroundColor3 = Color3.fromRGB(28,28,28)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,32)
title.Text = "AUTO BC ⇄ SUMMIT"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 15

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.9,0,0,40)
toggle.Position = UDim2.new(0.05,0,0.25,0)
toggle.Text = "AUTO : OFF"
toggle.BackgroundColor3 = Color3.fromRGB(180,60,60)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,10)

local delayBox = Instance.new("TextBox", frame)
delayBox.Size = UDim2.new(0.9,0,0,34)
delayBox.Position = UDim2.new(0.05,0,0.6,0)
delayBox.Text = "Delay (1-10) : 2"
delayBox.ClearTextOnFocus = false
delayBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
delayBox.TextColor3 = Color3.new(1,1,1)
delayBox.Font = Enum.Font.Gotham
delayBox.TextSize = 13
Instance.new("UICorner", delayBox).CornerRadius = UDim.new(0,8)

-- INPUT
delayBox.FocusLost:Connect(function()
	local n = tonumber(delayBox.Text:match("%d+"))
	if n then
		delayTime = math.clamp(n,1,10)
		delayBox.Text = "Delay (1-10) : "..delayTime
	end
end)

toggle.MouseButton1Click:Connect(function()
	running = not running
	toggle.Text = running and "AUTO : ON" or "AUTO : OFF"
	toggle.BackgroundColor3 = running
		and Color3.fromRGB(60,200,60)
		or Color3.fromRGB(180,60,60)
end)

-- LOOP UTAMA
task.spawn(function()
	while true do
		if running then
			local char = player.Character or player.CharacterAdded:Wait()
			local hrp = char:WaitForChild("HumanoidRootPart")

			-- 1️⃣ KE BC
			safeTP(hrp, BC_POS)
			task.wait(delayTime)

			-- 2️⃣ KE SUMMIT
			safeTP(hrp, SUMMIT_POS)
			task.wait(delayTime)

			-- 3️⃣ RESET VIA REMOTE (VALID)
			ResetRemote:FireServer()
			task.wait(delayTime)
		end
		task.wait(0.2)
	end
end)