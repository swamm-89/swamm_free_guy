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
local hitboxTransparency = 0.7
local hitboxThread = nil
local listUpdateThread = nil
local PlayersList = {}
local originalHRP = {}
local friendsCache = {}

-- Single player friend check (call only when needed)
local function cacheFriendStatus(plr)
    if plr == player then return end
    local success, isFriend = pcall(function()
        return player:IsFriendsWith(plr.UserId) -- synchronous version, lighter
    end)
    if success then
        friendsCache[plr.UserId] = isFriend
    end
end

-- Cache all current players
local function updateFriendsCache()
    for _, pl in ipairs(Players:GetPlayers()) do
        cacheFriendStatus(pl)
    end
end

local function isFriend(plr)
    if not friendProtection then return false end
    return friendsCache[plr.UserId] == true
end

local function restorePlayer(pl)
    if not pl or not pl.Character then return end
    local part = pl.Character:FindFirstChild("HumanoidRootPart")
    if not part then return end

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

local function applyHitbox(pl)
    if not pl or not pl.Character then return end
    local part = pl.Character:FindFirstChild("HumanoidRootPart")
    if not part then return end

    if isFriend(pl) then
        restorePlayer(pl)
        return
    end

    -- Save original only once
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
        part.Transparency = hitboxTransparency
        part.BrickColor = BrickColor.new("Bright blue")
        part.Material = Enum.Material.ForceField
        part.CanCollide = false
    end)
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

-- Hook CharacterAdded for a player
local function hookCharacter(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if hitboxEnabled then
            updatePlayersList()
            applyHitbox(plr)
        end
    end)
end

-- Hook EXISTING players (fixes the bug)
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        hookCharacter(plr)
    end
end

-- Hook NEW players
Players.PlayerAdded:Connect(function(plr)
    cacheFriendStatus(plr) -- cache once on join, not every 2s
    hookCharacter(plr)
end)

-- Cleanup on leave
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

            -- Main apply loop (every 0.5s instead of every frame)
            hitboxThread = task.spawn(function()
                while hitboxEnabled do
                    for _, pl in ipairs(PlayersList) do
                        applyHitbox(pl)
                    end
                    task.wait(0.5)
                end
            end)

            -- Player list refresh (every 3s is enough)
            listUpdateThread = task.spawn(function()
                while hitboxEnabled do
                    updatePlayersList()
                    task.wait(3)
                end
            end)
        else
            -- Reset everyone
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= player then
                    restorePlayer(pl)
                end
            end

            if hitboxThread then
                task.cancel(hitboxThread)
                hitboxThread = nil
            end
            if listUpdateThread then
                task.cancel(listUpdateThread)
                listUpdateThread = nil
            end

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
            for _, pl in ipairs(PlayersList) do
                applyHitbox(pl)
            end
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
    end
})

PlayerTab:CreateSlider({
    Name = "Transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = 0.7,
    Callback = function(v)
        hitboxTransparency = v
    end
})







-- ================== NOTIFICATION ==================
game.StarterGui:SetCore("SendNotification", {
    Title = "Squid Game X FREE GUY",
    Text = "Full Fixed Script Loaded",
    Duration = 6
})

warn("FULL FIXED SCRIPT LOADED")
