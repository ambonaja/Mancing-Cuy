--==================================================
-- AUTO FISH | FINAL PERFECT STABLE (ZONE UPDATED)
--==================================================

pcall(function()
	if _G.AUTO_FISH_GUI then _G.AUTO_FISH_GUI:Destroy() end
end)

--================ SERVICES =================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")

Player.CharacterAdded:Connect(function(c)
	Char = c
	HRP = c:WaitForChild("HumanoidRootPart")
end)

--================ REMOTES =================
local FishRemote = RS:WaitForChild("FishingYahiko")
local CastRemote = FishRemote:WaitForChild("CastReplication")
local GiveRemote = FishRemote:WaitForChild("YahikoGiver")
local SellRemote = FishRemote:WaitForChild("InventoryEvents"):WaitForChild("Inventory_SellAll")

--================ STATE =================
local AutoFish = false
local AutoSell = false

local SafeMode = true
local BrutalMode = false
local GodFarm = false

local CurrentRodIndex = 1
local ForcedZoneIndex = nil

--================ ROD DATA =================
local RodList = {
	"Basic Rod",
	"PokemonRod",
	"RavenRod",
	"IcePink",
	"QueenRod",
	"DeathRod"
}

--================ ZONE DATA =================
local Zones = {
	{ name = "Flame Megalodon", pos = Vector3.new(-19,457,18) },
	{ name = "Volcano Fire",    pos = Vector3.new(1091,475,-2357) },
	{ name = "Jungle New",      pos = Vector3.new(-2874,475,-1974) },
	{ name = "Snowy Isle",      pos = Vector3.new(2230,462,-1655) },
	{ name = "Hunter Island",   pos = Vector3.new(-1225,518,141) },
	{ name = "Oceancrest New",  pos = Vector3.new(3647,479,-2460) },
	{ name = "Ocean",           pos = Vector3.new(-1186,818,-901) },
}

--================ GUI =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AUTO_FISH_GUI"
gui.ResetOnSpawn = false
_G.AUTO_FISH_GUI = gui

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(560,300)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Instance.new("UICorner", main)

--================ HEADER =================
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,-10,0,45)
header.Position = UDim2.fromOffset(5,5)
header.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", header)

--================ MINIMIZE =================
local minBtn = Instance.new("TextButton", header)
minBtn.Size = UDim2.fromOffset(32,32)
minBtn.AnchorPoint = Vector2.new(1,0.5)
minBtn.Position = UDim2.new(1,-8,0.5,0)
minBtn.Text = "—"
minBtn.TextScaled = true
minBtn.Font = Enum.Font.GothamBold
minBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
minBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minBtn)

local icon = Instance.new("ImageButton", gui)
icon.Size = UDim2.fromOffset(48,48)
icon.Position = UDim2.fromScale(0.05,0.5)
icon.Image = "rbxassetid://6026568198"
icon.Visible = false
Instance.new("UICorner", icon)

--================ DRAG =================
local function drag(obj)
	local dragging, dragStart, startPos
	obj.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = i.Position
			startPos = obj.Position
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - dragStart
			obj.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + d.X,
				startPos.Y.Scale, startPos.Y.Offset + d.Y
			)
		end
	end)
	UIS.InputEnded:Connect(function()
		dragging = false
	end)
end

drag(main)
drag(icon)

minBtn.MouseButton1Click:Connect(function()
	main.Visible = false
	icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
	main.Visible = true
	icon.Visible = false
end)

--================ UI HELPERS =================
local function mkBtn(parent,text,y)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.fromOffset(260,36)
	b.Position = UDim2.fromOffset(0,y)
	b.Text = text
	b.TextScaled = true
	b.Font = Enum.Font.GothamBold
	b.BackgroundColor3 = Color3.fromRGB(150,50,50)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	return b
end

local function setToggle(btn,state,label)
	btn.Text = label..": "..(state and "ON" or "OFF")
	btn.BackgroundColor3 = state and Color3.fromRGB(40,170,90) or Color3.fromRGB(150,50,50)
end

--================ FAKE STRIKE EVENT =================
local function FakeStrike(hookPos)
	pcall(function()
		CastRemote:FireServer(
			hookPos,
			Vector3.new(0,-1,0),
			RodList[CurrentRodIndex],
			100
		)
	end)
end

--================ TABS =================
local tabFish = mkBtn(header,"FISH",7)
tabFish.Size = UDim2.fromOffset(100,30)
tabFish.Position = UDim2.fromOffset(10,7)

local tabSystem = mkBtn(header,"SYSTEM",7)
tabSystem.Size = UDim2.fromOffset(100,30)
tabSystem.Position = UDim2.fromOffset(120,7)

local tabRodZone = mkBtn(header,"ROD & ZONE",7)
tabRodZone.Size = UDim2.fromOffset(140,30)
tabRodZone.Position = UDim2.fromOffset(240,7)

