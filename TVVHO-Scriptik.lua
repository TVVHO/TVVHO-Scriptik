-- СБРОС
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("TVVHO_Hub") then
        game:GetService("CoreGui")["TVVHO_Hub"]:Destroy()
    end
end)
wait(0.5)

-- Сервисы
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Состояния
local NoclipActive = false
local FarmActive = false

-- Переменные для GUI
local CurrentTheme = "Dark" -- Dark или Light

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local ScrollingContainer = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "TVVHO_Hub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Enabled = false

-- Кнопка (с иконкой настроек для смены темы)
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = (CurrentTheme == "Dark" and Color3.fromRGB(220, 50, 50)) or Color3.fromRGB(255, 220, 0)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Position = UDim2.new(0, 15, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.AutoButtonColor = true
ToggleBtn.Text = "☀️" -- Иконка солнца (тема)
ToggleBtn.ZIndex = 2
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn
local ToggleShadow = Instance.new("UIStroke")
ToggleShadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleShadow.Color = Color3.fromRGB(0, 0, 0)
ToggleShadow.Transparency = 0.5
ToggleShadow.Thickness = 3
ToggleShadow.Parent = ToggleBtn

-- Главное окно
Main.Parent = ScreenGui
Main.BackgroundColor3 = (CurrentTheme == "Dark" and Color3.fromRGB(20, 20, 25)) or Color3.fromRGB(240, 240, 245)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.3, 0, 1.2, 0)
Main.Size = UDim2.new(0, 260, 0, 420)
Main.Active = true
Main.Draggable = true
Main.Visible = true
Main.ZIndex = 1
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main
local MainShadow = Instance.new("UIStroke")
MainShadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainShadow.Color = (CurrentTheme == "Dark" and Color3.fromRGB(100, 0, 255)) or Color3.fromRGB(0, 100, 255)
MainShadow.Transparency = 0.7
MainShadow.Thickness = 2
MainShadow.Parent = Main
local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 10)
UIPadding.Parent = Main

-- Заголовок
Title.Parent = Main
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "TVVHO Hub [GLOBAL]"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = (CurrentTheme == "Dark" and Color3.fromRGB(200, 200, 255)) or Color3.fromRGB(30, 30, 40)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Center

-- Контейнер
ScrollingContainer.Parent = Main
ScrollingContainer.BackgroundTransparency = 1
ScrollingContainer.Position = UDim2.new(0, 0, 0, 45)
ScrollingContainer.Size = UDim2.new(1, 0, 1, -50)
UIListLayout.Parent = ScrollingContainer
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Функция кнопок
local function CreateButton(text, icon, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollingContainer
    btn.BackgroundColor3 = (CurrentTheme == "Dark" and Color3.fromRGB(35, 35, 45)) or Color3.fromRGB(230, 230, 240)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = (CurrentTheme == "Dark" and Color3.fromRGB(220, 220, 255)) or Color3.fromRGB(40, 40, 50)
    btn.TextSize = 14
    btn.Text = icon .. "  " .. text
    btn.AutoButtonColor = false
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = btn
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = (CurrentTheme == "Dark" and Color3.fromRGB(50, 50, 70)) or Color3.fromRGB(210, 210, 220)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = (CurrentTheme == "Dark" and Color3.fromRGB(35, 35, 45)) or Color3.fromRGB(230, 230, 240)}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 38)}):Play()
        wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 40)}):Play()
        callback()
    end)
    return btn
end

-- ФУНКЦИИ НОВЫХ КНОПОК

-- 1. Teleport Tool
CreateButton("Телепорт (1000 стаков)", "🛸", function()
    local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if Root then
        Root.CFrame = Root.CFrame + Root.CFrame.LookVector * 1000
    end
end)
CreateButton("Телепорт к курсору", "🖱️", function()
    local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if Root then
        local target = Mouse.Hit.Position
        Root.CFrame = CFrame.new(target + Vector3.new(0, 3, 0), target)
    end
end)

