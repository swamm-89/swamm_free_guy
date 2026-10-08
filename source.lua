--     BEAUTIFUL RED ♥️ SPLASH SCREEN - FINAL CLEAN VERSION
--     No Close Button | Auto 5 Sec Fade Out | Super Beautiful Fonts & Colors
-- ====================================================

local TweenService = game:GetService("TweenService")

task.wait(0.4)

-- ====================================================
-- Create ScreenGui (CoreGui mein for full screen effect)
-- ====================================================
local splashGui = Instance.new("ScreenGui")
splashGui.Name = "LeoXBeautifulSplash"
splashGui.IgnoreGuiInset = true
splashGui.ResetOnSpawn = false
splashGui.Parent = game:GetService("CoreGui")

-- Main Frame - Ultra beautiful dark romantic red base
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 0, 8)   -- deep luxurious red-black
mainFrame.BackgroundTransparency = 0.35
mainFrame.BorderSizePixel = 0
mainFrame.Parent = splashGui

-- Premium Gradient - red rose to soft crimson glow
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(190, 30, 70)),   -- rich rose
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 90, 130)),  -- vibrant heart red
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(220, 60, 100)),  -- warm crimson
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(190, 30, 70))
}
uiGradient.Rotation = 120
uiGradient.Transparency = NumberSequence.new(0.3)
uiGradient.Parent = mainFrame

-- Elegant glow border
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(255, 140, 180)
uiStroke.Transparency = 0.45
uiStroke.Thickness = 5.5
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = mainFrame

-- Super smooth rounded corners
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 32)
uiCorner.Parent = mainFrame

-- Big Beautiful Title - LeoX ♥️
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.92, 0, 0.42, 0)
title.Position = UDim2.new(0.04, 0, 0.18, 0)
title.BackgroundTransparency = 1
title.Text = "M3GUN ♥️"
title.TextColor3 = Color3.fromRGB(255, 160, 190)   -- soft glowing pink-red
title.TextScaled = true
title.Font = Enum.Font.FredokaOne                 -- rounded, cute & premium
title.TextStrokeTransparency = 0.55
title.TextStrokeColor3 = Color3.fromRGB(180, 20, 70)
title.Parent = mainFrame

