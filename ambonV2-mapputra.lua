--========================================
-- AUTO FISH SYSTEM FINAL (FULL FIX)
-- AUTO SPAM + MINIMIZE + FLOAT ICON
--========================================

--============== SERVICES =================
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

--============== REMOTES ==================
local FS = RS:WaitForChild("FishingSystem")
local Cast = FS:WaitForChild("CastReplication")
local Give = FS:WaitForChild("KasihIkanItu")
local Catch = RS:WaitForChild("FishingCatchSuccess")
local Valid = RS:WaitForChild("ShowValidasi")
local Rarity = RS:WaitForChild("ShowRarityExclamation")
local StatusUmpan = RS:WaitForChild("StatusLemparUmpan1")

--============== STATE ====================
local autoFish = false
local autoSpam = true
local delayTime = 0.15
local timer = 0
local selectedFish = {}
local spamCooldown = false

--============== DATA IKAN =================
local fishData = {
	{ name="King Monster", pos=Vector3.new(2527,141,-819) },
	{ name="Hammer Shark", pos=Vector3.new(-1874,144,2355) },
	{ name="Jellyfish Core", pos=Vector3.new(-1874,144,2355) },
	{ name="Amber", pos=Vector3.new(-1162,160,-615) },
	{ name="Voyage", pos=Vector3.new(-1162,160,-615) },
	{ name="Puas Corda", pos=Vector3.new(1562,150,-3022) },
	{ name="Ciyup Carber", pos=Vector3.new(1439,209,-2509) },
	{ name="Megalodon Core", pos=Vector3.new(1439,209,-2509) },
	{ name="Kuzjuy Shark", pos=Vector3.new(710,134,1573) },
	{ name="Cindera Fish", pos=Vector3.new(710,134,1573) },
	{ name="Doplin Pink", pos=Vector3.new(710,134,1573) },
	{ name="Doplin Blue", pos=Vector3.new(710,134,1573) },
	{ name="Cype Darcoyellow", pos=Vector3.new(710,134,1573) },
	{ name="Cype Darcopink", pos=Vector3.new(710,134,1573) },
	{ name="Joar Cusyu", pos=Vector3.new(710,134,1573) },
	{ name="Whale Shark", pos=Vector3.new(846,145,-657) },
}

--============== GUI ======================
local gui = Instance.new("ScreenGui", lp.PlayerGui)
gui.Name = "AutoFish_System"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(320,360)
main.Position = UDim2.new(0.35,0,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

--============== TITLE ====================
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,-40,0,32)
title.Position = UDim2.new(0,10,0,6)
title.Text = "AUTO FISH SYSTEM"
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.fromOffset(26,26)
minimize.Position = UDim2.new(1,-32,0,6)
minimize.Text = "–"
minimize.TextScaled = true
minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
minimize.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minimize)

--============== TABS =====================
local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(1,-20,0,30)
tabFrame.Position = UDim2.new(0,10,0,44)
tabFrame.BackgroundTransparency = 1

local farmTab = Instance.new("TextButton", tabFrame)
farmTab.Size = UDim2.new(0.5,-4,1,0)
farmTab.Text = "SYSTEM"
farmTab.TextScaled = true
farmTab.BackgroundColor3 = Color3.fromRGB(40,120,40)
farmTab.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", farmTab)

local fishTab = farmTab:Clone()
fishTab.Parent = tabFrame
fishTab.Position = UDim2.new(0.5,4,0,0)
fishTab.Text = "FISH"
fishTab.BackgroundColor3 = Color3.fromRGB(40,40,40)

--============== PAGES ====================
local pages = Instance.new("Frame", main)
pages.Size = UDim2.new(1,-20,1,-90)
pages.Position = UDim2.new(0,10,0,82)
pages.BackgroundTransparency = 1

local farmPage = Instance.new("Frame", pages)
farmPage.Size = UDim2.fromScale(1,1)
farmPage.BackgroundTransparency = 1

local fishPage = Instance.new("Frame", pages)
fishPage.Size = UDim2.fromScale(1,1)
fishPage.Visible = false
fishPage.BackgroundTransparency = 1

--============== SYSTEM PAGE ==============
local autoBtn = Instance.new("TextButton", farmPage)
autoBtn.Size = UDim2.new(1,0,0,32)
autoBtn.Text = "AUTO FISH : OFF"
autoBtn.TextScaled = true
autoBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
autoBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", autoBtn)

autoBtn.MouseButton1Click:Connect(function()
	autoFish = not autoFish
	timer = 0
	autoBtn.Text = "AUTO FISH : "..(autoFish and "ON" or "OFF")
	autoBtn.BackgroundColor3 = autoFish and Color3.fromRGB(40,120,40) or Color3.fromRGB(120,40,40)
end)

