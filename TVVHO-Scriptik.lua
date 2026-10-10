-- Сброс
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("AetherX") then
        game:GetService("CoreGui")["AetherX"]:Destroy()
    end
end)
wait(0.5)

-- Сервисы
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Состояния
local Flags = {
    ["SilentAim"] = true,
    ["AimPart"] = "Head",
    ["ESP"] = false,
    ["Speed"] = false,
    ["Jump"] = false,
    ["TriggerBot"] = false,
    ["Hitbox"] = false,
    ["Gravity"] = false,
    ["FOV_Circle"] = true,
    ["LockOn"] = false
}

-- Настройки
local Aim_Settings = {Radius = 150}

-- Библиотека рисования
local DrawingLib
pcall(function() DrawingLib = loadstring(game:HttpGet("https://kiriot22.com/releases/drawing-lib.lua"))() end)

-- FOV Circle
local FOV_Circle
if DrawingLib then
    FOV_Circle = DrawingLib:Create('Circle', {Visible = Flags["FOV_Circle"], Color = Color3.fromRGB(100, 0, 255), Transparency = 0.6, Thickness = 2, NumSides = 100, Radius = Aim_Settings.Radius, Filled = false, Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)})
end

-- GUI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "AetherX"
ScreenGui.ResetOnSpawn = false

-- ПЛАВАЮЩАЯ КНОПКА (Просто для вида)
local WatermarkBtn = Instance.new("TextButton", ScreenGui)
WatermarkBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
WatermarkBtn.BorderSizePixel = 0
WatermarkBtn.Size = UDim2.new(0, 40, 0, 40)
WatermarkBtn.Position = UDim2.new(0, 10, 1, -50)
WatermarkBtn.Text = "M"
WatermarkBtn.Font = Enum.Font.GothamBold
WatermarkBtn.TextSize = 24
WatermarkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
WatermarkBtn.AutoButtonColor = false
local Corner = Instance.new("UICorner", WatermarkBtn)
Corner.CornerRadius = UDim.new(0, 8)

-- МЕНЮ (Рамка, кнопок внутри НЕТ)
local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Main.Position = UDim2.new(0.5, -130, 0.5, -150)
Main.Size = UDim2.new(0, 260, 0, 350)
Main.Active = true
Main.Draggable = true
Main.Visible = false
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 12)
local MainShadow = Instance.new("UIStroke", Main)
MainShadow.Color = Color3.fromRGB(60, 0, 120)
MainShadow.Thickness = 2

-- Заголовок
local Title = Instance.new("TextLabel", Main)
Title.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Aether X [KEYS]"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

-- Текст-инструкция (Вместо кнопок)
local Info = Instance.new("TextLabel", Main)
Info.BackgroundTransparency = 1
Info.Position = UDim2.new(0, 10, 0, 45)
Info.Size = UDim2.new(1, -20, 1, -50)
Info.Text = "Управление:\n[L] - Aim\n[G] - Gravity\n[B] - Hitbox\n[T] - Trigger\n[Ctrl+L] - Lock-On"
Info.Font = Enum.Font.Gotham
Info.TextColor3 = Color3.fromRGB(200, 200, 255)
Info.TextSize = 14
Info.TextXAlignment = Enum.TextXAlignment.Center
Info.TextYAlignment = Enum.TextYAlignment.Top
Info.TextWrapped = true

-- Открытие меню
WatermarkBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- ГОРЯЧИЕ КЛАВИШИ (УПРАВЛЕНИЕ)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Silent Aim (Зажать)
    if input.KeyCode == Enum.KeyCode_L then
        Flags.SilentAim = true
    end
    
    -- Gravity (Переключатель)
    if input.KeyCode == Enum.KeyCode_G then
        Flags.Gravity = not Flags.Gravity
        workspace.Gravity = Flags.Gravity and 100 or 196.2
    end
    
    -- Hitbox (Переключатель)
    if input.KeyCode == Enum.KeyCode_B then
        Flags.Hitbox = not Flags.Hitbox
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "TVVHO_HITBOX" then v:Destroy() end
        end
        if Flags.Hitbox then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local hb = Instance.new("Part", v.Character)
                    hb.Name = "TVVHO_HITBOX"
                    hb.Shape = Enum.PartType.Ball
                    hb.Size = Vector3.new(8, 8, 8)
                    hb.Color = Color3.fromRGB(255, 0, 0)
                    hb.Transparency = 0.7
                    hb.CanCollide = false
                    hb.Massless = true
                    hb.Anchored = false
                    local w = Instance.new("WeldConstraint", hb)
                    w.Part0 = hb
                    w.Part1 = v.Character.HumanoidRootPart
                end
            end
        end
    end

    -- TriggerBot (Переключатель)
    if input.KeyCode == Enum.KeyCode_T then
        Flags.TriggerBot = not Flags.TriggerBot
    end

    -- Lock-On (Зажать Ctrl + L)
    if input.KeyCode == Enum.KeyCode_L and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        Flags.LockOn = not Flags.LockOn
    end
