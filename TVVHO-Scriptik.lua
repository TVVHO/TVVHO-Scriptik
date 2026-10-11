-- Сброс
pcall(function() if game:GetService("CoreGui"):FindFirstChild("AetherSimple") then game:GetService("CoreGui")["AetherSimple"]:Destroy() end end)
wait(0.5)

-- Сервисы
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Состояния
local Flags = {SilentAim=true, AimPart="Head", ESP=false, Hitbox=false, Gravity=false, Speed=false, Jump=false, TriggerBot=false, AutoFarm=false, FOV_Circle=true}

-- Настройки
local Aim_Settings = {Radius = 150}

-- GUI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "AetherSimple"

-- Кнопка открытия (Маленькая точка)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OpenBtn.BackgroundTransparency = 0.5
OpenBtn.BorderSizePixel = 0
OpenBtn.Size = UDim2.new(0, 30, 0, 30)
OpenBtn.Position = UDim2.new(0, 10, 1, -40)
OpenBtn.Text = "M"
OpenBtn.Font = Enum.Font.Code
OpenBtn.TextSize = 16
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.AutoButtonColor = false
OpenBtn.ZIndex = 10

-- Меню (Рамка)
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Menu"
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, -120, 0.5, -140)
Main.Size = UDim2.new(0, 240, 0, 320)
Main.Active = true
Main.Draggable = true
Main.Visible = false
Main.ZIndex = 9

-- Заголовок
local Title = Instance.new("TextLabel", Main)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Aether UI"
Title.Font = Enum.Font.Gotham
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

-- Вкладки (Кнопки сверху)
local Tab1 = Instance.new("TextButton", Main)
Tab1.Size = UDim2.new(0.5, 0, 0, 25)
Tab1.Position = UDim2.new(0, 0, 0, 30)
Tab1.Text = "Combat"
Tab1.Font = Enum.Font.Gotham
Tab1.TextSize = 12
Tab1.BackgroundColor3 = Color3.fromRGB(40, 40, 50)

local Tab2 = Instance.new("TextButton", Main)
Tab2.Size = UDim2.new(0.5, 0, 0, 25)
Tab2.Position = UDim2.new(0.5, 0, 0, 30)
Tab2.Text = "World"
Tab2.Font = Enum.Font.Gotham
Tab2.TextSize = 12
Tab2.BackgroundColor3 = Color3.fromRGB(30, 30, 35)

-- Контейнер для кнопок
local Container = Instance.new("ScrollingFrame", Main)
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 0, 0, 60)
Container.Size = UDim2.new(1, 0, 1, -60)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 5)

-- Функция создания кнопок (Упрощенная)
local function Btn(text, func, flag)
    local button = Instance.new("TextButton", Container)
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, 0)
    button.Text = text
    button.Font = Enum.Font.Gotham
    button.TextSize = 13
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    button.AutoButtonColor = false
    local Check = Instance.new("Frame", button)
    Check.BackgroundColor3 = (flag and Flags[flag] and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0)
    Check.Position = UDim2.new(0.9, 0, 0.5, 0)
    Check.Size = UDim2.new(0, 10, 0, 10)
    Check.AnchorPoint = Vector2.new(0.5, 0.5)
    
    button.MouseButton1Click:Connect(function()
        func()
        if flag then
            Check.BackgroundColor3 = (Flags[flag] and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0)
        end
    end)
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)
end

-- ОТКРЫТИЕ
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- ЛОГИКА ВКЛАДОК (Создание кнопок при нажатии)
Tab1.MouseButton1Click:Connect(function()
    Container:ClearAllChildren()
    Tab1.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Tab2.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Btn("Silent Aim", function() Flags.SilentAim = not Flags.SilentAim end, "SilentAim")
    Btn("Hitbox", function() Flags.Hitbox = not Flags.Hitbox; for _,v in pairs(workspace:GetDescendants()) do if v.Name=="TVVHO_HITBOX" then v:Destroy() end end; if Flags.Hitbox then for _,v in pairs(Players:GetPlayers()) do if v~=LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then local hb=Instance.new("Part",v.Character) hb.Name="TVVHO_HITBOX" hb.Shape=Enum.PartType.Ball hb.Size=Vector3.new(8,8,8) hb.Color=Color3.fromRGB(255,0,0) hb.Transparency=0.7 hb.CanCollide=false hb.Massless=true hb.Anchored=false local w=Instance.new("WeldConstraint",hb) w.Part0=hb w.Part1=v.Character.HumanoidRootPart end end end end, "Hitbox")
    Btn("TriggerBot", function() Flags.TriggerBot = not Flags.TriggerBot end, "TriggerBot")
    Btn("ESP", function() Flags.ESP = not Flags.ESP end, "ESP")
end)

Tab2.MouseButton1Click:Connect(function()
    Container:ClearAllChildren()
    Tab1.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Tab2.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Btn("Speed", function() Flags.Speed = not Flags.Speed; if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = Flags.Speed and 100 or 16 end end, "Speed")
    Btn("Jump", function() Flags.Jump = not Flags.Jump; if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = Flags.Jump and 100 or 50 end end, "Jump")
    Btn("Gravity", function() Flags.Gravity = not Flags.Gravity; workspace.Gravity = Flags.Gravity and 100 or 196.2 end, "Gravity")
    Btn("FOV Circle", function() Flags.FOV_Circle = not Flags.FOV_Circle end, "FOV_Circle")
end)

-- (Здесь вставляется вся логика циклов: Silent Aim, TriggerBot, Hitbox и т.д. из прошлых сообщений)

print("Aether Simple UI Loaded.")