local spamBtn = Instance.new("TextButton", farmPage)
spamBtn.Size = UDim2.new(1,0,0,32)
spamBtn.Position = UDim2.new(0,0,0,40)
spamBtn.Text = "AUTO SPAM : ON"
spamBtn.TextScaled = true
spamBtn.BackgroundColor3 = Color3.fromRGB(40,120,40)
spamBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", spamBtn)

spamBtn.MouseButton1Click:Connect(function()
	autoSpam = not autoSpam
	spamBtn.Text = "AUTO SPAM : "..(autoSpam and "ON" or "OFF")
	spamBtn.BackgroundColor3 = autoSpam and Color3.fromRGB(40,120,40) or Color3.fromRGB(120,40,40)
end)

local delayBox = Instance.new("TextBox", farmPage)
delayBox.Size = UDim2.new(1,0,0,28)
delayBox.Position = UDim2.new(0,0,0,80)
delayBox.Text = tostring(delayTime)
delayBox.TextScaled = true
delayBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
delayBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", delayBox)

delayBox.FocusLost:Connect(function()
	local v = tonumber(delayBox.Text)
	if v then
		delayTime = math.clamp(v,0.05,5)
		delayBox.Text = tostring(delayTime)
	end
end)

local countdown = Instance.new("TextLabel", farmPage)
countdown.Size = UDim2.new(1,0,0,24)
countdown.Position = UDim2.new(0,0,0,114)
countdown.Text = "NEXT : -"
countdown.TextScaled = true
countdown.TextColor3 = Color3.new(1,1,1)
countdown.BackgroundTransparency = 1

--============== FISH PAGE =================
local scroll = Instance.new("ScrollingFrame", fishPage)
scroll.Size = UDim2.fromScale(1,1)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0

local grid = Instance.new("UIGridLayout", scroll)
grid.CellPadding = UDim2.fromOffset(6,6)
grid.CellSize = UDim2.fromOffset(95,32)

grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,grid.AbsoluteContentSize.Y + 6)
end)

for _,f in ipairs(fishData) do
	local b = Instance.new("TextButton", scroll)
	b.Text = f.name
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)

	b.MouseButton1Click:Connect(function()
		if selectedFish[f.name] then
			selectedFish[f.name] = nil
			b.BackgroundColor3 = Color3.fromRGB(35,35,35)
		else
			selectedFish[f.name] = f
			b.BackgroundColor3 = Color3.fromRGB(40,120,40)
		end
	end)
end

farmTab.MouseButton1Click:Connect(function()
	farmPage.Visible = true
	fishPage.Visible = false
end)

fishTab.MouseButton1Click:Connect(function()
	farmPage.Visible = false
	fishPage.Visible = true
end)

--============== FLOAT ICON =================
local floatBtn = Instance.new("TextButton", gui)
floatBtn.Size = UDim2.fromOffset(44,44)
floatBtn.Position = UDim2.fromScale(0.05,0.5)
floatBtn.Text = "🎣"
floatBtn.TextScaled = true
floatBtn.Visible = false
floatBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
floatBtn.TextColor3 = Color3.new(1,1,1)
floatBtn.Active = true
floatBtn.Draggable = true
floatBtn.ZIndex = 999
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1,0)

minimize.MouseButton1Click:Connect(function()
	main.Visible = false
	floatBtn.Visible = true
end)

floatBtn.MouseButton1Click:Connect(function()
	main.Visible = true
	floatBtn.Visible = false
end)

--============== AUTO SPAM FUNCTION =======
local function spamPulse()
	if spamCooldown then return end
	spamCooldown = true
	autoFish = false
	task.wait(0.03)
	autoFish = true
	task.delay(0.05,function()
		spamCooldown = false
	end)
end

--============== CORE LOOP ================
RunService.Heartbeat:Connect(function(dt)
	if not autoFish then
		timer = 0
		countdown.Text = "NEXT : -"
		return
	end

	timer += dt
	countdown.Text = string.format("NEXT : %.2fs", math.max(delayTime - timer,0))
	if timer < delayTime then return end
	timer = 0

	if autoSpam then
		spamPulse()
	end

	for _,f in pairs(selectedFish) do
		StatusUmpan:FireServer()
		Cast:FireServer(f.pos, Vector3.new(0,5,0), "Purple Saber", math.random(90,105))
		Give:FireServer(true,{
			hookPosition = f.pos,
			name = f.name,
			rarity = "Secret",
			weight = math.random(400,650)
		})
		Catch:FireServer()
		Valid:FireServer()
		Rarity:FireServer("Secret")
		task.wait(0.02)
		Catch:FireServer()
	end
end)