-- Elegant Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0.82, 0, 0.14, 0)
subtitle.Position = UDim2.new(0.09, 0, 0.54, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Squid Game X • Free Guy"
subtitle.TextColor3 = Color3.fromRGB(255, 210, 230)
subtitle.TextScaled = true
subtitle.Font = Enum.Font.GothamBlack             -- sharp & luxurious
subtitle.TextStrokeTransparency = 0.75
subtitle.Parent = mainFrame

-- Heart-touching tagline
local loveTag = Instance.new("TextLabel")
loveTag.Size = UDim2.new(0.7, 0, 0.1, 0)
loveTag.Position = UDim2.new(0.15, 0, 0.71, 0)
loveTag.BackgroundTransparency = 1
loveTag.Text = "Vision By SWAMM 💫♥️"
loveTag.TextColor3 = Color3.fromRGB(255, 190, 210)
loveTag.TextScaled = true
loveTag.Font = Enum.Font.FredokaOne
loveTag.TextStrokeTransparency = 0.8
loveTag.Parent = mainFrame

-- ====================================================
-- ULTRA BEAUTIFUL ANIMATIONS
-- ====================================================

local tweenFast = TweenInfo.new(1.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenPulse = TweenInfo.new(2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)

-- Fade + scale in
TweenService:Create(mainFrame, tweenFast, {BackgroundTransparency = 0.35}):Play()
TweenService:Create(title, tweenFast, {TextTransparency = 0}):Play()
TweenService:Create(subtitle, tweenFast, {TextTransparency = 0}):Play()
TweenService:Create(loveTag, tweenFast, {TextTransparency = 0}):Play()

-- Romantic heartbeat pulse on title
TweenService:Create(title, tweenPulse, {
    TextTransparency = 0.08,
    Rotation = 2.5,
    Size = UDim2.new(0.95, 0, 0.44, 0)
}):Play()

-- ====================================================
-- AUTO FADE OUT AFTER 5 SECONDS - No Button
-- ====================================================
task.delay(5, function()
    local fadeOut = TweenInfo.new(1.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    
    TweenService:Create(mainFrame, fadeOut, {BackgroundTransparency = 1}):Play()
    TweenService:Create(title, fadeOut, {TextTransparency = 1}):Play()
    TweenService:Create(subtitle, fadeOut, {TextTransparency = 1}):Play()
    TweenService:Create(loveTag, fadeOut, {TextTransparency = 1}):Play()
    
    task.delay(1.5, function()
        splashGui:Destroy()
        print("Beautiful LeoX ♥️ Splash faded out perfectly!")
        -- Yahan se tumhara Rayfield ya baaki script load kar sakte ho
    end)
end)


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
local NewModsTab = Window:CreateTab("NEW MODS", 4483362458)
local GuardTab = Window:CreateTab("Guard", 4483362458)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local VisualTab = Window:CreateTab("👁️ Visual Spy", 4483362458)
local GamemodeTab = Window:CreateTab("🎮 Gamemode", 4483362458)
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


local espEnabled = false
PlayerTab:CreateToggle({ Name = "📍 Player ESP", CurrentValue = false,
    Callback = function(Value)
        espEnabled = Value
        if espEnabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local hl = Instance.new("Highlight", p.Character)
                    hl.Name = "SquidESP"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.5
                end
            end
        else
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character then
                    local hl = p.Character:FindFirstChild("SquidESP")
                    if hl then hl:Destroy() end
                end
            end
        end
    end
})

----KILL ALL-------

local Players = game.Players
local LocalPlayer = Players.LocalPlayer

local KillAllActive = false
local FriendProtect = true

local OriginalSizes = {}
local Connections = {}

local function ApplyState(plr)
    if plr == LocalPlayer or not plr.Character then return end
    
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if not OriginalSizes[plr] then
        OriginalSizes[plr] = hrp.Size
    end
    
    local isFriend = FriendProtect and plr:IsFriendsWith(LocalPlayer.UserId)
    
    if KillAllActive then
        if isFriend then
            hrp.Size = OriginalSizes[plr] or Vector3.new(2, 2, 1)
            hrp.CanCollide = true
        else
            hrp.Size = Vector3.new(500, 500, 500)
            hrp.CanCollide = false
        end
    else
        hrp.Size = OriginalSizes[plr] or Vector3.new(2, 2, 1)
        hrp.CanCollide = true
    end
end

local function SetupPlayer(plr)
    local charConn
    charConn = plr.CharacterAdded:Connect(function(char)
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if hrp then
            ApplyState(plr)
        end
    end)
    
    if plr.Character then
        task.spawn(function() ApplyState(plr) end)
    end
    
    Connections[plr] = charConn
end

local playerAddedConn = Players.PlayerAdded:Connect(SetupPlayer)

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        SetupPlayer(plr)
    end
end

PlayerTab:CreateToggle({
    Name = "All Kill 🔥",
    CurrentValue = false,
    Callback = function(value)
        KillAllActive = value
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                ApplyState(plr)
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Friend Protection ❤️",
    CurrentValue = true,
    Callback = function(value)
        FriendProtect = value
        if KillAllActive then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    ApplyState(plr)
                end
            end
        end
    end
})

Players.PlayerRemoving:Connect(function(plr)
    if Connections[plr] then
        Connections[plr]:Disconnect()
        Connections[plr] = nil
    end
    OriginalSizes[plr] = nil
end)

-- ================== AUTO BABY PICKUP (INSTANT AT MY POSITION - NO TELEPORT) ==================
local autoBabyInstantPickup = false
local autoBabyConnection

PlayerTab:CreateToggle({
    Name = "Auto Baby Pickup 🐥",
    CurrentValue = false,
    Callback = function(Value)
        autoBabyInstantPickup = Value
        if Value then
            autoBabyConnection = RunService.Heartbeat:Connect(function()
                if not autoBabyInstantPickup then return end
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
                
                local droppedBaby = workspace:FindFirstChild("BabyPickup")
                if droppedBaby and droppedBaby:IsA("Model") then
                    local success, err = pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.BabyAction:FireServer()
                    end)
                    
                    wait(0.4)
                end
            end)
        else
            if autoBabyConnection then 
                autoBabyConnection:Disconnect() 
                autoBabyConnection = nil
            end
        end
    end
})

---AUTO SWING--
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local autoSwingEnabled = false
local SWING_SPEED = 0.01  -- Maximum speed (jitna kam utna fast, 0.01 Delta pe safe & max)

PlayerTab:CreateToggle({
    Name = "Auto Swing ⚠️",
    CurrentValue = false,
    Callback = function(value)
        autoSwingEnabled = value
        
        if autoSwingEnabled then
            task.spawn(function()
                while autoSwingEnabled do
                    local char = player.Character
                    if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                        local tool = char:FindFirstChildWhichIsA("Tool")
                        if tool then
                            pcall(function()
                                tool:Activate()
                            end)
                        end
                    end
                    task.wait(SWING_SPEED)
                end
            end)
        end
        -- No notifications
    end
})

-----ANTI PUSH------------

do -- << 'do' BLOCK (Safety Wrapper) >>

    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    -- ===== VARIABLES =====
    local TankConnection = nil
    local TankModeEnabled = false

    -- ===== LOGIC FUNCTIONS (SAME AS YOUR CODE) =====

    local function EnableTank()
        -- Purana connection hatao agar hai
        if TankConnection then TankConnection:Disconnect() end
        
        TankConnection = RunService.RenderStepped:Connect(function()
            if TankModeEnabled and LocalPlayer.Character then
                local Root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                
                if Root and Humanoid then
                    -- 1. Create or Find BodyVelocity (Movement Force)
                    local BV = Root:FindFirstChild("TankVelocity")
                    if not BV then
                        BV = Instance.new("BodyVelocity")
                        BV.Name = "TankVelocity"
                        BV.Parent = Root
                        -- X aur Z par High Force (No Push), Y par 0 (Gravity On)
                        BV.MaxForce = Vector3.new(100000, 0, 100000) 
                    end
                    
                    -- 2. Update Velocity based on Movement
                    if Humanoid.MoveDirection.Magnitude > 0 then
                        -- Agar chal rahe ho, toh us direction me force lagao
                        BV.Velocity = Humanoid.MoveDirection * Humanoid.WalkSpeed
                    else
                        -- Agar ruke ho, toh Velocity 0 karo (Anchor Effect)
                        BV.Velocity = Vector3.new(0, 0, 0)
                    end
                    
                    -- 3. Create or Find BodyGyro (Stabilizer)
                    local BG = Root:FindFirstChild("TankGyro")
                    if not BG then
                        BG = Instance.new("BodyGyro")
                        BG.Name = "TankGyro"
                        BG.Parent = Root
                        BG.MaxTorque = Vector3.new(100000, 100000, 100000)
                        BG.P = 3000
                        BG.D = 100
                    end

                    -- Update Rotation
                    if Humanoid.MoveDirection.Magnitude > 0 then
                        -- Move direction ki taraf face karo
                        BG.CFrame = CFrame.new(Root.Position, Root.Position + Humanoid.MoveDirection)
                    else
                        -- Ruke ho toh current position hold karo
                        BG.CFrame = Root.CFrame
                    end
                end
            end
        end)
    end

    local function DisableTank()
        if TankConnection then TankConnection:Disconnect() end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local Root = LocalPlayer.Character.HumanoidRootPart
            if Root:FindFirstChild("TankVelocity") then Root.TankVelocity:Destroy() end
            if Root:FindFirstChild("TankGyro") then Root.TankGyro:Destroy() end
        end
    end

    PlayerTab:CreateToggle({
        Name = "✋ Anti-Push",
        CurrentValue = false,
        Flag = "TankModeToggle",
        Callback = function(Value)
            TankModeEnabled = Value
            if Value then
                EnableTank()
            else
                DisableTank()
            end
        end,
    })

    -- Cleanup on Respawn
    LocalPlayer.CharacterAdded:Connect(function()
        TankModeEnabled = false
        DisableTank()
        -- Note: Rayfield Toggle visual reset nahi hota automatic, logic reset ho jayega.
    end)

end -- << END OF BLOCK >>


-- ================== JERK OFF TOGGLE (Clean & Stable) ==================
local JerkToggleEnabled = false
local currentAnimationTrack = nil
local animationConnection = nil

local function stopJerkAnimation()
    JerkToggleEnabled = false
    
    if currentAnimationTrack then
        currentAnimationTrack:Stop()
        currentAnimationTrack = nil
    end
    
    if animationConnection then
        animationConnection:Disconnect()
        animationConnection = nil
    end
end

local function startJerkAnimation()
    if JerkToggleEnabled then return end
    
    local character = player.Character
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    
    if not humanoid then
        Rayfield:Notify({
            Title = "Error",
            Content = "Humanoid nahi mila! Character respawn karo.",
            Duration = 3,
        })
        return
    end

    JerkToggleEnabled = true

    local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
    local animId = isR15 and "rbxassetid://698251653" or "rbxassetid://72042024"

    local animation = Instance.new("Animation")
    animation.AnimationId = animId

    currentAnimationTrack = humanoid:LoadAnimation(animation)

    -- Main Loop
    animationConnection = task.spawn(function()
        while JerkToggleEnabled do
            if currentAnimationTrack then
                currentAnimationTrack:Play()
                currentAnimationTrack:AdjustSpeed(isR15 and 0.7 or 0.65)
                currentAnimationTrack.TimePosition = 0.6

                task.wait(0.1)

                while currentAnimationTrack and currentAnimationTrack.TimePosition < (isR15 and 0.7 or 0.65) and JerkToggleEnabled do
                    task.wait(0.1)
                end

                if currentAnimationTrack then
                    currentAnimationTrack:Stop()
                end
            end
            task.wait(0.05)  -- Smooth loop
        end
    end)
     
end

-- ================== GUI TOGGLE ==================

PlayerTab:CreateToggle({
    Name = "🔞 Fun Tools",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            startJerkAnimation()
        else
            stopJerkAnimation()
            Rayfield:Notify({
                Title = "Jerk Off",
                Content = "Animation Stopped.",
                Duration = 2,
            })
        end
    end
})



----  ============ ===========NEW MODS =================================

-----FOLLOW PLAYER-----

NewModsTab:CreateButton({
    Name = "👤 Follow Player",
    Callback = function()
        Rayfield:Notify({
            Title = "Loading",
            Content = "Script GUI load ho raha hai...",
            Duration = 4
        })

        local success, err = pcall(function()
            loadstring(game:HttpGet("https://pastebin.com/raw/T2frP6Uq"))()
        end)

        if success then
            Rayfield:Notify({
                Title = "Success",
                Content = "GUI Successfully Loaded!",
                Duration = 4
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = tostring(err),
                Duration = 6
            })
        end
    end
})

local antiDetectEnabled = false
local remoteRef = nil
local originalRemoteParent = nil

local function getRemote()
    if remoteRef then return remoteRef end
    pcall(function()
        remoteRef = workspace:FindFirstChild("Map")
            and workspace.Map:FindFirstChild("RedLightGreenLight")
            and workspace.Map.RedLightGreenLight:FindFirstChild("Remotes")
            and workspace.Map.RedLightGreenLight.Remotes:FindFirstChild("RemoteEvent")
    end)
    return remoteRef
end


NewModsTab:CreateToggle({
    Name = "🛡️ RLGL ANTI MOVE",
    CurrentValue = false,
    Callback = function(Value)
        antiDetectEnabled = Value
        local remote = getRemote()
        if not remote then
            antiDetectEnabled = false  
            return
        end
        
        if Value then
            -- ON: Block remote
            originalRemoteParent = remote.Parent
            remote.Parent = nil
        else
            -- OFF: Restore remote
            if originalRemoteParent then
                remote.Parent = originalRemoteParent
                originalRemoteParent = nil
            end
        end
    end
})


-----GLASSS REVEAL HACK--------------------

local espEnabled = false
local highlights = {}

-- Get Glasses folder
local function getGlasses()
    return workspace:FindFirstChild("Map")
        and workspace.Map:FindFirstChild("Glass")
        and workspace.Map.Glass:FindFirstChild("Glasses")
end

-- Add red ESP on wrong glass
local function addESP(part)
    if highlights[part] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0)      -- Red fill
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0) -- Yellow outline
    highlight.FillTransparency = 0.4
    highlight.OutlineTransparency = 0
    highlight.Parent = part
    highlights[part] = highlight
