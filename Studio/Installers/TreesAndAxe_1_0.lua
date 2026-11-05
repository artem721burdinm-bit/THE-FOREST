-- THE FOREST | TREES + AXE INSTALLER 1.0
-- Paste the entire file into Roblox Studio > View > Command Bar.
-- Creates only its own folders/scripts/tool. Does not replace the map or other systems.

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPack = game:GetService("StarterPack")

local SYSTEM_NAME = "THE_FOREST_TREE_SYSTEM"
local AXE_NAME = "ForestAxe"
local REMOTE_NAME = "THE_FOREST_ChopTree"

-- Remove only objects created by this installer.
local oldTrees = Workspace:FindFirstChild(SYSTEM_NAME)
if oldTrees then oldTrees:Destroy() end

local oldTool = StarterPack:FindFirstChild(AXE_NAME)
if oldTool then oldTool:Destroy() end

local oldServer = ServerScriptService:FindFirstChild("THE_FOREST_TreeChoppingServer")
if oldServer then oldServer:Destroy() end

local oldRemote = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
if oldRemote then oldRemote:Destroy() end

local treeFolder = Instance.new("Folder")
treeFolder.Name = SYSTEM_NAME
treeFolder.Parent = Workspace

local remote = Instance.new("RemoteEvent")
remote.Name = REMOTE_NAME
remote.Parent = ReplicatedStorage

local function makePart(parent, name, size, cf, color, material, shape)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = cf
    p.Anchored = true
    p.CanCollide = true
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Color = color
    p.Material = material
    if shape then p.Shape = shape end
    p.Parent = parent
    return p
end

local function cylinderBetween(parent, name, a, b, thickness, color, material)
    local direction = b - a
    local midpoint = (a + b) / 2
    local p = makePart(
        parent,
        name,
        Vector3.new(thickness, direction.Magnitude, thickness),
        CFrame.lookAt(midpoint, b) * CFrame.Angles(math.rad(90), 0, 0),
        color,
        material,
        Enum.PartType.Cylinder
    )
    return p
end

