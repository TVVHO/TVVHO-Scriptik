-- Сброс
pcall(function() if game:GetService("CoreGui"):FindFirstChild("TVVHO_Dynasty") then game:GetService("CoreGui")["TVVHO_Dynasty"]:Destroy() end end)
wait(0.5)

-- Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Флаги
local Flags = {
    SilentAim = true, AimPart = "Head", 
    ESP = false, ESP_Tracers = false, 
    Hitbox = false, 
    TriggerBot = false, 
    Speed = false, Jump = false, Gravity = false, NoClip = false
}

-- Настройки
local Aim_Settings = {Radius = 150}

-- Библиотека рисования
local DrawingLib
pcall(function() DrawingLib = loadstring(game:HttpGet("https://kiriot22.com/releases/drawing-lib.lua"))() end)

-- FOV Circle
local FOV_Circle
if DrawingLib then
    FOV_Circle = DrawingLib:Create('Circle', {
        Visible = Flags["SilentAim"], 
        Color = Color3.fromRGB(255, 215, 0), 
        Transparency = 0.4, 
        Thickness = 4, 
        NumSides = 100, 
        Radius = Aim_Settings.Radius, 
        Filled = false, 
        Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    })
end

-- ==========================================
-- МЕНЮ (Dynasty Style)
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
ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
ToggleBtn.Text = "天"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
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
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
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
Title.Text = "天王 TVVHO"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
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
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 13
    Btn.AutoButtonColor = false
    Btn.MouseButton1Click:Connect(callback)
    PagesFolder.CanvasSize = UDim2.new(0, 0, 0, (#page:GetChildren() - 1) * 35 + 10)
end

-- Открытие меню
ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- ВКЛАДКА: 战斗 (COMBAT)
local CombatPage = Instance.new("ScrollingFrame")
CombatPage.Parent = PagesFolder
CombatPage.Size = UDim2.new(1, 0, 1, 0)
CombatPage.BackgroundTransparency = 1
CombatPage.AutomaticCanvasSize = Enum.AutomaticSize.Y

AddButton(CombatPage, "锁定 (Aim)", function() Flags.SilentAim = not Flags.SilentAim; if FOV_Circle then FOV_Circle.Visible = Flags.SilentAim end end)
AddButton(CombatPage, "透视 (ESP)", function() Flags.ESP = not Flags.ESP end)
AddButton(CombatPage, "红圈 (Hitbox)", function() Flags.Hitbox = not Flags.Hitbox end)
AddButton(CombatPage, "开枪 (Trigger)", function() Flags.TriggerBot = not Flags.TriggerBot end)

-- НОВАЯ КНОПКА: ТЕЛЕПОРТ
AddButton(CombatPage, "Телепорт (Кликни)", function()
    local Mouse = LocalPlayer:GetMouse()
    Mouse.Button1Down:Connect(function()
        local TargetPos = Mouse.Hit.p
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(TargetPos + Vector3.new(0, 5, 0)))
        end
    end)
end)

AddButton(CombatPage, "Speed", function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = 50 end end)
AddButton(CombatPage, "Jump", function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = 50 end end)
AddButton(CombatPage, "Gravity", function() Flags.Gravity = not Flags.Gravity; workspace.Gravity = Flags.Gravity and 100 or 196.2 end)
AddButton(CombatPage, "NoClip", function() Flags.NoClip = not Flags.NoClip end)

-- ВКЛАДКА: 世界 (WORLD)
local WorldPage = Instance.new("ScrollingFrame")
WorldPage.Parent = PagesFolder
WorldPage.Size = UDim2.new(1, 0, 1, 0)
WorldPage.BackgroundTransparency = 1
WorldPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
WorldPage.Visible = false

-- ВКЛАДКА: 设定 (SETTINGS)
local SettingsPage = Instance.new("ScrollingFrame")
SettingsPage.Parent = PagesFolder
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
SettingsPage.Visible = false

-- Переключение вкладок
local function CreateTabBtn(name, page)
    local Btn = Instance.new("TextButton")
    Btn.Parent = TabContainer
    Btn.Size = UDim2.new(0.33, 0, 1, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Btn.Text = name
    Btn.Font = Enum.Font.Gotham
    Btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    Btn.TextSize = 12
    Btn.AutoButtonColor = false
    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesFolder:GetChildren()) do p.Visible = false end
        page.Visible = true
    end)
    return Btn
end

local CombatTab = CreateTabBtn("战斗", CombatPage)
local WorldTab = CreateTabBtn("世界", WorldPage)
local SettingsTab = CreateTabBtn("设定", SettingsPage)
CombatTab.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

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

print("天王 TVVHO Dynasty Loaded. [Кнопка '天' в углу]")
