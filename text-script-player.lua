local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- ==================================================================
-- RAYFIELD GUI
-- ==================================================================
for _, gui in ipairs(CoreGui:GetChildren()) do
    if gui.Name == "RayfieldInterface" then
        gui:Destroy()
    end
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Squid Game X by FREE GUY",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "SQUID GAME X SCRIPT",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SquidAmethyst",
        FileName = "AmethystConfig"
    },
    Theme = "Ocean"
})

local PlayerTab = Window:CreateTab("Player", 4483362458)
local GuardTab = Window:CreateTab("Guard", 4483362458)
local DetectiveTab = Window:CreateTab("Detective", 4483362458)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

-- ================== GLOBAL VARIABLES ==================
local scriptEnabled = false
local evidenceCount = 0

-- ================== HITBOX EXPANDER + FRIEND PROTECTION (FIXED) ==================
local hitboxEnabled = false
local friendProtection = false
local hitboxSize = 180
local hitboxThread = nil
local listUpdateThread = nil
local PlayersList = {}
local originalHRP = {}
local friendsCache = {}

-- ================== FRIEND UTILS (STRONGER) ==================
local function cacheFriendStatus(plr)
    if not plr or plr == player then return end
    local success, isFriend = pcall(function()
        return player:IsFriendsWith(plr.UserId)
    end)
    if success then
        friendsCache[plr.UserId] = isFriend
    else
        -- fail hone pe safe side pe friend maano mat
        friendsCache[plr.UserId] = false
    end
end

local function updateFriendsCache()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= player then
            cacheFriendStatus(pl)
        end
    end
end

local function isFriend(plr)
    if not friendProtection then return false end
    if not plr then return false end
    -- double check
    if friendsCache[plr.UserId] == true then
        return true
    end
    return false
end

-- ================== RESTORE ==================
local function restorePlayer(pl)
    if not pl or not pl.Character then return end
    local part = pl.Character:FindFirstChild("HumanoidRootPart")
    if not part then return end

    local hitVisual = pl.Character:FindFirstChild("HitboxVisual")
    if hitVisual then hitVisual:Destroy() end
    local friendBox = pl.Character:FindFirstChild("FriendIndicator")
    if friendBox then friendBox:Destroy() end

    local orig = originalHRP[pl.UserId]
    if orig then
        pcall(function()
            part.Size = orig.Size
            part.Transparency = orig.Transparency
            part.CanCollide = orig.CanCollide
            part.Material = orig.Material
            part.BrickColor = orig.BrickColor
            part.Color = orig.Color
        end)
    else
        pcall(function()
            part.Size = Vector3.new(2, 2, 1)
            part.Transparency = 0
            part.CanCollide = true
            part.Material = Enum.Material.Plastic
        end)
    end
end

-- ================== FLASH ==================
local function flashEnemy(pl)
    local hrp = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local old = pl.Character:FindFirstChild("HitboxVisual")
    if old then old:Destroy() end

    pcall(function()
        hrp.Transparency = 1
        hrp.CanCollide = false
    end)

    local visual = Instance.new("Part")
    visual.Name = "HitboxVisual"
    visual.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
    visual.Transparency = 0.5
    visual.BrickColor = BrickColor.new("Really red")
    visual.Material = Enum.Material.ForceField
    visual.CanCollide = false
    visual.Anchored = false
    visual.Massless = true
    visual.CastShadow = false

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = hrp
    weld.Part1 = visual
    weld.Parent = visual

    visual.CFrame = hrp.CFrame
    visual.Parent = pl.Character

    local outline = Instance.new("SelectionBox")
    outline.Name = "HitboxOutline"
    outline.Adornee = visual
    outline.Color3 = Color3.fromRGB(255, 20, 20)
    outline.LineThickness = 0.05
    outline.SurfaceTransparency = 1
    outline.Parent = visual

    task.delay(8, function()
        pcall(function()
            if visual and visual.Parent then
                visual:Destroy()
            end
        end)
    end)
end

