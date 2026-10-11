
-- Сброс старых данных
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("TVVHO_Imperial") then
        game:GetService("CoreGui")["TVVHO_Imperial"]:Destroy()
    end
end)
wait(0.5)

-- Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Состояния (Флаги)
local Flags = {
    ["SilentAim"] = true,
    ["AimPart"] = "Head",
    ["ESP"] = false,
    ["ESP_Tracers"] = false,
    ["Hitbox"] = false,
    ["FOV_Circle"] = true,
    ["TriggerBot"] = false,
    ["Speed"] = false,
    ["Jump"] = false,
    ["Gravity"] = false,
    ["NoClip"] = false,
    ["WallbangAim"] = false -- Новый флаг для стрельбы сквозь стены
}

-- Настройки
local Aim_Settings = {Radius = 150}

-- Библиотека рисования
local DrawingLib
pcall(function() DrawingLib = loadstring(game:HttpGet("https://kiriot22.com/releases/drawing-lib.lua"))() end)

-- FOV Circle (Круг для аима)
local FOV_Circle
if DrawingLib then
    FOV_Circle = DrawingLib:Create('Circle', {
        Visible = Flags["FOV_Circle"], 
        Color = Color3.fromRGB(255, 215, 0), -- Золото
        Transparency = 0.4, 
        Thickness = 4, -- Сделали толще
        NumSides = 100, 
        Radius = Aim_Settings.Radius, 
        Filled = false, 
        Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    })
end

-- ==========================================
-- 1. МЕНЮ TVVHO IMPERIAL (Китайский стиль)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TVVHO_Imperial"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Кнопка вызова
local ToggleBtn = Instance.new("TextButton")
local ToggleCorner = Instance.new("UICorner")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.Position = UDim2.new(0, 15, 0.15, 0)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0) -- Глубокий красный
ToggleBtn.Text = "天" -- Иероглиф "Небо/Сила"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextColor3 = Color3.fromRGB(255, 215, 0) -- Золотой
ToggleBtn.TextSize = 26
ToggleCorner.CornerRadius = UDim.new(0, 12)
ToggleCorner.Parent = ToggleBtn

-- Главное окно
local Main = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local TabContainer = Instance.new("Frame")
local TabListLayout = Instance.new("UIListLayout")
local PagesFolder = Instance.new("Frame")

Main.Name = "Main"
Main.Parent = ScreenGui
Main.Position = UDim2.new(0.5, -175, 0.5, -125)
Main.Size = UDim2.new(0, 350, 0, 250)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15) -- Почти черный, глубокий
Main.ClipsDescendants = true
Main.Active = true
Main.Draggable = true
Main.Visible = false

MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)

Title.Name = "Title"
Title.Parent = TopBar
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(1, -12, 1, 0)
Title.Text = "天王 TVVHO" -- "Небесный Король TVVHO"
Title.TextColor3 = Color3.fromRGB(255, 215, 0) -- Золото
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

TabContainer.Name = "TabContainer"
TabContainer.Parent = Main
TabContainer.Position = UDim2.new(0, 8, 0, 40)
TabContainer.Size = UDim2.new(1, -16, 0, 30)
TabContainer.BackgroundTransparency = 1
TabListLayout.Parent = TabContainer
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 6)

PagesFolder.Name = "PagesFolder"
PagesFolder.Parent = Main
PagesFolder.Position = UDim2.new(0, 8, 0, 75)
PagesFolder.Size = UDim2.new(1, -16, 1, -83)
PagesFolder.BackgroundTransparency = 1

