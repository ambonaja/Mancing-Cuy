--==================================================
-- AUTO FARM FISH | FINAL STABLE
-- Delay 2.5s | Weight 600-700 | Coord per Fish
-- Multi Page + Checklist + Minimize Icon
--==================================================

--// SERVICES
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

--// REMOTE
local FishGiver = RS:WaitForChild("FishingSystem"):WaitForChild("FishGivers")

--// STATE
local autofarm = false
local delayFarm = 2.5

--==================================================
-- FISH DATA
--==================================================
local FishList = {
	"Ciyup Carber",
	"Megalodon Core",
	"Hammer Shark",
	"Jellyfish core",
	"Amber",
	"Voyage",
	"King Monster",
	"Puas Corda",
	"Kuzjuy Shark",
	"Cindera Fish"
}

local FishCoords = {
	["King Monster"]   = Vector3.new(2527,141,-819),
	["Hammer Shark"]   = Vector3.new(-1874,144,2355),
	["Jellyfish core"] = Vector3.new(-1874,144,2355),
	["Amber"]          = Vector3.new(-1162,160,-615),
	["Voyage"]         = Vector3.new(-1162,160,-615),
	["Puas Corda"]     = Vector3.new(1562,150,-3022),
	["Ciyup Carber"]   = Vector3.new(1439,209,-2509),
	["Megalodon Core"] = Vector3.new(1439,209,-2509),
	["Kuzjuy Shark"]   = Vector3.new(710,134,1573),
	["Cindera Fish"]   = Vector3.new(710,134,1573)
}

local SelectedFish = {}
for _,v in ipairs(FishList) do SelectedFish[v]=false end

