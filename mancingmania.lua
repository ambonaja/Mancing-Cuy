--====================================
-- AUTO FISH LEGIT (IKAN MASUK TAS)
--====================================

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

-- ===== REMOTES =====
local FishingSystem = RS:WaitForChild("FishingSystem")
local StartFishing = FishingSystem:WaitForChild("StartFishing")
local FishCaught = FishingSystem:WaitForChild("FishCaught")

-- kalau masih dipakai
local Remotes = RS:WaitForChild("Remotess")
local CastEvent = Remotes:WaitForChild("CastEvent")
local MiniGame = Remotes:WaitForChild("MiniGame")

local running = false

--====================================
-- GUI (AMAN MOBILE)
--====================================
local gui = Instance.new("ScreenGui")
gui.Name = "AutoFishLegit"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = pg

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0,170,0,45)
btn.Position = UDim2.new(0,10,0,70)
btn.Text = "AUTO FISH : OFF"
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
btn.TextColor3 = Color3.new(1,1,1)
btn.ZIndex = 9999
btn.Parent = gui
Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

btn.MouseButton1Click:Connect(function()
	running = not running
	btn.Text = running and "AUTO FISH : ON" or "AUTO FISH : OFF"
	btn.BackgroundColor3 = running and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,40)
end)

--====================================
-- HIDE UI MINIGAME (AMAN)
--====================================
local function killUI(v)
	if v:IsDescendantOf(gui) then return end
	if v:IsA("ScreenGui") or v:IsA("Frame") then
		local n = v.Name:lower()
		if n:find("mini") or n:find("game") then
			pcall(function() v:Destroy() end)
		end
	end
end

for _,v in ipairs(pg:GetDescendants()) do killUI(v) end
pg.DescendantAdded:Connect(function(v)
	task.wait()
	killUI(v)
end)

--====================================
-- MAIN LOOP (LEGIT FLOW)
--====================================
task.spawn(function()
	while task.wait(1.2) do
		if running then
			-- 1️⃣ START FISHING (server legit)
			StartFishing:FireServer()

			-- 2️⃣ CAST (kalau masih dibutuhin)
			CastEvent:FireServer(false, 41.7, CFrame.new(-59.75, 2.99, -39.66))

			-- 3️⃣ SKIP MINIGAME
			task.wait(0.05)
			MiniGame:FireServer(true)

			-- 4️⃣ HASIL → IKAN MASUK TAS
			task.wait(0.05)
			FishCaught:FireServer()
		end
	end
end)