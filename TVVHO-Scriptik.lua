-- Сброс старых данных
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("AetherPVP") then
        game:GetService("CoreGui")["AetherPVP"]:Destroy()
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

-- Состояния (Флаги)
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
    ["AI_Bot"] = false -- Главный переключатель бота
}

-- Настройки
local Aim_Settings = {Radius = 150}
local Clicker_Key = Enum.KeyCode_E
local Parry_Key = Enum.KeyCode_F

-- Библиотека рисования (для круга)
local DrawingLib
pcall(function() DrawingLib = loadstring(game:HttpGet("https://kiriot22.com/releases/drawing-lib.lua"))() end)

-- FOV Circle
local FOV_Circle
if DrawingLib then
    FOV_Circle = DrawingLib:Create('Circle', {Visible = Flags["FOV_Circle"], Color = Color3.fromRGB(100, 0, 255), Transparency = 0.6, Thickness = 2, NumSides = 100, Radius = Aim_Settings.Radius, Filled = false, Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)})
end

-- GUI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "AetherPVP"
ScreenGui.ResetOnSpawn = false

-- Фон
local Blur = Instance.new("Frame", ScreenGui)
Blur.BackgroundTransparency = 0.9; Blur.Size = UDim2.new(1,0,1,0); Blur.Visible = false
local BlurCorner = Instance.new("UICorner", Blur); BlurCorner.CornerRadius = UDim.new(0, 12)

local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Main.Position = UDim2.new(0.5, -130, 0.5, -150)
Main.Size = UDim2.new(0, 260, 0, 350)
Main.Active = true; Main.Draggable = true; Main.Visible = false
local MainCorner = Instance.new("UICorner", Main); MainCorner.CornerRadius = UDim.new(0, 12)
local MainShadow = Instance.new("UIStroke", Main); MainShadow.Color = Color3.fromRGB(60, 0, 120); MainShadow.Thickness = 2

-- Заголовок
local Title = Instance.new("TextLabel", Main)
Title.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Aether PVP v5.0"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

-- Кнопка открытия
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
ToggleBtn.Position = UDim2.new(0, 10, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Text = "M"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 24
ToggleBtn.AutoButtonColor = false
local ToggleCorner = Instance.new("UICorner", ToggleBtn); ToggleCorner.CornerRadius = UDim.new(0, 8)

-- ВКЛАДКИ
local TabButtons = {}
local SelectedTab = "Combat"
local TabBar = Instance.new("Frame", Main)
TabBar.BackgroundTransparency = 1
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0, 0, 0, 35)

local Content = Instance.new("ScrollingFrame", Main)
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 0, 0, 70)
Content.Size = UDim2.new(1, 0, 1, -75)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
local ListLayout = Instance.new("UIListLayout", Content)
ListLayout.Padding = UDim.new(0, 6)

