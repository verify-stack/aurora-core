-- user settings for scripts
-- by mike
-- v2025.0615

local InstanceRoot = require("./Instance")
local EnvConfig = require("../EnvConfig")
local UserGameSettings = require("./UserGameSettings").new()

local UserSettings = setmetatable({}, InstanceRoot)
UserSettings.__index = UserSettings

function UserSettings.new()
	local self = setmetatable(InstanceRoot.new(), UserSettings)
	self.FAILURE_NOFLAG = "Flag %s does not exist"
	self.Name = "GlobalBasicSettings"
	self.ClassName = "UserSettings"
	table.insert(self.Children, UserGameSettings)
	self[UserGameSettings.Name] = UserGameSettings

	return self
end

function UserSettings:IsUserFeatureEnabled(name)
	assert(EnvConfig[name], self.FAILURE_NOFLAG:format(name))
	return EnvConfig[name]
end

return UserSettings -- we can't inherit because we need to keep the same things inside