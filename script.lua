if not game:IsLoaded() then
    game.Loaded:Wait()
end
local custom =
    loadstring(
    game:HttpGet(
        "https://raw.githubusercontent.com/TheEmptynessProject/EmptynessProject/main/emptynessHub/customFunctions.lua"
    )
)()
local notificationLib =
    loadstring(
    game:HttpGet(
        "https://raw.githubusercontent.com/TheEmptynessProject/EmptynessProject/main/emptynessHub/notificationLib.lua"
    )
)()
local library =
    loadstring(
    game:HttpGet("https://raw.githubusercontent.com/TheEmptynessProject/EmptynessProject/main/emptynessHub/lib.lua")
)()
getgenv().mainLib =
    library:New(
    {
        Name = "Emptyness Hub",
        SizeX = 500,
        SizeY = 550,
        Log = false,
        LogURL = "https://discord.com/api/webhooks/1131678659384709301/Odi9JMgIU4skKIK9TYf_9JItefj1vl61cr3LQx_0Ad_UHJbEX_WgwsXeUEOvyjaZ6b_g" --nice try spamming, detected in 20 seconds
    }
)
getgenv().notifLib =
    notificationLib.new(
    {
        lifetime = 5,
        textColor = Color3.fromRGB(255, 255, 255),
        textSize = 50,
        textStrokeTransparency = 0.7,
        textStrokeColor = Color3.fromRGB(0, 0, 0),
        textFont = Enum.Font.Ubuntu
    }
)

notifLib:BuildUI()
local uniTab = mainLib:NewTab("Universal")
local randomThingsTab = mainLib:NewTab("Random")
local universalColumn1 =
    uniTab:NewSection(
    {
        Name = "",
        column = 1
    }
)
local universalColumn2 =
    uniTab:NewSection(
    {
        Name = "",
        column = 2
    }
)
local randomColumn1 =
    randomThingsTab:NewSection(
    {
        Name = "",
        column = 1
    }
)
local randomColumn2 =
    randomThingsTab:NewSection(
    {
        Name = "",
        column = 2
    }
)
universalColumn1:CreateKeybind(
    {
        Name = "Hide GUI",
        Default = library.toggleBind,
        Callback = function(key)
            task.wait()
            library.toggleBind = key
        end
    }
)
universalColumn1:CreateKeybind(
    {
        Name = "Close GUI",
        Default = library.closeBind,
        Callback = function(key)
            task.wait()
            library.closeBind = key
        end
    }
)
universalColumn1:CreateButton(
    {
        Name = "Get Place Info",
        Callback = function()
            setclipboard(tostring(game.PlaceId))
        end
    }
)
universalColumn1:CreateButton(
    {
        Name = "Get Self Position",
        Callback = function()
            setclipboard(tostring(game.Players.LocalPlayer.Character.HumanoidRootPart.Position))
        end
    }
)
universalColumn1:CreateLabel(
    {
        Name = "Teleport to Player"
    }
)
local dropdownPlayerArray = {}
for _, player in ipairs(game.Players:GetPlayers()) do
    table.insert(dropdownPlayerArray, player.DisplayName)
end
local tempDropPLAYERTP =
    universalColumn1:CreateDropdown(
    {
        Content = dropdownPlayerArray,
        MultiChoice = false,
        Callback = function(selectedPlayer)
            local targetPlayer = nil
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.DisplayName == selectedPlayer then
                    targetPlayer = player
                    break
                end
            end

            if targetPlayer then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                    targetPlayer.Character.HumanoidRootPart.CFrame
            else
                notifLib:Notify("Error", {Color = Color3.new(1, 0, 0)})
            end
        end
    }
)

