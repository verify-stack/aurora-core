-- startergui but for default guis
-- by mike
-- v2025.0706

local RunService = game:GetService("RunService")
if RunService:IsServer() then
	return {
		new = function()
			return {
				WARNING = "The server cannot access CoreGui."
			}
		end
	}
end

local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer.PlayerGui

local InstanceRoot = require("../DataTypes/Instance")
local Inheritance = require("../Utils/Inheritance")
--local Create = require("../Utils/Create") [did you know RobloxGuiBuilder would've been here instead. i will do that later]
local EnvConfig = require("../EnvConfig")

local CoreGui = setmetatable({}, InstanceRoot)
CoreGui.__index = CoreGui

function CoreGui.new()
	local self = setmetatable(InstanceRoot.new(PlayerGui), CoreGui)
	self.ClassName = "CoreGui"
	
	self.VersionFull = EnvConfig.CoreGuiVerDict[EnvConfig.ClientPeriod]
	if not self.VersionFull then
		self.VersionFull = EnvConfig.CoreGuiVerDict["2015E"] -- latest version
	end
	self.Version = self.VersionFull[1]
	
	return self
end

return Inheritance.new(PlayerGui, CoreGui)