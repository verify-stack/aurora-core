-- only here for coregui handling
-- by mike
-- v2025.0615

local StarterGuiRoot = game:GetService("StarterGui")
local InstanceRoot = require("../DataTypes/Instance")
local RBXScriptSignal = require("../DataTypes/RBXScriptSignal")
local Inheritance = require("../Utils/Inheritance")

local StarterGui = setmetatable({}, InstanceRoot)
StarterGui.__index = StarterGui

function StarterGui.new()
	local self = setmetatable(InstanceRoot.new(), StarterGui)
	self.ClassName = "StarterGui"
	
	self._EnabledCoreGui = {
		[Enum.CoreGuiType.PlayerList] = true,
		[Enum.CoreGuiType.Backpack] = true,
		[Enum.CoreGuiType.Chat] = true,
		[Enum.CoreGuiType.Health] = true
	}
	self.CoreGuiChangedSignal = RBXScriptSignal.new()
	if settings():GetFFlag("DisableRobloxCoreGui") then
		StarterGuiRoot:SetCoreGuiEnabled(Enum.CoreGuiType.All, false) -- disable the coregui because we'll be replacing them
	end
	
	return self
end

function StarterGui:GetCoreGuiEnabled(coreGuiType)
	return self._EnabledCoreGui[coreGuiType]
end

function StarterGui:SetCoreGuiEnabled(coreGuiType, enabled)
	self._EnabledCoreGui[coreGuiType] = enabled
	self.CoreGuiChangedSignal:Fire(coreGuiType, enabled)
end

return Inheritance.new(StarterGuiRoot, StarterGui)