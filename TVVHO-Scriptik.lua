-- Сервисы
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Создаем главный интерфейс TVVHO Hub
local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local ScrollingContainer = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

-- Настройки GUI
ScreenGui.Name = "TVVHO_Hub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Кнопка открыть/закрыть (Красная точка)
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Position = UDim2.new(0, 15, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.AutoButtonColor = true
ToggleBtn.Text = ""
ToggleBtn.ZIndex = 2
ToggleBtn.Name = "ToggleBtn"

-- Скругление кнопки
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0) -- Полный круг
ToggleCorner.Parent = ToggleBtn

-- Тень кнопки
local ToggleShadow = Instance.new("UIStroke")
ToggleShadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleShadow.Color = Color3.fromRGB(0, 0, 0)
ToggleShadow.Transparency = 0.5
ToggleShadow.Thickness = 3
ToggleShadow.Parent = ToggleBtn

-- Главное окно (Стиль: Стекло/Темный неон)
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.3, 0, 0.2, 0)
Main.Size = UDim2.new(0, 240, 0, 380)
Main.Active = true
Main.Draggable = true
Main.Visible = false -- Скрыто по умолчанию
Main.ZIndex = 1

-- Скругление окна
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

-- Тень окна
local MainShadow = Instance.new("UIStroke")
MainShadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainShadow.Color = Color3.fromRGB(100, 0, 255) -- Неоновая фиолетовая обводка
MainShadow.Transparency = 0.7
MainShadow.Thickness = 2
MainShadow.Parent = Main

-- Внутренний отступ (чтобы контент не прилипал к тени)
local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 10)
UIPadding.Parent = Main

-- Заголовок (Внутри окна, без отдельной рамки)
Title.Parent = Main
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "TVVHO Hub"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(200, 200, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Center

-- Контейнер для прокрутки (если кнопок будет много)
ScrollingContainer.Parent = Main
ScrollingContainer.BackgroundTransparency = 1
ScrollingContainer.Position = UDim2.new(0, 0, 0, 45)
ScrollingContainer.Size = UDim2.new(1, 0, 1, -50)

UIListLayout.Parent = ScrollingContainer
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Функция создания красивых кнопок
local function CreateButton(text, icon, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollingContainer
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.fromRGB(220, 220, 255)
    btn.TextSize = 14
    btn.Text = icon .. "  " .. text
    btn.AutoButtonColor = false -- Отключаем стандартную подсветку, делаем свою
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = btn
    
    -- Анимация наведения
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 38)}):Play()
        wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 40)}):Play()
        callback()
    end)
    
    return btn
end

-- ЛОГИКА КНОПОК (Функции остались прежними, изменился только вызов CreateButton)

-- 1. КНОПКА: Скорость
CreateButton("Скорость (100)", "⚡", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 100
    end
end)

-- 2. КНОПКА: Высокий прыжок
CreateButton("Прыжок (120)", "🦘", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 120
    end
end)

-- 3. КНОПКА: ESP (Используем символы для иконок)
CreateButton("Включить ESP (ВХ)", "👁️", function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if not player.Character:FindFirstChild("TVVHO_ESP") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "TVVHO_ESP"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.7
                highlight.Parent = player.Character
            end
        end
    end
end)

-- 4. КНОПКА: Аимбот (Улучшенная версия из прошлого ответа)
CreateButton("Аимбот (По центру)", "🎯", function()
    local maxDistanceFromCenter = 150
    local closestPlayer = nil
    local smallestDot = -1

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local headPos = v.Character.Head.Position
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {LocalPlayer.Character, v.Character}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            local rayResult = workspace:Raycast(Camera.CFrame.Position, (headPos - Camera.CFrame.Position).Unit * 1000, rayParams)
            
            if not rayResult or (rayResult.Instance:IsDescendantOf(v.Character)) then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(headPos)
                if onScreen then
                    local vec = Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                    if vec.Magnitude < maxDistanceFromCenter then
                        local dot = Camera.CFrame.LookVector:Dot((headPos - Camera.CFrame.Position).Unit)
                        if dot > smallestDot then
                            smallestDot = dot
                            closestPlayer = v
                        end
                    end
                end
            end
        end
    end

    if closestPlayer and closestPlayer.Character:FindFirstChild("Head") then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestPlayer.Character.Head.Position)
    end
end)

-- 5. КНОПКА: Сброс
CreateButton("Сбросить всё", "🔄", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
    -- Дополнительно убираем ESP при сбросе
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            local esp = v.Character:FindFirstChild("TVVHO_ESP")
            if esp then esp:Destroy() end
        end
    end
end)

-- Логика открытия/закрытия с анимацией
ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    if Main.Visible then
        -- Плавное появление
        Main.BackgroundTransparency = 1
        TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    else
        -- Плавное исчезновение
        TweenService:Create(Main, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        wait(0.2)
        -- (Прозрачность вернется к 0 сама при следующем открытии)
    end
end)
