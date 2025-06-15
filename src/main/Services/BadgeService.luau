-- BadgeService, placeholder for badges
-- by mike
-- v2025.0614

local BadgeServiceRoot = game:GetService("BadgeService")
local InstanceRoot = require("../DataTypes/Instance")
local RBXScriptSignal = require("../DataTypes/RBXScriptSignal")
local Inheritance = require("../Utils/Inheritance")

local BadgeService = setmetatable({}, InstanceRoot)
BadgeService.__index = BadgeService

function BadgeService.new()
	local self = setmetatable(InstanceRoot.new(), BadgeService)
	self.ClassName = "BadgeService"
	
	self.BadgeAwarded = RBXScriptSignal.new()
	
	return self
end

return Inheritance.new(BadgeServiceRoot, BadgeService)