local function makeTree(index, position, scale)
    local model = Instance.new("Model")
    model.Name = string.format("ForestTree_%02d", index)
    model:SetAttribute("IsChoppable", true)
    model:SetAttribute("TreeHealth", 5)
    model:SetAttribute("MaxTreeHealth", 5)
    model:SetAttribute("WoodReward", 3)
    model.Parent = treeFolder

    local x, z = position.X, position.Z
    local height = 18 * scale
    local trunkWidth = 3.1 * scale
    local bark = Color3.fromRGB(91, 57, 35)
    local barkLight = Color3.fromRGB(117, 76, 47)
    local leaves = {
        Color3.fromRGB(42, 91, 48),
        Color3.fromRGB(49, 105, 53),
        Color3.fromRGB(57, 116, 58)
    }

    -- Main trunk: stacked sections give it a slightly irregular silhouette.
    local trunk = makePart(
        model, "Trunk",
        Vector3.new(trunkWidth, height * 0.72, trunkWidth),
        CFrame.new(x, height * 0.36, z) * CFrame.Angles(0, math.rad(index * 17), math.rad((index % 3 - 1) * 2)),
        bark, Enum.Material.Wood, Enum.PartType.Cylinder
    )
    trunk:SetAttribute("MainTrunk", true)

    makePart(model, "UpperTrunk",
        Vector3.new(trunkWidth * 0.76, height * 0.36, trunkWidth * 0.76),
        CFrame.new(x + 0.15 * scale, height * 0.78, z),
        bark, Enum.Material.Wood, Enum.PartType.Cylinder)

    -- Roots flare out from the base.
    for r = 1, 5 do
        local angle = math.rad(r * 72 + index * 11)
        local rootEnd = Vector3.new(
            x + math.cos(angle) * 4.2 * scale,
            0.35 * scale,
            z + math.sin(angle) * 4.2 * scale
        )
        cylinderBetween(
            model, "Root",
            Vector3.new(x, 1.4 * scale, z),
            rootEnd,
            1.05 * scale,
            bark,
            Enum.Material.Wood
        )
    end

    -- Branches reach outward from the upper trunk.
    for b = 1, 5 do
        local angle = math.rad(b * 72 + index * 23)
        local startPoint = Vector3.new(x, height * (0.62 + (b % 2) * 0.08), z)
        local endPoint = Vector3.new(
            x + math.cos(angle) * 6.2 * scale,
            height * (0.78 + (b % 3) * 0.035),
            z + math.sin(angle) * 6.2 * scale
        )
        cylinderBetween(model, "Branch", startPoint, endPoint, 0.85 * scale, bark, Enum.Material.Wood)
    end

    -- Bark ridges add visible texture without external assets.
    for ridge = 1, 7 do
        local angle = math.rad(ridge * 51 + index * 13)
        local radius = trunkWidth * 0.49
        local ridgePart = makePart(
            model, "Bark_Ridge",
            Vector3.new(0.18 * scale, height * 0.43, 0.22 * scale),
            CFrame.new(
                x + math.cos(angle) * radius,
                height * 0.37,
                z + math.sin(angle) * radius
            ) * CFrame.Angles(0, -angle, math.rad(2)),
            barkLight, Enum.Material.Wood
        )
        ridgePart.CanCollide = false
    end

    -- Layered canopy: large overlapping clusters.
    local crownY = height + 4.2 * scale
    for c = 1, 9 do
        local angle = math.rad(c * 40 + index * 19)
        local ring = (c % 3 == 0) and 4.6 or 3.1
        local leafColor = leaves[(c % #leaves) + 1]
        local size = (c % 3 == 0) and 8.5 or 7.2
        local cluster = makePart(
            model, "Canopy",
            Vector3.new(size * scale, size * 0.82 * scale, size * scale),
            CFrame.new(
                x + math.cos(angle) * ring * scale,
                crownY + ((c % 4) - 1.5) * 1.1 * scale,
                z + math.sin(angle) * ring * scale
            ),
            leafColor, Enum.Material.Grass, Enum.PartType.Ball
        )
        cluster.CanCollide = false
    end

    local centerCrown = makePart(
        model, "Canopy_Center",
        Vector3.new(10 * scale, 9 * scale, 10 * scale),
        CFrame.new(x, crownY + 1.3 * scale, z),
        leaves[(index % #leaves) + 1], Enum.Material.Grass, Enum.PartType.Ball
    )
    centerCrown.CanCollide = false

    -- Health label appears only when the tree is being chopped.
    local gui = Instance.new("BillboardGui")
    gui.Name = "TreeHealthDisplay"
    gui.Size = UDim2.fromOffset(110, 24)
    gui.StudsOffset = Vector3.new(0, height + 7 * scale, 0)
    gui.AlwaysOnTop = true
    gui.Enabled = false
    gui.Parent = trunk

    local label = Instance.new("TextLabel")
    label.Name = "HealthText"
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundColor3 = Color3.fromRGB(24, 29, 22)
    label.BackgroundTransparency = 0.2
    label.TextColor3 = Color3.fromRGB(255, 235, 190)
    label.TextStrokeTransparency = 0.5
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Text = "TREE 5 / 5"
    label.Parent = gui

    model.PrimaryPart = trunk
    return model
end

-- Create a forest ring around the origin, leaving the center open.
local treePositions = {}
local count = 30
for i = 1, count do
    local angle = (math.pi * 2 / count) * i
    local radius = 14 + ((i * 9) % 20)
    local x = math.cos(angle) * radius
    local z = math.sin(angle) * radius
    table.insert(treePositions, Vector3.new(x, 0, z))
end

for i, position in ipairs(treePositions) do
    local scale = 0.88 + ((i * 7) % 6) * 0.075
    makeTree(i, position, scale)
end

-- Create the equipped axe Tool.
local tool = Instance.new("Tool")
tool.Name = AXE_NAME
tool.ToolTip = "Деревянный топор — рубить деревья"
tool.RequiresHandle = true
tool.CanBeDropped = false
tool.Grip = CFrame.new(0, -0.65, -0.15) * CFrame.Angles(math.rad(-8), 0, math.rad(88))
tool.Parent = StarterPack

local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(0.34, 3.2, 0.34)
handle.Color = Color3.fromRGB(126, 78, 43)
handle.Material = Enum.Material.Wood
handle.CanCollide = false
handle.Massless = true
handle.Parent = tool

local handleMesh = Instance.new("SpecialMesh")
handleMesh.MeshType = Enum.MeshType.Cylinder
handleMesh.Parent = handle

local axeHead = Instance.new("Part")
axeHead.Name = "AxeHead"
axeHead.Size = Vector3.new(1.85, 0.72, 0.48)
axeHead.Color = Color3.fromRGB(70, 76, 78)
axeHead.Material = Enum.Material.Metal
axeHead.CanCollide = false
axeHead.Massless = true
axeHead.Parent = tool

local headWeld = Instance.new("WeldConstraint")
headWeld.Part0 = handle
headWeld.Part1 = axeHead
headWeld.Parent = handle
axeHead.CFrame = handle.CFrame * CFrame.new(0, 1.15, 0)

local gripWrap = Instance.new("Part")
gripWrap.Name = "Grip_Wrap"
gripWrap.Size = Vector3.new(0.39, 0.72, 0.39)
gripWrap.Color = Color3.fromRGB(58, 43, 34)
gripWrap.Material = Enum.Material.Fabric
gripWrap.CanCollide = false
gripWrap.Massless = true
gripWrap.Parent = tool
gripWrap.CFrame = handle.CFrame * CFrame.new(0, -0.85, 0)

local wrapWeld = Instance.new("WeldConstraint")
wrapWeld.Part0 = handle
wrapWeld.Part1 = gripWrap
wrapWeld.Parent = handle

local bladeEdge = Instance.new("Part")
bladeEdge.Name = "Blade_Edge"
bladeEdge.Size = Vector3.new(0.16, 0.63, 0.5)
bladeEdge.Color = Color3.fromRGB(166, 174, 174)
bladeEdge.Material = Enum.Material.Metal
bladeEdge.CanCollide = false
bladeEdge.Massless = true
bladeEdge.Parent = tool
bladeEdge.CFrame = axeHead.CFrame * CFrame.new(-0.88, 0, 0)

local edgeWeld = Instance.new("WeldConstraint")
edgeWeld.Part0 = axeHead
edgeWeld.Part1 = bladeEdge
edgeWeld.Parent = axeHead

-- Client input: request a chop when the player clicks/taps.
local localScript = Instance.new("LocalScript")
localScript.Name = "AxeClient"
localScript.Source = [==[
local tool = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = ReplicatedStorage:WaitForChild("THE_FOREST_ChopTree")
local ready = true

tool.Activated:Connect(function()
    if not ready then return end
    ready = false
    remote:FireServer()
    task.delay(0.55, function()
        ready = true
    end)
end)
]==]
localScript.Parent = tool

-- Server-authoritative chopping and wood collection.
local serverScript = Instance.new("Script")
serverScript.Name = "THE_FOREST_TreeChoppingServer"
serverScript.Source = [==[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")

local remote = ReplicatedStorage:WaitForChild("THE_FOREST_ChopTree")
local treeFolder = Workspace:WaitForChild("THE_FOREST_TREE_SYSTEM")
local lastHit = {}
local HIT_COOLDOWN = 0.55
local MAX_DISTANCE = 12

local function setupLeaderstats(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        leaderstats = Instance.new("Folder")
        leaderstats.Name = "leaderstats"
        leaderstats.Parent = player
    end
    if not leaderstats:FindFirstChild("Wood") then
        local wood = Instance.new("IntValue")
        wood.Name = "Wood"
        wood.Value = 0
        wood.Parent = leaderstats
    end
end

Players.PlayerAdded:Connect(setupLeaderstats)
for _, player in ipairs(Players:GetPlayers()) do
    setupLeaderstats(player)
end

local function findTree(hitPart)
    local current = hitPart
    while current and current ~= Workspace do
        if current:IsA("Model") and current:GetAttribute("IsChoppable") == true then
            return current
        end
        current = current.Parent
    end
    return nil
end

local function showHealth(tree, health, maxHealth)
    local trunk = tree:FindFirstChild("Trunk")
    local gui = trunk and trunk:FindFirstChild("TreeHealthDisplay")
    if gui then
        gui.Enabled = true
        local label = gui:FindFirstChild("HealthText")
        if label then
            label.Text = "TREE  " .. health .. " / " .. maxHealth
        end
    end
end

local function dropWood(position, amount)
    for i = 1, amount do
        local log = Instance.new("Part")
        log.Name = "WoodLog"
        log.Shape = Enum.PartType.Cylinder
        log.Size = Vector3.new(1.1, 3.2, 1.1)
        log.Material = Enum.Material.Wood
        log.Color = Color3.fromRGB(130, 84, 48)
        log.Anchored = false
        log.CanCollide = true
        log.Position = position + Vector3.new(math.random(-3, 3), 2 + i, math.random(-3, 3))
        log.Parent = Workspace
        log:SetAttribute("IsWoodPickup", true)
        log:SetAttribute("Collected", false)
        log.Orientation = Vector3.new(0, 0, 90)
        Debris:AddItem(log, 45)

        log.Touched:Connect(function(hit)
            if log:GetAttribute("Collected") then return end
            local character = hit:FindFirstAncestorOfClass("Model")
            local player = character and Players:GetPlayerFromCharacter(character)
            if not player then return end
            local stats = player:FindFirstChild("leaderstats")
            local wood = stats and stats:FindFirstChild("Wood")
            if not wood then return end

            log:SetAttribute("Collected", true)
            wood.Value += 1
            log:Destroy()
        end)
    end
end

remote.OnServerEvent:Connect(function(player)
    local now = os.clock()
    if lastHit[player] and now - lastHit[player] < HIT_COOLDOWN then
        return
    end
    lastHit[player] = now

    local character = player.Character
    if not character then return end
    local equippedTool = character:FindFirstChild("ForestAxe")
    if not equippedTool or not equippedTool:IsA("Tool") then return end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local origin = root.Position + Vector3.new(0, 1.3, 0)
    local direction = root.CFrame.LookVector * MAX_DISTANCE
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {character}

    local result = Workspace:Raycast(origin, direction, params)
    if not result then return end

    local tree = findTree(result.Instance)
    if not tree or not tree:IsDescendantOf(treeFolder) then return end
    if not tree.PrimaryPart then return end

    local distance = (tree.PrimaryPart.Position - root.Position).Magnitude
    if distance > MAX_DISTANCE + 2 then return end

    local health = tree:GetAttribute("TreeHealth") or 5
    local maxHealth = tree:GetAttribute("MaxTreeHealth") or 5
    health -= 1
    tree:SetAttribute("TreeHealth", health)
    showHealth(tree, health, maxHealth)

    if health <= 0 then
        local position = tree.PrimaryPart.Position
        local reward = tree:GetAttribute("WoodReward") or 3
        dropWood(position, reward)

        -- Fade the tree away cleanly after it has been chopped down.
        for _, item in ipairs(tree:GetDescendants()) do
            if item:IsA("BasePart") then
                item.CanCollide = false
                item.Anchored = true
                item.Transparency = 1
            elseif item:IsA("BillboardGui") then
                item.Enabled = false
            end
        end
        task.delay(0.25, function()
            if tree and tree.Parent then
                tree:Destroy()
            end
        end)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    lastHit[player] = nil
end)
]==]
serverScript.Parent = ServerScriptService

print("================================================")
print("THE FOREST | TREES + AXE 1.0 INSTALLED")
print("Trees created: " .. #treePositions)
print("Tool added to StarterPack: " .. AXE_NAME)
print("Chopping is server-validated; wood pickup updates leaderstats.")
print("Press Play. Equip the axe and face a tree to chop it.")
print("================================================")
