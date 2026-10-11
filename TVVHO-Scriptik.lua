-- Сброс старых данных
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("AetherGlobal") then
        game:GetService("CoreGui")["AetherGlobal"]:Destroy()
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

-- Состояния (Твои читы)
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
    ["NoClip"] = false
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

-- ==========================================
-- МЕНЮ (Взято из твоего кода нейросети)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AetherGlobal"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Кнопка открытия
local ToggleBtn = Instance.new("TextButton")
local ToggleCorner = Instance.new("UICorner")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.Position = UDim2.new(0, 15, 0.15, 0)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleBtn.Text = "M"
ToggleBtn.TextColor3 = Color3.fromRGB(140, 85, 255)
ToggleBtn.TextSize = 22
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
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.ClipsDescendants = true
Main.Active = true
Main.Draggable = true
Main.Visible = false -- Скрыто по умолчанию

MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)

Title.Name = "Title"
Title.Parent = TopBar
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(1, -12, 1, 0)
Title.Text = "Aether Global"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
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

-- Функции создания элементов
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
    Page.ScrollBarImageColor3 = Color3.fromRGB(140, 85, 255)
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
        TabBtn.BackgroundColor3 = Color3.fromRGB(140, 85, 255)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    pages[tabName] = Page
    return Page
end

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
    Indicator.BackgroundColor3 = state and Color3.fromRGB(140, 85, 255) or Color3.fromRGB(45, 45, 60)
    IndicatorCorner.CornerRadius = UDim.new(0, 5)
    IndicatorCorner.Parent = Indicator
    Toggle.MouseButton1Click:Connect(function()
        state = not state
        Indicator.BackgroundColor3 = state and Color3.fromRGB(140, 85, 255) or Color3.fromRGB(45, 45, 60)
        pcall(callback, state)
    end)
end

-- ==========================================
-- СОЗДАНИЕ ВКЛАДОК И КНОПОК (ТВОИ ЧИТЫ)
-- ==========================================
local CombatPage = CreateTab("Combat")
local WorldPage = CreateTab("World")
local SettingsPage = CreateTab("Settings")

-- Открываем первую вкладку
CombatPage.Visible = true
TabContainer:FindFirstChild("CombatTab").BackgroundColor3 = Color3.fromRGB(140, 85, 255)
TabContainer:FindFirstChild("CombatTab").TextColor3 = Color3.fromRGB(255, 255, 255)

-- КНОПКА ОТКРЫТИЯ МЕНЮ
ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- 1. ВКЛАДКА COMBAT
AddToggle(CombatPage, "Silent Aim", Flags.SilentAim, function(val) Flags.SilentAim = val end)
AddToggle(CombatPage, "ESP", Flags.ESP, function(val) Flags.ESP = val end)
AddToggle(CombatPage, "ESP Tracers", Flags.ESP_Tracers, function(val) Flags.ESP_Tracers = val end)
AddToggle(CombatPage, "Hitbox", Flags.Hitbox, function(val) Flags.Hitbox = val end)
AddToggle(CombatPage, "TriggerBot", Flags.TriggerBot, function(val) Flags.TriggerBot = val end)
AddToggle(CombatPage, "NoClip", Flags.NoClip, function(val) Flags.NoClip = val end)

AddButton(CombatPage, "Aim Part (Head/Body)", function()
    Flags.AimPart = (Flags.AimPart == "Head" and "Body") or "Head"
end)

-- 2. ВКЛАДКА WORLD
AddToggle(WorldPage, "Speed", Flags.Speed, function(val) Flags.Speed = val end)
AddToggle(WorldPage, "Jump", Flags.Jump, function(val) Flags.Jump = val end)
AddToggle(WorldPage, "Gravity", Flags.Gravity, function(val) Flags.Gravity = val end)
AddToggle(WorldPage, "FOV Circle", Flags.FOV_Circle, function(val) Flags.FOV_Circle = val; if FOV_Circle then FOV_Circle.Visible = val end end)

-- 3. ВКЛАДКА SETTINGS
AddButton(SettingsPage, "Unload UI", function() ScreenGui:Destroy() end)

-- ==========================================
-- ЛОГИКА ЧИТОВ (Циклы)
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
end

-- NoClip
if Flags.NoClip then
    RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end

-- Hitbox (Создание)
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
end

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
end

-- FOV Circle
if FOV_Circle and Flags.FOV_Circle then
    RunService:BindToRenderStep("UpdateFOV", Enum.RenderPriority.Camera.Value - 1, function()
        FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end)
end