universalColumn1:CreateToggle(
    {
        Name = "Disable Invisible Parts",
        Callback = function(bool)
            for i, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Transparency == 1 and v.CanCollide then
                    if bool then
                        v.CanCollide = false
                    else
                        v.CanCollide = true
                    end
                end
            end
        end
    }
)
universalColumn1:CreateLine(
    {
        Size = 2,
        Color = Color3.new(255, 0, 255)
    }
)
universalColumn2:CreateToggle_and_Keybind(
    {
        Name = "Hex Spitter Kill All",
        Default = Enum.KeyCode.G,
        Callback = function(bool, key)
            if not bool then
                return
            end
            for _, player in ipairs(game.Players:GetPlayers()) do
                if
                    player.Character and player.Character:FindFirstChild("Humanoid") and
                        player.Character.Humanoid.Health > 0 and
                        not player.Character:FindFirstChildOfClass("ForceField")
                 then
                    notifLib:Notify(
                        "Player " .. player.Name .. " now has " .. player.Character.Humanoid.Health,
                        {Color = Color3.new(255, 255, 255)}
                    )
                    local c = {
                        [1] = "RayHit",
                        [2] = {
                            ["Position"] = Vector3.new(0, 0, 0),
                            ["Hit"] = player.Character.HumanoidRootPart
                        }
                    }
                    game:GetService("Players").LocalPlayer.Character.HexSpitter.Remotes.ServerControl:InvokeServer(
                        unpack(c)
                    )
                    task.wait()
                end
            end
        end
    }
)
repeat
    task.wait()
until game.Players.LocalPlayer.Character
local coroutineWS
universalColumn2:CreateSlider(
    {
        Name = "WalkSpeed",
        Min = 10,
        Max = 200,
        Default = math.floor(game.Players.LocalPlayer.Character.Humanoid.WalkSpeed) or 10,
        Decimals = 1,
        Callback = function(value)
            if coroutineWS then
                coroutine.close(coroutineWS)
                coroutineWS = nil
            end
            coroutineWS =
                coroutine.create(
                function()
                    while task.wait() do
                        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
                    end
                end
            )
            coroutine.resume(coroutineWS)
        end
    }
)
universalColumn2:CreateSlider(
    {
        Name = "JumpPower",
        Min = 10,
        Max = 200,
        Default = math.floor(game.Players.LocalPlayer.Character.Humanoid.JumpPower) or 10,
        Decimals = 1,
        Callback = function(value)
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        end
    }
)
universalColumn2:CreateSlider(
    {
        Name = "Camera Zoom Distance",
        Min = 0,
        Max = 20000,
        Default = math.floor(game.Players.LocalPlayer.CameraMaxZoomDistance) or 0,
        Decimals = 0.001,
        Callback = function(value)
            game.Players.LocalPlayer.CameraMaxZoomDistance = value
        end
    }
)
universalColumn2:CreateSlider(
    {
        Name = "Gravity",
        Min = 0,
        Max = 1000,
        Default = math.floor(game.workspace.Gravity) or 196,
        Decimals = 0.1,
        Callback = function(value)
            game.workspace.Gravity = value
        end
    }
)
universalColumn2:CreateToggle_and_Keybind(
    {
        Default = Enum.KeyCode.Space,
        Name = "Infinite Jump",
        Click = false,
        Callback = function(bool, keyed)
            if bool then
                game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end
    }
)
local thing, connectV2_infJump
universalColumn2:CreateToggle_and_Keybind(
    {
        Default = Enum.KeyCode.Space,
        Name = "Infinite Jump V2",
        Click = false,
        Callback = function(bool, keyed)
            if bool then
                if not thing then
                    thing = Instance.new("Part")
                    thing.Anchored = true
                    thing.Parent = game.Workspace
                    thing.Size = Vector3.new(5, 0.1, 5)
                    thing.Transparency = 1
                end

                if not connectV2_infJump then
                    connectV2_infJump =
                        game:GetService("RunService").RenderStepped:Connect(
                        function()
                            local pos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                            thing.CFrame = CFrame.new(pos.X, pos.Y - 3.3, pos.Z)
                        end
                    )
                end
            else
                if thing then
                    thing:Destroy()
                    thing = nil
                end
                if connectV2_infJump then
                    connectV2_infJump:Disconnect()
                    connectV2_infJump = nil
                end
            end
        end
    }
)