end

-- Clear all ESP
local function clearESP()
    for part, hl in pairs(highlights) do
        if hl and hl.Parent then hl:Destroy() end
    end
    highlights = {}
end

-- Detect once and apply ESP
local function detectAndESP()
    clearESP()  -- Purana ESP hata
    local glasses = getGlasses()
    if not glasses then
        return false
    end
    
    for _, pair in pairs(glasses:GetChildren()) do
        if pair:IsA("BasePart") then
            if not pair.CanCollide then  -- Wrong = CanCollide false
                addESP(pair)
            end
        end
    end
    return true
end

-- Toggle only (ON pe detect once, no loop)
NewModsTab:CreateToggle({
    Name = "🟥 GLASS ESP",
    CurrentValue = false,
    Callback = function(Value)
        espEnabled = Value
        if Value then
            detectAndESP()  -- Ek baar detect kar
        else
            clearESP()      -- OFF pe remove
        end
    end
})


-----------------------------INVISIBLE HACK-------------------------

do -- << 'do' BLOCK (Safety Wrapper) >>

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Debris = game:GetService("Debris")

    -- ===== CONFIGURATION =====
    local INVIS_POS = Vector3.new(-25.95, 84, 3537.55) 
    local SOUND_ID = "rbxassetid://942127495"

    -- ===== STATE =====
    local invisEnabled = false  -- 🔥 invis state remember karega

    -- ===== HELPER FUNCTIONS =====

    -- 1. Sound Function
    local function PlayToggleSound()
        local sound = Instance.new("Sound")
        sound.Name = "InvisSound"
        sound.SoundId = SOUND_ID
        sound.Volume = 1
        sound.Parent = game:GetService("SoundService")
        sound:Play()
        Debris:AddItem(sound, 2)
    end

    -- 2. Transparency Handler
    local function SetVisualTransparency(val)
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    if part.Name ~= "HumanoidRootPart" then
                        part.Transparency = val
                    end
                end
            end
        end
    end

    -- ===== MAIN LOGIC =====

    local function ApplyInvisToCharacter(char)
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end

        local hrp = char.HumanoidRootPart
        local savedPos = hrp.CFrame

        hrp.CFrame = CFrame.new(INVIS_POS)
        task.wait(0.15)

        local seat = Instance.new("Seat")
        seat.Name = "InvisSeat"
        seat.Anchored = false
        seat.CanCollide = false
        seat.Transparency = 1
        seat.Position = INVIS_POS
        seat.Parent = workspace

        local weld = Instance.new("Weld")
        weld.Part0 = seat
        weld.Part1 = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        weld.Parent = seat

        task.wait(0.1)
        seat.CFrame = savedPos

        SetVisualTransparency(0.5)
    end

    local function RemoveInvis()
        local seat = workspace:FindFirstChild("InvisSeat")
        if seat then seat:Destroy() end
        SetVisualTransparency(0)
    end

    local function ToggleInvisibility(State)
        invisEnabled = State

        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end

        PlayToggleSound()

        if State then
            ApplyInvisToCharacter(char)
        else
            RemoveInvis()
        end
    end

    -- ===== UI =====

    NewModsTab:CreateToggle({
        Name = "👻 Invisible Mode",
        CurrentValue = false,
        Flag = "InvisToggle",
        Callback = function(Value)
            ToggleInvisibility(Value)
        end,
    })

    -- ===== AUTO RE-APPLY ON RESPAWN / LOBBY TP =====

    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.5) -- thoda wait taaki HRP load ho jaaye
        if invisEnabled then
            ApplyInvisToCharacter(char) -- 🔥 new round pe auto invis
        else
            RemoveInvis()
        end
    end)

    Players.PlayerRemoving:Connect(function(plr)
        if plr == LocalPlayer then
            RemoveInvis()
        end
    end)

end -- << END OF BLOCK >>

----------------FRONTMAN HIGHTLIGTER-----------

