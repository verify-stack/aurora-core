-- settings for scripts
-- by mike
-- v2025.0511

local InstanceRoot = require("../Instance")
local EnvConfig = require("../../EnvConfig")

local RenderSettings = setmetatable({}, InstanceRoot)
RenderSettings.__index = RenderSettings

function RenderSettings.new()
	local self = setmetatable(InstanceRoot.new(), RenderSettings)
	self.Name = "Rendering"
	self.ClassName = "RenderSettings"
	self.MAX_QUALITY = 21
	
	-- actual settings
	self.QualityLevel = 21
	self.AutoFRMLevel = 21

	return self
end

function RenderSettings:GetMaxQualityLevel()
	return self.MAX_QUALITY
end

return RenderSettings