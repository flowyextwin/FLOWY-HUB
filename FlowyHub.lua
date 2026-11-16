
-- FLOWY HUB V5.0
-- ADVANCED EDITION
-- Interface de testes para Roblox Studio

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("FlowyHub")
if old then old:Destroy() end

local config = {
    Weapon = "Melee",
    Height = 8,
    CPS = 20,
    Toggles = {}
}

local tabs = {
    {"Main", {
        "Smart Auto Farm",
        "Auto Quest",
        "Auto Mastery",
        "Auto Stats",
        "Auto Boss",
        "Auto Respawn"
    }},
    {"Combat", {
        "Auto Click",
        "Fast Attack",
        "Auto Haki"
    }},
    {"Farm Settings", {
        "Farm Fly",
        "Follow NPC",
        "Damage Check"
    }},
    {"Fruits", {
        "Fruit Finder",
        "Fruit Notifier",
        "Auto Store Fruit"
    }},
    {"Sea Events", {
        "Sea Beast",
        "Terror Shark",
        "Leviathan",
        "Mirage Island"
    }},
    {"Race V4", {
        "Auto Training",
        "Trial System"
    }},
    {"Teleport", {
        "Island Teleport",
        "NPC Teleport"
    }},
    {"Visuals", {
        "Fruit ESP",
        "Chest ESP"
    }},
    {"Settings", {
        "FPS Boost",
        "Save Config",
        "UI Animations"
    }}
}

local purple = Color3.fromRGB(160, 91, 245)
local dark = Color3.fromRGB(16, 13, 22)
local panel = Color3.fromRGB(31, 23, 42)
local white = Color3.fromRGB(240, 235, 250)

local function create(class, parent, props)
    local object = Instance.new(class)
    for key, value in pairs(props or {}) do
        object[key] = value
    end
    object.Parent = parent
    return object
end

local function round(object, radius)
    create("UICorner", object, {
        CornerRadius = UDim.new(0, radius or 8)
    })
end

local gui = create("ScreenGui", playerGui, {
    Name = "FlowyHub",
    ResetOnSpawn = false
})

local window = create("Frame", gui, {
    Size = UDim2.fromOffset(520, 310),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = dark
})

round(window, 12)

create("UIStroke", window, {
    Color = purple,
    Thickness = 1.5
})

local scale = create("UIScale", window, {})

local function resize()
    local camera = workspace.CurrentCamera
    if camera then
        local size = camera.ViewportSize
        scale.Scale = math.min(
            1, (size.X - 24) / 520,
            (size.Y - 30) / 310
        )
    end
end

resize()

if workspace.CurrentCamera then
    workspace.CurrentCamera
        :GetPropertyChangedSignal("ViewportSize")
        :Connect(resize)
end

local function label(parent, text, size, position)
    return create("TextLabel", parent, {
        Size = size,
        Position = position,
        Text = text,
        BackgroundTransparency = 1,
        TextColor3 = white,
        Font = Enum.Font.Gotham,
        TextSize = 13
    })
end

local title = label(window,
    "FLOWY HUB  |  V5.0",
    UDim2.fromOffset(300, 42),
    UDim2.fromOffset(10, 0)
)

title.TextColor3 = purple
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local function button(parent, text, size, position)
    local b = create("TextButton", parent, {
        Size = size,
        Position = position,
        Text = text,
        TextColor3 = white,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        BackgroundColor3 = panel,
        AutoButtonColor = true
    })
    round(b, 7)
    return b
end

local minimize = button(window, "-",
    UDim2.fromOffset(32, 30),
    UDim2.fromOffset(478, 6)
)

local body = create("Frame", window, {
    Size = UDim2.new(1, 0, 1, -45),
    Position = UDim2.fromOffset(0, 45),
    BackgroundTransparency = 1
})

local minimized = false

minimize.Activated:Connect(function()
    minimized = not minimized
    body.Visible = not minimized
    minimize.Text = minimized and "+" or "-"
    window.Size = UDim2.fromOffset(
        520, minimized and 42 or 310
    )
end)

