-- Serviços e Jogador
local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Criando a Tela Principal (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AERO_Gui"
screenGui.ResetOnSpawn = false -- IMPEDE A GUI DE SUMIR AO RENASCER / MUDAR DE RODADA
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Janela Principal (Frame)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 230)
frame.Position = UDim2.new(0.5, -130, 0.3, 0)
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

--- VARIÁVEIS DE ESTADO ---
local currentSpeed = 16
local currentJumpPower = 50
local girando = false
local flying = false
local espAtivo = false
local blinkDistance = 25 -- Distância do Blink

--- BARRAS DE NAVEGAÇÃO (6 ABAS) ---
local tabs = {"Velocidade", "Pulo", "Giro", "Fly", "ESP", "Blink"}
local tabButtons = {}
local tabFrames = {}

for i, tabName in ipairs(tabs) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1 / #tabs, 0, 0, 25)
	btn.Position = UDim2.new((i - 1) * (1 / #tabs), 0, 0, 30)
	btn.Text = tabName
	btn.TextSize = 10
	btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Parent = frame
	tabButtons[tabName] = btn
	
	local contentFrame = Instance.new("Frame")
	contentFrame.Size = UDim2.new(1, 0, 1, -55)
	contentFrame.Position = UDim2.new(0, 0, 0, 55)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Visible = (i == 1)
	contentFrame.Parent = frame
	tabFrames[tabName] = contentFrame
end

-- Função para trocar de abas
for name, btn in pairs(tabButtons) do
	btn.MouseButton1Click:Connect(function()
		for tName, fFrame in pairs(tabFrames) do
			fFrame.Visible = (tName == name)
			tabButtons[tName].BackgroundColor3 = (tName == name) and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(40, 40, 40)
		end
	end)
end

--- FUNÇÕES AUXILIARES DE APLICAR ESTADOS ---
local function aplicarVelocidade(val)
	currentSpeed = val
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = val
	end
end

local function aplicarPulo(val)
	currentJumpPower = val
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.JumpPower = val
	end
end

local function aplicarGiro(estado)
	girando = estado
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		local giroAntigo = hrp:FindFirstChild("GiroRapido")
		if giroAntigo then giroAntigo:Destroy() end
		
		if girando then
			local giro = Instance.new("BodyAngularVelocity")
			giro.Name = "GiroRapido"
			giro.MaxTorque = Vector3.new(0, math.huge, 0)
			giro.AngularVelocity = Vector3.new(0, 60, 0)
			giro.Parent = hrp
		end
	end
end

local flyVelocity, flyGyro

local function aplicarFly(estado)
	flying = estado
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	
	if hrp then
		local oldVel = hrp:FindFirstChild("FlyVelocity")
		local oldGyro = hrp:FindFirstChild("FlyGyro")
		if oldVel then oldVel:Destroy() end
		if oldGyro then oldGyro:Destroy() end
		
		if flying then
			flyVelocity = Instance.new("BodyVelocity")
			flyVelocity.Name = "FlyVelocity"
			flyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			flyVelocity.Velocity = Vector3.new(0, 0, 0)
			flyVelocity.Parent = hrp
			
			flyGyro = Instance.new("BodyGyro")
			flyGyro.Name = "FlyGyro"
			flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
			flyGyro.CFrame = hrp.CFrame
			flyGyro.Parent = hrp
		end
	end
end

local function executarBlink()
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if hrp then
		-- Teleporta para frente na direção em que o jogador está olhando
		hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * blinkDistance)
	end
end

--- 1. ABA VELOCIDADE ---
local speedFrame = tabFrames["Velocidade"]
local textBoxSpeed = Instance.new("TextBox")
textBoxSpeed.Size = UDim2.new(0, 220, 0, 30)
textBoxSpeed.Position = UDim2.new(0, 20, 0, 10)
textBoxSpeed.PlaceholderText = "Digite a velocidade..."
textBoxSpeed.Text = ""
textBoxSpeed.Parent = speedFrame

local applySpeedBtn = Instance.new("TextButton")
applySpeedBtn.Size = UDim2.new(0, 220, 0, 30)
applySpeedBtn.Position = UDim2.new(0, 20, 0, 45)
applySpeedBtn.Text = "Aplicar Velocidade"
applySpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
applySpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applySpeedBtn.Parent = speedFrame

local velocidadesMacro = {18, 32, 50}
for i, vel in ipairs(velocidadesMacro) do
	local macroBtn = Instance.new("TextButton")
	macroBtn.Size = UDim2.new(0, 65, 0, 35)
	macroBtn.Position = UDim2.new(0, 20 + (i - 1) * 77, 0, 90)
	macroBtn.Text = tostring(vel)
	macroBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	macroBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	macroBtn.Parent = speedFrame
	
	macroBtn.MouseButton1Click:Connect(function()
		aplicarVelocidade(vel)
	end)
end

applySpeedBtn.MouseButton1Click:Connect(function()
	local novaVel = tonumber(textBoxSpeed.Text)
	if novaVel then
		aplicarVelocidade(novaVel)
	end
end)

--- 2. ABA PULO ---
local jumpFrame = tabFrames["Pulo"]
local textBoxJump = Instance.new("TextBox")
textBoxJump.Size = UDim2.new(0, 220, 0, 30)
textBoxJump.Position = UDim2.new(0, 20, 0, 10)
textBoxJump.PlaceholderText = "Digite a força do pulo..."
textBoxJump.Text = ""
textBoxJump.Parent = jumpFrame

local applyJumpBtn = Instance.new("TextButton")
applyJumpBtn.Size = UDim2.new(0, 220, 0, 30)
applyJumpBtn.Position = UDim2.new(0, 20, 0, 45)
applyJumpBtn.Text = "Aplicar Pulo"
applyJumpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
applyJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyJumpBtn.Parent = jumpFrame

local pulosMacro = {50, 100, 150}
for i, puloVal in ipairs(pulosMacro) do
	local macroBtn = Instance.new("TextButton")
	macroBtn.Size = UDim2.new(0, 65, 0, 35)
	macroBtn.Position = UDim2.new(0, 20 + (i - 1) * 77, 0, 90)
	macroBtn.Text = tostring(puloVal)
	macroBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	macroBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	macroBtn.Parent = jumpFrame
	
	macroBtn.MouseButton1Click:Connect(function()
		aplicarPulo(puloVal)
	end)
end

applyJumpBtn.MouseButton1Click:Connect(function()
	local novoPulo = tonumber(textBoxJump.Text)
	if novoPulo then
		aplicarPulo(novoPulo)
	end
end)

--- 3. ABA GIRO ---
local spinFrame = tabFrames["Giro"]
local spinBtn = Instance.new("TextButton")
spinBtn.Size = UDim2.new(0, 220, 0, 40)
spinBtn.Position = UDim2.new(0, 20, 0, 40)
spinBtn.Text = "Girar: DESLIGADO"
spinBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
spinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
spinBtn.Parent = spinFrame

spinBtn.MouseButton1Click:Connect(function()
	aplicarGiro(not girando)
	spinBtn.Text = girando and "Girar: LIGADO" or "Girar: DESLIGADO"
	spinBtn.BackgroundColor3 = girando and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

--- 4. ABA FLY ---
local flyFrame = tabFrames["Fly"]
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 220, 0, 40)
flyBtn.Position = UDim2.new(0, 20, 0, 40)
flyBtn.Text = "Fly: DESLIGADO"
flyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Parent = flyFrame

flyBtn.MouseButton1Click:Connect(function()
	aplicarFly(not flying)
	flyBtn.Text = flying and "Fly: LIGADO" or "Fly: DESLIGADO"
	flyBtn.BackgroundColor3 = flying and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

RunService.RenderStepped:Connect(function()
	if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = player.Character.HumanoidRootPart
		local camera = workspace.CurrentCamera
		if flyGyro and flyGyro.Parent then flyGyro.CFrame = camera.CFrame end
		
		local speed = 50
		local moveDir = Vector3.new()
		
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
		
		if flyVelocity and flyVelocity.Parent then flyVelocity.Velocity = moveDir * speed end
	end
end)

--- 5. ABA ESP ---
local espFrame = tabFrames["ESP"]
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0, 220, 0, 40)
espBtn.Position = UDim2.new(0, 20, 0, 40)
espBtn.Text = "ESP: DESLIGADO"
espBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.Parent = espFrame

local function adicionarESP(targetPlayer)
	if targetPlayer ~= player then
		targetPlayer.CharacterAdded:Connect(function(char)
			if espAtivo then
				task.wait(0.5)
				local highlight = Instance.new("Highlight")
				highlight.Name = "AERO_ESP"
				highlight.FillColor = Color3.fromRGB(255, 0, 0)
				highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				highlight.Parent = char
			end
		end)
		
		if targetPlayer.Character then
			local highlight = targetPlayer.Character:FindFirstChild("AERO_ESP") or Instance.new("Highlight")
			highlight.Name = "AERO_ESP"
			highlight.FillColor = Color3.fromRGB(255, 0, 0)
			highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
			highlight.Parent = targetPlayer.Character
		end
	end
end

espBtn.MouseButton1Click:Connect(function()
	espAtivo = not espAtivo
	espBtn.Text = espAtivo and "ESP: LIGADO" or "ESP: DESLIGADO"
	espBtn.BackgroundColor3 = espAtivo and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
	
	for _, p in ipairs(game.Players:GetPlayers()) do
		if espAtivo then
			adicionarESP(p)
		else
			if p.Character then
				local hl = p.Character:FindFirstChild("AERO_ESP")
				if hl then hl:Destroy() end
			end
		end
	end
end)

game.Players.PlayerAdded:Connect(function(p)
	if espAtivo then adicionarESP(p) end
end)

--- 6. ABA BLINK ---
local blinkFrame = tabFrames["Blink"]

local blinkBtn = Instance.new("TextButton")
blinkBtn.Size = UDim2.new(0, 220, 0, 40)
blinkBtn.Position = UDim2.new(0, 20, 0, 10)
blinkBtn.Text = "Blink (Teleport)"
blinkBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
blinkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
blinkBtn.Parent = blinkFrame

local textBoxBlink = Instance.new("TextBox")
textBoxBlink.Size = UDim2.new(0, 220, 0, 30)
textBoxBlink.Position = UDim2.new(0, 20, 0, 60)
textBoxBlink.PlaceholderText = "Distância do Blink (Padrão: 25)..."
textBoxBlink.Text = ""
textBoxBlink.Parent = blinkFrame

local applyBlinkBtn = Instance.new("TextButton")
applyBlinkBtn.Size = UDim2.new(0, 220, 0, 30)
applyBlinkBtn.Position = UDim2.new(0, 20, 0, 95)
applyBlinkBtn.Text = "Definir Distância"
applyBlinkBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
applyBlinkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyBlinkBtn.Parent = blinkFrame

blinkBtn.MouseButton1Click:Connect(function()
	executarBlink()
end)

applyBlinkBtn.MouseButton1Click:Connect(function()
	local dist = tonumber(textBoxBlink.Text)
	if dist then
		blinkDistance = dist
	end
end)

-- Atalho de teclado (Tecla E no PC para disparar o Blink)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.E then
		executarBlink()
	end
end)

