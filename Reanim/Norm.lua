
local v3_net, v3_808 = Vector3.new(0.1, 25.1, 0.1), Vector3.new(8, 0, 8)
local function getNetlessVelocity(realPartVelocity)
    if realPartVelocity.Magnitude > 1 then
        local unit = realPartVelocity.Unit
        if (unit.Y > 0.25) or (unit.Y < -0.75) then
            return unit * (25.1 / unit.Y)
        end
    end
    return v3_net + realPartVelocity * v3_808
end

local lp = game:GetService("Players").LocalPlayer
local rs, ws, sg = game:GetService("RunService"), game:GetService("Workspace"), game:GetService("StarterGui")
local stepped, heartbeat, renderstepped = rs.Stepped, rs.Heartbeat, rs.RenderStepped
local twait, tdelay, rad, inf, abs, clamp = task.wait, task.delay, math.rad, math.huge, math.abs, math.clamp
local cf, v3, angles = CFrame.new, Vector3.new, CFrame.Angles
local v3_0, cf_0 = v3(0, 0, 0), cf(0, 0, 0)

local c = lp.Character
if not (c and c.Parent) then
    return
end

c:GetPropertyChangedSignal("Parent"):Connect(function()
    if not (c and c.Parent) then
        c = nil
    end
end)

local clone, destroy, getchildren, getdescendants, isa = c.Clone, c.Destroy, c.GetChildren, c.GetDescendants, c.IsA

local function gp(parent, name, className)
    if typeof(parent) == "Instance" then
        for i, v in pairs(getchildren(parent)) do
            if (v.Name == name) and isa(v, className) then
                return v
            end
        end
    end
    return nil
end

local fenv = getfenv()

local shp = fenv.sethiddenproperty or fenv.set_hidden_property or fenv.set_hidden_prop or fenv.sethiddenprop
local ssr = fenv.setsimulationradius or fenv.set_simulation_radius or fenv.set_sim_radius or fenv.setsimradius or fenv.setsimrad or fenv.set_sim_rad

healthHide = healthHide and ((method == 0) or (method == 2) or (method == 3)) and gp(c, "Head", "BasePart")

local reclaim, lostpart = reclaim and c.PrimaryPart, nil

local function align(Part0, Part1)
    
    local att0 = Instance.new("Attachment")
    att0.Position, att0.Orientation, att0.Name = v3_0, v3_0, "att0_" .. Part0.Name
    local att1 = Instance.new("Attachment")
    att1.Position, att1.Orientation, att1.Name = v3_0, v3_0, "att1_" .. Part1.Name

    if alignmode == 4 then
    
        local hide = false
        if Part0 == healthHide then
            healthHide = false
            tdelay(0, function()
                while twait(2.9) and Part0 and c do
                    hide = #Part0:GetConnectedParts() == 1
                    twait(0.1)
                    hide = false
                end
            end)
        end
        
        local rot = rad(0.05)
        local con0, con1 = nil, nil
        con0 = stepped:Connect(function()
            if not (Part0 and Part1) then return con0:Disconnect() and con1:Disconnect() end
            Part0.RotVelocity = Part1.RotVelocity
        end)
        local lastpos = Part0.Position
        con1 = heartbeat:Connect(function(delta)
            if not (Part0 and Part1 and att1) then return con0:Disconnect() and con1:Disconnect() end
            if (not Part0.Anchored) and (Part0.ReceiveAge == 0) then
                if lostpart == Part0 then
                    lostpart = nil
                end
                local newcf = Part1.CFrame * att1.CFrame
                if Part1.Velocity.Magnitude > 0.1 then
                    Part0.Velocity = getNetlessVelocity(Part1.Velocity)
                else
                    local vel = (newcf.Position - lastpos) / delta
                    Part0.Velocity = getNetlessVelocity(vel)
                    if vel.Magnitude < 1 then
                        rot = -rot
                        newcf *= angles(0, 0, rot)
                    end
                end
                lastpos = newcf.Position
                if lostpart and (Part0 == reclaim) then
                    newcf = lostpart.CFrame
                elseif hide then
                    newcf += v3(0, 3000, 0)
                end
                if novoid and (newcf.Y < ws.FallenPartsDestroyHeight + 0.1) then
                    newcf += v3(0, ws.FallenPartsDestroyHeight + 0.1 - newcf.Y, 0)
                end
                Part0.CFrame = newcf
            elseif (not Part0.Anchored) and (abs(Part0.Velocity.X) < 45) and (abs(Part0.Velocity.Y) < 25) and (abs(Part0.Velocity.Z) < 45) then
                lostpart = Part0
            end
        end)
    
    else
        
        Part0.CustomPhysicalProperties = physp
        if (alignmode == 1) or (alignmode == 2) then
            local ape = Instance.new("AlignPosition")
            ape.MaxForce, ape.MaxVelocity, ape.Responsiveness = inf, inf, inf
            ape.ReactionForceEnabled, ape.RigidityEnabled, ape.ApplyAtCenterOfMass = false, true, false
            ape.Attachment0, ape.Attachment1, ape.Name = att0, att1, "AlignPositionRtrue"
            ape.Parent = att0
        end
        
        if (alignmode == 2) or (alignmode == 3) then
            local apd = Instance.new("AlignPosition")
            apd.MaxForce, apd.MaxVelocity, apd.Responsiveness = inf, inf, inf
            apd.ReactionForceEnabled, apd.RigidityEnabled, apd.ApplyAtCenterOfMass = false, false, false
            apd.Attachment0, apd.Attachment1, apd.Name = att0, att1, "AlignPositionRfalse"
            apd.Parent = att0
        end
        
        local ao = Instance.new("AlignOrientation")
        ao.MaxAngularVelocity, ao.MaxTorque, ao.Responsiveness = inf, inf, inf
        ao.PrimaryAxisOnly, ao.ReactionTorqueEnabled, ao.RigidityEnabled = false, false, false
        ao.Attachment0, ao.Attachment1 = att0, att1
        ao.Parent = att0
        
        local con0, con1 = nil, nil
        local vel = Part0.Velocity
        con0 = renderstepped:Connect(function()
            if not (Part0 and Part1) then return con0:Disconnect() and con1:Disconnect() end
            Part0.Velocity = vel
        end)
        local lastpos = Part0.Position
        con1 = heartbeat:Connect(function(delta)
            if not (Part0 and Part1) then return con0:Disconnect() and con1:Disconnect() end
            vel = Part0.Velocity
            if Part1.Velocity.Magnitude > 0.01 then
                Part0.Velocity = getNetlessVelocity(Part1.Velocity)
            else
                Part0.Velocity = getNetlessVelocity((Part0.Position - lastpos) / delta)
            end
            lastpos = Part0.Position
        end)
    
    end

    att0:GetPropertyChangedSignal("Parent"):Connect(function()
        Part0 = att0.Parent
        if not isa(Part0, "BasePart") then
            att0 = nil
            if lostpart == Part0 then
                lostpart = nil
            end
            Part0 = nil
        end
    end)
    att0.Parent = Part0
    
    att1:GetPropertyChangedSignal("Parent"):Connect(function()
        Part1 = att1.Parent
        if not isa(Part1, "BasePart") then
            att1 = nil
            Part1 = nil
        end
    end)
    att1.Parent = Part1
