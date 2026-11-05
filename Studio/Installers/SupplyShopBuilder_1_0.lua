--!strict
-- THE FOREST | SUPPLY SHOP BUILDER 1.0
-- Install: Roblox Studio > View > Command Bar > paste entire file > Enter.
-- Builds ONLY Workspace.THE_FOREST_LOBBY/03_Supply_Shop.
-- If the main lobby folder does not exist, creates it. Does not touch other lobby folders.
-- Shop location matches LobbyBuilder_1_0: center (-48, 0, -57).

local Workspace = game:GetService("Workspace")

local lobby = Workspace:FindFirstChild("THE_FOREST_LOBBY")
if not lobby then
	lobby = Instance.new("Folder")
	lobby.Name = "THE_FOREST_LOBBY"
	lobby.Parent = Workspace
end

local oldShop = lobby:FindFirstChild("03_Supply_Shop")
if oldShop then oldShop:Destroy() end

local shop = Instance.new("Folder")
shop.Name = "03_Supply_Shop"
shop.Parent = lobby

local ORIGIN = Vector3.new(-48, 0, -57)
local X, Z = ORIGIN.X, ORIGIN.Z

local COLORS = {
	Wood = Color3.fromRGB(105, 69, 43),
	WoodMid = Color3.fromRGB(128, 85, 51),
	WoodLight = Color3.fromRGB(163, 119, 73),
	WoodDark = Color3.fromRGB(54, 38, 29),
	Plank = Color3.fromRGB(119, 81, 50),
	Roof = Color3.fromRGB(54, 63, 52),
	RoofLight = Color3.fromRGB(77, 83, 64),
	Stone = Color3.fromRGB(104, 104, 91),
	StoneLight = Color3.fromRGB(145, 137, 115),
	Metal = Color3.fromRGB(57, 62, 57),
	Gold = Color3.fromRGB(255, 190, 92),
	Glass = Color3.fromRGB(170, 194, 174),
	Cloth = Color3.fromRGB(105, 88, 61),
	Red = Color3.fromRGB(125, 55, 43),
	Green = Color3.fromRGB(65, 103, 64),
}

local function makePart(parent: Instance, name: string, size: Vector3, cf: CFrame, color: Color3, material: Enum.Material?, shape: Enum.PartType?)
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

local function block(name: string, x: number, y: number, z: number, sx: number, sy: number, sz: number, color: Color3, material: Enum.Material?, rx: number?, ry: number?, rz: number?)
	return makePart(shop, name, Vector3.new(sx, sy, sz),
		CFrame.new(x, y, z) * CFrame.Angles(math.rad(rx or 0), math.rad(ry or 0), math.rad(rz or 0)),
		color, material)
end

local function ball(name: string, x: number, y: number, z: number, sx: number, sy: number, sz: number, color: Color3, material: Enum.Material?)
	return makePart(shop, name, Vector3.new(sx, sy, sz), CFrame.new(x, y, z), color, material, Enum.PartType.Ball)
end

local function cylinder(name: string, x: number, y: number, z: number, sx: number, sy: number, sz: number, color: Color3, material: Enum.Material?)
	return makePart(shop, name, Vector3.new(sx, sy, sz), CFrame.new(x, y, z) * CFrame.Angles(0, 0, math.rad(90)), color, material, Enum.PartType.Cylinder)
end

local function pointLight(parent: BasePart, color: Color3, brightness: number, range: number)
	local light = Instance.new("PointLight")
	light.Color = color
	light.Brightness = brightness
	light.Range = range
	light.Shadows = true
	light.Parent = parent
	return light
end

local function signText(board: BasePart, text: string, face: Enum.NormalId, textColor: Color3, font: Enum.Font?)
	local gui = Instance.new("SurfaceGui")
	gui.Name = "ShopSignGui"
	gui.Face = face
	gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	gui.PixelsPerStud = 55
	gui.LightInfluence = 0
	gui.Parent = board

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = textColor
	label.TextStrokeColor3 = Color3.fromRGB(38, 27, 20)
	label.TextStrokeTransparency = 0.35
	label.TextScaled = true
	label.Font = font or Enum.Font.Fantasy
	label.Parent = gui
end

local function lantern(name: string, x: number, y: number, z: number, brightness: number, range: number)
	local frame = block(name .. "_Frame", x, y, z, 1.15, 1.5, 1.15, COLORS.WoodDark, Enum.Material.Wood)
	local glass = ball(name .. "_Glow", x, y - 0.05, z, 0.72, 0.95, 0.72, COLORS.Gold, Enum.Material.Neon)
	pointLight(glass, COLORS.Gold, brightness, range)
	block(name .. "_Top", x, y + 0.82, z, 1.5, 0.22, 1.5, COLORS.Metal, Enum.Material.Metal)
	block(name .. "_Bottom", x, y - 0.82, z, 1.35, 0.18, 1.35, COLORS.Metal, Enum.Material.Metal)
	return frame
