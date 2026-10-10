-- Сброс старых объектов
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("TVVHO_WORKING") then
        game:GetService("CoreGui")["TVVHO_WORKING"]:Destroy()
    end
end)
wait(0.5)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Состояния
local Flags = {
    ["SilentAim"] = true,
    ["ESP"] = false,
    ["Speed"] = false
}

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "TVVHO_WORKING"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Main.Position = UDim2.new(0.5, -110, 0.5, -120)
Main.Size = UDim2.new(0, 220, 0, 320)
Main.Active = true
Main.Draggable = true
Main.Visible = false

-- Крутые закругленные углы (UICorner)
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Main)
Title.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "TVVHO | PRO"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
ToggleBtn.Position = UDim2.new(0, 10, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Text = "M"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 24
ToggleBtn.AutoButtonColor = false
local ToggleCorner = Instance.new("UICorner", ToggleBtn)
ToggleCorner.CornerRadius = UDim.new(0, 8)

local List = Instance.new("UIListLayout", Main)
List.Padding = UDim.new(0, 5)

-- Функция кнопок
local function Btn(text, func)
    local button = Instance.new("TextButton", Main)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    button.Position = UDim2.new(0.05, 0, 0, 0)
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.Text = text
    button.Font = Enum.Font.Gotham
    button.TextColor3 = Color3.fromRGB(220, 220, 255)
    button.TextSize = 14
    local BtnCorner = Instance.new("UICorner", button)
    BtnCorner.CornerRadius = UDim.new(0, 6)
    button.MouseButton1Click:Connect(func)
    List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Main.Size = UDim2.new(0, 220, 0, 45 + List.AbsoluteContentSize.Y + 10)
    end)
end

-- КНОПКИ
local y = 45
Btn("Скорость (100)", function()
    Flags.Speed = not Flags.Speed
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Flags.Speed and 100 or 16
    end
end)
y = y + 45

Btn("Прыжок (100)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 100
    end
end)
y = y + 45

Btn("ВХ (ESP)", function()
    Flags.ESP = not Flags.ESP
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            if not v.Character:FindFirstChild("TVVHO_ESP") and Flags.ESP then
                local hl = Instance.new("Highlight", v.Character)
                hl.Name = "TVVHO_ESP"
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.7
            elseif v.Character:FindFirstChild("TVVHO_ESP") and not Flags.ESP then
                v.Character:FindFirstChild("TVVHO_ESP"):Destroy()
            end
        end
    end
end)
y = y + 45

Btn("Silent Aim: ON", function()
    Flags.SilentAim = not Flags.SilentAim
    -- Текст кнопки не обновляем, чтобы не усложнять код, просто меняем логику
end)
y = y + 45

Btn("Сбросить", function()
    Flags.Speed = false
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Highlight") and v.Name == "TVVHO_ESP" then v:Destroy() end
    end
end)

-- Кнопка закрытия
local Close = Instance.new("TextButton", Main)
Close.BackgroundTransparency = 1
Close.Position = UDim2.new(1, -25, 0, 5)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextColor3 = Color3.fromRGB(255, 100, 100)
Close.TextSize = 16
Close.AutoButtonColor = false
local CloseCorner = Instance.new("UICorner", Close)
CloseCorner.CornerRadius = UDim.new(0, 4)
Close.MouseButton1Click:Connect(function() Main.Visible = false end)

-- УПРАВЛЕНИЕ МЕНЮ
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- Silent Aim (САМАЯ ВАЖНАЯ ЧАСТЬ)
RunService:BindToRenderStep("Aim", Enum.RenderPriority.Camera.Value, function()
    if Flags.SilentAim then
        if UserInputService:IsKeyDown(Enum.KeyCode_L) then -- Зажми L для аима
            local Target = nil
            local Shortest = math.huge
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                    local Head = v.Character.Head
                    local Vec, Vis = Camera:WorldToViewportPoint(Head.Position)
                    if Vis then
                        local MouseVec = Vector2.new(Mouse.X, Mouse.Y)
                        local Dist = (MouseVec - Vector2.new(Vec.X, Vec.Y)).Magnitude
                        if Dist < 150 and Dist < Shortest then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {LocalPlayer.Character, v.Character}
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            local rayResult = workspace:Raycast(Camera.CFrame.Position, (Head.Position - Camera.CFrame.Position).Unit * 1000, rayParams)
                            if not rayResult or rayResult.Instance:IsDescendantOf(v.Character) then
                                Shortest = Dist
                                Target = Head
                            end
                        end
                    end
                end
            end
            if Target then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
            end
        end
    end
end)

print("TVVHO WORKING Loaded. [M] for Menu | [L] for Aim")