end

local function respawnrequest()
    local ccfr, c = ws.CurrentCamera.CFrame, lp.Character
    lp.Character = nil
    lp.Character = c
    local con = nil
    con = ws.CurrentCamera.Changed:Connect(function(prop)
        if (prop ~= "Parent") and (prop ~= "CFrame") then
            return
        end
        ws.CurrentCamera.CFrame = ccfr
        con:Disconnect()
    end)
end

local destroyhum = (method == 4) or (method == 5)
local breakjoints = (method == 0) or (method == 4)
local antirespawn = (method == 0) or (method == 2) or (method == 3)

hatcollide = hatcollide and (method == 0)

addtools = addtools and lp:FindFirstChildOfClass("Backpack")

if type(simrad) ~= "number" then simrad = 1000 end
if shp and (simradius == "shp") then
    tdelay(0, function()
        while c do
            shp(lp, "SimulationRadius", simrad)
            heartbeat:Wait()
        end
    end)
elseif ssr and (simradius == "ssr") then
    tdelay(0, function()
        while c do
            ssr(simrad)
            heartbeat:Wait()
        end
    end)
end

if antiragdoll then
    antiragdoll = function(v)
        if isa(v, "HingeConstraint") or isa(v, "BallSocketConstraint") then
            v.Parent = nil
        end
    end
    for i, v in pairs(getdescendants(c)) do
        antiragdoll(v)
    end
    c.DescendantAdded:Connect(antiragdoll)
end

if antirespawn then
    respawnrequest()
end

if method == 0 then
    twait(loadtime)
    if not c then
        return
    end
end

if discharscripts then
    for i, v in pairs(getdescendants(c)) do
        if isa(v, "LocalScript") then
            v.Disabled = true
        end
    end
elseif newanimate then
    local animate = gp(c, "Animate", "LocalScript")
    if animate and (not animate.Disabled) then
        animate.Disabled = true
    else
        newanimate = false
    end
end

if addtools then
    for i, v in pairs(getchildren(addtools)) do
        if isa(v, "Tool") then
            v.Parent = c
        end
    end
end

pcall(function()
    settings().Physics.AllowSleep = false
    settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
end)

local OLDscripts = {}

for i, v in pairs(getdescendants(c)) do
    if v.ClassName == "Script" then
        OLDscripts[v.Name] = true
    end
end

local scriptNames = {}

for i, v in pairs(getdescendants(c)) do
    if isa(v, "BasePart") then
        local newName, exists = tostring(i), true
        while exists do
            exists = OLDscripts[newName]
            if exists then
                newName = newName .. "_"    
            end
        end
        table.insert(scriptNames, newName)
        Instance.new("Script", v).Name = newName
    end
end

local hum = c:FindFirstChildOfClass("Humanoid")
if hum then
    for i, v in pairs(hum:GetPlayingAnimationTracks()) do
        v:Stop()
    end
end

HeadHeight = 0
if rescale and c.Humanoid.RigType == Enum.HumanoidRigType.R15 then
    HeadHeight = 0.2
local function wipe_parts()
    for i,v in pairs(c:GetDescendants()) do
        if v:IsA("BasePart") then
            if v.Name == "Handle" or v.Name == "Head" then
                if c.Head:FindFirstChild("OriginalSize") then
                    c.Head:WaitForChild('OriginalSize'):Destroy()
                end
            else
                for i,cav in pairs(v:GetDescendants()) do
                    if cav:IsA("Attachment") then
                        if cav:FindFirstChild("OriginalPosition") then
                            cav:WaitForChild'OriginalPosition':Destroy()  
                        end
                    end
                end
                v:WaitForChild("OriginalSize"):Destroy()
                if v:FindFirstChild("AvatarPartScaleType") then
                    v:WaitForChild("AvatarPartScaleType"):Destroy()
                end
            end
        end
    end
    end
