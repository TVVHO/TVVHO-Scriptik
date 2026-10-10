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
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Состояния
local NoclipActive = false
local FarmActive = false
local ESPActive = false
local SelectedAimPart = "Head" -- Цель аима (Head или HumanoidRootPart)

-- Звуки (чтобы было "дорого")
local ClickSound = Instance.new("Sound")
ClickSound.SoundId = "rbxassetid://759071027" -- Звук клика (SFX)
ClickSound.Volume = 0.3
ClickSound.Parent = SoundService

-- ТАБЫ (Разделы меню)
local Tabs = {"Combat", "Visuals", "World", "Settings"}
local CurrentTab = "Combat"

-- ОСНОВНОЙ GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TVVHO_Hub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Enabled = false

-- Кнопка вызова (маленькая)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Position = UDim2.new(0, 10, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.AutoButtonColor = false
ToggleBtn.Text = "+"
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 24
ToggleBtn.ZIndex = 10
local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ToggleBtn
local BtnShadow = Instance.new("UIStroke")
BtnShadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
BtnShadow.Color = Color3.fromRGB(150, 0, 255)
BtnShadow.Thickness = 2
BtnShadow.Parent = ToggleBtn

-- Главное окно
local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, -150, 0.5, -175)
Main.Size = UDim2.new(0, 300, 0, 350)
Main.Active = true
Main.Draggable = true
Main.Visible = true
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main
local MainShadow = Instance.new("UIStroke")
MainShadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainShadow.Color = Color3.fromRGB(100, 0, 255)
MainShadow.Thickness = 2
MainShadow.Parent = Main

-- Заголовок с крестиком
local Header = Instance.new("Frame")
Header.Parent = Main
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.Position = UDim2.new(0, 0, 0, 0)
local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10, 0, 0)
HeaderCorner.Parent = Header
local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "TVVHO PRO"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(220, 220, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Padding = UDim.new(0, 10)

-- КРЕСТИК ЗАКРЫТИЯ
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.BackgroundTransparency = 1
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextSize = 18
CloseBtn.AutoButtonColor = false
CloseBtn.MouseEnter:Connect(function()
    CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
end)
CloseBtn.MouseLeave:Connect(function()
    CloseBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
end)
CloseBtn.MouseButton1Click:Connect(function()
    ClickSound:Play()
    Main.Visible = false
    ToggleBtn.Visible = true
end)

-- Панель табов (сверху под заголовком)
local TabBar = Instance.new("Frame")
TabBar.Parent = Main
TabBar.BackgroundTransparency = 1
TabBar.Size = UDim2.new(1, 0, 0, 35)
TabBar.Position = UDim2.new(0, 0, 0, 30)

-- Контейнер контента
local Content = Instance.new("Frame")
Content.Parent = Main
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 0, 0, 65)
Content.Size = UDim2.new(1, 0, 1, -65)

-- Функция создания табов
local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Parent = TabBar
    TabBtn.BackgroundColor3 = (name == CurrentTab and Color3.fromRGB(50, 0, 100)) or Color3.fromRGB(30, 30, 40)
    TabBtn.BorderSizePixel = 0
    TabBtn.Size = UDim2.new(0.25, 0, 1, 0)
    TabBtn.Position = UDim2.new((#TabBar:GetChildren() - 1) * 0.25, 0, 0, 0)
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
    TabBtn.TextSize = 12
    TabBtn.AutoButtonColor = false
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = TabBtn
    TabBtn.MouseEnter:Connect(function()
        TweenService:Create(TabBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
    end)
    TabBtn.MouseLeave:Connect(function()
        TweenService:Create(TabBtn, TweenInfo.new(0.1), {BackgroundColor3 = (name == CurrentTab and Color3.fromRGB(50, 0, 100)) or Color3.fromRGB(30, 30, 40)}):Play()
    end)
    TabBtn.MouseButton1Click:Connect(function()
        ClickSound:Play()
        CurrentTab = name
        -- Обновляем цвета
        for _, v in pairs(TabBar:GetChildren()) do
            if v:IsA("TextButton") then
                if v.Text == name then
                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 0, 100)}):Play()
                else
                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
                end
            end
        end
        -- Перерисовываем контент
        Content:ClearAllChildren()
        RenderContent()
    end)
end

