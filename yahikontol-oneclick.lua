--==================================================
-- INSTANT BURST CATCH (50.000x / CLICK)
-- VERY DANGEROUS MODE
--==================================================

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer

local CatchRemote = RS:WaitForChild("FishingCatchSuccess")

-- JUMLAH BURST
local BURST = 50000 -- 😋 instan

-- UI
local gui = Instance.new("ScreenGui", lp.PlayerGui)
gui.Name = "InstantBurstGUI"
gui.ResetOnSpawn = false

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 150, 0, 45)
btn.Position = UDim2.new(0.05, 0, 0.65, 0)
btn.Text = "😈 INSTANT 50K"
btn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.TextSize = 14
btn.BorderSizePixel = 0
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

-- DRAG
local dragging, dragStart, startPos
btn.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = i.Position
		startPos = btn.Position
	end
end)
UIS.InputChanged:Connect(function(i)
	if dragging then
		local d = i.Position - dragStart
		btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)
UIS.InputEnded:Connect(function()
	dragging = false
end)

-- CLICK = BURST
btn.MouseButton1Click:Connect(function()
	task.spawn(function()
		for i = 1, BURST do
			CatchRemote:FireServer()
		end
	end)
end)