-- Функция создания вкладок
local pages = {}
local function CreateTab(tabName)
    local TabBtn = Instance.new("TextButton")
    local TabBtnCorner = Instance.new("UICorner")
    TabBtn.Name = tabName .. "Tab"
    TabBtn.Parent = TabContainer
    TabBtn.Size = UDim2.new(0, 100, 1, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TabBtn.Text = tabName
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.TextSize = 13
    TabBtnCorner.CornerRadius = UDim.new(0, 8)
    TabBtnCorner.Parent = TabBtn

    local Page = Instance.new("ScrollingFrame")
    local PageListLayout = Instance.new("UIListLayout")
    local PagePadding = Instance.new("UIPadding")
    Page.Name = tabName .. "Page"
    Page.Parent = PagesFolder
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0) -- Золотой скролл
    PageListLayout.Parent = Page
    PageListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageListLayout.Padding = UDim.new(0, 6)
    PagePadding.Parent = Page
    PagePadding.PaddingTop = UDim.new(0, 2)
    PagePadding.PaddingBottom = UDim.new(0, 2)

    PageListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageListLayout.AbsoluteContentSize.Y + 10)
    end)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesFolder:GetChildren()) do p.Visible = false end
        for _, t in pairs(TabContainer:GetChildren()) do
            if t:IsA("TextButton") then
                t.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                t.TextColor3 = Color3.fromRGB(180, 180, 200)
            end
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0) -- Красный активный
        TabBtn.TextColor3 = Color3.fromRGB(255, 215, 0) -- Золотой текст
    end)

    pages[tabName] = Page
    return Page
end

-- Функция создания кнопок
local function AddButton(page, text, callback)
    local Btn = Instance.new("TextButton")
    local BtnCorner = Instance.new("UICorner")
    Btn.Name = text
    Btn.Parent = page
    Btn.Size = UDim2.new(1, -4, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn
    Btn.MouseButton1Click:Connect(function() pcall(callback) end)
end

local function AddToggle(page, text, defaultState, callback)
    local state = defaultState or false
    local Toggle = Instance.new("TextButton")
    local ToggleCorner = Instance.new("UICorner")
    local Indicator = Instance.new("Frame")
    local IndicatorCorner = Instance.new("UICorner")
    Toggle.Name = text
    Toggle.Parent = page
    Toggle.Size = UDim2.new(1, -4, 0, 35)
    Toggle.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Toggle.Text = "   " .. text
    Toggle.TextColor3 = Color3.fromRGB(240, 240, 240)
    Toggle.Font = Enum.Font.Gotham
    Toggle.TextSize = 13
    Toggle.TextXAlignment = Enum.TextXAlignment.Left
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle
    Indicator.Name = "Indicator"
    Indicator.Parent = Toggle
    Indicator.Position = UDim2.new(1, -30, 0.5, -9)
    Indicator.Size = UDim2.new(0, 18, 0, 18)
    Indicator.BackgroundColor3 = state and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(45, 45, 60)
    IndicatorCorner.CornerRadius = UDim.new(0, 5)
    IndicatorCorner.Parent = Indicator
    Toggle.MouseButton1Click:Connect(function()
        state = not state
        Indicator.BackgroundColor3 = state and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(45, 45, 60)
        pcall(callback, state)
    end)
end

-- ==========================================
-- 2. ИНИЦИАЛИЗАЦИЯ ВКЛАДОК (Китайские названия)
-- ==========================================
local CombatPage = CreateTab("战斗") -- Битва
local WorldPage = CreateTab("世界")   -- Мир
local SettingsPage = CreateTab("设定") -- Настройки

CombatPage.Visible = true
TabContainer:FindFirstChild("战斗Tab").BackgroundColor3 = Color3.fromRGB(180, 0, 0)
TabContainer:FindFirstChild("战斗Tab").TextColor3 = Color3.fromRGB(255, 215, 0)

-- Открытие меню
ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- ==========================================
-- 3. СОДЕРЖИМОЕ ВКЛАДОК (Функции)
-- ==========================================

-- ВКЛАДКА: 战斗 (COMBAT)
AddToggle(CombatPage, "锁定 (Aim)", Flags.SilentAim, function(val) Flags.SilentAim = val end)
AddToggle(CombatPage, "透视 (ESP)", Flags.ESP, function(val) Flags.ESP = val end)
AddToggle(CombatPage, "线条 (Tracers)", Flags.ESP_Tracers, function(val) Flags.ESP_Tracers = val end)
AddToggle(CombatPage, "红圈 (Hitbox)", Flags.Hitbox, function(val) Flags.Hitbox = val end)
AddToggle(CombatPage, "开枪 (Trigger)", Flags.TriggerBot, function(val) Flags.TriggerBot = val end)
AddToggle(CombatPage, "穿墙 (NoClip)", Flags.NoClip, function(val) Flags.NoClip = val end)
AddButton(CombatPage, "切换部位", function() Flags.AimPart = (Flags.AimPart == "Head" and "Body") or "Head" end)

-- НОВЫЕ ФУНКЦИИ:
-- Телепорт по клику
AddButton(CombatPage, "Телепорт (Кликни)", function()
    local Mouse = LocalPlayer:GetMouse()
    Mouse.Button1Down:Connect(function()
        local TargetPos = Mouse.Hit.p
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(TargetPos + Vector3.new(0, 5, 0)))
        end
    end)
end)

