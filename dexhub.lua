local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create the Rayfield window
local Window = Rayfield:CreateWindow({
    Name = "Steal a Brainrot GUI",
    LoadingTitle = "Steal a Brainrot",
    LoadingSubtitle = "Script Injected",
    Theme = "Default",
    ToggleUIKeybind = "K",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "BrainrotConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "Steal a Brainrot GUI Key System",
        Subtitle = "Key Required to Use GUI",
        Note = "Join discord.gg/yourserver to get the key", -- Change this to your actual Discord
        FileName = "BrainrotKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"DEXHUB", "dexhubbackup"} -- Replace with your actual key(s)
    }
})

-- Notify
Rayfield:Notify({
    Title = "STEAL A BRAINROT SCRIPT",
    Content = "INJECTED SUCCESSFULLY",
    Duration = 6.5,
    Image = 4483362458,
})

-- Tabs
local mainTab = Window:CreateTab("MainTab", 4483362458)
local espTab = Window:CreateTab("ESP", 4483362458)
local miscTab = Window:CreateTab("MISC", 4483362458)

mainTab:CreateSection("Main Features")

mainTab:CreateButton({
    Name = "Speed Boost (External Script)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/robloxcomphub/comphubTPtest/refs/heads/main/speed.lua"))()
    end
})

mainTab:CreateButton({
    Name = "Jump Boost (40 Studs Up)",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 40, 0)
        end
    end
})

-- ESP Setup
local espEnabled = false
local espObjects = {}

local function highlightCharacter(player)
    if player == game.Players.LocalPlayer then return end
    if not player.Character then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "FullBodyESP"
    highlight.FillColor = Color3.fromRGB(0, 0, 255)
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = player.Character
    highlight.Parent = player.Character

    if player.Character:FindFirstChild("Head") then
        local headDot = Instance.new("Part")
        headDot.Name = "HeadDot"
        headDot.Shape = Enum.PartType.Ball
        headDot.Material = Enum.Material.Neon
        headDot.Size = Vector3.new(0.3, 0.3, 0.3)
        headDot.Color = Color3.fromRGB(255, 0, 0)
        headDot.Anchored = false
        headDot.CanCollide = false
        headDot.CFrame = player.Character.Head.CFrame * CFrame.new(0, 0.5, 0)
        headDot.Parent = player.Character

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = headDot
        weld.Part1 = player.Character.Head
        weld.Parent = headDot
    end

    espObjects[player] = true
end

local function removeESP(player)
    if player.Character then
        local highlight = player.Character:FindFirstChild("FullBodyESP")
        if highlight then highlight:Destroy() end
        local headDot = player.Character:FindFirstChild("HeadDot")
        if headDot then headDot:Destroy() end
    end
    espObjects[player] = nil
end

espTab:CreateToggle({
    Name = "ESP (Body Highlight + Red Head Dot)",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        espEnabled = Value
        for _, player in ipairs(game.Players:GetPlayers()) do
            if Value then
                highlightCharacter(player)
                player.CharacterAdded:Connect(function()
                    task.wait(1)
                    if espEnabled then highlightCharacter(player) end
                end)
            else
                removeESP(player)
            end
        end

        game.Players.PlayerAdded:Connect(function(player)
            if espEnabled then
                player.CharacterAdded:Connect(function()
                    task.wait(1)
                    if espEnabled then highlightCharacter(player) end
                end)
            end
        end)
    end
})

miscTab:CreateSection("Server Controls")

miscTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")

        local PlaceId = game.PlaceId
        local JobId = game.JobId

        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(
                "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
            ))
        end)

        if success and response and response.data then
            for _, server in ipairs(response.data) do
                if server.id ~= JobId and server.playing < server.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(PlaceId, server.id, Players.LocalPlayer)
                    return
                end
            end
            Rayfield:Notify({
                Title = "Server Hop",
                Content = "No empty servers found. Try again later.",
                Duration = 5
            })
        else
            Rayfield:Notify({
                Title = "Server Hop Failed",
                Content = "Could not fetch server list.",
                Duration = 5
            })
        end
    end
})

miscTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
    end
})
