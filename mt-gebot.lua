-- MT GEBOK SEKALI AUTO TP GUI
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local RunService = game:GetService("RunService")

local function tp(cf)
    if hrp then
        hrp.CFrame = cf
    end
end

-- DATA
local CP = {
    CFrame.new(5403,490,7527),
    CFrame.new(5419,494,8367),
    CFrame.new(5634,494,9432),
    CFrame.new(5515,498,10814),
    CFrame.new(5419,638,11890),
    CFrame.new(4907,642,13143),
    CFrame.new(4786,882,14049),
    CFrame.new(4859,890,15537),
    CFrame.new(4848,894,17231),
    CFrame.new(3374,1130,17592),
    CFrame.new(2268,1734,17174),
    CFrame.new(438,1734,16749),
    CFrame.new(-561,2014,16727),
    CFrame.new(-1966,1658,16900),
    CFrame.new(-3034,1662,16545),
    CFrame.new(-4281,1726,16448),
    CFrame.new(-5055,1735,14661),
    CFrame.new(-6489,1979,14454),
    CFrame.new(-7693,2299,14410),
}

local SUMMIT = CFrame.new(-9027,2904,14521)
local BC = CFrame.new(5437,485,6583)

-- STATE
local auto = false
local delayTime = 3

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "MT_AUTO_GUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.3,0.48)
main.Position = UDim2.fromScale(0.35,0.25)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "MT GEBOK AUTO TP 🏔️"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- Minimize
local mini = Instance.new("TextButton", main)
mini.Size = UDim2.new(0,40,0,40)
mini.Position = UDim2.new(1,-40,0,0)
mini.Text = "-"

local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.new(0,50,0,50)
icon.Position = UDim2.new(0,20,0.5,0)
icon.Text = "⛰️"
icon.Visible = false

mini.MouseButton1Click:Connect(function()
    main.Visible = false
    icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
    main.Visible = true
    icon.Visible = false
end)

-- Delay Input
local box = Instance.new("TextBox", main)
box.Size = UDim2.new(0.4,0,0,30)
box.Position = UDim2.new(0.05,0,0,45)
box.Text = tostring(delayTime)
box.PlaceholderText = "Delay 1-10"
box.ClearTextOnFocus = false

box.FocusLost:Connect(function()
    local v = tonumber(box.Text)
    if v and v >= 1 and v <= 10 then
        delayTime = v
    else
        box.Text = tostring(delayTime)
    end
end)

-- Auto Button
local autoBtn = Instance.new("TextButton", main)
autoBtn.Size = UDim2.new(0.45,0,0,30)
autoBtn.Position = UDim2.new(0.5,0,0,45)
autoBtn.Text = "AUTO : OFF"

autoBtn.MouseButton1Click:Connect(function()
    auto = not auto
    autoBtn.Text = auto and "AUTO : ON" or "AUTO : OFF"
end)

-- Manual Buttons
local function makeBtn(text,y,cf)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9,0,0,30)
    b.Position = UDim2.new(0.05,0,0,y)
    b.Text = text
    b.MouseButton1Click:Connect(function()
        tp(cf)
    end)
end

local y = 90
for i,cf in ipairs(CP) do
    makeBtn("TP CP"..i,y,cf)
    y += 32
end

makeBtn("TP SUMMIT 🏁",y+10,SUMMIT)
makeBtn("TP BC",y+45,BC)

-- AUTO LOOP
task.spawn(function()
    while true do
        if auto then
            for _,cf in ipairs(CP) do
                if not auto then break end
                tp(cf)
                task.wait(delayTime)
            end
            if auto then
                tp(SUMMIT)
                task.wait(delayTime)
                tp(BC)
            end
        end
        task.wait(0.2)
    end
end)

print("AUTO TELEPORT READY 🚀")