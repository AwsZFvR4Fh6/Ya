--local preloadanimations = true -- enable this if you want to preload all animations (lagspike)
if not getgenv().preloadanimations then getgenv().preloadanimations = false end
if not getgenv().loadtime then getgenv().loadtime = 0.1 end
if not getgenv().reanimate then getgenv().reanimate = true end

local wait = getgenv().MiliWait and getgenv().MiliWait.Event or game:GetService("RunService").Heartbeat --task.wait

local files = game:GetObjects("rbxassetid://9136313101")[1]
if getgenv().preloadanimations then
    local gui = files.ScreenGui:Clone()
    gui.Parent = game.CoreGui
    local loadamount,amounttoload = 0,0
    amounttoload = #files.Folder:GetChildren()--amounttoload + 1
    for i,v in pairs(files.Folder:GetChildren()) do
        if getgenv().loadtime ~= 0 then
            wait:Wait(getgenv().loadtime)
        end
        spawn(function()
            local animid,soundid = v.ToolTip,v.SoundID.SoundId
            if soundid then
                local soundwait = Instance.new("Sound",game.Players.LocalPlayer)
                soundwait.SoundId = soundid
                spawn(function()
                        soundwait.Loaded:Wait()
                        soundwait:Destroy()    
                end)
            end
            if animid then
                pcall(function()
                    game:GetObjects('rbxassetid://'..animid)
                end)
            end
            
            loadamount = loadamount + 1
            print(loadamount,amounttoload)
        end)
    end
    repeat wait:Wait() until loadamount == amounttoload
    gui:Destroy()
end
if getgenv().reanimate then
  getgenv().AutoAnimate = false
  loadstring(game:HttpGet("https://raw.githubusercontent.com/CenteredSniper/Kenzen/master/newnetlessreanimate.lua",true))()
   wait = getgenv().MiliWait.Event
  wait:Wait()
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/AwsZFvR4Fh6/Ya/main/AnimyForthing",true))()

for i,v in pairs(files.Folder:GetChildren()) do
    local tool = v --:Clone()
        tool.Parent = game.Players.LocalPlayer.Backpack
        wait:Wait()
        tool.Activated:Connect(function()
            if _G.runanimation then
                _G.runanimation(v.ToolTip,string.sub(v.SoundID.SoundId,14))
            end
        end)
        tool.Unequipped:Connect(function()
            _G.dancing = false
            if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Sound") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.Sound:Destroy()
            end
        end)
end
