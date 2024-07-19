local SilentAim = {}
SilentAim.Callback = function(bool)
    local function test(mouseHit)
        local nearestPlayer, nearestDistance = nil, math.huge

        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local playerRootPart = player.Character.HumanoidRootPart
                local distance = (playerRootPart.Position - mouseHit).Magnitude

                if distance < nearestDistance and player.Team and player.Team ~= game.Players.LocalPlayer.Team and player.Character.Humanoid and player.Character.Humanoid.Health > 0 then
                    nearestPlayer = player
                    nearestDistance = distance
                end
            end
        end
        return nearestPlayer
    end

    local UserInputService = game:GetService("UserInputService")

    local function onMouseButton1Click(mouse)
        local mouseLocation = Vector2.new(mouse.X, mouse.Y)
        local worldPosition = mouse.Hit.Position
        return worldPosition
    end

    local function getToolEquipped()
        local character = game.Players.LocalPlayer.Character
        if character then
            for _, tool in ipairs(character:GetChildren()) do
                if tool:IsA("Tool") then
                    return tool
                end
            end
        end
        return nil
    end

    UserInputService.InputBegan:Connect(function(input, isProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouse = game.Players.LocalPlayer:GetMouse()
            local nearestToMouse = test(onMouseButton1Click(mouse))
            local pistol = getToolEquipped()
            if pistol then
                local hc = 50 -- Hit chance percentage, change as needed
                local delay = 0 -- Delay in seconds, change as needed
                local chance = math.random(100)
                if chance <= hc then
                    local args = {
                        [1] = Vector3.new(0, 0, 0),
                        [2] = Vector3.new(0, 0, 0),
                        [3] = nearestToMouse.Character.HumanoidRootPart,
                        [4] = Vector3.new(0, 0, 0)
                    }
                    if delay > 0 then
                        task.wait(delay)
                    end
                    game:GetService("ReplicatedStorage").Remotes.Shoot:FireServer(unpack(args))
                else
                    print("You missed")
                end
            else
                print("No pistol equipped")
            end
        end
    end)
end

-- Automatically turn on SilentAim
SilentAim.Callback(true)

return SilentAim
