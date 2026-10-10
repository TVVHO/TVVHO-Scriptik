-- СБРОС
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("TVVHO_Hub") then
        game:GetService("CoreGui")["TVVHO_Hub"]:Destroy()
    end
    for i, v in pairs(workspace.CurrentCamera:GetChildren()) do
        if v.Name:find("TVVHO") then v:Destroy() end
    end
end)
wait(0.5)

-- Сервисы
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Библиотеки (КРИТИЧНО ДЛЯ ПРО-СКРИПТОВ)
local GuiLibrary
pcall(function() GuiLibrary = LoadLibrary("RbxGui") end)

-- Если RbxGui не сработал (новые версии Roblox), скрипт не запустится. 
-- Это признак того, что инжектор не поддерживает старые методы.
if not GuiLibrary then
    warn("RbxGui не найден. Используйте инжектор с поддержкой старых библиотек (Fluxus, Wave).")
    return
end

-- Состояния
local Flags = {
    ["Aimbot"] = false,
    ["ESP"] = false,
    ["FOV"] = 120,
    ["Smoothness"] = 0.1,
    ["TargetPart"] = "Head",
    ["Noclip"] = false,
    ["Speed"] = 16
}

-- DRAWING LIBRARY (Для ESP линий и имен)
local Drawings = {}
local function CreateDrawing(type, props)
    local obj = Drawing.new(type)
    for i, v in pairs(props) do
        obj[i] = v
    end
    table.insert(Drawings, obj)
    return obj
end

-- МЕНЮ (Используем RbxGui для создания крутого списка)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "TVVHO_Hub"
ScreenGui.ResetOnSpawn = false

local Window = Instance.new("Frame", ScreenGui)
Window.Name = "Window"
Window.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Window.BorderSizePixel = 0
Window.Position = UDim2.new(0.5, -150, 0.5, -150)
Window.Size = UDim2.new(0, 300, 0, 350)
Window.Active = true
Window.Draggable = true
local WindowCorner = Instance.new("UICorner", Window)
WindowCorner.CornerRadius = UDim.new(0, 8)

-- Заголовок
local Header = Instance.new("Frame", Window)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.Position = UDim2.new(0, 0, 0, 0)
local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 8, 0, 0)
local Title = Instance.new("TextLabel", Header)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "TVVHO || PRO EDITION"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(100, 0, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Padding = UDim.new(0, 10)

-- Крестик
local Close = Instance.new("TextButton", Header)
Close.BackgroundTransparency = 1
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -30, 0, 0)
Close.Text = "✕"
Close.Font = Enum.Font.GothamBold
Close.TextColor3 = Color3.fromRGB(255, 100, 100)
Close.TextSize = 18
Close.MouseButton1Click:Connect(function() Window.Visible = false end)

-- Список (САМОЕ ВАЖНО: используем RbxGui)
local ListContainer = Instance.new("Frame", Window)
ListContainer.BackgroundTransparency = 1
ListContainer.Position = UDim2.new(0, 0, 0, 35)
ListContainer.Size = UDim2.new(1, 0, 1, -35)

local function AddToggle(text, flagName, callback)
    local template = Instance.new("Frame")
    template.Size = UDim2.new(1, 0, 0, 30)
    template.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", template)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggle = GuiLibrary:CreateSlider(" ", UDim2.new(1, -35, 0.5, -6), UDim2.new(0, 30, 0, 12), 0, 1, false, template)
    -- GuiLibrary:CreateToggle возвращает Frame, внутри которого чекбокс
    -- Мы просто имитируем его поведение через TextButton для надежности
    local box = Instance.new("TextButton", template)
    box.Size = UDim2.new(0, 20, 0, 20)
    box.Position = UDim2.new(1, -30, 0.5, -10)
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    box.Text = ""
    box.AutoButtonColor = false
    local boxCorner = Instance.new("UICorner", box)
    boxCorner.CornerRadius = UDim.new(0, 4)
    
    box.MouseButton1Click:Connect(function()
        Flags[flagName] = not Flags[flagName]
        box.BackgroundColor3 = Flags[flagName] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 50)
        if callback then callback(Flags[flagName]) end
    end)
    
    template.Parent = ListContainer
    return box
end

-- Создаем элементы меню
AddToggle("Aimbot", "Aimbot")
AddToggle("ESP (Drawing)", "ESP")
AddToggle("NoClip", "Noclip")

-- Слайдер FOV
local FOVSlider = GuiLibrary:CreateSlider("FOV", UDim2.new(0, 10, 0, 120), UDim2.new(0, 280, 0, 20), 70, 150, false, ListContainer)
FOVSlider.Slider.Changed:Connect(function() Flags["FOV"] = FOVSlider.Slider.Value end)
Camera.FieldOfView = Flags["FOV"]

-- ФУНКЦИИ

-- ESP Drawing (КРУТОЙ, не палится обычным античитом)
local ESPFolder = Instance.new("Folder", Camera)
ESPFolder.Name = "TVVHO_DRAWINGS"

RunService:BindToRenderStep("TVVHO_ESP", Enum.RenderPriority.Camera.Value + 1, function()
    Camera.FieldOfView = Flags["FOV"]
    
    if Flags["ESP"] then
        for _, obj in pairs(ESPFolder:GetChildren()) do obj:Destroy() end
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") then
                local line = CreateDrawing("Line", {
                    From = Camera:WorldToViewportPoint(v.Character.Head.Position + Vector3.new(0, 0.5, 0)),
                    To = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position),
                    Color = Color3.fromRGB(255, 0, 0),
                    Thickness = 2,
                    Transparency = 0.8,
                    ZIndex = 1
                })
                line.Parent = ESPFolder
                
                local text = CreateDrawing("Text", {
                    Text = v.Name,
                    Position = Camera:WorldToViewportPoint(v.Character.Head.Position),
                    Color = Color3.fromRGB(255, 255, 255),
                    Center = true,
                    Outline = true,
                    Font = Drawing.Fonts.UI,
                    Size = 13,
                    ZIndex = 1
                })
                text.Parent = ESPFolder
            end
        end
    else
        for _, obj in pairs(ESPFolder:GetChildren()) do obj:Destroy() end
    end
    
    if Flags["Aimbot"] and UserInputService:IsKeyDown(Enum.KeyCode_L) then
        local Target = nil
        local ShortestDist = math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(Flags["TargetPart"]) then
                local Part = v.Character[Flags["TargetPart"]]
                local Vec, Vis = Camera:WorldToViewportPoint(Part.Position)
                if Vis then
                    local MouseVec = Vector2.new(Mouse.X, Mouse.Y)
                    local Dist = (MouseVec - Vector2.new(Vec.X, Vec.Y)).Magnitude
                    if Dist < 100 and Dist < ShortestDist then
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
        if Target then
            -- Плавный аим (Smoothing)
            local goal = CFrame.new(Camera.CFrame.Position, Target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(goal, Flags["Smoothness"])
        end
    end
end)

-- NoClip
RunService.Stepped:Connect(function()
    if Flags["Noclip"] and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Управление скоростью
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            Flags["Speed"] = (Flags["Speed"] == 16 and 100) or 16
            LocalPlayer.Character.Humanoid.WalkSpeed = Flags["Speed"]
        end
    end
end)

print("TVVHO PRO LOADED. Press E for Speed, Hold L for Aimbot.")
