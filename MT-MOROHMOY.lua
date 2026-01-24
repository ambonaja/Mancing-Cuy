--==================================================
-- AUTO TP MT MOROHMOY - CP → SUMMIT → RESET BC
-- GUI + MINIMIZE + INPUT DELAY
--==================================================

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

lp.CharacterAdded:Connect(function(c)
	char = c
	hrp = c:WaitForChild("HumanoidRootPart")
	hum = c:WaitForChild("Humanoid")
end)

--================= DATA =================
local CP = {
	Vector3.new(-741,100,-832),
	Vector3.new(-210,100,-869),
	Vector3.new(220,248,-528),
	Vector3.new(278,249,139),
	Vector3.new(73,348,838),
	Vector3.new(-361,352,1363),
	Vector3.new(-835,176,758),
	Vector3.new(-966,352,885),
	Vector3.new(-1501,320,1090),
	Vector3.new(-2376,320,1326),
	Vector3.new(-2776,154,663),
	Vector3.new(-2647,292,-362),
	Vector3.new(-2954,588,-1155),
	Vector3.new(-4014,596,-1208),
	Vector3.new(-4921,696,-1457),
	Vector3.new(-5891,688,-1684),
	Vector3.new(-7036,724,-1680),
	Vector3.new(-7791,728,-1119),
	Vector3.new(-8041,880,-1323),
	Vector3.new(-8382,880,-1837),
	Vector3.new(-8142,880,-2896),
	Vector3.new(-8361,884,-3770),
	Vector3.new(-8735,908,-4405),
	Vector3.new(-9129,996,-4899),
	Vector3.new(-9662,1004,-5515),
	Vector3.new(-10241,1176,-5521),
	Vector3.new(-11460,1180,-5456),
	Vector3.new(-12185,1240,-5950),
	Vector3.new(-12540,1224,-6444),
	Vector3.new(-12795,1296,-6286),
	Vector3.new(-13973,1296,-6430),
	Vector3.new(-14017,1296,-7277),
	Vector3.new(-14184,1472,-7650),
	Vector3.new(-14092,1472,-8489),
	Vector3.new(-14068,1472,-9109),
	Vector3.new(-13968,1452,-9980),
	Vector3.new(-13388,1660,-10433),
	Vector3.new(-12894,1784,-10503),
	Vector3.new(-12099,1784,-10623),
	Vector3.new(-11390,1784,-10741),
}

local SUMMIT = Vector3.new(-10826,2060,-12292)
local BC = Vector3.new(-922,100,-815)

--================= STATE =================
local running = false
local delayTP = 1

--================= GUI =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MOROHMOY_GUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(260,220)
main.Position = UDim2.fromScale(0.02,0.3)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active, main.Draggable = true, true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,35)
title.Text = "MT MOROHMOY AUTO TP"
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

local delayBox = Instance.new("TextBox", main)
delayBox.PlaceholderText = "Delay (1-10)"
delayBox.Position = UDim2.fromOffset(20,50)
delayBox.Size = UDim2.fromOffset(220,30)
delayBox.Text = "1"
delayBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
delayBox.TextColor3 = Color3.new(1,1,1)

local startBtn = Instance.new("TextButton", main)
startBtn.Position = UDim2.fromOffset(20,95)
startBtn.Size = UDim2.fromOffset(220,35)
startBtn.Text = "START AUTO TP"
startBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
startBtn.TextColor3 = Color3.new(1,1,1)

local stopBtn = Instance.new("TextButton", main)
stopBtn.Position = UDim2.fromOffset(20,140)
stopBtn.Size = UDim2.fromOffset(220,35)
stopBtn.Text = "STOP"
stopBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
stopBtn.TextColor3 = Color3.new(1,1,1)

local mini = Instance.new("TextButton", gui)
mini.Text = "MT"
mini.Size = UDim2.fromOffset(50,50)
mini.Position = UDim2.fromScale(0.02,0.3)
mini.Visible = false
mini.BackgroundColor3 = Color3.fromRGB(0,0,0)
mini.TextColor3 = Color3.new(1,1,1)

title.InputBegan:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.RightShift then
		main.Visible = false
		mini.Visible = true
	end
end)

mini.MouseButton1Click:Connect(function()
	main.Visible = true
	mini.Visible = false
end)

--================= FUNCTION =================
local function tp(pos)
	if hrp then
		hrp.CFrame = CFrame.new(pos)
	end
end

local function loopTP()
	while running do
		for _,v in ipairs(CP) do
			if not running then return end
			tp(v)
			task.wait(delayTP)
		end

		tp(SUMMIT)
		task.wait(2)

		-- RESET CHARACTER → BC
		hum.Health = 0
		task.wait(5)
		tp(BC)
	end
end

--================= BUTTON =================
startBtn.MouseButton1Click:Connect(function()
	local d = tonumber(delayBox.Text)
	if d and d >= 1 and d <= 10 then
		delayTP = d
	end
	if not running then
		running = true
		task.spawn(loopTP)
	end
end)

stopBtn.MouseButton1Click:Connect(function()
	running = false
end)