NewModsTab:CreateToggle({
   Name = "🕵️‍♂️ Frontman Highlighter",
   CurrentValue = false,
   Flag = "highlighter",
   Callback = function(Value)
       -- Frontman Highlighter Script
       -- This script highlights the Frontman player with a yellow glow

       local Players = game:GetService("Players")
       local ReplicatedStorage = game:GetService("ReplicatedStorage")
       local RunService = game:GetService("RunService")

       local LocalPlayer = Players.LocalPlayer

       -- Function to create highlight effect
       local function createFrontmanHighlight(player)
           if not player.Character then
               return nil
           end
           
           -- Create highlight object
           local highlight = Instance.new("Highlight")
           highlight.Name = "FrontmanHighlight"
           highlight.FillColor = Color3.fromRGB(255, 255, 0)  -- Yellow
           highlight.OutlineColor = Color3.fromRGB(255, 215, 0) -- Gold outline
           highlight.FillTransparency = 0.3
           highlight.OutlineTransparency = 0
           highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
           highlight.Parent = player.Character
           
           return highlight
       end

       -- Function to remove highlight
       local function removeFrontmanHighlight(player)
           if player.Character then
               local existingHighlight = player.Character:FindFirstChild("FrontmanHighlight")
               if existingHighlight then
                   existingHighlight:Destroy()
               end
           end
       end

       -- Function to remove all highlights from all players
       local function removeAllHighlights()
           for _, player in ipairs(Players:GetPlayers()) do
               removeFrontmanHighlight(player)
           end
       end

       -- Function to check for Frontman and apply highlight
       local function checkAndHighlightFrontman()
           for _, player in ipairs(Players:GetPlayers()) do
               -- Remove any existing highlights first
               removeFrontmanHighlight(player)
               
               -- Check if this player is the Frontman
               if player:GetAttribute("IsFrontman") then
                   -- Add highlight to Frontman
                   local highlight = createFrontmanHighlight(player)
                   
                   -- If character doesn't exist yet, wait for it
                   if not highlight then
                       player.CharacterAdded:Connect(function()
                           wait(1) -- Wait for character to fully load
                           if player:GetAttribute("IsFrontman") then
                               createFrontmanHighlight(player)
                           end
                       end)
                   end
               end
           end
       end

       -- Table to store connections so we can disconnect them later
       local connections = {}

       -- Listen for attribute changes
       local function setupFrontmanTracking()
           -- Initial check
           checkAndHighlightFrontman()
           
           -- Listen for changes to IsFrontman attribute on all players
           for _, player in ipairs(Players:GetPlayers()) do
               local connection = player:GetAttributeChangedSignal("IsFrontman"):Connect(function()
                   checkAndHighlightFrontman()
               end)
               table.insert(connections, connection)
           end
           
           -- Listen for new players
           local playerAddedConnection = Players.PlayerAdded:Connect(function(player)
               local attributeConnection = player:GetAttributeChangedSignal("IsFrontman"):Connect(function()
                   checkAndHighlightFrontman()
               end)
               table.insert(connections, attributeConnection)
               
               local characterConnection = player.CharacterAdded:Connect(function(character)
                   -- Wait a moment for attributes to load
                   wait(0.5)
                   if player:GetAttribute("IsFrontman") then
                       createFrontmanHighlight(player)
                   end
               end)
               table.insert(connections, characterConnection)
           end)
           table.insert(connections, playerAddedConnection)
           
           -- Listen for character changes on existing players
           for _, player in ipairs(Players:GetPlayers()) do
               local characterConnection = player.CharacterAdded:Connect(function(character)
                   wait(0.5)
                   if player:GetAttribute("IsFrontman") then
                       createFrontmanHighlight(player)
                   end
               end)
               table.insert(connections, characterConnection)
           end
       end

       if Value then
           -- Toggle is ON - start tracking the Frontman
           setupFrontmanTracking()
       else
           -- Toggle is OFF - remove all highlights and disconnect events
           removeAllHighlights()
           
           -- Disconnect all connections
           for _, connection in ipairs(connections) do
               connection:Disconnect()
           end
           connections = {} -- Clear the connections table
       end
   end,
})


---=== SAFE TP ---===-------------------------

-- ================== MANUAL SAFE TP - 4999 HEIGHT ==================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

local safeHeight = 4999
local isSafe = false
local oldCFrame = nil
local safePlatform = nil

local function ToggleSafeTP(state)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = character.HumanoidRootPart

    if state and not isSafe then
        -- === SAFE MODE ON ===
        isSafe = true
        oldCFrame = hrp.CFrame   -- Purani position save kar lo

        -- Safe Platform banao (girne se bachne ke liye)
        safePlatform = Instance.new("Part")
        safePlatform.Name = "SafePlatform"
        safePlatform.Size = Vector3.new(50, 4, 50)
        safePlatform.Position = Vector3.new(0, safeHeight - 6, 0)
        safePlatform.Anchored = true
        safePlatform.CanCollide = true
        safePlatform.Transparency = 0.3
        safePlatform.Color = Color3.fromRGB(0, 170, 255)
        safePlatform.Material = Enum.Material.ForceField
        safePlatform.Parent = Workspace

        -- Teleport to safe height
        hrp.CFrame = CFrame.new(0, safeHeight, 0)

    elseif not state and isSafe then
        -- === SAFE MODE OFF - WAPAS AAO ===
        isSafe = false

        -- Purani position pe wapas le jao
        if oldCFrame then
            hrp.CFrame = oldCFrame
        end

        -- Platform delete kar do
        if safePlatform then
            safePlatform:Destroy()
            safePlatform = nil
        end
    end
end

-- ================== TOGGLE BUTTON ==================
NewModsTab:CreateToggle({
    Name = "🛡️ Safe TP ",
    CurrentValue = false,
    Callback = function(Value)
        ToggleSafeTP(Value)
    end,
})

-- ================== REMOVE ROPE (JUMP ROPE - ONE-TIME DELETE) ==================
local removeRopeEnabled = false

NewModsTab:CreateToggle({
    Name = "Remove Rope 🪢 ",
    CurrentValue = false,
    Callback = function(Value)
        removeRopeEnabled = Value
        
        if Value then
            local map = workspace:FindFirstChild("Map")
            if map then
                local jumpRope = map:FindFirstChild("JumpRope")
                if jumpRope then
                    local rope = jumpRope:FindFirstChild("Rope")
                    if rope then  -- No need to check IsA("Folder"), destroy whatever it is
                        rope:Destroy()
                        -- Optional silent notification (comment out if not wanted)
                        -- game.StarterGui:SetCore("SendNotification", {
                        --     Title = "Remove Rope",
                        --     Text = "Rope deleted!",
                        --     Duration = 3
                        -- })
                    end
                end
            end
        end
        -- OFF karne pe kuch nahi, rope already gayab
    end
})



