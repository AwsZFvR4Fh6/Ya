local LoadTick = tick()

-- [ Variables ] -- 

local Global = Global or getgenv and getgenv() or getrenv and getrenv() or getfenv and getfenv() or shared or _G

local _OG = {}; do
	_OG.readfile = readfileasync or readfile
	_OG.isfile = isfile or _OG.readfile and function(f) return pcall(function() _OG.readfile(f) end) end
	_OG.writefile = writefileasync or writefile
	_OG.decompile = decompile
	_OG.wait = wait
	_OG.getsynasset = getsynasset or getcustomasset
end

local printconsole = printconsole or print
local request = (syn and syn.request) or (http and http.request) or (request) or (http_request) or (httprequest)
local getconnections = getconnections or get_connections or get_signal_cons
local setreadonly = setreadonly or make_readonly or makereadonly

local fwait = task.wait
local issyn = syn ~= nil
local Player,notify,Event,Settings,Part
local syng = syn or {}; 
local http = http or {};
local WindowFocused = true

local FolderPath = "MarchAutoexec/"

local Sethiddenproperty; do -- sethiddenproperty compatability
	local shp = sethiddenproperty or set_hidden_property or sethiddenprop or setscriptable and function(loc,prop,val)
		if not loc then
			return true
		end 
		if not pcall(function() local a = loc[prop] end)  then
			setscriptable(loc,prop,true)
		end 
		loc[prop] = val
	end or function() end

	Sethiddenproperty = function(loc,prop,val) -- krnl has a broken sethiddenproperty
		return pcall(function()
			shp(loc,prop,val)
		end)
	end
end

local Gethiddenproperty; do -- gethiddenproperty compatability
	local shp = gethiddenproperty or get_hidden_property or gethiddenprop or get_hidden_prop or setscriptable and function(loc,prop)
		if not pcall(function() local a = loc[prop] end)  then
			setscriptable(loc,prop,true)
		end 
		return loc[prop]
	end or function() end

	Gethiddenproperty = function(loc,prop,val) -- krnl has a broken sethiddenproperty
		local Result; pcall(function()
			Result = shp(loc,prop,val)
		end) return Result
	end
end

local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ChatService = game:GetService("Chat")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local HTTP = game:GetService("HttpService")
local NetworkClient = game:GetService("NetworkClient")
local Players = game:GetService("Players")

-- [ Functions ] -- 

local function RequestURL(URL,KeepActive)
	local Data,Temp; if request then 
		Data,Temp = request({Url = URL,Method = 'GET'}); Data = Data.Body
	else 
		Data,Temp = game:HttpGetAsync(URL)
	end
	return Data
end; 

local function SetGlobal(Name,Var)
	Global[Name] = Var
	if not Global[Name] then
		if getrenv then
			getrenv()[Name] = Var
		elseif getfenv then
			getfenv()[Name] = Var
		elseif shared then
			shared[Name] = Var
		elseif _G then
			_G[Name] = Var
		end
	end
end

local function SetAllGlobals(AllNames,Var)
	for i,v in pairs(AllNames) do
		SetGlobal(v,Var)
	end
end

local function ForceTableGlobal(MainTable,Name,Var)
	if setreadonly then
		setreadonly(MainTable,false)
		MainTable[Name] = Var
		setreadonly(MainTable,true)
	else
		pcall(function()
			MainTable[Name] = Var
		end)
	end
end

local function readfile(Name)
	return _OG.readfile(FolderPath .. Name)
end

local function isfile(Name)
	return _OG.isfile(FolderPath .. Name)
end

local function writefile(Name,Data)
	return _OG.writefile(FolderPath .. Name,Data)
end

local function getsynasset(Name)
	return _OG.getsynasset(FolderPath .. Name)
end

local function IsGameLoaded()
	if not game:IsLoaded("Workspace") then game.Loaded:Wait() end
end

