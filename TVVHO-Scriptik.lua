-- Сброс старых данных
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("TVVHO_Dynasty") then
        game:GetService("CoreGui")["TVVHO_Dynasty"].Destroy()
    end
end)
wait(0.5)

-- Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local DrawingLib = loadstring(game:HttpGet("https://kiriot22.com/releases/drawing-lib.lua"))() -- Для круга
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Настройки
local Flags = {
    ["SilentAim"] = true,
    ["ESP"] = false,
    ["Hitbox"] = false,
    ["TriggerBot"] = false,
    ["FOV_Circle"] = true,
}

-- Радиус захвата цели (чем меньше, тем точнее; стандартно ~150 пикселей)
local Aim_Settings = {Radius = 150} 

-- Библиотека рисования (только для круга)
local FOV_Circle
if DrawingLib then
    FOV_Circle = DrawingLib:Create('Circle', {
        Visible = Flags.FOV_Circle, -- Теперь зависит ТОЛЬКО от флага
        Color = Color3.fromRGB(255, 215, 0),
        Transparency = 0.6,
        Thickness = 4,
        NumSides = 100,
        Radius = Aim_Settings.Radius,
        Filled = false,
        Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    })
end

-- ==========================================
-- МЕНЮ TVVHO DYNASTY (Китайский стиль)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TVVHO_Dynasty"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Кнопка открытия
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
Main.BorderSizePixel = 0
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
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Title.Text = "天王 TVVHO" -- "Небесный Король TVVHO"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 215, 0) -- Золото
Title.TextSize = 18
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
PagesFolder.Position = UDim2.new(0, 0, 0, 75)
PagesFolder.Size = UDim2.new(1, -16, 1, -83)
PagesFolder.BackgroundTransparency = 1
PagesFolder.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Функция создания кнопок
local function AddButton(page, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = page
    Btn.Size = UDim2.new(1, -10, 0, 30)
    Btn.Position = UDim2.new(0, 5, 0, (#page:GetChildren() - 1) * 35)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Btn.Text = text
    Btn.Font = Enum.Font.Gotham
    Btn.TextColor3 = Color3.Color3.new(1, 1, 1)
    Btn.TextSize = 13
    Btn.AutoButtonColor = false
    Btn.MouseButton1Click:Connect(callback)
end

-- Переключение вкладок
local pages = {}
local function CreateTab(tabName)
    local TabBtn = Instance.new("TextButton")
    local TabBtnCorner = Instance.new("UICorner")
    TabBtn.Name = tabName .. "Tab"
    TabBtn.Parent = TabContainer
    TabBtn.Size = UDim2.new(0, 100, 1, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TabBtn.Text = tabName
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
    TabBtn.TextSize = 13
    TabBtnCorner.CornerRadius = UDim.new(0, 8)
    TabBtnCorner.Parent = TabBtn

    local Page = Instance.new("ScrollingFrame")
    Page.Name = tabName .. "Page"
    Page.Parent = PagesFolder
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

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

-- ==========================================
-- СОДЕРЖИМОЕ ВКЛАДОК
-- ==========================================

-- ВКЛАДКА: COMBAT
local CombatPage = Instance.new("ScrollingFrame")
CombatPage.Parent = PagesFolder
CombatPage.Size = UDim2.new(1, 0, 1, 0)
CombatPage.BackgroundTransparency = 1
CombatPage.AutomaticCanvasSize = Enum.AutomaticSize.Y

AddButton(CombatPage, "Silent Aim", function() Flags.SilentAim = not Flags.SilentAim end)
AddButton(CombatPage, "Aim Part (Head/Body)", function() Flags.AimPart = (Flags.AimPart == "Head" and "HumanoidRootPart") or "Head" end)
AddButton(CombatPage, "ESP", function() Flags.ESP = not Flags.ESP end)
AddButton(CombatPage, "Hitbox", function() Flags.Hitbox = not Flags.Hitbox end)
AddButton(CombatPage, "TriggerBot", function() Flags.TriggerBot = not Flags.TriggerBot end)

-- НОВАЯ КНОПКА: Удаляет все хитбоксы сразу
AddButton(CombatPage, "Reset Hitboxes", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "TVVHO_HITBOX" then v:Destroy() end
    end
end)

-- ВКЛАДКА: SETTINGS
local SettingsPage = Instance.new("ScrollingFrame")
SettingsPage.Parent = PagesFolder
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
SettingsPage.Visible = false

AddButton(SettingsPage, "Unload UI", function() ScreenGui:Destroy() end)

-- Открываем первую вкладку
local CombatTab = CreateTab("战斗") -- Битва
local SettingsTab = CreateTab("设定") -- Настройки
CombatTab.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
CombatPage.Visible = true

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- ЛОГИКА ЧИТОВ

-- Silent Aim (Улучшенный)
RunService.Heartbeat:Connect(function()
    if Flags.SilentAim then
        local Target, ShortestDist = nil, math.huge
        
        -- Проверяем ВСЕХ игроков (включая тех, кто за стенами)
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local Part = plr.Character:FindFirstChild(Flags.AimPart) or plr.Character:FindFirstChild("Head")
                
                if Part then
                    local Vec, Vis = Camera:WorldToViewportPoint(Part.Position)
                    
                    -- Наводимся, даже если врага НЕ видно (Wallbang)
                    local MouseVec = Vector2.new(Mouse.X, Mouse.Y)
                    local Dist = (MouseVec - Vector2.new(Vec.X, Vec.Y)).Magnitude
                    if Dist < Aim_Settings.Radius and Dist < ShortestDist then
                        ShortestDist = Dist
                        Target = Part
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

-- Hitbox Expander
if Flags.Hitbox then
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hb = Instance.new("Part", plr.Character)
            hb.Name = "TVVHO_HITBOX"
            hb.Shape = Enum.PartType.Ball
            hb.Size = Vector3.new(8, 8, 8)
            hb.Color = Color3.fromRGB(255, 0, 0)
            hb.Transparency = 0.7
            hb.CanCollide = false
            hb.Massless = true
            hb.Anchored = false
            
            local weld = Instance.new("WeldConstraint", hb)
            weld.Part0 = hb
            weld.Part1 = plr.Character.HumanoidRootPart
        end
    end
end

-- ESP (Подсветка)
if Flags.ESP then
    RunService.Heartbeat:Connect(function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                if not plr.Character:FindFirstChild("TVVHO_ESP") then
                    local hl = Instance.new("Highlight", plr.Character)
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

-- FOV Circle
if FOV_Circle and Flags.FOV_Circle then
    RunService.BindToRenderStep("UpdateFOV", Enum.RenderPriority.Camera.Value - 1, function()
        FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end)
end