-- ================== FLY HACK - PC PERFECT + PHONE SAME FEEL (JUMP ONLY UP) ==================
local flyActive = false
local flySpeed = 70
local bv, bg
local flyConnection

local function startFly()
    if flyActive then return end
    flyActive = true

    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")
    local cam = workspace.CurrentCamera

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = hrp

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 15000
    bg.Parent = hrp

    flyConnection = RunService.Heartbeat:Connect(function(dt)
        if not flyActive or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

        local move = Vector3.new(0, 0, 0)

        -- PC: Keyboard controls (unchanged - perfect as per you)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            move = move + cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            move = move - cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            move = move - cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            move = move + cam.CFrame.RightVector
        end

        -- Phone: Joystick input (fixed to match PC feel - dynamic camera, no fixed direction)
        if UserInputService.TouchEnabled then
            local joystickDir = humanoid.MoveDirection
            if joystickDir.Magnitude > 0.05 then  -- deadzone
                move = joystickDir * flySpeed
            end
        end

        -- Normalize and apply speed (only if PC input, since phone already normalized)
        if move.Magnitude > 0 and not UserInputService.TouchEnabled then
            move = move.Unit * flySpeed
        end

        -- Jump button logic: ONLY UP (tap or hold = rise, no down)
        local verticalVelocity = 0
        if humanoid.Jump or UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            verticalVelocity = flySpeed * 1.2  -- Adjust this value for rise speed (1.0 = slow, 1.5 = fast)
        end

        -- Final velocity: horizontal move + vertical rise from jump
        bv.Velocity = Vector3.new(move.X, verticalVelocity, move.Z)

        bg.CFrame = cam.CFrame

        -- Anti-fall protection (same)
        if hrp.Velocity.Y < -50 then
            bv.Velocity = Vector3.new(move.X, flySpeed, move.Z)
        end
    end)
end

local function stopFly()
    flyActive = false
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
end

-- Respawn handler (same)
player.CharacterAdded:Connect(function()
    task.wait(2)
    if flyActive then startFly() end
end)

NewModsTab:CreateToggle({
    Name = "Fly ✈️ ",
    CurrentValue = false,
    Callback = function(v)
        if v then startFly() else stopFly() end
    end
})

NewModsTab:CreateSlider({
    Name = "Fly Speed",
    Range = {50, 400},
    Increment = 10,
    CurrentValue = 70,
    Callback = function(v) flySpeed = v end
})






-- Hitbox Expander--------------

NewModsTab:CreateSection("Hitbox Expander")
NewModsTab:CreateToggle({ Name = "Hitbox Expander", CurrentValue = false,
    Callback = function(Value)
        hitboxEnabled = Value
        if hitboxEnabled then
            task.spawn(function()
                while hitboxEnabled do
                    PlayersList = {}
                    for _, pl in ipairs(Players:GetPlayers()) do
                        if pl ~= player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                            table.insert(PlayersList, pl)
                        end
                    end
                    task.wait(2)
                end
            end)
            hitboxConnection = RunService.Heartbeat:Connect(function()
                if not hitboxEnabled then return end
                for _, pl in ipairs(PlayersList) do
                    if pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                        local part = pl.Character.HumanoidRootPart
                        part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        part.Transparency = hitboxTransparency
                        part.BrickColor = BrickColor.new("Bright blue")
                        part.Material = Enum.Material.ForceField
                        part.CanCollide = false
                    end
                end
            end)
        else
            for _, pl in ipairs(PlayersList) do
                if pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                    local part = pl.Character.HumanoidRootPart
                    part.Size = Vector3.new(2, 2, 1)
                    part.Transparency = 0
                    part.CanCollide = true
                end
            end
            if hitboxConnection then hitboxConnection:Disconnect() end
        end
    end
})
NewModsTab:CreateSlider({ Name = "Hitbox Size", Range = {1, 500}, Increment = 1, CurrentValue = 10, Callback = function(v) hitboxSize = v end })
NewModsTab:CreateSlider({ Name = "Transparency", Range = {0, 1}, Increment = 0.1, CurrentValue = 1, Callback = function(v) hitboxTransparency = v end })

Players.PlayerRemoving:Connect(function(plr)
    if Connections[plr] then
        Connections[plr]:Disconnect()
        Connections[plr] = nil
    end
    originalProps[plr] = nil
end)




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

-- ================== GUARD TAB ==================

-- FRIEND PROTECTION
local friendProtection = true

-- GUN ADDER SYSTEM
local customGuns = {}  -- User added guns
local permanentGuns = {"MP5", "Golden MP5", "Revolver", "MPS-5", "Golden MPS-5"}  -- PERMANENT + GOLDEN MPS-5

local autoHit = false

-- FRIEND PROTECTION TOGGLE
GuardTab:CreateToggle({
    Name = "Friend Protection ❤️",
    CurrentValue = true,
    Callback = function(Value)
        friendProtection = Value
        local status = friendProtection and "ON (Friends Safe)" or "OFF (No Protection)"
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = "Friend Protection",
                Text = status,
                Duration = 3
            })
        end)
    end
})