-- Функция создания таба
local function CreateTab(name)
    local btn = Instance.new("TextButton", TabBar)
    btn.BackgroundColor3 = (name == SelectedTab and Color3.fromRGB(60, 0, 120)) or Color3.fromRGB(40, 40, 50)
    btn.Size = UDim2.new(0.33, 0, 1, 0)
    btn.Position = UDim2.new((#TabButtons) * 0.33, 0, 0, 0)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.fromRGB(220, 220, 255)
    btn.TextSize = 12
    btn.AutoButtonColor = false
    local Corner = Instance.new("UICorner", btn); Corner.CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        SelectedTab = name
        for _, v in pairs(TabButtons) do v.BackgroundColor3 = Color3.fromRGB(40, 40, 50) end
        btn.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
        Content:ClearAllChildren()
        ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Content.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
        end)
        
        -- КНОПКИ ДЛЯ ВКЛАДКИ COMBAT
        if name == "Combat" then
            local function Btn2(text, func, flag)
                local button = Instance.new("TextButton", Content)
                button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                button.Size = UDim2.new(1, -10, 0, 35)
                button.Position = UDim2.new(0, 5, 0, 0)
                button.Text = text
                button.Font = Enum.Font.Gotham
                button.TextColor3 = Color3.fromRGB(220, 220, 255)
                button.TextSize = 14
                button.AutoButtonColor = false
                local BtnCorner = Instance.new("UICorner", button); BtnCorner.CornerRadius = UDim.new(0, 8)
                local BtnShadow = Instance.new("UIStroke", button); BtnShadow.Color = Color3.fromRGB(60, 0, 120); BtnShadow.Thickness = 1; BtnShadow.Transparency = 0.7
                local Check = Instance.new("Frame", button)
                Check.BackgroundColor3 = (flag and Flags[flag] and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0)
                Check.Position = UDim2.new(0.85, 0, 0.5, 0)
                Check.Size = UDim2.new(0, 12, 0, 12)
                Check.AnchorPoint = Vector2.new(0.5, 0.5)
                local CheckCorner = Instance.new("UICorner", Check); CheckCorner.CornerRadius = UDim.new(0, 3)
                button.MouseEnter:Connect(function() TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}):Play(); TweenService:Create(button, TweenInfo.new(0.15), {Size = UDim2.new(1.02, -10, 0, 37)}):Play() end)
                button.MouseLeave:Connect(function() TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play(); TweenService:Create(button, TweenInfo.new(0.15), {Size = UDim2.new(1, -10, 0, 35)}):Play() end)
                button.MouseButton1Click:Connect(function() TweenService:Create(button, TweenInfo.new(0.05), {Size = UDim2.new(0.98, -10, 0, 33)}):Play(); wait(0.05); TweenService:Create(button, TweenInfo.new(0.05), {Size = UDim2.new(1, -10, 0, 35)}):Play(); func(); if flag then Check.BackgroundColor3 = (Flags[flag] and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0) end end)
            end
            Btn2("Silent Aim", function() Flags.SilentAim = not Flags.SilentAim end, "SilentAim")
            Btn2("Aim Part", function() Flags.AimPart = (Flags.AimPart == "Head" and "Body") or "Head" end)
            Btn2("ESP", function() Flags.ESP = not Flags.ESP; for _,v in pairs(Players:GetPlayers()) do if v~=LocalPlayer and v.Character then if not v.Character:FindFirstChild("TVVHO_ESP") and Flags.ESP then local hl=Instance.new("Highlight",v.Character) hl.Name="TVVHO_ESP" hl.FillColor=Color3.fromRGB(255,0,0) hl.OutlineColor=Color3.fromRGB(255,255,255) hl.FillTransparency=0.7 elseif v.Character:FindFirstChild("TVVHO_ESP") and not Flags.ESP then v.Character:FindFirstChild("TVVHO_ESP"):Destroy() end end end end, "ESP")
            Btn2("Hitbox", function() Flags.Hitbox = not Flags.Hitbox; for _,v in pairs(workspace:GetDescendants()) do if v.Name=="TVVHO_HITBOX" then v:Destroy() end end; if Flags.Hitbox then for _,v in pairs(Players:GetPlayers()) do if v~=LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then local hb=Instance.new("Part",v.Character) hb.Name="TVVHO_HITBOX" hb.Shape=Enum.PartType.Ball hb.Size=Vector3.new(8,8,8) hb.Color=Color3.fromRGB(255,0,0) hb.Transparency=0.7 hb.CanCollide=false hb.Massless=true hb.Anchored=false local w=Instance.new("WeldConstraint",hb) w.Part0=hb w.Part1=v.Character.HumanoidRootPart end end end end, "Hitbox")
            Btn2("TriggerBot", function() Flags.TriggerBot = not Flags.TriggerBot end, "TriggerBot")
        elseif name == "World" then
            local function Btn2(text, func, flag)
                local button = Instance.new("TextButton", Content)
                button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                button.Size = UDim2.new(1, -10, 0, 35)
                button.Position = UDim2.new(0, 5, 0, 0)
                button.Text = text
                button.Font = Enum.Font.Gotham
                button.TextColor3 = Color3.fromRGB(220, 220, 255)
                button.TextSize = 14
                button.AutoButtonColor = false
                local BtnCorner = Instance.new("UICorner", button); BtnCorner.CornerRadius = UDim.new(0, 8)
                local BtnShadow = Instance.new("UIStroke", button); BtnShadow.Color = Color3.fromRGB(60, 0, 120); BtnShadow.Thickness = 1; BtnShadow.Transparency = 0.7
                local Check = Instance.new("Frame", button)
                Check.BackgroundColor3 = (flag and Flags[flag] and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0)
                Check.Position = UDim2.new(0.85, 0, 0.5, 0)
                Check.Size = UDim2.new(0, 12, 0, 12)
                Check.AnchorPoint = Vector2.new(0.5, 0.5)
                local CheckCorner = Instance.new("UICorner", Check); CheckCorner.CornerRadius = UDim.new(0, 3)
                button.MouseEnter:Connect(function() TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}):Play(); TweenService:Create(button, TweenInfo.new(0.15), {Size = UDim2.new(1.02, -10, 0, 37)}):Play() end)
                button.MouseLeave:Connect(function() TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play(); TweenService:Create(button, TweenInfo.new(0.15), {Size = UDim2.new(1, -10, 0, 35)}):Play() end)
                button.MouseButton1Click:Connect(function() TweenService:Create(button, TweenInfo.new(0.05), {Size = UDim2.new(0.98, -10, 0, 33)}):Play(); wait(0.05); TweenService:Create(button, TweenInfo.new(0.05), {Size = UDim2.new(1, -10, 0, 35)}):Play(); func(); if flag then Check.BackgroundColor3 = (Flags[flag] and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0) end end)
            end
            Btn2("Speed", function() Flags.Speed = not Flags.Speed; if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = Flags.Speed and 100 or 16 end end, "Speed")
            Btn2("Jump Power", function() Flags.Jump = not Flags.Jump; if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = Flags.Jump and 100 or 50 end end, "Jump")
            Btn2("Gravity", function() Flags.Gravity = not Flags.Gravity; workspace.Gravity = Flags.Gravity and 100 or 196.2 end, "Gravity")
            Btn2("FOV Circle", function() Flags.FOV_Circle = not Flags.FOV_Circle; if FOV_Circle then FOV_Circle.Visible = Flags.FOV_Circle end end, "FOV_Circle")
            Btn2("AI Combat Bot", function() Flags.AI_Bot = not Flags.AI_Bot end, "AI_Bot") -- Кнопка бота
        elseif name == "Settings" then
            local function Btn2(text, func, flag)
                local button = Instance.new("TextButton", Content)
                button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                button.Size = UDim2.new(1, -10, 0, 35)
                button.Position = UDim2.new(0, 5, 0, 0)
                button.Text = text
                button.Font = Enum.Font.Gotham
                button.TextColor3 = Color3.fromRGB(220, 220, 255)
                button.TextSize = 14
                button.AutoButtonColor = false
                local BtnCorner = Instance.new("UICorner", button); BtnCorner.CornerRadius = UDim.new(0, 8)
                local BtnShadow = Instance.new("UIStroke", button); BtnShadow.Color = Color3.fromRGB(60, 0, 120); BtnShadow.Thickness = 1; BtnShadow.Transparency = 0.7
                local Check = Instance.new("Frame", button)
                Check.BackgroundColor3 = (flag and Flags[flag] and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0)
                Check.Position = UDim2.new(0.85, 0, 0.5, 0)
                Check.Size = UDim2.new(0, 12, 0, 12)
                Check.AnchorPoint = Vector2.new(0.5, 0.5)
                local CheckCorner = Instance.new("UICorner", Check); CheckCorner.CornerRadius = UDim.new(0, 3)
                button.MouseEnter:Connect(function() TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}):Play(); TweenService:Create(button, TweenInfo.new(0.15), {Size = UDim2.new(1.02, -10, 0, 37)}):Play() end)
                button.MouseLeave:Connect(function() TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play(); TweenService:Create(button, TweenInfo.new(0.15), {Size = UDim2.new(1, -10, 0, 35)}):Play() end)
                button.MouseButton1Click:Connect(function() TweenService:Create(button, TweenInfo.new(0.05), {Size = UDim2.new(0.98, -10, 0, 33)}):Play(); wait(0.05); TweenService:Create(button, TweenInfo.new(0.05), {Size = UDim2.new(1, -10, 0, 35)}):Play(); func(); if flag then Check.BackgroundColor3 = (Flags[flag] and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0) end end)
            end
            Btn2("Close", function() Main.Visible = false; Blur.Visible = false end)
        end
        table.insert(TabButtons, btn)
    end)