local connection_noclip
universalColumn2:CreateToggle_and_Keybind(
    {
        Default = Enum.KeyCode.N,
        Name = "Noclip",
        Click = true,
        Callback = function(bool, toggled, keyed)
            local player = game.Players.LocalPlayer
            local function setNoclipEnabled(enabled)
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = not enabled
                    end
                end
            end
            local on = bool and toggled
            if on then
                if not connection_noclip then
                    connection_noclip =
                        game:GetService("RunService").Stepped:Connect(
                        function()
                            setNoclipEnabled(true)
                        end
                    )
                end
            else
                if connection_noclip then
                    connection_noclip:Disconnect()
                    connection_noclip = nil
                end
                setNoclipEnabled(false)
            end
        end
    }
)

local connectionFly, bodyVelocity
universalColumn2:CreateToggle_and_Keybind(
    {
        Default = Enum.KeyCode.G,
        Name = "Fly",
        Click = true,
        Info = "Also works as Vehicle Fly",
        Mode = 2,
        Callback = function(bool, toggled, keyed)
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
            local rootPart = character:WaitForChild("HumanoidRootPart")

            local flying = toggled and bool
            local flySpeed = 0
            local flyMaxSpeed = 500
            local mouse = player:GetMouse()

            local function updateFlySpeed()
                if flySpeed < flyMaxSpeed then
                    flySpeed = flySpeed + 1
                end
            end

            local function getMovementDirection()
                local camera = game.Workspace.CurrentCamera
                local lookVector = camera.CFrame.LookVector
                local rightVector = camera.CFrame.RightVector
                local flyDirection = Vector3.new(0, 0, 0)

                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                    flyDirection = flyDirection + lookVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                    flyDirection = flyDirection - lookVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                    flyDirection = flyDirection - rightVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                    flyDirection = flyDirection + rightVector
                end

                return flyDirection
            end
            if flying then
                connectionFly =
                    game:GetService("RunService").RenderStepped:Connect(
                    function()
                        if not flying then
                            return
                        end
                        if not bodyVelocity then
                            bodyVelocity = Instance.new("BodyVelocity", rootPart)
                            bodyVelocity.MaxForce = Vector3.new(2e10, 2e10, 2e10)
                            updateFlySpeed()
                        else
                            game:GetService("TweenService"):Create(
                                bodyVelocity,
                                TweenInfo.new(0.5),
                                {Velocity = getMovementDirection() * flySpeed}
                            ):Play()
                            updateFlySpeed()
                        end
                    end
                )
            else
                flySpeed = 0
                if bodyVelocity then
                    game:GetService("TweenService"):Create(
                        bodyVelocity,
                        TweenInfo.new(0.5),
                        {Velocity = Vector3.new(0, 0, 0)}
                    ):Play()
                    bodyVelocity:Destroy()
                    bodyVelocity = nil
                end
                if connectionFly then
                    connectionFly:Disconnect()
                    connectionFly = nil
                end
            end
        end
    }
)
local WSdetectConnect
local lastDetectionTimestamps = {}
universalColumn1:CreateToggle(
    {
        Name = "WalkSpeed Detection",
        Callback = function(bool)
            if bool then
                WSdetectConnect =
                    game:GetService("RunService").RenderStepped:Connect(
                    function()
                        local localPlayer = game.Players.LocalPlayer
                        local localWalkSpeed =
                            localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") and
                            localPlayer.Character.Humanoid.WalkSpeed

                        if not localWalkSpeed then
                            return
                        end

                        for _, player in pairs(game.Players:GetPlayers()) do
                            pcall(
                                function()
                                    local humanoidRootPart =
                                        player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                                    if humanoidRootPart then
                                        local temp =
                                            Vector2.new(humanoidRootPart.Velocity.X, humanoidRootPart.Velocity.Z)
                                        local velo = math.floor(temp.Magnitude)
                                        if velo > localWalkSpeed + 5 then
                                            local now = tick()
                                            local lastDetectionTime = lastDetectionTimestamps[player]
                                            if not lastDetectionTime or (now - lastDetectionTime) >= 30 then
                                                lastDetectionTimestamps[player] = now
                                                notifLib:Notify(
                                                    "Player " ..
                                                        player.Name ..
                                                            " (" ..
                                                                player.DisplayName .. ")" .. " was detected: " .. velo,
                                                    {Color = Color3.new(255, 0, 0)}
                                                )
                                            end
                                        end
                                    end
                                end
                            )
                        end
                    end
                )
            else
                if WSdetectConnect then
                    WSdetectConnect:Disconnect()
                end
            end
        end
    }
)
--[[
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.Velocity = Vector3.new(math.huge, math.huge, math.huge)
bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
local allToggled = 0

randomColumn1:CreateToggle(
    {
        Name = "Block X POS",
        Callback = function(bool)
            if bool then
                allToggled = allToggled + 1
                bodyVelocity.MaxForce = bodyVelocity.MaxForce + Vector3.new(math.huge, 0, 0)
                bodyVelocity.Velocity = bodyVelocity.Velocity - Vector3.new(math.huge, 0, 0)
            else
                allToggled = allToggled - 1
                bodyVelocity.MaxForce = bodyVelocity.MaxForce - Vector3.new(math.huge, 0, 0)
                bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(math.huge, 0, 0)
            end

            if allToggled == 0 then
                bodyVelocity.Parent = nil
                return
            else
                bodyVelocity.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
            end
        end
    }
)

randomColumn1:CreateToggle(
    {
        Name = "Block Y POS",
        Callback = function(bool)
            if bool then
                allToggled = allToggled + 1
                bodyVelocity.MaxForce = bodyVelocity.MaxForce + Vector3.new(0, math.huge, 0)
                bodyVelocity.Velocity = bodyVelocity.Velocity - Vector3.new(0, math.huge, 0)
            else
                allToggled = allToggled - 1
                bodyVelocity.MaxForce = bodyVelocity.MaxForce - Vector3.new(0, math.huge, 0)
                bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, math.huge, 0)
            end

            if allToggled == 0 then
                bodyVelocity.Parent = nil
                return
            else
                bodyVelocity.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
            end
        end
    }
)

randomColumn1:CreateToggle(
    {
        Name = "Block Z POS",
        Callback = function(bool)
            if bool then
                allToggled = allToggled + 1
                bodyVelocity.MaxForce = bodyVelocity.MaxForce + Vector3.new(0, 0, math.huge)
                bodyVelocity.Velocity = bodyVelocity.Velocity - Vector3.new(0, 0, math.huge)
            else
                allToggled = allToggled - 1
                bodyVelocity.MaxForce = bodyVelocity.MaxForce - Vector3.new(0, 0, math.huge)
                bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, 0, math.huge)
            end

            if allToggled == 0 then
                bodyVelocity.Parent = nil
                return
            else
                bodyVelocity.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
            end
        end
    }
)
local function overdose()
    notifLib:Notify("You overdosed!", {Color = Color3.new(255, 0, 0)})
    task.wait()
    game.Players.LocalPlayer.Character:BreakJoints()
