-- Сброс старых объектов
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("TVVHO_WORKING") then
        game:GetService("CoreGui")["TVVHO_WORKING"]:Destroy()
    end
end)
wait(0.5)

-- Библиотека рисования (для круга FOV)
local DrawingLib
pcall(function()
    DrawingLib = loadstring(game:HttpGet("https://kiriot22.com/releases/drawing-lib.lua"))()
end)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- НАСТРОЙКИ ХИТБОКСА
local Hitbox_Settings = {
    ["Size"] = 8, -- Размер хитбокса (6-10 оптимально)
    ["Color"] = Color3.fromRGB(255, 0, 0),
    ["Transparency"] = 0.7,
    ["Enabled"] = false
}

local Hitbox_Connections = {} -- Для очистки

-- Состояния
local Flags = {
    ["SilentAim"] = true,
    ["ESP"] = false,
    ["Speed"] = false,
    ["FOV_Circle"] = true,
    ["Hitbox"] = false -- Состояние кнопки
}

-- FOV Circle Object
local FOV_Circle
if DrawingLib then
    FOV_Circle = DrawingLib:Create('Circle', {
        Visible = Flags["FOV_Circle"],
        Color = Color3.fromRGB(100, 0, 255),
        Transparency = 0.6,
        Thickness = 2,
        NumSides = 100,
        Radius = 150,
        Filled = false,
        Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    })
end

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "TVVHO_WORKING"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ФОН (Эффект стекла)
local Blur = Instance.new("Frame", ScreenGui)
Blur.BackgroundTransparency = 0.9
Blur.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Blur.Size = UDim2.new(1, 0, 1, 0)
Blur.Position = UDim2.new(0, 0, 0, 0)
Blur.Visible = false
local BlurCorner = Instance.new("UICorner", Blur)
BlurCorner.CornerRadius = UDim.new(0, 12)
local BlurShadow = Instance.new("UIStroke", Blur)
BlurShadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
BlurShadow.Color = Color3.fromRGB(60, 0, 120)
BlurShadow.Thickness = 2
BlurShadow.Transparency = 0.5

local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Main.Position = UDim2.new(0.5, -110, 0.5, -120)
Main.Size = UDim2.new(0, 220, 0, 320)
Main.Active = true
Main.Draggable = true
Main.Visible = false
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 12)

-- Тень окна (UIStroke)
local MainShadow = Instance.new("UIStroke", Main)
MainShadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainShadow.Color = Color3.fromRGB(60, 0, 120)
MainShadow.Thickness = 2
MainShadow.Transparency = 0.6

local Title = Instance.new("TextLabel", Main)
Title.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Aether Hub"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
ToggleBtn.Position = UDim2.new(0, 10, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Text = "M"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 24
ToggleBtn.AutoButtonColor = false
local ToggleCorner = Instance.new("UICorner", ToggleBtn)
ToggleCorner.CornerRadius = UDim.new(0, 8)
local ToggleShadow = Instance.new("UIStroke", ToggleBtn)
ToggleShadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleShadow.Color = Color3.fromRGB(100, 0, 200)
ToggleShadow.Thickness = 2

local List = Instance.new("UIListLayout", Main)
List.Padding = UDim.new(0, 8)

-- Функция кнопок
local function Btn(text, func, flag)
    local button = Instance.new("TextButton", Main)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    button.Position = UDim2.new(0.05, 0, 0, 0)
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.Text = text
    button.Font = Enum.Font.Gotham
    button.TextColor3 = Color3.fromRGB(220, 220, 255)
    button.TextSize = 14
    button.AutoButtonColor = false
    local BtnCorner = Instance.new("UICorner", button)
    BtnCorner.CornerRadius = UDim.new(0, 8)
    local BtnShadow = Instance.new("UIStroke", button)
    BtnShadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    BtnShadow.Color = Color3.fromRGB(60, 0, 120)
    BtnShadow.Thickness = 1
    BtnShadow.Transparency = 0.7

    -- Чекбокс
    local Check = Instance.new("Frame", button)
    Check.BackgroundColor3 = (flag and Flags[flag] and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0)
    Check.Position = UDim2.new(0.85, 0, 0.5, 0)
    Check.Size = UDim2.new(0, 12, 0, 12)
    Check.AnchorPoint = Vector2.new(0.5, 0.5)
    local CheckCorner = Instance.new("UICorner", Check)
    CheckCorner.CornerRadius = UDim.new(0, 3)

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}):Play()
        TweenService:Create(button, TweenInfo.new(0.15), {Size = UDim2.new(0.92, 0, 0, 37)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
        TweenService:Create(button, TweenInfo.new(0.15), {Size = UDim2.new(0.9, 0, 0, 35)}):Play()
    end)
    button.MouseButton1Click:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.05), {Size = UDim2.new(0.88, 0, 0, 33)}):Play()
        wait(0.05)
        TweenService:Create(button, TweenInfo.new(0.05), {Size = UDim2.new(0.9, 0, 0, 35)}):Play()
        func()
        if flag then
            Check.BackgroundColor3 = (Flags[flag] and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0)
        end
    end)
    
    List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Main.Size = UDim2.new(0, 220, 0, 45 + List.AbsoluteContentSize.Y + 15)
    end)
end

