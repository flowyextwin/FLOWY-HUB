-- FLOWY HUB | EXTWIN ESTUDIO
-- Interface demonstrativa sem Key
local p = game.Players.LocalPlayer
local pg = p:WaitForChild("PlayerGui")
local old = pg:FindFirstChild("FLOWY_HUB")
if old then old:Destroy() end

local purple = Color3.fromRGB(183,122,255)
local function new(c,parent,props)
    local o = Instance.new(c)
    for k,v in pairs(props) do o[k]=v end
    o.Parent=parent
    return o
end

local gui=new("ScreenGui",pg,{
    Name="FLOWY_HUB",
    ResetOnSpawn=false,
    DisplayOrder=100
})

local hub=new("Frame",gui,{
    Size=UDim2.fromScale(.78,.82),
    Position=UDim2.fromScale(.11,.09),
    BackgroundColor3=Color3.fromRGB(14,9,23),
    ClipsDescendants=true
})
new("UICorner",hub,{CornerRadius=UDim.new(0,12)})
new("UIStroke",hub,{Color=purple,Transparency=.4})

local function button(parent,text,size,pos)
    local b=new("TextButton",parent,{
        Text=text,Size=size,Position=pos,
        BackgroundColor3=Color3.fromRGB(42,25,60),
        BackgroundTransparency=.3,
        TextColor3=Color3.fromRGB(235,220,250),
        Font=Enum.Font.Gotham,
        TextSize=13
    })
    new("UICorner",b,{CornerRadius=UDim.new(0,7)})
    return b
end

local planet=new("Frame",hub,{
    Size=UDim2.fromOffset(230,230),
    Position=UDim2.fromScale(.61,.25),
    BackgroundColor3=purple
})
new("UICorner",planet,{CornerRadius=UDim.new(1,0)})
local gradient=new("UIGradient",planet,{
    Color=ColorSequence.new(
        Color3.fromRGB(90,42,135),
        Color3.fromRGB(15,6,30)
    )
})

local stars={}
for i=1,55 do
    stars[i]=new("Frame",hub,{
        Size=UDim2.fromOffset(2,2),
        Position=UDim2.fromScale(math.random(),math.random()),
        BackgroundColor3=purple,
        BorderSizePixel=0
    })
end

local title=button(hub,"FLOWY HUB",UDim2.new(1,-80,0,38),UDim2.fromOffset(12,4))
title.TextSize=25
title.Font=Enum.Font.GothamBold
title.BackgroundTransparency=1
title.TextColor3=purple

local sub=button(hub,"EXTWIN ✦ ESTUDIO",UDim2.new(1,0,0,23),UDim2.fromOffset(0,40))
sub.BackgroundTransparency=1

local nav=new("ScrollingFrame",hub,{
    Size=UDim2.new(.28,-8,1,-105),
    Position=UDim2.fromOffset(8,68),
    BackgroundTransparency=.5,
    BackgroundColor3=Color3.fromRGB(18,10,28),
    ScrollBarThickness=3,
    AutomaticCanvasSize=Enum.AutomaticSize.Y,
    CanvasSize=UDim2.new()
})
new("UIListLayout",nav,{Padding=UDim.new(0,5)})

local body=new("ScrollingFrame",hub,{
    Size=UDim2.new(.72,-15,1,-105),
    Position=UDim2.new(.28,7,0,68),
    BackgroundTransparency=1,
    ScrollBarThickness=3,
    AutomaticCanvasSize=Enum.AutomaticSize.Y,
    CanvasSize=UDim2.new()
})

local tabs={
    {"Status & Server","Smart Priority","Resume Task"},
    {"Config","Auto Haki","Auto Click","Farm Position"},
    {"Skills","Skill Z","Skill X","Skill C","Skill V","Skill F"},
    {"Main","Auto Farm Level","Auto Mastery","Auto Farm Nearest","Auto Farm Boss","Auto Boss Quest","Auto Second Sea","Auto Third Sea","Secret Quests","Auto Level 3000"},
    {"Stats","Melee","Defense","Sword","Gun","Blox Fruit"},
    {"Sub Farm","Beli","Fragments","Materials","Chests"},
    {"Combat","Combat Settings"},
    {"Weapons","Select Weapon","Weapon Requirements"},
    {"Fighting Style","Select Style","Style Requirements"},
    {"Fruits","Select Fruit","Fruit Mastery"},
    {"Sea Event","Sea Beast","Terror Shark","Leviathan","Boat Settings"},
    {"Island Events","Mirage","Kitsune","Prehistoric"},
    {"Race","Race V2","Race V3","Race V4"},
    {"Raid","Select Raid","Awakening"},
    {"Dungeon","Select Dungeon"},
    {"Fishing","Fishing Settings"},
    {"Dojo","Dojo Quests"},
    {"Shop","Select Item"},
    {"Teleport","Select Island"},
    {"ESP","Visual Settings"},
    {"Quests","Select Quest","Secret Quests"},
    {"Upgrades","Enchantments","Upgrade Items"},
    {"Settings","Planet Rotation","Moving Stars","Pause Effects"}
}

local state={}
local effects=true
local current=tabs[4]

local function render(tab)
    current=tab
    body:ClearAllChildren()
    new("UIGridLayout",body,{
        CellSize=UDim2.new(.48,0,0,42),
        CellPadding=UDim2.new(.02,0,0,6)
    })
    for i=2,#tab do
        local name=tab[i]
        local b=button(body,name,UDim2.new(),UDim2.new())
        local function refresh()
            b.Text=(state[name] and "✓ " or "□ ")..name
            b.TextColor3=state[name] and purple or Color3.new(1,1,1)
        end
        refresh()
        b.Activated:Connect(function()
            state[name]=not state[name]
            if name=="Pause Effects" then
                effects=not state[name]
            end
            refresh()
        end)
    end
end

for _,tab in ipairs(tabs) do
    local b=button(nav,tab[1],UDim2.new(1,-5,0,32),UDim2.new())
    b.Activated:Connect(function() render(tab) end)
end

local stop=button(hub,"Stop All",UDim2.fromOffset(85,28),UDim2.new(1,-95,1,-32))
stop.TextColor3=Color3.fromRGB(255,80,100)
stop.Activated:Connect(function()
    table.clear(state)
    effects=true
    render(current)
end)

local close=button(hub,"X",UDim2.fromOffset(32,30),UDim2.new(1,-39,0,7))
close.Activated:Connect(function() gui:Destroy() end)

render(current)

task.spawn(function()
    while gui.Parent do
        if effects then
            gradient.Rotation=(gradient.Rotation+1)%360
            for i,s in ipairs(stars) do
                s.BackgroundTransparency=(math.sin(os.clock()*2+i)+1)/2
            end
        end
        task.wait(.05)
    end
end)