local function GetLinkedAsset(Link)
	local Name = string.split(Link,"/"); Name = Name[#Name]
	local File
	if getsynasset and string.find(Name,".") then
		if not isfile(Name) then
			writefile(Name,RequestURL(Link))
		end
		File = getsynasset(Name)
	end
	return File
end; 

local function RoundNumber(number, decimalPlaces) if number and tonumber(number) then
		decimalPlaces = decimalPlaces or 4
		local Negative = math.abs(number) ~= number and -1 or 1; number = math.abs(number)
		local Return = tostring(math.round(tonumber(number) * 10^decimalPlaces) * 10^-decimalPlaces)
		return string.find(Return,".") and tonumber(string.sub(Return,1,string.find(Return,".")+decimalPlaces+1)) or tonumber(Return)
	end
end; 

local function GetToPath(From,Directory)
	for i,v in pairs(string.split(Directory,".")) do
		From = From:WaitForChild(v,5000)
	end return From
end

local function SaveSettings()
	local SettingsString = "return {"
	for i,v in pairs(Settings) do
		SettingsString ..= "\n\t" .. tostring(i) .. " = " .. tostring(v)
	end
	SettingsString ..= SettingsString .. "\n}"
	writefile("settings.lua",SettingsString)
end

-- [ Code ] -- 

Settings = loadstring(readfile("settings.lua"))()
Event = RunService.Heartbeat

if Settings.ExtraGlobals then
	do -- :: Compatibility Fixes
		local GlobalAlternates = {
			--// Meta Table Functions \--

			[{
				"get_raw_metatable","getmetatable",{debug,"getmetatable"},
			}] = debug.getmetatable or get_raw_metatable or getrawmetatable,
			[{
				"set_raw_metatable","setrawmetatable",{debug,"setmetatable"},
			}] = debug.setmetatable or set_raw_metatable or setrawmetatable,
			[{
				"iswriteable","writeable","is_writeable"
			}] = iswriteable or writeable or is_writeable,
			[{
				"setreadonly","makereadonly","make_readonly"
			}] = setreadonly,

			--// Mouse Inputs \--

			[{
				"mouse1release","syn_mouse1release","m1release","m1rel","mouse1up"
			}] = mouse1release or syn_mouse1release or m1release or m1rel or mouse1up,
			[{
				"mouse1press","m1press","mouse1click"
			}] = mouse1press or m1press or mouse1click,
			[{
				"mouse2release","syn_mouse2release","m2release","m1rel","mouse2up"
			}] = mouse2release or syn_mouse2release or m2release or m1rel or mouse2up,
			[{
				"mouse2press","mouse2press","m2press","mouse2click"
			}] = mouse2press or mouse2press or m2press or mouse2click,

			--// IO Functions \--

			[{
				"isfolder","syn_isfolder","is_folder"
			}] = isfolder or syn_isfolder or is_folder,
			[{
				"delfolder","syn_delsfolder","del_folder"
			}] = delfolder or syn_delsfolder or del_folder,
			[{
				"appendfile","syn_io_append","append_file"
			}] = appendfile or syn_io_append or append_file,
			[{
				"makefolder","make_folder","createfolder","create_folder"
			}] = makefolder or make_folder or createfolder or create_folder,
			[{
				"getsynasset","getcustomasset"
			}] = _OG.getsynasset,
			[{
				"write_clipboard","writeclipboard","setclipboard","set_clipboard",{syng,"write_clipboard"}
			}] = write_clipboard or writeclipboard or setclipboard or set_clipboard or syng.write_clipboard,

			--// Environment Manipulation Functions \--

			[{
				"hookfunction","hookfunc","detour_function"
			}] = hookfunction or hookfunc or detour_function,
			[{
				"hookmetamethod","hook_meta_method"
			}] = hookmetamethod or hook_meta_method,
			[{
				"islclosure","is_lclosure","isluaclosure"
			}] = islclosure or is_lclosure or isluaclosure,
			[{
				"iscclosure","is_cclosure"
			}] = iscclosure or is_cclosure,
			[{
				"newcclosure","new_cclosure"
			}] = newcclosure or new_cclosure,
			[{
				"clonereference","cloneref"
			}] = clonereference or cloneref or function(Inst) return Inst end,
			[{
				"getconnections","get_connections","get_signal_cons"
			}] = getconnections,
			[{
				"getnamecallmethod","get_namecall_method"
			}] = getnamecallmethod or get_namecall_method,
			[{
				"setnamecallmethod","set_namecall_method"
			}] = setnamecallmethod or set_namecall_method,
			[{
				"_G","shared","Global"
			}] = Global,
			[{
				"getgenv"
			}] = function() return Global end,
			[{
				"getfenv",{debug,"getfenv"}
			}] = debug.getfenv or getfenv,
			[{
				"setfflag"
			}] = setfflag or function(flag,bool) game:DefineFastFlag(flag,bool) end,
			[{
				"fire_signal","firesignal"
			}] = fire_signal or firesignal or getconnections and function(Signal)
				for i,v in pairs(getconnections(Signal)) do
					v:Fire()
				end
			end,

			--// Instance Functions \--

			[{
				"getnilinstances","get_nil_instances"
			}] = getnilinstances or get_nil_instances,
			[{
				"fireclickdetector","fire_click_detector"
			}] = fireclickdetector or fire_click_detector,
			[{
				"gethiddenproperty","gethiddenproperty","gethiddenprop","get_hidden_prop"
			}] = Gethiddenproperty,
			[{
				"sethiddenproperty","set_hidden_property","sethiddenprop"
			}] = Sethiddenproperty,
			[{
				"getrunningscripts","getscripts","get_running_scripts","get_scripts"
			}] = getrunningscripts or getscripts or get_running_scripts or get_scripts,

			--// Network Functions \--

			[{
				"setsimradius","set_simulation_radius","setsimulationradius"
			}] = setsimradius or set_simulation_radius or setsimulationradius,
			[{
				"getsimradius","get_simulation_radius","getsimulationradius"
			}] = getsimradius or get_simulation_radius or getsimulationradius,
			[{
				"isnetowner","isnetworkowner","is_network_owner"
			}] = isnetworkowner or function(Part) return Part.ReceiveAge == 0 end,
			[{
				"request","http_request","httprequest",{syng,"request"},{http,"request"}
			}] = function(Table)
				if Table and typeof(Table) == "table" and Table.Method and Table.Method == "GET" then
					return RequestURL(Table.Url)
				else
					return request(Table)
				end
			end,

			--// Script Methods \--

			[{
				"getthreadcontext","get_thread_context","getthreadidentity","get_thread_identity"
			}] = getthreadcontext or get_thread_context or getthreadidentity or get_thread_identity,
			[{
				"setthreadcontext","set_thread_context","setthreadidentity","set_thread_identity"
			}] = setthreadcontext or set_thread_context or setthreadidentity or set_thread_identity,
			[{
				"getcallingscript","get_calling_script"
			}] = getcallingscript or get_calling_script,
			[{
				"KRNL_SAFE_CALL","securecall","secure_call",{syng,{"securecall"}}
			}] = KRNL_SAFE_CALL or securecall or secure_call or syng.securecall,

			--// Misc Functions \--

			[{
				"iswindowactive","isrbxactive"
			}] = iswindowactive or isrbxactive or WindowFocused,
			[{
				"queue_on_teleport","queueonteleport",{syng,"queue_on_teleport"}
			}] = queue_on_teleport or queueonteleport or syng.queue_on_teleport,
			[{
				{syng,"protect_gui"}
			}] = syng.protect_gui or function(GUI) return GUI end,
			[{
				{syng,"unprotect_gui"}
			}] = syng.unprotect_gui or function(GUI) return GUI end,
			[{
				{syng,"unprotect_gui"}
			}] = syng.unprotect_gui or function(GUI) return GUI end,
			[{
				"http"
			}] = http,
			[{
				"luau"
			}] = true,
			[{
				"printconsole"
			}] = printconsole,
			[{
				"gethui"
			}] = not issyn or gethui,
		}

		for Names,Value in pairs(GlobalAlternates) do
			for _,Name in pairs(Names) do
				if typeof(Name) == "table" then
					ForceTableGlobal(Name[1],Name[2],Value)
				else
					SetGlobal(Name,Value)
				end
			end
		end

		if getproperties then
			SetAllGlobals({"getproperties","get_properties"},getproperties or get_properties)
			SetAllGlobals({"gethiddenproperties","get_hidden_properties"},gethiddenproperties or get_hidden_properties)
		else
			task.defer(function()
				local Properties = {}
				local HiddenProperties = {}

				local Data = HTTP:JSONDecode(RequestURL("https://raw.githubusercontent.com/CloneTrooper1019/Roblox-Client-Tracker/roblox/API-Dump.json"))
				local DataFix = {}
				for i,v in pairs(Data.Classes) do
					DataFix[v.Name] = v
				end

				for i,v in pairs(DataFix) do
					if not Properties[i] then Properties[i] = {Properties={},Superclass=v.Superclass} end
					if not HiddenProperties[i] then HiddenProperties[i] = {Properties={},Superclass=v.Superclass} end
					for _,v in pairs(v.Members) do
						if v.MemberType == "Property" then
							if v.Tags and table.find(v.Tags,"NotScriptable") then
								table.insert(HiddenProperties[i].Properties,v.Name)
							elseif v.Tags and table.find(v.Tags,"Hidden") and v.Security.Read ~= "None" then
								table.insert(HiddenProperties[i].Properties,v.Name)
							else
								table.insert(Properties[i].Properties,v.Name)
							end
						end
					end
					task.defer(function()
						local superclass = v.Superclass
						repeat 
							repeat fwait() until Properties[superclass]
							if Properties[superclass] then
								for index,v in pairs(Properties[superclass].Properties) do
									if not table.find(Properties[i].Properties,v) then
										table.insert(Properties[i].Properties,v)
									end
								end
								for index,v in pairs(HiddenProperties[superclass].Properties) do
									if not table.find(HiddenProperties[i].Properties,v) then
										table.insert(HiddenProperties[i].Properties,v)
									end
								end
							end
							superclass = Properties[superclass].Superclass
						until superclass == "<<<ROOT>>>"
					end)

					if not table.find(Properties[i].Properties,"Parent") then
						table.insert(Properties[i].Properties,"Parent")
					end
				end

				SetAllGlobals({"getproperties","get_properties"},function(Instance)
					local Table = {}
					for i,v in pairs(Properties[Instance.ClassName].Properties) do
						Table[v] = Instance[v]
					end
					return Table
				end) 
				SetAllGlobals({"gethiddenproperties","get_hidden_properties"},function(Instance)
					local Table = {}
					for i,v in pairs(HiddenProperties[Instance.ClassName].Properties) do
						Table[v] = Gethiddenproperty(Instance,v)
					end
					return Table
				end)
			end)
		end

		task.defer(function() -- :: gethiddengui
			loadstring(RequestURL("https://raw.githubusercontent.com/AwsZFvR4Fh6/Ya/main/gethiddengui.lua"))() 
		end)
	end
	Global.GetFileFromURL = GetLinkedAsset
	Global.RoundNumber = RoundNumber
	Global.RequestURL = RequestURL

	Global.isproperty = function(Inst,Property)
		return pcall(function()
			return Gethiddenproperty and Gethiddenproperty(Inst,Property) and true or Inst[Property] and true
		end)
	end

	Global.RandomString = function(Amount)
		local nString = ""
		for _ = 1, Amount or math.random(5,20) do
			nString = string.upper(nString .. string.char(math.random(33, 126)))
		end
		return nString
	end; Global.nCreate = Global.RandomString

	Global.WaitForDescendant = function(Start,Name)
		local Find = Start:FindFirstChild(Name,true)
		local DescendantAdded = Start.DescendantAdded:Connect(function(New)
			if New.Name == Name then Find = New end
		end)
		repeat Find = Start:FindFirstChild(Name,true) fwait(0/1) until Find
		DescendantAdded:Disconnect()
		return Find
	end

	Global.WaitForChildOfClass = function(Start,Class)
		local Find = Start:FindFirstChildOfClass(Class)
		if Find then return Find
		else
			local Table = {}
			local ChildAdded
			ChildAdded = Start.ChildAdded:Connect(function(v)
				if v:IsA(Class) and not table.find(Table,v) then Find = v else table.insert(Table,v) end
			end)
			for i,v in pairs(Start:GetChildren()) do
				if v:IsA(Class) then Find = v else table.insert(Table,v) end
			end
			repeat Start.ChildAdded:Wait() until Find; ChildAdded:Disconnect() return Find
		end

	end

	Global.WaitForDescendantOfClass = function(Start,Class)
		local Find = Start:FindFirstChildOfClass(Class,true)
		if Find then return Find
		else
			local Table = {}
			local DescendantAdded
			DescendantAdded = Start.DescendantAdded:Connect(function(v)
				if v:IsA(Class) and not table.find(Table,v) then Find = v else table.insert(Table,v) end
			end)
			for i,v in pairs(Start:GetDescendants()) do
				if v:IsA(Class) then Find = v else table.insert(Table,v) end
			end
			repeat Start.DescendantAdded:Wait() until Find; DescendantAdded:Disconnect() return Find
		end
	end

	do -- :: fwait and pwait
		local Bind = Instance.new("BindableEvent")
		local PingBind = Instance.new("BindableEvent")
		local PingVal,PingVal2 = 0,0
		local Ping; task.spawn(function() Ping = GetToPath(game:GetService("Stats"),"Network.ServerStatsItem.Data Ping") PingVal = Ping:GetValue()/1000 end)
		local VarTick = tick()

		local function Fire()
			Bind:Fire(tick()-VarTick)
			VarTick = tick()

			local GetValue = Ping and Ping:GetValue()
			if GetValue and GetValue ~= PingVal then
				PingVal = GetValue
				PingBind:Fire(PingVal/1000)
			end
			
			repeat fwait(0/1) until Player or Players.LocalPlayer
			local GetNetworkPing = Player and Player:GetNetworkPing() or Players.LocalPlayer and Players.LocalPlayer:GetNetworkPing()
			if GetNetworkPing and GetNetworkPing ~= PingVal2 then
				PingVal2 = GetNetworkPing
				PingBind:Fire(PingVal2)
			end
		end

		for i,v in ipairs({"RenderStepped","PreAnimation","Stepped","Heartbeat","PostSimulation","PreSimulation","PreRender"}) do
			RunService[v]:Connect(Fire)
		end;

		local function FastWait(Num)
			if Num and Num > 0 then
				local Tick = 0
				repeat
					Tick += Bind.Event:Wait()
				until Tick >= Num
				return Tick

			else
				return Bind.Event:Wait()
			end
		end
		local function PingWait()
			return PingBind.Event:Wait()
		end

		fwait = FastWait
		Global.fwait = FastWait
		Global.Event = Bind.Event

		Global.pwait = PingWait
		Global.pEvent = PingBind.Event

		Event = Bind.Event
	end

	Global.decompile = function(script)
		return "--  Advanced Decompiler by ProductionTakeOne#3330 \n" .. string.gsub(string.gsub(_OG.decompile(script),"l__",""),"__1","")
	end

	task.defer(function() -- :: ServerInfo
		local peer,replicator = NetworkClient.ConnectionAccepted:Wait()
		local data = game:GetService("HttpService"):JSONDecode(RequestURL("http://ip-api.com/json/" .. peer:sub(1, peer:find("|")-1)))
		local ServerInfo = {
			Country = data.country,
			CountryCode = data.countrycode,
			State = data.regionName,
			StateCode = data.region,
			City = data.city,
			ZIP = data.zip,
			Latitude = data.lat,
			Longitude = data.lon,
			TimeZone = data.timezone,
			IP = data.query,
		}

		Global.ServerInfo = ServerInfo

		repeat fwait(0/1) until notify
		if notify ~= "Disabled" then
			Global.Notify = notify
			notify({
				Text = "Connected to " .. ServerInfo.State .. ", " .. ServerInfo.City .. " in " .. ServerInfo.Country,
				Duration = 10
			})
		end
	end)

	Global.wait = function(Time)
		if Time then
			return fwait(Time)
		else
			return fwait(1/30)
		end
	end

	Global.syn = syng
end

if Settings.KickGui then
	task.defer(function()
		GetToPath(CoreGui,"RobloxPromptGui.promptOverlay").ChildAdded:Connect(function(v)
			if v.Name == "ErrorPrompt" then
				if Settings.RejoinOnKick then
					if #Players:GetPlayers() <= 1 then
						TeleportService:Teleport(game.PlaceId, Player or Players.LocalPlayer)
					else
						TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player or Players.LocalPlayer)
					end
				end

				GuiService:ClearError()
				local ErrorText = v:FindFirstChild("ErrorMessage",true)
				v.Visible = false
				local VideoFrame = Instance.new("VideoFrame"); do
					VideoFrame.AnchorPoint = Vector2.new(0.5,1)
					VideoFrame.BackgroundTransparency = 1
					VideoFrame.Position = UDim2.new(0.5,0,0.8,0)
					VideoFrame.Size = UDim2.new(0,450,0,225)
					VideoFrame.ZIndex = 999999998
					VideoFrame.Looped = true
					VideoFrame.Video = GetLinkedAsset("https://cdn.discordapp.com/attachments/806623634038325318/957076752843280424/one-piece-vinsmoke-sanji.webm") or "rbxassetid://5670785995"
					VideoFrame:Play()
					VideoFrame.Parent = CoreGui.RobloxPromptGui
				end
				local TextLabel = Instance.new("TextLabel"); do
					TextLabel.AnchorPoint = Vector2.new(0.5,0)
					TextLabel.BackgroundTransparency = 1
					TextLabel.Position = UDim2.new(0.5,0,1,0)
					TextLabel.Size = UDim2.new(1,0,0.3,0)
					TextLabel.ZIndex = 999999998
					TextLabel.Font = Enum.Font.Gotham
					TextLabel.TextSize = 20
					TextLabel.Text = ErrorText.Text
					TextLabel.TextColor3 = Color3.new(1,1,1)
					TextLabel.TextStrokeTransparency = 0
					TextLabel.Parent = VideoFrame
					ErrorText.Changed:Connect(function()
						TextLabel.Text = ErrorText.Text
					end)
				end
				local TextButton = Instance.new("TextButton"); do
					TextButton.AnchorPoint = Vector2.new(0,0)
					TextButton.Size = UDim2.new(1,0,1,0)
					TextButton.ZIndex = 999999999
					TextButton.Text = ""
					TextButton.Transparency = 1
					TextButton.Parent = VideoFrame
					TextButton.Activated:Connect(function()
						VideoFrame:Destroy()
					end)
				end
				RunService:SetRobloxGuiFocused(false)
				repeat GuiService:ClearError() fwait(0/1) until not VideoFrame
			end
		end)
	end)
