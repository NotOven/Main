repeat task.wait() until game:IsLoaded()
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = game:GetService("Workspace"):WaitForChild("Camera")
local KeyCode = Enum.KeyCode.C
local CameraZoomedIn = false
local NotFinished = false
local OldZoomValue = Camera.FieldOfView

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == KeyCode and not CameraZoomedIn and not NotFinished then
        NotFinished = true
        TweenService:Create(Camera, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {FieldOfView = 20}):Play()
        CameraZoomedIn = true
        NotFinished = false
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == KeyCode and CameraZoomedIn and not NotFinished then
        NotFinished = true
        TweenService:Create(Camera, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {FieldOfView = OldZoomValue}):Play()
        CameraZoomedIn = false
        NotFinished = false
    end
end)
