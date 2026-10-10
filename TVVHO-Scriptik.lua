-- Сброс старых объектов
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("TVVHO_OLD") then
        game:GetService("CoreGui")["TVVHO_OLD"]:Destroy()
    end
end)
wait(0.5)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Создаем GUI (Максимально просто)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "TVVHO_OLD"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Main.Position = UDim2.new(0.5, -110, 0.5, -120)
Main.Size = UDim2.new(0, 220, 0, 300)
Main.Active = true
Main.Draggable = true
Main.Visible = false -- Скрыто по умолчанию

local Title = Instance.new("TextLabel", Main)
Title.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "TVVHO | OLD"
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
ToggleBtn.Position = UDim2.new(0, 10, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Text = "M"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 24
ToggleBtn.AutoButtonColor = false

-- Список кнопок
local List = Instance.new("UIListLayout", Main)
List.Padding = UDim.new(0, 5)
List.SortOrder = Enum.SortOrder.LayoutOrder

-- Функция создания кнопок (Старая школа)
local function Btn(text, yPos, func)
    local button = Instance.new("TextButton", Main)
    button.Name = text
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    button.Position = UDim2.new(0.05, 0, 0, yPos)
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.Text = text
    button.Font = Enum.Font.SourceSans
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.MouseButton1Click:Connect(func)
end

-- КНОПКИ (Функции)
local y = 45
Btn("Скорость (100)", y, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 100
    end
end)
y = y + 45

Btn("Прыжок (100)", y, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 100
    end
end)
y = y + 45

Btn("ВХ (ESP)", y, function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            if not v.Character:FindFirstChild("TVVHO_ESP") then
                local hl = Instance.new("Highlight", v.Character)
                hl.Name = "TVVHO_ESP"
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.7
            end
        end
    end
end)
y = y + 45

Btn("Сбросить", y, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Highlight") and v.Name == "TVVHO_ESP" then v:Destroy() end
    end
end)
y = y + 45

-- УПРАВЛЕНИЕ
ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Кнопка закрытия (Крестик)
local Close = Instance.new("TextButton", Main)
Close.BackgroundTransparency = 1
Close.Position = UDim2.new(1, -25, 0, 5)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Text = "X"
Close.Font = Enum.Font.SourceSansBold
Close.TextColor3 = Color3.fromRGB(255, 100, 100)
Close.TextSize = 16
Close.AutoButtonColor = false
Close.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

print("TVVHO OLD Loaded. [M] to open.")