end

if Settings.FastLoad then
	task.defer(function()
		local RobloxLoadingGui = GetToPath(CoreGui,"RobloxLoadingGUI")
		GetToPath(RobloxLoadingGui,"BackgroundScreen").Enabled = false
		RunService:SetRobloxGuiFocused(false)
		
		local InfoFrame = GetToPath(RobloxLoadingGui,"MainScreen.DarkGradient.InfoFrame")
		InfoFrame.BackgroundTransparency = 1
		InfoFrame.AnchorPoint = Vector2.new(0,1)
		InfoFrame.Position = UDim2.fromScale(0,1)
		
		local IconFrame = GetToPath(InfoFrame,"IconFrame")
		IconFrame.AnchorPoint = Vector2.new(0,1)
		IconFrame.Position = UDim2.fromScale(0,1)
		
		local TextLayout = GetToPath(InfoFrame,"TextLayout")
		GetToPath(TextLayout,"UIListLayout"):Destroy()
		GetToPath(TextLayout,"Padding"):Destroy()
		TextLayout.AnchorPoint = Vector2.new(0,1)
		TextLayout.Position = UDim2.new(0,IconFrame.Size.X.Offset+5,1,0)
		
		local CreatorLabel = GetToPath(TextLayout,"CreatorLabel")
		CreatorLabel.AnchorPoint = Vector2.new(0,1)
		CreatorLabel.Position = UDim2.new(0,0,1,18)
		CreatorLabel.Size = UDim2.new(0.6,0,0,16)
		CreatorLabel.AutomaticSize = Enum.AutomaticSize.None
		CreatorLabel.TextXAlignment = Enum.TextXAlignment.Left
		
		local PlaceLabel = GetToPath(TextLayout,"PlaceLabel")
		PlaceLabel.AnchorPoint = Vector2.new(0,0)
		PlaceLabel.Position = UDim2.new(0,0,1,18)
		PlaceLabel.Size = UDim2.new(0.8,0,0,30)
		PlaceLabel.AutomaticSize = Enum.AutomaticSize.None
		PlaceLabel.TextYAlignment = Enum.TextYAlignment.Bottom
		PlaceLabel.TextXAlignment = Enum.TextXAlignment.Left
		
		local ServerFrame = GetToPath(RobloxLoadingGui,"MainScreen.DarkGradient.ServerFrame")
		ServerFrame.AnchorPoint = Vector2.new(0.5,0)
		ServerFrame.Position = UDim2.new(0.5,0,0,0)
		
		local JoinText = GetToPath(ServerFrame,"JoinText")
		JoinText.Position = UDim2.new(0,0,0,0)
	end)
	Part = Instance.new("Part"); do
		Part.Size = Vector3.new(5,1,5)
		Part.CFrame = CFrame.Angles(0,math.rad(-90),0)--CFrame.new(Vector3.new(),workspace.CurrentCamera.CFrame.Position)
		Part.Transparency = 1
		Part.Parent = workspace
	end
	local Surface = Instance.new("SurfaceGui"); do
		Surface.Face = Enum.NormalId.Top
		Surface.Parent = Part
	end
	local Image = Instance.new("ImageLabel"); do
		Image.Size = UDim2.new(1,0,1,0)
		Image.BackgroundTransparency = 1
		Image.Image = GetLinkedAsset("https://cdn.discordapp.com/attachments/806690952089305158/954924304238260284/FN_nKHuUcAAY8H4.png") or "rbxassetid://9184481698"
		Image.Parent = Surface
	end
