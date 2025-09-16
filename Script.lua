-- Hamood GUI - By Ansyx
-- Compatible con móvil (drag, minimizar, maximizar)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Crear ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HamoodGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Marco principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 250)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- UICorner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Text = "Hamood GUI"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Minimizar/maximizar
local ToggleButton = Instance.new("TextButton")
ToggleButton.Text = "-"
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(1, -35, 0, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 20
ToggleButton.Parent = MainFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = ToggleButton

-- ScrollFrame para botones
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -40)
ScrollFrame.Position = UDim2.new(0, 5, 0, 35)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- Función para crear botones
local function CreateButton(text, parent)
    local Btn = Instance.new("TextButton")
    Btn.Text = text
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 18
    Btn.Parent = parent

    local UICornerBtn = Instance.new("UICorner")
    UICornerBtn.CornerRadius = UDim.new(0, 8)
    UICornerBtn.Parent = Btn

    return Btn
end

-- Anti-Lag
local BtnAntiLag = CreateButton("Anti-Lag", ScrollFrame)
BtnAntiLag.MouseButton1Click:Connect(function()
    local lighting = game:GetService("Lighting")
    local terrain = workspace:FindFirstChildOfClass("Terrain")

    lighting.GlobalShadows = false
    lighting.FogEnd = math.huge
    lighting.Brightness = 0
    lighting.EnvironmentDiffuseScale = 0
    lighting.EnvironmentSpecularScale = 0

    for _, v in pairs(lighting:GetDescendants()) do
        if v:IsA("PostEffect") then v.Enabled = false end
    end

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
            obj.Enabled = false
        elseif obj:IsA("Decal") then
            obj.Transparency = 1
        end
    end

    if terrain then
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 1
    end

    for _, sound in pairs(workspace:GetDescendants()) do
        if sound:IsA("Sound") then sound.Volume = 0 end
    end

    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr.Character then
            for _, item in pairs(plr.Character:GetDescendants()) do
                if item:IsA("Accessory") or item:IsA("Clothing") then item:Destroy() end
            end
        end
    end

    game.StarterGui:SetCore("SendNotification", {
        Title = "FPS BOOST ACTIVADO";
        Text = "¡Rendimiento mejorado!";
        Duration = 1;
    })

    print("Anti-Lag Activado.")
end)

-- Lag Server
local BtnLagServer = CreateButton("Lag Server", ScrollFrame)
BtnLagServer.MouseButton1Click:Connect(function()
    local delayTime = 1
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "FireServer" or method == "InvokeServer" then
            task.wait(delayTime)
            return old(self, unpack(args))
        end
        return old(self, ...)
    end

    task.spawn(function()
        while task.wait(5) do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Anchored = true
                task.wait(delayTime)
                LocalPlayer.Character.HumanoidRootPart.Anchored = false
            end
        end
    end)

    print("Simulador de ping activado con " .. delayTime .. "s extra.")
end)

-- SpeedCoil_Bug
local BtnSpeedCoil = CreateButton("SpeedCoil: OFF", ScrollFrame)
local SpeedCoil = false
BtnSpeedCoil.MouseButton1Click:Connect(function()
    SpeedCoil = not SpeedCoil
    BtnSpeedCoil.Text = SpeedCoil and "SpeedCoil: ON" or "SpeedCoil: OFF"
end)

task.spawn(function()
    local impulso = 15
    local frecuencia = 0.25
    while true do
        task.wait(frecuencia)
        if SpeedCoil then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                local hrp = char.HumanoidRootPart
                local humanoid = char.Humanoid
                if humanoid.FloorMaterial == Enum.Material.Air then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, impulso, hrp.Velocity.Z)
                end
            end
        end
    end
end)

-- SpeedBoost
local BtnSpeedBoost = CreateButton("SpeedBoost: OFF", ScrollFrame)
local SpeedBoost = false
local SpeedValue = 27.5
local RefreshRate = 2

local function ToggleSpeedBoost()
    SpeedBoost = not SpeedBoost
    BtnSpeedBoost.Text = SpeedBoost and "SpeedBoost: ON" or "SpeedBoost: OFF"
    if not SpeedBoost then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = 16
        end
    end
end

BtnSpeedBoost.MouseButton1Click:Connect(ToggleSpeedBoost)
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then ToggleSpeedBoost() end
end)

task.spawn(function()
    while true do
        task.wait(RefreshRate)
        if SpeedBoost then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = SpeedValue
            end
        end
    end
end)

-- Actualizar CanvasSize
task.spawn(function()
    while task.wait(0.5) do
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end
end)

-- Minimizar / maximizar
local minimized = false
ToggleButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        ScrollFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 250, 0, 30)
        ToggleButton.Text = "+"
    else
        ScrollFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 250, 0, 250)
        ToggleButton.Text = "-"
    end
end)
