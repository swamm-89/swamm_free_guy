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





-- ================== CUTSCENE REMOVER ==================
DetectiveTab:CreateToggle({
    Name = "Cutseen Remover",
    CurrentValue = false,
    Callback = function(v)
        scriptEnabled = v
        warn("SCRIPT ENABLED:", v)
    end
})

local playerGui = player.PlayerGui
local playerScripts = player.PlayerScripts

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    if not scriptEnabled then
        return oldNamecall(self, ...)
    end
    local method = getnamecallmethod()
    local name = self.Name
    local path = tostring(self):lower()

    if method == "FireServer" and name == "RequestTeleportAsync" and self.Parent and self.Parent.Name == "Remotes" then
        warn("Teleport FireServer BLOCKED")
        return
    end

    if (name == "SafeCutscene" or path:find("cutscene") or path:find("ending")) and (method == "Play" or method:find("Ending") or method:find("Skippable")) then
        warn("Cutscene BLOCKED:", method)
        return
    end

    if name == "GameHandler" and method == "Toggle" and tostring(...):lower():find("door") then
        warn("Door Toggle BLOCKED")
        return
    end

    return oldNamecall(self, ...)
end)

mt.__index = newcclosure(function(self, key)
    if scriptEnabled and key == "InvokeServer" and self.Name == "RequestTeleportAsync" and self.Parent and self.Parent.Name == "Remotes" then
        warn("Teleport InvokeServer BLOCKED")
        return function() return nil end
    end
    return oldIndex(self, key)
end)

setreadonly(mt, true)

local function onCharacterAdded(char)
    if not scriptEnabled then return end
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        hum.Died:Connect(function()
            if scriptEnabled then
                warn("Death detected → Respawn")
                player:LoadCharacter()
            end
        end)
    end
end

if player.Character then
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

task.spawn(function()
    pcall(function()
        local client = playerScripts:WaitForChild("Client", 15)
        local handler = client:WaitForChild("GameHandler", 15)
        local mode = handler:WaitForChild("GameModeSystem", 10)
        if mode and mode:IsA("LocalScript") then
            mode.Disabled = true
            warn("GameModeSystem DISABLED")
        end
    end)
end)

local function clean()
    if not scriptEnabled then return end
    for _, gui in ipairs(playerGui:GetChildren()) do
        local n = gui.Name:lower()
        if gui:IsA("ScreenGui") and (n:find("death") or n:find("cutscene") or n:find("black") or n:find("fade") or n:find("end") or n:find("tele")) then
            gui:Destroy()
        end
    end
    for _, s in ipairs(playerScripts:GetDescendants()) do
        if s:IsA("LocalScript") and not s.Disabled then
            local ln = s.Name:lower()
            if ln:find("cutscene") or ln:find("gamemode") or ln:find("handler") or ln:find("system") then
                s.Disabled = true
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.5) do
        clean()
    end
end)
clean()

-- ================== PLAYER TAB ==================
local walkspeedValue = 16
local walkspeedConnection
local infJumpConnection

PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        walkspeedValue = v
        if walkspeedConnection then walkspeedConnection:Disconnect() end
        walkspeedConnection = RunService.Heartbeat:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = v
            end
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            infJumpConnection = UserInputService.JumpRequest:Connect(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if infJumpConnection then infJumpConnection:Disconnect() end
        end
    end
})

local noclip = false
local noclipConnection
local originalCollision = {}

PlayerTab:CreateToggle({
    Name = "No Clip",
    CurrentValue = false,
    Callback = function(Value)
        noclip = Value
        if noclip then
            noclipConnection = RunService.Stepped:Connect(function()
                local char = player.Character
                if not char then return end
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide == true then
                        originalCollision[part] = true
                        part.CanCollide = false
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            for part in pairs(originalCollision) do
                if part and part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
            originalCollision = {}
        end
    end
})

-- ================== DETECTIVE TAB ==================
local AUTO_COLLECT_RUNNING = false
local TeleportBack = true
local HOLD_TIME = 0.8
local MAX_ATTEMPTS = 2
local MAX_EVIDENCE = 8
local DELAY_BETWEEN = 1.8

local function getInstancesRoot()
    local cur = workspace
    for _, name in {"Data", "Detective", "Evidence", "Instances"} do
        cur = cur:FindFirstChild(name)
        if not cur then return nil end
    end
    return cur
end

local function safeTeleportTo(pos, offsetY)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = char.HumanoidRootPart
    local old = hrp.CFrame
    pcall(function()
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, offsetY or 3, 0))
    end)
    return old
end

