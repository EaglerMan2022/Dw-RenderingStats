local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. DESTROY OLD UI (Clean up)
if CoreGui:FindFirstChild("OverlayUI") then
    CoreGui.OverlayUI:Destroy()
end

-- 2. CREATE SCREEN GUI IN COREGUI
local gui = Instance.new("ScreenGui")
gui.Name = "OverlayUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
-- This is the max 32-bit integer. It puts this UI above the Chat, Menu, and everything else.
gui.DisplayOrder = 2147483647 
gui.Parent = CoreGui 

-- 3. MAIN CONTAINER
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 260, 0, 300)
frame.Position = UDim2.new(0, 10, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.ZIndex = 10 -- Ensures it layers over other CoreGui elements
frame.Parent = gui

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 2)
layout.Parent = frame

-- 4. CLOSE BUTTON
local close = Instance.new("TextButton")
close.Text = "CLOSE OVERLAY"
close.Size = UDim2.new(1, 0, 0, 30)
close.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.SourceSansBold
close.TextSize = 18
close.ZIndex = 11
close.Parent = frame

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- 5. LABELS SETUP
local floorLabel = Instance.new("TextLabel")
floorLabel.Size = UDim2.new(1, 0, 0, 35)
floorLabel.BackgroundTransparency = 1
floorLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
floorLabel.Font = Enum.Font.SourceSansBold
floorLabel.TextSize = 22
floorLabel.Text = "Floor: Init..."
floorLabel.ZIndex = 11
floorLabel.Parent = frame

local roomLabel = Instance.new("TextLabel")
roomLabel.Size = UDim2.new(1, 0, 0, 35)
roomLabel.BackgroundTransparency = 1
roomLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
roomLabel.Font = Enum.Font.SourceSansBold
roomLabel.TextSize = 20
roomLabel.Text = "Room: Init..."
roomLabel.ZIndex = 11
roomLabel.Parent = frame

local monsterLabels = {}
for i = 1, 6 do
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 25)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(255, 100, 100)
    l.Font = Enum.Font.SourceSansItalic
    l.TextSize = 18
    l.Text = ""
    l.ZIndex = 11
    l.Parent = frame
    table.insert(monsterLabels, l)
end

-- 6. UPDATE LOGIC
local function update()
    -- FLOOR SEARCH (Based on your path: PlayerGui -> ScreenGui -> Menu -> FloorNumber)
    local floorText = "Floor: ???"
    local success, err = pcall(function()
        local sg = playerGui:FindFirstChild("ScreenGui")
        local menu = sg and sg:FindFirstChild("Menu")
        local fn = menu and menu:FindFirstChild("FloorNumber")
        if fn then
            floorText = "Floor: " .. tostring(fn.Text)
        end
    end)
    floorLabel.Text = floorText

    -- ROOM & MONSTER SEARCH
    local roomName = "Room: Not Found"
    -- Clear current monster list
    for _, ml in pairs(monsterLabels) do ml.Text = "" end

    local currentRoom = workspace:FindFirstChild("CurrentRoom")
    if currentRoom then
        local roomModel = currentRoom:FindFirstChildOfClass("Model")
        if roomModel then
            roomName = "Room: " .. roomModel.Name
            
            local monstersFolder = roomModel:FindFirstChild("Monsters")
            if monstersFolder then
                local enemies = monstersFolder:GetChildren()
                if #enemies > 0 then
                    for i, enemy in ipairs(enemies) do
                        if monsterLabels[i] then
                            monsterLabels[i].Text = "! " .. enemy.Name
                        end
                    end
                else
                    monsterLabels[1].Text = "No Monsters"
                end
            end
        end
    end
    roomLabel.Text = roomName
end

-- Use Heartbeat so it updates even when the frame-rate is capped or rendering is toggled
RunService.Heartbeat:Connect(function()
    pcall(update)
end)
