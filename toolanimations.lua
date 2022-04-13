--local preloadanimations = true -- enable this if you want to preload all animations (lagspike)
local function getsynassetfromurl(URL,Name)
	if not isfolder("FakeAudios") then makefolder("FakeAudios") end
	Name = "FakeAudios/" .. Name
	local getsynasset, request = getsynasset or getcustomasset or error('invalid attempt to \'getsynassetfromurl\' (custom asset retrieval function expected)'), (syn and syn.request) or (http and http.request) or (request) or error('invalid attempt to \'getsynassetfromurl\' (http request function expected)')
	if isfile(Name .. ".ogg") then
		return getsynasset(Name .. ".ogg")
	else
		local Extension, Types, URL = '', {'.png', '.webm'}, assert(tostring(type(URL)) == 'string', 'invalid argument #1 to \'getsynassetfromurl\' (string [URL] expected, got '..tostring(type(URL))..')') and URL or nil
		local Response, TempFile = request({
			Url = URL,
			Method = 'GET'
		})

		if Response.StatusCode == 200 then
			Extension = Response.Body:sub(2, 4) == 'PNG' and '.png' or Response.Body:sub(25, 28) == 'webm' and '.webm' or nil
		end

		if Response.StatusCode == 200 then--and (Extension and table.find(Types, Extension)) then
			for i = 1, 15 do
				local Letter, Lower = string.char(math.random(65, 90)), math.random(1, 5) == 3 and true or false
			end

			writefile(Name..".ogg", Response.Body)

			return getsynasset(Name..".ogg")
		elseif Response.StatusCode ~= 200 or not Extension then
			warn('unexpected \'getsynassetfromurl\' Status Error: ' .. Response.StatusMessage .. ' ('..URL..')')
		elseif not (Extension) then
			warn('unexpected \'getsynassetfromurl\' Error: (PNG or webm file expected)')
		end
	end
end

if getgenv().Preload == nil then getgenv().Preload = false end
if getgenv().PreloadWait == nil then getgenv().PreloadWait = 0.1 end
if getgenv().Reanimate == nil then getgenv().Reanimate = true end

local Files = game:GetObjects("rbxassetid://9353862873")[1]
if getgenv().Preload then
	local GUI = Files.ScreenGui:Clone()
	GUI.Parent = game.CoreGui
	local LoadAmount,NumberToLoad = 0,#Files.Folder:GetChildren()
	for i,v in pairs(Files.Folder:GetChildren()) do
		if getgenv().PreloadWait > (1/60) then
			task.wait(getgenv().PreloadWait)
		end
		task.spawn(function()
			local AnimationID,soundid = v.ToolTip,v.SoundID.SoundId
			if soundid then
				local soundwait = Instance.new("Sound",game.Players.LocalPlayer)
				soundwait.SoundId = v:FindFirstChild("FakeAsset") and getsynassetfromurl(v.FakeAsset.Value,v.ToolTip) or v.SoundID.SoundId
				task.spawn(function()
					soundwait.Loaded:Wait()
					soundwait:Destroy()    
				end)
			end
			if AnimationID then
				pcall(function()
					game:GetObjects('rbxassetid://'..AnimationID)
				end)
			end

			loadamount = loadamount + 1
			print(loadamount,NumberToLoad)
		end)
	end
	repeat task.wait(0/1) until loadamount == NumberToLoad
	GUI:Destroy()
end

if getgenv().Reanimate then
	getgenv().AutoAnimate = false
	loadstring(game:HttpGet("https://raw.githubusercontent.com/CenteredSniper/Kenzen/master/newnetlessreanimate.lua",true))()
	task.wait(0/1)
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/AwsZFvR4Fh6/Ya/main/AnimZ.lua",true))()

for i,v in pairs(Files.Folder:GetChildren()) do
	task.spawn(function()
		local tool = v --:Clone()
		tool.Parent = game.Players.LocalPlayer.Backpack
		task.wait(0/1)
		local ToolPlaying = false
		tool.Activated:Connect(function()
			if getgenv().RunAnimation then
				local SoundID = v:FindFirstChild("FakeAsset") and getsynassetfromurl(v.FakeAsset.Value,v.ToolTip) or v.SoundID.SoundId
				ToolPlaying = true
				getgenv().RunAnimation(v.ToolTip,SoundID)
			end
		end)
		tool.Unequipped:Connect(function()
			if ToolPlaying then
				ToolPlaying = false
				getgenv().RunAnimation()
			end
		end)
	end)
end
