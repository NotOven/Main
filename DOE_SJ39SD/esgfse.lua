local GetService = setmetatable({}, {
	__index = function(self, key)
		return game:GetService(key)
	end
})

-- Variables
local Workspace = GetService.Workspace
local Players = GetService.Players
local RunService = GetService.RunService

local Stepped = RunService.Stepped
local Heartbeat = RunService.Heartbeat

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character

local V3 = Vector3.new
local CF = CFrame.new
local Angles = CFrame.Angles

local Insert = table.insert
local Find = table.find
-- Clone
Character.Archivable = true
local Clone = Character:Clone()
Clone.Name = 'CharacterClone'
Clone.Parent = Workspace

Clone.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame

if _G.Options.Animate == true then
    local Events = {}
    local a=Clone;local b=a:WaitForChild("Torso")local c=b:WaitForChild("Right Shoulder")local d=b:WaitForChild("Left Shoulder")local e=b:WaitForChild("Right Hip")local f=b:WaitForChild("Left Hip")local g=b:WaitForChild("Neck")local h=a:WaitForChild("Humanoid")local i="Standing"local j=""local k=nil;local l=nil;local m=nil;local n=1.0;local o={}local p={idle={{id="http://www.roblox.com/asset/?id=180435571",weight=9},{id="http://www.roblox.com/asset/?id=180435792",weight=1}},walk={{id="http://www.roblox.com/asset/?id=180426354",weight=10}},run={{id="run.xml",weight=10}},jump={{id="http://www.roblox.com/asset/?id=125750702",weight=10}},fall={{id="http://www.roblox.com/asset/?id=180436148",weight=10}},climb={{id="http://www.roblox.com/asset/?id=180436334",weight=10}},sit={{id="http://www.roblox.com/asset/?id=178130996",weight=10}},toolnone={{id="http://www.roblox.com/asset/?id=182393478",weight=10}},toolslash={{id="http://www.roblox.com/asset/?id=129967390",weight=10}},toollunge={{id="http://www.roblox.com/asset/?id=129967478",weight=10}},wave={{id="http://www.roblox.com/asset/?id=128777973",weight=10}},point={{id="http://www.roblox.com/asset/?id=128853357",weight=10}},dance1={{id="http://www.roblox.com/asset/?id=182435998",weight=10},{id="http://www.roblox.com/asset/?id=182491037",weight=10},{id="http://www.roblox.com/asset/?id=182491065",weight=10}},dance2={{id="http://www.roblox.com/asset/?id=182436842",weight=10},{id="http://www.roblox.com/asset/?id=182491248",weight=10},{id="http://www.roblox.com/asset/?id=182491277",weight=10}},dance3={{id="http://www.roblox.com/asset/?id=182436935",weight=10},{id="http://www.roblox.com/asset/?id=182491368",weight=10},{id="http://www.roblox.com/asset/?id=182491423",weight=10}},laugh={{id="http://www.roblox.com/asset/?id=129423131",weight=10}},cheer={{id="http://www.roblox.com/asset/?id=129423030",weight=10}}}local q={"dance1","dance2","dance3"}local r={wave=false,point=false,dance1=true,dance2=true,dance3=true,laugh=false,cheer=false}function configureAnimationSet(s,t)if o[s]~=nil then for u,v in pairs(o[s].connections)do v:disconnect()end end;o[s]={}o[s].count=0;o[s].totalWeight=0;o[s].connections={}local w=script:FindFirstChild(s)if w~=nil then table.insert(o[s].connections,w.ChildAdded:connect(function(x)configureAnimationSet(s,t)end))table.insert(o[s].connections,w.ChildRemoved:connect(function(x)configureAnimationSet(s,t)end))local y=1;for u,z in pairs(w:GetChildren())do if z:IsA("Animation")then table.insert(o[s].connections,z.Changed:connect(function(A)configureAnimationSet(s,t)end))o[s][y]={}o[s][y].anim=z;local B=z:FindFirstChild("Weight")if B==nil then o[s][y].weight=1 else o[s][y].weight=B.Value end;o[s].count=o[s].count+1;o[s].totalWeight=o[s].totalWeight+o[s][y].weight;y=y+1 end end end;if o[s].count<=0 then for y,C in pairs(t)do o[s][y]={}o[s][y].anim=Instance.new("Animation")o[s][y].anim.Name=s;o[s][y].anim.AnimationId=C.id;o[s][y].weight=C.weight;o[s].count=o[s].count+1;o[s].totalWeight=o[s].totalWeight+C.weight end end end;function scriptChildModified(x)local t=p[x.Name]if t~=nil then configureAnimationSet(x.Name,t)end end;script.ChildAdded:connect(scriptChildModified)script.ChildRemoved:connect(scriptChildModified)for s,t in pairs(p)do configureAnimationSet(s,t)end;local D="None"local E=0;local F=0;local G=0.3;local H=0.1;local I=0.3;local J=0.75;function stopAllAnimations()local K=j;if r[K]~=nil and r[K]==false then K="idle"end;j=""k=nil;if m~=nil then m:disconnect()end;if l~=nil then l:Stop()l:Destroy()l=nil end;return K end;function setAnimationSpeed(L)if L~=n then n=L;l:AdjustSpeed(n)end end;function keyFrameReachedFunc(M)if M=="End"then local N=j;if r[N]~=nil and r[N]==false then N="idle"end;local O=n;playAnimation(N,0.0,h)setAnimationSpeed(O)end end;function playAnimation(P,Q,R)pcall(function()local S=math.random(1,o[P].totalWeight)local T=S;local y=1;while S>o[P][y].weight do S=S-o[P][y].weight;y=y+1 end;local C=o[P][y].anim;if C~=k then if l~=nil then l:Stop(Q)l:Destroy()end;n=1.0;l=R:LoadAnimation(C)l.Priority=Enum.AnimationPriority.Core;l:Play(Q)j=P;k=C;if m~=nil then m:disconnect()end;m=l.KeyframeReached:connect(keyFrameReachedFunc)end end)end;local U=""local V=nil;local W=nil;local X=nil;function toolKeyFrameReachedFunc(M)if M=="End"then playToolAnimation(U,0.0,h)end end;function playToolAnimation(P,Q,R,Y)local S=math.random(1,o[P].totalWeight)local T=S;local y=1;while S>o[P][y].weight do S=S-o[P][y].weight;y=y+1 end;local C=o[P][y].anim;if W~=C then if V~=nil then V:Stop()V:Destroy()Q=0 end;V=R:LoadAnimation(C)if Y then V.Priority=Y end;V:Play(Q)U=P;W=C;X=V.KeyframeReached:connect(toolKeyFrameReachedFunc)end end;function stopToolAnimations()local K=U;if X~=nil then X:disconnect()end;U=""W=nil;if V~=nil then V:Stop()V:Destroy()V=nil end;return K end;function onRunning(L)pcall(function()if L>0.01 then playAnimation("walk",0.1,h)if k and k.AnimationId=="http://www.roblox.com/asset/?id=180426354"then setAnimationSpeed(L/14.5)end;i="Running"else if r[j]==nil then playAnimation("idle",0.1,h)i="Standing"end end end)end;function onDied()i="Dead"end;function onJumping()playAnimation("jump",0.1,h)F=G;i="Jumping"end;function onClimbing(L)playAnimation("climb",0.1,h)setAnimationSpeed(L/12.0)i="Climbing"end;function onGettingUp()i="GettingUp"end;function onFreeFall()if F<=0 then playAnimation("fall",I,h)end;i="FreeFall"end;function onFallingDown()i="FallingDown"end;function onSeated()i="Seated"end;function onPlatformStanding()i="PlatformStanding"end;function onSwimming(L)if L>0 then i="Running"else i="Standing"end end;function getTool()for u,Z in ipairs(a:GetChildren())do if Z.className=="Tool"then return Z end end;return nil end;function getToolAnim(_)for u,a0 in ipairs(_:GetChildren())do if a0.Name=="toolanim"and a0.className=="StringValue"then return a0 end end;return nil end;function animateTool()if D=="None"then playToolAnimation("toolnone",H,h,Enum.AnimationPriority.Idle)return end;if D=="Slash"then playToolAnimation("toolslash",0,h,Enum.AnimationPriority.Action)return end;if D=="Lunge"then playToolAnimation("toollunge",0,h,Enum.AnimationPriority.Action)return end end;function moveSit()c.MaxVelocity=0.15;d.MaxVelocity=0.15;c:SetDesiredAngle(3.14/2)d:SetDesiredAngle(-3.14/2)e:SetDesiredAngle(3.14/2)f:SetDesiredAngle(-3.14/2)end;local a1=0;function move(a2)local a3=1;local a4=1;local a5=a2-a1;a1=a2;local a6=0;local a7=false;if F>0 then F=F-a5 end;if i=="FreeFall"and F<=0 then playAnimation("fall",I,h)elseif i=="Seated"then playAnimation("sit",0.5,h)return elseif i=="Running"then playAnimation("walk",0.1,h)elseif i=="Dead"or i=="GettingUp"or i=="FallingDown"or i=="Seated"or i=="PlatformStanding"then stopAllAnimations()a3=0.1;a4=1;a7=true end;if a7 then local a8=a3*math.sin(a2*a4)c:SetDesiredAngle(a8+a6)d:SetDesiredAngle(a8-a6)e:SetDesiredAngle(-a8)f:SetDesiredAngle(-a8)end;local _=getTool()if _ and _:FindFirstChild("Handle")then local a9=getToolAnim(_)if a9 then D=a9.Value;a9.Parent=nil;E=a2+.3 end;if a2>E then E=0;D="None"end;animateTool()else stopToolAnimations()D="None"W=nil;E=0 end end;table.insert(Events,h.Died:connect(onDied))table.insert(Events,h.Running:connect(onRunning))table.insert(Events,h.Jumping:connect(onJumping))table.insert(Events,h.Climbing:connect(onClimbing))table.insert(Events,h.GettingUp:connect(onGettingUp))table.insert(Events,h.FreeFalling:connect(onFreeFall))table.insert(Events,h.FallingDown:connect(onFallingDown))table.insert(Events,h.Seated:connect(onSeated))table.insert(Events,h.PlatformStanding:connect(onPlatformStanding))table.insert(Events,h.Swimming:connect(onSwimming))game:GetService("Players").LocalPlayer.Chatted:connect(function(aa)local ab=""if aa=="/e dance"then ab=q[math.random(1,#q)]elseif string.sub(aa,1,3)=="/e "then ab=string.sub(aa,4)elseif string.sub(aa,1,7)=="/emote "then ab=string.sub(aa,8)end;if i=="Standing"and r[ab]~=nil then playAnimation(ab,0.1,h)end end)playAnimation("idle",0.1,h)i="Standing"table.insert(Events,game:GetService("RunService").Stepped:Connect(function()local u,a2=wait(0.1)move(a2)end))
else
    Character.Animate.Disabled = true
	for i,v in next, Character:FindFirstChildOfClass('Humanoid'):GetPlayingAnimationTracks() do
		v:Stop()
	end
end

for _, BasePart in ipairs(Clone:GetDescendants()) do
	if BasePart:IsA('BasePart') and BasePart.Name ~= "HumanoidRootPart" then
		BasePart.Transparency = 1
	end
end

RunService.Stepped:Connect(function()
	for _, BasePart in ipairs(Clone:GetDescendants()) do
		if BasePart:IsA('BasePart') then
			BasePart.CanCollide = false
		end
	end
end)

OriginalClonePosition, OriginalCameraPosition = Clone:GetPivot(), Camera.CFrame
--


local v3_net, v3_808 = V3(0.12, 27.5, 0.12), V3(8.5, 0, 8.5)
local function getNetlessVelocity(realPartVelocity)
	if realPartVelocity.Magnitude > 1 then
		local unit = realPartVelocity.Unit
		if (unit.Y > 0.25) or (unit.Y < -0.75) then
			return unit * (26 / unit.Y)
		end
	end
	return v3_net + realPartVelocity * v3_808
end

local function Align(Part0, Part1, Pos, Ori)

	local att1 = Instance.new("Attachment")
	att1.Position = Pos or V3(0,0,0)
	att1.Orientation = Ori or V3(0,0,0)
	att1.Name = "att1_" .. Part1.Name

	local Rot = math.rad(0.05)
	if con0 then con0:Disconnect() end
	if con1 then con1:Disconnect() end
	local con0, con1 = nil, nil

	con0 = Stepped:Connect(function()
		if not (Part0 and Part1) then return con0:Disconnect() and con1:Disconnect() end
		Part0.RotVelocity = Part1.RotVelocity
	end)

	local lastpos = Part0.Position

	con1 = Heartbeat:Connect(function(delta)
		if not (Part0 and Part1 and att1) then return con0:Disconnect() and con1:Disconnect() end
		if (not Part0.Anchored) and (Part0.ReceiveAge == 0) then
			local newcf = Part1.CFrame * att1.CFrame
			if Part1.Velocity.Magnitude > 0.1 then
				Part0.Velocity = getNetlessVelocity(Part1.Velocity)
			else
				local vel = (newcf.Position - lastpos) / delta
				Part0.Velocity = getNetlessVelocity(vel)
				if vel.Magnitude < 1 then
					Rot = -Rot
					newcf *= Angles(0, 0, Rot)
				end
			end
			lastpos = newcf.Position
			Part0.CFrame = newcf
		end
	end)

	if _G.Options.Reanim_Type == "Humanoid" then
		spawn(function()
			LocalPlayer.CharacterAdded:Wait()
			if con0 then con0:Disconnect() end
			if con1 then con1:Disconnect() end
		end)
	end
end

-- Reanims
if _G.Options.Reanim_Type == "Humanoid" then -- Humanoid
	local OnCharacterAdded = function(Character)
		if Character == Clone then
			return
		end

		local Loop = Stepped:Connect(function()
			sethiddenproperty(LocalPlayer, "MaximumSimulationRadius", 10000000*2)
			sethiddenproperty(LocalPlayer, "SimulationRadius", 10000000*2)
			for _, BasePart in ipairs(Character:GetDescendants()) do
				if BasePart:IsA('BasePart') then
					BasePart.CanCollide = false
				end
			end
		end)

		local Humanoid = Character:WaitForChild('Humanoid')
		Humanoid:Destroy()

		local Torso = Character:WaitForChild('Torso')
		Torso:WaitForChild('Neck'):Destroy()
		Torso:WaitForChild('Right Shoulder'):Destroy()
		Torso:WaitForChild('Left Shoulder'):Destroy()
		Torso:WaitForChild('Right Hip'):Destroy()
		Torso:WaitForChild('Left Hip'):Destroy()
		Character:WaitForChild('HumanoidRootPart'):WaitForChild('RootJoint'):Destroy()

		coroutine.wrap(function()
			RunService.RenderStepped:Wait()
			Camera.CFrame = OriginalCameraPosition
		end)()

		LocalPlayer.Character = Clone
		Camera.CameraSubject = Clone:FindFirstChildOfClass('Humanoid')

		for i,v in pairs(Clone:GetDescendants()) do
			if v:IsA('BasePart') and not v.Parent:IsA('Accessory') then
				for _,x in pairs(Character:GetDescendants()) do
					if x:IsA('BasePart') and not x.Parent:IsA('Accessory') then
						if v.Name == x.Name and v.ClassName == x.ClassName then
							Align(x, v)
						end
					end
				end
			elseif v:IsA('BasePart') and v.Parent:IsA('Accessory') then
				for _,x in pairs(Character:GetDescendants()) do
					if x:IsA('BasePart') and x.Parent:IsA('Accessory') then
						if v.Parent.Name == x.Parent.Name and v.Parent.ClassName == x.Parent.ClassName then
							Align(x, v)
						end
					end
				end
			end
		end


		task.wait(Players.RespawnTime - 0.01)
		OriginalClonePosition, OriginalCameraPosition = Clone:GetPivot(), Camera.CFrame
		Loop:Disconnect()
	end

	if LocalPlayer.Character then
		OnCharacterAdded(LocalPlayer.Character)
	end
	LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)

elseif _G.Options.Reanim_Type == "Hat" then
	if Character == Clone then 
		return
	end

	local Character = LocalPlayer.Character

	local Loop = Stepped:Connect(function()
		sethiddenproperty(LocalPlayer, "MaximumSimulationRadius", 10000000*2)
		sethiddenproperty(LocalPlayer, "SimulationRadius", 10000000*2)
		for _, BasePart in ipairs(Character:GetDescendants()) do
			if BasePart:IsA('BasePart') then
				BasePart.CanCollide = false
			end
		end
	end)

	Character.HumanoidRootPart:Destroy()

	Character["Animate"].Disabled = true
	for i,v in next, Character:FindFirstChildOfClass('Humanoid'):GetPlayingAnimationTracks() do
		v:Stop()
	end

	for i,v in pairs(Character:GetChildren()) do
		if (v:IsA('Accessory') and v:FindFirstChild('Handle') and v.Handle:FindFirstChild('AccessoryWeld')) then
			v.Handle.AccessoryWeld:Destroy()
		end
	end

	for i,v in pairs(Clone:GetDescendants()) do
		if v:IsA('BasePart') and v.Parent:IsA('Accessory') and not Find(_G.Options.Limbs, v.Parent.Name) then
			CharacterHat = Character:FindFirstChild(v.Parent.Name)
			if CharacterHat then
				Align(CharacterHat.Handle, v)
			end
		elseif v:IsA('BasePart') and v.Parent:IsA('Accessory') and Find(_G.Options.Limbs, v.Parent.Name) then
			Hat = Character:FindFirstChild(v.Parent.Name)
			if Hat then
				if Hat.Handle:FindFirstChildWhichIsA('SpecialMesh') then Hat.Handle:FindFirstChildWhichIsA('SpecialMesh'):Destroy() end

				if Hat.Name == "LavanderHair" then 
					Align(Hat.Handle, Clone["Right Arm"], V3(0,0,0), V3(90,0,0))
				elseif Hat.Name == "Hat1" then
					Align(Hat.Handle, Clone["Left Arm"], V3(0,0,0), V3(90,0,0))
				elseif Hat.Name == "Pal Hair" then
					Align(Hat.Handle, Clone["Right Leg"], V3(0,0,0), V3(90,0,0))
				elseif Hat.Name == "Kate Hair" then
					Align(Hat.Handle, Clone["Left Leg"], V3(0,0,0), V3(90,0,0))
				end
			end
		elseif v:IsA('BasePart') and v.Name == "Torso" then
			CharTorso = Character:FindFirstChild('Torso')
			if CharTorso then
				Align(CharTorso, Clone["Torso"], V3(0,0,0), V3(0,0,0))
			end
		end
	end


	if _G.Options.Block_Hats then
		for i,v in pairs(Character:GetChildren()) do
			if v:IsA('Accessory') or v:IsA('Tool') then
				if (v:FindFirstChild('Handle') and v:FindFirstChild('Handle'):FindFirstChildWhichIsA('SpecialMesh')) then
					v.Handle:FindFirstChildWhichIsA('SpecialMesh'):Destroy()
				end
			end
		end
	end

	if _G.Options.BoomBox_Enabled then
		local BoomBox = Character:FindFirstChild('BoomBox') or LocalPlayer.Backpack:FindFirstChild('BoomBox')
		if BoomBox then
			BoomBox.Parent = LocalPlayer.Backpack
			BoomBox.Parent = Character
			Character["Right Arm"]:BreakJoints()
			Character["Right Arm"]:Destroy()

			BoomBox:WaitForChild('Handle')

			Light = Instance.new("Highlight", BoomBox.Handle)
			Light.FillTransparency = 0.8
			Light.OutlineTransparency = 0.5
			Light.FillColor = Color3.new(0,255,0)

			Align(BoomBox.Handle, Clone["HumanoidRootPart"], V3(0,-5,0), V3(0,0,0-0.1*math.sin(100*tick())))

			LocalPlayer.Backpack:ClearAllChildren()

			function ChangeSong(ID)
				if game.PlaceId == 7154305304 then
					Character["BoomBox"].RemoteEvent:FireServer(ID)
				else
					Character["BoomBox"].Remote:FireServer("PlaySong",ID)
				end
			end
		end
	else
		function ChangeSong(ID)
			if not Clone.Torso:FindFirstChild('Music') then
				Instance.new("Sound",Clone["Torso"])
				Clone["Torso"].Sound.Name = "Music"
			end

			Music = Clone["Torso"]:FindFirstChild('Music')
			Music.SoundId =  "rbxassetid://"..ID
			Music.Playing = true
		end
	end

	for i,v in pairs(Character.Torso:GetChildren()) do
		if v:IsA("Motor6D") and v.Name ~= "Neck" then
			v:Destroy()
		end
	end


	LocalPlayer.Character = Clone
	Camera.CameraSubject = Clone:FindFirstChildOfClass('Humanoid')

end
--
