--!strict
-- THE FOREST | LOBBY BUILDER 1.0
-- Paste the complete file into Roblox Studio > View > Command Bar.
-- Re-runnable: replaces ONLY Workspace.THE_FOREST_LOBBY.
-- Does not edit Lighting, Terrain, or any other game systems outside this folder.

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local ROOT_NAME = "THE_FOREST_LOBBY"
local old = Workspace:FindFirstChild(ROOT_NAME)
if old then old:Destroy() end

local root = Instance.new("Folder")
root.Name = ROOT_NAME
root.Parent = Workspace

local function group(name: string): Folder
	local f = Instance.new("Folder")
	f.Name = name
	f.Parent = root
	return f
end

local G = {
	Ground = group("01_Ground_And_Paths"),
	Fence = group("02_Palisade_And_Gate"),
	Shop = group("03_Supply_Shop"),
	Queues = group("04_Rectangular_Queue_Pads"),
	Camp = group("05_Campfire_Center"),
	Props = group("06_Props_And_Lanterns"),
	Nature = group("07_Forest_And_Nature"),
	Spawn = group("08_Player_Spawn"),
	Signs = group("09_Signs"),
}

local C = {
	Grass = Color3.fromRGB(75, 99, 61),
	Dirt = Color3.fromRGB(104, 83, 59),
	Stone = Color3.fromRGB(116, 112, 99),
	StoneDark = Color3.fromRGB(76, 78, 70),
	Wood = Color3.fromRGB(105, 69, 43),
	WoodLight = Color3.fromRGB(145, 101, 61),
	WoodDark = Color3.fromRGB(57, 39, 29),
	Leaf1 = Color3.fromRGB(43, 91, 48),
	Leaf2 = Color3.fromRGB(55, 108, 57),
	Leaf3 = Color3.fromRGB(34, 73, 43),
	Gold = Color3.fromRGB(255, 190, 93),
}

local function part(parent: Instance, name: string, size: Vector3, cf: CFrame, color: Color3, material: Enum.Material?, shape: Enum.PartType?)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.CFrame = cf
	p.Anchored = true
	p.Color = color
	p.Material = material or Enum.Material.Wood
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Shape = shape or Enum.PartType.Block
	p.Parent = parent
	return p
end

local function box(parent: Instance, name: string, pos: Vector3, size: Vector3, color: Color3, material: Enum.Material?, rot: Vector3?)
	local r = rot or Vector3.zero
	return part(parent, name, size,
		CFrame.new(pos) * CFrame.Angles(math.rad(r.X), math.rad(r.Y), math.rad(r.Z)),
		color, material)
end

local function orb(parent: Instance, name: string, pos: Vector3, size: Vector3, color: Color3, material: Enum.Material?)
	return part(parent, name, size, CFrame.new(pos), color, material, Enum.PartType.Ball)
end

local function cylinder(parent: Instance, name: string, pos: Vector3, size: Vector3, color: Color3, rot: Vector3?)
	local r = rot or Vector3.zero
	return part(parent, name, size, CFrame.new(pos) * CFrame.Angles(math.rad(r.X), math.rad(r.Y), math.rad(r.Z)), color, Enum.Material.Wood, Enum.PartType.Cylinder)
end

local function addPointLight(parent: Instance, color: Color3, brightness: number, range: number)
	local l = Instance.new("PointLight")
	l.Color = color
	l.Brightness = brightness
	l.Range = range
	l.Shadows = true
	l.Parent = parent
	return l
end

local function surfaceText(parent: BasePart, face: Enum.NormalId, text: string, color: Color3, font: Enum.Font?)
	local gui = Instance.new("SurfaceGui")
	gui.Name = "ReadableSign"
	gui.Face = face
	gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	gui.PixelsPerStud = 45
	gui.LightInfluence = 0
	gui.Parent = parent
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color
	label.TextScaled = true
	label.Font = font or Enum.Font.GothamBold
	label.Parent = gui
	return gui