-- Wallbang Aim (Наведение сквозь стену)
AddToggle(CombatPage, "Wallbang Aim", false, function(val)
    Flags.WallbangAim = val
    if val then
        spawn(function()
            while Flags.WallbangAim do
                local Target = nil
                local ShortestDist = math.huge
                local Camera = workspace.CurrentCamera
                
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                        local Part = v.Character.Head
                        local Vec, Vis = Camera:WorldToViewportPoint(Part.Position)
                        if Vis then
                            local Params = RaycastParams.new()
                            Params.FilterDescendantsInstances = {LocalPlayer.Character, workspace.Players}
                            Params.FilterType = Enum.RaycastFilterType.Exclude
                            Params.IgnoreWater = true
                            
                            local RayDir = (Part.Position - Camera.CFrame.Position).Unit * 1000
                            local Result = workspace:Raycast(Camera.CFrame.Position, RayDir, Params)
                            
                            if not Result or Result.Instance:IsDescendantOf(v.Character) then
                                local MouseVec = Vector2.new(Mouse.X, Mouse.Y)
                                local Dist = (MouseVec - Vector2.new(Vec.X, Vec.Y)).Magnitude
                                if Dist < 500 and Dist < ShortestDist then
                                    ShortestDist = Dist
                                    Target = v
                                end
                            end
                        end
                    end
                end
                
                if Target and Target.Character:FindFirstChild("Head") then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position)
                end
                wait()
            end
        end)
    end
end)

-- ВКЛАДКА: 世界 (WORLD)
AddToggle(WorldPage, "加速", Flags.Speed, function(val) Flags.Speed = val end)
AddToggle(WorldPage, "跳跃", Flags.Jump, function(val) Flags.Jump = val end)
AddToggle(WorldPage, "重力", Flags.Gravity, function(val) Flags.Gravity = val end)
AddToggle(WorldPage, "FOV 圈", Flags.FOV_Circle, function(val) Flags.FOV_Circle = val; if FOV_Circle then FOV_Circle.Visible = val end end)

-- ВКЛАДКА: 设定 (SETTINGS)
AddButton(SettingsPage, "卸载 (Unload)", function() ScreenGui:Destroy() end)

-- ==========================================
-- 4. ЛОГИКА ЧИТОВ (Циклы)
-- ==========================================

-- Silent Aim
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
                                Target = v
                            end
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
if Flags.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = 100 end
if Flags.Jump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = 100 end
if Flags.Gravity then workspace.Gravity = 100 else workspace.Gravity = 196.2 end

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

-- ESP Tracers
if Flags.ESP_Tracers and DrawingLib then
    local Tracers = {}
    RunService.Heartbeat:Connect(function()
        for _, line in pairs(Tracers) do if line then line:Destroy() end end
        table.clear(Tracers)
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local line = DrawingLib:Create('Line', {
                    From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2),
                    To = Vector2.new(Mouse.X, Mouse.Y),
                    Color = Color3.fromRGB(255, 0, 0),
                    Thickness = 1,
                    Transparency = 0.7
                })
                table.insert(Tracers, line)
            end
        end
    end)
end)

-- FOV Circle
if FOV_Circle and Flags.FOV_Circle then
    RunService:BindToRenderStep("UpdateFOV", Enum.RenderPriority.Camera.Value - 1, function()
        FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end)
end)

print("天王 TVVHO Imperial Loaded. [Кнопка '天' в углу]")
