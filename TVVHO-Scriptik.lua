-- Сброс
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("AetherMobile") then
        game:GetService("CoreGui")["AetherMobile"]:Destroy()
    end
end)
wait(0.5)

-- Сервисы
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Состояния
local Flags = {
    ["SilentAim"] = true,
    ["AimPart"] = "Head",
    ["ESP"] = false,
    ["ESP_Tracers"] = false,
    ["Hitbox"] = false,
    ["Gravity"] = false,
    ["Speed"] = false,
    ["Jump"] = false,
    ["TriggerBot"] = false,
    ["AutoFarm"] = false,
    ["FOV_Circle"] = true,
    ["NoClip"] = false
}

-- Настройки
local Aim_Settings = {Radius = 150}

-- Библиотека рисования
local DrawingLib
pcall(function() DrawingLib = loadstring(game:HttpGet("https://kiriot22.com/releases/drawing-lib.lua"))() end)

-- FOV Circle
local FOV_Circle
if DrawingLib then
    FOV_Circle = DrawingLib:Create('Circle', {Visible = Flags["FOV_Circle"], Color = Color3.fromRGB(100, 0, 255), Transparency = 0.6, Thickness = 2, NumSides = 100, Radius = Aim_Settings.Radius, Filled = false, Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)})
end

-- GUI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "AetherMobile"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

-- Кнопка открытия (Плавающая)
local WatermarkBtn = Instance.new("TextButton", ScreenGui)
WatermarkBtn.Name = "OpenMenu"
WatermarkBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
WatermarkBtn.BorderSizePixel = 0
WatermarkBtn.Size = UDim2.new(0, 40, 0, 40)
WatermarkBtn.Position = UDim2.new(0, 10, 1, -50)
WatermarkBtn.Text = "M"
WatermarkBtn.Font = Enum.Font.GothamBold
WatermarkBtn.TextSize = 24
WatermarkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
WatermarkBtn.AutoButtonColor = false
local Corner = Instance.new("UICorner", WatermarkBtn)
Corner.CornerRadius = UDim.new(0, 8)

-- Меню
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainMenu"
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Main.Position = UDim2.new(0.5, -130, 0.5, -150)
Main.Size = UDim2.new(0, 260, 0, 350)
Main.Active = true
Main.Draggable = true
Main.Visible = false
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 12)
local MainShadow = Instance.new("UIStroke", Main)
MainShadow.Color = Color3.fromRGB(60, 0, 120)
MainShadow.Thickness = 2

-- Заголовок
local Title = Instance.new("TextLabel", Main)
Title.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Aether Mobile Pro"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

-- Вкладки
local TabButtons = {}
local SelectedTab = "Combat"
local TabBar = Instance.new("Frame", Main)
TabBar.BackgroundTransparency = 1
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0, 0, 0, 35)

local Content = Instance.new("ScrollingFrame", Main)
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 0, 0, 70)
Content.Size = UDim2.new(1, 0, 1, -75)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
local ListLayout = Instance.new("UIListLayout", Content)
ListLayout.Padding = UDim.new(0, 6)

