
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- ==================================================================
-- RAYFIELD GUI (WITH YOUR CONTROL)
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



-- ================== PLAYER TAB ==================

DetectiveTab:CreateButton({
    Name = "♥️ Activate Extra Life",
    Callback = function()
        if extraLifeUsed then return end -- already activated, do nothing

        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        pcall(function()
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ExtraLifePurchase"):InvokeServer()
        end)

        extraLifeUsed = true -- mark as used
    end
})


--== ULTIMATE Executor Script + Rayfield (SINGLE TOGGLE) ==--
-- Mobile Friendly | All features merged | One toggle only

DetectiveTab:CreateToggle({
    Name = "Cutseen Remover",
    CurrentValue = false,
    Callback = function(v)
        scriptEnabled = v
        warn("🟢 SCRIPT ENABLED:", v)
    end
})

-------------------------------------------------
-- SERVICES
-------------------------------------------------
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local playerScripts = player.PlayerScripts

-------------------------------------------------
-- PART 1: SINGLE METAMETHOD HOOK (ALL BLOCKS)
-------------------------------------------------
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index

setreadonly(mt, false)

-- FireServer / Play / Toggle / Cutscene block
mt.__namecall = newcclosure(function(self, ...)
    if not scriptEnabled then
        return oldNamecall(self, ...)
    end

    local method = getnamecallmethod()
    local name = self.Name
    local path = tostring(self):lower()

    -- 🚫 TELEPORT FireServer BLOCK
    if method == "FireServer"
        and name == "RequestTeleportAsync"
        and self.Parent
        and self.Parent.Name == "Remotes" then
        warn("🚫 Teleport FireServer BLOCKED")
        return
    end

    -- 🎬 CUTSCENE BLOCK
    if (name == "SafeCutscene" or path:find("cutscene") or path:find("ending"))
        and (method == "Play" or method:find("Ending") or method:find("Skippable")) then
        warn("🎬 Cutscene BLOCKED:", method)
        return
    end

    -- 🚪 GameHandler Door Toggle
    if name == "GameHandler"
        and method == "Toggle"
        and tostring(...):lower():find("door") then
        warn("🚪 Door Toggle BLOCKED")
        return
    end

    return oldNamecall(self, ...)
end)

-- 🚫 TELEPORT InvokeServer BLOCK
mt.__index = newcclosure(function(self, key)
    if scriptEnabled
        and key == "InvokeServer"
        and self.Name == "RequestTeleportAsync"
        and self.Parent
        and self.Parent.Name == "Remotes" then
        warn("🚫 Teleport InvokeServer BLOCKED")
        return function() return nil end
    end
    return oldIndex(self, key)
end)

setreadonly(mt, true)
print("🔒 Advanced Metamethod Hook Applied")

-------------------------------------------------
-- PART 2: AUTO RESPAWN
-------------------------------------------------
local function onCharacterAdded(char)
    if not scriptEnabled then return end

    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        hum.Died:Connect(function()
            if scriptEnabled then
                warn("💀 Death detected → Respawn")
                player:LoadCharacter()
            end
        end)
    end
end

if player.Character then
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

-------------------------------------------------
-- PART 3: DISABLE GameModeSystem
-------------------------------------------------
task.spawn(function()
    pcall(function()
        local client = playerScripts:WaitForChild("Client", 15)
        local handler = client:WaitForChild("GameHandler", 15)
        local mode = handler:WaitForChild("GameModeSystem", 10)

        if mode and mode:IsA("LocalScript") then
            mode.Disabled = true
            warn("❌ GameModeSystem DISABLED")
        end
    end)
end)

-------------------------------------------------
-- PART 4: GUI + SCRIPT CLEANER
-------------------------------------------------
local function clean()
    if not scriptEnabled then return end

    -- GUI cleaner
    for _, gui in ipairs(playerGui:GetChildren()) do
        local n = gui.Name:lower()
        if gui:IsA("ScreenGui") and (
            n:find("death") or n:find("cutscene") or n:find("black")
            or n:find("fade") or n:find("end") or n:find("tele")
        ) then
            gui:Destroy()
        end
    end

    -- PlayerScripts cleaner
    for _, s in ipairs(playerScripts:GetDescendants()) do
        if s:IsA("LocalScript") and not s.Disabled then
            local ln = s.Name:lower()
            if ln:find("cutscene") or ln:find("gamemode")
               or ln:find("handler") or ln:find("system") then
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
warn("✅ ULTIMATE SCRIPT LOADED | SINGLE TOGGLE ACTIVE")



local walkspeedValue = 16
local walkspeedConnection
local infJumpConnection

