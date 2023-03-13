local InputService = game:GetService("UserInputService")
local plr = game:GetService('Players').LocalPlayer
local KeyCode = Enum.KeyCode.LeftControl
local sprinting = false
local NormSpeed = plr.Character:FindFirstChildOfClass('Humanoid').WalkSpeed

--Notif To Switch Sprint Key In Case LeftControl Is Already Used
local Bindable = Instance.new("BindableFunction")
function Switch(Response)
	if Response == "Yes" then
		KeyCode = Enum.KeyCode.LeftShift
	elseif Response == "No" then
		KeyCode = Enum.KeyCode.LeftControl
	end
	Bindable:Destroy()
end

    Bindable.OnInvoke = Switch
    game.StarterGui:SetCore("SendNotification",{Title = "Switch Sprint Key To Left Shift?";Text = "";Duration = 9e9;Callback = Bindable,Button1 = "Yes",Button2 = "No"})

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
