-- Auto Fish GUI untuk Mobile
-- oleh: [Nama Anda]

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Buat ScreenGui utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileAutoFish"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Fungsi untuk membuat button dengan style mobile-friendly
local function createMobileButton(name, text, size, position)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Text = text
	button.Size = size
	button.Position = position
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 18
	button.AutoButtonColor = true
	button.BorderSizePixel = 0
	button.ZIndex = 2
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.2, 0)
	corner.Parent = button
	
	return button
end

-- Fungsi untuk membuat frame dengan style mobile-friendly
local function createMobileFrame(name, size, position)
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Size = size
	frame.Position = position
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BorderSizePixel = 0
	frame.ZIndex = 1
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.1, 0)
	corner.Parent = frame
	
	local shadow = Instance.new("UIStroke")
	shadow.Color = Color3.fromRGB(0, 0, 0)
	shadow.Thickness = 2
	shadow.Parent = frame
	
	return frame
end

-- Main Frame (Ukuran optimal untuk mobile)
local mainFrame = createMobileFrame(
	"MainFrame",
	UDim2.new(0.8, 0, 0.4, 0), -- 80% lebar layar, 40% tinggi
	UDim2.new(0.1, 0, 0.05, 0) -- 10% dari kiri, 5% dari atas
)
mainFrame.Parent = ScreenGui

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0.15, 0)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 2
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0.1, 0)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "🐟 AUTO FISH 🐟"
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0.15, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextScaled = true
title.ZIndex = 3
title.Parent = titleBar

-- Minimize Button
local minimizeBtn = createMobileButton(
	"MinimizeBtn",
	"_",
	UDim2.new(0.1, 0, 0.8, 0),
	UDim2.new(0.02, 0, 0.1, 0)
)
minimizeBtn.TextSize = 24
minimizeBtn.Font = Enum.Font.GothamBlack
minimizeBtn.Parent = titleBar

-- Close Button (Optional)
local closeBtn = createMobileButton(
	"CloseBtn",
	"X",
	UDim2.new(0.1, 0, 0.8, 0),
	UDim2.new(0.88, 0, 0.1, 0)
)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Parent = titleBar

-- Content Area
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, 0, 0.85, 0)
contentFrame.Position = UDim2.new(0, 0, 0.15, 0)
contentFrame.BackgroundTransparency = 1
contentFrame.ZIndex = 1
contentFrame.Parent = mainFrame

-- Status Display
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Text = "Status: OFF"
statusLabel.Size = UDim2.new(0.9, 0, 0.2, 0)
statusLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
statusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 18
statusLabel.TextScaled = true
statusLabel.ZIndex = 2
statusLabel.Parent = contentFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0.1, 0)
statusCorner.Parent = statusLabel

-- Buttons Container
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Name = "ButtonsFrame"
buttonsFrame.Size = UDim2.new(0.9, 0, 0.6, 0)
buttonsFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = contentFrame

-- Start/Stop Button
local toggleBtn = createMobileButton(
	"ToggleButton",
	"▶ START AUTO FARM",
	UDim2.new(1, 0, 0.4, 0),
	UDim2.new(0, 0, 0, 0)
)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
toggleBtn.Parent = buttonsFrame

-- Stats Button
local statsBtn = createMobileButton(
	"StatsButton",
	"📊 STATS",
	UDim2.new(0.48, 0, 0.4, 0),
	UDim2.new(0, 0, 0.5, 0)
)
statsBtn.Parent = buttonsFrame

-- Settings Button
local settingsBtn = createMobileButton(
	"SettingsButton",
	"⚙ SETTINGS",
	UDim2.new(0.48, 0, 0.4, 0),
	UDim2.new(0.52, 0, 0.5, 0)
)
settingsBtn.Parent = buttonsFrame

-- Minimized Frame
local minimizedFrame = createMobileFrame(
	"MinimizedFrame",
	UDim2.new(0.3, 0, 0.08, 0),
	UDim2.new(0.35, 0, 0.01, 0)
)
minimizedFrame.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
minimizedFrame.Visible = false
minimizedFrame.Parent = ScreenGui

local minimizedTitle = Instance.new("TextButton")
minimizedTitle.Name = "MinimizedTitle"
minimizedTitle.Text = "🐟 FISH"
minimizedTitle.Size = UDim2.new(1, 0, 1, 0)
minimizedTitle.Position = UDim2.new(0, 0, 0, 0)
minimizedTitle.BackgroundTransparency = 1
minimizedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizedTitle.Font = Enum.Font.GothamBold
minimizedTitle.TextSize = 16
minimizedTitle.ZIndex = 3
minimizedTitle.Parent = minimizedFrame

