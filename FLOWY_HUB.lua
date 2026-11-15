
-- FLOWY HUB V0.2 | EXTWIN ESTUDIO
-- Sem Key

local player = game:GetService("Players").LocalPlayer
local autoFarm = false
local selectedWeapon = "Melee"
local weapons = {"Melee", "Sword", "Gun", "Blox Fruit"}
local index = 1

local gui = Instance.new("ScreenGui")
gui.Name = "FLOWY_HUB"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(320,245)
frame.Position = UDim2.new(0.5,-160,0.5,-122)
frame.BackgroundColor3 = Color3.fromRGB(18,12,28)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,55)
title.BackgroundTransparency = 1
title.Text = "FLOWY HUB\nEXTWIN ESTUDIO"
title.TextColor3 = Color3.fromRGB(183,122,255)
title.TextSize = 20

local function button(text,y)
    local b = Instance.new("TextButton",frame)
    b.Size = UDim2.new(0.9,0,0,38)
    b.Position = UDim2.new(0.05,0,0,y)
    b.BackgroundColor3 = Color3.fromRGB(65,30,105)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 15
    b.Text = text
    Instance.new("UICorner",b)
    return b
end

local weapon = button("Select Weapon: Melee",60)
local farm = button("Auto Farm: OFF",105)
local stop = button("Stop All",150)
local close = button("Close",195)

weapon.Activated:Connect(function()
    index = index % #weapons + 1
    selectedWeapon = weapons[index]
    weapon.Text = "Select Weapon: "..selectedWeapon
end)

farm.Activated:Connect(function()
    autoFarm = not autoFarm
    farm.Text = "Auto Farm: "..(autoFarm and "ON" or "OFF")
end)

stop.Activated:Connect(function()
    autoFarm = false
    farm.Text = "Auto Farm: OFF"
end)

close.Activated:Connect(function()
    autoFarm = false
    gui:Destroy()
end)

task.spawn(function()
    while gui.Parent do
        task.wait(0.2)

        if autoFarm then
            local success,err = pcall(function()
                local char = player.Character
                if not char then return end

                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                local enemies = workspace:FindFirstChild("Enemies")

                if not hum or not root or not enemies or hum.Health <= 0 then
                    return
                end

                for _,tool in ipairs(player.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.ToolTip == selectedWeapon then
                        hum:EquipTool(tool)
                        break
                    end
                end

                local target
                local distance = math.huge

                for _,npc in ipairs(enemies:GetChildren()) do
                    local nh = npc:FindFirstChildOfClass("Humanoid")
                    local nr = npc:FindFirstChild("HumanoidRootPart")

                    if nh and nr and nh.Health > 0 then
                        local d = (root.Position-nr.Position).Magnitude

                        if d < distance then
                            distance = d
                            target = nr
                        end
                    end
                end

                if target then
                    hum:MoveTo(target.Position)
                    local tool = char:FindFirstChildOfClass("Tool")

                    if tool and tool.ToolTip == selectedWeapon and distance < 10 then
                        tool:Activate()
                    end
                end
            end)

            if not success then
                warn("[FLOWY HUB]",err)
            end
        end
    end
end)