end

-- FOUNDATION AND FLOOR
block("Stone_Foundation", X, 0.7, Z, 48, 1.3, 34, COLORS.Stone, Enum.Material.Cobblestone)
block("Timber_Floor", X, 1.48, Z, 46, 0.32, 32, COLORS.WoodMid, Enum.Material.WoodPlanks)

-- Floorboard seams: subtle strips across the room.
for i = -14, 14, 2 do
	block("Floorboard_Seam", X + i, 1.66, Z, 0.08, 0.035, 31, COLORS.WoodDark, Enum.Material.Wood)
end

-- BACK WALL AND SIDE WALLS; FRONT IS AN OPEN TRADING PORCH.
block("Back_Wall_Core", X, 8.7, Z - 15.3, 45, 14, 1.1, COLORS.WoodDark, Enum.Material.WoodPlanks)
block("Left_Wall_Core", X - 22.2, 8.5, Z, 1.1, 13.5, 30, COLORS.Wood, Enum.Material.WoodPlanks)
block("Right_Wall_Core", X + 22.2, 8.5, Z, 1.1, 13.5, 30, COLORS.Wood, Enum.Material.WoodPlanks)

-- Wall cladding: visible horizontal timber courses.
for y = 3, 14, 2 do
	block("Back_Wall_Beam", X, y, Z - 14.55, 45.5, 0.35, 0.55, COLORS.WoodLight, Enum.Material.Wood)
	block("Left_Wall_Beam", X - 21.55, y, Z, 0.55, 0.35, 30, COLORS.WoodLight, Enum.Material.Wood)
	block("Right_Wall_Beam", X + 21.55, y, Z, 0.55, 0.35, 30, COLORS.WoodLight, Enum.Material.Wood)
end

-- Front pillars and cross beams.
for _, dx in ipairs({-21, -10.5, 0, 10.5, 21}) do
	block("Front_Timber_Post", X + dx, 8.4, Z + 15, 1.5, 13.5, 1.5, COLORS.WoodDark, Enum.Material.Wood)
	block("Post_Foot", X + dx, 2.2, Z + 15, 2.2, 1, 2.2, COLORS.Stone, Enum.Material.Cobblestone)
end
block("Front_Header_Beam", X, 15.2, Z + 15, 47, 1.5, 2, COLORS.WoodDark, Enum.Material.Wood)
block("Front_Lower_Rail", X, 3.2, Z + 15, 44, 0.65, 1.1, COLORS.WoodLight, Enum.Material.Wood)

-- ROOF: two broad pitched panels, ridge cap and decorative rafters.
block("Roof_Left_Slope", X - 10.5, 18.2, Z, 27, 1.5, 39, COLORS.Roof, Enum.Material.Slate, 0, 0, 25)
block("Roof_Right_Slope", X + 10.5, 18.2, Z, 27, 1.5, 39, COLORS.Roof, Enum.Material.Slate, 0, 0, -25)
block("Roof_Ridge_Cap", X, 23.7, Z, 3, 1.4, 40, COLORS.WoodDark, Enum.Material.Wood)
for _, dz in ipairs({-17, -10, -3, 4, 11, 18}) do
	block("Roof_Eave_Trim", X, 12.7, Z + dz, 47, 0.65, 0.65, COLORS.WoodDark, Enum.Material.Wood)
end
block("Front_Gable_Fascia", X, 18.5, Z + 16.5, 42, 1, 0.7, COLORS.WoodLight, Enum.Material.Wood)
block("Back_Gable_Fascia", X, 18.5, Z - 16.5, 42, 1, 0.7, COLORS.WoodLight, Enum.Material.Wood)

-- Decorative roof shingles, grouped into visible rows.
for row = 1, 4 do
	local y = 20.8 - row * 1.45
	local offset = row * 2.2
	block("Left_Roof_Shingle_Row", X - 10.5 + offset, y, Z, 23, 0.18, 38, COLORS.RoofLight, Enum.Material.Slate, 0, 0, 25)
	block("Right_Roof_Shingle_Row", X + 10.5 - offset, y, Z, 23, 0.18, 38, COLORS.RoofLight, Enum.Material.Slate, 0, 0, -25)
end

-- FRONT AWNING ABOVE THE SERVICE COUNTER.
block("Awning_Canvas", X, 12.1, Z + 18.2, 42, 0.45, 7, COLORS.Cloth, Enum.Material.Fabric, -8, 0, 0)
for i = -5, 5 do
	local dx = i * 3.7
	block("Awning_Stripe", X + dx, 12.35, Z + 18.3, 1.8, 0.12, 6.8,
		(i % 2 == 0) and COLORS.Red or COLORS.Cloth, Enum.Material.Fabric, -8, 0, 0)
