local Version = "1.06.3"
if not game:IsLoaded("Workspace") then -- scriptware uses isloaded args
	game.Loaded:Wait()
end
local LoadTick = tick()
local GUI = game:GetObjects("rbxassetid://10541085796")[1]

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local NetworkClient = game:GetService("NetworkClient")
local HTTP = game:GetService("HttpService")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = Player:GetMouse()

local Toggle = false
local Global = getgenv and getgenv() or shared
local setfflag = setfflag or function(flag,bool) game:DefineFastFlag(flag,bool) end
local printconsole = printconsole or print

local Storage = {}

local fwait,Event = Global.fwait,Global.Event

if not fwait and not Event then
	do -- [[ Setting Flags ]]
		pcall(function() setfflag("NewRunServiceSignals", "true") end) 
		pcall(function() setfflag("NewRunServiceSignals", true) end) 
	end

	local Bind = Instance.new("BindableEvent")
	for i,v in ipairs({RunService.Heartbeat,RunService.Stepped,RunService.RenderStepped,RunService.PreAnimation}) do
		local Tick = tick()
		v:Connect(function()
			Bind:Fire(tick()-Tick)
			Tick = tick()
		end)
	end
	fwait = function(Num)
		if Num and Num > 0 then
			local Tick = tick()
			repeat
				Tick += Bind.Event:Wait()
			until Tick >= Num
			return Tick
		else
			return Bind.Event:Wait()
		end
	end
	Global.fwait = fwait
	Global.Event = Bind.Event
	Event = Bind.Event
end


