-- Создаем главный интерфейс TVVHO Hub
local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Name = "TVVHO_Hub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Кнопка скрыть/раскрыть меню
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ToggleBtn.Position = UDim2.new(0, 10, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 70, 0, 30)
ToggleBtn.Text = "TVVHO"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14

-- Главное окно
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Position = UDim2.new(0.3, 0, 0.2, 0)
Main.Size = UDim2.new(0, 220, 0, 260)
Main.Active = true
Main.Draggable = true

Title.Parent = Main
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "TVVHO Hub [PVP]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Title.TextSize = 16

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Функция создания кнопок
local yPos = 45
local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Main
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.TextSize = 13
    btn.MouseButton1Click:Connect(callback)
    yPos = yPos + 40
    return btn
end

-- 1. КНОПКА: Скорость
CreateButton("Скорость (100)", function()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
    end
end)

-- 2. КНОПКА: Высокий прыжок
CreateButton("Прыжок (120)", function()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 120
    end
end)

-- 3. КНОПКА: ВХ / ESP (Подсветка игроков)
CreateButton("Включить ESP (ВХ)", function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            if not player.Character:FindFirstChild("TVVHO_ESP") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "TVVHO_ESP"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = player.Character
            end
        end
    end
end)

-- 4. КНОПКА: Аимбот (Наводка на близкого врага)
CreateButton("Аимбот (Навести прицел)", function()
    local Camera = workspace.CurrentCamera
    local LocalPlayer = game.Players.LocalPlayer
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local magnitude = (v.Character.Head.Position - LocalPlayer.Character.Head.Position).Magnitude
            if magnitude < shortestDistance then
                shortestDistance = magnitude
                closestPlayer = v
            end
        end
    end

    if closestPlayer and closestPlayer.Character:FindFirstChild("Head") then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestPlayer.Character.Head.Position)
    end
end)

-- 5. КНОПКА: Сброс настроек
CreateButton("Сбросить всё", function()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end