wipe_parts()
hum:WaitForChild("BodyTypeScale"):Destroy()
wipe_parts()
hum:WaitForChild("BodyWidthScale"):Destroy()
wipe_parts()
hum:WaitForChild("BodyDepthScale"):Destroy()
wipe_parts()
hum:WaitForChild("HeadScale"):Destroy()
end

c.Archivable = true
local cl = clone(c)
if hum and humState16 then
    hum:ChangeState(Enum.HumanoidStateType.Physics)
    if destroyhum then
        twait()
    end
end
if destroyhum then
    pcall(destroy, hum)
end

if not c then
    return
end

--Setting Hrp To Collide = false Cuz Yeah
if c.HumanoidRootPart then c.HumanoidRootPart.CanCollide = false end
if model.HumanoidRootPart then model.HumanoidRootPart.CanCollide = false end

local head, torso, root = gp(c, "Head", "BasePart"), gp(c, "Torso", "BasePart") or gp(c, "UpperTorso", "BasePart"), gp(c, "HumanoidRootPart", "BasePart")
if hatcollide and c:FindFirstChildOfClass("Accessory") then
    local anything = gp(c, "Health", "Script")
    if not (torso and root and anything) then
        return
    end

c.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame + Vector3.new(10,75,0)
task.wait(.15)
for i,v in pairs(c:GetChildren()) do
    if v:IsA("Accessory") then
        sethiddenproperty(v,"BackendAccoutrementState", 0)
        for i,v in pairs(v.Handle:GetChildren()) do
            if v:IsA("Attachment") then v:remove() end
        end
    end
end

    c["Body Colors"]:Remove()
    torso:Destroy()
    root:Destroy()
    anything:Destroy()
    task.wait(.1)
end

local model = Instance.new("Model", c)
model:GetPropertyChangedSignal("Parent"):Connect(function()
    if not (model and model.Parent) then
        model = nil
    end
end)

for i, v in pairs(getchildren(c)) do
    if v ~= model then
        if addtools and isa(v, "Tool") then
            for i1, v1 in pairs(getdescendants(v)) do
                if v1 and v1.Parent and isa(v1, "BasePart") then
                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity, bv.MaxForce, bv.P, bv.Name = v3_0, v3(1000, 1000, 1000), 1250, "bv_" .. v.Name
                    bv.Parent = v1
                end
            end
        end
        v.Parent = model
    end
end

if breakjoints then
    model:BreakJoints()
else
    if head and torso then
        for i, v in pairs(getdescendants(model)) do
            if isa(v, "JointInstance") then
                local save = false
                if (v.Part0 == torso) and (v.Part1 == head) then
                    save = true
                end
                if (v.Part0 == head) and (v.Part1 == torso) then
                    save = true
                end
                if save then
                    if hedafterneck then
                        hedafterneck = v
                    end
                else
                    pcall(destroy, v)
                end
            end
        end
    end
    if method == 3 then
        task.delay(loadtime, pcall, model.BreakJoints, model)
    end
end

cl.Parent = ws
for i, v in pairs(getchildren(cl)) do
    v.Parent = c
end
pcall(destroy, cl)

local uncollide, noclipcon = nil, nil
if noclipAllParts then
    uncollide = function()
        if c then
            for i, v in pairs(getdescendants(c)) do
                if isa(v, "BasePart") then
                    v.CanCollide = false
                end
            end
        else
            noclipcon:Disconnect()
        end
    end
else
    uncollide = function()
        if model then
            for i, v in pairs(getdescendants(model)) do
                if isa(v, "BasePart") then
                    v.CanCollide = false
                end
            end
        else
            noclipcon:Disconnect()
        end
    end
end
noclipcon = stepped:Connect(uncollide)
uncollide()

for i, scr in pairs(getdescendants(model)) do
    if (scr.ClassName == "Script") and table.find(scriptNames, scr.Name) then
        local Part0 = scr.Parent
        if isa(Part0, "BasePart") then
            for i1, scr1 in pairs(getdescendants(c)) do
                if (scr1.ClassName == "Script") and (scr1.Name == scr.Name) and (not scr1:IsDescendantOf(model)) then
                    local Part1 = scr1.Parent
                    if (Part1.ClassName == Part0.ClassName) and (Part1.Name == Part0.Name) then
                        align(Part0, Part1)
                        pcall(destroy, scr)
                        pcall(destroy, scr1)
                        break
                    end
                end
            end
        end
    end
end

for i, v in pairs(getdescendants(c)) do
    if v and v.Parent and (not v:IsDescendantOf(model)) then
        if isa(v, "Decal") then
            v.Transparency = 1
        elseif isa(v, "BasePart") then
            v.Transparency = 1
            v.Anchored = false
        elseif isa(v, "ForceField") then
            v.Visible = false
        elseif isa(v, "Sound") then
            v.Playing = false
        elseif isa(v, "BillboardGui") or isa(v, "SurfaceGui") or isa(v, "ParticleEmitter") or isa(v, "Fire") or isa(v, "Smoke") or isa(v, "Sparkles") then
            v.Enabled = false
        end
    end
end