--================ PAGES =================
local pages = Instance.new("Folder", main)

local FishPage = Instance.new("Frame", pages)
FishPage.Size = UDim2.fromOffset(260,230)
FishPage.Position = UDim2.fromOffset(10,60)
FishPage.BackgroundTransparency = 1
FishPage.Visible = true

local SystemPage = FishPage:Clone()
SystemPage.Parent = pages
SystemPage.Position = UDim2.fromOffset(290,60)
SystemPage.Visible = false

local RodZonePage = FishPage:Clone()
RodZonePage.Parent = pages
RodZonePage.Position = UDim2.fromOffset(10,60)
RodZonePage.Visible = false

tabFish.MouseButton1Click:Connect(function()
	FishPage.Visible = true
	SystemPage.Visible = false
	RodZonePage.Visible = false
end)

tabSystem.MouseButton1Click:Connect(function()
	FishPage.Visible = false
	SystemPage.Visible = true
	RodZonePage.Visible = false
end)

tabRodZone.MouseButton1Click:Connect(function()
	FishPage.Visible = false
	SystemPage.Visible = false
	RodZonePage.Visible = true
end)

--================ FISH PAGE =================
local afBtn = mkBtn(FishPage,"AUTO FISH",0)
setToggle(afBtn,false,"AUTO FISH")
afBtn.MouseButton1Click:Connect(function()
	AutoFish = not AutoFish
	setToggle(afBtn,AutoFish,"AUTO FISH")
end)

local sellBtn = mkBtn(FishPage,"AUTO SELL",45)
setToggle(sellBtn,false,"AUTO SELL")
sellBtn.MouseButton1Click:Connect(function()
	AutoSell = not AutoSell
	setToggle(sellBtn,AutoSell,"AUTO SELL")
end)

--================ SYSTEM PAGE =================
local safeBtn = mkBtn(SystemPage,"SAFE MODE",0)
setToggle(safeBtn,true,"SAFE MODE")
safeBtn.MouseButton1Click:Connect(function()
	SafeMode, BrutalMode, GodFarm = true, false, false
	setToggle(safeBtn,true,"SAFE MODE")
end)

local brutalBtn = mkBtn(SystemPage,"BRUTAL MODE",45)
setToggle(brutalBtn,false,"BRUTAL MODE")
brutalBtn.MouseButton1Click:Connect(function()
	SafeMode, BrutalMode, GodFarm = false, true, false
	setToggle(brutalBtn,true,"BRUTAL MODE")
end)

local godBtn = mkBtn(SystemPage,"GOD FARM",90)
setToggle(godBtn,false,"GOD FARM")
godBtn.MouseButton1Click:Connect(function()
	SafeMode, BrutalMode, GodFarm = false, false, true
	setToggle(godBtn,true,"GOD FARM")
end)

--================ ROD & ZONE PAGE =================
local rodBtn = mkBtn(RodZonePage,"ROD",0)
rodBtn.Text = "ROD : "..RodList[CurrentRodIndex]
rodBtn.MouseButton1Click:Connect(function()
	CurrentRodIndex = (CurrentRodIndex % #RodList) + 1
	rodBtn.Text = "ROD : "..RodList[CurrentRodIndex]
end)

local zoneBtn = mkBtn(RodZonePage,"ZONE",45)
zoneBtn.Text = "ZONE : AUTO"
zoneBtn.MouseButton1Click:Connect(function()
	if not ForcedZoneIndex then
		ForcedZoneIndex = 1
	else
		ForcedZoneIndex = (ForcedZoneIndex % #Zones) + 1
	end
	zoneBtn.Text = "ZONE : "..Zones[ForcedZoneIndex].name
end)

local autoZoneBtn = mkBtn(RodZonePage,"ZONE MODE : AUTO",90)
autoZoneBtn.MouseButton1Click:Connect(function()
	ForcedZoneIndex = nil
	zoneBtn.Text = "ZONE : AUTO"
end)

--================ AUTO FISH CORE =================
task.spawn(function()
	while true do
		if AutoFish and HRP then
			local zone = ForcedZoneIndex and Zones[ForcedZoneIndex]
			local hookPos = zone and zone.pos or HRP.Position

			CastRemote:FireServer(
				HRP.Position + Vector3.new(0,5,0),
				Vector3.new(0,5,0),
				RodList[CurrentRodIndex],
				BrutalMode and 100 or 80
			)

			FakeStrike(hookPos) -- pemalsuan state strike (event kecil)

			GiveRemote:FireServer({
				rodName = RodList[CurrentRodIndex],
				hookPosition = hookPos,
				powerPercent = GodFarm and 1 or (BrutalMode and 1 or 0.8),
				zone = zone and zone.name or "AUTO"
			})

			if AutoSell then
				pcall(function()
					SellRemote:InvokeServer()
				end)
			end
		end
		task.wait(GodFarm and 0 or BrutalMode and 0.15 or 1)
	end
end)