do -- [[ Commands ]]
	local function ShortName(Name)
		Name = tostring(Name)
		for _,plr in pairs(Players:GetPlayers()) do
			if plr ~= Player and string.sub(string.lower(plr.Name),1,#Name) == string.lower(Name) then
				return plr
			end
		end
		for _,plr in pairs(Players:GetPlayers()) do
			if plr ~= Player and string.sub(string.lower(plr.DisplayName),1,#Name) == string.lower(Name) then
				return plr
			end
		end
	end
	local function check4property(obj, prop)
		return ({pcall(function()if(typeof(obj[prop])=="Instance")then error()end end)})[1]
	end

	local Commands,Visible,RealChar
	local noclipping,Flying = false,false

	Commands = {
		["print"] = {{"Value"},function(args)
			print(args[2])
		end},
		["commands"] = {{},function(args)
			GUI.Frame.Position = UDim2.new(0.1, 0,0.3, 0)
			GUI.Frame.Visible = true
		end},
		["cmds"] = {{},function(args)
			GUI.Frame.Position = UDim2.new(0.1, 0,0.3, 0)
			GUI.Frame.Visible = true
		end},
		["hydroxide"] = {{},function(args)
			local owner = "Upbolt"
			local branch = "revision"

			local function webImport(file)
				return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
			end

			webImport("init")
			webImport("ui/main")
		end},
		["backdoorchecker"] = {{},function(args)
			loadstring(game:HttpGet(('https://raw.githubusercontent.com/iK4oS/backdoor.exe/master/source.lua'),true))()
		end},
		["animstealer"] = {{},function(args)
			loadstring(game:HttpGet("https://raw.githubusercontent.com/CenteredSniper/Kenzen/master/AnimationStealer.lua",true))()
		end},
		["aimlock"] = {{},function(args)
			loadstring(game:HttpGet("https://pastebin.com/raw/Zz5yB0D1", true))()
		end},
		["antitp"] = {{},function(args)
			local humroot = Player.Character.HumanoidRootPart
			local prevpos = humroot.CFrame
			while fwait() do
				if (humroot.Position - prevpos.Position).Magnitude < -2 or (humroot.Position - prevpos.Position).Magnitude > 2 then
					humroot.CFrame = prevpos
				end
				prevpos = humroot.CFrame
			end
		end},
		["antifling"] = {{},function(args)
			loadstring(game:HttpGet("https://raw.githubusercontent.com/L8X/phys/main/antifling.lua",true))()
		end},
		["dex"] = {{},function(args)
			loadstring(game:HttpGet("https://raw.githubusercontent.com/L8X/ExProDex-V2/main/src.lua", true))()
		end},
		["dexv4"] = {{},function(args)
			loadstring(game:HttpGetAsync("https://pastebin.com/raw/fPP8bZ8Z",true))()
		end},
		["iy"] = {{},function(args)
			loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
		end},
		["reanimate"] = {{},function(args)
			loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/CenteredSniper/Kenzen/master/ZendeyReanimate.lua", true))()
		end},
		["tooldances"] = {{},function(args)
			Global.AutoAnimate = false
			Global.R15ToR6 = true
			loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/AwsZFvR4Fh6/Ya/main/toolanimations.lua", true))()
		end},
		["r15tooldances"] = {{},function(args)
			Global.AutoAnimate = false
			Global.R15ToR6 = false
			loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/AwsZFvR4Fh6/Ya/main/R15ToolDances.lua", true))()
		end},
		["f3x"] = {{},function(args)
			loadstring(game:GetObjects("rbxassetid://4698064966")[1].Source)()
		end},
		["copypos"] = {{},function(args)
			local function toClipboard(String)
				local clipBoard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
				if clipBoard then
					clipBoard(String)
				end
			end
			local roundedPos = math.round(Player.Character.HumanoidRootPart.Position.X) .. ", " .. math.round(Player.Character.HumanoidRootPart.Position.Y) .. ", " .. math.round(Player.Character.HumanoidRootPart.Position.Z)
			toClipboard(roundedPos)
		end},
		["antilog"] = {{},function(args)
			loadstring(game:HttpGet('https://pastebin.com/raw/444k40vk'))();
		end},
		["antikorblox"] = {{},function(args)
			local LP = Player
			local a = LP.Character:FindFirstChild("Korblox Deathspeaker Right Leg")
			if a then a:Destroy() end
			LP.CharacterAdded:Connect(function(v)
				repeat wait() until v:FindFirstChild("Korblox Deathspeaker Right Leg")
				v:WaitForChild("Korblox Deathspeaker Right Leg"):Destroy()
			end)
		end},
		["headsit"] = {{"Player"},function(args)
			if Storage["Headsit"] then Storage["Headsit"]:Disconnect() end
			if Storage["SitRunning"] then Storage["SitRunning"]:Disconnect() end
			if args[2] then
				local copyplr = ShortName(args[2])
				if copyplr then
					Player.Character:FindFirstChildOfClass('Humanoid').Sit = true
					local BodyVelocity = Instance.new("BodyVelocity"); do
						BodyVelocity.Parent = Player.Character.HumanoidRootPart
					end
					Storage["Headsit"] = Event:Connect(function()
						if Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChildOfClass('Humanoid').Sit == true and copyplr and copyplr.Character then
							Player.Character.HumanoidRootPart.CFrame = copyplr.Character.HumanoidRootPart.CFrame *CFrame.new(0,1.6,1.15)
						else
							BodyVelocity:Destroy()
							if Storage["Headsit"] then Storage["Headsit"]:Disconnect() end
							if Storage["SitRunning"] then Storage["SitRunning"]:Disconnect() end
						end
					end)
				end
			end
		end},
		["headsitpredict"] = {{"Player"},function(args)
			if Storage["Headsit"] then Storage["Headsit"]:Disconnect() end
			if Storage["SitRunning"] then Storage["SitRunning"]:Disconnect() end
			if args[2] then
				local copyplr = ShortName(args[2])
				if copyplr then
					local speed = 0
					Player.Character:FindFirstChildOfClass('Humanoid').Sit = true
					local BodyVelocity = Instance.new("BodyVelocity"); do
						BodyVelocity.Parent = Player.Character.HumanoidRootPart
					end

					Storage["SitRunning"] = copyplr.Character.Humanoid.Running:Connect(function(sp)
						speed = sp
					end)

					Storage["Headsit"] = Event:Connect(function()
						if Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChildOfClass('Humanoid').Sit == true and copyplr and copyplr.Character then
							Player.Character.HumanoidRootPart.CFrame = CFrame.new(copyplr.Character.HumanoidRootPart.Position + (copyplr.Character.Humanoid.MoveDirection * ((speed/16)+game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()/10))) * (copyplr.Character.HumanoidRootPart.CFrame-copyplr.Character.HumanoidRootPart.Position) * CFrame.new(0,1.6,1.15)
						else
							BodyVelocity:Destroy()
							if Storage["Headsit"] then Storage["Headsit"]:Disconnect() end
							if Storage["SitRunning"] then Storage["SitRunning"]:Disconnect() end
						end
					end)
				end
			end
		end},
		["bang"] = {{"Player"},function(args)
			if Storage["Banging"] then Storage["Banging"]:Disconnect() end
			if Storage["BangRunning"] then Storage["BangRunning"]:Disconnect() end
			if args[2] then
				local copyplr = ShortName(args[2])
				if copyplr then
					local bang
					local bangAnim = Instance.new("Animation") do
						if Player.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
							bangAnim.AnimationId = "rbxassetid://5918726674"
						else
							bangAnim.AnimationId = "rbxassetid://148840371"
						end

						bang = Player.Character.Humanoid:LoadAnimation(bangAnim) do
							bang:Play(.1, 1, 1)
							bang:AdjustSpeed(5)
						end
					end

					local BodyVelocity = Instance.new("BodyVelocity"); do
						BodyVelocity.Parent = Player.Character.HumanoidRootPart
					end

					Player.CharacterAdded:Connect(function()
						if Storage["Banging"] then Storage["Banging"]:Disconnect() end
						if Storage["BangRunning"] then Storage["BangRunning"]:Disconnect() end
						bang:Stop()
					end)

					Storage["Banging"] = Event:Connect(function()
						if Player.Character:FindFirstChild("HumanoidRootPart") and copyplr and copyplr.Character then
							Player.Character.HumanoidRootPart.CFrame = copyplr.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,1)
						else
							if Storage["Banging"] then Storage["Banging"]:Disconnect() end
							if Storage["BangRunning"] then Storage["BangRunning"]:Disconnect() end
							BodyVelocity:Destroy()
							bang:Stop()
						end
					end)
				end
			end
		end},
		["joinplr"] = {{"PlayerID","GameID"},function(args)
			local retries = 0
			local function ToServer(User,PlaceId)	
				if args[2] == nil then PlaceId = game.PlaceId end
				if not pcall(function()
						local FoundUser, UserId = pcall(function()
							if tonumber(User) then
								return tonumber(User)
							end

							return Players:GetUserIdFromNameAsync(User)
						end)
							local URL2 = ("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
							local Http = HTTP:JSONDecode(game:HttpGet(URL2))
							local GUID

							local function tablelength(T)
								local count = 0
								for _ in pairs(T) do count = count + 1 end
								return count
							end

							for i=1,tonumber(tablelength(Http.data)) do
								for j,k in pairs(Http.data[i].playerIds) do
									if k == UserId then
										GUID = Http.data[i].id
									end
								end
							end

							if GUID ~= nil then
								game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceId,GUID,Players.LocalPlayer)
							else
							end
					end)
				then
					if retries < 999 then
						retries = retries + 1
						print('ERROR retrying '..retries..'/3')
						ToServer(User,PlaceId)
					else
					end
				end
			end
			ToServer(args[2],args[3])
		end},
		["bangpredict"] = {{"Player"},function(args)
			if Storage["Banging"] then Storage["Banging"]:Disconnect() end
			if Storage["BangRunning"] then Storage["BangRunning"]:Disconnect() end
			if args[2] then
				local copyplr = ShortName(args[2])
				if copyplr then
					local speed = 0
					local bang
					local bangAnim = Instance.new("Animation") do
						if Player.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
							bangAnim.AnimationId = "rbxassetid://5918726674"
						else
							bangAnim.AnimationId = "rbxassetid://148840371"
						end

						bang = Player.Character.Humanoid:LoadAnimation(bangAnim) do
							bang:Play(.1, 1, 1)
							bang:AdjustSpeed(5)
						end
					end

					local BodyVelocity = Instance.new("BodyVelocity"); do
						BodyVelocity.Parent = Player.Character.HumanoidRootPart
					end

					Storage["BangRunning"] = copyplr.Character.Humanoid.Running:Connect(function(sp)
						speed = sp
					end)

					Player.CharacterAdded:Connect(function()
						if Storage["Banging"] then Storage["Banging"]:Disconnect() end
						if Storage["BangRunning"] then Storage["BangRunning"]:Disconnect() end
						bang:Stop()
					end)

					Storage["Banging"] = Event:Connect(function()
						if Player.Character:FindFirstChild("HumanoidRootPart") and copyplr and copyplr.Character then
							Player.Character.HumanoidRootPart.CFrame = CFrame.new(copyplr.Character.HumanoidRootPart.Position + (copyplr.Character.Humanoid.MoveDirection * ((speed/16)+game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()/10))) * (copyplr.Character.HumanoidRootPart.CFrame-copyplr.Character.HumanoidRootPart.Position) * CFrame.new(0,0,1)
						else
							if Storage["Banging"] then Storage["Banging"]:Disconnect() end
							if Storage["BangRunning"] then Storage["BangRunning"]:Disconnect() end
							BodyVelocity:Destroy()
							bang:Stop()
						end
					end)
				end
			end
		end},
		["owlhub"] = {{},function(args)
			loadstring(game:HttpGet("https://raw.githubusercontent.com/ZinityDrops/OwlHubLink/master/OwlHubBack.lua"))();
		end},
		["boombox"] = {{},function(args)
			loadstring(game:HttpGetAsync('https://riptxde.dev/u/hub/script.lua'))()
		end},
		["serverhop"] = {{},function(args)
			local sl = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/".. game.PlaceId.. "/servers/Public?sortOrder=Asc&limit=100"))
			for i,v in pairs(sl.data) do
				if v.playing < v.maxPlayers and v.id ~= game.JobId then
					game:service'TeleportService':TeleportToPlaceInstance(game.PlaceId, v.id)
				end
			end
		end},
		["serverhopsmallest"] = {{},function(args)
			local sl = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/".. game.PlaceId.. "/servers/Public?sortOrder=Asc&limit=100"))
			local minimum,id = 100,nil
			for i,v in pairs(sl.data) do
				if v.playing < v.maxPlayers-1 and v.id ~= game.JobId and v.playing < minimum then
					minimum = v.playing
					id = v.id
				end
			end
			if id then
				game:service'TeleportService':TeleportToPlaceInstance(game.PlaceId, id)
			end
		end},
		["serverhoplargest"] = {{},function(args)
			local sl = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/".. game.PlaceId.. "/servers/Public?sortOrder=Asc&limit=100"))
			local maximum,id = 0,nil
			for i,v in pairs(sl.data) do
				if v.playing < v.maxPlayers-1 and v.id ~= game.JobId and v.playing > maximum then
					maximum = v.playing
					id = v.id
				end
			end
			if id then
				game:service'TeleportService':TeleportToPlaceInstance(game.PlaceId, id)
			end
		end},
		["serverhop2"] = {{},function(args)
			game:GetService('TeleportService'):Teleport(game.PlaceId, Player)
		end},
		["rejoin"] = {{},function(args)
			if #Players:GetPlayers() <= 1 then
				game:GetService('TeleportService'):Teleport(game.PlaceId, Player)
			else
				game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
			end
		end},
		["invisible"] = {{},function(args)
			if not RealChar then
				local Player = game:GetService("Players").LocalPlayer
				RealChar = Player.Character
				RealChar.Archivable = true
				local FakeChar = RealChar:Clone()

				for i,v in pairs(FakeChar:GetDescendants()) do
					if v:IsA("BasePart") then
						v.Material = Enum.Material.ForceField
					end
				end

				RealChar:MoveTo(Vector3.new(0,math.huge,0))
				RealChar.HumanoidRootPart.Anchored = true

				FakeChar.Parent = workspace
				Player.Character = FakeChar

				workspace.CurrentCamera.CameraSubject = FakeChar.Humanoid
				if FakeChar:FindFirstChild("Animate") then FakeChar.Animate.Disabled = true; FakeChar.Animate.Disabled = false end

				Visible = function()
					workspace.CurrentCamera.CameraSubject = RealChar.Humanoid

					RealChar.HumanoidRootPart.Anchored = false
					RealChar.HumanoidRootPart.CFrame = FakeChar.HumanoidRootPart.CFrame

					Player.Character = RealChar
					FakeChar:Destroy()
				end
			end

		end},
		["visible"] = {{},function()
			if Visible then
				Visible()
				Visible = nil
			end
		end},
		["noclip"] = {{},function()
			Storage["Noclip"] = RunService.Stepped:Connect(function()
				for _, child in pairs(Player.Character:GetDescendants()) do
					if child:IsA("BasePart") and child.CanCollide == true then
						child.CanCollide = false
					end
				end
			end)
		end},
		["clip"] = {{},function()
			if Storage["Noclip"] then Storage["Noclip"]:Disconnect() end
		end},
		["respawn"] = {{},function()
			if Storage["InvisFling"] then Storage["InvisFling"]:Disconnect() end
			if game.PlaceId == 7115420363 then
				game:GetService("ReplicatedStorage").Respawn:FireServer()
			elseif game.PlaceId == 9307193325 or game.PlaceId == 5100950559 then
				Global.ToggleChatFix = false
				local ChatBar = Player:WaitForChild("PlayerGui"):WaitForChild("Chat"):WaitForChild("Frame"):WaitForChild("ChatBarParentFrame"):WaitForChild("Frame"):WaitForChild("BoxFrame"):WaitForChild("Frame"):WaitForChild("ChatBar")
				local Text = ChatBar.Text
				ChatBar:SetTextFromInput("-gr")
				Players:Chat("-gr")
				ChatBar:SetTextFromInput(Text)
				Global.ToggleChatFix = true
			elseif Player.Character:FindFirstChild(Player.Name) then
				Player.Character.Head:Destroy()
			else
				local char = RealChar or Player.Character
				if char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid"):ChangeState(15) end
				char:ClearAllChildren()
				local newChar = Instance.new("Model")
				newChar.Parent = workspace
				Player.Character = newChar
				fwait()
				Player.Character = char
				newChar:Destroy()
			end
		end},
		["refresh"] = {{},function()
			local pos = Player.Character.HumanoidRootPart.CFrame
			Commands["respawn"][2]()
			Player.CharacterAdded:Wait()
			Player.Character:WaitForChild("HumanoidRootPart",500).CFrame = pos
		end},
		["fly"] = {{},function()
			if not Flying then
				local Player = game:GetService("Players").LocalPlayer
				local Character = RealChar or Player.Character
				local Root = Character.HumanoidRootPart

				Flying = true

				local Speed = 50

				local Controls = {
					Left = 0,
					Right = 0,
					Forward = 0,
					Back = 0,
					Up = 0,
					Down = 0,
				}

				local BodyGyro = Instance.new("BodyGyro"); do
					BodyGyro.P = 9e4
					BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
					BodyGyro.CFrame = Root.CFrame
					BodyGyro.Parent = Root
				end

				local BodyVelocity = Instance.new("BodyVelocity"); do
					BodyVelocity.Velocity = Vector3.new(0, 0, 0)
					BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
					BodyVelocity.Parent = Root
				end

				Character.Humanoid.PlatformStand = true

				Storage["FlyInputBegan"] = UserInputService.InputBegan:Connect(function(Key)
					if Key.KeyCode == Enum.KeyCode.W then
						Controls.Forward = 1
					elseif Key.KeyCode == Enum.KeyCode.S then
						Controls.Back = - 1
					elseif Key.KeyCode == Enum.KeyCode.A then
						Controls.Left = - 1
					elseif Key.KeyCode == Enum.KeyCode.D then 
						Controls.Right = 1
					elseif Key.KeyCode == Enum.KeyCode.E then
						Controls.Up = 1*2
					elseif Key.KeyCode == Enum.KeyCode.Q then
						Controls.Down = -1*2
					end
				end)

				Storage["FlyInputEnd"] = UserInputService.InputEnded:Connect(function(Key)
					if Key.KeyCode == Enum.KeyCode.W then
						Controls.Forward = 0
					elseif Key.KeyCode == Enum.KeyCode.S then
						Controls.Back =  0
					elseif Key.KeyCode == Enum.KeyCode.A then
						Controls.Left =  0
					elseif Key.KeyCode == Enum.KeyCode.D then 
						Controls.Right = 0
					elseif Key.KeyCode == Enum.KeyCode.E then
						Controls.Up = 0
					elseif Key.KeyCode == Enum.KeyCode.Q then
						Controls.Down = 0
					end
				end)

				while Flying do
					local Speed = Controls.Left == 0 and  Controls.Right == 0 and Controls.Forward == 0 and  Controls.Back == 0 and  Controls.Down == 0 and Controls.Up == 0 and 0 or 50
					if (Controls.Left + Controls.Right) ~= 0 or (Controls.Forward + Controls.Back) ~= 0 or (Controls.Down + Controls.Up) ~= 0 then
						BodyVelocity.Velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (Controls.Forward + Controls.Back)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(Controls.Left + Controls.Right, (Controls.Forward + Controls.Back + Controls.Down + Controls.Up) * 0.2, 0).Position) - workspace.CurrentCamera.CoordinateFrame.p)) * Speed
					else
						BodyVelocity.Velocity = Vector3.new(0, 0, 0)
					end
					BodyGyro.CFrame = workspace.CurrentCamera.CoordinateFrame
					fwait()
				end

				BodyGyro:destroy()
				BodyVelocity:destroy()
				Player.Character.Humanoid.PlatformStand = false
			end
		end},
		["unfly"] = {{},function()
			Flying = false
			if Storage["FlyInputEnd"] then Storage["FlyInputEnd"]:Disconnect() end
			if Storage["FlyInputBegan"] then Storage["FlyInputBegan"]:Disconnect() end
		end},
		["cleanfling"] = {{},function()
			local tool = Player.Character:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool")
			if tool then
				tool.Parent = Player.Backpack
				tool.Handle.Massless = true
				tool.GripPos = Vector3.new(5000, 5000, 5000)
				Player.Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(math.huge,math.huge,math.huge,math.huge,math.huge)
				tool.Parent = Player.Backpack
				tool.Parent = Player.Character
				Commands["noclip"][2]()
			end
		end},
		["invisfling"] = {{},function()
			RealChar = Player.Character
			local Root = RealChar.HumanoidRootPart

			Root.Transparency = 0
			RealChar.Archivable = true
			local FakeCharacter = RealChar:Clone(); do
				RealChar.Parent = workspace
				FakeCharacter.Parent = RealChar
				Player.Character = RealChar

				workspace.CurrentCamera.CameraSubject = Root
				task.wait(game.Players.RespawnTime+0.1)
			end

			Storage["InvisFling"] = Event:Connect(function()
				Root:ApplyImpulse(Vector3.new(-17.72,0,-17.72))
				Root.Velocity = Vector3.new(-17.72,0,-17.72)
			end)

			for i,v in pairs(RealChar:GetChildren()) do
				if v ~= Root and v.Name ~= "Humanoid" then
					v:Destroy()
				end
			end

			Commands["fly"][2]()
		end},
		["datalimit"] = {{"Number"},function(args)
			if tonumber(args[2]) then
				NetworkClient:SetOutgoingKBPSLimit(tonumber(args[2]))
			end
		end},
		["replicationlag"] = {{"Number"},function(args)
			if tonumber(args[2]) then
				settings():GetService("NetworkSettings").IncomingReplicationLag = tonumber(args[2])/1000
			end
		end},
		["goto"] = {{"Player"},function(args)
			local Plr = ShortName(args[2])
			if Plr then
				Player.Character.HumanoidRootPart.CFrame = Plr.Character:FindFirstChild("HumanoidRootPart") and Plr.Character.HumanoidRootPart.CFrame or Plr.Character:FindFirstChildOfClass("BasePart").CFrame
			end
		end},
		["jp"] = {{"Number"},function(args)
			local jpower = args[2] and tonumber(args[2]) or 50
			if Player.Character:FindFirstChildOfClass('Humanoid').UseJumpPower then
				Player.Character:FindFirstChildOfClass('Humanoid').JumpPower = jpower
			else
				Player.Character:FindFirstChildOfClass('Humanoid').JumpHeight  = jpower
			end
		end},
		["speed"] = {{"Number"},function(args)
			local jpower = args[2] and tonumber(args[2]) or 16
			Player.Character:FindFirstChildOfClass('Humanoid').WalkSpeed = jpower
		end},
		["gravity"] = {{"Number"},function(args)
			local jpower = args[2] and tonumber(args[2]) or 196.2
			workspace.Gravity = jpower
		end},
		["sit"] = {{},function(args)
			Player.Character.Humanoid.Sit = true
		end},
		["tptool"] = {{},function(args)
			local TpTool = Instance.new("Tool")
			TpTool.Name = "Teleport Tool"
			TpTool.RequiresHandle = false
			TpTool.Parent = Player.Backpack
			TpTool.Activated:Connect(function()
				local Char = RealChar or Player.Character or workspace:FindFirstChild(Player.Name)
				local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
				if not Char or not HRP then
					return warn("Failed to find HumanoidRootPart")
				end
				HRP.CFrame = CFrame.new(Mouse.Hit.X, Mouse.Hit.Y + 3, Mouse.Hit.Z, select(4, HRP.CFrame:components()))
			end)
		end},
		["friend"] = {{"Player"},function(args)
			local Plr = ShortName(args[2])
			if Plr then
				Plr:RequestFriendship(Plr)
			end
		end},
		["fireproximityprompt"] = {{},function(args)
			if fireproximityprompt then
				for i,v in pairs(workspace:GetDescendants()) do
					if v:IsA("ProximityPrompt") then
						fireproximityprompt(v)
					end
				end
			end
		end},
		["light"] = {{"Range","Brightness"},function(args)
			local light = Instance.new("PointLight")
			light.Parent = Player.Character:FindFirstChildOfClass("BasePart")
			light.Range = 30
			light.Brightness = args[3] or 5
			light.Range = args[2] or 8
		end},
		["split"] = {{},function(args)
			if Player.Character:FindFirstChild("Waist",true) then
				Player.Character.Character.UpperTorso.Waist:Destroy()
			end
		end},
		["firetouchinterests"] = {{},function(args)
			local Root = Player.Character:FindFirstChildOfClass("BasePart")
			local function Touch(x)
				x = x.FindFirstAncestorWhichIsA(x, "Part")
				if x then
					if firetouchinterest then
						return task.spawn(function()
							firetouchinterest(x, Root, 1, wait() and firetouchinterest(x, Root, 0))
						end)
					end
					x.CFrame = Root.CFrame
				end
			end
			for _, v in ipairs(workspace:GetDescendants()) do
				if v.IsA(v, "TouchTransmitter") then
					Touch(v)
				end
			end
		end},
		["kill"] = {{"Player"},function(args)
			local Plr = ShortName(args[2])
			local tool = Player.Character:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool")
			if Plr and tool then

				tool.Parent = Player.Backpack
				local Target = Plr.Character
				local Character = Player.Character

				local Humanoid = Character.Humanoid do
					local FakeHum = Humanoid:Clone()
					Humanoid.Name = ""
					FakeHum.Parent = Character
					Humanoid:Destroy()
				end

				tool.Parent = Character

				local Root = Character.HumanoidRootPart
				local TRoot = Target.HumanoidRootPart

				repeat
					Root.CFrame = TRoot.CFrame * CFrame.new(math.random(-1,1)/10,math.random(-1,1)/10,math.random(-1,1)/10)
					fwait()
				until tool.Parent == Target

				repeat
					Root.CFrame = CFrame.new(999999, workspace.FallenPartsDestroyHeight + 1,999999)
					fwait()
				until not Root or not TRoot or not Root.Parent or not TRoot.Parent
			end
		end},
		["kill2"] = {{"Player"},function(args)
			local Plr = ShortName(args[2])
			local tool = Player.Character:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool")
			if Plr and tool then
				local function AttachTool(RightArm,Tool,CF)
					for i,v in pairs(Tool:GetDescendants()) do
						if not (v:IsA("BasePart") or v:IsA("Mesh") or v:IsA("SpecialMesh")) then
							v:Destroy()
						end
					end

					local Grip = Instance.new("Weld"); do
						Grip.Name = "RightGrip"
						Grip.Part0 = RightArm
						Grip.Part1 = Tool.Handle
						Grip.C0 = CF
						Grip.C1 = Tool.Grip
						Grip.Parent = RightArm
					end

					Tool.Parent = Player.Backpack
					Tool.Parent = Player.Character.Humanoid
					Tool.Parent = Player.Character
					Tool.Handle:BreakJoints()
					Tool.Parent = Player.Backpack
					Tool.Parent = Player.Character.Humanoid

					Grip = Instance.new("Weld"); do
						Grip.Name = "RightGrip"
						Grip.Part0 = RightArm
						Grip.Part1 = Tool.Handle
						Grip.C0 = CF
						Grip.C1 = Tool.Grip
						Grip.Parent = RightArm
					end

					return Grip
				end

				local Target = Plr.Character
				local origpos = Player.Character.HumanoidRootPart.CFrame
				Player.Character.HumanoidRootPart.CFrame *= CFrame.new(0,math.huge,0)--= CFrame.new(8, 12, -25)
				task.wait(0.2)
				workspace.FallenPartsDestroyHeight = 0/0
				tool.Handle.CanCollide = false

				local attWeld = AttachTool(Player.Character:FindFirstChild("Right Hand") or Player.Character:FindFirstChild("RightArm"),tool,CFrame.new(-1,-6,0) * CFrame.Angles(math.rad(-90),0,0))

				Target.Humanoid.PlatformStand = true
				for i=1,20 do
					firetouchinterest(Target.HumanoidRootPart,tool.Handle,0)
				end


				--task.wait(.2)
				--Player.Character.HumanoidRootPart.CFrame *= CFrame.new(0,math.huge,0)

				task.wait(1)
				attWeld:Destroy()
				task.wait(.1)
				Player.Character:MoveTo(origpos.Position)
			end
		end},
		["plazakick"] = {{"Player"},function(args)
			local Plr = ShortName(args[2])
			local tool = Player.Character:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool")
			if Plr and tool then
				local function AttachTool(RightArm,Tool,CF)
					for i,v in pairs(Tool:GetDescendants()) do
						if not (v:IsA("BasePart") or v:IsA("Mesh") or v:IsA("SpecialMesh")) then
							v:Destroy()
						end
					end

					local Grip = Instance.new("Weld"); do
						Grip.Name = "RightGrip"
						Grip.Part0 = RightArm
						Grip.Part1 = Tool.Handle
						Grip.C0 = CF
						Grip.C1 = Tool.Grip
						Grip.Parent = RightArm
					end

					Tool.Parent = Player.Backpack
					Tool.Parent = Player.Character.Humanoid
					Tool.Parent = Player.Character
					Tool.Handle:BreakJoints()
					Tool.Parent = Player.Backpack
					Tool.Parent = Player.Character.Humanoid

					Grip = Instance.new("Weld"); do
						Grip.Name = "RightGrip"
						Grip.Part0 = RightArm
						Grip.Part1 = Tool.Handle
						Grip.C0 = CF
						Grip.C1 = Tool.Grip
						Grip.Parent = RightArm
					end

					return Grip
				end

				local Target = Plr.Character
				local origpos = Player.Character.HumanoidRootPart.CFrame
				Player.Character.HumanoidRootPart.CFrame = CFrame.new(8, 12, -25)
				task.wait(0.2)
				workspace.FallenPartsDestroyHeight = 0/0
				tool.Handle.CanCollide = false

				local attWeld = AttachTool(Player.Character:FindFirstChild("Right Hand") or Player.Character:FindFirstChild("RightArm"),tool,CFrame.new(-1,-6,0) * CFrame.Angles(math.rad(-90),0,0))

				Target.Humanoid.PlatformStand = true
				for i=1,20 do
					firetouchinterest(Target.HumanoidRootPart,tool.Handle,0)
				end


				--task.wait(.2)
				--Player.Character.HumanoidRootPart.CFrame *= CFrame.new(0,math.huge,0)

				task.wait(1)
				attWeld:Destroy()
				task.wait(.1)
				Player.Character:MoveTo(origpos.Position)
			end
		end},
		["psr"] = {{"Number"},function(args)
			local psr = tonumber(args[2]) or 30
			setfflag("S2PhysicsSenderRate", psr)
		end},
		["boothprint"] = {{},function()
			for i,v in pairs(workspace["Booth Blocks"]:GetChildren()) do
				print(v:WaitForChild("Board"):WaitForChild("BoothGui"):WaitForChild("BoothFrame"):WaitForChild("Description").Text)
			end
		end,
		},
		["aimkid"] = {{},function(args)
			GUI.TextBox.Frame.Frame.Visible = not GUI.TextBox.Frame.Frame.Visible
		end},
	}

	GUI.TextBox.FocusLost:Connect(function(EnterPressed)
		if EnterPressed then
			local Args = string.split(GUI.TextBox.Text," ")
			if Commands[string.lower(Args[1])] then
				Commands[string.lower(Args[1])][2](Args)
			end
		end
		GUI.TextBox.Text = ""
	end)

	Player.Chatted:Connect(function(msg)
		if string.sub(msg,1,1) == "!" then
			msg = string.sub(msg,2)
			local Args = string.split(msg," ")
			if Commands[string.lower(Args[1])] then
				Commands[string.lower(Args[1])][2](Args)
			end
		end
	end)

	for i,v in pairs(Commands) do
		local newlabel = Instance.new("TextLabel"); do
			newlabel.BackgroundTransparency = 1
			newlabel.Size = UDim2.new(1,0,0,20)
			newlabel.Font = Enum.Font.Gotham
			newlabel.TextSize = 14
			newlabel.TextColor3 = Color3.new(1,1,1)
			newlabel.LayoutOrder = i
		end--script.TextLabel:Clone()
		local txt = i
		for i,v in pairs(v[1]) do
			txt ..= " <" .. v .. ">"
		end
		newlabel.Text = txt
		newlabel.Parent = GUI.Frame.ScrollingFrame
	end