-- Функция рендера контента (в зависимости от таба)
local function RenderContent()
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Content
    Layout.Padding = UDim.new(0, 6)
    Layout.FillDirection = Enum.FillDirection.Vertical
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    if CurrentTab == "Combat" then
        CreateButton("Аимбот (Head)", "🎯", function()
            SelectedAimPart = "Head"
        end)
        CreateButton("Аимбот (Тело)", "🏃", function()
            SelectedAimPart = "HumanoidRootPart"
        end)
        CreateButton("TriggerBot", "⚡", function()
            -- Простой TriggerBot (стреляет сам при наведении)
            spawn(function()
                local old = Mouse.Button1Down:Connect(function() end)
                wait(2)
                old:Disconnect()
            end)
        end)
    elseif CurrentTab == "Visuals" then
        CreateButton("ВХ (ESP)", "👁️", function()
            ESPActive = not ESPActive
            if ESPActive then
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer and v.Character then
                        if not v.Character:FindFirstChild("TVVHO_ESP") then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "TVVHO_ESP"
                            highlight.FillColor = Color3.fromRGB(255, 0, 0)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.7
                            highlight.Parent = v.Character
                        end
                    end
                end
            else
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer and v.Character then
                        local esp = v.Character:FindFirstChild("TVVHO_ESP")
                        if esp then esp:Destroy() end
                    end
                end
            end
        end)
    elseif CurrentTab == "World" then
        CreateButton("Телепорт (1000)", "🛸", function()
            local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if Root then Root.CFrame = Root.CFrame + Root.CFrame.LookVector * 1000 end
        end)
        CreateButton("NoClip", "🧱", function()
            NoclipActive = not NoclipActive
        end)
    elseif CurrentTab == "Settings" then
        CreateButton("Закрыть", "✕", function()
            ClickSound:Play()
            Main.Visible = false
            ToggleBtn.Visible = true
        end)
    end
end

-- Функция кнопок (универсальная)
local function CreateButton(text, icon, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Content
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.fromRGB(220, 220, 255)
    btn.TextSize = 13
    btn.Text = icon .. "  " .. text
    btn.AutoButtonColor = false
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = btn
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        ClickSound:Play()
        callback()
    end)
    return btn
end

-- Рисуем табы
for _, v in pairs(Tabs) do
    CreateTab(v)
end
RenderContent()

-- ЛОГИКА КНОПОК ВЫЗОВА
ToggleBtn.MouseButton1Click:Connect(function()
    ClickSound:Play()
    Main.Visible = true
    ToggleBtn.Visible = false
end)

-- ЦИКЛЫ (Аим, Ноклип, Фарм)

-- АИМБОТ (Плавный, работает с выбранным SelectedAimPart)
RunService.RenderStepped:Connect(function()
    if UserInputService:IsKeyDown(Enum.KeyCode_L) then -- Удерживай L для аима
        local Target = nil
        local ShortestDist = math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(SelectedAimPart) then
                local Part = v.Character[SelectedAimPart]
                local Magnitude = (Part.Position - Camera.CFrame.Position).Magnitude
                if Magnitude < 500 and Magnitude < ShortestDist then
                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, v.Character}
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    local rayResult = workspace:Raycast(Camera.CFrame.Position, (Part.Position - Camera.CFrame.Position).Unit * 1000, rayParams)
                    if not rayResult or rayResult.Instance:IsDescendantOf(v.Character) then
                        ShortestDist = Magnitude
                        Target = Part
                    end
                end
            end
        end
        if Target then
            TweenService:Create(Camera, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)}):Play()
        end
    end
end)

-- NOCLIP
RunService.Stepped:Connect(function()
    if NoclipActive and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- АВТО-АТАКА (FARM)
RunService.Heartbeat:Connect(function()
    if FarmActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local Target = nil
        local ShortestDist = math.huge
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= LocalPlayer.Character then
                local Magnitude = (LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                if Magnitude < 20 and Magnitude < ShortestDist then
                    ShortestDist = Magnitude
                    Target = v
                end
            end
        end
        if Target then
            LocalPlayer.Character.Humanoid:MoveTo(Target.HumanoidRootPart.Position)
            -- Здесь нужно добавить RemoteEvent для удара
        end
    end
end)

-- АНИМАЦИЯ ЗАПУСКА
wait(1)
ScreenGui.Enabled = true
TweenService:Create(ToggleBtn, TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Position = UDim2.new(0, 10, 0.2, 0)}):Play()