end
local PostEffect = Instance.new("BloomEffect")
PostEffect.Intensity = 200
PostEffect.Size = 2 ^ 10
PostEffect.Threshold = 1
randomColumn2:CreateButton(
    {
        Name = "Take LSD",
        Callback = function()
            local TweenService = game:GetService("TweenService")
            local affected = {}
            local materials = {}
            local colors = {}
            local coroutines = {}
            local centerPosition = game.Workspace.CurrentCamera.CFrame.Position
            
			local TweenInfo1 = TweenInfo.new(5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			local TweenInfo2 = TweenInfo.new(30, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			local TweenInfo3 = TweenInfo.new(15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

			local Tween1 = TweenService:Create(PostEffect, TweenInfo2, {Size = 2^5, Intensity = 200}):Play()
            for i, v in pairs(game.Workspace:GetDescendants()) do
			local success, error = pcall(function()
                if (v.Position - centerPosition).Magnitude <= 500 then
                            v.Material = Enum.Material.Neon

                            local co =
                                coroutine.create(
                                function()
                                    while true do
                                        for i = 0, 1, 1 / 50 do
                                            v.Color = Color3.fromHSV(i, 1, 1)
                                            task.wait()
                                        end
                                    end
                                end
                            )

                            table.insert(coroutines, co)
                end
				end)
				if sucess then
                        table.insert(affected, v)
                        table.insert(materials, v.Material)
                        table.insert(colors, v.Color)
                    end
            end

            for _, co in ipairs(coroutines) do
                coroutine.resume(co)
            end

            task.delay(
                5,
                function()
                    for _, co in ipairs(coroutines) do
                        coroutine.close(co)
                        task.wait()
                    end
                    if math.random() <= 0.075 then
                        overdose()
                    end
                    for i, v in ipairs(affected) do
                        local colorTween = TweenService:Create(v, TweenInfo, {Color = colors[i]})
                        colorTween:Play()
                        colorTween.Completed:Connect(
                            function()
                                v.Material = materials[i]
                            end
                        )
                    end
					local Tween2 = TweenService:Create(PostEffect, TweenInfo3, {Size = 0, Intensity = 0}):Play()
                end
            )
        end
    }
)
randomColumn2:CreateButton( --Motion Blur and heavy camera
    {
        Name = "Take Cocaine",
        Callback = function()
        end
    }
)]] local connection_BHOP
universalColumn2:CreateToggle_and_Keybind(
    {
        Default = Enum.KeyCode.F,
        Name = "BHOP",
        Click = true,
        Callback = function(temp, thing, keyed)
            local bool = temp and thing
            if bool then
                connection_BHOP =
                    game:GetService("RunService").Stepped:connect(
                    function()
                        if not bool then
                            return
                        end
                        if game.Players.LocalPlayer.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
                            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                        end
                    end
                )
            else
                if connection_BHOP then
                    connection_BHOP:Disconnect()
                    connection_BHOP = nil
                end
            end
        end
    }
)
universalColumn1:CreateButton(
    {
        Name = "TP Lowest Player Server",
        Callback = function()
            local HttpService = game:GetService("HttpService")
            local request = syn and syn.request or http and http.request or http_request or request or httprequest

            local response =
                HttpService:JSONDecode(
                request(
                    {
                        Url = "https://games.roblox.com/v1/games/" ..
                            game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=25",
                        Method = "GET"
                    }
                ).Body
            )

            local firstServer = response.data[1]
            if firstServer then
                game:GetService("TeleportService"):TeleportToPlaceInstance(
                    game.PlaceId,
                    firstServer.id,
                    game.Players.LocalPlayer
                )
            end
        end
    }
)

universalColumn1:CreateButton(
    {
        Name = "TP Highest Player Server",
        Callback = function()
            local HttpService = game:GetService("HttpService")
            local request = syn and syn.request or http and http.request or http_request or request or httprequest

            local response =
                HttpService:JSONDecode(
                request(
                    {
                        Url = "https://games.roblox.com/v1/games/" ..
                            game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=25&excludeFullGames=true",
                        Method = "GET"
                    }
                ).Body
            )

            local firstServer = response.data[1]
            if firstServer then
                game:GetService("TeleportService"):TeleportToPlaceInstance(
                    game.PlaceId,
                    firstServer.id,
                    game.Players.LocalPlayer
                )
            end
        end
    }
)
universalColumn1:CreateButton(
    {
        Name = "Rejoin",
        Callback = function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end
    }
)
local idleConnection 
universalColumn1:CreateButton(
    {
        Name = "Anti AFK",
		Info = "Untested",
        Callback = function()
            local Players = game:GetService("Players")
local idleFunc = Players.LocalPlayer.Idled
if getconnections then
    local idledConnections = getconnections(idleFunc)
    for _, connection in pairs(idledConnections) do
	if connection ~= idleConnection then
        if connection.Disable then
			connection:Disable()
		elseif connection.Disconnect then
			connection:Disconnect()
		end
		else
		print("Connection Safe")
		end
    end
	if not idleConnection then
	idleConnection = idleFunc:Connect(function()
		local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
	end)
	end
else
	warn("Your exploit does not support getconnections function")
end
        end
    }
)
--
--[[local connections = {}
universalColumn1:CreateToggle(
    {
        Name = "Destruction Bypass",
        Info = "Prototype",
        Mode = 1,
        Callback = function(bool)
            local function onInstanceDestroying(instance)
                print(instance.Name .. " tried to be destroyed")
                coroutine.yield()
                print("Not supposed")
            end

            if bool then
                for _, instance in pairs(game:GetDescendants()) do
                    if typeof(instance) == "Instance" then
                        connections[instance] =
                            instance.Destroying:Connect(
                            function()
                                onInstanceDestroying(instance)
                            end
                        )
                    end
                end
            else
                for instance, connection in pairs(connections) do
                    connection:Disconnect()
                end
            end
        end
    }
)]] randomColumn1:CreateButton(
    {
        Name = "Snake Game",
        Info = "Reset Character to remove game",
        Callback = function()
            local ScreenGui =
                custom.createObject(
                ("ScreenGui"),
                {
                    Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
                    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                }
            )

            local border =
                custom.createObject(
                ("Frame"),
                {
                    Name = "border",
                    Parent = ScreenGui,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.0, 0, 0.0, 0),
                    Size = UDim2.new(0, 720, 0, 570)
                }
            )

            local playground =
                custom.createObject(
                ("Frame"),
                {
                    Name = "playground",
                    Parent = border,
                    BackgroundColor3 = Color3.fromRGB(70, 210, 70),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.0, 10, 0.0, 10),
                    Size = UDim2.new(0, 700, 0, 550)
                }
            )

            local cellSize = 25
            local rows = math.floor(playground.Size.Y.Offset / cellSize)
            local columns = math.floor(playground.Size.X.Offset / cellSize)

            for row = 1, rows do
                for col = 1, columns do
                    local cell = Instance.new("Frame")
                    cell.Name = "Cell"
                    cell.Parent = playground
                    cell.BackgroundColor3 = Color3.fromRGB(70, 210, 70)
                    cell.BackgroundTransparency = 0.2
                    cell.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    cell.BorderSizePixel = 1
                    cell.Size = UDim2.new(0, cellSize, 0, cellSize)
                    cell.Position = UDim2.new(0, (col - 1) * cellSize, 0, (row - 1) * cellSize)
                    cell.ZIndex = 1
                end
            end

            local fruitDemo =
                custom.createObject(
                ("ImageLabel"),
                {
                    Name = "fruitDemo",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1.000,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, cellSize, 0, cellSize),
                    Parent = playground,
                    Image = "http://www.roblox.com/asset/?id=13575694232"
                }
            )

            local snakeHead =
                custom.createObject(
                ("ImageLabel"),
                {
                    Name = "head",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1.000,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, cellSize, 0, cellSize),
                    Parent = playground,
                    Image = "http://www.roblox.com/asset/?id=6811016328",
                    ImageTransparency = 1
                }
            )

            local function createSnakeBodySegment(position)
                local snakeBodyDemo =
                    custom.createObject(
                    ("ImageLabel"),
                    {
                        Name = "body",
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1.000,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Size = UDim2.new(0, cellSize, 0, cellSize),
                        Parent = playground,
                        Image = "http://www.roblox.com/asset/?id=6811016328",
                        Position = position
                    }
                )

                return snakeBodyDemo
            end

            local snake = {snakeHead}
            local direction = Vector2.new(0, 0)
            local timed = 0.5
            local prevPositions = {}
            local loopAround = false
            local died = false

            local function updateSnakeBody()
                for i = #snake, 1, -1 do
                    prevPositions[i] = snake[i].Position
                end

                for i = #snake, 2, -1 do
                    snake[i].Position = prevPositions[i - 1]
                end
            end

            local function isPositionOccupied(position)
                for _, bodySegment in ipairs(snake) do
                    if bodySegment.Position == position then
                        return true
                    end
                end
                return false
            end

            local function updateFruit()
                local fruitX, fruitY
                repeat
                    fruitX = math.random(1, columns)
                    fruitY = math.random(1, rows)
                    fruitDemo.Position = UDim2.new(0, (fruitX - 1) * cellSize, 0, (fruitY - 1) * cellSize)
                until not isPositionOccupied(fruitDemo.Position)

                return fruitDemo.Position
            end
            updateFruit()
            local function checkForCollisions()
                local headPosition = snakeHead.Position
                for i = 3, #snake do
                    if snake[i].Position == headPosition then
                        died = true
                        break
                    end
                end
            end
            local function updateSnake()
                local X = math.random(1, columns)
                local Y = math.random(1, rows)

                snakeHead.Position = UDim2.new(0, (X - 1) * cellSize, 0, (Y - 1) * cellSize)
            end
            local temp =
                createSnakeBodySegment(
                UDim2.new(0, snakeHead.Position.X.Offset * cellSize, 0, snakeHead.Position.Y.Offset * cellSize)
            )
            table.insert(snake, temp)
            updateSnake()
            updateSnakeBody()
            local function resetGame()
                for i = #snake, 2, -1 do
                    snake[i]:Destroy()
                    wait(timed * 1.25) -- Wait for a short time before removing the next segment
                end
                updateFruit()
                snake = {snakeHead}
                temp =
                    createSnakeBodySegment(
                    UDim2.new(0, snakeHead.Position.X.Offset * cellSize, 0, snakeHead.Position.Y.Offset * cellSize)
                )
                table.insert(snake, temp)
                updateSnake()
                updateSnakeBody()
                prevPositions = {}
                direction = Vector2.new(0, 0)
                timed = 0.5
                died = false
            end

            local function onKeyDown(input)
                if input.KeyCode == Enum.KeyCode.W then
                    if direction ~= Vector2.new(0, 1) then
                        direction = Vector2.new(0, -1)
                    end
                elseif input.KeyCode == Enum.KeyCode.A then
                    if direction ~= Vector2.new(1, 0) then
                        direction = Vector2.new(-1, 0)
                    end
                elseif input.KeyCode == Enum.KeyCode.S then
                    if direction ~= Vector2.new(0, -1) then
                        direction = Vector2.new(0, 1)
                    end
                elseif input.KeyCode == Enum.KeyCode.D then
                    if direction ~= Vector2.new(-1, 0) then
                        direction = Vector2.new(1, 0)
                    end
                end
            end

            game:GetService("UserInputService").InputBegan:Connect(onKeyDown)

            local function gameLoop()
                while true do
                    wait(timed)
                    local headX = (snakeHead.Position.X.Offset / cellSize) + direction.X
                    local headY = (snakeHead.Position.Y.Offset / cellSize) + direction.Y
                    if loopAround then
                        if headX > columns - 1 then
                            headX = 0
                        elseif headX < 0 then
                            headX = columns - 1
                        end
                        if headY > rows - 1 then
                            headY = 0
                        elseif headY < 0 then
                            headY = rows - 1
                        end
                    else
                        if headX > columns - 1 or headX < 0 or headY > rows - 1 or headY < 0 then
                            died = true
                        end
                    end

                    if snakeHead.Position == fruitDemo.Position then
                        local newBodySegment =
                            createSnakeBodySegment(UDim2.new(0, headX * cellSize, 0, headY * cellSize))
                        table.insert(snake, newBodySegment)
                        timed = timed - 0.02
                        updateFruit()
                    end
                    checkForCollisions()
                    if not died then
                        snakeHead.Position = UDim2.new(0, headX * cellSize, 0, headY * cellSize)
                        updateSnakeBody()
                    else
                        resetGame()
                    end
                end
            end

            gameLoop()
        end
    }
)
local gameScriptUrl =
    string.format(
    "https://github.com/TheEmptynessProject/EmptynessProject/raw/main/emptynessHub/games/%d.lua",
    game.PlaceId
)

pcall(
    function()
        loadstring(game:HttpGet(gameScriptUrl))()
    end
)
