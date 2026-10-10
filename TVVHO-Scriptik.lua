-- Создаем простое меню TVVHO
local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SpeedBtn = Instance.new("TextButton")
local JumpBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Position = UDim2.new(0.3, 0, 0.3, 0)
Main.Size = UDim2.new(0, 200, 0, 180)
Main.Active = true
Main.Draggable = true

Title.Parent = Main
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "TVVHO Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

SpeedBtn.Parent = Main
SpeedBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
SpeedBtn.Size = UDim2.new(0.8, 0, 0.3, 0)
SpeedBtn.Text = "Скорость (100)"
SpeedBtn.MouseButton1Click:Connect(function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)

JumpBtn.Parent = Main
JumpBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
JumpBtn.Size = UDim2.new(0.8, 0, 0.3, 0)
JumpBtn.Text = "Прыжок (120)"
JumpBtn.MouseButton1Click:Connect(function()
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 120
end)