end

do -- [[ Commands GUI ]]
	local function drag(Frame,FrameToMove)
		local frametomove = FrameToMove
		local dragToggle,dragInput,dragStart,startPos
		local dragSpeed = 0
		local function updateInput(input)
			local Delta = input.Position - dragStart
			frametomove.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
		end
		Frame.InputBegan:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and game:GetService("UserInputService"):GetFocusedTextBox() == nil then
				dragToggle = true
				dragStart = input.Position
				startPos = frametomove.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragToggle = false
					end
				end)	
			end
		end)
		Frame.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragToggle then
				updateInput(input)
			end
		end)
	end
	drag(GUI.Frame.Frame,GUI.Frame)
	GUI.Frame.Frame.TextButton.Activated:Connect(function()
		GUI.Frame.Visible = false
	end)
end

do -- [[ Aimkid KeyChain ]]
	local lastY = 0
	local val = 0

	task.spawn(function() 
		while GUI do
			local Fram = RunService.RenderStepped:Wait()/(1/60)*0.6
			local X, Y, Z = Camera.CFrame:ToOrientation()
			if Toggle then
				if math.deg(Y) > lastY then
					val += Fram
				elseif math.deg(Y) < lastY then
					val -= Fram
				else
					val -= val/12
				end
				if val >= 30 then
					val -= Fram
				elseif val <= -30 then
					val += Fram
				end
			else
				if GUI.TextBox.Frame.Frame.Rotation > -180 then
					val -= Fram*15
				end
			end
			GUI.TextBox.Frame.Frame.Rotation = val
			lastY = math.deg(Y)

		end 
	end)