--- RENOVAÇÃO AUTOMÁTICA AO RENASCER (RESPAWN) ---
player.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid")
	task.wait(0.2)
	
	if currentSpeed ~= 16 then aplicarVelocidade(currentSpeed) end
	if currentJumpPower ~= 50 then aplicarPulo(currentJumpPower) end
	if girando then aplicarGiro(true) end
	if flying then aplicarFly(true) end
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

--- BARRAS DE NAVEGAÇÃO (5 ABAS) ---
local tabs = {"Velocidade", "Pulo", "Giro", "Fly", "ESP"}
local tabButtons = {}
local tabFrames = {}

for i, tabName in ipairs(tabs) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.2, 0, 0, 25)
	btn.Position = UDim2.new((i - 1) * 0.2, 0, 0, 30)
	btn.Text = tabName
	btn.TextSize = 11
	btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Parent = frame
	tabButtons[tabName] = btn
	
	local contentFrame = Instance.new("Frame")
	contentFrame.Size = UDim2.new(1, 0, 1, -55)
	contentFrame.Position = UDim2.new(0, 0, 0, 55)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Visible = (i == 1)
	contentFrame.Parent = frame
	tabFrames[tabName] = contentFrame
end

-- Função para trocar de abas
for name, btn in pairs(tabButtons) do
	btn.MouseButton1Click:Connect(function()
		for tName, fFrame in pairs(tabFrames) do
			fFrame.Visible = (tName == name)
			tabButtons[tName].BackgroundColor3 = (tName == name) and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(40, 40, 40)
		end
	end)
