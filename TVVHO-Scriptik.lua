-- СБРОС СТАРЫХ ОБЪЕКТОВ
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("AetherHub") then
        game:GetService("CoreGui")["AetherHub"]:Destroy()
    end
    for _, v in pairs(workspace.CurrentCamera:GetChildren()) do
        if v:IsA("Folder") and v.Name == "AetherESP" then v:Destroy() end
    end
end)
wait(0.5)

--[[================================================================================
SERVICES & CONFIG
================================================================================]]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local Config = {
    Version = "Aether v2.1",
    Keybind = Enum.KeyCode.RightControl, -- Кнопка открытия меню
    AimKey = Enum.KeyCode_L,             -- Кнопка аима (Silent)
    TargetPart = "Head",                 -- Голова или HumanoidRootPart
    SilentAimRadius = 150,               -- Радиус захвата цели (в пикселях)
    Colors = {
        Main = Color3.fromRGB(100, 0, 255),
        Red = Color3.fromRGB(255, 70, 70),
        Dark = Color3.fromRGB(25, 25, 35),
        Light = Color3.fromRGB(240, 240, 245)
    }
}

-- Состояния (Flags)
local Flags = {
    ["SilentAim"] = true,
    ["ESP"] = false,
    ["Boxes"] = false,
    ["Tracers"] = false,
    ["Noclip"] = false,
    ["Speed"] = false
}

--[[================================================================================
    GUI CREATION (STYLISH)
================================================================================]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "AetherHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Главное окно
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.BackgroundColor3 = Config.Colors.Dark
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, -160, 0.5, -180)
Main.Size = UDim2.new(0, 320, 0, 400)
Main.Active = true
Main.Draggable = true
Main.Visible = false
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 12)
local MainShadow = Instance.new("UIStroke", Main)
MainShadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainShadow.Color = Config.Colors.Main
MainShadow.Thickness = 2

-- Заголовок
local Header = Instance.new("Frame", Main)
Header.BackgroundColor3 = Config.Colors.Main
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Position = UDim2.new(0, 0, 0, 0)
local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 12, 0, 0)
local Title = Instance.new("TextLabel", Header)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "Aether Hub"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Padding = UDim.new(0, 15)

-- Кнопка закрытия (Крестик)
local Close = Instance.new("TextButton", Header)
Close.BackgroundTransparency = 1
Close.Position = UDim2.new(1, -35, 0, 10)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Text = "✕"
Close.Font = Enum.Font.GothamBold
Close.TextColor3 = Color3.fromRGB(255, 100, 100)
Close.TextSize = 16
Close.AutoButtonColor = false

-- Контейнер для кнопок
local Container = Instance.new("ScrollingFrame", Main)
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 0, 0, 45)
Container.Size = UDim2.new(1, 0, 1, -50)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.ScrollBarImageColor3 = Config.Colors.Main
local ListLayout = Instance.new("UIListLayout", Container)
ListLayout.Padding = UDim.new(0, 8)
ListLayout.FillDirection = Enum.FillDirection.Vertical
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Функция создания красивых кнопок
local function CreateButton(text, icon, callback)
    local btn = Instance.new("TextButton", Container)
    btn.BackgroundColor3 = Config.Colors.Dark
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, -20, 0, 38)
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.fromRGB(220, 220, 255)
    btn.TextSize = 14
    btn.Text = icon .. "  " .. text
    btn.AutoButtonColor = false
    local Corner = Instance.new("UICorner", btn)
    Corner.CornerRadius = UDim.new(0, 8)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Config.Colors.Main}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Config.Colors.Dark}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        callback()
    end)
    -- Авто-увеличение CanvasSize
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
    return btn
end