local sidebar = create("ScrollingFrame", body, {
    Size = UDim2.fromOffset(130, 255),
    Position = UDim2.fromOffset(8, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 2,
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y
})

create("UIListLayout", sidebar, {
    Padding = UDim.new(0, 5)
})

local content = create("ScrollingFrame", body, {
    Size = UDim2.fromOffset(360, 217),
    Position = UDim2.fromOffset(150, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y
})

local monitor = label(body, "Active Functions: 0",
    UDim2.fromOffset(220, 30),
    UDim2.fromOffset(145, 225)
)

monitor.TextColor3 = purple

local function updateMonitor()
    local total = 0
    for _, enabled in pairs(config.Toggles) do
        if enabled then total = total + 1 end
    end
    monitor.Text = "Active Functions: " .. total
end

local activeTab = tabs[1][1]
local tabButtons = {}

local function showTab(name)
    activeTab = name
    content:ClearAllChildren()
    content.CanvasPosition = Vector2.new(0, 0)

    create("UIListLayout", content, {
        Padding = UDim.new(0, 6)
    })

    for tabName, b in pairs(tabButtons) do
        b.BackgroundColor3 =
            tabName == name and purple or panel
    end

    local heading = label(content, name,
        UDim2.new(1, -8, 0, 30),
        UDim2.new()
    )

    heading.TextSize = 18
    heading.TextColor3 = purple

    if name == "Main" then
        local weapons = {
            "Melee", "Sword", "Blox Fruit", "Gun"
        }

        local weaponButton = button(content,
            "Weapon: " .. config.Weapon,
            UDim2.new(1, -8, 0, 35),
            UDim2.new()
        )

        weaponButton.Activated:Connect(function()
            local i = table.find(weapons, config.Weapon) or 1
            config.Weapon = weapons[i % #weapons + 1]
            weaponButton.Text = "Weapon: " .. config.Weapon
        end)
    end

    for _, tab in ipairs(tabs) do
        if tab[1] == name then
            for _, feature in ipairs(tab[2]) do
                local b = button(content, "",
                    UDim2.new(1, -8, 0, 35),
                    UDim2.new()
                )

                local function refresh()
                    local enabled = config.Toggles[feature]
                    b.Text = feature ..
                        (enabled and "  |  ON" or "  |  OFF")
                    b.BackgroundColor3 =
                        enabled and purple or panel
                end

                b.Activated:Connect(function()
                    config.Toggles[feature] =
                        not config.Toggles[feature]
                    refresh()
                    updateMonitor()
                end)

                refresh()
            end
        end
    end

    local function numberBox(key, minimum, maximum)
        local box = create("TextBox", content, {
            Size = UDim2.new(1, -8, 0, 35),
            BackgroundColor3 = panel,
            TextColor3 = white,
            TextSize = 14,
            Text = key .. ": " .. config[key],
            ClearTextOnFocus = true
        })

        round(box, 7)

        box.FocusLost:Connect(function()
            config[key] = math.clamp(
                tonumber(box.Text) or config[key],
                minimum, maximum
            )
            box.Text = key .. ": " .. config[key]
        end)
    end

    if name == "Combat" then
        numberBox("CPS", 1, 30)
    elseif name == "Farm Settings" then
        numberBox("Height", 3, 25)
    end
end

for _, tab in ipairs(tabs) do
    local name = tab[1]

    local b = button(sidebar, name,
        UDim2.new(1, -5, 0, 31),
        UDim2.new()
    )

    tabButtons[name] = b

    b.Activated:Connect(function()
        showTab(name)
    end)
end

local stop = button(body, "STOP ALL",
    UDim2.fromOffset(110, 28),
    UDim2.fromOffset(400, 225)
)

stop.BackgroundColor3 = Color3.fromRGB(130, 35, 65)

stop.Activated:Connect(function()
    table.clear(config.Toggles)
    updateMonitor()
    showTab(activeTab)
end)

showTab("Main")

print("[FLOWY HUB V5.0] Interface loaded!")
