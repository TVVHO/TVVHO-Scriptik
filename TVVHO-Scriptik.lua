-- Сброс
pcall(function() if game:GetService("CoreGui"):FindFirstChild("TVVHO_LITE") then game:GetService("CoreGui")["TVVHO_LITE"]:Destroy() end end)
wait(0.5)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Флаги
local Flags = {SilentAim=true, AimPart="Head", ESP=false, Hitbox=false, TriggerBot=false, Speed=false, Jump=false, Gravity=false, NoClip=false}

-- Настройки
local Aim_Settings = {Radius = 150}

-- БИБЛИОТЕКА РИСОВАНИЯ (DrawingLib)
local DrawingLib
pcall(function() DrawingLib = loadstring(game:HttpGet("https://kiriot22.com/releases/drawing-lib.lua"))() end)

-- FOV Circle (Круг)
local FOV_Circle
if DrawingLib then
    FOV_Circle = DrawingLib:Create('Circle', {
        Visible = Flags["SilentAim"], 
        Color = Color3.fromRGB(255, 0, 0), 
        Transparency = 0.5, 
        Thickness = 3, 
        NumSides = 100, 
        Radius = Aim_Settings.Radius, 
        Filled = false, 
        Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    })
end

-- ==========================================
-- МЕНЮ (САМЫЙ ПРОСТОЙ ВАРИАНТ)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TVVHO_LITE"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Кнопка открытия (маленький квадрат)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "Toggle"
ToggleBtn.Parent = ScreenGui
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleBtn.Text = "M"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 24
ToggleBtn.AutoButtonColor = false
ToggleBtn.ZIndex = 10

-- Главное окно (Рамка)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.Position = UDim2.new(0.5, -150, 0.5, -100)
Main.Size = UDim2.new(0, 300, 0, 200)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Visible = false

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Title.Text = "TVVHO LITE"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

-- Контейнер для кнопок
local Page = Instance.new("ScrollingFrame")
Page.Parent = Main
Page.Position = UDim2.new(0, 0, 0, 35)
Page.Size = UDim2.new(1, 0, 1, -35)
Page.BackgroundTransparency = 1
Page.CanvasSize = UDim2.new(0, 0, 0, 0)
Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Функция создания кнопок (Простая)
local function AddButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = Page
    Btn.Size = UDim2.new(1, -10, 0, 30)
    Btn.Position = UDim2.new(0, 5, 0, (#Page:GetChildren() - 1) * 35)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Btn.Text = text
    Btn.Font = Enum.Font.Gotham
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 13
    Btn.AutoButtonColor = false
    Btn.MouseButton1Click:Connect(callback)
    
    -- Обновляем размер скролла
    Page.CanvasSize = UDim2.new(0, 0, 0, (#Page:GetChildren() - 1) * 35 + 10)
end

-- Кнопка открытия меню
ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- ==========================================
-- КНОПКИ ФУНКЦИЙ
-- ==========================================
AddButton("Silent Aim: " .. (Flags.SilentAim and "ON" or "OFF"), function()
    Flags.SilentAim = not Flags.SilentAim
    if FOV_Circle then FOV_Circle.Visible = Flags.SilentAim end
    -- Обновляем текст кнопки (сложно, пропустим для простоты)
end)

AddButton("ESP: " .. (Flags.ESP and "ON" or "OFF"), function() Flags.ESP = not Flags.ESP end)
AddButton("Hitbox: " .. (Flags.Hitbox and "ON" or "OFF"), function() Flags.Hitbox = not Flags.Hitbox end)
AddButton("TriggerBot: " .. (Flags.TriggerBot and "ON" or "OFF"), function() Flags.TriggerBot = not Flags.TriggerBot end)
AddButton("Speed (50)", function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = 50 end end)
AddButton("Jump (50)", function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = 50 end end)
AddButton("Gravity", function() Flags.Gravity = not Flags.Gravity; workspace.Gravity = Flags.Gravity and 100 or 196.2 end)
AddButton("NoClip", function() Flags.NoClip = not Flags.NoClip end)
AddButton("Телепорт (Кликни)", function()
    local Mouse = LocalPlayer:GetMouse()
    Mouse.Button1Down:Connect(function()
        local TargetPos = Mouse.Hit.p
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(TargetPos + Vector3.new(0, 5, 0)))
        end
    end)
end)

-- ==========================================
-- ЛОГИКА ЧИТОВ
-- ==========================================

-- Silent Aim
RunService.Heartbeat:Connect(function()
    if Flags.SilentAim then
        local Target, Shortest = nil, math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(Flags.AimPart) then
                local Part = v.Character[Flags.AimPart]
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
                            Target = v
                        end
                    end
                end
            end
        end
        if Target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character[Flags.AimPart].Position) end
    end
end)

-- TriggerBot
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
end)

-- NoClip
if Flags.NoClip then
    RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

-- Hitbox
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
end)

-- Speed/Jump/Gravity
RunService.Heartbeat:Connect(function()
    if Flags.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = 50 end
    if Flags.Jump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = 50 end
    if Flags.Gravity then workspace.Gravity = 100 else workspace.Gravity = 196.2 end
end)

-- ESP
if Flags.ESP then
    RunService.Heartbeat:Connect(function()
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                if not v.Character:FindFirstChild("TVVHO_ESP") then
                    local hl = Instance.new("Highlight", v.Character)
                    hl.Name = "TVVHO_ESP"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.7
                    hl.DepthMode = Enum.HighlightDepthMode.Occluded
                end
            end
        end
    end)
end)

print("TVVHO LITE Loaded. [Кнопка 'M' в углу]")
