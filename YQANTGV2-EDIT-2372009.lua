local NEVERLOSE = loadstring(game:HttpGet("https://you.whimper.xyz/sources/ronix/ui.lua"))()



NEVERLOSE:Theme("dark")

local Window = NEVERLOSE:AddWindow("YQANTG Gui", "The Strongest Battleground")



-- Tabs and Sections

local MainTab = Window:AddTab("Misc", "home")

local MainSection = MainTab:AddSection("Misc", "left")



MainSection:AddButton("M1 Reach", function()

   loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/M1%20Reach%20Rework"))()

end)


MainSection:AddButton("Aimbot", function()

   loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Aimlock%20By%20YQANTG"))()
end)

MainSection:AddButton("Face Lock", function()

   loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/Tsb/FACELOCK"))()
end)

MainSection:AddButton("Block Aimlock", function()

   loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Block%20Aimlock"))()
end)

MainSection:AddButton("Orbit", function()

   loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Orbit%20by%20YQANTG"))()
end)

MainSection:AddButton("Fake Dash ( Q )", function()

   loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Fake%20Dash%20Q"))()
end)

MainSection:AddButton("No Slide Dash Endlag", function()

   loadstring(game:HttpGet("https://raw.githubusercontent.com/Slaphello/No-endlag-side-dash/refs/heads/main/No%20endlag%20side%20dash"))()
end)

MainSection:AddButton("Keyboard", function()

   loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/Delta-Scripts/refs/heads/main/MobileKeyboard.txt"))()
end)

local MainTab = Window:AddTab("Local", "folder")

local MainSection = MainTab:AddSection("Local", "left")

MainSection:AddButton("Fov", function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Kakuwhwbbanab"))()
end)


MainSection:AddButton("Aura + animation by Stoopid", function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV2/YQANTGV2/refs/heads/main/Aura"))()
end)

MainSection:AddButton("Goku Miui", function()
 loadstring(game:HttpGet("https://raw.githubusercontent.com/IdkRandomUsernameok/PublicAssets/refs/heads/main/Releases/MUI.lua"))()
end)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local auraOn = false
local auraHighlight = nil
local auraParticles = {}
local auraColorTime = 0
local auraLoop = nil

local function enableAura()
	-- ✅ Animation (có thể tạm bỏ nếu không cần)
	local success, err = pcall(function()
		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://114586157428274" -- kiểm tra ID thật có tồn tại
		local track = humanoid:LoadAnimation(anim)
		track:Play()
	end)

	-- ✅ Highlight
	auraHighlight = Instance.new("Highlight")
	auraHighlight.Adornee = char
	auraHighlight.FillTransparency = 1
	auraHighlight.OutlineTransparency = 0
	auraHighlight.OutlineColor = Color3.fromRGB(255, 0, 255)
	auraHighlight.Parent = char

	-- ✅ Particles
	for _, partName in pairs({"UpperTorso", "LowerTorso", "HumanoidRootPart"}) do
		local part = char:FindFirstChild(partName)
		if part then
			local att = Instance.new("Attachment", part)
			local particle = Instance.new("ParticleEmitter", att)
			particle.Name = "DarkAura"
			particle.Rate = 30
			particle.Lifetime = NumberRange.new(1.2, 2)
			particle.Speed = NumberRange.new(2, 5)
			particle.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 3), NumberSequenceKeypoint.new(1, 0) })
			particle.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1) })
			particle.Color = ColorSequence.new(Color3.fromRGB(15, 15, 15))
			particle.Rotation = NumberRange.new(0, 360)
			particle.RotSpeed = NumberRange.new(-90, 90)
			particle.SpreadAngle = Vector2.new(180, 180)
			particle.ZOffset = -1
			table.insert(auraParticles, particle)
		end
	end

	-- ✅ Rainbow Highlight
	auraLoop = game:GetService("RunService").RenderStepped:Connect(function(dt)
		if auraOn and auraHighlight then
			auraColorTime += dt * 0.25
			local r = math.sin(auraColorTime) * 127 + 128
			local g = math.sin(auraColorTime + 2) * 127 + 128
			local b = math.sin(auraColorTime + 4) * 127 + 128
			auraHighlight.OutlineColor = Color3.fromRGB(r, g, b)
		end
	end)
end

local function disableAura()
	if auraHighlight then
		auraHighlight:Destroy()
		auraHighlight = nil
	end
	for _, p in pairs(auraParticles) do
		if p then p:Destroy() end
	end
	auraParticles = {}

	if auraLoop then
		auraLoop:Disconnect()
		auraLoop = nil
	end
end

MainSection:AddToggle("Aura (Client)", false, function(state)
	auraOn = state
	if state then
		enableAura()
	else
		disableAura()
	end
end)

local player = game.Players.LocalPlayer
local targetAnimationId = "rbxassetid://10470389827"

local blockEnabled = false
local blockLoop = nil
local blockAnimConnection = nil
local respawnConnection = nil

-- Hàm ngăn block animation
local function stopBlockAnimations(humanoid)
	for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
		if track.Animation and track.Animation.AnimationId == targetAnimationId then
			track:Stop()
			track:Destroy()
		end
	end
end

-- BẬT block
local function enableBlock()
	local function setup(char)
		local hum = char:WaitForChild("Humanoid")

		-- Dọn kết nối cũ nếu có
		if blockAnimConnection then blockAnimConnection:Disconnect() end
		if blockLoop then task.cancel(blockLoop) end

		-- Theo dõi animation
		blockAnimConnection = hum.AnimationPlayed:Connect(function(track)
			if track.Animation and track.Animation.AnimationId == targetAnimationId then
				track:Stop()
				track:Destroy()
			end
		end)

		-- Vòng lặp xoá liên tục nếu animation bị phát lại
		blockLoop = task.spawn(function()
			while blockEnabled and hum.Parent do
				stopBlockAnimations(hum)
				task.wait(0.05)
			end
		end)
	end

	-- Gắn vào nhân vật hiện tại
	if player.Character then
		setup(player.Character)
	end

	-- Theo dõi khi respawn
	if respawnConnection then respawnConnection:Disconnect() end
	respawnConnection = player.CharacterAdded:Connect(function(char)
		if blockEnabled then
			setup(char)
		end
	end)
end

-- TẮT block
local function disableBlock()
	blockEnabled = false

	if blockAnimConnection then
		blockAnimConnection:Disconnect()
		blockAnimConnection = nil
	end
	if blockLoop then
		task.cancel(blockLoop)
		blockLoop = nil
	end
	if respawnConnection then
		respawnConnection:Disconnect()
		respawnConnection = nil
	end
end

-- ✅ Gắn vào toggle chuẩn
MainSection:AddToggle("Invisible Block", false, function(state)
	blockEnabled = state
	if state then
		enableBlock()
	else
		disableBlock()
	end
end)

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

local noStunConnection = nil

local function enableNoStun()
	if noStunConnection then return end -- tránh trùng kết nối

	noStunConnection = runService.RenderStepped:Connect(function()
		local char = player.Character
		if not char then return end

		-- Xoá trạng thái Stunned
		local stunned = char:FindFirstChild("Stunned")
		if stunned then
			stunned:Destroy()
		end

		-- Hủy PlatformStand + Fix WalkSpeed
		local hum = char:FindFirstChild("Humanoid")
		if hum then
			hum.PlatformStand = false
			if hum.WalkSpeed == 0 then
				hum.WalkSpeed = 16
			end
		end
	end)
end

local function disableNoStun()
	if noStunConnection then
		noStunConnection:Disconnect()
		noStunConnection = nil
	end
end

MainSection:AddToggle("No Stun", false, function(state)
	if state then
		enableNoStun()
	else
		disableNoStun()
	end
end)

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

local noSlowedConnection = nil

local function enableNoSlowed()
	if noSlowedConnection then return end -- Tránh trùng

	noSlowedConnection = runService.RenderStepped:Connect(function()
		local char = player.Character
		if not char then return end

		local hum = char:FindFirstChild("Humanoid")
		if hum then
			if hum.WalkSpeed < 20 then
				hum.WalkSpeed = 20
			end
			hum.PlatformStand = false
		end
	end)
end

local function disableNoSlowed()
	if noSlowedConnection then
		noSlowedConnection:Disconnect()
		noSlowedConnection = nil
	end
end

MainSection:AddToggle("No Slowed", false, function(state)
	if state then
		enableNoSlowed()
	else
		disableNoSlowed()
	end
end)

