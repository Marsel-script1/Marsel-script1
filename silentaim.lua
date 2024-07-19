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
                            print("pistol")
                        end
                    end
                end
            )
        end
    }
)