-- AUTO KILL 
GuardTab:CreateToggle({ 
    Name = "GOD Auto Kill 💀 ", 
    CurrentValue = false,
    Callback = function(Value)
        autoHit = Value
        if autoHit then
            task.spawn(function()
                local weaponHit = ReplicatedStorage:WaitForChild("Local"):WaitForChild("GunSystem"):WaitForChild("Network"):WaitForChild("WeaponHit")
                local weaponFired = ReplicatedStorage:WaitForChild("Local"):WaitForChild("GunSystem"):WaitForChild("Network"):WaitForChild("WeaponFired")
                local onGunUsed = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("onGunUsed")

                while autoHit do
                    task.wait(0.15)
                    local char = player.Character or player.CharacterAdded:Wait()
                    local backpack = player.Backpack

                    -- FIND GUN: PERMANENT + CUSTOM
                    local gun
                    for _, name in ipairs(permanentGuns) do
                        gun = backpack:FindFirstChild(name) or char:FindFirstChild(name)
                        if gun then break end
                    end
                    if not gun then
                        for _, name in ipairs(customGuns) do
                            gun = backpack:FindFirstChild(name) or char:FindFirstChild(name)
                            if gun then break end
                        end
                    end

                    if gun then
                        local isMPS5 = gun.Name == "MPS-5" or gun.Name == "Golden MPS-5"
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if not root then continue end

                        for _, plr in pairs(Players:GetPlayers()) do
                            if plr ~= player 
                                and (not friendProtection or not player:IsFriendsWith(plr.UserId))
                                and plr.Character 
                                and plr.Character:FindFirstChild("HumanoidRootPart") then

                                local target = plr.Character
                                local part = target:FindFirstChild("LeftUpperLeg") or target:FindFirstChild("HumanoidRootPart")
                                local humanoid = target:FindFirstChild("Humanoid")
                                if not (part and humanoid) then continue end

                                local distance = (root.Position - part.Position).Magnitude
                                local direction = (part.Position - root.Position).Unit
                                local shotId = isMPS5 and math.random(10, 99) or math.random(100, 999)

                                if isMPS5 then
                                    pcall(function() onGunUsed:FireServer() end)
                                    local firedArgs = { gun, { root.Position, direction, Vector2.new(0, math.random(20, 50)) } }
                                    pcall(function() weaponFired:FireServer(unpack(firedArgs)) end)
                                    local hitArgs = { gun, { p = part.Position, pid = 1, part = part, d = distance, maxDist = distance + 0.1, h = humanoid, m = Enum.Material.Plastic, n = direction, t = tick(), sid = shotId } }
                                    pcall(function() weaponHit:FireServer(unpack(hitArgs)) end)
                                else
                                    local hitArgs = { gun, { p = part.Position, pid = 1, part = part, d = 999, maxDist = 999, h = humanoid, m = Enum.Material.Plastic, n = Vector3.new(0, -1, 0), t = tick(), sid = shotId } }
                                    pcall(function() weaponHit:FireServer(unpack(hitArgs)) end)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})


-- AUTO CLEAN (100x/sec SPAM + TELEPORT BACK TOGGLE)
local autoClean = false
local cleanTeleportBack = true
local lastFired = {}
GuardTab:CreateToggle({ Name = "Auto Clean 💨", CurrentValue = false,
    Callback = function(Value)
        autoClean = Value
        if autoClean then
            task.spawn(function()
                local DISTANCE_OVERRIDE = 9999
                local PROMPT_COOLDOWN = 0.01
                local TELEPORT_OFFSET = Vector3.new(0, 5, 0)
                local HOLD_DURATION = 0.05

                local function safeFirePrompt(prompt)
                    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
                    local now = tick()
                    if lastFired[prompt] and now - lastFired[prompt] < PROMPT_COOLDOWN then return false end

                    local char = player.Character
                    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
                    local hrp = char.HumanoidRootPart
                    local origPos = hrp.CFrame

                    local origDist = pcall(function() return prompt.MaxActivationDistance end) and prompt.MaxActivationDistance or 10
                    local origEnabled = prompt.Enabled
                    local origLOS = prompt.RequiresLineOfSight
                    local origHold = prompt.HoldDuration

                    pcall(function()
                        prompt.MaxActivationDistance = DISTANCE_OVERRIDE
                        prompt.Enabled = true
                        prompt.RequiresLineOfSight = false
                        prompt.HoldDuration = HOLD_DURATION
                    end)

                    local targetPos = prompt.Parent.Position + TELEPORT_OFFSET
                    pcall(function() hrp.CFrame = CFrame.new(targetPos) end)

                    local fired = pcall(function() fireproximityprompt(prompt, HOLD_DURATION) end)

                    task.wait(0.01)
                    if cleanTeleportBack then pcall(function() hrp.CFrame = origPos end) end
                    task.wait(0.005)

                    pcall(function()
                        prompt.MaxActivationDistance = origDist
                        prompt.Enabled = origEnabled
                        prompt.RequiresLineOfSight = origLOS
                        prompt.HoldDuration = origHold
                    end)

                    lastFired[prompt] = tick()
                    return fired
                end

                RunService.Heartbeat:Connect(function()
                    if not autoClean then return end
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr ~= player then
                            local model = workspace:FindFirstChild(plr.Name)
                            if model then
                                local parts = {model:FindFirstChild("HumanoidRootPart"), model:FindFirstChild("Head"), model:FindFirstChild("UpperTorso"), model:FindFirstChild("Torso")}
                                for _, part in pairs(parts) do
                                    if part then
                                        for _, child in pairs(part:GetChildren()) do
                                            if child:IsA("ProximityPrompt") and (child.Name == "Clean" or (child.ActionText and child.ActionText == "Clean Up")) then
                                                safeFirePrompt(child)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end)
        end
    end
})

GuardTab:CreateToggle({ Name = "Teleport Back After Clean ⏳", CurrentValue = true,
    Callback = function(Value) cleanTeleportBack = Value end
})

-- Auto Pickup & Burn
local autoPickup = false
GuardTab:CreateToggle({ Name = "Auto Pickup Body 🥀⚰️", CurrentValue = false,
    Callback = function(Value)
        autoPickup = Value
        if autoPickup then
            task.spawn(function()
                while autoPickup do
                    task.wait(0.3)
                    if workspace.Data.IncinerationRoom:FindFirstChild("PickupCoffins") then
                        for _, v in pairs(workspace.Data.IncinerationRoom.PickupCoffins:GetChildren()) do
                            if v:FindFirstChild("Main") and v.Main:FindFirstChild("Pickup") then
                                fireproximityprompt(v.Main.Pickup)
                            end
                        end
                    end
                end
            end)
        end
    end
})

local autoBurn = false
GuardTab:CreateToggle({ Name = "Auto Burn 🔥♨️", CurrentValue = false,
    Callback = function(Value)
        autoBurn = Value
        if autoBurn then
            task.spawn(function()
                while autoBurn do
                    task.wait(0.3)
                    if workspace.Data.IncinerationRoom:FindFirstChild("Burn") and workspace.Data.IncinerationRoom.Burn:FindFirstChild("Burn") then
                        fireproximityprompt(workspace.Data.IncinerationRoom.Burn.Burn)
                    end
                end
            end)
        end
    end
})



--===============VISIUAL TAB--======================




do -- << 'do' BLOCK (Safety) >>

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera

    -- 1. SPECTATE (Dropdown)
    local spectateList = {}
    
    local function UpdatePlayerList()
        spectateList = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(spectateList, p.Name)
            end
        end
    end
    UpdatePlayerList()

    local Dropdown = VisualTab:CreateDropdown({
        Name = "📹 CCTV Spectate (Select Player)",
        Options = spectateList,
        CurrentOption = "",
        Flag = "SpectateDropdown",
        Callback = function(Option)
            local targetName = Option[1]
            local target = Players:FindFirstChild(targetName)
            
            if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                Camera.CameraSubject = target.Character.Humanoid
                Rayfield:Notify({Title = "Watching", Content = "Now spectating: " .. targetName, Duration = 3})
            end
        end,
    })

    -- Refresh List Button
    VisualTab:CreateButton({
        Name = "🔄 Refresh Player List",
        Callback = function()
            UpdatePlayerList()
            Dropdown:Refresh(spectateList) -- Rayfield Dropdown Refresh
        end,
    })

    -- Reset Camera Button
    VisualTab:CreateButton({
        Name = "❌ Stop Spectating (Reset Camera)",
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                Camera.CameraSubject = LocalPlayer.Character.Humanoid
            end
        end,
    })

    -- 2. ESP (Wallhack) TOGGLE
    local espEnabled = false
    local espFolder = Instance.new("Folder", game.CoreGui)
    espFolder.Name = "SpyESP"

    local function CreateESP(plr)
        if plr == LocalPlayer then return end
        
        local function Update()
            if not espEnabled then return end
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") then
                
                -- Check/Create Highlight (Chamakne wala effect)
                local hl = plr.Character:FindFirstChild("SpyHighlight")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "SpyHighlight"
                    hl.FillColor = Color3.fromRGB(255, 0, 0) -- Red
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.5
                    hl.Parent = plr.Character
                end

                -- Check/Create NameTag (Naam aur Doori)
                local hrp = plr.Character.HumanoidRootPart
                local bg = espFolder:FindFirstChild(plr.Name .. "_ESP")
                if not bg then
                    bg = Instance.new("BillboardGui")
                    bg.Name = plr.Name .. "_ESP"
                    bg.AlwaysOnTop = true
                    bg.Size = UDim2.new(0, 200, 0, 50)
                    bg.Adornee = hrp
                    bg.Parent = espFolder
                    
                    local nameLabel = Instance.new("TextLabel", bg)
                    nameLabel.Size = UDim2.new(1, 0, 1, 0)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 0) -- Yellow Text
                    nameLabel.TextStrokeTransparency = 0
                    nameLabel.Font = Enum.Font.GothamBold
                    nameLabel.TextSize = 14
                    nameLabel.Name = "Label"
                end
                
                -- Update Distance Text
                local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                bg.Label.Text = "🕵️ " .. plr.Name .. "\n[" .. dist .. "m]"
            else
                -- Agar character mar gaya to ESP hatao
                if espFolder:FindFirstChild(plr.Name .. "_ESP") then
                    espFolder[plr.Name .. "_ESP"]:Destroy()
                end
            end
        end
        
        RunService.RenderStepped:Connect(Update)
    end

    VisualTab:CreateToggle({
        Name = "👁️ ESP (See Through Walls)",
        CurrentValue = false,
        Flag = "ESPMode",
        Callback = function(Value)
            espEnabled = Value
            if Value then
                for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
                Players.PlayerAdded:Connect(CreateESP)
            else
                espFolder:ClearAllChildren()
                for _, p in pairs(Players:GetPlayers()) do
                    if p.Character and p.Character:FindFirstChild("SpyHighlight") then
                        p.Character.SpyHighlight:Destroy()
                    end
                end
            end
        end,
    })

    -- =============================================
    -- TAB 2: STEALTH (Hide)
    -- =============================================

    local oldPos = nil
    VisualTab:CreateToggle({
        Name = "🕳️ Hide Under Map (Safe)",
        CurrentValue = false,
        Flag = "SpyHide",
        Callback = function(Value)
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if Value and hrp then
                -- [ HIDE ]
                oldPos = hrp.CFrame
                hrp.CFrame = CFrame.new(hrp.Position.X, -150, hrp.Position.Z)
                task.wait(0.2)
                hrp.Anchored = true -- Freeze kar do taaki giro nahi
                Rayfield:Notify({Title = "Hidden", Content = "You are now under the map.", Duration = 1})
            elseif not Value and hrp and oldPos then
                -- [ UNHIDE ]
                hrp.Anchored = false
                hrp.CFrame = oldPos
                Rayfield:Notify({Title = "Visible", Content = "Returned to surface.", Duration = 1})
            end
        end,
    })

end -- << 'do' BLOCK END >>


---=====================GOMEMODE---==========================


GamemodeTab:CreateSection("Sky Squid")

local GODMODE = false
local lastSafePos = nil

---------------------------------------------------------------------

-- Track last safe ground position
task.spawn(function()
    while true do
        if GODMODE then
            local p = game.Players.LocalPlayer
            local char = p.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")

            if root then
                -- Agar platform ya part par ho
                local ray = Ray.new(root.Position, Vector3.new(0, -6, 0))
                local hit = workspace:FindPartOnRay(ray, char)

                if hit and hit.CanCollide and not hit.Name:lower():find("kill") then
                    lastSafePos = root.Position
                end
            end
        end
        task.wait(0.2)
    end
end)

---------------------------------------------------------------------

function FullProtectionLoop()
    task.spawn(function()
        while true do
            if GODMODE then
                local player = game.Players.LocalPlayer
                local char = player.Character
                if char then

                    -- ❌ FALL DAMAGE REMOVE
                    pcall(function()
                        if char:FindFirstChild("FallDamage") then
                            char.FallDamage:Destroy()
                        end
                    end)

                    -- ❌ RAGDOLL DISABLE
                    pcall(function()
                        for _, v in pairs(char:GetDescendants()) do
                            if v:IsA("HingeConstraint") or v:IsA("BallSocketConstraint") then
                                v.Enabled = false
                            end
                        end
                    end)

                    -- ❌ KILL ZONES IGNORE
                    pcall(function()
                        for _, v in pairs(workspace:GetDescendants()) do
                            if v:IsA("TouchTransmitter") and v.Parent.Name:lower():find("kill") then
                                v.Parent.CanTouch = false
                            end
                        end
                    end)

                    -- ❌ PUSH FORCE REMOVE
                    pcall(function()
                        if char:FindFirstChild("HumanoidRootPart") then
                            char.HumanoidRootPart.CustomPhysicalProperties =
                                PhysicalProperties.new(0, 0, 0, 0, 0)
                        end
                    end)

                    -------------------------------------------------
                    -- 🟢 AUTO RETURN IF FALLING
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root and lastSafePos then
                        if root.Position.Y < lastSafePos.Y - 15 then
                            -- गिरते ही वापस safe spot पर
                            root.CFrame = CFrame.new(lastSafePos + Vector3.new(0, 2, 0))
                        end
                    end
                    -------------------------------------------------

                end
            end

            task.wait(0.15)
        end
    end)
end

FullProtectionLoop()

---------------------------------------------------------------------

GamemodeTab:CreateToggle({
    Name = "🛡️ Anti Fall",
    CurrentValue = false,
    Callback = function(v)
        GODMODE = v
    end,
})





----------------------------------------------------
-- OPTIMIZED GODMODE SCRIPT (Fixes Local Register Overflow)
----------------------------------------------------

-- Hum saare functions aur variables ko ek table me daal rahe hain
-- taaki 200 variables ki limit cross na ho.
local GodmodeLogic = {
    Connections = {},
    OriginalTouch = {},
    Player = game:GetService("Players").LocalPlayer,
    RunService = game:GetService("RunService")
}

-- Helper: Check if part is a weapon
function GodmodeLogic.IsWeapon(part)
    local char = GodmodeLogic.Player.Character
    if char and part:IsDescendantOf(char) and part.Parent:IsA("Tool") then
        return true
    end
    return false
end

-- ENABLE GODMODE
function GodmodeLogic.Enable()
    local player = GodmodeLogic.Player
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    
    -- 1. Infinite Health
    hum.MaxHealth = math.huge
    hum.Health = hum.MaxHealth
    GodmodeLogic.Connections["Health"] = hum.HealthChanged:Connect(function(h)
        if h < hum.MaxHealth then hum.Health = hum.MaxHealth end
    end)
    
    -- 2. Block Touch Damage (Workspace)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.CanTouch and not GodmodeLogic.IsWeapon(obj) then
            GodmodeLogic.OriginalTouch[obj] = obj.CanTouch
            obj.CanTouch = false
        end
    end
    
    GodmodeLogic.Connections["DescAdded"] = workspace.DescendantAdded:Connect(function(obj)
        task.wait()
        if obj:IsA("BasePart") and obj.CanTouch and not GodmodeLogic.IsWeapon(obj) then
            GodmodeLogic.OriginalTouch[obj] = true
            obj.CanTouch = false
        end
    end)
    
    -- 3. Destroy Remotes (Aggressive anti-kill)
    local function destroyRemotes(parent)
        for _, obj in ipairs(parent:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("BindableEvent") then
                obj:Destroy()
            end
        end
    end
    destroyRemotes(char)
    
    GodmodeLogic.Connections["CharNewEvents"] = char.DescendantAdded:Connect(function(obj)
        if obj:IsA("RemoteEvent") or obj:IsA("BindableEvent") then
            obj:Destroy()
        end
    end)
    
    -- 4. Anti Void
    GodmodeLogic.Connections["Void"] = GodmodeLogic.RunService.Heartbeat:Connect(function()
        local root = char:FindFirstChild("HumanoidRootPart")
        if root and root.Position.Y < -10 then
            root.CFrame = CFrame.new(0, 50, 0)
        end
    end)
    
    -- 5. Anti Fall Damage
    GodmodeLogic.Connections["Fall"] = hum.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Freefall then
            hum:ChangeState(Enum.HumanoidStateType.Physics)
        end
    end)
    
    print("GODMODE ENABLED")
end

-- DISABLE GODMODE
function GodmodeLogic.Disable()
    -- Restore Touch
    for part, original in pairs(GodmodeLogic.OriginalTouch) do
        if part and part:IsDescendantOf(workspace) then
            part.CanTouch = original
        end
    end
    GodmodeLogic.OriginalTouch = {}

    -- Disconnect Events
    for name, conn in pairs(GodmodeLogic.Connections) do
        if conn then 
            conn:Disconnect() 
            GodmodeLogic.Connections[name] = nil
        end
    end

    -- Reset Character State
    local char = GodmodeLogic.Player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        
        if root then
            root.Velocity = Vector3.zero
            root.RotVelocity = Vector3.zero
        end
        
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            -- Reset health to normal (optional, 100 is standard)
            hum.MaxHealth = 100
            hum.Health = 100
        end
    end
    
    print("GODMODE DISABLED")
end


----------------------------------------------------
-- RAYFIELD TOGGLE
----------------------------------------------------
-- Ensure GamemodeTab is defined in your main script
if GamemodeTab then
    GamemodeTab:CreateToggle({
        Name = "👑 Godmode ( not recommended to use)",
        CurrentValue = false,
        Callback = function(value)
            if value then
                GodmodeLogic.Enable()
            else
                GodmodeLogic.Disable()
            end
        end
    })
else
    warn("GamemodeTab not found! Godmode loaded but UI missing.")
end


-- GAMEMODE SECTION
GamemodeTab:CreateSection("Tug Of War")

--=====================================================
-- 1. AUTO GREEN ZONE EXPANDER (PASSIVE)
--=====================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local autoPull = false

-- Ye loop hamesha chalega taaki Green Zone hamesha 100% rahe
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local gui = LocalPlayer.PlayerGui:FindFirstChild("TugOfWarGui") or LocalPlayer.PlayerGui:FindFirstChild("GameGui")
            if gui then
                for _, v in pairs(gui:GetDescendants()) do
                    -- Green Bar ko dhoondh kar bada karna
                    if v:IsA("Frame") and (v.Name:match("Success") or v.Name:match("Bar") or v.BackgroundColor3 == Color3.fromRGB(0, 255, 0)) then
                        if v.Size.X.Scale < 0.9 then 
                            v.Size = UDim2.new(1, 0, 1, 0) -- Full Screen Green
                            v.BackgroundTransparency = 0.5
                            v.Visible = true
                        end
                    end
                end
            end
        end)
    end