end

local function makeLantern(parent: Instance, pos: Vector3, height: number)
	box(parent, "Lantern_Post", pos + Vector3.new(0, height/2, 0), Vector3.new(0.65, height, 0.65), C.WoodDark, Enum.Material.Wood)
	box(parent, "Lantern_Arm", pos + Vector3.new(0.7, height - 0.6, 0), Vector3.new(1.7, 0.3, 0.3), C.WoodDark, Enum.Material.Wood)
	local glow = orb(parent, "Warm_Lantern", pos + Vector3.new(1.35, height - 1.4, 0), Vector3.new(1.15, 1.15, 1.15), C.Gold, Enum.Material.Neon)
	addPointLight(glow, C.Gold, 1.25, 19)
	box(parent, "Lantern_Cap", pos + Vector3.new(1.35, height - 0.75, 0), Vector3.new(1.55, 0.25, 1.55), C.WoodDark, Enum.Material.Wood)
end

-- DAYTIME LOOK: changes only the global lighting values, not other game objects.
Lighting.ClockTime = 10.2
Lighting.Brightness = 2.15
Lighting.GlobalShadows = true
Lighting.Ambient = Color3.fromRGB(112, 119, 104)
Lighting.OutdoorAmbient = Color3.fromRGB(153, 165, 145)
Lighting.FogColor = Color3.fromRGB(174, 194, 178)
Lighting.FogStart = 260
Lighting.FogEnd = 720
Lighting.EnvironmentDiffuseScale = 0.45
Lighting.EnvironmentSpecularScale = 0.35

-- LAND: 220 x 190 fenced compound.
box(G.Ground, "Outer_Grassland", Vector3.new(0, -1.3, 0), Vector3.new(230, 2, 200), C.Grass, Enum.Material.Grass)
box(G.Ground, "Courtyard_Base", Vector3.new(0, -0.05, 0), Vector3.new(166, 0.5, 142), C.Dirt, Enum.Material.Ground)
box(G.Ground, "Courtyard_Stone_Center", Vector3.new(0, 0.18, 9), Vector3.new(105, 0.32, 91), C.Stone, Enum.Material.Cobblestone)

-- Main paths, laid as broad stone sections.
box(G.Ground, "Main_Path_To_Gate", Vector3.new(0, 0.39, 58), Vector3.new(13, 0.22, 34), C.Stone, Enum.Material.Cobblestone)
box(G.Ground, "Main_Path_To_Shop", Vector3.new(-42, 0.39, -25), Vector3.new(34, 0.22, 9), C.Stone, Enum.Material.Cobblestone)
box(G.Ground, "Cross_Path_Left", Vector3.new(-43, 0.39, 13), Vector3.new(9, 0.22, 52), C.Stone, Enum.Material.Cobblestone)
box(G.Ground, "Cross_Path_Right", Vector3.new(43, 0.39, 13), Vector3.new(9, 0.22, 52), C.Stone, Enum.Material.Cobblestone)

-- Cobble edging around courtyard.
for x = -53, 53, 4 do
	box(G.Ground, "Courtyard_Edge_Front", Vector3.new(x, 0.42, 55), Vector3.new(3.6, 0.24, 0.8), C.StoneDark, Enum.Material.Slate)
	box(G.Ground, "Courtyard_Edge_Back", Vector3.new(x, 0.42, -37), Vector3.new(3.6, 0.24, 0.8), C.StoneDark, Enum.Material.Slate)
end
for z = -33, 51, 4 do
	box(G.Ground, "Courtyard_Edge_Left", Vector3.new(-54, 0.42, z), Vector3.new(0.8, 0.24, 3.6), C.StoneDark, Enum.Material.Slate)
	box(G.Ground, "Courtyard_Edge_Right", Vector3.new(54, 0.42, z), Vector3.new(0.8, 0.24, 3.6), C.StoneDark, Enum.Material.Slate)