end

--- FUNÇÕES AUXILIARES DE APLICAR ESTADOS ---
local function aplicarVelocidade(val)
	currentSpeed = val
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = val
	end
end

local function aplicarPulo(val)
	currentJumpPower = val
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.JumpPower = val
	end
end

local function aplicarGiro(estado)
	girando = estado
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		local giroAntigo = hrp:FindFirstChild("GiroRapido")
		if giroAntigo then giroAntigo:Destroy() end
		
		if girando then
			local giro = Instance.new("BodyAngularVelocity")
			giro.Name = "GiroRapido"
			giro.MaxTorque = Vector3.new(0, math.huge, 0)
			giro.AngularVelocity = Vector3.new(0, 60, 0)
			giro.Parent = hrp
		end
	end
end

local flyVelocity, flyGyro

local function aplicarFly(estado)
	flying = estado
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	
	if hrp then
		local oldVel = hrp:FindFirstChild("FlyVelocity")
		local oldGyro = hrp:FindFirstChild("FlyGyro")
		if oldVel then oldVel:Destroy() end
		if oldGyro then oldGyro:Destroy() end
		
		if flying then
			flyVelocity = Instance.new("BodyVelocity")
			flyVelocity.Name = "FlyVelocity"
			flyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			flyVelocity.Velocity = Vector3.new(0, 0, 0)
			flyVelocity.Parent = hrp
			
			flyGyro = Instance.new("BodyGyro")
			flyGyro.Name = "FlyGyro"
			flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
			flyGyro.CFrame = hrp.CFrame
			flyGyro.Parent = hrp
		end
	end