local function getRandomFish()
	local pool={}
	for k,v in pairs(SelectedFish) do
		if v then table.insert(pool,k) end
	end
	if #pool==0 then return nil end
	return pool[math.random(#pool)]
end

--==================================================
-- GUI CLEAN
--==================================================
pcall(function() game.CoreGui.AutoFarmGUI:Destroy() end)
local gui=Instance.new("ScreenGui",game.CoreGui)
gui.Name="AutoFarmGUI"

-- MAIN FRAME
local frame=Instance.new("Frame",gui)
frame.Size=UDim2.fromOffset(300,260)
frame.Position=UDim2.new(0.5,-150,0.5,-130)
frame.BackgroundColor3=Color3.fromRGB(25,25,25)
Instance.new("UICorner",frame).CornerRadius=UDim.new(0,14)

-- FLOAT ICON
local floating=Instance.new("TextButton",gui)
floating.Size=UDim2.fromOffset(42,42)
floating.Position=UDim2.new(1,-60,0.5,-21)
floating.Text="🎣"
floating.TextSize=20
floating.BackgroundColor3=Color3.fromRGB(40,40,40)
floating.TextColor3=Color3.new(1,1,1)
floating.Visible=false
Instance.new("UICorner",floating).CornerRadius=UDim.new(1,0)

-- TITLE
local title=Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,28)
title.Text="AUTO FARM FISH"
title.BackgroundTransparency=1
title.TextColor3=Color3.new(1,1,1)
title.Font=Enum.Font.GothamBold
title.TextSize=14

-- MINIMIZE
local minimize=Instance.new("TextButton",frame)
minimize.Size=UDim2.fromOffset(26,26)
minimize.Position=UDim2.new(1,-30,0,2)
minimize.Text="–"
minimize.TextSize=18
minimize.TextColor3=Color3.new(1,1,1)
minimize.BackgroundColor3=Color3.fromRGB(45,45,45)
Instance.new("UICorner",minimize).CornerRadius=UDim.new(0,8)

-- TAB BAR
local tabBar=Instance.new("Frame",frame)
tabBar.Size=UDim2.new(1,-20,0,30)
tabBar.Position=UDim2.fromOffset(10,30)
tabBar.BackgroundTransparency=1

local tabLayout=Instance.new("UIListLayout",tabBar)
tabLayout.FillDirection=Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
tabLayout.Padding=UDim.new(0,8)

local Pages={}
local function createTab(name)
	local b=Instance.new("TextButton",tabBar)
	b.Size=UDim2.fromOffset(80,26)
	b.Text=name
	b.TextSize=12
	b.Font=Enum.Font.GothamBold
	b.TextColor3=Color3.new(1,1,1)
	b.BackgroundColor3=Color3.fromRGB(40,40,40)
	Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
	b.MouseButton1Click:Connect(function()
		for _,p in pairs(Pages) do p.Visible=false end
		Pages[name].Visible=true
	end)
end

createTab("Main")
createTab("Fish")

-- HOLDER
local holder=Instance.new("Frame",frame)
holder.Size=UDim2.new(1,-20,1,-70)
holder.Position=UDim2.fromOffset(10,65)
holder.BackgroundTransparency=1

--==================================================
-- MAIN PAGE
--==================================================
Pages.Main=Instance.new("Frame",holder)
Pages.Main.Size=UDim2.new(1,0,1,0)
Pages.Main.BackgroundTransparency=1

local toggle=Instance.new("TextButton",Pages.Main)
toggle.Size=UDim2.fromOffset(220,42)
toggle.Position=UDim2.fromOffset(30,20)
toggle.Text="AUTO FARM : OFF"
toggle.Font=Enum.Font.GothamBold
toggle.TextSize=14
toggle.TextColor3=Color3.new(1,1,1)
toggle.BackgroundColor3=Color3.fromRGB(80,0,0)
Instance.new("UICorner",toggle).CornerRadius=UDim.new(0,12)

local countdown=Instance.new("TextLabel",Pages.Main)
countdown.Size=UDim2.new(1,0,0,20)
countdown.Position=UDim2.fromOffset(0,75)
countdown.Text="Next catch: 2.5s"
countdown.BackgroundTransparency=1
countdown.TextColor3=Color3.fromRGB(180,180,180)
countdown.Font=Enum.Font.Gotham
countdown.TextSize=12
countdown.Visible=false

toggle.MouseButton1Click:Connect(function()
	autofarm=not autofarm
	toggle.Text=autofarm and "AUTO FARM : ON" or "AUTO FARM : OFF"
	toggle.BackgroundColor3=autofarm and Color3.fromRGB(0,90,0) or Color3.fromRGB(80,0,0)
	if not autofarm then countdown.Visible=false end
end)

--==================================================
-- FISH PAGE
--==================================================
Pages.Fish=Instance.new("Frame",holder)
Pages.Fish.Size=UDim2.new(1,0,1,0)
Pages.Fish.Visible=false
Pages.Fish.BackgroundTransparency=1

local scroll=Instance.new("ScrollingFrame",Pages.Fish)
scroll.Size=UDim2.new(1,0,1,0)
scroll.BackgroundTransparency=1
scroll.ScrollBarImageTransparency=0.5

local grid=Instance.new("UIGridLayout",scroll)
grid.CellSize=UDim2.fromOffset(120,30)
grid.CellPadding=UDim2.fromOffset(10,8)
grid.FillDirectionMaxCells=2

for _,fish in ipairs(FishList) do
	local b=Instance.new("TextButton",scroll)
	b.Text="☐ "..fish
	b.TextSize=11
	b.Font=Enum.Font.Gotham
	b.TextColor3=Color3.new(1,1,1)
	b.BackgroundColor3=Color3.fromRGB(40,40,40)
	Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)

	b.MouseButton1Click:Connect(function()
		SelectedFish[fish]=not SelectedFish[fish]
		b.Text=(SelectedFish[fish] and "☑ " or "☐ ")..fish
		b.BackgroundColor3=SelectedFish[fish] and Color3.fromRGB(0,80,40) or Color3.fromRGB(40,40,40)
	end)
end

task.wait()
scroll.CanvasSize=UDim2.new(0,0,0,grid.AbsoluteContentSize.Y+10)

Pages.Main.Visible=true

--==================================================
-- DRAG
--==================================================
local function drag(o)
	local d,s,p
	o.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then
			d=true s=i.Position p=o.Position
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if d and i.UserInputType==Enum.UserInputType.MouseMovement then
			local dx=i.Position-s
			o.Position=UDim2.new(p.X.Scale,p.X.Offset+dx.X,p.Y.Scale,p.Y.Offset+dx.Y)
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then d=false end
	end)
end

drag(frame)
drag(floating)

-- MINIMIZE
minimize.MouseButton1Click:Connect(function()
	frame.Visible=false
	floating.Visible=true
end)

floating.MouseButton1Click:Connect(function()
	frame.Visible=true
	floating.Visible=false
end)

--==================================================
-- AUTO FARM LOOP
--==================================================
task.spawn(function()
	while true do
		if autofarm then
			local t=delayFarm
			countdown.Visible=true
			while t>0 and autofarm do
				countdown.Text=string.format("Next catch: %.1fs",t)
				task.wait(0.1)
				t-=0.1
			end
			if autofarm then
				local fish=getRandomFish()
				if fish then
					pcall(function()
						FishGiver:FireServer(true,{
							name=fish,
							rarity="Secret",
							weight=math.random(600,700),
							hookPosition=FishCoords[fish]
						})
					end)
				end
			end
		end
		task.wait(0.05)
	end
end)