end

-- PALISADE: continuous perimeter, opening at front for the gate.
local fenceY = 5
local fenceHeight = 9
local fenceZ = 88
local fenceX = 104

local function fenceRunX(z: number, x1: number, x2: number)
	for x = x1, x2, 3.1 do
		local h = fenceHeight + ((math.floor((x-x1)/3.1) % 3 == 0) and 0.7 or 0)
		box(G.Fence, "Palisade_Picket", Vector3.new(x, h/2, z), Vector3.new(0.9, h, 1.05), C.Wood, Enum.Material.Wood)
		box(G.Fence, "Picket_Point", Vector3.new(x, h + 0.08, z), Vector3.new(0.9, 0.35, 1.05), C.WoodLight, Enum.Material.Wood, Vector3.new(0,0,45))
	end
	local mid = (x1+x2)/2
	box(G.Fence, "Upper_Rail", Vector3.new(mid, 6.8, z), Vector3.new(x2-x1+2, 0.65, 1.2), C.WoodDark, Enum.Material.WoodPlanks)
	box(G.Fence, "Lower_Rail", Vector3.new(mid, 2.3, z), Vector3.new(x2-x1+2, 0.55, 1.2), C.WoodDark, Enum.Material.WoodPlanks)
end

local function fenceRunZ(x: number, z1: number, z2: number)
	for z = z1, z2, 3.1 do
		local h = fenceHeight + ((math.floor((z-z1)/3.1) % 3 == 0) and 0.7 or 0)
		box(G.Fence, "Palisade_Picket", Vector3.new(x, h/2, z), Vector3.new(1.05, h, 0.9), C.Wood, Enum.Material.Wood)
		box(G.Fence, "Picket_Point", Vector3.new(x, h + 0.08, z), Vector3.new(1.05, 0.35, 0.9), C.WoodLight, Enum.Material.Wood, Vector3.new(45,0,0))
	end
	local mid = (z1+z2)/2
	box(G.Fence, "Upper_Rail", Vector3.new(x, 6.8, mid), Vector3.new(1.2, 0.65, z2-z1+2), C.WoodDark, Enum.Material.WoodPlanks)
	box(G.Fence, "Lower_Rail", Vector3.new(x, 2.3, mid), Vector3.new(1.2, 0.55, z2-z1+2), C.WoodDark, Enum.Material.WoodPlanks)
end

fenceRunX(-fenceZ, -fenceX, fenceX)
fenceRunZ(-fenceX, -fenceZ, fenceZ)
fenceRunZ(fenceX, -fenceZ, fenceZ)
fenceRunX(fenceZ, -fenceX, -15)
fenceRunX(fenceZ, 15, fenceX)

-- Reinforced entrance posts and gate.
for _, x in ipairs({-15, 15}) do
	box(G.Fence, "Gate_Tower_Post", Vector3.new(x, 6, fenceZ), Vector3.new(3.5, 12, 3.5), C.WoodDark, Enum.Material.Wood)
	box(G.Fence, "Gate_Tower_Cap", Vector3.new(x, 12.4, fenceZ), Vector3.new(5, 1, 5), C.WoodLight, Enum.Material.WoodPlanks)
	makeLantern(G.Fence, Vector3.new(x + (x < 0 and 1.5 or -1.5), 0, fenceZ-2), 8)
end
box(G.Fence, "Gate_Header", Vector3.new(0, 12, fenceZ), Vector3.new(33, 2, 3), C.WoodDark, Enum.Material.WoodPlanks)
box(G.Fence, "Gate_Left_Leaf", Vector3.new(-7.2, 3.8, fenceZ), Vector3.new(13.5, 7.5, 1.2), C.Wood, Enum.Material.WoodPlanks)
box(G.Fence, "Gate_Right_Leaf", Vector3.new(7.2, 3.8, fenceZ), Vector3.new(13.5, 7.5, 1.2), C.Wood, Enum.Material.WoodPlanks)
for x = -12, 12, 3 do
	box(G.Fence, "Gate_Iron_Brace", Vector3.new(x, 3.8, fenceZ-0.7), Vector3.new(0.25, 7.4, 0.2), Color3.fromRGB(48,48,43), Enum.Material.Metal)
