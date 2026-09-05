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
tabSpeedBtn.Size = UDim2.new(0.333, 0, 0, 25)
tabSpeedBtn.Position = UDim2.new(0, 0, 0, 30)
tabSpeedBtn.Text = "Velocidade"
tabSpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tabSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabSpeedBtn.Parent = frame

local tabJumpBtn = Instance.new("TextButton")
tabJumpBtn.Size = UDim2.new(0.333, 0, 0, 25)
tabJumpBtn.Position = UDim2.new(0.333, 0, 0, 30)
tabJumpBtn.Text = "Pulo"
tabJumpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tabJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabJumpBtn.Parent = frame

local tabSpinBtn = Instance.new("TextButton")
tabSpinBtn.Size = UDim2.new(0.334, 0, 0, 25)
tabSpinBtn.Position = UDim2.new(0.666, 0, 0, 30)
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

local textBoxSpeed = Instance.new("TextBox")
textBoxSpeed.Size = UDim2.new(0, 200, 0, 30)
textBoxSpeed.Position = UDim2.new(0, 20, 0, 10)
textBoxSpeed.PlaceholderText = "Digite a velocidade..."
textBoxSpeed.Text = ""
textBoxSpeed.Parent = speedFrame

local applySpeedBtn = Instance.new("TextButton")
applySpeedBtn.Size = UDim2.new(0, 200, 0, 30)
applySpeedBtn.Position = UDim2.new(0, 20, 0, 45)
applySpeedBtn.Text = "Aplicar Velocidade"
applySpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
applySpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applySpeedBtn.Parent = speedFrame

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
	local novaVelocidade = tonumber(textBoxSpeed.Text)
	if novaVelocidade and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = novaVelocidade
	end
end)

--- CONTEÚDO DA ABA PULO ---
local jumpFrame = Instance.new("Frame")
jumpFrame.Size = UDim2.new(1, 0, 1, -55)
jumpFrame.Position = UDim2.new(0, 0, 0, 55)
jumpFrame.BackgroundTransparency = 1
jumpFrame.Visible = false
jumpFrame.Parent = frame

local textBoxJump = Instance.new("TextBox")
textBoxJump.Size = UDim2.new(0, 200, 0, 30)
textBoxJump.Position = UDim2.new(0, 20, 0, 10)
textBoxJump.PlaceholderText = "Digite a força do pulo..."
textBoxJump.Text = ""
textBoxJump.Parent = jumpFrame

local applyJumpBtn = Instance.new("TextButton")
applyJumpBtn.Size = UDim2.new(0, 200, 0, 30)
applyJumpBtn.Position = UDim2.new(0, 20, 0, 45)
applyJumpBtn.Text = "Aplicar Pulo"
applyJumpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
applyJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyJumpBtn.Parent = jumpFrame

local pulosMacro = {50, 100, 150}
for i, puloVal in ipairs(pulosMacro) do
	local macroBtn = Instance.new("TextButton")
	macroBtn.Size = UDim2.new(0, 60, 0, 35)
	macroBtn.Position = UDim2.new(0, 20 + (i - 1) * 70, 0, 90)
	macroBtn.Text = tostring(puloVal)
	macroBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	macroBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	macroBtn.Parent = jumpFrame
	
	macroBtn.MouseButton1Click:Connect(function()
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.JumpPower = puloVal
		end
	end)
end

applyJumpBtn.MouseButton1Click:Connect(function()
	local novoPulo = tonumber(textBoxJump.Text)
	if novoPulo and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.JumpPower = novoPulo
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
	jumpFrame.Visible = false
	spinFrame.Visible = false
	tabSpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	tabJumpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	tabSpinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

tabJumpBtn.MouseButton1Click:Connect(function()
	speedFrame.Visible = false
	jumpFrame.Visible = true
	spinFrame.Visible = false
	tabSpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	tabJumpBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	tabSpinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

tabSpinBtn.MouseButton1Click:Connect(function()
	speedFrame.Visible = false
	jumpFrame.Visible = false
	spinFrame.Visible = true
	tabSpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	tabJumpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
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
