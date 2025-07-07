-- handle tests
-- by mike
-- v2025.0706

local UserInputServiceRoot = game:GetService("UserInputService")
local InstanceRoot = require("../DataTypes/Instance")
local Inheritance = require("../Utils/Inheritance")
local settings = require("../Settings")

local luaControlsSuccess, luaControlsFlagValue = pcall(function() return settings():GetFFlag("UseLuaCameraAndControl") end)
local extensionModuleSuccess, extensionModuleFlagValue = pcall(function() return settings():GetFFlag("ExtensionModules") end)

local UserInputService = setmetatable({}, InstanceRoot)
UserInputService.__index = UserInputService

function UserInputService.new()
	local self = setmetatable(InstanceRoot.new(), UserInputService)
	self.ClassName = "UserInputService"
	self.LegacyCameraControls = not luaControlsSuccess or (luaControlsSuccess and luaControlsFlagValue == false)
	self.ExtensionModules = if extensionModuleSuccess and type(extensionModuleFlagValue) == "table" then extensionModuleFlagValue else false
    if self.LegacyCameraControls and self.ExtensionModules then
		self.LegacyCamera = require(self.ExtensionModules.CameraModule)
        self.InputCamera = self.LegacyCamera.new("AuroraCore-LegacyCamera")
    end
	
	self.ProcessedEvent = UserInputServiceRoot.InputBegan -- wtf??
	
	return self
end

function UserInputService:IsLuaTouchControls()
	return true--self.LegacyCameraControls
end

-- camerascript already handles these two
function UserInputService:RotateCamera(rotateVector)
	if self.LegacyCameraControls and self.ExtensionModules then
		return
	end
	self.InputCamera:RotateCamera(rotateVector)
end

function UserInputService:ZoomCamera(zoom)
	if self.LegacyCameraControls and self.ExtensionModules then
		return
	end
	self.InputCamera:ZoomCamera(zoom)
end

return Inheritance.new(UserInputServiceRoot, UserInputService)