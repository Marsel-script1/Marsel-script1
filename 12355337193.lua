local default = getgenv().mainLib:NewTab("Game Tab 1")
local PlaceId =
    default:NewSection(
    {
        Name = "",
        column = 1
    }
)

local function getToolEquipped()
    for i, v in pairs(game.workspace:GetChildren()) do
        if v.Name == game.Players.LocalPlayer.Name then
            local tool = v:FindFirstChildOfClass("Tool")
            if not tool then
                return nil
            end
            if tool:FindFirstChild("Fire") and tool.Fire:IsA("Sound") then
                return true --pistol
            else
                return false --knife
            end
        end
    end
    return nil
end
PlaceId:CreateKeybind(
    {
        Name = "Kill All",
        Default = Enum.KeyCode.J,
        Callback = function()
            local pistol = getToolEquipped()
            repeat
                pistol = getToolEquipped()
                task.wait(0.2)
            until pistol ~= nil
            if pistol then
                for i, v in pairs(game.workspace:GetChildren()) do
                    if
                        v.ClassName == "Model" and v.Name ~= "" and v:FindFirstChild("HumanoidRootPart") and
                            v.Name ~= game.Players.LocalPlayer.Name
                     then
                        if
                            game.Players[v.Name].Team ~= nil and
                                game.Players[v.Name].Team ~= game.Players.LocalPlayer.Team and
                                v.Humanoid.Health > 0
                         then
                            local args = {
                                [1] = Vector3.new(0, 0, 0),
                                [2] = Vector3.new(0, 0, 0),
                                [3] = v.HumanoidRootPart.Part,
                                [4] = Vector3.new(0, 0, 0)
                            }

                            game:GetService("ReplicatedStorage").Remotes.Shoot:FireServer(unpack(args))
                        end
                    end
                end
            else
                for i, v in pairs(game.workspace:GetChildren()) do
                    if
                        v.ClassName == "Model" and v.Name ~= "" and v:FindFirstChild("HumanoidRootPart") and
                            v.Name ~= game.Players.LocalPlayer.Name
                     then
                        if
                            game.Players[v.Name].Team ~= nil and
                                game.Players[v.Name].Team ~= game.Players.LocalPlayer.Team and
                                v.Humanoid.Health > 0
                         then
                            game:GetService("ReplicatedStorage").Remotes.Stab:FireServer(v.HumanoidRootPart)
                        end
                    end
                end
            end
        end
    }
)

PlaceId:CreateKeybind(
    {
        Name = "Kill one",
        Default = Enum.KeyCode.R,
        Callback = function()
            local pistol = getToolEquipped()
            repeat
                pistol = getToolEquipped()
                task.wait(0.2)
            until pistol ~= nil
            if pistol then
                for i, v in pairs(game.workspace:GetChildren()) do
                    if
                        v.ClassName == "Model" and v.Name ~= "" and v:FindFirstChild("HumanoidRootPart") and
                            v.Name ~= game.Players.LocalPlayer.Name
                     then
                        if
                            game.Players[v.Name].Team ~= nil and
                                game.Players[v.Name].Team ~= game.Players.LocalPlayer.Team and
                                v.Humanoid.Health > 0
                         then
                            local args = {
                                [1] = Vector3.new(0, 0, 0),
                                [2] = Vector3.new(0, 0, 0),
                                [3] = v.HumanoidRootPart.Part,
                                [4] = Vector3.new(0, 0, 0)
                            }

                            game:GetService("ReplicatedStorage").Remotes.Shoot:FireServer(unpack(args))
                            return
                        end
                    end
                end
            else
                for i, v in pairs(game.workspace:GetChildren()) do
                    if
                        v.ClassName == "Model" and v.Name ~= "" and v:FindFirstChild("HumanoidRootPart") and
                            v.Name ~= game.Players.LocalPlayer.Name
                     then
                        if
                            game.Players[v.Name].Team ~= nil and
                                game.Players[v.Name].Team ~= game.Players.LocalPlayer.Team and
                                v.Humanoid.Health > 0
                         then
                            game:GetService("ReplicatedStorage").Remotes.Stab:FireServer(v.HumanoidRootPart)
                            return
                        end
                    end
                end
            end
        end
    }
)
local delay = 0
local hc = 40
PlaceId:CreateSlider(
    {
        Name = "Lag Simulator",
        Min = 0,
        Max = 5,
        Default = delay,
        Decimals = 1,
        Callback = function(value)
            delay = value
        end
    }
)
PlaceId:CreateSlider(
    {
        Name = "Hitchance",
        Min = 0,
        Max = 100,
        Default = hc,
        Decimals = 0.1,
        Callback = function(value)
            hc = value
        end
    }
)
PlaceId:CreateToggle(
    {
        Name = "Silent Aim",
        Callback = function(bool)
            local function test(mouseHit)
                local nearestPlayer, nearestDistance = nil, math.huge

                for _, player in ipairs(game.Players:GetPlayers()) do
                    if
                        player ~= game.Players.LocalPlayer and player.Character and
                            player.Character:FindFirstChild("HumanoidRootPart")
                     then
                        local playerRootPart = player.Character.HumanoidRootPart
                        local distance = (playerRootPart.Position - mouseHit).Magnitude

                        if
                            distance < nearestDistance and player.Team and player.Team ~= game.Players.LocalPlayer.Team and
                                player.Character.Humanoid and
                                player.Character.Humanoid.Health > 0
                         then
                            nearestPlayer = player
                            nearestDistance = distance
                        end
                    end
                end
                if nearestPlayer then
                    return nearestPlayer
                end
            end
            local UserInputService = game:GetService("UserInputService")

            local function onMouseButton1Click(mouse)
                local mouseLocation = mouse.X, mouse.Y
                local worldPosition = mouse.Hit.Position
                return worldPosition
            end

            UserInputService.InputBegan:Connect(
                function(input, isProcessed)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local mouse = game.Players.LocalPlayer:GetMouse()
                        local nearestToMouse = test(onMouseButton1Click(mouse))
                        local pistol = getToolEquipped()
                        if pistol then
                            local chance = math.round(math.random())
                            if chance <= hc / 100 then
                                local args = {
                                    [1] = Vector3.new(0, 0, 0),
                                    [2] = Vector3.new(0, 0, 0),
                                    [3] = nearestToMouse.Character.HumanoidRootPart.Part,
                                    [4] = Vector3.new(0, 0, 0)
                                }
                                if delay > 0 then
                                    task.wait(delay)
                                end
                                game:GetService("ReplicatedStorage").Remotes.Shoot:FireServer(unpack(args))
                            else
                                notifLib:Notify("You missed", {Color = Color3.new(255, 255, 255)})
                            end
                        else
                            notifLib:Notify("You should equip pistol", {Color = Color3.new(255, 0, 0)})
                        end
                    end
                end
            )
        end
    }
)