-- 2. NoClip
local NoclipBtn = CreateButton("NoClip: ВЫКЛ", "🧱", function()
    NoclipActive = not NoclipActive
    if NoclipActive then
        NoclipBtn.Text = "NoClip: ВКЛ 🟢"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        NoclipBtn.Text = "NoClip: ВЫКЛ 🔴"
        NoclipBtn.BackgroundColor3 = (CurrentTheme == "Dark" and Color3.fromRGB(35, 35, 45)) or Color3.fromRGB(230, 230, 240)
    end
end)

-- 3. Gravity
CreateButton("Гравитация: 196.2", "🌍", function()
    local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if Humanoid then
        local current = Humanoid.JumpHeight * workspace.Gravity
        local newVal = 0
        if current == 196.2 then newVal = 98.1
        elseif current == 98.1 then newVal = 19.62
        else newVal = 196.2 end
        
        workspace.Gravity = newVal
        Humanoid.JumpHeight = 3.5 -- Стандартная высота
    end
end)

-- 4. Auto Farm
CreateButton("Auto-Farm: ВЫКЛ", "⚔️", function()
    FarmActive = not FarmActive
    if FarmActive then
        FarmActive = true
        spawn(function()
            while FarmActive do
                wait(0.1)
                local Target = nil
                local ShortestDist = math.huge
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                        local Magnitude = (LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                        if Magnitude < 50 and Magnitude < ShortestDist and v ~= LocalPlayer.Character then
                            ShortestDist = Magnitude
                            Target = v
                        end
                    end
                end
                if Target then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = Target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    wait(0.1)
                    LocalPlayer.Character.Humanoid:MoveTo(Target.HumanoidRootPart.Position)
                    -- Здесь должна быть функция удара (зависит от игры)
                    -- game:GetService("ReplicatedStorage").Remotes.Attack:FireServer(Target)
                end
            end
        end)
    else
        FarmActive = false
    end
end)

-- 5. Theme Switcher (вместо Reset)
CreateButton("Сменить тему", "🎨", function()
    if CurrentTheme == "Dark" then
        CurrentTheme = "Light"
        -- Меняем цвета
        Main.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
        MainShadow.Color = Color3.fromRGB(0, 100, 255)
        Title.TextColor3 = Color3.fromRGB(30, 30, 40)
        for _, v in pairs(ScrollingContainer:GetChildren()) do
            if v:IsA("TextButton") then
                v.BackgroundColor3 = Color3.fromRGB(230, 230, 240)
                v.TextColor3 = Color3.fromRGB(40, 40, 50)
            end
        end
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 220, 0)
        ToggleBtn.Text = "🌙"
    else
        CurrentTheme = "Dark"
        -- Возвращаем темные
        Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        MainShadow.Color = Color3.fromRGB(100, 0, 255)
        Title.TextColor3 = Color3.fromRGB(200, 200, 255)
        for _, v in pairs(ScrollingContainer:GetChildren()) do
            if v:IsA("TextButton") then
                v.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                v.TextColor3 = Color3.fromRGB(220, 220, 255)
            end
        end
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        ToggleBtn.Text = "☀️"
    end
end)

-- ЛОГИКА СТАРЫХ КНОПОК (Скорость, Прыжок, Аим, ESP) остается прежней, добавь их CreateButton(...) здесь

-- Noclip Loop
RunService.Stepped:Connect(function()
    if NoclipActive and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Логика открытия
ToggleBtn.MouseButton1Click:Connect(function()
    if Main.Visible then
        TweenService:Create(Main, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        wait(0.2)
        Main.Visible = false
    else
        Main.Visible = true
        Main.BackgroundTransparency = 1
        TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    end
end)

-- АНИМАЦИЯ ЗАПУСКА
wait(1)
ScreenGui.Enabled = true
TweenService:Create(ToggleBtn, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 15, 0.2, 0)}):Play()
wait(0.3)
TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0.3, 0, 0.2, 0)}):Play()