if newanimate then
    local animate = gp(c, "Animate", "LocalScript")
    if animate then
        animate.Disabled = false
    end
end

if addtools then
    for i, v in pairs(getchildren(c)) do
        if isa(v, "Tool") then
            v.Parent = addtools
        end
    end
end

local hum0, hum1 = model:FindFirstChildOfClass("Humanoid"), c:FindFirstChildOfClass("Humanoid")
if hum0 then
    hum0:GetPropertyChangedSignal("Parent"):Connect(function()
        if not (hum0 and hum0.Parent) then
            hum0 = nil
        end
    end)
end
if hum1 then
    hum1:GetPropertyChangedSignal("Parent"):Connect(function()
        if not (hum1 and hum1.Parent) then
            hum1 = nil
        end
    end)

    ws.CurrentCamera.CameraSubject = hum1
    local camSubCon = nil
    local function camSubFunc()
        camSubCon:Disconnect()
        if c and hum1 then
            ws.CurrentCamera.CameraSubject = hum1
        end
    end
    camSubCon = renderstepped:Connect(camSubFunc)
    if hum0 then
        hum0:GetPropertyChangedSignal("Jump"):Connect(function()
            if hum1 then
                hum1.Jump = hum0.Jump
            end
        end)
    else
        respawnrequest()
    end
end

local rb = Instance.new("BindableEvent", c)
rb.Event:Connect(function()
    pcall(destroy, rb)
    sg:SetCore("ResetButtonCallback", true)
    if destroyhum then
        if c then c:BreakJoints() end
        return
    end
    if model and hum0 and (hum0.Health > 0) then
        model:BreakJoints()
        hum0.Health = 0
    end
    if antirespawn then
        respawnrequest()
    end
end)
sg:SetCore("ResetButtonCallback", rb)

tdelay(0, function()
    while c do
        if hum0 and hum1 then
            hum1.Jump = hum0.Jump
        end
        wait()
    end
    sg:SetCore("ResetButtonCallback", true)
end)