MainSection:AddToggle("No Anim Ult", false, function(state)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local lp = Players.LocalPlayer
    local blockAnimEnabled = state

    local blockedIds = {
        "12447707844",
        "12342141464",
        "12772543293"
    }

    local function isBlocked(animationId)
        for _, id in pairs(blockedIds) do
            if animationId:find(id) then
                return true
            end
        end
        return false
    end

    if _G.BlockAnimConnection then
        _G.BlockAnimConnection:Disconnect()
        _G.BlockAnimConnection = nil
    end

    if state then
        _G.BlockAnimConnection = RunService.Stepped:Connect(function()
            local char = lp.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local animator = humanoid:FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        local anim = track.Animation
                        if anim and isBlocked(anim.AnimationId) then
                            track:Stop(0)
                            pcall(function() track:Destroy() end)
                            print("🚫 Dừng animation bị chặn: " .. anim.AnimationId)
                        end
                    end
                end
            end
        end)
    end
end)

MainSection:AddToggle("Face Camera Y", false, function(enabled)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")

    local lp = Players.LocalPlayer
    local cam = Workspace.CurrentCamera

    if _G.FaceCamConnection then
        _G.FaceCamConnection:Disconnect()
        _G.FaceCamConnection = nil
    end

    if enabled then
        _G.FaceCamConnection = RunService.RenderStepped:Connect(function()
            local char = lp.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local camLook = cam.CFrame.LookVector
            local lookDir = Vector3.new(camLook.X, 0, camLook.Z).Unit

            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + lookDir)
        end)
    end
end)

