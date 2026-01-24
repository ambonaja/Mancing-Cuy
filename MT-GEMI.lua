--========================================
-- MT GEMI AUTO SUMMIT LOOP + AUTO RESET
--========================================

-- SERVICES
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- POSITIONS
local BC = Vector3.new(1283, 640, 1831)
local SUMMIT = Vector3.new(-6682, 3070, -801)

-- STATE
local AutoLoop = false
local Delay = 1
local TeleportedToSummit = false

-- CHARACTER VARS
local char, hrp, hum

local function setupChar(c)
    char = c
    hrp = c:WaitForChild("HumanoidRootPart")
    hum = c:WaitForChild("Humanoid")

    -- spawn -> send to BC first (optional stability)
    task.wait(0.2)
    hrp.CFrame = CFrame.new(BC)

    -- after respawn, if loop on -> go summit again
    if AutoLoop then
        task.wait(Delay)
        hrp.CFrame = CFrame.new(SUMMIT)
        TeleportedToSummit = true
    end
end

if lp.Character then
    setupChar(lp.Character)
end

lp.CharacterAdded:Connect(setupChar)

-- TELEPORT
local function TP(pos)
    if hrp then
        hrp.CFrame = CFrame.new(pos)
    end
end

-- MAIN LOOP
task.spawn(function()
    while task.wait() do
        if AutoLoop and hrp and hum then
            -- go summit once
            if not TeleportedToSummit then
                TP(SUMMIT)
                TeleportedToSummit = true
                task.wait(Delay)
            end

            -- if at summit -> reset
            local dist = (hrp.Position - SUMMIT).Magnitude
            if dist < 15 then
                task.wait(Delay)
                hum.Health = 0 -- AUTO RESET
                TeleportedToSummit = false
            end
        end
    end
end)

--================ UI =====================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MT_GEMI_SUMMIT_LOOP_UI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(300,220)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "MT GEMI AUTO SUMMIT RESET"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.new(1,1,1)

-- TOGGLE LOOP
local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.fromOffset(260,40)
toggle.Position = UDim2.fromOffset(20,55)
toggle.Text = "AUTO LOOP : OFF"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 13
toggle.BackgroundColor3 = Color3.fromRGB(45,45,45)
toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggle)

-- DELAY INPUT
local delayBox = Instance.new("TextBox", main)
delayBox.Size = UDim2.fromOffset(260,35)
delayBox.Position = UDim2.fromOffset(20,105)
delayBox.PlaceholderText = "Delay (1 - 10)"
delayBox.Text = "1"
delayBox.Font = Enum.Font.Gotham
delayBox.TextSize = 12
delayBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
delayBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", delayBox)

-- STATUS LABEL
local status = Instance.new("TextLabel", main)
status.Size = UDim2.fromOffset(260,30)
status.Position = UDim2.fromOffset(20,150)
status.BackgroundTransparency = 1
status.Text = "Status: Idle"
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextColor3 = Color3.fromRGB(200,200,200)

-- LOGIC
toggle.MouseButton1Click:Connect(function()
    AutoLoop = not AutoLoop
    toggle.Text = AutoLoop and "AUTO LOOP : ON" or "AUTO LOOP : OFF"
    TeleportedToSummit = false
    status.Text = AutoLoop and "Status: Loop Running" or "Status: Idle"
end)

delayBox.FocusLost:Connect(function()
    local v = tonumber(delayBox.Text)
    if v and v >= 1 and v <= 10 then
        Delay = v
    else
        delayBox.Text = tostring(Delay)
    end
end)

-- MINIMIZE BUTTON
local mini = Instance.new("TextButton", gui)
mini.Size = UDim2.fromOffset(45,45)
mini.Position = UDim2.fromOffset(20,200)
mini.Text = "MT"
mini.Font = Enum.Font.GothamBold
mini.TextSize = 14
mini.BackgroundColor3 = Color3.fromRGB(30,30,30)
mini.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", mini).CornerRadius = UDim.new(1,0)

mini.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)