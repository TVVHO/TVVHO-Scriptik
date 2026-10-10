-- Сброс старых объектов
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("SimpleTVVHO") then
        game:GetService("CoreGui")["SimpleTVVHO"]:Destroy()
    end
end)
wait(0.5)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "SimpleTVVHO"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Main.Position = UDim2.new(0.5, -120, 0.5, -100)
Main.Size = UDim2.new(0, 240, 0, 280)
Main.Active = true
Main.Draggable = true
Main.Visible = false

local Title = Instance.new("TextLabel", Main)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "TVVHO | SIMPLE"
Title.Font = Enum.Font.Gotham
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Text = "T"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 20
ToggleBtn.AutoButtonColor = false

local List = Instance.new("UIListLayout", Main)
List.Padding = UDim.new(0, 5)

-- Функция кнопки
local function Btn(text, func)
    local button = Instance.new("TextButton", Main)
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, 0)
    button.Text = text
    button.Font = Enum.Font.Gotham
    button.TextColor3 = Color3.fromRGB(220, 220, 255)
    button.TextSize = 13
    button.MouseButton1Click:Connect(func)
    List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Main.Size = UDim2.new(0, 240, 0, 40 + List.AbsoluteContentSize.Y + 10)
    end)
end

-- КНОПКИ
Btn("Скорость (100)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 100
    end
end)

Btn("Прыжок (100)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 100
    end
end)

Btn("ВХ (ESP)", function()
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

Btn("Сброс", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Highlight") and v.Name == "TVVHO_ESP" then v:Destroy() end
    end
end)

-- УПРАВЛЕНИЕ
ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

print("Simple TVVHO Loaded.")