local function flashFriend(pl)
    local hrp = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local old = pl.Character:FindFirstChild("FriendIndicator")
    if old then old:Destroy() end

    -- FORCE restore friend hitbox (important)
    restorePlayer(pl)

    local box = Instance.new("Part")
    box.Name = "FriendIndicator"
    box.Size = Vector3.new(4, 4, 4)
    box.Transparency = 0.4
    box.BrickColor = BrickColor.new("Lime green")
    box.Material = Enum.Material.ForceField
    box.CanCollide = false
    box.Anchored = false
    box.Massless = true
    box.CastShadow = false

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = hrp
    weld.Part1 = box
    weld.Parent = box

    box.CFrame = hrp.CFrame
    box.Parent = pl.Character

    local outline = Instance.new("SelectionBox")
    outline.Name = "FriendOutline"
    outline.Adornee = box
    outline.Color3 = Color3.fromRGB(20, 255, 20)
    outline.LineThickness = 0.05
    outline.SurfaceTransparency = 1
    outline.Parent = box

    task.delay(8, function()
        pcall(function()
            if box and box.Parent then
                box:Destroy()
            end
        end)
    end)
end

-- ================== APPLY HITBOX (STRICT FRIEND CHECK) ==================
local function applyHitbox(pl, showFlash)
    if not pl or not pl.Character then return end
    local part = pl.Character:FindFirstChild("HumanoidRootPart")
    if not part then return end

    -- ========== STRICT FRIEND PROTECTION ==========
    if isFriend(pl) then
        -- Friend ko hamesha restore karo + expand mat karo
        restorePlayer(pl)
        if showFlash then
            flashFriend(pl)
        end
        return -- bahut important: yahan se aage mat jao
    end

    -- Enemy only
    if not originalHRP[pl.UserId] then
        originalHRP[pl.UserId] = {
            Size = part.Size,
            Transparency = part.Transparency,
            CanCollide = part.CanCollide,
            Material = part.Material,
            BrickColor = part.BrickColor,
            Color = part.Color
        }
    end

    pcall(function()
        part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
        part.CanCollide = false
        part.Transparency = 1
    end)

    if showFlash then
        flashEnemy(pl)
    end
end

local function flashAll()
    for _, pl in ipairs(PlayersList) do
        applyHitbox(pl, true)
    end
end

local function updatePlayersList()
    local newList = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(newList, pl)
        end
    end
    PlayersList = newList
end

-- ================== CHARACTER HOOKS ==================
local function hookCharacter(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1.2)
        if hitboxEnabled then
            cacheFriendStatus(plr) -- respawn pe friend status refresh
            updatePlayersList()
            applyHitbox(plr, false)
        end
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        hookCharacter(plr)
    end
end

Players.PlayerAdded:Connect(function(plr)
    cacheFriendStatus(plr)
    hookCharacter(plr)
end)

Players.PlayerRemoving:Connect(function(plr)
    originalHRP[plr.UserId] = nil
    friendsCache[plr.UserId] = nil
end)

-- ================== UI ==================
PlayerTab:CreateToggle({
    Name = "Hitbox Expander🔴",
    CurrentValue = false,
    Callback = function(Value)
        hitboxEnabled = Value

        if hitboxEnabled then
            updateFriendsCache()
            updatePlayersList()
            flashAll()

            listUpdateThread = task.spawn(function()
                while hitboxEnabled do
                    updatePlayersList()
                    updateFriendsCache() -- friends bhi refresh
                    task.wait(4)
                end
            end)

            hitboxThread = task.spawn(function()
                while hitboxEnabled do
                    for _, pl in ipairs(PlayersList) do
                        -- Friend ko force restore rakho
                        if isFriend(pl) then
                            restorePlayer(pl)
                        else
                            applyHitbox(pl, false)
                        end
                    end
                    task.wait(1.5)
                end
            end)
        else
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= player then
                    restorePlayer(pl)
                end
            end

            if hitboxThread then task.cancel(hitboxThread) hitboxThread = nil end
            if listUpdateThread then task.cancel(listUpdateThread) listUpdateThread = nil end

            table.clear(originalHRP)
            table.clear(PlayersList)
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Hitbox Size📐",
    Range = {10, 500},
    Increment = 5,
    CurrentValue = 180,
    Callback = function(v)
        hitboxSize = v
        if hitboxEnabled then
            flashAll()
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Friend Protection💗",
    CurrentValue = false,
    Callback = function(Value)
        friendProtection = Value
        if hitboxEnabled then
            updateFriendsCache()
            -- Friends ko force restore
            for _, pl in ipairs(PlayersList) do
                if isFriend(pl) then
                    restorePlayer(pl)
                    flashFriend(pl)
                else
                    applyHitbox(pl, true)
                end
            end
        end
    end
})


-- ================== NOTIFICATION ==================
game.StarterGui:SetCore("SendNotification", {
    Title = "Squid Game X FREE GUY",
    Text = "Full Fixed Script Loaded",
    Duration = 6
})

warn("FULL FIXED SCRIPT LOADED")