end
local gateSign = box(G.Signs, "Main_Entrance_Sign", Vector3.new(0, 14.5, fenceZ-1.8), Vector3.new(20, 3, 0.6), C.WoodDark, Enum.Material.WoodPlanks)
surfaceText(gateSign, Enum.NormalId.Front, "THE FOREST", Color3.fromRGB(255, 220, 158), Enum.Font.Fantasy)

-- WATCH POSTS at corners.
for _, pos in ipairs({Vector3.new(-99,0,-83), Vector3.new(99,0,-83), Vector3.new(-99,0,83), Vector3.new(99,0,83)}) do
	box(G.Fence, "Corner_Watch_Post", pos + Vector3.new(0,6,0), Vector3.new(5,12,5), C.WoodDark, Enum.Material.Wood)
	box(G.Fence, "Watch_Platform", pos + Vector3.new(0,12.5,0), Vector3.new(8,1,8), C.WoodLight, Enum.Material.WoodPlanks)
	box(G.Fence, "Watch_Roof", pos + Vector3.new(0,16,0), Vector3.new(9,1,9), C.WoodDark, Enum.Material.WoodPlanks)
end

-- SHOP BUILDING: detailed trading post with open front and interior.
local sx, sz = -48, -57
box(G.Shop, "Shop_Foundation", Vector3.new(sx,0.8,sz), Vector3.new(43,1.2,28), C.WoodDark, Enum.Material.WoodPlanks)
box(G.Shop, "Shop_Floor", Vector3.new(sx,1.5,sz), Vector3.new(41,0.35,26), C.WoodLight, Enum.Material.WoodPlanks)
box(G.Shop, "Shop_Back_Wall", Vector3.new(sx,9,sz-13), Vector3.new(41,15,1), C.Wood, Enum.Material.WoodPlanks)
box(G.Shop, "Shop_Left_Wall", Vector3.new(sx-20.5,9,sz), Vector3.new(1,15,27), C.Wood, Enum.Material.WoodPlanks)
box(G.Shop, "Shop_Right_Wall", Vector3.new(sx+20.5,9,sz), Vector3.new(1,15,27), C.Wood, Enum.Material.WoodPlanks)

for _, x in ipairs({sx-19,sx+19}) do
	box(G.Shop, "Shop_Front_Pillar", Vector3.new(x,8.5,sz+13), Vector3.new(1.8,14,1.8), C.WoodDark, Enum.Material.Wood)
end
box(G.Shop, "Shop_Front_Beam", Vector3.new(sx,15,sz+13), Vector3.new(41,1.8,2), C.WoodDark, Enum.Material.WoodPlanks)

-- Roof: two sloped solid roof panels.
box(G.Shop, "Shop_Roof_Left", Vector3.new(sx-10,17,sz), Vector3.new(24,1.6,32), Color3.fromRGB(59,65,53), Enum.Material.Slate, Vector3.new(0,0,-24))
box(G.Shop, "Shop_Roof_Right", Vector3.new(sx+10,17,sz), Vector3.new(24,1.6,32), Color3.fromRGB(59,65,53), Enum.Material.Slate, Vector3.new(0,0,24))
box(G.Shop, "Shop_Ridge", Vector3.new(sx,21.6,sz), Vector3.new(2,1.4,33), C.WoodDark, Enum.Material.Wood)