-- Функция кнопок
local function Btn(text, icon, func, flag)
    local button = Instance.new("TextButton", Content)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    button.Size = UDim2.new(1, -10, 0, 35)
    button.Position = UDim2.new(0, 5, 0, 0)
    button.Text = icon .. "  " .. text
    button.Font = Enum.Font.Gotham
    button.TextColor3 = Color3.fromRGB(220, 220, 255)
    button.TextSize = 14
    button.AutoButtonColor = false
    local BtnCorner = Instance.new("UICorner", button)
    BtnCorner.CornerRadius = UDim.new(0, 8)
    local BtnShadow = Instance.new("UIStroke", button)
    BtnShadow.Color = Color3.fromRGB(60, 0, 120)
    BtnShadow.Thickness = 1
    BtnShadow.Transparency = 0.7
    local Check = Instance.new("Frame", button)
    Check.BackgroundColor3 = (flag and Flags[flag] and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0)
    Check.Position = UDim2.new(0.85, 0, 0.5, 0)
    Check.Size = UDim2.new(0, 12, 0, 12)
    Check.AnchorPoint = Vector2.new(0.5, 0.5)
    local CheckCorner = Instance.new("UICorner", Check)
    CheckCorner.CornerRadius = UDim.new(0, 3)
    
    button.MouseEnter:Connect(function() TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}):Play(); TweenService:Create(button, TweenInfo.new(0.15), {Size = UDim2.new(1.02, -10, 0, 37)}):Play() end)
    button.MouseLeave:Connect(function() TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play(); TweenService:Create(button, TweenInfo.new(0.15), {Size = UDim2.new(1, -10, 0, 35)}):Play() end)
    button.MouseButton1Click:Connect(function() TweenService:Create(button, TweenInfo.new(0.05), {Size = UDim2.new(0.98, -10, 0, 33)}):Play(); wait(0.05); TweenService:Create(button, TweenInfo.new(0.05), {Size = UDim2.new(1, -10, 0, 35)}):Play(); func(); if flag then Check.BackgroundColor3 = (Flags[flag] and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0) end end)
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Content.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
end

-- Создание табов
local function CreateTab(name, icon)
    local btn = Instance.new("TextButton", TabBar)
    btn.BackgroundColor3 = (name == SelectedTab and Color3.fromRGB(60, 0, 120)) or Color3.fromRGB(40, 40, 50)
    btn.Size = UDim2.new(0.33, 0, 1, 0)
    btn.Position = UDim2.new((#TabButtons) * 0.33, 0, 0, 0)
    btn.Text = icon
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.fromRGB(220, 220, 255)
    btn.TextSize = 14
    btn.AutoButtonColor = false
    local Corner = Instance.new("UICorner", btn)
    Corner.CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        SelectedTab = name
        for _, v in pairs(TabButtons) do v.BackgroundColor3 = Color3.fromRGB(40, 40, 50) end
        btn.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
        Content:ClearAllChildren()
        ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Content.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
        end)
        
        if name == "Combat" then
            Btn("Silent Aim", "🎯", function() Flags.SilentAim = not Flags.SilentAim end, "SilentAim")
            Btn("Aim Part", "🏃", function() Flags.AimPart = (Flags.AimPart == "Head" and "Body") or "Head" end)
            Btn("ESP", "👁️", function() Flags.ESP = not Flags.ESP; for _,v in pairs(Players:GetPlayers()) do if v~=LocalPlayer and v.Character then if not v.Character:FindFirstChild("TVVHO_ESP") and Flags.ESP then local hl=Instance.new("Highlight",v.Character) hl.Name="TVVHO_ESP" hl.FillColor=Color3.fromRGB(255,0,0) hl.OutlineColor=Color3.fromRGB(255,255,255) hl.FillTransparency=0.7 elseif v.Character:FindFirstChild("TVVHO_ESP") and not Flags.ESP then v.Character:FindFirstChild("TVVHO_ESP"):Destroy() end end end end, "ESP")
            Btn("ESP Tracers", "↔️", function() Flags.ESP_Tracers = not Flags.ESP_Tracers end)
            Btn("Hitbox", "🟥", function() Flags.Hitbox = not Flags.Hitbox; for _,v in pairs(workspace:GetDescendants()) do if v.Name=="TVVHO_HITBOX" then v:Destroy() end end; if Flags.Hitbox then for _,v in pairs(Players:GetPlayers()) do if v~=LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then local hb=Instance.new("Part",v.Character) hb.Name="TVVHO_HITBOX" hb.Shape=Enum.PartType.Ball hb.Size=Vector3.new(8,8,8) hb.Color=Color3.fromRGB(255,0,0) hb.Transparency=0.7 hb.CanCollide=false hb.Massless=true hb.Anchored=false local w=Instance.new("WeldConstraint",hb) w.Part0=hb w.Part1=v.Character.HumanoidRootPart end end end end, "Hitbox")
            Btn("TriggerBot", "🔫", function() Flags.TriggerBot = not Flags.TriggerBot end, "TriggerBot")
            Btn("NoClip", "🧱", function() Flags.NoClip = not Flags.NoClip end, "NoClip")
        elseif name == "World" then
            Btn("Speed", "⚡", function() Flags.Speed = not Flags.Speed; if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = Flags.Speed and 100 or 16 end end, "Speed")
            Btn("Jump", "🦘", function() Flags.Jump = not Flags.Jump; if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = Flags.Jump and 100 or 50 end end, "Jump")
            Btn("Gravity", "🌍", function() Flags.Gravity = not Flags.Gravity; workspace.Gravity = Flags.Gravity and 100 or 196.2 end, "Gravity")
            Btn("FOV Circle", "🔘", function() Flags.FOV_Circle = not Flags.FOV_Circle; if FOV_Circle then FOV_Circle.Visible = Flags.FOV_CIRCLE end end, "FOV_Circle")
        elseif name == "Farm" then
            Btn("Auto Farm", "🚜", function() Flags.AutoFarm = not Flags.AutoFarm end, "AutoFarm")
        end
        table.insert(TabButtons, btn)
    end)
