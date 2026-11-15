-- FLOWY HUB | EXTWIN ESTUDIO
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "FlowyHub"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(300, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(24, 15, 35)
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 55)
title.BackgroundTransparency = 1
title.Text = "FLOWY HUB"
title.TextSize = 26
title.TextColor3 = Color3.fromRGB(183, 122, 255)

local key = Instance.new("TextBox", frame)
key.Size = UDim2.new(0.9, 0, 0, 40)
key.Position = UDim2.fromScale(0.05, 0.4)
key.PlaceholderText = "Insira sua Key"
key.Text = ""

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.9, 0, 0, 40)
button.Position = UDim2.fromScale(0.05, 0.7)
button.BackgroundColor3 = Color3.fromRGB(110, 55, 175)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "Validar Key"
button.Activated:Connect(function()
    button.Text = "Autenticacao pendente"
end)
