-- =====================================================
-- AMBON HUB | Mobile Edition + Fly Joystick
-- =====================================================

-- LOAD UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "AMBON HUB | ULTIMATE",
	LoadingTitle = "AMBON HUB",
	LoadingSubtitle = "Ultimate V1.0",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "AMBON_HUB",
		FileName = "Config"
	}
})

-- SERVICES
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local FishingSystem = RS:WaitForChild("FishingSystem")
local Camera = workspace.CurrentCamera

-- VARIABLES
local AutoFarm = false
local MinDelay = 0.5
local MaxDelay = 1.2

-- Fly
local FlyEnabled = false
local FlySpeed = 60
local FlyBV
local JoyDir = Vector3.zero
local UpDown = 0

-- ==============================
-- FUNCTIONS
-- ==============================
local function RandomDelay()
	return math.random(MinDelay * 100, MaxDelay * 100) / 100
end

local function CastFish()
	local p = HRP.Position
	FishingSystem.CastReplication:FireServer(
		p,
		Vector3.new(0,100,0),
		"Blue Katana",
		90,
		p + Vector3.new(3,0,3),
		"Starter Bait"
	)
end

local function ReelFish()
	FishingSystem.ReplicateVFX:FireServer("StateUpdate","Reeling")
	FishingSystem.RequestFishRoll:InvokeServer(HRP.Position)
	FishingSystem.ReplicateVFX:FireServer("StateUpdate","Caught")
end

local function StartAutoFarm()
	task.spawn(function()
		while AutoFarm do
			FishingSystem.ReplicateVFX:FireServer("StateUpdate","Casting")
			CastFish()
			task.wait(RandomDelay())
			ReelFish()
			task.wait(RandomDelay())
		end
	end)
end

-- ==============================
-- FLY CORE
-- ==============================
local function StartFly()
	if FlyBV then FlyBV:Destroy() end
	FlyBV = Instance.new("BodyVelocity")
	FlyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
	FlyBV.Parent = HRP
end

local function StopFly()
	if FlyBV then FlyBV:Destroy() FlyBV = nil end
	JoyDir = Vector3.zero
	UpDown = 0
end

-- Update Fly Movement
task.spawn(function()
	while true do
		if FlyEnabled and FlyBV then
			local cf = Camera.CFrame
			local move =
				(cf.LookVector * JoyDir.Z) +
				(cf.RightVector * JoyDir.X) +
				Vector3.new(0, UpDown, 0)

			if move.Magnitude > 0 then
				FlyBV.Velocity = move.Unit * FlySpeed
			else
				FlyBV.Velocity = Vector3.zero
			end
		end
		task.wait()
	end
end)

-- ==============================
-- TAB : FISHING
-- ==============================
local FishingTab = Window:CreateTab("🎣 Fishing", 4483362458)

FishingTab:CreateToggle({
	Name = "Auto Farm Fishing",
	Callback = function(v)
		AutoFarm = v
		if v then StartAutoFarm() end
	end
})

FishingTab:CreateInput({
	Name = "Min Delay",
	PlaceholderText = "0.5",
	Callback = function(v)
		MinDelay = tonumber(v) or MinDelay
	end
})

FishingTab:CreateInput({
	Name = "Max Delay",
	PlaceholderText = "1.2",
	Callback = function(v)
		MaxDelay = tonumber(v) or MaxDelay
	end
})

-- ==============================
-- TAB : TELEPORT
-- ==============================
local TeleportTab = Window:CreateTab("🌍 Teleport", 4483362458)

local Zones = {
	["Lost Jungle"] = Vector3.new(1922,21,-102),
	["Pulau Danau"] = Vector3.new(1553,10,-1322),
	["Secret Trade"] = Vector3.new(1602,66,-1685),
	["Pulau Natal"] = Vector3.new(508,6,-738),
	["Zona Abadi"] = Vector3.new(-826,1,-30)
}

local ZoneList = {}
for k,_ in pairs(Zones) do table.insert(ZoneList,k) end

TeleportTab:CreateDropdown({
	Name = "Pilih Zone",
	Options = ZoneList,
	CurrentOption = {ZoneList[1]},
	Callback = function(v)
		local z = v[1]
		if Zones[z] then
			HRP.CFrame = CFrame.new(Zones[z] + Vector3.new(0,3,0))
		end
	end
})

-- ==============================
-- TAB : FLY JOYSTICK
-- ==============================
local FlyTab = Window:CreateTab("🎮 Fly Joystick", 4483362458)

FlyTab:CreateToggle({
	Name = "Enable Fly",
	Callback = function(v)
		FlyEnabled = v
		if v then StartFly() else StopFly() end
	end
})

FlyTab:CreateSlider({
	Name = "Fly Speed",
	Min = 10,
	Max = 200,
	Increment = 5,
	CurrentValue = FlySpeed,
	Callback = function(v)
		FlySpeed = v
	end
})

FlyTab:CreateSlider({
	Name = "Joystick X (Left / Right)",
	Min = -1,
	Max = 1,
	Increment = 0.05,
	CurrentValue = 0,
	Callback = function(v)
		JoyDir = Vector3.new(v, 0, JoyDir.Z)
	end
})

FlyTab:CreateSlider({
	Name = "Joystick Y (Forward / Back)",
	Min = -1,
	Max = 1,
	Increment = 0.05,
	CurrentValue = 0,
	Callback = function(v)
		JoyDir = Vector3.new(JoyDir.X, 0, v)
	end
})

FlyTab:CreateButton({
	Name = "Up",
	Callback = function()
		UpDown = 1
	end
})

FlyTab:CreateButton({
	Name = "Down",
	Callback = function()
		UpDown = -1
	end
})

FlyTab:CreateButton({
	Name = "Stop Vertical",
	Callback = function()
		UpDown = 0
	end
})

FlyTab:CreateButton({
	Name = "Stop All",
	Callback = function()
		JoyDir = Vector3.zero
		UpDown = 0
	end
})

-- ==============================
-- TAB : DISCORD
-- ==============================
local DiscordTab = Window:CreateTab("💬 Discord", 4483362458)

DiscordTab:CreateLabel({
	Name = "AMBON HUB Community"
})

DiscordTab:CreateButton({
	Name = "Copy Discord Invite",
	Callback = function()
		if setclipboard then
			setclipboard("https://discord.gg/FTVC2RVYC")
		end
		Rayfield:Notify({
			Title = "AMBON HUB",
			Content = "Link Discord disalin ke clipboard",
			Duration = 5
		})
	end
})

Rayfield:Notify({
	Title = "AMBON HUB",
	Content = "Fly Joystick Loaded (Mobile Ready)",
	Duration = 5
})