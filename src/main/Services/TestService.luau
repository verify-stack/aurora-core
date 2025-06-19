-- testing service for checks
-- by mike
-- v2025.0503

local TestServiceRoot = game:GetService("TestService")
local InstanceRoot = require("../DataTypes/Instance")
local Inheritance = require("../Utils/Inheritance")

local TestService = setmetatable({}, InstanceRoot)
TestService.__index = TestService

function TestService.new()
	local self = setmetatable(InstanceRoot.new(), TestService)
	self.ClassName = "TestService"
	
	self.AuroraCoreVersion = "v2025.0618"
	self.AuroraCoreVersionGlobal = 8
	
	return self
end

return Inheritance.new(TestServiceRoot, TestService)