end)

--=====================================================
-- 2. AUTO CLICKER & REMOTE SPAMMER
--=====================================================
local potentialRemotes = { "Pull", "Tug", "TugOfWar", "Click", "PullRope", "Action" }

local function getRemote()
    for _, name in pairs(potentialRemotes) do
        local remote = ReplicatedStorage:FindFirstChild(name, true)
        if remote and remote:IsA("RemoteEvent") then
            return remote
        end
    end
    return nil
end

local function getClickButton()
    local gui = LocalPlayer.PlayerGui:FindFirstChild("TugOfWarGui") or LocalPlayer.PlayerGui:FindFirstChild("GameGui")
    if gui then
        for _, v in pairs(gui:GetDescendants()) do
            if (v:IsA("TextButton") or v:IsA("ImageButton")) and v.Visible then
                -- Button dhoondhne ki koshish
                local text = (v:IsA("TextButton") and v.Text:lower()) or ""
                if text:match("pull") or text:match("click") or v.Name:lower():match("pull") then
                    return v
                end
            end
        end
    end
    return nil
end

--=====================================================
-- RAYFIELD UI
--=====================================================

GamemodeTab:CreateToggle({
   Name = "🔘 Auto Pull",
   CurrentValue = false,
   Flag = "AutoPull", 
   Callback = function(Value)
        autoPull = Value
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Pull ON",
                Content = "Thanks bol chutiye",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- MAIN LOOP: Ye sab kuch khud karega
            task.spawn(function()
                while autoPull do
                    -- 1. Method A: Server Signal (Direct Win)
                    local remote = getRemote()
                    if remote then
                        pcall(function()
                            remote:FireServer(1)
                            remote:FireServer("Perfect")
                        end)
                    end
                    
                    -- 2. Method B: Virtual Click (Button Press)
                    local btn = getClickButton()
                    if btn then
                        -- Button ke signals fire karna
                        for _, con in pairs(getconnections(btn.MouseButton1Click)) do
                            con:Fire()
                        end
                        for _, con in pairs(getconnections(btn.TouchTap)) do
                            con:Fire()
                        end
                    else
                        -- Agar button na mile, toh screen ke beech mein click karo
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new(9999, 9999)) -- Screen click simulation
                    end
                    
                    task.wait(0.05) -- Bahut tez speed
                end
            end)
        else
            Rayfield:Notify({
                Title = "Auto Pull OFF",
                Content = "Stopped pulling.",
                Duration = 2,
                Image = 4483362458,
            })
        end
   end,
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