-- Front counter and service window.
box(G.Shop, "Shop_Counter_Base", Vector3.new(sx,3.3,sz+8), Vector3.new(31,3.4,3), C.WoodDark, Enum.Material.WoodPlanks)
box(G.Shop, "Shop_Counter_Top", Vector3.new(sx,5.2,sz+8), Vector3.new(33,0.6,3.8), C.WoodLight, Enum.Material.WoodPlanks)
for _, x in ipairs({sx-14,sx+14}) do
	box(G.Shop, "Counter_Support", Vector3.new(x,3.5,sz+8), Vector3.new(1,4,4), C.Wood, Enum.Material.Wood)
end

-- Shelves and stock crates.
for row = 1, 3 do
	local z = sz-8 + row*3
	box(G.Shop, "Back_Shelf", Vector3.new(sx,5+row*2,z), Vector3.new(29,0.5,2), C.WoodDark, Enum.Material.WoodPlanks)
	for col = -4, 4 do
		local x = sx + col*3
		local crate = box(G.Shop, "Shop_Goods_Crate", Vector3.new(x,6+row*2,z), Vector3.new(1.8,1.7,1.8),
			(row+col)%2 == 0 and Color3.fromRGB(130,91,53) or Color3.fromRGB(83,105,68), Enum.Material.Wood)
	end
end

local shopSign = box(G.Shop, "Shop_Sign_Board", Vector3.new(sx,14,sz+14.3), Vector3.new(23,4,0.8), C.WoodDark, Enum.Material.WoodPlanks)
surfaceText(shopSign, Enum.NormalId.Front, "SUPPLY  •  SHOP", Color3.fromRGB(255,218,150), Enum.Font.Fantasy)

for _, x in ipairs({sx-17,sx+17}) do
	local glow = orb(G.Shop, "Shop_Warm_Lantern", Vector3.new(x,10,sz+14), Vector3.new(1.4,1.4,1.4), C.Gold, Enum.Material.Neon)
	addPointLight(glow, C.Gold, 1.5, 22)
end

-- RECTANGULAR MATCHMAKING PADS.
local function queuePad(name: string, x: number, z: number, title: string, glowColor: Color3)
	local w, d = 23, 16
	box(G.Queues, name.."_Base", Vector3.new(x,0.55,z), Vector3.new(w,0.5,d), Color3.fromRGB(50,61,48), Enum.Material.Slate)
	local t = 0.38
	box(G.Queues, name.."_Outline_Front", Vector3.new(x,0.9,z-d/2), Vector3.new(w,t,t), glowColor, Enum.Material.Neon)
	box(G.Queues, name.."_Outline_Back", Vector3.new(x,0.9,z+d/2), Vector3.new(w,t,t), glowColor, Enum.Material.Neon)
	box(G.Queues, name.."_Outline_Left", Vector3.new(x-w/2,0.9,z), Vector3.new(t,t,d), glowColor, Enum.Material.Neon)
	box(G.Queues, name.."_Outline_Right", Vector3.new(x+w/2,0.9,z), Vector3.new(t,t,d), glowColor, Enum.Material.Neon)
	local board = box(G.Queues, name.."_Sign", Vector3.new(x,4.3,z-d/2-2), Vector3.new(12,3.2,0.65), C.WoodDark, Enum.Material.WoodPlanks)
	surfaceText(board, Enum.NormalId.Front, title, Color3.fromRGB(245,238,208))
end

queuePad("QUEUE_SOLO_DUO", 37, 29, "1 - 2 PLAYERS", Color3.fromRGB(92,235,145))
queuePad("QUEUE_SQUAD", 69, -7, "3 - 4 PLAYERS", Color3.fromRGB(100,190,255))
queuePad("QUEUE_FULL", 37, -36, "5 - 6 PLAYERS", Color3.fromRGB(255,190,90))