end
for _, dx in ipairs({-19, 19}) do
	block("Awning_Support", X + dx, 8.2, Z + 18.5, 0.55, 8, 0.55, COLORS.WoodDark, Enum.Material.Wood)
end

-- SHOP SIGN, LARGE AND READABLE FROM THE COURTYARD.
local sign = block("Main_Shop_Sign", X, 15.7, Z + 16.2, 25, 4.3, 0.8, COLORS.WoodDark, Enum.Material.WoodPlanks)
signText(sign, "THE FOREST  •  SUPPLIES", Enum.NormalId.Back, Color3.fromRGB(255, 220, 160), Enum.Font.Fantasy)
for _, dx in ipairs({-11, 11}) do
	ball("Sign_Rivet", X + dx, 15.7, Z + 16.68, 0.45, 0.45, 0.18, COLORS.Gold, Enum.Material.Metal)
end

-- SIDE WINDOWS WITH WOODEN FRAMES AND TRANSLUCENT GLASS.
for _, side in ipairs({-1, 1}) do
	local wx = X + side * 22.85
	block("Window_Glass", wx, 9.2, Z - 2.5, 0.22, 5.5, 8, COLORS.Glass, Enum.Material.Glass)
	for _, yy in ipairs({6.3, 12.1}) do
		block("Window_Frame_Horizontal", wx + side * 0.2, yy, Z - 2.5, 0.55, 0.45, 9, COLORS.WoodDark, Enum.Material.Wood)
	end
	for _, zz in ipairs({-7, 2}) do
		block("Window_Frame_Vertical", wx + side * 0.2, 9.2, Z + zz, 0.55, 6, 0.45, COLORS.WoodDark, Enum.Material.Wood)
	end
	block("Window_Crossbar", wx + side * 0.25, 9.2, Z - 2.5, 0.6, 0.35, 8, COLORS.WoodLight, Enum.Material.Wood)
end

-- SERVICE COUNTER: layered timber front, thick countertop and display ledge.
block("Counter_Base", X, 3.7, Z + 7.3, 34, 4.1, 3.2, COLORS.WoodDark, Enum.Material.WoodPlanks)
block("Counter_Front_Panel", X, 3.7, Z + 9, 32, 3.1, 0.25, COLORS.WoodMid, Enum.Material.WoodPlanks)
block("Counter_Top", X, 6.05, Z + 7.1, 36, 0.7, 4.3, COLORS.WoodLight, Enum.Material.WoodPlanks)
block("Counter_Edge_Trim", X, 6.38, Z + 7.1, 36.5, 0.18, 4.5, COLORS.Gold, Enum.Material.Wood)
for dx = -14, 14, 4 do
	block("Counter_Front_Batten", X + dx, 3.8, Z + 9.18, 0.25, 3.2, 0.18, COLORS.WoodLight, Enum.Material.Wood)
end

-- COUNTER DISPLAY: crates, bottles, rolled maps and lantern.
for i = 1, 7 do
	local dx = -14 + (i - 1) * 4.5
	local color = (i % 2 == 0) and COLORS.Green or COLORS.Red
	block("Display_Crate", X + dx, 7.05, Z + 6.5, 2.4, 1.4, 2.2, COLORS.WoodMid, Enum.Material.Wood)
	ball("Display_Goods", X + dx, 8.05, Z + 6.5, 1.25, 1.1, 1.25, color, Enum.Material.SmoothPlastic)
end

-- BACK WALL SHELVING, THREE TIERS, WITH INDIVIDUAL STOCK.
for shelf = 1, 3 do
	local yy = 4.3 + shelf * 2.8
	block("Rear_Shelf_Board", X, yy, Z - 12.8, 35, 0.55, 2, COLORS.WoodLight, Enum.Material.WoodPlanks)
	block("Rear_Shelf_Front_Lip", X, yy + 0.25, Z - 11.8, 35, 0.25, 0.25, COLORS.WoodDark, Enum.Material.Wood)
	for item = 1, 11 do
		local ix = X - 16 + item * 2.9
		local tint = ({COLORS.Green, COLORS.Red, COLORS.WoodLight, COLORS.Gold})[((item + shelf) % 4) + 1]
		if item % 3 == 0 then
			cylinder("Shelf_Jar", ix, yy + 1, Z - 12.7, 0.9, 1.7, 0.9, tint, Enum.Material.Glass)
		else
			block("Shelf_Supply_Box", ix, yy + 0.9, Z - 12.7, 1.5, 1.6, 1.4, tint, Enum.Material.Wood)
		end
	end
end