end

--- 1. ABA VELOCIDADE ---
local speedFrame = tabFrames["Velocidade"]
local textBoxSpeed = Instance.new("TextBox")
textBoxSpeed.Size = UDim2.new(0, 220, 0, 30)
textBoxSpeed.Position = UDim2.new(0, 20, 0, 10)
textBoxSpeed.PlaceholderText = "Digite a velocidade..."
textBoxSpeed.Text = ""
textBoxSpeed.Parent = speedFrame

local applySpeedBtn = Instance.new("TextButton")
applySpeedBtn.Size = UDim2.new(0, 220, 0, 30)
applySpeedBtn.Position = UDim2.new(0, 20, 0, 45)
applySpeedBtn.Text = "Aplicar Velocidade"
applySpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
applySpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applySpeedBtn.Parent = speedFrame

local velocidadesMacro = {18, 32, 50}
for i, vel in ipairs(velocidadesMacro) do
	local macroBtn = Instance.new("TextButton")
	macroBtn.Size = UDim2.new(0, 65, 0, 35)
	macroBtn.Position = UDim2.new(0, 20 + (i - 1) * 77, 0, 90)
	macroBtn.Text = tostring(vel)
	macroBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	macroBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	macroBtn.Parent = speedFrame
	
	macroBtn.MouseButton1Click:Connect(function()
		aplicarVelocidade(vel)
	end)
end

applySpeedBtn.MouseButton1Click:Connect(function()
	local novaVel = tonumber(textBoxSpeed.Text)
	if novaVel then
		aplicarVelocidade(novaVel)
	end
end)

--- 2. ABA PULO ---
local jumpFrame = tabFrames["Pulo"]
local textBoxJump = Instance.new("TextBox")
textBoxJump.Size = UDim2.new(0, 220, 0, 30)
textBoxJump.Position = UDim2.new(0, 20, 0, 10)
textBoxJump.PlaceholderText = "Digite a força do pulo..."
textBoxJump.Text = ""
textBoxJump.Parent = jumpFrame

local applyJumpBtn = Instance.new("TextButton")
applyJumpBtn.Size = UDim2.new(0, 220, 0, 30)
applyJumpBtn.Position = UDim2.new(0, 20, 0, 45)
applyJumpBtn.Text = "Aplicar Pulo"
applyJumpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
applyJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyJumpBtn.Parent = jumpFrame