end

if Settings.DisablePrompts then
	task.defer(function()
		GetToPath(CoreGui,"PurchasePrompt.ProductPurchaseContainer").Visible = false
	end)
end
--[[
if Settings.ToggleGUI then
	task.defer(function()
		Global.AidKid = Settings.GUISettings
		loadstring(RequestURL("https://raw.githubusercontent.com/AwsZFvR4Fh6/Ya/main/KenzenGui.lua"))()
	end)
end]]

IsGameLoaded(); Part:Destroy()
local GameLoadedIn = tick() - LoadTick
printconsole(tostring("Game loaded in " .. RoundNumber(GameLoadedIn) .. " (" .. RoundNumber(GameLoadedIn)*10000 .. "ms)"))

Player = Players.LocalPlayer

if Settings.DisableConnections and getconnections then
	local ConnectionsToDisable = {
		GuiService.MenuOpened,
		GuiService.MenuClosed,
	}; for _,v in pairs(ConnectionsToDisable) do
		for _,Connection in pairs(getconnections(v)) do
			Connection:Disable()
		end
	end
end

if Settings.Backrooms then
	local function RootCheck(Char)
		local HumRoot = Char:WaitForChild("HumanoidRootPart",500)
		local HB
		HB = game:GetService("RunService").Heartbeat:Connect(function()
			if HumRoot and HumRoot.Parent then
				if HumRoot.Position.Y <= workspace.FallenPartsDestroyHeight + 10 then
					game:GetService("TeleportService"):Teleport(3227921645, Player)
					HB:Disconnect()
				end
			else
				HB:Disconnect()
			end
		end)
	end Player.CharacterAdded:Connect(function(Character)
		RootCheck(Character) 
	end) if Player.Character then RootCheck(Player.Character) end
