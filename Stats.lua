local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Destroy old UI
if CoreGui:FindFirstChild("OverlayUI") then
    CoreGui.OverlayUI:Destroy()
end

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "OverlayUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 2147483647
gui.Parent = CoreGui

-- Main Frame (centered)
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 350, 0, 400)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0) -- perfectly center
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.ZIndex = 10
frame.Parent = gui

-- Make draggable from anywhere inside frame
local dragging = false
local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Layout
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = frame

-- Close button
local close = Instance.new("TextButton")
close.Text = "CLOSE OVERLAY"
close.Size = UDim2.new(1, 0, 0, 40)
close.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.SourceSansBold
close.TextSize = 22
close.ZIndex = 11
close.Parent = frame

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Labels
local floorLabel = Instance.new("TextLabel")
floorLabel.Size = UDim2.new(1, 0, 0, 50)
floorLabel.BackgroundTransparency = 1
floorLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
floorLabel.Font = Enum.Font.SourceSansBold
floorLabel.TextSize = 28
floorLabel.Text = "Floor: Init..."
floorLabel.ZIndex = 11
floorLabel.Parent = frame

local roomLabel = Instance.new("TextLabel")
roomLabel.Size = UDim2.new(1, 0, 0, 50)
roomLabel.BackgroundTransparency = 1
roomLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
roomLabel.Font = Enum.Font.SourceSansBold
roomLabel.TextSize = 26
roomLabel.Text = "Room: Init..."
roomLabel.ZIndex = 11
roomLabel.Parent = frame

local monsterLabels = {}
for i = 1, 10 do
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 40)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(255, 100, 100)
    l.Font = Enum.Font.SourceSansItalic
    l.TextSize = 24
    l.Text = ""
    l.ZIndex = 11
    l.Parent = frame
    table.insert(monsterLabels, l)
end

-- Purple and Blue monsters
local purpleMonsters = {
    BassieMonster=true, AstroMonster=true, PebbleMonster=true,
    ShellyMonster=true, VeeMonster=true, SproutMonster=true
}
local blueMonsters = {
    GoobMonster=true, ScrapsMonster=true, GigiMonster=true, SquirmMonster=true,
    BlottMonster=true, CocoaMonster=true, FlutterMonster=true, GlistenMonster=true
}

-- Update logic
local function update()
    -- Floor
    local floorText = "Floor: ???"
    pcall(function()
        local sg = playerGui:FindFirstChild("ScreenGui")
        local menu = sg and sg:FindFirstChild("Menu")
        local fn = menu and menu:FindFirstChild("FloorNumber")
        if fn then
            floorText = "Floor: " .. tostring(fn.Text)
        end
    end)
    floorLabel.Text = floorText

    -- Room & monsters
    local roomName = "Room: Not Found"
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
                            local color
                            if purpleMonsters[enemy.Name] then
                                color = Color3.fromRGB(180, 0, 180)
                            elseif blueMonsters[enemy.Name] then
                                color = Color3.fromRGB(0, 150, 255)
                            else
                                color = Color3.fromRGB(255, 100, 100)
                            end
                            monsterLabels[i].TextColor3 = color
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

RunService.Heartbeat:Connect(function()
    pcall(update)
end)