-- SIDE RACKS AND HANGING EQUIPMENT.
for _, side in ipairs({-1, 1}) do
	local rx = X + side * 18.2
	for shelf = 1, 3 do
		local yy = 4 + shelf * 2.7
		block("Side_Rack_Shelf", rx, yy, Z - 2, 2.2, 0.45, 18, COLORS.WoodLight, Enum.Material.WoodPlanks)
		for j = 1, 4 do
			local rz = Z - 9 + j * 4
			block("Side_Rack_Crate", rx, yy + 1, rz, 1.8, 1.6, 2.5, COLORS.WoodMid, Enum.Material.Wood)
		end
	end
end

-- STOCK CRATES, BARRELS AND SACKS IN THE REAR CORNERS.
for i = 1, 8 do
	local side = (i % 2 == 0) and -1 or 1
	local px = X + side * (11 + (i % 3) * 2)
	local pz = Z - 6 - math.floor(i / 2) * 2
	block("Supply_Crate_Stack", px, 2.6 + (i % 3) * 1.7, pz, 3.2, 3.2, 3.2,
		(i % 2 == 0) and COLORS.WoodMid or COLORS.Wood, Enum.Material.WoodPlanks)
end
for i = 1, 4 do
	local px = X - 16 + i * 8
	cylinder("Shop_Barrel", px, 3.1, Z - 4, 2.8, 3.8, 2.8, COLORS.WoodDark, Enum.Material.Wood)
	for yy = 1.8, 4.2, 2.2 do
		block("Barrel_Iron_Hoop", px, yy, Z - 4, 2.95, 0.2, 2.95, COLORS.Metal, Enum.Material.Metal)
	end
end

-- FLOOR RUG AND SMALL WAITING BENCH.
block("Woven_Rug", X, 1.72, Z + 1, 13, 0.12, 6, COLORS.Red, Enum.Material.Fabric)
block("Customer_Bench_Seat", X - 14, 2.5, Z + 4, 7, 0.6, 2, COLORS.WoodLight, Enum.Material.WoodPlanks)
for _, dx in ipairs({-16.5, -11.5}) do
	block("Customer_Bench_Leg", X + dx, 2, Z + 4, 0.55, 1.3, 0.55, COLORS.WoodDark, Enum.Material.Wood)
end

-- WALL MAP / NOTICE BOARD.
local notice = block("Expedition_Notice_Board", X - 10, 10.2, Z - 14.25, 10, 6, 0.45, COLORS.WoodDark, Enum.Material.WoodPlanks)
signText(notice, "EXPEDITIONS\n\n99 NIGHTS\nSUPPLIES  •  MAPS", Enum.NormalId.Back, Color3.fromRGB(244, 220, 174), Enum.Font.GothamBold)
block("Map_Paper", X - 10, 9.8, Z - 13.95, 5.2, 3.2, 0.12, Color3.fromRGB(207, 190, 145), Enum.Material.Paper)

-- HANGING LANTERNS INSIDE AND OUTSIDE THE SHOP.
for _, dx in ipairs({-15, -5, 5, 15}) do
	local chain = block("Ceiling_Lantern_Chain", X + dx, 15.1, Z + 1, 0.18, 3.2, 0.18, COLORS.Metal, Enum.Material.Metal)
	lantern("Interior_Lantern", X + dx, 13.2, Z + 1, 1.1, 19)
end
for _, dx in ipairs({-17, 17}) do
	lantern("Porch_Lantern", X + dx, 10.3, Z + 18.4, 1.5, 24)
end

-- SMALL DECORATIVE DETAILS: beams, hooks, plants and entrance steps.
for _, dx in ipairs({-20, 20}) do
	block("Corner_Bracing", X + dx, 5, Z + 13.8, 0.45, 7, 5, COLORS.WoodDark, Enum.Material.Wood, 28, 0, 0)
end
for i = 1, 5 do
	local px = X - 15 + i * 6
	block("Front_Step", px, 0.45, Z + 19.5, 5.5, 0.5, 2.2, COLORS.StoneLight, Enum.Material.Cobblestone)
end
for _, dx in ipairs({-20, 20}) do
	ball("Porch_Planter", X + dx, 2.1, Z + 20.5, 3, 2.2, 3, COLORS.Green, Enum.Material.Grass)
end

-- WELCOME PLAQUE INSIDE THE FRONT BEAM.
local plaque = block("Welcome_Plaque", X, 9.8, Z + 14.35, 13, 2.1, 0.35, COLORS.WoodDark, Enum.Material.WoodPlanks)
signText(plaque, "WELCOME, SURVIVOR", Enum.NormalId.Back, Color3.fromRGB(255, 222, 167), Enum.Font.Fantasy)

print("================================================")
print("THE FOREST | SUPPLY SHOP BUILDER 1.0 COMPLETE")
print("Only THE_FOREST_LOBBY/03_Supply_Shop was replaced.")
print("Shop center: X=-48, Z=-57")
print("================================================")
