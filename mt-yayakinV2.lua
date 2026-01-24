--// MT YAYAKIN V2 500 SUMMIT
--// AUTO LOOP RUN ALL CP → SUMMIT → BC (UPDATED COORD)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

--================ DATA (UPDATED) =================--
local Points = {
    CP = {
        {"CP1", Vector3.new(-428,249,775)},
        {"CP2", Vector3.new(-380,387,579)},
        {"CP3", Vector3.new(252,429,501)},
        {"CP4", Vector3.new(331,489,365)},
        {"CP5", Vector3.new(235,313,-145)},
    },
    Summit = Vector3.new(-617,905,-552),
    BC = Vector3.new(-947,169,860)
}

local delayTime = 1
local tpBusy = false
local autoLoop = false

--================ SAFE HRP =================--
local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

--================ TELEPORT (STABLE) =================--
local function teleport(pos)
    if tpBusy then return end
    tpBusy = true

    local hrp = getHRP()
    hrp.Anchored = false
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    task.wait()
    hrp.CFrame = CFrame.new(pos + Vector3.new(0,4,0))
    task.wait(0.15)

    tpBusy = false
end

--================ GUI =================--
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- icon
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.new(0,48,0,48)
icon.Position = UDim2.new(0,15,0.5,-24)
icon.Text = "⛰️"
icon.TextSize = 22
icon.BackgroundColor3 = Color3.fromRGB(40,40,40)
icon.TextColor3 = Color3.new(1,1,1)
icon.BorderSizePixel = 0
icon.Visible = false
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

-- main
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,330,0,390)
main.Position = UDim2.new(0.5,-165,0.5,-195)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
Instance.new("UICorner", main)

-- header
local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1,0,0,40)
header.Text = "MT YAYAKIN V2 500 SUMMIT"
header.TextColor3 = Color3.new(1,1,1)
header.BackgroundColor3 = Color3.fromRGB(35,35,35)
header.BorderSizePixel = 0
header.TextSize = 14
Instance.new("UICorner", header)

local minBtn = Instance.new("TextButton", header)
minBtn.Size = UDim2.new(0,40,1,0)
minBtn.Position = UDim2.new(1,-40,0,0)
minBtn.Text = "-"
minBtn.TextSize = 20
minBtn.BackgroundTransparency = 1
minBtn.TextColor3 = Color3.new(1,1,1)

-- pages
local pages = Instance.new("Frame", main)
pages.Position = UDim2.new(0,0,0,40)
pages.Size = UDim2.new(1,0,1,-40)
pages.BackgroundTransparency = 1

local function tab(text,x)
    local b = Instance.new("TextButton", pages)
    b.Size = UDim2.new(0.33,0,0,30)
    b.Position = UDim2.new(x,0,0,0)
    b.Text = text
    b.TextSize = 13
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.BorderSizePixel = 0
    return b
end

local tabCP = tab("CP",0)
local tabSummit = tab("SUMMIT",0.33)
local tabBC = tab("BC",0.66)

local function page()
    local f = Instance.new("Frame", pages)
    f.Position = UDim2.new(0,0,0,35)
    f.Size = UDim2.new(1,0,1,-35)
    f.BackgroundTransparency = 1
    f.Visible = false
    return f
end

local pageCP = page()
local pageSummit = page()
local pageBC = page()
pageCP.Visible = true

local function btn(parent,text,y,cb)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.9,0,0,36)
    b.Position = UDim2.new(0.05,0,0,y)
    b.Text = text
    b.TextSize = 14
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    b.TextColor3 = Color3.new(1,1,1)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        cb(b)
    end)
end

--================ CP PAGE =================--
local y = 0
for _,v in ipairs(Points.CP) do
    btn(pageCP, v[1], y, function()
        teleport(v[2])
    end)
    y += 42
end

-- AUTO LOOP
btn(pageCP,"AUTO RUN ALL (OFF)",y+10,function(button)
    autoLoop = not autoLoop
    button.Text = autoLoop and "AUTO RUN ALL (ON)" or "AUTO RUN ALL (OFF)"
    if not autoLoop then return end

    task.spawn(function()
        while autoLoop do
            for _,v in ipairs(Points.CP) do
                if not autoLoop then break end
                teleport(v[2])
                task.wait(delayTime)
            end
            if not autoLoop then break end
            teleport(Points.Summit)
            task.wait(delayTime)
            if not autoLoop then break end
            teleport(Points.BC)
            task.wait(delayTime)
        end
    end)
end)

-- Summit
btn(pageSummit,"TELEPORT SUMMIT",0,function()
    teleport(Points.Summit)
end)

-- BC
btn(pageBC,"TELEPORT BC",0,function()
    teleport(Points.BC)
end)

-- Delay input
local delayBox = Instance.new("TextBox", pages)
delayBox.Size = UDim2.new(0.9,0,0,30)
delayBox.Position = UDim2.new(0.05,0,1,-35)
delayBox.Text = "Delay (1 - 10)"
delayBox.TextColor3 = Color3.new(1,1,1)
delayBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
delayBox.BorderSizePixel = 0
delayBox.ClearTextOnFocus = false
Instance.new("UICorner", delayBox)

delayBox.FocusLost:Connect(function()
    local v = tonumber(delayBox.Text)
    if v and v >= 1 and v <= 10 then
        delayTime = v
        delayBox.Text = "Delay : "..v
    else
        delayBox.Text = "Delay (1 - 10)"
    end
end)

-- Tabs
local function hide()
    pageCP.Visible = false
    pageSummit.Visible = false
    pageBC.Visible = false
end
tabCP.MouseButton1Click:Connect(function() hide(); pageCP.Visible = true end)
tabSummit.MouseButton1Click:Connect(function() hide(); pageSummit.Visible = true end)
tabBC.MouseButton1Click:Connect(function() hide(); pageBC.Visible = true end)

-- Minimize
minBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    icon.Visible = true
end)
icon.MouseButton1Click:Connect(function()
    main.Visible = true
    icon.Visible = false
end)