local function tryActivatePrompt(prompt, attempt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    local parentPart = prompt.Parent
    if not parentPart or not parentPart:IsA("BasePart") then return false end
    local offsetY = 3 + (attempt * 0.8)
    local old = safeTeleportTo(parentPart.Position, offsetY)
    task.wait(0.15)
    pcall(function()
        if prompt.HoldDuration > 0 then
            fireproximityprompt(prompt, prompt.HoldDuration)
        else
            fireproximityprompt(prompt)
        end
    end)
    task.wait(HOLD_TIME)
    return true, old
end

local function collectAllPrompts()
    if AUTO_COLLECT_RUNNING then return end
    AUTO_COLLECT_RUNNING = true
    task.spawn(function()
        local root = getInstancesRoot()
        if not root then
            AUTO_COLLECT_RUNNING = false
            return
        end
        local orig = nil
        local collected = 0

        for _, folder in ipairs(root:GetChildren()) do
            if not AUTO_COLLECT_RUNNING then break end
            local ppart = folder:FindFirstChild("PPart")
            if ppart then
                local prompt = ppart:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt and prompt.Enabled then
                    local success = false
                    for attempt = 1, MAX_ATTEMPTS do
                        if not AUTO_COLLECT_RUNNING then break end
                        local _, oldPos = tryActivatePrompt(prompt, attempt)
                        if oldPos and not orig then
                            orig = oldPos
                        end
                        task.wait(DELAY_BETWEEN)
                        if not prompt.Enabled or prompt.Parent == nil then
                            success = true
                            break
                        end
                    end
                    if success then
                        collected = collected + 1
                        addEvidenceCount(1)
                        print("Evidence Collected: " .. collected .. "/" .. MAX_EVIDENCE)

                        if collected >= MAX_EVIDENCE then
                            if TeleportBack and orig and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                pcall(function()
                                    player.Character.HumanoidRootPart.CFrame = orig
                                end)
                            end
                            break
                        end
                    end
                end
            end
        end

        if collected < MAX_EVIDENCE and TeleportBack and orig and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                player.Character.HumanoidRootPart.CFrame = orig
            end)
        end
        print("Auto Collect Finished! Total: " .. collected)
        AUTO_COLLECT_RUNNING = false
    end)
end

DetectiveTab:CreateSection("Auto Evidence Collector")
DetectiveTab:CreateToggle({
    Name = "Auto Collect",
    CurrentValue = false,
    Callback = function(v)
        if v then
            collectAllPrompts()
        else
            AUTO_COLLECT_RUNNING = false
        end
    end
})
DetectiveTab:CreateToggle({
    Name = "Teleport Back",
    CurrentValue = true,
    Callback = function(v) TeleportBack = v end
})


-- ================== ISLAND PATH ==================
local PathHighlightEnabled = false
local TargetPosition = Vector3.new(-2867.14, -788.57, 15618.65)
local lineFolder = nil

local function createLineFolder()
    if lineFolder then return lineFolder end
    lineFolder = Instance.new("Folder")
    lineFolder.Name = "StraightRedPath"
    lineFolder.Parent = workspace
    return lineFolder
end

local function clearPath()
    if lineFolder then
        lineFolder:Destroy()
        lineFolder = nil
    end
end

local function drawStraightPath()
    clearPath()
    createLineFolder()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local startPos = char.HumanoidRootPart.Position
    local distance = (startPos - TargetPosition).Magnitude

    local beam = Instance.new("Beam")
    beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    beam.LightEmission = 0.9
    beam.LightInfluence = 0.4
    beam.Width0 = 2.2
    beam.Width1 = 2.2
    beam.Segments = 25
    beam.Transparency = NumberSequence.new(0.2)
    beam.Parent = lineFolder

    local att0 = Instance.new("Attachment", workspace.Terrain)
    local att1 = Instance.new("Attachment", workspace.Terrain)
    att0.Position = startPos + Vector3.new(0, 3, 0)
    att1.Position = TargetPosition + Vector3.new(0, 3, 0)
    beam.Attachment0 = att0
    beam.Attachment1 = att1

    Rayfield:Notify({
        Title = "Path Highlighted",
        Content = "Distance: " .. math.floor(distance) .. " studs",
        Duration = 4
    })
end

DetectiveTab:CreateToggle({
    Name = "Island Path Highlighter",
    CurrentValue = false,
    Callback = function(Value)
        PathHighlightEnabled = Value
        if Value then
            drawStraightPath()
        else
            clearPath()
        end
    end
})