end

do -- [[ Toggle ]]
	UserInputService.InputBegan:Connect(function(input,gameprocess)
		if not gameprocess and input.KeyCode == Enum.KeyCode.LeftBracket then
			Toggle = not Toggle
			if Toggle then
				TweenService:Create(GUI.TextBox,TweenInfo.new(0.5),{Position=UDim2.new(0.5,0,0.1,0)}):Play()
				TweenService:Create(GUI.TextBox.Frame.Frame.ImageLabel,TweenInfo.new(0.5),{AnchorPoint=Vector2.new(0.25,0.25)}):Play()
			else
				TweenService:Create(GUI.TextBox,TweenInfo.new(0.5),{Position=UDim2.new(0.5,0,0,-70)}):Play()
				TweenService:Create(GUI.TextBox.Frame.Frame.ImageLabel,TweenInfo.new(0.5),{AnchorPoint=Vector2.new(0.1,0.1)}):Play()
			end
		end
	end)
	task.spawn(function()
		fwait(.1)
		TweenService:Create(GUI.TextBox,TweenInfo.new(0.5),{Position=UDim2.new(0.5,0,0,-70)}):Play()
		TweenService:Create(GUI.TextBox.Frame.Frame.ImageLabel,TweenInfo.new(0.5),{AnchorPoint=Vector2.new(0.1,0.1)}):Play()
	end)
end

do -- [[ Settings ]]
	local Settings = Global.AidKid or {
		MainColor = Color3.fromRGB(57, 0, 98),
		SecondaryColor = Color3.fromRGB(47, 0, 84),
		Image = "rbxassetid://4840955387" -- must use image id
	}
	for i,v in pairs(GUI:GetDescendants()) do
		if not v:IsA("UIListLayout") then
			if v.BackgroundColor3 == Color3.fromRGB(57, 0, 98) then
				v.BackgroundColor3 = Settings.MainColor
			elseif v.BackgroundColor3 == Color3.fromRGB(47, 0, 84) then
				v.BackgroundColor3 = Settings.SecondaryColor
			end
		end
	end
	GUI.TextBox.Frame.Frame.ImageLabel.ImageLabel.Image = Settings.Image
end

GUI.Parent = game:GetService("CoreGui")
printconsole(Version)
return LoadTick
