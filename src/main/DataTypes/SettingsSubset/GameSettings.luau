-- settings for scripts
-- by mike
-- v2025.0511

local InstanceRoot = require("../Instance")
local EnvConfig = require("../../EnvConfig")
local RBXScriptSignal = require("../RBXScriptSignal")

local GameSettings = setmetatable({}, InstanceRoot)
GameSettings.__index = GameSettings

function GameSettings.new()
	local self = setmetatable(InstanceRoot.new(), GameSettings)
	self.Name = "Game Options"
	self.ClassName = "GameSettings"

	-- actual settings
	self.VideoRecordingChangeRequest = RBXScriptSignal.new()
	self.VideoCaptureEnabled = true
	self.VideoRecording = false
	self.VideoRecordingChangeRequest:Connect(function()
		self.VideoRecording = not self.VideoRecording
	end)

	return self
end


return GameSettings