local pulosMacro = {50, 100, 150}
for i, puloVal in ipairs(pulosMacro) do
	local macroBtn = Instance.new("TextButton")
	macroBtn.Size = UDim2.new(0, 65, 0, 35)
	macroBtn.Position = UDim2.new(0, 20 + (i - 1) * 77, 0, 90)
	macroBtn.Text = tostring(puloVal)
	macroBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	macroBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	macroBtn.Parent = jumpFrame
	
	macroBtn.MouseButton1Click:Connect(function()
		aplicarPulo(puloVal)
	end)
end

applyJumpBtn.MouseButton1Click:Connect(function()
	local novoPulo = tonumber(textBoxJump.Text)
	if novoPulo then
		aplicarPulo(novoPulo)
	end
end)

--- 3. ABA GIRO ---
local spinFrame = tabFrames["Giro"]
local spinBtn = Instance.new("TextButton")
spinBtn.Size = UDim2.new(0, 220, 0, 40)
spinBtn.Position = UDim2.new(0, 20, 0, 40)
spinBtn.Text = "Girar: DESLIGADO"
spinBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
spinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
spinBtn.Parent = spinFrame

spinBtn.MouseButton1Click:Connect(function()
	aplicarGiro(not girando)
	spinBtn.Text = girando and "Girar: LIGADO" or "Girar: DESLIGADO"
	spinBtn.BackgroundColor3 = girando and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

--- 4. ABA FLY ---
local flyFrame = tabFrames["Fly"]
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 220, 0, 40)
flyBtn.Position = UDim2.new(0, 20, 0, 40)
flyBtn.Text = "Fly: DESLIGADO"
flyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Parent = flyFrame

flyBtn.MouseButton1Click:Connect(function()
	aplicarFly(not flying)
	flyBtn.Text = flying and "Fly: LIGADO" or "Fly: DESLIGADO"
	flyBtn.BackgroundColor3 = flying and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

RunService.RenderStepped:Connect(function()
	if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = player.Character.HumanoidRootPart
		local camera = workspace.CurrentCamera
		if flyGyro and flyGyro.Parent then flyGyro.CFrame = camera.CFrame end
		
		local speed = 50
		local moveDir = Vector3.new()
		
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
		
		if flyVelocity and flyVelocity.Parent then flyVelocity.Velocity = moveDir * speed end
	end
end)

--- 5. ABA ESP ---
local espFrame = tabFrames["ESP"]
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0, 220, 0, 40)
espBtn.Position = UDim2.new(0, 20, 0, 40)
espBtn.Text = "ESP: DESLIGADO"
espBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.Parent = espFrame

local function adicionarESP(targetPlayer)
	if targetPlayer ~= player then
		targetPlayer.CharacterAdded:Connect(function(char)
			if espAtivo then
				task.wait(0.5)
				local highlight = Instance.new("Highlight")
				highlight.Name = "AERO_ESP"
				highlight.FillColor = Color3.fromRGB(255, 0, 0)
				highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				highlight.Parent = char
			end
		end)
		
		if targetPlayer.Character then
			local highlight = targetPlayer.Character:FindFirstChild("AERO_ESP") or Instance.new("Highlight")
			highlight.Name = "AERO_ESP"
			highlight.FillColor = Color3.fromRGB(255, 0, 0)
			highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
			highlight.Parent = targetPlayer.Character
		end
	end
end

espBtn.MouseButton1Click:Connect(function()
	espAtivo = not espAtivo
	espBtn.Text = espAtivo and "ESP: LIGADO" or "ESP: DESLIGADO"
	espBtn.BackgroundColor3 = espAtivo and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
	
	for _, p in ipairs(game.Players:GetPlayers()) do
		if espAtivo then
			adicionarESP(p)
		else
			if p.Character then
				local hl = p.Character:FindFirstChild("AERO_ESP")
				if hl then hl:Destroy() end
			end
		end
	end
end)

game.Players.PlayerAdded:Connect(function(p)
	if espAtivo then adicionarESP(p) end
end)

--- RENOVAÇÃO AUTOMÁTICA AO RENASCER (RESPAWN) ---
player.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid")
	task.wait(0.2)
	
	-- Re-aplica as modificações salvas no novo personagem
	if currentSpeed ~= 16 then aplicarVelocidade(currentSpeed) end
	if currentJumpPower ~= 50 then aplicarPulo(currentJumpPower) end
	if girando then aplicarGiro(true) end
	if flying then aplicarFly(true) end
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
