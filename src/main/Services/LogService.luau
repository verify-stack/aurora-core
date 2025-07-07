-- testing service for checks
-- by mike
-- v2025.0614

local LogServiceRoot = game:GetService("LogService")
local InstanceRoot = require("../DataTypes/Instance")
local Inheritance = require("../Utils/Inheritance")
local RBXScriptSignal = require("../DataTypes/RBXScriptSignal")

local LogService = setmetatable({}, InstanceRoot)
LogService.__index = LogService

function LogService.new()
	local self = setmetatable(InstanceRoot.new(), LogService)
	self.ClassName = "LogService"
	self.UseVLuaEmulation = true -- placeholder for an fflag
	self.TunaCanVersion = "v2025.0614" -- tuna-can doesn't exist yet, just wait...
	
	self.ServerMessageOut = RBXScriptSignal.new()

	return self
end

function LogService:ExecuteScript(code)
	warn("not added")
end

function LogService:RequestServerOutput()
	warn("not added")
end

return Inheritance.new(LogServiceRoot, LogService)