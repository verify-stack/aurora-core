-- settings for scripts
-- by mike
-- v2025.0618

local InstanceRoot = require("./Instance")
local EnvConfig = require("../EnvConfig")
local SettingsSubset = script.Parent:WaitForChild("SettingsSubset")

local GlobalSettings = setmetatable({}, InstanceRoot)
GlobalSettings.__index = GlobalSettings

function GlobalSettings.new()
	local self = setmetatable(InstanceRoot.new(), GlobalSettings)
	self.FAILURE_NOFLAG = "Flag %s referenced from Lua isn't defined in C++ code"
	self.Name = "Global Settings"
	self.ClassName = "GlobalSettings"
	for _, setting in ipairs(SettingsSubset:GetChildren()) do
		setting = require(setting).new()
		table.insert(self.Children, setting)
		self[setting.Name] = setting
	end

	return self
end

function GlobalSettings:GetFFlag(name)
	local findFlag = function(name)
		for key, value in pairs(EnvConfig.FFlags) do
			if key == name then
				return value
			end
		end
	end
	
	assert(findFlag(name) ~= nil, self.FAILURE_NOFLAG:format(name))
	return findFlag(name)
end

function GlobalSettings:GetFVariable(name)
	return GlobalSettings:GetFFlag(name)
end

function GlobalSettings:FindService(name)
	return GlobalSettings:FindFirstChild(name)
end

function GlobalSettings:GetService(name)
	return self:FindService(name)
end

return GlobalSettings -- we can't inherit because we need to keep the same things inside