-- ================== AUTO FARM LOOP ==================
local AUTO_FARM_RUNNING = false
local WAIT_AFTER_COLLECT = 45
local StartTeleportPos = Vector3.new(8073.37, 88.97, 3679.23)
local MidTeleportPos = Vector3.new(-1992.31, -859.86, 15906.73)
local waypoints = {
    Vector3.new(8073.96, 88.86, 3650.73),
    Vector3.new(8161.80, 100.84, 3650.35),
    Vector3.new(8161.49, 100.64, 3472.72),
    Vector3.new(-2063.78, -839.86, 15972.25),
    Vector3.new(-2124.64, -819.91, 15898.50),
    Vector3.new(-2171.05, -819.02, 15829.92),
    Vector3.new(-2307.93, -765.76, 15685.34),
    Vector3.new(-2314.12, -787.01, 15562.18),
    Vector3.new(-2496.66, -786.53, 15496.33),
    Vector3.new(-2614.94, -782.07, 15233.47),
    Vector3.new(-2688.85, -787.00, 15219.22),
    Vector3.new(-2826.85, -783.00, 15337.36),
    Vector3.new(-2843.02, -786.00, 15511.34)
}

local function collectEvidence()
    local root = getInstancesRoot()
    if not root then return end
    local returnPosition = nil
    local collected = 0

    for _, folder in ipairs(root:GetChildren()) do
        if not AUTO_FARM_RUNNING then break end
        local ppart = folder:FindFirstChild("PPart")
        if ppart then
            local prompt = ppart:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt and prompt.Enabled then
                if not returnPosition then
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        returnPosition = char.HumanoidRootPart.CFrame
                    end
                end
                local success = false
                for attempt = 1, MAX_ATTEMPTS do
                    if not AUTO_FARM_RUNNING then break end
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = CFrame.new(prompt.Parent.Position + Vector3.new(0, 4, 0))
                    end
                    task.wait(0.2)
                    pcall(function()
                        fireproximityprompt(prompt, prompt.HoldDuration or 0)
                    end)
                    task.wait(HOLD_TIME)
                    if not prompt.Enabled or prompt.Parent == nil then
                        success = true
                        break
                    end
                end
                if success then
                    collected = collected + 1
                    addEvidenceCount(1)
                    if collected >= MAX_EVIDENCE then break end
                end
                task.wait(DELAY_BETWEEN)
            end
        end
    end

    if returnPosition then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = returnPosition
            task.wait(0.8)
        end
    end
    print("Collect Finished | Total: " .. collected)
end

local function submitEvidence()
    local boat = workspace.Data and workspace.Data.Detective and workspace.Data.Detective.Boat and workspace.Data.Detective.Boat["Speedy Bowrider"]
    if not boat then return end
    local prompt = boat:FindFirstChild("RearPart", true) and boat.RearPart:FindFirstChild("Attachment", true) and boat.RearPart.Attachment:FindFirstChild("ProximityPrompt")
    if not prompt then return end

    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local origCFrame = hrp.CFrame

    prompt.MaxActivationDistance = 50
    prompt.Enabled = true
    prompt.RequiresLineOfSight = false
    prompt.HoldDuration = 0.5

    hrp.CFrame = CFrame.new(prompt.Parent.Parent.Position + Vector3.new(0, 3, 0))
    task.wait(0.4)
    pcall(function()
        fireproximityprompt(prompt, 0.5)
    end)
    task.wait(0.8)
    hrp.CFrame = origCFrame
end

local function startAutoWalk()
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if not hum then return end
    pcall(function()
        player.Character.HumanoidRootPart.CFrame = CFrame.new(StartTeleportPos + Vector3.new(0, 5, 0))
    end)
    task.wait(1.5)
    for i = 1, #waypoints do
        if not AUTO_FARM_RUNNING then break end
        hum:MoveTo(waypoints[i])
        hum.MoveToFinished:Wait(15)
        if i == 3 then
            pcall(function()
                player.Character.HumanoidRootPart.CFrame = CFrame.new(MidTeleportPos + Vector3.new(0, 5, 0))
            end)
            task.wait(1.8)
        end
        task.wait(0.5)
    end
end

local function autoFarmLoop()
    while AUTO_FARM_RUNNING do
        print("Starting new Auto Farm Cycle...")
        collectEvidence()
        task.wait(WAIT_AFTER_COLLECT)
        if not AUTO_FARM_RUNNING then break end
        startAutoWalk()
        if not AUTO_FARM_RUNNING then break end
        submitEvidence()
        print("Cycle Completed")
        task.wait(2)
    end
    print("AUTO FARM Loop Stopped")
end

