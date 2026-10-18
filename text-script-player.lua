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


-- ================== HITBOX EXPANDER + FRIEND PROTECTION ==================
local hitboxEnabled = false
local friendProtection = false
local hitboxSize = 180
local hitboxThread = nil
local listUpdateThread = nil
local PlayersList = {}
local originalHRP = {}
local friendsCache = {}

-- ================== FRIEND UTILS ==================
local function cacheFriendStatus(plr)
    if plr == player then return end
    local success, isFriend = pcall(function()
        return player:IsFriendsWith(plr.UserId)
    end)
    if success then
        friendsCache[plr.UserId] = isFriend
    end
end

local function updateFriendsCache()
    for _, pl in ipairs(Players:GetPlayers()) do
        cacheFriendStatus(pl)
    end
end

local function isFriend(plr)
    if not friendProtection then return false end
    return friendsCache[plr.UserId] == true
end

-- ================== RESTORE ==================
local function restorePlayer(pl)
    if not pl or not pl.Character then return end
    local part = pl.Character:FindFirstChild("HumanoidRootPart")
    if not part then return end

    -- Remove friend indicator if exists
    local indicator = pl.Character:FindFirstChild("FriendIndicator")
    if indicator then indicator:Destroy() end

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

-- ================== FLASH INDICATORS ==================

-- Enemy: red box 5 sec then invisible (hitbox stays expanded)
local function flashEnemy(pl)
    local part = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
    if not part then return end

    pcall(function()
        part.Transparency = 0.6
        part.BrickColor = BrickColor.new("Bright red")
        part.Material = Enum.Material.ForceField
    end)

    task.delay(5, function()
        pcall(function()
            if pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                pl.Character.HumanoidRootPart.Transparency = 1
                pl.Character.HumanoidRootPart.Material = Enum.Material.Plastic
            end
        end)
    end)
end

-- Friend: small green box 5 sec then destroy
local function flashFriend(pl)
    local hrp = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Remove old indicator if stacked
    local old = pl.Character:FindFirstChild("FriendIndicator")
    if old then old:Destroy() end

    local indicator = Instance.new("Part")
    indicator.Name = "FriendIndicator"
    indicator.Size = Vector3.new(4, 4, 4)
    indicator.BrickColor = BrickColor.new("Bright green")
    indicator.Material = Enum.Material.ForceField
    indicator.Transparency = 0.5
    indicator.CanCollide = false
    indicator.Anchored = false

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = hrp
    weld.Part1 = indicator
    weld.Parent = indicator

    indicator.CFrame = hrp.CFrame
    indicator.Parent = pl.Character

    task.delay(5, function()
        pcall(function()
            if indicator and indicator.Parent then
                indicator:Destroy()
            end
        end)
    end)
end

-- ================== APPLY HITBOX ==================
local function applyHitbox(pl, showFlash)
    if not pl or not pl.Character then return end
    local part = pl.Character:FindFirstChild("HumanoidRootPart")
    if not part then return end

    if isFriend(pl) then
        restorePlayer(pl)
        if showFlash then flashFriend(pl) end
        return
    end

    -- Save original once
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
        part.Transparency = 1 -- invisible by default
    end)

    if showFlash then flashEnemy(pl) end
end

-- Flash everyone (called on toggle ON / size change)
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
        task.wait(1)
        if hitboxEnabled then
            updatePlayersList()
            applyHitbox(plr, true) -- flash on respawn
        end
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then hookCharacter(plr) end
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
PlayerTab:CreateSection("Hitbox Expander")

PlayerTab:CreateToggle({
    Name = "Hitbox Expander",
    CurrentValue = false,
    Callback = function(Value)
        hitboxEnabled = Value

        if hitboxEnabled then
            updateFriendsCache()
            updatePlayersList()
            flashAll() -- RED enemies + GREEN friends for 5s

            -- Silently maintain hitbox for new/respawning players
            listUpdateThread = task.spawn(function()
                while hitboxEnabled do
                    updatePlayersList()
                    task.wait(3)
                end
            end)

            -- Quiet apply loop (no flash, just keep hitbox expanded)
            hitboxThread = task.spawn(function()
                while hitboxEnabled do
                    for _, pl in ipairs(PlayersList) do
                        applyHitbox(pl, false) -- no flash on routine check
                    end
                    task.wait(2)
                end
            end)
        else
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= player then restorePlayer(pl) end
            end

            if hitboxThread then task.cancel(hitboxThread); hitboxThread = nil end
            if listUpdateThread then task.cancel(listUpdateThread); listUpdateThread = nil end

            table.clear(originalHRP)
            table.clear(PlayersList)
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Friend Protection",
    CurrentValue = false,
    Callback = function(Value)
        friendProtection = Value
        if hitboxEnabled then
            updateFriendsCache()
            flashAll() -- re-flash to show updated status
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {10, 500},
    Increment = 5,
    CurrentValue = 180,
    Callback = function(v)
        hitboxSize = v
        if hitboxEnabled then
            flashAll() -- size change = flash RED 5s with new size
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