end)

-- Отпускание Aim
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode_L then
        Flags.SilentAim = false
    end
end)

-- ЛОГИКА (Циклы)

-- 1. Silent Aim
RunService.Heartbeat:Connect(function()
    if Flags.SilentAim then
        local Target, Shortest = nil, math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local Part = v.Character:FindFirstChild(Flags.AimPart) or v.Character:FindFirstChild("HumanoidRootPart")
                if Part then
                    local Vec, Vis = Camera:WorldToViewportPoint(Part.Position)
                    if Vis then
                        local MouseVec = Vector2.new(Mouse.X, Mouse.Y)
                        local Dist = (MouseVec - Vector2.new(Vec.X, Vec.Y)).Magnitude
                        if Dist < 150 and Dist < Shortest then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {LocalPlayer.Character, v.Character}
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            local rayResult = workspace:Raycast(Camera.CFrame.Position, (Part.Position - Camera.CFrame.Position).Unit * 1000, rayParams)
                            if not rayResult or rayResult.Instance:IsDescendantOf(v.Character) then
                                Shortest = Dist
                                Target = Part
                            end
                        end
                    end
                end
            end
        end
        if Target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position) end
    end
end)

-- 2. TriggerBot
if Flags.TriggerBot then
    RunService.Heartbeat:Connect(function()
        local target = Mouse.Target
        if target then
            local char = target:FindFirstAncestorWhichIsA("Model")
            if char and char:FindFirstChild("Humanoid") then
                local plr = Players:GetPlayerFromCharacter(char)
                if plr and plr ~= LocalPlayer then
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    wait(0.05)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            end
        end
    end)
end

-- 3. Lock-On (Авто-наведение)
if Flags.LockOn then
    RunService.Heartbeat:Connect(function()
        local Target, Shortest = nil, math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                local Head = v.Character.Head
                local Vec, Vis = Camera:WorldToViewportPoint(Head.Position)
                if Vis then
                    local MouseVec = Vector2.new(Mouse.X, Mouse.Y)
                    local Dist = (MouseVec - Vector2.new(Vec.X, Vec.Y)).Magnitude
                    if Dist < 200 and Dist < Shortest then
                        local rayParams = RaycastParams.new()
                        rayParams.FilterDescendantsInstances = {LocalPlayer.Character, v.Character}
                        rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        local rayResult = workspace:Raycast(Camera.CFrame.Position, (Head.Position - Camera.CFrame.Position).Unit * 1000, rayParams)
                        if not rayResult or rayResult.Instance:IsDescendantOf(v.Character) then
                            Shortest = Dist
                            Target = Head
                        end
                    end
                end
            end
        end
        if Target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position) end
    end)
end

-- 4. Hitbox (Создание)
if Flags.Hitbox then
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hb = Instance.new("Part", v.Character)
            hb.Name = "TVVHO_HITBOX"
            hb.Shape = Enum.PartType.Ball
            hb.Size = Vector3.new(8, 8, 8)
            hb.Color = Color3.fromRGB(255, 0, 0)
            hb.Transparency = 0.7
            hb.CanCollide = false
            hb.Massless = true
            hb.Anchored = false
            local w = Instance.new("WeldConstraint", hb)
            w.Part0 = hb
            w.Part1 = v.Character.HumanoidRootPart
        end
    end
end

-- 5. Speed/Jump/Gravity
if Flags.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = 100 end
if Flags.Jump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = 100 end
if Flags.Gravity then workspace.Gravity = 100 else workspace.Gravity = 196.2 end

-- 6. FOV Circle
if FOV_Circle and Flags.FOV_Circle then
    RunService:BindToRenderStep("UpdateFOV", Enum.RenderPriority.Camera.Value - 1, function()
        FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end)
end

print("Aether X KEYS Loaded. [M] Menu | [L] Aim | [G] Grav | [B] Box | [T] Trigger")