DetectiveTab:CreateSection("AUTO FARM - LOOP MODE")
DetectiveTab:CreateToggle({
    Name = "AUTO FARM LOOP (Infinite Cycle)",
    CurrentValue = false,
    Callback = function(v)
        if v then
            AUTO_FARM_RUNNING = true
            print("AUTO FARM LOOP Started")
            task.spawn(autoFarmLoop)
        else
            AUTO_FARM_RUNNING = false
            print("AUTO FARM LOOP Stopped")
        end
    end
})

-- ================== TELEPORT TAB ==================
local normalLocations = {
    ["Sniper Room"] = CFrame.new(-12141.4541, -730.498535, -2957.66406),
    ["Lobby"] = CFrame.new(8037.88623, 89.01297, 3716.98755),
    ["Coffin Room"] = CFrame.new(8115.72949, 81.5116348, 3563.58252),
    ["Kitchen"] = CFrame.new(8196.88086, 100.611847, 3641.15967),
    ["Island"] = CFrame.new(-2855.55933, -785.993164, 15511.7393)
}

for name, cframe in pairs(normalLocations) do
    TeleportTab:CreateButton({
        Name = "Teleport to " .. name,
        Callback = function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = cframe
            end
        end
    })
end

TeleportTab:CreateSection("Gamemode")
local gamemodes = {
    ["Red Light Green Light"] = CFrame.new(-12203.375, -790.695312, -3007.31567),
    ["PENTATHLON"] = CFrame.new(-2750.47, 95.31, -4947.26),
    ["Mingle"] = CFrame.new(-821.12, 35.15, 1555.95),
    ["Rock Paper Scissors"] = CFrame.new(1283.39, 286.68, 588.87),
    ["GLASS GAME"] = CFrame.new(1278.72, 101.70, -1087.84),
    ["Dinner"] = CFrame.new(8070.41, 56.10, 23481.91),
    ["Sky Squid Platform 1"] = CFrame.new(510.28, 287.33, 76.86),
    ["Sky Squid Platform 2"] = CFrame.new(498.37, 287.29, 158.14),
    ["Sky Squid Platform 3"] = CFrame.new(495.70, 287.35, 258.99),
    ["Honeycomb"] = CFrame.new(48.0107231, 26.2989159, 3139.28125),
    ["Hide n Seek"] = CFrame.new(-792.37, 8.42, 339.92),
    ["Jump Rope"] = CFrame.new(94.34, 119.73, -4.28)
}

for name, cframe in pairs(gamemodes) do
    TeleportTab:CreateButton({
        Name = name,
        Callback = function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = cframe
            end
        end
    })
end

-- ================== GUARD TAB ==================
GuardTab:CreateSection("Kitchen")

local Character = player.Character or player.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local originalDurations = {}
local promptAddedConn = nil
local Range = 15

player.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
end)

local function enableInstantInteract()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            originalDurations[obj] = obj.HoldDuration
            obj.HoldDuration = 0
        end
    end
    promptAddedConn = workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("ProximityPrompt") then
            originalDurations[obj] = obj.HoldDuration
            obj.HoldDuration = 0
        end
    end)
end

local function disableInstantInteract()
    for prompt, dur in pairs(originalDurations) do
        if prompt and prompt.Parent then
            prompt.HoldDuration = dur
        end
    end
    originalDurations = {}
    if promptAddedConn then
        pcall(function() promptAddedConn:Disconnect() end)
        promptAddedConn = nil
    end
end

GuardTab:CreateToggle({
    Name = "Instant Interact",
    CurrentValue = false,
    Callback = function(val)
        if val then enableInstantInteract() else disableInstantInteract() end
    end
})

GuardTab:CreateSlider({
    Name = "Interact Range",
    Range = {10, 100},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 15,
    Callback = function(val)
        Range = val
    end
})

_G.AutoInteract = false
local autoLoop

GuardTab:CreateToggle({
    Name = "Auto Interact",
    CurrentValue = false,
    Callback = function(val)
        _G.AutoInteract = val
        if val then
            autoLoop = task.spawn(function()
                while _G.AutoInteract do
                    for _, prompt in ipairs(workspace:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                            if HRP and prompt.Parent and prompt.Parent:IsA("BasePart") then
                                local dist = (HRP.Position - prompt.Parent.Position).Magnitude
                                if dist <= Range then
                                    pcall(function()
                                        fireproximityprompt(prompt)
                                    end)
                                end
                            end
                        end
                    end
                    task.wait(0.08)
                end
            end)
        else
            if autoLoop then
                task.cancel(autoLoop)
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
