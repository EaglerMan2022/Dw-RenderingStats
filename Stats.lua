-- Main Frame (centered)
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 350, 0, 400)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.Parent = gui

-- 🔹 DRAG BAR (separate, NOT affected by layout)
local dragBar = Instance.new("Frame")
dragBar.Size = UDim2.new(1, 0, 0, 30)
dragBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dragBar.BorderSizePixel = 0
dragBar.Parent = frame

local dragLabel = Instance.new("TextLabel")
dragLabel.Size = UDim2.new(1, 0, 1, 0)
dragLabel.BackgroundTransparency = 1
dragLabel.Text = "DRAG HERE"
dragLabel.TextColor3 = Color3.new(1,1,1)
dragLabel.Font = Enum.Font.SourceSansBold
dragLabel.TextSize = 18
dragLabel.Parent = dragBar

-- 🔹 CONTENT FRAME (this is what layout controls)
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -30) -- below drag bar
content.Position = UDim2.new(0, 0, 0, 30)
content.BackgroundTransparency = 1
content.Parent = frame

-- Layout goes INSIDE content, not frame
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = content
