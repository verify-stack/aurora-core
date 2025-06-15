-- only really used for LoadingScript and RemoveDefaultLoadingScreen
-- by mike
-- v2025.0503

local ReplicatedFirstRoot = game:GetService("ReplicatedFirst")
local InstanceRoot = require("../DataTypes/Instance")
local RBXScriptSignal = require("../DataTypes/RBXScriptSignal")
local Inheritance = require("../Utils/Inheritance")

local ReplicatedFirst = setmetatable({}, InstanceRoot)
ReplicatedFirst.__index = ReplicatedFirst

function ReplicatedFirst.new()
	local self = setmetatable(InstanceRoot.new(ReplicatedFirstRoot), ReplicatedFirst)
	self.ClassName = "ReplicatedFirst"
	
	self.FinishedReplicating = RBXScriptSignal.new()
	self.RemoveDefaultLoadingGuiSignal = RBXScriptSignal.new()
	self.RemoveDefaultLoadingGuiValue = false
	
	return self
end

function ReplicatedFirst:IsFinishedReplicating()
	return true
end

function ReplicatedFirst:IsDefaultLoadingGuiRemoved()
	return self.RemoveDefaultLoadingGuiValue
end

function ReplicatedFirst:RemoveDefaultLoadingScreen()
	self.RemoveDefaultLoadingGuiSignal:Fire()
	self.RemoveDefaultLoadingGuiValue = true
end

return Inheritance.new(ReplicatedFirstRoot, ReplicatedFirst)