R15toR6 = R15toR6 and hum1 and (hum1.RigType == Enum.HumanoidRigType.R15)
if R15toR6 then
    local part = gp(c, "HumanoidRootPart", "BasePart") or gp(c, "UpperTorso", "BasePart") or gp(c, "LowerTorso", "BasePart") or gp(c, "Head", "BasePart") or c:FindFirstChildWhichIsA("BasePart")
    if part then
        local cfr = part.CFrame
        local R6parts = { 
            head = {
                Name = "Head",
                Size = v3(2, 1.25, 1),
                R15 = {
                    Head = HeadHeight
                }
            },
            torso = {
                Name = "Torso",
                Size = v3(2, 2, 1),
                R15 = {
                    UpperTorso = 0.2,
                    LowerTorso = -0.8
                }
            },
            root = {
                Name = "HumanoidRootPart",
                Size = v3(2, 2, 1),
                R15 = {
                    HumanoidRootPart = 0
                }
            },
            leftArm = {
                Name = "Left Arm",
                Size = v3(1, 2, 1),
                R15 = {
                    LeftHand = -0.76,
                    LeftLowerArm = -0.174,
                    LeftUpperArm = 0.415
                }
            },
            rightArm = {
                Name = "Right Arm",
                Size = v3(1, 2, 1),
                R15 = {
                    RightHand = -0.76,
                    RightLowerArm = -0.174,
                    RightUpperArm = 0.415
                }
            },
            leftLeg = {
                Name = "Left Leg",
                Size = v3(1, 2, 1),
                R15 = {
                    LeftFoot = -0.85,
                    LeftLowerLeg = -0.29,
                    LeftUpperLeg = 0.49
                }
            },
            rightLeg = {
                Name = "Right Leg",
                Size = v3(1, 2, 1),
                R15 = {
                    RightFoot = -0.85,
                    RightLowerLeg = -0.29,
                    RightUpperLeg = 0.49
                }
            }
        }
        for i, v in pairs(getchildren(c)) do
            if isa(v, "BasePart") then
                for i1, v1 in pairs(getchildren(v)) do
                    if isa(v1, "Motor6D") then
                        v1.Part0 = nil
                    end
                end
            end
        end
        part.Archivable = true
        for i, v in pairs(R6parts) do
            local part = clone(part)
            part:ClearAllChildren()
            part.Name, part.Size, part.CFrame, part.Anchored, part.Transparency, part.CanCollide = v.Name, v.Size, cfr, false, 1, false
            for i1, v1 in pairs(v.R15) do
                local R15part = gp(c, i1, "BasePart")
                local att = gp(R15part, "att1_" .. i1, "Attachment")
                if R15part then
                    local weld = Instance.new("Weld")
                    weld.Part0, weld.Part1, weld.C0, weld.C1, weld.Name = part, R15part, cf(0, v1, 0), cf_0, "Weld_" .. i1
                    weld.Parent = R15part
                    R15part.Massless, R15part.Name = true, "R15_" .. i1
                    R15part.Parent = part
                    if att then
                        att.Position = v3(0, v1, 0)
                        att.Parent = part
                    end
                end
            end
            part.Parent = c
            R6parts[i] = part
        end
        local R6joints = {
            neck = {
                Parent = R6parts.torso,
                Name = "Neck",
                Part0 = R6parts.torso,
                Part1 = R6parts.head,
                C0 = cf(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
                C1 = cf(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
            },
            rootJoint = {
                Parent = R6parts.root,
                Name = "RootJoint" ,
                Part0 = R6parts.root,
                Part1 = R6parts.torso,
                C0 = cf(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
                C1 = cf(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
            },
            rightShoulder = {
                Parent = R6parts.torso,
                Name = "Right Shoulder",
                Part0 = R6parts.torso,
                Part1 = R6parts.rightArm,
                C0 = cf(1, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
                C1 = cf(-0.5, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
            },
            leftShoulder = {
                Parent = R6parts.torso,
                Name = "Left Shoulder",
                Part0 = R6parts.torso,
                Part1 = R6parts.leftArm,
                C0 = cf(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
                C1 = cf(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            },
            rightHip = {
                Parent = R6parts.torso,
                Name = "Right Hip",
                Part0 = R6parts.torso,
                Part1 = R6parts.rightLeg,
                C0 = cf(1, -1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
                C1 = cf(0.5, 1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
            },
            leftHip = {
                Parent = R6parts.torso,
                Name = "Left Hip" ,
                Part0 = R6parts.torso,
                Part1 = R6parts.leftLeg,
                C0 = cf(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
                C1 = cf(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            }
        }
        for i, v in pairs(R6joints) do
            local joint = Instance.new("Motor6D")
            for prop, val in pairs(v) do
                joint[prop] = val
            end
            R6joints[i] = joint
        end
        if hum1 then
            hum1.RigType, hum1.HipHeight = Enum.HumanoidRigType.R6, 0
        end
    end
    --the default roblox animate script edited and put in one line
    local script = gp(c, "Animate", "LocalScript") if not script.Disabled then script:ClearAllChildren() local Torso = gp(c, "Torso", "BasePart") local RightShoulder = gp(Torso, "Right Shoulder", "Motor6D") local LeftShoulder = gp(Torso, "Left Shoulder", "Motor6D") local RightHip = gp(Torso, "Right Hip", "Motor6D") local LeftHip = gp(Torso, "Left Hip", "Motor6D") local Neck = gp(Torso, "Neck", "Motor6D") local Humanoid = c:FindFirstChildOfClass("Humanoid") local pose = "Standing" local currentAnim = "" local currentAnimInstance = nil local currentAnimTrack = nil local currentAnimKeyframeHandler = nil local currentAnimSpeed = 1.0 local animTable = {} local animNames = { idle = { { id = "http://www.roblox.com/asset/?id=180435571", weight = 9 }, { id = "http://www.roblox.com/asset/?id=180435792", weight = 1 } }, walk = { { id = "http://www.roblox.com/asset/?id=180426354", weight = 10 } }, run = { { id = "run.xml", weight = 10 } }, jump = { { id = "http://www.roblox.com/asset/?id=125750702", weight = 10 } }, fall = { { id = "http://www.roblox.com/asset/?id=180436148", weight = 10 } }, climb = { { id = "http://www.roblox.com/asset/?id=180436334", weight = 10 } }, sit = { { id = "http://www.roblox.com/asset/?id=178130996", weight = 10 } }, toolnone = { { id = "http://www.roblox.com/asset/?id=182393478", weight = 10 } }, toolslash = { { id = "http://www.roblox.com/asset/?id=129967390", weight = 10 } }, toollunge = { { id = "http://www.roblox.com/asset/?id=129967478", weight = 10 } }, wave = { { id = "http://www.roblox.com/asset/?id=128777973", weight = 10 } }, point = { { id = "http://www.roblox.com/asset/?id=128853357", weight = 10 } }, dance1 = { { id = "http://www.roblox.com/asset/?id=182435998", weight = 10 }, { id = "http://www.roblox.com/asset/?id=182491037", weight = 10 }, { id = "http://www.roblox.com/asset/?id=182491065", weight = 10 } }, dance2 = { { id = "http://www.roblox.com/asset/?id=182436842", weight = 10 }, { id = "http://www.roblox.com/asset/?id=182491248", weight = 10 }, { id = "http://www.roblox.com/asset/?id=182491277", weight = 10 } }, dance3 = { { id = "http://www.roblox.com/asset/?id=182436935", weight = 10 }, { id = "http://www.roblox.com/asset/?id=182491368", weight = 10 }, { id = "http://www.roblox.com/asset/?id=182491423", weight = 10 } }, laugh = { { id = "http://www.roblox.com/asset/?id=129423131", weight = 10 } }, cheer = { { id = "http://www.roblox.com/asset/?id=129423030", weight = 10 } }, } local dances = {"dance1", "dance2", "dance3"} local emoteNames = { wave = false, point = false, dance1 = true, dance2 = true, dance3 = true, laugh = false, cheer = false} local function configureAnimationSet(name, fileList) if (animTable[name] ~= nil) then for _, connection in pairs(animTable[name].connections) do connection:disconnect() end end animTable[name] = {} animTable[name].count = 0 animTable[name].totalWeight = 0 animTable[name].connections = {} local config = script:FindFirstChild(name) if (config ~= nil) then table.insert(animTable[name].connections, config.ChildAdded:connect(function(child) configureAnimationSet(name, fileList) end)) table.insert(animTable[name].connections, config.ChildRemoved:connect(function(child) configureAnimationSet(name, fileList) end)) local idx = 1 for _, childPart in pairs(config:GetChildren()) do if (childPart:IsA("Animation")) then table.insert(animTable[name].connections, childPart.Changed:connect(function(property) configureAnimationSet(name, fileList) end)) animTable[name][idx] = {} animTable[name][idx].anim = childPart local weightObject = childPart:FindFirstChild("Weight") if (weightObject == nil) then animTable[name][idx].weight = 1 else animTable[name][idx].weight = weightObject.Value end animTable[name].count = animTable[name].count + 1 animTable[name].totalWeight = animTable[name].totalWeight + animTable[name][idx].weight idx = idx + 1 end end end if (animTable[name].count <= 0) then for idx, anim in pairs(fileList) do animTable[name][idx] = {} animTable[name][idx].anim = Instance.new("Animation") animTable[name][idx].anim.Name = name animTable[name][idx].anim.AnimationId = anim.id animTable[name][idx].weight = anim.weight animTable[name].count = animTable[name].count + 1 animTable[name].totalWeight = animTable[name].totalWeight + anim.weight end end end local function scriptChildModified(child) local fileList = animNames[child.Name] if (fileList ~= nil) then configureAnimationSet(child.Name, fileList) end end script.ChildAdded:connect(scriptChildModified) script.ChildRemoved:connect(scriptChildModified) local animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator") or nil if animator then local animTracks = animator:GetPlayingAnimationTracks() for i, track in ipairs(animTracks) do track:Stop(0) track:Destroy() end end for name, fileList in pairs(animNames) do configureAnimationSet(name, fileList) end local toolAnim = "None" local toolAnimTime = 0 local jumpAnimTime = 0 local jumpAnimDuration = 0.3 local toolTransitionTime = 0.1 local fallTransitionTime = 0.3 local jumpMaxLimbVelocity = 0.75 local function stopAllAnimations() local oldAnim = currentAnim if (emoteNames[oldAnim] ~= nil and emoteNames[oldAnim] == false) then oldAnim = "idle" end currentAnim = "" currentAnimInstance = nil if (currentAnimKeyframeHandler ~= nil) then currentAnimKeyframeHandler:disconnect() end if (currentAnimTrack ~= nil) then currentAnimTrack:Stop() currentAnimTrack:Destroy() currentAnimTrack = nil end return oldAnim end local function playAnimation(animName, transitionTime, humanoid) local roll = math.random(1, animTable[animName].totalWeight) local origRoll = roll local idx = 1 while (roll > animTable[animName][idx].weight) do roll = roll - animTable[animName][idx].weight idx = idx + 1 end local anim = animTable[animName][idx].anim if (anim ~= currentAnimInstance) then if (currentAnimTrack ~= nil) then currentAnimTrack:Stop(transitionTime) currentAnimTrack:Destroy() end currentAnimSpeed = 1.0 currentAnimTrack = humanoid:LoadAnimation(anim) currentAnimTrack.Priority = Enum.AnimationPriority.Core currentAnimTrack:Play(transitionTime) currentAnim = animName currentAnimInstance = anim if (currentAnimKeyframeHandler ~= nil) then currentAnimKeyframeHandler:disconnect() end currentAnimKeyframeHandler = currentAnimTrack.KeyframeReached:connect(keyFrameReachedFunc) end end local function setAnimationSpeed(speed) if speed ~= currentAnimSpeed then currentAnimSpeed = speed currentAnimTrack:AdjustSpeed(currentAnimSpeed) end end local function keyFrameReachedFunc(frameName) if (frameName == "End") then local repeatAnim = currentAnim if (emoteNames[repeatAnim] ~= nil and emoteNames[repeatAnim] == false) then repeatAnim = "idle" end local animSpeed = currentAnimSpeed playAnimation(repeatAnim, 0.0, Humanoid) setAnimationSpeed(animSpeed) end end local toolAnimName = "" local toolAnimTrack = nil local toolAnimInstance = nil local currentToolAnimKeyframeHandler = nil local function toolKeyFrameReachedFunc(frameName) if (frameName == "End") then playToolAnimation(toolAnimName, 0.0, Humanoid) end end local function playToolAnimation(animName, transitionTime, humanoid, priority) local roll = math.random(1, animTable[animName].totalWeight) local origRoll = roll local idx = 1 while (roll > animTable[animName][idx].weight) do roll = roll - animTable[animName][idx].weight idx = idx + 1 end local anim = animTable[animName][idx].anim if (toolAnimInstance ~= anim) then if (toolAnimTrack ~= nil) then toolAnimTrack:Stop() toolAnimTrack:Destroy() transitionTime = 0 end toolAnimTrack = humanoid:LoadAnimation(anim) if priority then toolAnimTrack.Priority = priority end toolAnimTrack:Play(transitionTime) toolAnimName = animName toolAnimInstance = anim currentToolAnimKeyframeHandler = toolAnimTrack.KeyframeReached:connect(toolKeyFrameReachedFunc) end end local function stopToolAnimations() local oldAnim = toolAnimName if (currentToolAnimKeyframeHandler ~= nil) then currentToolAnimKeyframeHandler:disconnect() end toolAnimName = "" toolAnimInstance = nil if (toolAnimTrack ~= nil) then toolAnimTrack:Stop() toolAnimTrack:Destroy() toolAnimTrack = nil end return oldAnim end local function onRunning(speed) if speed > 0.01 then playAnimation("walk", 0.1, Humanoid) if currentAnimInstance and currentAnimInstance.AnimationId == "http://www.roblox.com/asset/?id=180426354" then setAnimationSpeed(speed / 14.5) end pose = "Running" else if emoteNames[currentAnim] == nil then playAnimation("idle", 0.1, Humanoid) pose = "Standing" end end end local function onDied() pose = "Dead" end local function onJumping() playAnimation("jump", 0.1, Humanoid) jumpAnimTime = jumpAnimDuration pose = "Jumping" end local function onClimbing(speed) playAnimation("climb", 0.1, Humanoid) setAnimationSpeed(speed / 12.0) pose = "Climbing" end local function onGettingUp() pose = "GettingUp" end local function onFreeFall() if (jumpAnimTime <= 0) then playAnimation("fall", fallTransitionTime, Humanoid) end pose = "FreeFall" end local function onFallingDown() pose = "FallingDown" end local function onSeated() pose = "Seated" end local function onPlatformStanding() pose = "PlatformStanding" end local function onSwimming(speed) if speed > 0 then pose = "Running" else pose = "Standing" end end local function getTool() return c and c:FindFirstChildOfClass("Tool") end local function getToolAnim(tool) for _, c in ipairs(tool:GetChildren()) do if c.Name == "toolanim" and c.className == "StringValue" then return c end end return nil end local function animateTool() if (toolAnim == "None") then playToolAnimation("toolnone", toolTransitionTime, Humanoid, Enum.AnimationPriority.Idle) return end if (toolAnim == "Slash") then playToolAnimation("toolslash", 0, Humanoid, Enum.AnimationPriority.Action) return end if (toolAnim == "Lunge") then playToolAnimation("toollunge", 0, Humanoid, Enum.AnimationPriority.Action) return end end local function moveSit() RightShoulder.MaxVelocity = 0.15 LeftShoulder.MaxVelocity = 0.15 RightShoulder:SetDesiredAngle(3.14 /2) LeftShoulder:SetDesiredAngle(-3.14 /2) RightHip:SetDesiredAngle(3.14 /2) LeftHip:SetDesiredAngle(-3.14 /2) end local lastTick = 0 local function move(time) local amplitude = 1 local frequency = 1 local deltaTime = time - lastTick lastTick = time local climbFudge = 0 local setAngles = false if (jumpAnimTime > 0) then jumpAnimTime = jumpAnimTime - deltaTime end if (pose == "FreeFall" and jumpAnimTime <= 0) then playAnimation("fall", fallTransitionTime, Humanoid) elseif (pose == "Seated") then playAnimation("sit", 0.5, Humanoid) return elseif (pose == "Running") then playAnimation("walk", 0.1, Humanoid) elseif (pose == "Dead" or pose == "GettingUp" or pose == "FallingDown" or pose == "Seated" or pose == "PlatformStanding") then stopAllAnimations() amplitude = 0.1 frequency = 1 setAngles = true end if (setAngles) then local desiredAngle = amplitude * math.sin(time * frequency) RightShoulder:SetDesiredAngle(desiredAngle + climbFudge) LeftShoulder:SetDesiredAngle(desiredAngle - climbFudge) RightHip:SetDesiredAngle(-desiredAngle) LeftHip:SetDesiredAngle(-desiredAngle) end local tool = getTool() if tool and tool:FindFirstChild("Handle") then local animStringValueObject = getToolAnim(tool) if animStringValueObject then toolAnim = animStringValueObject.Value animStringValueObject.Parent = nil toolAnimTime = time + .3 end if time > toolAnimTime then toolAnimTime = 0 toolAnim = "None" end animateTool() else stopToolAnimations() toolAnim = "None" toolAnimInstance = nil toolAnimTime = 0 end end Humanoid.Died:connect(onDied) Humanoid.Running:connect(onRunning) Humanoid.Jumping:connect(onJumping) Humanoid.Climbing:connect(onClimbing) Humanoid.GettingUp:connect(onGettingUp) Humanoid.FreeFalling:connect(onFreeFall) Humanoid.FallingDown:connect(onFallingDown) Humanoid.Seated:connect(onSeated) Humanoid.PlatformStanding:connect(onPlatformStanding) Humanoid.Swimming:connect(onSwimming) game:GetService("Players").LocalPlayer.Chatted:connect(function(msg) local emote = "" if msg == "/e dance" then emote = dances[math.random(1, #dances)] elseif (string.sub(msg, 1, 3) == "/e ") then emote = string.sub(msg, 4) elseif (string.sub(msg, 1, 7) == "/emote ") then emote = string.sub(msg, 8) end if (pose == "Standing" and emoteNames[emote] ~= nil) then playAnimation(emote, 0.1, Humanoid) end end) playAnimation("idle", 0.1, Humanoid) pose = "Standing" tdelay(0, function() while c do local _, time = wait(0.1) if (script.Parent == c) and (not script.Disabled) then move(time) end end end) end 
end

local torso1 = torso
torso = gp(c, "Torso", "BasePart") or ((not R15toR6) and gp(c, torso.Name, "BasePart"))
if (typeof(hedafterneck) == "Instance") and head and torso and torso1 then
    local conNeck, conTorso, conTorso1 = nil, nil, nil
    local aligns = {}
    local function enableAligns()
        conNeck:Disconnect()
        conTorso:Disconnect()
        conTorso1:Disconnect()
        for i, v in pairs(aligns) do
            v.Enabled = true
        end
    end
    conNeck = hedafterneck.Changed:Connect(function(prop)
        if table.find({"Part0", "Part1", "Parent"}, prop) then
            enableAligns()
        end
    end)
    conTorso = torso:GetPropertyChangedSignal("Parent"):Connect(enableAligns)
    conTorso1 = torso1:GetPropertyChangedSignal("Parent"):Connect(enableAligns)
    for i, v in pairs(getdescendants(head)) do
        if isa(v, "AlignPosition") or isa(v, "AlignOrientation") then
            i = tostring(i)
            aligns[i] = v
            v:GetPropertyChangedSignal("Parent"):Connect(function()
                aligns[i] = nil
            end)
            v.Enabled = false
        end
    end
end

local flingpart0 = gp(model, flingpart, "BasePart") or gp(gp(model, flingpart, "Accessory"), "Handle", "BasePart")
local flingpart1 = gp(c, flingpart, "BasePart") or gp(gp(c, flingpart, "Accessory"), "Handle", "BasePart")

local fling = function() end
if flingpart0 and flingpart1 then
    flingpart0:GetPropertyChangedSignal("Parent"):Connect(function()
        if not (flingpart0 and flingpart0.Parent) then
            flingpart0 = nil
            fling = function() end
        end
    end)
    flingpart0.Archivable = true
    flingpart1:GetPropertyChangedSignal("Parent"):Connect(function()
        if not (flingpart1 and flingpart1.Parent) then
            flingpart1 = nil
            fling = function() end
        end
    end)
    local att0 = gp(flingpart0, "att0_" .. flingpart0.Name, "Attachment")
    local att1 = gp(flingpart1, "att1_" .. flingpart1.Name, "Attachment")
    if att0 and att1 then
        att0:GetPropertyChangedSignal("Parent"):Connect(function()
            if not (att0 and att0.Parent) then
                att0 = nil
                fling = function() end
            end
        end)
        att1:GetPropertyChangedSignal("Parent"):Connect(function()
            if not (att1 and att1.Parent) then
                att1 = nil
                fling = function() end
            end
        end)
        local lastfling = nil
        local mouse = lp:GetMouse()
        fling = function(target, duration, rotVelocity)
            if typeof(target) == "Instance" then
                if isa(target, "BasePart") then
                    target = target.Position
                elseif isa(target, "Model") then
                    target = gp(target, "HumanoidRootPart", "BasePart") or gp(target, "Torso", "BasePart") or gp(target, "UpperTorso", "BasePart") or target:FindFirstChildWhichIsA("BasePart")
                    if target then
                        target = target.Position
                    else
                        return
                    end
                elseif isa(target, "Humanoid") then
                    target = target.Parent
                    if not (target and isa(target, "Model")) then
                        return
                    end
                    target = gp(target, "HumanoidRootPart", "BasePart") or gp(target, "Torso", "BasePart") or gp(target, "UpperTorso", "BasePart") or target:FindFirstChildWhichIsA("BasePart")
                    if target then
                        target = target.Position
                    else
                        return
                    end
                else
                    return
                end
            elseif typeof(target) == "CFrame" then
                target = target.Position
            elseif typeof(target) ~= "Vector3" then
                target = mouse.Hit
                if target then
                    target = target.Position
                else
                    return
                end
            end
            if target.Y < ws.FallenPartsDestroyHeight + 5 then
                target = v3(target.X, ws.FallenPartsDestroyHeight + 5, target.Z)
            end
            lastfling = target
            if type(duration) ~= "number" then
                duration = tonumber(duration) or 0.5
            end
            if typeof(rotVelocity) ~= "Vector3" then
                rotVelocity = v3(20000, 20000, 20000)
            end
            if not (target and flingpart0 and flingpart1 and att0 and att1) then
                return
            end
            flingpart0.Archivable = true
            local flingpart = clone(flingpart0)
            flingpart.Transparency = 1
            flingpart.CanCollide = false
            flingpart.Name = "flingpart_" .. flingpart0.Name
            flingpart.Anchored = true
            flingpart.Velocity = v3_0
            flingpart.RotVelocity = v3_0
            flingpart.Position = target
            flingpart:GetPropertyChangedSignal("Parent"):Connect(function()
                if not (flingpart and flingpart.Parent) then
                    flingpart = nil
                end
            end)
            flingpart.Parent = flingpart1
            if flingpart0.Transparency > 0.5 then
                flingpart0.Transparency = 0.5
            end
            att1.Parent = flingpart
            local con = nil
            local rotchg = v3(0, rotVelocity.Unit.Y * -1000, 0)
            con = heartbeat:Connect(function(delta)
                if target and (lastfling == target) and flingpart and flingpart0 and flingpart1 and att0 and att1 then
                    flingpart.Orientation += rotchg * delta
                    flingpart0.RotVelocity = rotVelocity
                else
                    con:Disconnect()
                end
            end)
            if alignmode ~= 4 then
                local con = nil
                con = renderstepped:Connect(function()
                    if flingpart0 and target then
                        flingpart0.RotVelocity = v3_0
                    else
                        con:Disconnect()
                    end
                end)
            end
            twait(duration)
            if lastfling ~= target then
                if flingpart then
                    if att1 and (att1.Parent == flingpart) then
                        att1.Parent = flingpart1
                    end
                    pcall(destroy, flingpart)
                end
                return
            end
            target = nil
            if not (flingpart and flingpart0 and flingpart1 and att0 and att1) then
                return
            end
            flingpart0.RotVelocity = v3_0
            att1.Parent = flingpart1
            pcall(destroy, flingpart)
        end
    end
end