-- CAMPFIRE CENTERPIECE.
local cx, cz = -3, 13
for i = 1, 10 do
	local a = math.pi*2*i/10
	orb(G.Camp, "Firepit_Stone", Vector3.new(cx+math.cos(a)*5,0.9,cz+math.sin(a)*5),
		Vector3.new(2.2,1.4,2.2), C.StoneDark, Enum.Material.Rock)
end
box(G.Camp, "Fire_Log_A", Vector3.new(cx,1.3,cz), Vector3.new(8,1.1,1.2), C.WoodDark, Enum.Material.Wood, Vector3.new(0,0,12))
box(G.Camp, "Fire_Log_B", Vector3.new(cx,1.5,cz), Vector3.new(7,1.1,1.2), C.Wood, Enum.Material.Wood, Vector3.new(0,0,-15))
local fire = orb(G.Camp, "Campfire_Glow", Vector3.new(cx,3.1,cz), Vector3.new(2.8,3.8,2.8), Color3.fromRGB(255,125,39), Enum.Material.Neon)
addPointLight(fire, Color3.fromRGB(255,145,65), 2.5, 32)

for i = 1, 6 do
	local a = math.pi*2*i/6
	local x, z = cx+math.cos(a)*12, cz+math.sin(a)*12
	box(G.Camp, "Camp_Bench_Seat", Vector3.new(x,1.7,z), Vector3.new(6,0.7,2), C.WoodLight, Enum.Material.WoodPlanks, Vector3.new(0,-i*60,0))
	box(G.Camp, "Camp_Bench_Leg_A", Vector3.new(x-1.8,0.9,z), Vector3.new(0.6,1.5,0.6), C.WoodDark, Enum.Material.Wood)
	box(G.Camp, "Camp_Bench_Leg_B", Vector3.new(x+1.8,0.9,z), Vector3.new(0.6,1.5,0.6), C.WoodDark, Enum.Material.Wood)
end

-- PROPS: barrels, crates, signposts, lanterns.
for i = 1, 10 do
	local x = -75 + (i%5)*8
	local z = 35 + math.floor(i/5)*7
	box(G.Props, "Supply_Crate", Vector3.new(x,1.5,z), Vector3.new(3,3,3), Color3.fromRGB(122,83,48), Enum.Material.WoodPlanks)
	box(G.Props, "Crate_Band", Vector3.new(x,1.5,z-1.55), Vector3.new(3.1,0.25,0.2), C.WoodDark, Enum.Material.Wood)
end

for i = 1, 4 do
	local x = 76
	local z = -45 + i*9
	cylinder(G.Props, "Barrel", Vector3.new(x,2,z), Vector3.new(3.4,4,3.4), Color3.fromRGB(94,63,39), Vector3.new(0,0,90))
end

for _, pos in ipairs({
	Vector3.new(-65,0,48), Vector3.new(65,0,48),
	Vector3.new(-65,0,-28), Vector3.new(65,0,-28),
	Vector3.new(-25,0,66), Vector3.new(25,0,66),
	Vector3.new(-25,0,-66), Vector3.new(25,0,-66),
}) do
	makeLantern(G.Props, pos, 7)
end