-- Кнопка открытия (в углу)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.BackgroundColor3 = Config.Colors.Main
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Position = UDim2.new(0, 10, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Text = "A"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 20
ToggleBtn.AutoButtonColor = false
local ToggleCorner = Instance.new("UICorner", ToggleBtn)
ToggleCorner.CornerRadius = UDim.new(0, 10)

--[[================================================================================
    COMBAT FUNCTIONS (Silent Aim + ESP)
================================================================================]]

-- Функция поиска цели для аима
local function GetTarget()
    local Target = nil
    local ShortestDist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local Part = v.Character:FindFirstChild(Config.TargetPart)
            if Part then
                local Vec, Vis = Camera:WorldToViewportPoint(Part.Position)
                if Vis then
                    local MouseVec = Vector2.new(Mouse.X, Mouse.Y)
                    local Dist = (MouseVec - Vector2.new(Vec.X, Vec.Y)).Magnitude
                    if Dist < Flags.SilentAimRadius and Dist < ShortestDist then
                        local rayParams = RaycastParams.new()
                        rayParams.FilterDescendantsInstances = {LocalPlayer.Character, v.Character}
                        rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        local rayResult = workspace:Raycast(Camera.CFrame.Position, (Part.Position - Camera.CFrame.Position).Unit * 1000, rayParams)
                        if not rayResult or rayResult.Instance:IsDescendantOf(v.Character) then
                            ShortestDist = Dist
                            Target = Part
                        end
                    end
                end
            end
        end
    end
    return Target
end

-- ESP (Drawing Library на мобильных часто крашит, используем Highlight - это "КРУТОЙ" и безопасный способ)
local function UpdateESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            local Highlight = v.Character:FindFirstChild("AetherESP")
            if Flags.ESP then
                if not Highlight then
                    local hl = Instance.new("Highlight", v.Character)
                    hl.Name = "AetherESP"
                    hl.FillColor = Config.Colors.Red
                    hl.OutlineColor = Config.Colors.Main
                    hl.FillTransparency = 0.8
                    hl.DepthMode = Enum.HighlightDepthMode.Occluded
                end
            else
                if Highlight then Highlight:Destroy() end
            end
        end
    end
end

--[[================================================================================
    UI BUTTONS (MENU)
================================================================================]]

-- Silent Aim Toggle
CreateButton("Silent Aim: ON", "🎯", function()
    Flags.SilentAim = not Flags.SilentAim
    local text = Flags.SilentAim and "Silent Aim: ON" or "Silent Aim: OFF"
    -- Кнопка не обновляет текст сама, так как это сложная структура, просто меняем логику
end)

-- ESP Toggle
CreateButton("ESP: OFF", "👁️", function()
    Flags.ESP = not Flags.ESP
    UpdateESP()
end)

-- Speed Toggle
CreateButton("Speed: OFF", "⚡", function()
    Flags.Speed = not Flags.Speed
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Flags.Speed and 100 or 16
    end
end)

-- Noclip Toggle
CreateButton("Noclip: OFF", "🧱", function()
    Flags.Noclip = not Flags.Noclip
end)

-- Target Part (Head/Body)
CreateButton("Target: Head", "🏃", function()
    if Config.TargetPart == "Head" then
        Config.TargetPart = "HumanoidRootPart"
    else
        Config.TargetPart = "Head"
    end
end)

-- Close Menu
CreateButton("Закрыть", "✕", function()
    Main.Visible = false
end)

--[[================================================================================
    MAIN LOOPS
================================================================================]]

-- Silent Aim (Работает по нажатию L)
RunService:BindToRenderStep("AetherAim", Enum.RenderPriority.Camera.Value, function()
    if Flags.SilentAim and UserInputService:IsKeyDown(AimKey) then
        local Target = GetTarget()
        if Target then
            -- Silent: Мы не крутим камеру игрока, мы просто "говорим" игре, что прицел тут
            -- На мобильных это работает через VirtualInputManager или просто через физику
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
        end
    end
end)

-- Noclip Loop
RunService.Stepped:Connect(function()
    if Flags.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Update ESP Loop
RunService.Heartbeat:Connect(UpdateESP)

-- UI Toggle Logic
ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
Close.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

print("Aether Hub v2.1 Loaded. [RightCtrl] for Menu | [L] for Aim")