-- Variables untuk auto farm
local isRunning = false
local isMinimized = false
local fishCount = 0
local startTime = 0

-- Replicated Storage connection
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GiveFishFunction

-- Cari function dengan berbagai kemungkinan nama
local function findFishFunction()
	if ReplicatedStorage:FindFirstChild("GiveFishFunction") then
		return ReplicatedStorage:WaitForChild("GiveFishFunction")
	elseif ReplicatedStorage:FindFirstChild("FishFunction") then
		return ReplicatedStorage:WaitForChild("FishFunction")
	elseif ReplicatedStorage:FindFirstChild("GiveFish") then
		return ReplicatedStorage:WaitForChild("GiveFish")
	end
	return nil
end

-- Fungsi auto farm
local function autoFarm()
	while isRunning and task.wait(0.5) do
		pcall(function()
			if GiveFishFunction then
				local args = {"safsafwaetqw3fsa"}
				GiveFishFunction:InvokeServer(unpack(args))
				fishCount = fishCount + 1
				
				-- Update status setiap 5 ikan
				if fishCount % 5 == 0 then
					local runtime = math.floor(os.time() - startTime)
					local minutes = math.floor(runtime / 60)
					local seconds = runtime % 60
					statusLabel.Text = string.format("Status: ON\nFish: %d\nTime: %02d:%02d", fishCount, minutes, seconds)
				end
			else
				-- Coba cari function lagi
				GiveFishFunction = findFishFunction()
				if not GiveFishFunction then
					statusLabel.Text = "ERROR: Function not found!"
					isRunning = false
					toggleBtn.Text = "▶ START AUTO FARM"
					toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
				end
			end
		end)
	end
end

-- UI Event Handlers
minimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	mainFrame.Visible = not isMinimized
	minimizedFrame.Visible = isMinimized
	
	if isMinimized then
		minimizeBtn.Text = "□"
	else
		minimizeBtn.Text = "_"
	end
end)

minimizedTitle.MouseButton1Click:Connect(function()
	isMinimized = false
	mainFrame.Visible = true
	minimizedFrame.Visible = false
	minimizeBtn.Text = "_"
end)

closeBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

toggleBtn.MouseButton1Click:Connect(function()
	isRunning = not isRunning
	
	if isRunning then
		-- Start auto farm
		toggleBtn.Text = "⏹ STOP AUTO FARM"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		statusLabel.Text = "Status: STARTING..."
		
		-- Inisialisasi fish function
		GiveFishFunction = findFishFunction()
		
		if GiveFishFunction then
			startTime = os.time()
			fishCount = 0
			statusLabel.Text = "Status: ON\nFish: 0\nTime: 00:00"
			
			-- Start farming coroutine
			coroutine.wrap(autoFarm)()
		else
			statusLabel.Text = "ERROR: Fish function not found!"
			isRunning = false
			toggleBtn.Text = "▶ START AUTO FARM"
			toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
		end
	else
		-- Stop auto farm
		toggleBtn.Text = "▶ START AUTO FARM"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
		
		if fishCount > 0 then
			local runtime = math.floor(os.time() - startTime)
			local minutes = math.floor(runtime / 60)
			local seconds = runtime % 60
			statusLabel.Text = string.format("Status: OFF\nTotal Fish: %d\nTotal Time: %02d:%02d", fishCount, minutes, seconds)
		else
			statusLabel.Text = "Status: OFF"
		end
	end
end)

statsBtn.MouseButton1Click:Connect(function()
	if fishCount > 0 then
		local runtime = math.floor(os.time() - startTime)
		local minutes = math.floor(runtime / 60)
		local seconds = runtime % 60
		local fishPerMinute = runtime > 0 and math.floor((fishCount / runtime) * 60) or 0
		
		statusLabel.Text = string.format(
			"📊 STATISTICS\nFish: %d\nTime: %02d:%02d\nRate: %d fish/min",
			fishCount, minutes, seconds, fishPerMinute
		)
	else
		statusLabel.Text = "📊 STATISTICS\nNo data available\nStart farming first!"
	end
end)

settingsBtn.MouseButton1Click:Connect(function()
	statusLabel.Text = "⚙ SETTINGS\nAuto Farm v1.0\nMade for Mobile\nTap buttons to use"
end)

-- Tambah drag functionality untuk mobile
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
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
	if input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		updateInput(input)
	end
end)

-- Juga untuk minimized frame
minimizedTitle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = minimizedFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

minimizedTitle.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

-- Notifikasi awal
statusLabel.Text = "🎣 Mobile Auto Fish v1.0\nTap START to begin farming!\nDrag title to move UI"

print("Mobile Auto Fish GUI loaded successfully!")
print("Features: Auto Farm, Minimize, Mobile-friendly UI")