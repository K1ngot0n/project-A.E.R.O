-- Serviços e Jogador
local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Criando a Tela Principal (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AERO_Gui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Janela Principal (Frame)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 220)
frame.Position = UDim2.new(0.5, -120, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Título da GUI
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "A.E.R.O"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleLabel.Parent = frame

--- BARRAS DE NAVEGAÇÃO (ABAS) ---
local tabSpeedBtn = Instance.new("TextButton")
tabSpeedBtn.Size = UDim2.new(0.5, 0, 0, 25)
tabSpeedBtn.Position = UDim2.new(0, 0, 0, 30)
tabSpeedBtn.Text = "Velocidade"
tabSpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tabSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabSpeedBtn.Parent = frame

local tabSpinBtn = Instance.new("TextButton")
tabSpinBtn.Size = UDim2.new(0.5, 0, 0, 25)
tabSpinBtn.Position = UDim2.new(0.5, 0, 0, 30)
tabSpinBtn.Text = "Giro"
tabSpinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tabSpinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabSpinBtn.Parent = frame

--- CONTEÚDO DA ABA VELOCIDADE ---
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(1, 0, 1, -55)
speedFrame.Position = UDim2.new(0, 0, 0, 55)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0, 200, 0, 30)
textBox.Position = UDim2.new(0, 20, 0, 10)
textBox.PlaceholderText = "Digite a velocidade..."
textBox.Text = ""
textBox.Parent = speedFrame

local applySpeedBtn = Instance.new("TextButton")
applySpeedBtn.Size = UDim2.new(0, 200, 0, 30)
applySpeedBtn.Position = UDim2.new(0, 20, 0, 45)
applySpeedBtn.Text = "Aplicar Texto"
applySpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
applySpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applySpeedBtn.Parent = speedFrame

-- Macros de Velocidade
local velocidadesMacro = {18, 32, 50}
for i, vel in ipairs(velocidadesMacro) do
	local macroBtn = Instance.new("TextButton")
	macroBtn.Size = UDim2.new(0, 60, 0, 35)
	macroBtn.Position = UDim2.new(0, 20 + (i - 1) * 70, 0, 90)
	macroBtn.Text = tostring(vel)
	macroBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	macroBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	macroBtn.Parent = speedFrame
	
	macroBtn.MouseButton1Click:Connect(function()
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.WalkSpeed = vel
		end
	end)
end

applySpeedBtn.MouseButton1Click:Connect(function()
	local novaVelocidade = tonumber(textBox.Text)
	if novaVelocidade and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = novaVelocidade
	end
end)

--- CONTEÚDO DA ABA GIRO ---
local spinFrame = Instance.new("Frame")
spinFrame.Size = UDim2.new(1, 0, 1, -55)
spinFrame.Position = UDim2.new(0, 0, 0, 55)
spinFrame.BackgroundTransparency = 1
spinFrame.Visible = false
spinFrame.Parent = frame

local spinBtn = Instance.new("TextButton")
spinBtn.Size = UDim2.new(0, 200, 0, 40)
spinBtn.Position = UDim2.new(0, 20, 0, 40)
spinBtn.Text = "Girar: DESLIGADO"
spinBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
spinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
spinBtn.Parent = spinFrame

local girando = false
spinBtn.MouseButton1Click:Connect(function()
	girando = not girando
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	
	if hrp then
		if girando then
			spinBtn.Text = "Girar: LIGADO"
			spinBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
			
			local giro = Instance.new("BodyAngularVelocity")
			giro.Name = "GiroRapido"
			giro.MaxTorque = Vector3.new(0, math.huge, 0)
			giro.AngularVelocity = Vector3.new(0, 60, 0)
			giro.Parent = hrp
		else
			spinBtn.Text = "Girar: DESLIGADO"
			spinBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
			
			local giro = hrp:FindFirstChild("GiroRapido")
			if giro then
				giro:Destroy()
			end
		end
	end
end)

--- TROCA DE ABAS ---
tabSpeedBtn.MouseButton1Click:Connect(function()
	speedFrame.Visible = true
	spinFrame.Visible = false
	tabSpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	tabSpinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

tabSpinBtn.MouseButton1Click:Connect(function()
	speedFrame.Visible = false
	spinFrame.Visible = true
	tabSpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	tabSpinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

--- SISTEMA DE ARRASTAR (DRAGGABLE) ---
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)