end

if Settings.ChatFilterLabel then
	task.defer(function()
		local ChatBar = GetToPath(Player,"PlayerGui.Chat.Frame.ChatBarParentFrame")
		local ChatBox = GetToPath(ChatBar,"Frame.BoxFrame.Frame.ChatBar")
		local TextLabel = Instance.new("TextLabel"); do
			TextLabel.Size = UDim2.new(1,0,0,42)
			TextLabel.Position = UDim2.new(0,5,1,0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.TextStrokeTransparency = 0
			TextLabel.TextColor3 = Color3.new(1,1,1)
			TextLabel.Text = ChatBox.Text
			TextLabel.TextSize = 15
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.TextYAlignment = Enum.TextYAlignment.Top
			TextLabel.Parent = ChatBar
		end
		local bool = true
		ChatBox.Changed:Connect(function()
			if bool then
				bool = false
				pcall(function()
					TextLabel.Text = ChatService:FilterStringForBroadcast(ChatBox.Text,Player)
				end) 
				bool = true
			end
		end)
	end)
end

if Settings.Notifications then
	notify = Settings.Notifications and loadstring(RequestURL("https://raw.githubusercontent.com/CenteredSniper/Kenzen/master/extra/Notifications.lua"))() or "Disabled"
end

if Settings.AntiAFK then 
	task.defer(function()
		loadstring(RequestURL("https://raw.githubusercontent.com/NoTwistedHere/Roblox/main/AntiAFK.lua"))()
	end) 
end

if Settings.SecureEnvironment then 
	if issyn then
		loadstring(RequestURL("https://raw.githubusercontent.com/IHaxU/SecureSynapseEnv/main/SecureSynapseEnv.lua"))()
	end 
end

local loadedtime = (tick() - LoadTick)

printconsole(tostring("V4 Autoexec loaded in " .. RoundNumber(loadedtime) .. " (" .. RoundNumber(loadedtime)*10000 .. "ms)"))

if notify ~= "Disabled" then
	notify({Text = "Game loaded in " .. math.abs(GameLoadedIn),Duration = 5})
end

