-- Сброс
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("TVVHO_MOBILE") then
        game:GetService("CoreGui")["TVVHO_MOBILE"]:Destroy()
    end
end)
wait(0.5)

local plrs = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = plrs.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

local CharactersFolder = Workspace:WaitForChild('Characters')

-- Флаги
local Flags = {
    Aimbot = true, -- Аим работает сам по себе
    ESP = true,    -- ВХ работает сам по себе
    Speed = false,
    Jump = false,
    Gravity = false,
    NoClip = false
}

-- Настройки
local enemyColor = Color3.fromRGB(255, 0, 0)
local teamColor = Color3.fromRGB(50, 205, 50)
local TargetPart = "Head"

-- GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "TVVHO_MOBILE"
local ESPFolder = Instance.new("Folder", ScreenGui)

-- Функция Телепорта (Вызывается кнопкой)
local function TeleportToCursor()
    local target = Mouse.Hit.p
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char:SetPrimaryPartCFrame(CFrame.new(target + Vector3.new(0, 5, 0)))
    end
end

-- ESP
function espPart(part, player, color)
    local esp = Instance.new("BoxHandleAdornment", ESPFolder)
    esp.Adornee = part
    esp.AlwaysOnTop = true
    esp.ZIndex = 1
    esp.Transparency = 0.5
    esp.Size = part.Size
    esp.Color3 = color
end

function espPlayer(targetPlayer)
    if CharactersFolder:FindFirstChild(targetPlayer.Name) then
        local CharModel = CharactersFolder[targetPlayer.Name]
        if CharModel and CharModel:FindFirstChild("Hitbox") then
            for _,part in pairs(CharModel.Hitbox:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= TargetPart then
                    local color = (targetPlayer.Team == LocalPlayer.Team) and teamColor or enemyColor
                    espPart(part, targetPlayer, color)
                end
            end
        end
    end
end

function ESP()
    ESPFolder:ClearAllChildren()
    for _,player in pairs(plrs:GetPlayers()) do
        if player ~= LocalPlayer then
            espPlayer(player)
        end
    end
end

CharactersFolder.ChildAdded:Connect(function(instance)
    if instance.Name ~= LocalPlayer.Name then
        espPlayer(plrs[instance.Name])
    end
end)
CharactersFolder.ChildRemoved:Connect(function() ESP() end)
ESP()

-- AIMBOT (АВТОМАТИЧЕСКИЙ для телефона)
RunService.RenderStepped:Connect(function()
    if Flags.Aimbot then
        local target = nil
        local shortestDist = math.huge
        for _, v in pairs(plrs:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local Head = v.Character.Head
                local Vec, Vis = Camera:WorldToViewportPoint(Head.Position)
                if Vis then
                    local MouseVec = Vector2.new(Mouse.X, Mouse.Y)
                    local Dist = (MouseVec - Vector2.new(Vec.X, Vec.Y)).Magnitude
                    if Dist < 250 and Dist < shortestDist then
                        shortestDist = Dist
                        target = v
                    end
                end
            end
        end
        if target and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- МЕНЮ (Простое, для телефона)
local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -10, 0, 30)
    Btn.Position = UDim2.new(0, 5, 0, (#parent:GetChildren() - 1) * 35)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Btn.Text = text
    Btn.Font = Enum.Font.Gotham
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 13
    Btn.AutoButtonColor = false
    Btn.MouseButton1Click:Connect(callback)
end

local Main = Instance.new("Frame", ScreenGui)
Main.Position = UDim2.new(0.5, -150, 0.5, -100)
Main.Size = UDim2.new(0, 300, 0, 200)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Title.Text = "TVVHO Mobile"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 215, 0)

local Pages = Instance.new("Folder", Main)

-- Вкладки
local CombatPage = Instance.new("ScrollingFrame", Pages)
CombatPage.Size = UDim2.new(1, 0, 1, -35)
CombatPage.BackgroundTransparency = 1
CombatPage.Visible = true

local WorldPage = Instance.new("ScrollingFrame", Pages)
WorldPage.Size = UDim2.new(1, 0, 1, -35)
WorldPage.BackgroundTransparency = 1
WorldPage.Visible = false

-- Кнопки
CreateButton(CombatPage, "Телепорт (Кликни)", TeleportToCursor)
CreateButton(CombatPage, "Speed", function() Flags.Speed = not Flags.Speed end)
CreateButton(CombatPage, "Jump", function() Flags.Jump = not Flags.Jump end)
CreateButton(CombatPage, "Gravity", function() Flags.Gravity = not Flags.Gravity end)
CreateButton(CombatPage, "NoClip", function() Flags.NoClip = not Flags.NoClip end)

-- Переключение вкладок (Кнопки сверху)
CreateButton(Main, "Combat", function() CombatPage.Visible = true; WorldPage.Visible = false end)
CreateButton(Main, "World", function() WorldPage.Visible = true; CombatPage.Visible = false end)

warn("TVVHO MOBILE LOADED. [Aimbot: Auto] [Teleport: Button]")
