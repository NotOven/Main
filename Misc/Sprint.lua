local InputService = game:GetService("UserInputService")
local plr = game:GetService('Players').LocalPlayer
local KeyCode = Enum.KeyCode.LeftShift
local sprinting = false
local NormSpeed = plr.Character:FindFirstChildOfClass('Humanoid').WalkSpeed

InputService.InputBegan:Connect(function(input)
	if input.KeyCode == KeyCode then
	    if sprinting == false then NormSpeed = plr.Character:FindFirstChildOfClass('Humanoid').WalkSpeed end
		plr.Character:FindFirstChildOfClass('Humanoid').WalkSpeed = 36
		spinting = true
	end
end)
InputService.InputEnded:Connect(function(input)
	if input.KeyCode == KeyCode then
		plr.Character:FindFirstChildOfClass('Humanoid').WalkSpeed = NormSpeed
		sprinting = false
	end
end)