-- КНОПКИ
local y = 45
Btn("Скорость (100)", function()
    Flags.Speed = not Flags.Speed
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Flags.Speed and 100 or 16
    end
end, "Speed")
y = y + 45

Btn("Прыжок (100)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 100
    end
end)
y = y + 45

Btn("ВХ (ESP)", function()
    Flags.ESP = not Flags.ESP
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            if not v.Character:FindFirstChild("TVVHO_ESP") and Flags.ESP then
                local hl = Instance.new("Highlight", v.Character)
                hl.Name = "TVVHO_ESP"
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.7
            elseif v.Character:FindFirstChild("TVVHO_ESP") and not Flags.ESP then
                v.Character:FindFirstChild("TVVHO_ESP"):Destroy()
            end
        end
    end
end, "ESP")
y = y + 45

Btn("Silent Aim", function()
    Flags.SilentAim = not Flags.SilentAim
end, "SilentAim")
y = y + 45

-- КНОПКА ХИТБОКСА (EXPANDER)
Btn("Hitbox Expander", function()
    Flags.Hitbox = not Flags.Hitbox
    
    -- Очистка старых хитбоксов
    for _, conn in pairs(Hitbox_Connections) do
        if conn then conn:Disconnect() end
    end
    table.clear(Hitbox_Connections)
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "TVVHO_HITBOX" then v:Destroy() end
    end
    
    if Flags.Hitbox then
        -- Функция создания хитбокса
        local function CreateHitbox(char)
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local hb = Instance.new("Part", char)
            hb.Name = "TVVHO_HITBOX"
            hb.Shape = Enum.PartType.Ball
            hb.Size = Vector3.new(Hitbox_Settings.Size, Hitbox_Settings.Size, Hitbox_Settings.Size)
            hb.Color = Hitbox_Settings.Color
            hb.Transparency = Hitbox_Settings.Transparency
            hb.CanCollide = false
            hb.Massless = true
            hb.Anchored = false
            hb.Name = "TVVHO_HITBOX"
            
            local weld = Instance.new("WeldConstraint", hb)
            weld.Part0 = hb
            weld.Part1 = char.HumanoidRootPart
        end
        
        -- Создаем для существующих
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                CreateHitbox(v.Character)
            end
        end
        
        -- Слушаем появление новых игроков
        Hitbox_Connections["PlayerAdded"] = Players.PlayerAdded:Connect(function(plr)
            Hitbox_Connections["CharAdded_" .. plr.Name] = plr.CharacterAdded:Connect(function(char)
                wait(0.5)
                CreateHitbox(char)
            end)
        end)
        
        -- Удаляем при выходе
        Hitbox_Connections["PlayerRemoving"] = Players.PlayerRemoving:Connect(function(plr)
            if Hitbox_Connections["CharAdded_" .. plr.Name] then
                Hitbox_Connections["CharAdded_" .. plr.Name]:Disconnect()
            end
            if plr.Character then
                for _, v in pairs(plr.Character:GetDescendants()) do
                    if v.Name == "TVVHO_HITBOX" then v:Destroy() end
                end
            end
        end)
    end
end, "Hitbox")
y = y + 45

Btn("FOV Circle", function()
    Flags.FOV_Circle = not Flags.FOV_Circle
    if FOV_Circle then
        FOV_Circle.Visible = Flags.FOV_Circle
    end
end, "FOV_Circle")
y = y + 45

Btn("Сбросить", function()
    Flags.Speed = false
    Flags.SilentAim = true
    Flags.ESP = false
    Flags.FOV_Circle = true
    Flags.Hitbox = false
    
    if FOV_Circle then FOV_Circle.Visible = true end
    
    -- Очистка хитбоксов при сбросе
    for _, conn in pairs(Hitbox_Connections) do
        if conn then conn:Disconnect() end
    end
    table.clear(Hitbox_Connections)
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "TVVHO_HITBOX" then v:Destroy() end
    end
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Highlight") and v.Name == "TVVHO_ESP" then v:Destroy() end
    end
end)

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
local CloseCorner = Instance.new("UICorner", Close)
CloseCorner.CornerRadius = UDim.new(0, 4)
Close.MouseButton1Click:Connect(function() 
    Blur.Visible = false
    Main.Visible = false 
end)

-- УПРАВЛЕНИЕ МЕНЮ
ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    Blur.Visible = Main.Visible
end)

-- Silent Aim (HEARTBEAT)
RunService.Heartbeat:Connect(function()
    if Flags.SilentAim then
        if UserInputService:IsKeyDown(Enum.KeyCode_L) then
            local Target = nil
            local Shortest = math.huge
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                    local Head = v.Character.Head
                    local Vec, Vis = Camera:WorldToViewportPoint(Head.Position)
                    if Vis then
                        local MouseVec = Vector2.new(Mouse.X, Mouse.Y)
                        local Dist = (MouseVec - Vector2.new(Vec.X, Vec.Y)).Magnitude
                        if Dist < 150 and Dist < Shortest then
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
            if Target then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
            end
        end
    end
end)

-- Обновление позиции круга
RunService:BindToRenderStep("UpdateFOV", Enum.RenderPriority.Camera.Value - 1, function()
    if FOV_Circle and Flags.FOV_Circle then
        FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
end)

print("Aether Glass v4.0 Loaded. [M] for Menu | [L] for Aim | Hitbox ON = God Mode") 