end

CreateTab("Combat")
CreateTab("World")
CreateTab("Settings")

-- Кнопка закрытия
local Close = Instance.new("TextButton", Main)
Close.BackgroundTransparency = 1
Close.Position = UDim2.new(1, -25, 0, 5)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextColor3 = Color3.fromRGB(255, 100, 100)
Close.TextSize = 16
Close.AutoButtonColor = false
Close.MouseButton1Click:Connect(function() Main.Visible = false; Blur.Visible = false end)

-- Открытие меню
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible; Blur.Visible = Main.Visible end)

-- === ЦИКЛЫ ЛОГИКИ ===

-- 1. Silent Aim
RunService.Heartbeat:Connect(function()
    if Flags.SilentAim and UserInputService:IsKeyDown(Enum.KeyCode_L) then
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

-- 3. AI Combat Bot (Авто-режим)
if Flags.AI_Bot then
    spawn(function()
        while wait(0.2) do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local Target = nil
                local ShortestDist = math.huge
                
                -- Поиск цели
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                        local Magnitude = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        if Magnitude < 1000 and Magnitude < ShortestDist then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {LocalPlayer.Character, v.Character}
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            local rayResult = workspace:Raycast(LocalPlayer.Character.Head.Position, (v.Character.Head.Position - LocalPlayer.Character.Head.Position).Unit * 1000, rayParams)
                            if not rayResult or rayResult.Instance:IsDescendantOf(v.Character) then
                                ShortestDist = Magnitude
                                Target = v
                            end
                        end
                    end
                end

                -- Атака
                if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
                    local TargetRoot = Target.Character.HumanoidRootPart
                    local LocalRoot = LocalPlayer.Character.HumanoidRootPart
                    
                    -- Телепорт к цели (Pathfinding заменен на TP для скорости)
                    if (LocalRoot.Position - TargetRoot.Position).Magnitude > 20 then
                        LocalRoot.CFrame = TargetRoot.CFrame * CFrame.new(0, 0, -5)
                        wait(0.1)
                    end
                    
                    -- Наведение
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, TargetRoot.Position)
                    
                    -- Удар (TriggerBot логика внутри бота)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    wait(0.05)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            end
        end
    end)
end

-- 4. Gravity
if Flags.Gravity then workspace.Gravity = 100 else workspace.Gravity = 196.2 end

-- 5. FOV Circle
RunService:BindToRenderStep("UpdateFOV", Enum.RenderPriority.Camera.Value - 1, function()
    if FOV_Circle and Flags.FOV_Circle then
        FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
end)

print("Aether PVP v5.0 Loaded. [M] for Menu | [L] for Manual Aim | AI Bot in World Tab")