PlayerTab:CreateSlider({ 
    Name = "Walk Speed 🏃", Range = {16, 200}, Increment = 1, CurrentValue = 16,
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

PlayerTab:CreateToggle({ Name = "Infinite Jump ⏫", CurrentValue = false,
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
local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

local originalCollision = {} -- Store only modified parts

PlayerTab:CreateToggle({
    Name = "👻 No Clip",
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

            -- Restore only changed parts
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

---  AUTO EVIDENCE  COLLECT ----
local AUTO_COLLECT_RUNNING = false
local TeleportBack = true

-- ================== FIXED SETTINGS (Yahan change kar sakte ho) ==================
local HOLD_TIME = 0.1      -- Har evidence ke paas kitna second rukega
local MAX_ATTEMPTS = 3         -- Har evidence pe kitni baar try karega
local MAX_EVIDENCE = 8         -- 8 evidence collect hone pe auto back teleport
-- =====================================================================

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
        local totalAttempts = 0

        for _, folder in ipairs(root:GetChildren()) do
            if not AUTO_COLLECT_RUNNING then break end

            local ppart = folder:FindFirstChild("PPart")
            if ppart then
                local prompt = ppart:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt and prompt.Enabled then
                    
                    local success = false
                    
                    for attempt = 1, MAX_ATTEMPTS do
                        if not AUTO_COLLECT_RUNNING then break end
                        
                        totalAttempts = totalAttempts + 1
                        print(string.format("Attempt %d/%d | Evidence %d", attempt, MAX_ATTEMPTS, collected + 1))
                        
                        local _, oldPos = tryActivatePrompt(prompt, attempt)
                        if oldPos and not orig then 
                            orig = oldPos 
                        end

                        task.wait(0.4)

                        if not prompt.Enabled or prompt.Parent == nil then
                            success = true
                            break
                        end
                    end

                    if success then
                        collected = collected + 1
                        print("✅ Evidence Collected: " .. collected .. "/" .. MAX_EVIDENCE)
                        
                        -- 8 Evidence collect hone pe turant back teleport
                        if collected >= MAX_EVIDENCE then
                            print("🎯 " .. MAX_EVIDENCE .. " Evidence collected! Auto Teleporting Back...")
                            if TeleportBack and orig and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                pcall(function()
                                    player.Character.HumanoidRootPart.CFrame = orig
                                end)
                            end
                            break
                        end
                    else
                        print("⚠️ Evidence missed after " .. MAX_ATTEMPTS .. " attempts")
                    end
                end
            end
        end

        -- Agar 8 se kam collect hue to normal teleport back
        if collected < MAX_EVIDENCE and TeleportBack and orig and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                player.Character.HumanoidRootPart.CFrame = orig
            end)
        end

        print(string.format("Auto Collect Finished! Total Collected: %d / %d", collected, MAX_EVIDENCE))
        AUTO_COLLECT_RUNNING = false
    end)
end

-- ================== UI (Sirf Toggle aur Teleport Back) ==================
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




-- ================== STRAIGHT RED GLOWING PATH (No Path Too Long Error) ==================
local PathHighlightEnabled = false

-- ================== TARGET COORDINATE ==================
local TargetPosition = Vector3.new(-2867.14, -788.57, 15618.65)   -- ←←← YAHAN APNA TARGET COORDINATE DAAL DO
-- ===================================================================

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
    if not char or not char:FindFirstChild("HumanoidRootPart") then 
        print("❌ Character nahi mila!")
        return 
    end

    local startPos = char.HumanoidRootPart.Position
    local distance = (startPos - TargetPosition).Magnitude

    print("Straight Path Drawing... Distance: " .. math.floor(distance) .. " studs")

    -- Single Straight Beam (Red Glowing)
    local beam = Instance.new("Beam")
    beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))     -- Bright Red
    beam.LightEmission = 0.9
    beam.LightInfluence = 0.4
    beam.Width0 = 2.2
    beam.Width1 = 2.2
    beam.Segments = 25
    beam.Transparency = NumberSequence.new(0.2)
    beam.Parent = lineFolder

    local att0 = Instance.new("Attachment", workspace.Terrain)
    local att1 = Instance.new("Attachment", workspace.Terrain)
    att0.Position = startPos + Vector3.new(0, 3, 0)      -- thoda upar
    att1.Position = TargetPosition + Vector3.new(0, 3, 0)
    beam.Attachment0 = att0
    beam.Attachment1 = att1

    print("✅ Island Path Highlighted!")

    -- Notification
    Rayfield:Notify({
        Title = "Path Highlighted",
        Content = "Straight path created!\nDistance: " .. math.floor(distance) .. " studs",
        Duration = 4,
        Image = 4483362458,
    })
end

-- ================== GUI ==================


DetectiveTab:CreateToggle({
    Name = "🔴 Island Path Highlighter",
    CurrentValue = false,
    Callback = function(Value)
        PathHighlightEnabled = Value
        
        if Value then
            drawStraightPath()
        else
            clearPath()
            print("Straight Path Disabled")
        end
    end
})



-- ================== AUTO FARM - INFINITE LOOP VERSION ==================
local AUTO_FARM_RUNNING = false

-- ================== SETTINGS ==================
local HOLD_TIME = 2.0
local MAX_ATTEMPTS = 3
local MAX_EVIDENCE = 8
local WAIT_AFTER_COLLECT = 60

-- Auto Walk Settings
local StartTeleportPos = Vector3.new(8073.37, 88.97, 3679.23)
local MidTeleportPos   = Vector3.new(-1992.31, -859.86, 15906.73)

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

-- ================== AUTO COLLECT WITH FIXED TELEPORT BACK ==================
local function getInstancesRoot()
    local cur = workspace
    for _, name in {"Data", "Detective", "Evidence", "Instances"} do
        cur = cur:FindFirstChild(name)
        if not cur then return nil end
    end
    return cur
end

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
                    collected += 1
                    if collected >= MAX_EVIDENCE then
                        break
                    end
                end
            end
        end
    end

    -- Teleport Back
    if returnPosition then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = returnPosition
            task.wait(0.8)
        end
    end

    print("Collect Finished | Total: " .. collected)
end

-- ================== AUTO SUBMIT ==================
local function submitEvidence()
    local boat = workspace.Data.Detective.Boat and workspace.Data.Detective.Boat["Speedy Bowrider"]
    if not boat then return end

    local prompt = boat:FindFirstChild("RearPart", true) 
        and boat.RearPart:FindFirstChild("Attachment", true) 
        and boat.RearPart.Attachment:FindFirstChild("ProximityPrompt")

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

-- ================== AUTO WALK ==================
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

-- ================== MAIN LOOP ==================
local function autoFarmLoop()
    while AUTO_FARM_RUNNING do
        print("🔄 Starting new Auto Farm Cycle...")

        collectEvidence()                    -- 1. Collect + Teleport Back
        task.wait(WAIT_AFTER_COLLECT)        -- 2. 60 sec wait

        if not AUTO_FARM_RUNNING then break end
        startAutoWalk()                      -- 3. Auto Walk

        if not AUTO_FARM_RUNNING then break end
        submitEvidence()                     -- 4. Submit

        print("✅ Cycle Completed | Starting next cycle in 2 seconds...")
        task.wait(2)   -- Chhota delay next cycle se pehle
    end

    print("AUTO FARM Loop Stopped")
end

-- ================== GUI ==================
DetectiveTab:CreateSection("🚀 AUTO FARM - LOOP MODE")

DetectiveTab:CreateToggle({
    Name = "AUTO FARM LOOP (Infinite Cycle)",
    CurrentValue = false,
    Callback = function(v)
        if v then
            AUTO_FARM_RUNNING = true
            print("🚀 AUTO FARM LOOP Started")
            task.spawn(autoFarmLoop)        -- Loop ko background mein chala rahe hain
        else
            AUTO_FARM_RUNNING = false
            print("🛑 AUTO FARM LOOP Stopped")
        end
    end
})


-- ================== TELEPORT TAB ==================
-- NORMAL LOCATIONS
local normalLocations = {
    ["Sniper Room"] = CFrame.new(-12141.4541, -730.498535, -2957.66406, -0.180338055, -2.98282621e-09, 0.98360467, -6.66433975e-09, 1, 1.81067872e-09, -0.98360467, -6.22854168e-09, -0.180338055),
    ["Lobby"] = CFrame.new(8037.88623, 89.01297, 3716.98755, 0.989010394, 2.00211296e-08, -0.147845939, -3.05174623e-08, 1, -6.87266564e-08, 0.147845939, 7.24832603e-08, 0.989010394),
    ["Coffin Room"] = CFrame.new(8115.72949, 81.5116348, 3563.58252, 0.999861181, 4.8363944e-09, 0.0166631918, -4.61536453e-09, 1, -1.33030325e-08, -0.0166631918, 1.32242786e-08, 0.999861181),
    ["Kitchen"] = CFrame.new(8196.88086, 100.611847, 3641.15967, 0.0568975545, -1.63478759e-08, -0.998380005, 8.93332341e-09, 1, -1.58652931e-08, 0.998380005, -8.01615485e-09, 0.0568975545),
    ["Island"] = CFrame.new(-2855.55933, -785.993164, 15511.7393, -0.419365525, 3.11538741e-08, 0.907817483, -2.97939575e-08, 1, -4.80806293e-08, -0.907817483, -4.72108326e-08, -0.419365525)
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

-- GAMEMODE SECTION
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
    ["Honeycomb"] = CFrame.new(48.0107231, 26.2989159, 3139.28125, 0.577934206, -3.13240811e-08, 0.816083372, 1.06247038e-08, 1, 3.08592263e-08, -0.816083372, -9.16395759e-09, 0.577934206),
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




-- ================== NOTIFICATION ==================
game.StarterGui:SetCore("SendNotification", {
    Title = "Squid Game X FREE GUY !",
    Text = "GOD SCRIPT BY SWAMM| Follow @zigs_009!",
    Duration = 10
})




