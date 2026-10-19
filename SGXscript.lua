local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local MAIN_API_URL = "https://swamm-backend-verify.onrender.com"
local FINAL_SCRIPT_URL = "https://gist.githubusercontent.com/swamm-89/f5c09eec6f05dd2b342ece2b7dfc2849/raw/9aa91504a41fdf63c5cf1ed97cb2a8f88f9a45a3/myscript-source-green.lua"  

-- Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SWAMM CONTROL PANEL",
    LoadingTitle = "SWAMM",
    LoadingSubtitle = "Verification System",
    ConfigurationSaving = { Enabled = true, FolderName = "SWAMM", FileName = "Config" }
})

local MainTab = Window:CreateTab("Main", 4483362458)

-- Verification Section (same rakha)
MainTab:CreateSection("Verification Status")

MainTab:CreateLabel("🚫 Do not attempt to kill M3GUN..She is the manager of the hack, and doing so may result in a ban.. 💞 Our hack will always remain free for our valued users ")

local StatusLabel = MainTab:CreateLabel("Status: Send Verify Request")
local StatusDot   = MainTab:CreateLabel("🔴 Not Requested")


-- Check Verification Status Button (route fixed + better handling)
MainTab:CreateButton({
    Name = "🔍 Check Verification Status",
    Callback = function()
        Rayfield:Notify({
            Title = "Checking...",
            Content = "Please wait",
            Duration = 3
        })

        local playerId = tostring(player.UserId)
        local url = MAIN_API_URL .. "/check-verification/" .. playerId

        local success, res = pcall(function()
            return game:HttpGet(url, true)
        end)

        if not success then
            Rayfield:Notify({
                Title = "Connection Failed",
                Content = "Try After 5 min baby 😜 ",
                Duration = 6
            })
            return
        end

        local data
        local decodeSuccess = pcall(function()
            data = HttpService:JSONDecode(res)
        end)

        if not decodeSuccess then
            Rayfield:Notify({
                Title = "Error",
                Content = "Invalid server response 😜",
                Duration = 6
            })
            return
        end

        local verified = data.verified or "pending"

        if verified == "approved" then
            StatusLabel:Set("Status: Approved")
            StatusDot:Set("🟢 Approved")

            Rayfield:Notify({
                Title = " Aprroved ✅ ",
                Content = "Loading Full Script...",
                Duration = 5
            })

            -- Final script load
            local loadSuccess, loadErr = pcall(function()
                local finalCode = game:HttpGet(FINAL_SCRIPT_URL, true)
                loadstring(finalCode)()
            end)

            if not loadSuccess then
                Rayfield:Notify({
                    Title = "Script Load Failed",
                    Content = "Wait. Admin will fix 💢 " .. tostring(loadErr),
                    Duration = 10
                })
            end

        elseif verified == "rejected" then
            StatusLabel:Set("Status: Rejected")
            StatusDot:Set("🔴 Rejected")
            Rayfield:Notify({
                Title = "Request Rejected ❌ ",
                Content = " Contract Admin  ",
                Duration = 10
            })

        else  -- pending or no user
            StatusLabel:Set("Status: Waiting for Approval")
            StatusDot:Set("🟡 Pending")
            Rayfield:Notify({
                Title = "Pending Approval 💤",
                Content = "Wait for Decision or Contract Admin ",
                Duration = 6
            })
        end
    end,
})


-- Request Verification Button 
MainTab:CreateButton({
    Name = "🔐 Request Verification",
    Callback = function()
        Rayfield:Notify({
            Title = "Checking Status...",
            Content = "Please wait",
            Duration = 3
        })

        local playerId = tostring(player.UserId)
        local checkUrl = MAIN_API_URL .. "/check-verification/" .. playerId

        -- Pehle current status check karo
        local checkSuccess, checkRes = pcall(function()
            return game:HttpGet(checkUrl, true)
        end)

        if not checkSuccess then
            Rayfield:Notify({
                Title = "Connection Failed ",
                Content = "Server se connect nahi ho pa raha",
                Duration = 6
            })
            return
        end

        local data
        local decodeOk = pcall(function()
            data = HttpService:JSONDecode(checkRes)
        end)

        if not decodeOk or not data then
            Rayfield:Notify({
                Title = "Error",
                Content = "Invalid response from server",
                Duration = 5
            })
            return
        end

        local currentStatus = data.verified or "pending"

        -- Agar already approved ya rejected hai to request mat bhejo
        if currentStatus == "approved" then
            StatusLabel:Set("Status: Approved")
            StatusDot:Set("🟢 Approved")
            Rayfield:Notify({
                Title = "Already Approved 🙂",
                Content = "BKL approved hai tu ab Check Verification par click kar ",
                Duration = 6
            })
            return

        elseif currentStatus == "rejected" then
            StatusLabel:Set("Status: Rejected")
            StatusDot:Set("🔴 Rejected")
            Rayfield:Notify({
                Title = "Already Rejected 🤣",
                Content = "Admin ne reject kar diya ",
                Duration = 8
            })
            return
        end

        -- Agar yahan tak pahunch gaye → status pending hai (ya naya user) → request bhejo
        Rayfield:Notify({
            Title = "Sending Request...",
            Content = "Please wait",
            Duration = 3
        })

        local username = player.Name
        local display = player.DisplayName

        local requestUrl = MAIN_API_URL .. "/request-verification/" .. playerId
            .. "?username=" .. HttpService:UrlEncode(username)
            .. "&display=" .. HttpService:UrlEncode(display)

        local reqSuccess, reqRes = pcall(function()
            return game:HttpGet(requestUrl, true)
        end)

        if not reqSuccess then
            Rayfield:Notify({
                Title = "Connection Failed ⁉️ ",
                Content = "Server se connect nahi ho pa raha",
                Duration = 6
            })
            return
        end

        local response
        local reqDecodeOk = pcall(function()
            response = HttpService:JSONDecode(reqRes)
        end)

        if not reqDecodeOk then
            Rayfield:Notify({
                Title = "Server Error ⁉️",
                Content = "Invalid response from server",
                Duration = 5
            })
            return
        end

        if response.status == "request_sent" then
            StatusLabel:Set("Status: Waiting for Approval")
            StatusDot:Set("🟡 Pending")
            Rayfield:Notify({
                Title = "Success ❇️ ",
                Content = "Request sent to admin\nWaiting for approval...",
                Duration = 5
            })

        elseif response.status == "limit_exceeded" then
            Rayfield:Notify({
                Title = "Limit Reached 🙂🔪",
                Content = "BKL 10 barr request bhej chuka hai tu.",
                Duration = 8
            })

        else
            Rayfield:Notify({
                Title = "Unknown Response",
                Content = response.message or "Something went wrong",
                Duration = 6
            })
        end
    end,
})



MainTab:CreateParagraph({
    Title = "Admin ID 💖",
    Content = "Platform: Telegram"
})

MainTab:CreateButton({
    Name = "Copy @zigs_009",
    Callback = function()
        setclipboard("@zigs_009")
    end,
})
