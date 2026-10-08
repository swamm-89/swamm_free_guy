

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



-- ================== PLAYER TAB ==================



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







-- ================== NOTIFICATION ==================
game.StarterGui:SetCore("SendNotification", {
    Title = "Squid Game X FREE GUY !",
    Text = "GOD SCRIPT BY SWAMM| Follow @zigs_009!",
    Duration = 10
})