-- FOREST: perimeter trees only, with visible trunks rooted at ground.
local rng = Random.new(1701)
local function makeTree(x: number, z: number, scale: number)
	local h = 16*scale
	local w = 2.4*scale
	local lean = rng:NextNumber(-5,5)
	box(G.Nature, "Tree_Trunk", Vector3.new(x,h/2,z), Vector3.new(w,h,w), Color3.fromRGB(83,54,35), Enum.Material.Wood, Vector3.new(lean,0,lean/2))

	for n = 1, 4 do
		local a = math.pi*2*n/4
		local rx = x + math.cos(a)*2.5*scale
		local rz = z + math.sin(a)*2.5*scale
		box(G.Nature, "Tree_Root", Vector3.new(rx,0.6*scale,rz), Vector3.new(1.4*scale,1.2*scale,5*scale),
			Color3.fromRGB(75,48,31), Enum.Material.Wood, Vector3.new(0,-n*90,12))
	end

	for n = 1, 3 do
		local a = math.pi*2*n/3
		local bx = x + math.cos(a)*2.5*scale
		local bz = z + math.sin(a)*2.5*scale
		box(G.Nature, "Tree_Branch", Vector3.new(bx,h*0.73,bz), Vector3.new(1.2*scale,6*scale,1.2*scale),
			Color3.fromRGB(75,48,31), Enum.Material.Wood, Vector3.new(0,-n*120,35))
	end

	local leaf = ({C.Leaf1,C.Leaf2,C.Leaf3})[rng:NextInteger(1,3)]
	local top = h + 3.8*scale
	orb(G.Nature, "Tree_Crown_Main", Vector3.new(x,top,z), Vector3.new(10,9,10)*scale, leaf, Enum.Material.Grass)
	for n = 1, 5 do
		local a = math.pi*2*n/5
		orb(G.Nature, "Tree_Crown_Cluster",
			Vector3.new(x+math.cos(a)*4*scale,top-1.5*scale,z+math.sin(a)*4*scale),
			Vector3.new(7,7,7)*scale, leaf, Enum.Material.Grass)
	end
end

-- Forest wall behind the fence. No trees inside the main courtyard.
for i = 1, 76 do
	local side = i%4
	local x, z
	if side == 0 then
		x, z = rng:NextNumber(-112,112), rng:NextNumber(-113,-99)
	elseif side == 1 then
		x, z = rng:NextNumber(-112,112), rng:NextNumber(99,113)
	elseif side == 2 then
		x, z = rng:NextNumber(-113,-101), rng:NextNumber(-98,98)
	else
		x, z = rng:NextNumber(101,113), rng:NextNumber(-98,98)
	end
	makeTree(x,z,rng:NextNumber(0.8,1.35))
end

-- Undergrowth and scattered rocks outside fence.
for i = 1, 100 do
	local side = i%4
	local x, z
	if side == 0 then
		x, z = rng:NextNumber(-115,115), rng:NextNumber(-119,-101)
	elseif side == 1 then
		x, z = rng:NextNumber(-115,115), rng:NextNumber(101,119)
	elseif side == 2 then
		x, z = rng:NextNumber(-119,-103), rng:NextNumber(-100,100)
	else
		x, z = rng:NextNumber(103,119), rng:NextNumber(-100,100)
	end
	orb(G.Nature, "Forest_Bush", Vector3.new(x,0.9,z),
		Vector3.new(rng:NextNumber(2,5),rng:NextNumber(1.4,3),rng:NextNumber(2,5)),
		C.Leaf3, Enum.Material.Grass)
end

for i = 1, 45 do
	local x = rng:NextNumber(-115,115)
	local z = rng:NextNumber(-120,120)
	if math.abs(x)>104 or math.abs(z)>94 then
		orb(G.Nature, "Forest_Rock", Vector3.new(x,0.7,z),
			Vector3.new(rng:NextNumber(2,5),rng:NextNumber(1,3),rng:NextNumber(2,5)),
			Color3.fromRGB(91,96,83), Enum.Material.Rock)
	end
end

-- SPAWN: invisible neutral spawn inside the gate.
local spawn = Instance.new("SpawnLocation")
spawn.Name = "LobbySpawn"
spawn.Size = Vector3.new(8,1,8)
spawn.CFrame = CFrame.new(0,0.7,68)
spawn.Anchored = true
spawn.Transparency = 1
spawn.CanCollide = true
spawn.Neutral = true
spawn.Duration = 0
spawn.Parent = G.Spawn

print("================================================")
print("THE FOREST | LOBBY BUILDER 1.0 COMPLETE")
print("Created: fenced compound, gate, shop, queue pads, campfire, forest.")
print("Only Workspace.THE_FOREST_LOBBY was replaced.")
print("================================================")