end

CreateTab("Combat", "⚔️")
CreateTab("World", "🌍")
CreateTab("Farm", "🚜")

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
Close.MouseButton1Click:Connect(function() Main.Visible = false end)

-- Открытие меню
WatermarkBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- ЛОГИКА (Циклы)

-- Silent Aim
RunService.Heartbeat:Connect(function()
    if Flags.SilentAim then
        local Target, Shortest = nil, math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local Part = v.Character:FindFirstChild(Flags.AimPart) or v.Character:FindFirstChild("HumanoidRootPart")
                if Part then
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
                                Target = Part
                            end
                        end
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

-- NoClip
if Flags.NoClip then
    RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end

-- Hitbox (Создание)
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
end

-- Speed/Jump/Gravity
if Flags.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = 100 end
if Flags.Jump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = 100 end
if Flags.Gravity then workspace.Gravity = 100 else workspace.Gravity = 196.2 end

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
end

-- ESP Tracers
if Flags.ESP_Tracers and DrawingLib then
    local Tracers = {}
    RunService.Heartbeat:Connect(function()
        -- Очистка
        for _, line in pairs(Tracers) do if line then line:Destroy() end end
        table.clear(Tracers)
        
        -- Рисование
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local line = DrawingLib:Create('Line', {
                    From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2),
                    To = Vector2.new(Mouse.X, Mouse.Y), -- Упрощенно к курсору, можно переделать на RootPart
                    Color = Color3.fromRGB(255, 0, 0),
                    Thickness = 1,
                    Transparency = 0.7
                })
                table.insert(Tracers, line)
            end
        end
    end)
end

-- FOV Circle
if FOV_Circle and Flags.FOV_Circle then
    RunService:BindToRenderStep("UpdateFOV", Enum.RenderPriority.Camera.Value - 1, function()
        FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end)
end

-- Auto Farm (Простой пример)
if Flags.AutoFarm then
    spawn(function()
        while wait(1) do
            if Flags.AutoFarm and workspace:FindFirstChild("NPCs") then
                for _, npc in pairs(workspace.NPCs:GetChildren()) do
                    if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") and npc.Humanoid.Health > 0 then
                        -- Телепорт к мобу
                        LocalPlayer.Character:SetPrimaryPartCFrame(npc.HumanoidRootPart.CFrame * CFrame.new(0, 5, 5))
                        wait(0.5)
                        -- Здесь должен быть вызов RemoteEvent для удара (зависит от игры)
                        -- VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
                        -- wait(0.1)
                        -- VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
                    end
                end
            end
        end
    end)
end

print("Aether Mobile Pro Loaded. [M] to Open")
