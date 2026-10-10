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
ToggleBtn.Position = UDim2.new(0, 10, 0.3, 0)
ToggleBtn.Size = UDim2.new(0, 80, 0, 30)
ToggleBtn.Text = "TVVHO"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14

-- Главное окно
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Position = UDim2.new(0.3, 0, 0.2, 0)
Main.Size = UDim2.new(0, 220, 0, 320)
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

-- Функция создания красивых кнопок
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
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)

-- 2. КНОПКА: Высокий прыжок
CreateButton("Прыжок (120)", function()
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 120
end)

-- 3. КНОПКА: ВХ / ESP (Подсветка игроков)
local espEnabled = false
CreateButton("ВКЛ / ВЫКЛ ESP (ВХ)", function()
    espEnabled = not espEnabled
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            if espEnabled then
                if not player.Character:FindFirstChild("TVVHO_ESP") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "TVVHO_ESP"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = player.Character
                end
            else
                if player.Character:FindFirstChild("TVVHO_ESP") then
                    player.Character.TVVHO_ESP:Destroy()
                end
            end
        end
    end
end)

-- 4. КНОПКА: Аимбот (Авто-наводка)
local aimEnabled = false
CreateButton("ВКЛ / ВЫКЛ Aimbot", function()
    aimEnabled = not aimEnabled
    
    local Camera = workspace.CurrentCamera
    local LocalPlayer = game.Players.LocalPlayer
    
    local function GetClosestPlayer()
        local closest = nil
        local maxDist = math.huge
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if onScreen thenlocal dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if dist < maxDist then
                        maxDist = dist
                        closest = v.Character.Head
                    end
                end
            end
        end
        return closest
    end

    game:GetService("RunService").RenderStepped:Connect(function()
        if aimEnabled then
            local target = GetClosestPlayer()
            if target then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            end
        end
    end)
end)

-- 5. КНОПКА: Бесконечный прыжок
local infJump = false
CreateButton("Бесконечный прыжок", function()
    infJump = true
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if infJump then
            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end)
