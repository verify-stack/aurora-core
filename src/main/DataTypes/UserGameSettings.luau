-- user settings for scripts
-- by mike
-- v2025.0511

local InstanceRoot = require("./Instance")
local Inheritance = require("../Utils/Inheritance")
local UploadEnum = require("../UploadEnum")

local UserGameSettings = setmetatable({}, InstanceRoot)
UserGameSettings.__index = UserGameSettings

function UserGameSettings.new()
	local self = setmetatable(InstanceRoot.new(), UserGameSettings)
	self.Name = "GameSettings"
	self.ClassName = "UserGameSettings"
	
	-- actual settings
	self.ControlMode = Enum.ControlMode.MouseLockSwitch
	self.CameraMode = Enum.CameraMode.Classic
	self.ComputerCameraMovementMode = Enum.ComputerCameraMovementMode.Classic
	self.ComputerMovementMode = Enum.ComputerMovementMode.Default
	self.TouchCameraMovementMode = Enum.TouchCameraMovementMode.Default
	self.TouchMovementMode = Enum.TouchMovementMode.Default
	self.SavedQualityLevel = Enum.SavedQualitySetting.Automatic
	self.VideoUploadPromptBehavior = UploadEnum["Never"]

	self.MasterVolume = 1

	self.FullscreenChanged = UserSettings().GameSettings.FullscreenChanged
	self.StudioModeChanged = UserSettings().GameSettings.StudioModeChanged
	
	return self
end

function UserGameSettings:InStudioMode()
	return UserSettings().GameSettings:InStudioMode()
end

function UserGameSettings:InFullScreen()
	return UserSettings().GameSettings:InFullScreen()
end

return Inheritance.new(UserSettings().GameSettings, UserGameSettings)