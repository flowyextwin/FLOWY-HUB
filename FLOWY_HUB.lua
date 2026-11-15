-- FLOWY HUB V0.3 | EXTWIN ESTUDIO
local player = game:GetService("Players").LocalPlayer

local config = {
    AutoFarm = false,
    AutoClick = false,
    Weapon = "Melee",
    Distance = 8,
    Speed = 32,
    ClickDelay = 0.01,
    Recovery = true
}

local gui = Instance.new("ScreenGui")
gui.Name = "FLOWY_HUB"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(320, 340)
frame.Position = UDim2.new(0.5,-160,0.5,-170)
frame.BackgroundColor3 = Color3.fromRGB(18,12,28)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "FLOWY HUB\nEXTWIN ESTUDIO"
title.TextColor3 = Color3.fromRGB(183,122,255)
title.TextSize = 20

local function button(text,y)
    local b = Instance.new("TextButton",frame)
    b.Size = UDim2.new(0.9,0,0,32)
    b.Position = UDim2.new(0.05,0,0,y)
    b.BackgroundColor3 = Color3.fromRGB(65,30,105)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 14
    b.Text = text
    Instance.new("UICorner",b)
    return b
end

local weapons = {"Melee","Sword","Gun","Blox Fruit"}
local index = 1

local weapon = button("Select Weapon: Melee",55)
local farm = button("Auto Farm: OFF",95)
local click = button("Auto Click: OFF",135)
local distance = button("Distance: 8",175)
local speed = button("Speed: 32",215)
local stop = button("Stop All",255)
local close = button("Close",295)

weapon.Activated:Connect(function()
    index = index % #weapons + 1
    config.Weapon = weapons[index]
    weapon.Text = "Select Weapon: "..config.Weapon
end)

farm.Activated:Connect(function()
    config.AutoFarm = not config.AutoFarm
    farm.Text = "Auto Farm: "..(config.AutoFarm and "ON" or "OFF")
end)

click.Activated:Connect(function()
    config.AutoClick = not config.AutoClick
    click.Text = "Auto Click: "..(config.AutoClick and "ON" or "OFF")
end)

distance.Activated:Connect(function()
    config.Distance = config.Distance + 2
    if config.Distance > 30 then
        config.Distance = 4
    end
    distance.Text = "Distance: "..config.Distance
end)

speed.Activated:Connect(function()
    config.Speed = config.Speed + 16
    if config.Speed > 160 then
        config.Speed = 16
    end
    speed.Text = "Speed: "..config.Speed
end)

local originalSpeeds = {}

local function stopAll()
    config.AutoFarm = false
    config.AutoClick = false
    farm.Text = "Auto Farm: OFF"
    click.Text = "Auto Click: OFF"

    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:MoveTo(char:GetPivot().Position)
        if originalSpeeds[hum] then
            hum.WalkSpeed = originalSpeeds[hum]
        end
    end
end

stop.Activated:Connect(stopAll)

close.Activated:Connect(function()
    stopAll()
    gui:Destroy()
end)

local function equip(char,hum)
    for _,tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == config.Weapon then
            return tool
        end
    end

    for _,tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == config.Weapon then
            hum:EquipTool(tool)
            return tool
        end
    end
end

local function findNPC(root)
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return end

    local target
    local nearest = math.huge

    for _,npc in ipairs(enemies:GetChildren()) do
        local h = npc:FindFirstChildOfClass("Humanoid")
        local r = npc:FindFirstChild("HumanoidRootPart")

        if h and r and h.Health > 0 then
            local d = (root.Position-r.Position).Magnitude
            if d < nearest then
                nearest = d
                target = r
            end
        end
    end

    return target
end

task.spawn(function()
    while gui.Parent do
        task.wait(config.ClickDelay)

        local ok,err = pcall(function()
            local char = player.Character
            if not char then return end

            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")

            if not hum or not root or hum.Health <= 0 then
                return
            end

            if not config.AutoFarm and not config.AutoClick then
                return
            end

            if config.Recovery and hum.Health < hum.MaxHealth * 0.3 then
                hum:MoveTo(root.Position)
                return
            end

            local tool = equip(char,hum)

            if config.AutoFarm then
                originalSpeeds[hum] = originalSpeeds[hum] or hum.WalkSpeed
                hum.WalkSpeed = config.Speed

                local npc = findNPC(root)
                if npc then
                    local offset = root.Position - npc.Position

                    if offset.Magnitude > 0.1 then
                        local position = npc.Position +
                            offset.Unit * config.Distance

                        hum:MoveTo(position)
                    end

                    if tool and offset.Magnitude <= 10 then
                        tool:Activate()
                    end
                end
            elseif config.AutoClick and tool then
                tool:Activate()
            end
        end)

        if not ok then
            warn("[FLOWY HUB]",err)
            task.wait(1)
        end
    end
end)