MainSection:AddToggle("Ultra Shader", false, function(state)
	local Lighting = game:GetService("Lighting")
	local Players = game:GetService("Players")
	local Workspace = game:GetService("Workspace")
	local RunService = game:GetService("RunService")
	local Camera = Workspace.CurrentCamera

	local LocalPlayer = Players.LocalPlayer
	local shaderOn = state
	local bloom, sunrays, cc, sky, atmo
	local reflectionModel

	local motionBlur = Instance.new("BlurEffect")
	motionBlur.Name = "MotionBlur"
	motionBlur.Size = 5
	motionBlur.Parent = Lighting

	local lastLookVector = Camera.CFrame.LookVector

	local motionConnection = RunService.RenderStepped:Connect(function()
		local currentLook = Camera.CFrame.LookVector
		local delta = (currentLook - lastLookVector).Magnitude
		lastLookVector = currentLook

		local rightVector = Camera.CFrame.RightVector
		local angleOffset = math.abs(currentLook:Dot(rightVector))
		local blurAmount = math.clamp(angleOffset * delta * 800, 0, 40)

		motionBlur.Size = shaderOn and (blurAmount + 4) or blurAmount
	end)

	local function setupSky()
		sky = Instance.new("Sky", Lighting)
		sky.SkyboxBk = "rbxassetid://7115316513"
		sky.SkyboxDn = "rbxassetid://7115316904"
		sky.SkyboxFt = "rbxassetid://7115317252"
		sky.SkyboxLf = "rbxassetid://7115317606"
		sky.SkyboxRt = "rbxassetid://7115317973"
		sky.SkyboxUp = "rbxassetid://7115318319"
		sky.SunAngularSize = 21
		sky.MoonAngularSize = 11
		sky.StarCount = 3000
	end

	local function setupLightAndHighlight(model)
		if not model:IsA("Model") then return end
		local root = model:FindFirstChild("HumanoidRootPart")

		if not model:FindFirstChild("AutoHL") then
			local hl = Instance.new("Highlight", model)
			hl.Name = "AutoHL"
			hl.FillColor = Color3.fromRGB(255, 255, 255)
			hl.OutlineColor = Color3.new(0, 0, 0)
			hl.OutlineTransparency = 0.5
			hl.FillTransparency = 1
		end

		if root and not root:FindFirstChild("NightLight") then
			local light = Instance.new("PointLight", root)
			light.Name = "NightLight"
			light.Color = Color3.new(1, 1, 0.9)
			light.Range = 12
			light.Brightness = 0
			light.Enabled = true
		end
	end

	local function applyShader()
		Lighting.ClockTime = 17
		Lighting.Brightness = 3
		Lighting.GlobalShadows = true
		Lighting.OutdoorAmbient = Color3.fromRGB(135, 148, 178)
		Lighting.FogEnd = 800
		Lighting.FogStart = 0
		Lighting.FogColor = Color3.fromRGB(200, 220, 250)

		setupSky()

		bloom = Instance.new("BloomEffect", Lighting)
		bloom.Intensity = 2.6
		bloom.Size = 100
		bloom.Threshold = 1

		sunrays = Instance.new("SunRaysEffect", Lighting)
		sunrays.Intensity = 0.55
		sunrays.Spread = 2.2

		cc = Instance.new("ColorCorrectionEffect", Lighting)
		cc.Brightness = 0.18
		cc.Contrast = 0.2
		cc.Saturation = 0.3
		cc.TintColor = Color3.fromRGB(255, 230, 180)

		atmo = Instance.new("Atmosphere", Lighting)
		atmo.Density = 0.30
		atmo.Offset = 0.8
		atmo.Glare = 0.3
		atmo.Haze = 1.5
		atmo.Color = Color3.fromRGB(200, 220, 255)
		atmo.Decay = Color3.fromRGB(180, 190, 290)

		local sun = Instance.new("Part")
		sun.Name = "FakeSun"
		sun.Size = Vector3.new(15, 15, 15)
		sun.Shape = Enum.PartType.Ball
		sun.Anchored = true
		sun.CanCollide = true
		sun.Material = Enum.Material.Neon
		sun.Color = Color3.fromRGB(255, 240, 180)
		sun.Position = Camera.CFrame.Position + Vector3.new(0, 300, 500)
		sun.Parent = workspace

		local light = Instance.new("SurfaceLight", sun)
		light.Brightness = 3
		light.Range = 100
		light.Angle = 180
		light.Face = Enum.NormalId.Top
		light.Color = Color3.fromRGB(255, 220, 150)

		local beam = Instance.new("ParticleEmitter", sun)
		beam.LightEmission = 10
		beam.LightInfluence = 10
		beam.Texture = "rbxassetid://259703948"
		beam.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 6), NumberSequenceKeypoint.new(1, 0)})
		beam.Transparency = NumberSequence.new(0.1)
		beam.Rate = 100
		beam.Speed = NumberRange.new(0)
		beam.Lifetime = NumberRange.new(1)
		beam.Color = ColorSequence.new(Color3.fromRGB(255, 220, 150))

		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		reflectionModel = character:Clone()
		reflectionModel.Name = "Reflection"
		reflectionModel.Parent = workspace

		for _, part in ipairs(reflectionModel:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Anchored = true
				part.CanCollide = false
				part.Material = Enum.Material.SmoothPlastic
				part.Transparency = 0.4
			end
		end

		task.spawn(function()
			while shaderOn and reflectionModel and reflectionModel.Parent do
				local root = character:FindFirstChild("HumanoidRootPart")
				local refRoot = reflectionModel:FindFirstChild("HumanoidRootPart")
				if root and refRoot then
					reflectionModel:SetPrimaryPartCFrame(CFrame.new(Vector3.new(root.Position.X, -root.Position.Y + 1, root.Position.Z)) * CFrame.Angles(math.rad(180), 0, 0))
				end
				task.wait(0.03)
			end
		end)

		local function onCharacterAdded(char)
			task.wait(1)
			setupLightAndHighlight(char)
		end

		onCharacterAdded(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())
		LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

		for _, model in pairs(workspace.Live:GetChildren()) do
			setupLightAndHighlight(model)
			model.AncestryChanged:Connect(function()
				if model:IsDescendantOf(workspace) then
					task.wait(1)
					setupLightAndHighlight(model)
				end
			end)
		end

		workspace.Live.ChildAdded:Connect(function(model)
			task.wait(1)
			setupLightAndHighlight(model)
		end)
	end

	local function removeShader()
		Lighting.ClockTime = 10
		Lighting.Brightness = 1.2
		Lighting.FogEnd = 100000
		Lighting.GlobalShadows = true
		Lighting.OutdoorAmbient = Color3.fromRGB(128, 118, 148)

		for _, v in pairs(Lighting:GetChildren()) do
			if v:IsA("BloomEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect")
			or v:IsA("Sky") or v:IsA("Atmosphere") then
				v:Destroy()
			end
		end

		if workspace:FindFirstChild("FakeSun") then
			workspace.FakeSun:Destroy()
		end
		if reflectionModel then
			reflectionModel:Destroy()
		end
	end

	if shaderOn then
		applyShader()
	else
		removeShader()
	end

	task.spawn(function()
		while shaderOn do
			for _, model in pairs(workspace.Live:GetChildren()) do
				if model:IsA("Model") then
					local hl = model:FindFirstChild("AutoHL")
					local root = model:FindFirstChild("HumanoidRootPart")
					local light = root and root:FindFirstChild("NightLight")
					local isNight = Lighting.ClockTime >= 18 or Lighting.ClockTime < 6

					if hl then
						hl.FillTransparency = isNight and math.clamp(hl.FillTransparency - 0.05, 0.1, 1) or math.clamp(hl.FillTransparency + 0.05, 0.1, 1)
						hl.OutlineTransparency = isNight and math.clamp(hl.OutlineTransparency - 0.05, 0.1, 1) or math.clamp(hl.OutlineTransparency + 0.05, 0.1, 1)
					end

					if light then
						light.Brightness = isNight and math.clamp(light.Brightness + 0.1, 0, 2) or math.clamp(light.Brightness - 0.1, 0, 2)
					end
				end
			end

			local char = LocalPlayer.Character
			if char then setupLightAndHighlight(char) end

			task.wait(0.3)
		end
	end)

	task.spawn(function()
		local phase = 0
		local clockValues = {5, 8, 12, 15, 18, 20, 23, 1}
		local phaseTime = 30

		while shaderOn do
			local target = clockValues[(phase % #clockValues) + 1]
			local nextTarget = clockValues[((phase + 1) % #clockValues) + 1]

			for t = 0, 1, 1 / (phaseTime * 10) do
				local smooth = target + (nextTarget - target) * t
				Lighting.ClockTime = smooth
				task.wait(0.1)
			end

			phase += 1
		end
	end)
end)

local MainTab = Window:AddTab("Esp", "folder")

local MainSection = MainTab:AddSection("Esp Player", "left")

local player = game.Players.LocalPlayer
local espEnabled = false
local espLabels = {}

local function createESP(plr)
	if plr == player or espLabels[plr] then return end
	local char = plr.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	if not head then return end

	local gui = Instance.new("BillboardGui")
	gui.Name = "NameESP"
	gui.Size = UDim2.new(0, 100, 0, 20)
	gui.StudsOffset = Vector3.new(0, 2.5, 0)
	gui.AlwaysOnTop = true
	gui.Adornee = head
	gui.Parent = head

	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1, 0, 1, 0)
	text.BackgroundTransparency = 1
	text.Text = plr.Name
	text.TextColor3 = Color3.fromRGB(100, 255, 255)
	text.TextStrokeTransparency = 0.2
	text.Font = Enum.Font.GothamBold
	text.TextScaled = true
	text.Parent = gui

	espLabels[plr] = gui
end

local function updateESP()
	for _, p in ipairs(game.Players:GetPlayers()) do
		if not espLabels[p] and p.Character then
			createESP(p)
		end
	end
end

local espLoop = nil

local function enableESP()
	updateESP()
	espLoop = game:GetService("RunService").RenderStepped:Connect(function()
		if not espEnabled then return end
		updateESP()
	end)
end

local function disableESP()
	if espLoop then espLoop:Disconnect() espLoop = nil end
	for _, gui in pairs(espLabels) do
		if gui then gui:Destroy() end
	end
	espLabels = {}
end

MainSection:AddToggle("ESP Name", false, function(state)
	espEnabled = state
	if state then
		enableESP()
	else
		disableESP()
	end
end)

local player = game.Players.LocalPlayer
local highlightEnabled = false
local highlights = {}

local function createHighlight(plr)
	if plr == player or highlights[plr] then return end
	local char = plr.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local hl = Instance.new("Highlight")
	hl.Name = "OutlineESP"
	hl.FillTransparency = 1
	hl.OutlineColor = Color3.fromRGB(255, 0, 0)
	hl.OutlineTransparency = 0
	hl.Adornee = char
	hl.Parent = char

	highlights[plr] = hl
end

local function updateHighlight()
	for _, p in ipairs(game.Players:GetPlayers()) do
		if not highlights[p] and p.Character then
			createHighlight(p)
		end
	end
end

local highlightLoop = nil

local function enableHighlight()
	updateHighlight()
	highlightLoop = game:GetService("RunService").RenderStepped:Connect(function()
		if not highlightEnabled then return end
		updateHighlight()
	end)
end

local function disableHighlight()
	if highlightLoop then highlightLoop:Disconnect() highlightLoop = nil end
	for _, hl in pairs(highlights) do
		if hl then hl:Destroy() end
	end
	highlights = {}
end

MainSection:AddToggle("Highlight", false, function(state)
	highlightEnabled = state
	if state then
		enableHighlight()
	else
		disableHighlight()
	end
end)

local player = game.Players.LocalPlayer
local torsoBoxEnabled = false
local boxes = {}

local function createBox(plr)
	if plr == player or boxes[plr] then return end
	local char = plr.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local box = Instance.new("BoxHandleAdornment")
	box.Adornee = hrp
	box.AlwaysOnTop = true
	box.ZIndex = 10
	box.Size = Vector3.new(2, 2, 1)
	box.Color3 = Color3.fromRGB(170, 0, 255)
	box.Transparency = 0.2
	box.Name = "TorsoBox"
	box.Parent = hrp

	boxes[plr] = box
end

local function updateBox()
	for _, p in ipairs(game.Players:GetPlayers()) do
		if not boxes[p] and p.Character then
			createBox(p)
		end
	end
end

local boxLoop = nil

local function enableBoxes()
	updateBox()
	boxLoop = game:GetService("RunService").RenderStepped:Connect(function()
		if not torsoBoxEnabled then return end
		updateBox()
	end)
end

local function disableBoxes()
	if boxLoop then boxLoop:Disconnect() boxLoop = nil end
	for _, box in pairs(boxes) do
		if box then box:Destroy() end
	end
	boxes = {}
end

MainSection:AddToggle("Show Torso", false, function(state)
	torsoBoxEnabled = state
	if state then
		enableBoxes()
	else
		disableBoxes()
	end
end)

local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local guiConnection = nil
local playerCountLabel = nil
local screenGui = nil

-- Tạo GUI và hiệu ứng xuất hiện
local function createPlayerCountGUI()
	if screenGui then return end -- Tránh tạo lại nếu đã có

	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "PlayerCountGui"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.Parent = player:WaitForChild("PlayerGui")

	playerCountLabel = Instance.new("TextLabel")
	playerCountLabel.Size = UDim2.new(0, 220, 0, 50)
	playerCountLabel.Position = UDim2.new(0.5, -100, 0, 50)
	playerCountLabel.BackgroundTransparency = 1
	playerCountLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
	playerCountLabel.TextStrokeTransparency = 0.2
	playerCountLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	playerCountLabel.TextScaled = true
	playerCountLabel.Font = Enum.Font.GothamBlack
	playerCountLabel.TextTransparency = 1
	playerCountLabel.Text = "Players: " .. #game.Players:GetPlayers()
	playerCountLabel.Parent = screenGui

	local tween = TweenService:Create(playerCountLabel, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextTransparency = 0
	})
	tween:Play()

	guiConnection = RunService.RenderStepped:Connect(function()
		if playerCountLabel then
			playerCountLabel.Text = "Players: " .. #game.Players:GetPlayers()
		end
	end)
end

-- Xoá GUI và kết nối
local function removePlayerCountGUI()
	if guiConnection then
		guiConnection:Disconnect()
		guiConnection = nil
	end
	if playerCountLabel then
		playerCountLabel:Destroy()
		playerCountLabel = nil
	end
	if screenGui then
		screenGui:Destroy()
		screenGui = nil
	end
end

-- ✅ Gắn vào toggle UI
MainSection:AddToggle("Show Count", false, function(state)
	if state then
		createPlayerCountGUI()
	else
		removePlayerCountGUI()
	end
end)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local toolEspMap = {
	["Flowing Water"] = {"Garou", Color3.fromRGB(0, 170, 255)},
	["Crushed Rock"] = {"Garou", Color3.fromRGB(0, 170, 255)},
	["Normal Punch"] = {"Saitama", Color3.fromRGB(139, 69, 19)},
	["Serious Punch"] = {"Saitama", Color3.fromRGB(139, 69, 19)},
	["Binding Cloth"] = {"Monster Form", Color3.fromRGB(255, 0, 0)},
	["Beatdown"] = {"Brutal Demon", Color3.fromRGB(255, 255, 255)},
	["Death Blow"] = {"Brutal Demon", Color3.fromRGB(255, 255, 255)},
	["Blitz Shot"] = {"Cyborg", Color3.fromRGB(255, 140, 0)},
	["Flamewave Cannon"] = {"Cyborg", Color3.fromRGB(255, 140, 0)},
	["Explosive Shuriken"] = {"Sonic", Color3.fromRGB(255, 105, 180)},
	["Carnage"] = {"Sonic", Color3.fromRGB(255, 105, 180)},
	["Atmos Cleave"] = {"Blade Master", Color3.fromRGB(255, 255, 0)},
	["Atomic Slash"] = {"Blade Master", Color3.fromRGB(255, 255, 0)},
	["Crushing Pull"] = {"Tatsumaki", Color3.fromRGB(0, 255, 0)},
	["Psychic Ricochet"] = {"Tatsumaki", Color3.fromRGB(0, 255, 0)},
	["Bullet Barrage"] = {"Martial Artist", Color3.fromRGB(128, 0, 128)},
	["Earth Splitting Strike"] = {"Martial Artist", Color3.fromRGB(128, 0, 128)},
}

local espFolder = Instance.new("Folder", Workspace)
espFolder.Name = "DynamicESP"

local espEnabled = false
local charConnections = {}
local refreshLoop

local function getEspData(player)
	local backpack = player:FindFirstChildOfClass("Backpack")
	if not backpack then return "Tech Prodigy", Color3.fromRGB(200, 200, 200) end

	for toolName, data in pairs(toolEspMap) do
		if backpack:FindFirstChild(toolName) then
			return data[1], data[2]
		end
	end
	return "Tech Prodigy", Color3.fromRGB(200, 200, 200)
end

local function createESP(player, labelText, color)
	local char = player.Character
	if not char or not char:FindFirstChild("Head") then return end
	if espFolder:FindFirstChild(player.Name) then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = player.Name
	billboard.Adornee = char.Head
	billboard.Size = UDim2.new(0, 100, 0, 20)
	billboard.StudsOffset = Vector3.new(3.5, 0.5, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = espFolder

	local label = Instance.new("TextLabel", billboard)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = color
	label.Font = Enum.Font.GothamBold
	label.TextScaled = false
	label.TextSize = 12
	label.TextStrokeTransparency = 0.6
	label.TextTransparency = 1

	TweenService:Create(label, TweenInfo.new(0.3), {
		TextTransparency = 0,
		TextStrokeTransparency = 0.3
	}):Play()
end

local function clearAllESP()
	for _, v in ipairs(espFolder:GetChildren()) do
		v:Destroy()
	end
end

local function updateESPForPlayer(player)
	if player == LocalPlayer then return end
	if not player.Character or not player.Character:FindFirstChild("Head") then return end
	local labelText, color = getEspData(player)
	createESP(player, labelText, color)
end

local function refreshAll()
	clearAllESP()
	for _, p in ipairs(Players:GetPlayers()) do
		updateESPForPlayer(p)
	end
end

MainSection:AddToggle("Esp Character", false, function(state)
	espEnabled = state

	if espEnabled then
		refreshAll()

		for _, conn in pairs(charConnections) do
			if conn then conn:Disconnect() end
		end
		charConnections = {}

		for _, player in pairs(Players:GetPlayers()) do
			local conn = player.CharacterAdded:Connect(function()
				if espEnabled then
					task.wait(1)
					updateESPForPlayer(player)
				end
			end)
			table.insert(charConnections, conn)
		end

		local conn = Players.PlayerAdded:Connect(function(player)
			local sub = player.CharacterAdded:Connect(function()
				if espEnabled then
					task.wait(1)
					updateESPForPlayer(player)
				end
			end)
			table.insert(charConnections, sub)
		end)
		table.insert(charConnections, conn)

		refreshLoop = task.spawn(function()
			while espEnabled do
				refreshAll()
				task.wait(2)
			end
		end)
	else
		clearAllESP()
		for _, conn in pairs(charConnections) do
			if conn then conn:Disconnect() end
		end
		charConnections = {}

		if refreshLoop then
			task.cancel(refreshLoop)
			refreshLoop = nil
		end
	end
end)

local MainTab = Window:AddTab("Dummy", "folder")

local MainSection = MainTab:AddSection("Dummy", "left")


local npcHighlights = {}
local npcConnections = {}
local npcLoop = nil

MainSection:AddToggle("Highlight", false, function(state)
	if state then
		local liveFolder = workspace:FindFirstChild("Live")
		if not liveFolder then return end

		-- Hàm tạo highlight cho 1 NPC
		local function highlightNPC(model)
			if npcHighlights[model] then return end
			if not model:IsA("Model") or not model:FindFirstChild("HumanoidRootPart") then return end

			local highlight = Instance.new("Highlight")
			highlight.Adornee = model
			highlight.FillTransparency = 1
			highlight.OutlineTransparency = 0
			highlight.OutlineColor = Color3.fromRGB(170, 0, 255)
			highlight.Name = "NPC_Highlight"
			highlight.Parent = model

			npcHighlights[model] = highlight
		end

		-- Highlight NPC có sẵn
		for _, model in pairs(liveFolder:GetChildren()) do
			if model:IsA("Model") and model.Name == "Weakest Dummy" then
				highlightNPC(model)
			end
		end

		-- Theo dõi NPC mới thêm
		table.insert(npcConnections, liveFolder.ChildAdded:Connect(function(child)
			if child:IsA("Model") and child.Name == "Weakest Dummy" then
				repeat task.wait() until child:FindFirstChild("HumanoidRootPart")
				highlightNPC(child)
			end
		end))

		-- Cập nhật liên tục nếu sót
		npcLoop = game:GetService("RunService").RenderStepped:Connect(function()
			for _, model in pairs(liveFolder:GetChildren()) do
				if model:IsA("Model") and model.Name == "Weakest Dummy" and not npcHighlights[model] then
					highlightNPC(model)
				end
			end
		end)

	else
		-- Xoá tất cả highlight
		for _, h in pairs(npcHighlights) do
			if h then h:Destroy() end
		end
		npcHighlights = {}

		for _, conn in pairs(npcConnections) do
			if conn then conn:Disconnect() end
		end
		npcConnections = {}

		if npcLoop then
			npcLoop:Disconnect()
			npcLoop = nil
		end
	end
end)

local npcNameTags = {}
local npcNameConnections = {}
local npcLoop = nil

MainSection:AddToggle("Show Name", false, function(state)
	if state then
		local live = workspace:FindFirstChild("Live")
		if not live then return end

		-- Tạo tag tên
		local function addNameTag(npc)
			if npcNameTags[npc] then return end
			local hrp = npc:FindFirstChild("HumanoidRootPart")
			if not hrp then return end

			local billboard = Instance.new("BillboardGui")
			billboard.Name = "NameTag"
			billboard.Size = UDim2.new(0, 100, 0, 25)
			billboard.Adornee = hrp
			billboard.AlwaysOnTop = true
			billboard.StudsOffset = Vector3.new(0, 3.5, 0)
			billboard.Parent = npc

			local textLabel = Instance.new("TextLabel")
			textLabel.Size = UDim2.new(1, 0, 1, 0)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = npc.Name
			textLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
			textLabel.TextStrokeTransparency = 0.2
			textLabel.TextScaled = true
			textLabel.Font = Enum.Font.GothamBold
			textLabel.Parent = billboard

			npcNameTags[npc] = billboard
		end

		-- Thêm tên cho NPC có sẵn
		for _, npc in pairs(live:GetChildren()) do
			if npc:IsA("Model") and npc.Name == "Weakest Dummy" then
				addNameTag(npc)
			end
		end

		-- NPC mới vào
		table.insert(npcNameConnections, live.ChildAdded:Connect(function(npc)
			if npc:IsA("Model") and npc.Name == "Weakest Dummy" then
				task.wait(0.2)
				addNameTag(npc)
			end
		end))

		-- Cập nhật liên tục để không bỏ sót
		npcLoop = game:GetService("RunService").RenderStepped:Connect(function()
			for _, npc in pairs(live:GetChildren()) do
				if npc:IsA("Model") and npc.Name == "Weakest Dummy" and not npcNameTags[npc] then
					addNameTag(npc)
				end
			end
		end)

	else
		-- Xoá tên
		for _, tag in pairs(npcNameTags) do
			if tag then tag:Destroy() end
		end
		npcNameTags = {}

		for _, conn in ipairs(npcNameConnections) do
			if conn then conn:Disconnect() end
		end
		npcNameConnections = {}

		if npcLoop then
			npcLoop:Disconnect()
			npcLoop = nil
		end
	end
end)

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local orbitConnection = nil
local angle = 0

MainSection:AddToggle("Orbit NPC", false, function(state)
	if state then
		angle = 0
		orbitConnection = runService.RenderStepped:Connect(function(dt)
			local char = player.Character
			if not char or not char:FindFirstChild("HumanoidRootPart") then return end
			local hrp = char.HumanoidRootPart

			local live = workspace:FindFirstChild("Live")
			if not live then return end

			local closest
			local shortest = math.huge
			local myPos = hrp.Position

			for _, npc in pairs(live:GetChildren()) do
				if npc:IsA("Model") and npc.Name == "Weakest Dummy" and npc:FindFirstChild("HumanoidRootPart") then
					local dist = (npc.HumanoidRootPart.Position - myPos).Magnitude
					if dist < shortest then
						shortest = dist
						closest = npc
					end
				end
			end

			if not closest or not closest:FindFirstChild("HumanoidRootPart") then return end
			local npcHRP = closest.HumanoidRootPart
			local center = npcHRP.Position

			-- Cập nhật orbit
			angle += dt * 2
			local radius = 5
			local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
			local goalPos = center + offset

			-- Nhân vật luôn xoay về NPC
			local newCFrame = CFrame.new(goalPos, center)
			hrp.CFrame = newCFrame
		end)
	else
		if orbitConnection then
			orbitConnection:Disconnect()
			orbitConnection = nil
		end
	end
end)

local player = game.Players.LocalPlayer
local tweenService = game:GetService("TweenService")

-- Tìm Weakest Dummy gần nhất
local function getClosestDummy()
	local live = workspace:FindFirstChild("Live")
	if not live then return nil end

	local myChar = player.Character
	if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
	local myPos = myChar.HumanoidRootPart.Position

	local closest = nil
	local shortest = math.huge

	for _, npc in pairs(live:GetChildren()) do
		if npc:IsA("Model") and npc.Name == "Weakest Dummy" and npc:FindFirstChild("HumanoidRootPart") then
			local dist = (npc.HumanoidRootPart.Position - myPos).Magnitude
			if dist < shortest then
				shortest = dist
				closest = npc
			end
		end
	end

	return closest
end

-- ✅ Gắn vào Button kiểu MainSection
MainSection:AddButton("Tween To Dummy", function()
	local myChar = player.Character
	if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
	local myHRP = myChar.HumanoidRootPart

	local npc = getClosestDummy()
	if npc and npc:FindFirstChild("HumanoidRootPart") then
		local targetPos = npc.HumanoidRootPart.Position
		local finalPos = Vector3.new(targetPos.X, myHRP.Position.Y, targetPos.Z)

		-- Giữ nguyên hướng nhìn bằng CFrame
		local currentRot = myHRP.CFrame - myHRP.Position
		local goalCFrame = CFrame.new(finalPos) * currentRot

		local tween = tweenService:Create(myHRP, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {
			CFrame = goalCFrame
		})
		tween:Play()
	end
end)

local player = game.Players.LocalPlayer

-- Tìm Weakest Dummy gần nhất
local function getClosestDummy()
	local live = workspace:FindFirstChild("Live")
	if not live then return nil end

	local myChar = player.Character
	if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
	local myPos = myChar.HumanoidRootPart.Position

	local closest = nil
	local shortest = math.huge

	for _, npc in pairs(live:GetChildren()) do
		if npc:IsA("Model") and npc.Name == "Weakest Dummy" and npc:FindFirstChild("HumanoidRootPart") then
			local dist = (npc.HumanoidRootPart.Position - myPos).Magnitude
			if dist < shortest then
				shortest = dist
				closest = npc
			end
		end
	end

	return closest
end

-- ✅ Gắn vào button chuẩn định dạng
MainSection:AddButton("Teleport To Dummy", function()
	local myChar = player.Character
	if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
	local myHRP = myChar.HumanoidRootPart

	local npc = getClosestDummy()
	if npc and npc:FindFirstChild("HumanoidRootPart") then
		local targetPos = npc.HumanoidRootPart.Position
		local newPos = Vector3.new(targetPos.X, myHRP.Position.Y, targetPos.Z)

		-- Giữ nguyên góc nhìn hiện tại
		local currentRot = myHRP.CFrame - myHRP.Position
		myHRP.CFrame = CFrame.new(newPos) * currentRot
	end
end)

local MainTab = Window:AddTab("Tech", "list")

local MainSection = MainTab:AddSection("Tech", "left")


MainSection:AddButton("M1 Reset", function()

   getgenv().keybinds = {
            m1reset = Enum.KeyCode.R,
            emotedash = Enum.KeyCode.T,
            rotation = Enum.KeyCode.H
        }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Slaphello/M1-Reset-And-Emote-Dash-TSB-OLD-/refs/heads/main/M1R%26ED%20TSB"))()
end)

MainSection:AddButton("Auto Kyoto", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Auto%20kyoto%20ma%20hoa"))()
end)

MainSection:AddButton("Loop Dash", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Loop%20Dash%20Rework%20Script%20Real"))()
end)

MainSection:AddButton("Lethal Dash", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Lethal%20Dash%20Script"))()
end)

MainSection:AddButton("Tornado Tech", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Idk%20lolololol"))()
end)

MainSection:AddButton("Oreo Rework", function()

   loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Oreo%20rework"))()

end)

MainSection:AddButton("Supa Tech", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Supa%20tech%20script"))()
end)

MainSection:AddButton("Supa Tech V2", function()

   loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV2/YQANTGV2/refs/heads/main/TEST"))()
end)

MainSection:AddButton("BackDash (Mobile)", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/BackDash%20Tech"))()
end)

MainSection:AddButton("BackDash (PC)", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/BackDash%20For%20Pc"))()
end)

local MainTab = Window:AddTab("Auto", "list")

local MainSection = MainTab:AddSection("Auto Tech + More...", "left")

MainSection:AddButton("Auto Upper Punch", function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV2/YQANTGV2/refs/heads/main/Upper"))()
end)

MainSection:AddButton("Auto Block By ( Notpaki )", function()

   loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/TSB/refs/heads/main/CombatGui"))()

end)

MainSection:AddButton("Auto Block V2 By ( YQANTG )", function()

   loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/YQANTG-/refs/heads/main/AUTOBLOCKV2.lua.txt"))()
end)

local player = game.Players.LocalPlayer
local cooldown = false
local animationConnection
local charAddedConnection
local animationId = "rbxassetid://13294471966"
local delayBeforeRemote = 0.23

-- Gửi remote dash
local function useRemote()
	local args = {
		[1] = {
			["Dash"] = Enum.KeyCode.W,
			["Key"] = Enum.KeyCode.Q,
			["Goal"] = "KeyPress"
		}
	}
	local char = player.Character
	if char and char:FindFirstChild("Communicate") then
		char.Communicate:FireServer(unpack(args))
	end
end

-- Lùi lại
local function stepBack()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 3)
	end
end

-- Gắn phát hiện animation
local function bindAnimationDetection()
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")

	animationConnection = humanoid.AnimationPlayed:Connect(function(track)
		if track.Animation and track.Animation.AnimationId == animationId and not cooldown then
			cooldown = true
			task.delay(delayBeforeRemote, function()
				stepBack()
				useRemote()
			end)
			task.delay(5, function()
				cooldown = false
			end)
		end
	end)
end

-- ✅ Gắn vào toggle chuẩn Orion MainSection
MainSection:AddToggle("Auto Twisted", false, function(state)
	if state then
		bindAnimationDetection()
		charAddedConnection = player.CharacterAdded:Connect(function()
			task.wait(1)
			bindAnimationDetection()
		end)
	else
		if animationConnection then
			animationConnection:Disconnect()
			animationConnection = nil
		end
		if charAddedConnection then
			charAddedConnection:Disconnect()
			charAddedConnection = nil
		end
	end
end)

local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local cam = workspace.CurrentCamera
local animationId = "rbxassetid://13294471966"
local debounce = false
local animConnection
local charConnection

-- Swipe và Dash
local function swipeAndDash()
	print("✅ Swipe + Dash Triggered")

	local args = {
		[1] = {
			["Dash"] = Enum.KeyCode.W,
			["Key"] = Enum.KeyCode.Q,
			["Goal"] = "KeyPress"
		}
	}
	local char = player.Character
	if char and char:FindFirstChild("Communicate") then
		char.Communicate:FireServer(unpack(args))
	end

	local startCFrame = cam.CFrame
	local leftCFrame = startCFrame * CFrame.Angles(40, math.rad(-90), 180)

	cam.CameraType = Enum.CameraType.Scriptable
	local tween1 = TweenService:Create(cam, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {CFrame = leftCFrame})
	tween1:Play()
	tween1.Completed:Wait()

	wait(0.00001)
	local tween2 = TweenService:Create(cam, TweenInfo.new(0.001, Enum.EasingStyle.Sine), {CFrame = startCFrame})
	tween2:Play()
	tween2.Completed:Wait()

	wait(0.1)
	local angledCFrame = startCFrame * CFrame.Angles(math.rad(-6), math.rad(20), 0)
	local tween3 = TweenService:Create(cam, TweenInfo.new(0.0001, Enum.EasingStyle.Sine), {CFrame = angledCFrame})
	tween3:Play()
	tween3.Completed:Wait()

	cam.CameraType = Enum.CameraType.Custom
end

-- Theo dõi animation
local function bindAnimator(animator)
	animConnection = animator.AnimationPlayed:Connect(function(track)
		if track.Animation and track.Animation.AnimationId == animationId and not debounce then
			debounce = true
			print("🎬 Phát hiện animation:", animationId)

			local char = player.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hrp then
				local back = hrp.CFrame.LookVector * -1
				hrp.CFrame = hrp.CFrame + back
			end

			task.delay(0.25, function()
				swipeAndDash()
				wait(5)
				debounce = false
			end)
		end
	end)
end

-- Theo dõi nhân vật
local function monitorCharacter()
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")
	local animator = humanoid:FindFirstChildOfClass("Animator")

	if animator then
		bindAnimator(animator)
	else
		humanoid.ChildAdded:Connect(function(child)
			if child:IsA("Animator") then
				bindAnimator(child)
			end
		end)
	end
end

-- 🔘 Gắn Toggle mới
MainSection:AddToggle("Instant Twisted", false, function(state)
	if state then
		monitorCharacter()
		charConnection = player.CharacterAdded:Connect(monitorCharacter)
	else
		if animConnection then
			animConnection:Disconnect()
			animConnection = nil
		end
		if charConnection then
			charConnection:Disconnect()
			charConnection = nil
		end
	end
end)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local cam = Workspace.CurrentCamera

local targetAnimationId = "rbxassetid://12296113986"
local rotating = false
local animConnection
local charConnection

local function holdJump()
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then humanoid.Jump = true end
end

local function releaseJump()
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then humanoid.Jump = false end
end

local function rotateBack()
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if root then
		local currentCFrame = root.CFrame
		local lookVector = -currentCFrame.LookVector
		local newLook = CFrame.lookAt(currentCFrame.Position, currentCFrame.Position + lookVector)
		root.CFrame = newLook
		cam.CFrame = CFrame.lookAt(cam.CFrame.Position, cam.CFrame.Position + lookVector)
	end
end

local function sendRemote()
	local remote = player.Character and player.Character:FindFirstChild("Communicate")
	if remote then
		local args = {
			[1] = {
				["Dash"] = Enum.KeyCode.W,
				["Key"] = Enum.KeyCode.Q,
				["Goal"] = "KeyPress"
			}
		}
		remote:FireServer(unpack(args))
	end
end

local function bindHumanoid(humanoid)
	animConnection = humanoid.AnimationPlayed:Connect(function(track)
		if track.Animation and track.Animation.AnimationId == targetAnimationId and not rotating then
			rotating = true
			holdJump()
			task.delay(2, function()
				sendRemote()
				task.delay(0.26, function()
					rotateBack()
					releaseJump()
					rotating = false
				end)
			end)
		end
	end)
end

local function setupMonitor()
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")
	bindHumanoid(humanoid)
end

MainSection:AddToggle("Auto Supa", false, function(state)
	if state then
		setupMonitor()
		charConnection = player.CharacterAdded:Connect(setupMonitor)
	else
		if animConnection then animConnection:Disconnect() animConnection = nil end
		if charConnection then charConnection:Disconnect() charConnection = nil end
	end
end)

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local animationId = "rbxassetid://12273188754"

local flowingConnection
local flowingEnabled = false

MainSection:AddToggle("Flowing + Grasp", false, function(state)
	flowingEnabled = state
	if flowingConnection then
		flowingConnection:Disconnect()
		flowingConnection = nil
	end

	if not state then return end

	local isTweening = false
	local lastPlaying = false

	flowingConnection = RunService.RenderStepped:Connect(function()
		local char = player.Character
		local humanoid = char and char:FindFirstChild("Humanoid")
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not humanoid or not hrp then return end

		local isPlaying = false
		for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
			if track.Animation and track.Animation.AnimationId == animationId then
				isPlaying = true
				break
			end
		end

		if isPlaying and not isTweening and not lastPlaying then
			isTweening = true
			lastPlaying = true

			task.delay(1.8, function()
				local forwardCFrame = hrp.CFrame + hrp.CFrame.LookVector * 24
				local tween = TweenService:Create(hrp, TweenInfo.new(0.1), {CFrame = forwardCFrame})
				tween:Play()
				tween.Completed:Wait()

				local tool = player.Backpack:FindFirstChild("Hunter's Grasp")
				local remote = char:FindFirstChild("Communicate")
				if tool and remote then
					local args = {
						[1] = {
							["Tool"] = tool,
							["Goal"] = "Console Move"
						}
					}
					remote:FireServer(unpack(args))
				end

				isTweening = false
			end)
		elseif not isPlaying then
			lastPlaying = false
		end
	end)
end)

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local player = game.Players.LocalPlayer

local animationId = "rbxassetid://10503381238"
local TWEEN_HEIGHT_OFFSET = Vector3.new(0, 8, 0)

local upperConnection
local upperEnabled = false

MainSection:AddToggle("Upper + Grasp", false, function(state)
	upperEnabled = state
	if upperConnection then
		upperConnection:Disconnect()
		upperConnection = nil
	end

	if not state then return end

	local isTweening = false
	local lastPlaying = false
	local cooldown = false

	upperConnection = RunService.RenderStepped:Connect(function()
		local char = player.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local humanoid = char and char:FindFirstChild("Humanoid")
		if not char or not hrp or not humanoid then return end

		local isPlaying = false
		for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
			if track.Animation and track.Animation.AnimationId == animationId then
				isPlaying = true
				break
			end
		end

		if isPlaying and not isTweening and not lastPlaying and not cooldown then
			isTweening = true
			lastPlaying = true
			cooldown = true

			task.delay(0.18, function()
				local target
				local shortestDist = 7
				local live = Workspace:FindFirstChild("Live")
				if live then
					for _, model in ipairs(live:GetChildren()) do
						if model:IsA("Model") and model ~= char then
							local torso = model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso")
							if torso then
								local dist = (hrp.Position - torso.Position).Magnitude
								if dist <= shortestDist then
									shortestDist = dist
									target = torso
								end
							end
						end
					end
				end

				if target then
					local targetPos = target.Position + TWEEN_HEIGHT_OFFSET
					local tween = TweenService:Create(hrp, TweenInfo.new(0.1), {CFrame = CFrame.new(targetPos)})
					tween:Play()
					tween.Completed:Wait()
				end

				local tool = player.Backpack:FindFirstChild("Hunter's Grasp")
				local remote = char:FindFirstChild("Communicate")
				if tool and remote then
					local args = {
						[1] = {
							["Tool"] = tool,
							["Goal"] = "Console Move"
						}
					}
					remote:FireServer(unpack(args))
				end

				isTweening = false
				task.delay(15, function() cooldown = false end)
			end)
		elseif not isPlaying then
			lastPlaying = false
		end
	end)
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local animationIdToDetect = "rbxassetid://12309835105"
local detected = false
local connection1

MainSection:AddToggle("Grasp + Dash", false, function(state)
	if connection1 then
		connection1:Disconnect()
		connection1 = nil
	end

	if state then
		local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local Humanoid = Character:WaitForChild("Humanoid")

		connection1 = Humanoid.AnimationPlayed:Connect(function(track)
			if track.Animation.AnimationId == animationIdToDetect and not detected then
				detected = true
				print("✅ Phát hiện animation!")

				task.delay(0.8, function()
					local char = LocalPlayer.Character
					if not char then return end

					local root = char:FindFirstChild("HumanoidRootPart")
					if root then
						local backVec = -root.CFrame.LookVector * 4.5
						root.CFrame = root.CFrame + backVec
						print("↩️ Đã lùi lại 5 stud")
					end

					local remote = char:FindFirstChild("Communicate")
					if remote then
						local args = {
							{
								Dash = Enum.KeyCode.W,
								Key = Enum.KeyCode.Q,
								Goal = "KeyPress"
							}
						}
						remote:FireServer(unpack(args))
						print("📤 Đã gửi remote Dash Q")
					end

					task.wait(1.5)
					detected = false
				end)
			end
		end)
	end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local animationId = "rbxassetid://12510170988"
local isDashEnabled = false
local dashConnection

local function FireDashRemote()
	local comm = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Communicate")
	if comm then
		local args = {
			{
				Dash = Enum.KeyCode.W,
				Key = Enum.KeyCode.Q,
				Goal = "KeyPress"
			}
		}
		comm:FireServer(unpack(args))
	end
end

MainSection:AddToggle("Skill4 + Dash ( Saitama )", false, function(state)
	isDashEnabled = state

	if dashConnection then
		dashConnection:Disconnect()
		dashConnection = nil
	end

	if state then
		local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local Humanoid = Character:WaitForChild("Humanoid")

		dashConnection = Humanoid.AnimationPlayed:Connect(function(track)
			if track.Animation and track.Animation.AnimationId == animationId then
				task.delay(1, function()
					if track.IsPlaying then
						FireDashRemote()
					end
				end)
			end
		end)
	end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local targetIDs = {
	["10480796021"] = true,
	["10480793962"] = true,
}

local animConnection, charConnection
local toggleState = false

MainSection:AddToggle("Slide + M1", false, function(state)
	toggleState = state

	if not toggleState then
		if animConnection then animConnection:Disconnect() animConnection = nil end
		if charConnection then charConnection:Disconnect() charConnection = nil end
		return
	end

	local function setupForCharacter(char)
		local humanoid = char:WaitForChild("Humanoid", 3)
		local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
		local remote = char:FindFirstChild("Communicate")

		if not humanoid or not animator or not remote then return end
		local cooldown = false

		if animConnection then animConnection:Disconnect() end

		animConnection = animator.AnimationPlayed:Connect(function(track)
			if not toggleState then return end
			local id = track.Animation.AnimationId:match("%d+")
			if id and targetIDs[id] and not cooldown then
				cooldown = true

				remote:FireServer({
					["Mobile"] = true,
					["Goal"] = "LeftClick"
				})
				remote:FireServer({
					["Goal"] = "LeftClickRelease",
					["Mobile"] = true
				})

				task.delay(1.5, function()
					cooldown = false
				end)
			end
		end)
	end

	if LocalPlayer.Character then
		setupForCharacter(LocalPlayer.Character)
	end

	if charConnection then charConnection:Disconnect() end
	charConnection = LocalPlayer.CharacterAdded:Connect(function(char)
		task.wait(1)
		if toggleState then
			setupForCharacter(char)
		end
	end)
end)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local TARGET_ANIM_ID = "rbxassetid://12309835105"
local active = false
local isTweening = false
local charConnection

MainSection:AddToggle("Auto Surf", false, function(state)
	active = state

	if charConnection then charConnection:Disconnect() charConnection = nil end
	if not state then return end

	local function getCharacter()
		return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	end

	local function isTargetAnimPlaying()
		local char = getCharacter()
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if not humanoid then return false end

		for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
			if track.Animation and track.Animation.AnimationId == TARGET_ANIM_ID then
				return true
			end
		end
		return false
	end

	RunService.RenderStepped:Connect(function()
		if not active or isTweening then return end
		if isTargetAnimPlaying() then
			isTweening = true
			task.wait(0.6)

			local char = getCharacter()
			local root = char:FindFirstChild("HumanoidRootPart")
			if root then
				root.Anchored = false
				local forward = root.CFrame.LookVector.Unit
				local tween = TweenService:Create(root, TweenInfo.new(0.78), {CFrame = root.CFrame + (forward * 50)})
				tween:Play()
				tween.Completed:Wait()
			end

			task.wait(1.5)
			isTweening = false
		end
	end)

	charConnection = LocalPlayer.CharacterAdded:Connect(function()
		task.wait(1)
		getCharacter()
	end)
end)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local workspace = game:GetService("Workspace")

local char, humanoid, hrp
local enabled = false

local validIDs = {
	["rbxassetid://10469639222"] = true,
	["rbxassetid://13532604085"] = true,
	["rbxassetid://13295919399"] = true,
	["rbxassetid://13378751717"] = true,
	["rbxassetid://14001963401"] = true,
	["rbxassetid://15240176873"] = true,
	["rbxassetid://16515448089"] = true,
	["rbxassetid://17889471098"] = true,
	["rbxassetid://104895379416342"] = true,
}

local function isNearTarget()
	if not hrp then return false end
	for _, model in ipairs(workspace.Live:GetChildren()) do
		if model:IsA("Model") and model ~= char then
			local root = model:FindFirstChild("HumanoidRootPart")
			if root and (root.Position - hrp.Position).Magnitude <= 15 then
				if Players:GetPlayerFromCharacter(model) or model.Name == "Weakest Dummy" then
					return true
				end
			end
		end
	end
	return false
end

local function liftAndJump()
	if not hrp or not humanoid then return end
	if not isNearTarget() then return end

	local tween = TweenService:Create(
		hrp,
		TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ CFrame = hrp.CFrame + Vector3.new(0, 6, 0) }
	)
	tween:Play()

	for _, state in ipairs({
		Enum.HumanoidStateType.PlatformStanding,
		Enum.HumanoidStateType.Freefall,
		Enum.HumanoidStateType.GettingUp,
	}) do
		if humanoid:GetState() == state then
			humanoid:ChangeState(Enum.HumanoidStateType.Physics)
			task.wait()
		end
	end

	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end

local function bindAnimationDetect()
	if humanoid then
		humanoid.AnimationPlayed:Connect(function(track)
			if enabled and track.Animation and validIDs[track.Animation.AnimationId] then
				liftAndJump()
			end
		end)
	end
end

local function setupCharacter()
	char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart")
	bindAnimationDetect()
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)
setupCharacter()

MainSection:AddToggle("Auto DownSlam", false, function(state)
	enabled = state
end)

local animationIds = {
	["rbxassetid://10503381238"] = true,
	["rbxassetid://13379003796"] = true,
}
local TWEEN_HEIGHT_OFFSET = Vector3.new(0, 5, 0)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local toggleConnection
local aimlockConnection
local systemEnabled = false
local lockedTarget = nil

-- Aimlock logic
local function startAimlock(target)
	if aimlockConnection then aimlockConnection:Disconnect() end
	local cam = Workspace.CurrentCamera
	local character = player.Character
	local lockTime = 0.65
	local chaosTime = 0.15
	local startTime = tick()

	aimlockConnection = RunService.RenderStepped:Connect(function()
		if not systemEnabled then return end
		if not (target and target:FindFirstChild("HumanoidRootPart")) then return end
		if not (character and character:FindFirstChild("HumanoidRootPart")) then return end

		local now = tick()
		local targetPos = target.HumanoidRootPart.Position
		local camPos = cam.CFrame.Position

		if now - startTime < chaosTime then
			local angleX = math.rad(math.random(-15, 25))
			local angleY = math.rad(math.random(-15, 25))
			local baseCFrame = CFrame.new(camPos, targetPos)
			cam.CFrame = baseCFrame * CFrame.Angles(angleY, angleX, 0)
		else
			cam.CFrame = CFrame.new(camPos, targetPos)
		end

		character.HumanoidRootPart.CFrame = CFrame.new(character.HumanoidRootPart.Position, cam.CFrame.Position + cam.CFrame.LookVector)
	end)

	task.delay(lockTime, function()
		if aimlockConnection then
			aimlockConnection:Disconnect()
			aimlockConnection = nil
		end
		lockedTarget = nil
	end)
end

-- Setup mỗi khi respawn hoặc bật
local function setupCharacter(character)
	if toggleConnection then toggleConnection:Disconnect() end
	if aimlockConnection then aimlockConnection:Disconnect() end
	lockedTarget = nil

	if not systemEnabled then return end

	local isTweening = false
	local lastPlaying = false
	local cooldown = false

	toggleConnection = RunService.RenderStepped:Connect(function()
		if not systemEnabled then return end

		local hrp = character:FindFirstChild("HumanoidRootPart")
		local humanoid = character:FindFirstChild("Humanoid")
		if not hrp or not humanoid then return end

		local isPlaying = false
		for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
			if track.Animation and animationIds[track.Animation.AnimationId] then
				isPlaying = true
				break
			end
		end

		if isPlaying and not isTweening and not lastPlaying and not cooldown then
			isTweening = true
			lastPlaying = true
			cooldown = true

			task.delay(0.18, function()
				if not systemEnabled then return end

				local target = nil
				local shortestDist = 15
				local live = Workspace:FindFirstChild("Live")
				if live then
					for _, model in ipairs(live:GetChildren()) do
						if model:IsA("Model") and model ~= character then
							local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model:FindFirstChild("UpperTorso")
							if root then
								local dist = (hrp.Position - root.Position).Magnitude
								if dist < shortestDist then
									shortestDist = dist
									target = model
								end
							end
						end
					end
				end

				if target and target:FindFirstChild("HumanoidRootPart") then
					local targetPos = target.HumanoidRootPart.Position + TWEEN_HEIGHT_OFFSET
					local tween = TweenService:Create(hrp, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
						CFrame = CFrame.new(targetPos)
					})
					tween:Play()
					tween.Completed:Wait()

					local bodyPosition = Instance.new("BodyPosition")
					bodyPosition.MaxForce = Vector3.new(1e5, 1e5, 1e5)
					bodyPosition.P = 10000
					bodyPosition.D = 100
					bodyPosition.Position = targetPos
					bodyPosition.Parent = hrp

					task.delay(0.76, function()
						bodyPosition:Destroy()
					end)

					local remote = character:FindFirstChild("Communicate")
					if remote then
						remote:FireServer({
							["Dash"] = Enum.KeyCode.W,
							["Key"] = Enum.KeyCode.Q,
							["Goal"] = "KeyPress"
						})
					end

					lockedTarget = target
					startAimlock(lockedTarget)
				end

				isTweening = false
				task.delay(4, function()
					cooldown = false
				end)
			end)
		elseif not isPlaying then
			lastPlaying = false
		end
	end)
end

-- Theo dõi khi respawn
player.CharacterAdded:Connect(function(char)
	if systemEnabled then
		setupCharacter(char)
	end
end)

-- GUI Toggle đúng cách
MainSection:AddToggle("Kiba Tech", false, function(state)
	systemEnabled = state

	if toggleConnection then toggleConnection:Disconnect() end
	if aimlockConnection then aimlockConnection:Disconnect() end
	lockedTarget = nil

	if state and player.Character then
		setupCharacter(player.Character)
	end
end)

MainSection:AddToggle("Auto Whirlwind Dunk", false, function(isEnabled)
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local lp = Players.LocalPlayer

	-- Ngắt kết nối cũ nếu có
	if _G.TeleportAnimConnection then
		_G.TeleportAnimConnection:Disconnect()
		_G.TeleportAnimConnection = nil
	end

	if isEnabled then
		local isTeleporting = false
		local lastTrack = nil

		_G.TeleportAnimConnection = RunService.RenderStepped:Connect(function()
			local character = lp.Character
			if not character or isTeleporting then return end

			local humanoid = character:FindFirstChildWhichIsA("Humanoid")
			local root = character:FindFirstChild("HumanoidRootPart")
			if not humanoid or not root then return end

			for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
				if track.Animation and track.Animation.AnimationId == "rbxassetid://12296113986" then
					if lastTrack == track then return end
					lastTrack = track

					isTeleporting = true
					task.delay(1, function()
						if root and root.Parent then
							root.CFrame = root.CFrame + Vector3.new(0, 70, 0)
						end
						isTeleporting = false
					end)
					break
				end
			end

			-- Reset nếu animation kết thúc
			if lastTrack and not lastTrack.IsPlaying then
				lastTrack = nil
			end
		end)
	end
end)

local MainTab = Window:AddTab("Auto Farm", "list")

local MainSection = MainTab:AddSection("Auto Farm", "left")


MainSection:AddButton("Comming Soon...", function()

   print("")
end)

local MainTab = Window:AddTab("Server", "earth")

local MainSection = MainTab:AddSection("Server", "left")


MainSection:AddButton("Rejoin", function()
	local TeleportService = game:GetService("TeleportService")
	local player = game.Players.LocalPlayer

	-- Giao diện đếm ngược
	local gui = Instance.new("ScreenGui")
	gui.Name = "RejoinGui"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.3, 0, 0.2, 0)
	label.Position = UDim2.new(0.35, 0, 0.4, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.Text = ""
	label.Parent = gui

	for i = 5, 1, -1 do
		label.Text = "Rejoining in " .. i .. "..."
		task.wait(1)
	end

	gui:Destroy()

	-- Teleport lại đúng instance hiện tại
	TeleportService:Teleport(game.PlaceId, player)
end)

MainSection:AddButton("Server Hop", function()
	local TeleportService = game:GetService("TeleportService")
	local HttpService = game:GetService("HttpService")
	local player = game.Players.LocalPlayer
	local placeId = game.PlaceId

	-- Giao diện đếm ngược
	local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	gui.Name = "ServerHopGui"
	gui.ResetOnSpawn = false

	local label = Instance.new("TextLabel", gui)
	label.Size = UDim2.new(0.3, 0, 0.2, 0)
	label.Position = UDim2.new(0.35, 0, 0.4, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true

	for i = 5, 1, -1 do
		label.Text = "Hopping in " .. i .. "..."
		task.wait(1)
	end

	gui:Destroy()

	local function getRandomServer()
		local servers = {}
		local success, result = pcall(function()
			return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"))
		end)

		if success and result and result.data then
			for _, s in pairs(result.data) do
				if s.playing < s.maxPlayers and s.id ~= game.JobId then
					table.insert(servers, s.id)
				end
			end
		end

		return #servers > 0 and servers[math.random(1, #servers)] or nil
	end

	local target = getRandomServer()
	if target then
		TeleportService:TeleportToPlaceInstance(placeId, target, player)
	else
		warn("⚠️ Không tìm được server khác.")
	end
end)

MainSection:AddButton("Small Server", function()
	local TeleportService = game:GetService("TeleportService")
	local HttpService = game:GetService("HttpService")
	local player = game.Players.LocalPlayer
	local placeId = game.PlaceId

	-- GUI đếm ngược
	local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	gui.Name = "SmallServerGui"
	gui.ResetOnSpawn = false

	local label = Instance.new("TextLabel", gui)
	label.Size = UDim2.new(0.3, 0, 0.2, 0)
	label.Position = UDim2.new(0.35, 0, 0.4, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true

	for i = 5, 1, -1 do
		label.Text = "Tìm server < 5 người trong " .. i .. "..."
		task.wait(1)
	end

	gui:Destroy()

	local function getSmallServer()
		local servers = {}
		local cursor = ""

		for i = 1, 5 do
			local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"
			if cursor ~= "" then url = url .. "&cursor=" .. cursor end

			local success, data = pcall(function()
				return HttpService:JSONDecode(game:HttpGet(url))
			end)

			if success and data and data.data then
				for _, s in pairs(data.data) do
					if s.playing < 5 and s.id ~= game.JobId then
						table.insert(servers, s.id)
					end
				end

				if data.nextPageCursor then
					cursor = data.nextPageCursor
				else
					break
				end
			else
				break
			end
		end

		return #servers > 0 and servers[math.random(1, #servers)] or nil
	end

	local target = getSmallServer()
	if target then
		TeleportService:TeleportToPlaceInstance(placeId, target, player)
	else
		warn("⚠️ Không tìm được server < 5 người.")
	end
end)

MainSection:AddButton("Anti Lag", function()

   loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Antilag%20script"))()

end)

MainSection:AddButton("Check Ping", function()

   -- Tạo GUI hiển thị ping
local player = game:GetService("Players").LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PingDisplay"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(0, 150, 0, 40)
pingLabel.Position = UDim2.new(1, -160, 0, 10) -- góc trên bên phải
pingLabel.BackgroundTransparency = 0.4
pingLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
pingLabel.TextColor3 = Color3.new(1, 1, 1)
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextSize = 20
pingLabel.Text = "PING: -- ms"
pingLabel.Parent = screenGui

-- Cập nhật ping liên tục
while true do
    local ping = math.floor(player:GetNetworkPing() * 1000)
    pingLabel.Text = "PING: " .. ping .. " ms"

    -- Đổi màu theo mức ping
    if ping <= 80 then
        pingLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- xanh
    elseif ping <= 150 then
        pingLabel.TextColor3 = Color3.fromRGB(255, 170, 0) -- cam
    else
        pingLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- đỏ
    end

    wait(1)
end

end)

MainSection:AddToggle("Anti Kick", false, function(state)
	local Players = game:GetService("Players")
	local StarterGui = game:GetService("StarterGui")
	local LocalPlayer = Players.LocalPlayer
	local connections = {}

	local function hookKick()
		local mt = getrawmetatable(game)
		local oldNamecall = mt.__namecall
		setreadonly(mt, false)

		mt.__namecall = newcclosure(function(self, ...)
			if getnamecallmethod() == "Kick" and self == LocalPlayer then
				warn("[🚫 AntiKick]: Kick blocked (Namecall)")
				return nil
			end
			return oldNamecall(self, ...)
		end)

		LocalPlayer.Kick = function()
			warn("[🚫 AntiKick]: Kick blocked (Direct)")
			return nil
		end

		setreadonly(mt, true)
	end

	local function hookGui()
		local con = StarterGui.MessageBoxPrompted:Connect(function()
			warn("[🚫 AntiKick]: MessageBox blocked")
		end)
		table.insert(connections, con)
	end

	local function hookExploit()
		for _, v in pairs(getgc(true)) do
			if typeof(v) == "function" and islclosure(v) then
				local info = debug.getinfo(v)
				if info.name and string.lower(info.name):match("kick") then
					hookfunction(v, function(...)
						warn("[🚫 AntiKick]: Exploit Kick blocked")
						return nil
					end)
				end
			end
		end
	end

	local function enable()
		hookKick()
		hookGui()
		hookExploit()
	end

	local function disable()
		for _, con in ipairs(connections) do
			if typeof(con) == "RBXScriptConnection" then
				pcall(function() con:Disconnect() end)
			end
		end
		table.clear(connections)
	end

	if state then
		enable()
	else
		disable()
	end
end)

local MainTab = Window:AddTab("Admin", "user")

local MainSection = MainTab:AddSection("Admin", "left")


MainSection:AddButton("Infinite Yield", function()

   loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()

end)

MainSection:AddButton("Nameless", function()

   loadstring(game:HttpGet("https://github.com/FilteringEnabled/NamelessAdmin/blob/main/Source?raw=true"))()

end)
