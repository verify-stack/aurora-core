-- every object will inherit this
-- by mike
-- v2025.0503

local RBXScriptSignal = require("./RBXScriptSignal")
local Instance = {}
Instance.__index = Instance

function Instance.prototype(value)
	local self = {}
	self.Name = ""
	self.ClassName = ""
	self.Archivable = false
	self.RobloxLocked = false
	self.Parent = nil
	
	self.Children = {}
	self.Value = value or self
	
	self.ChildAdded = RBXScriptSignal.new()
	self.ChildRemoved = RBXScriptSignal.new()
	self.Destroying = RBXScriptSignal.new()
	self.AncestryChanged = RBXScriptSignal.new()
	
	return self
end

function Instance.new(value)
	return setmetatable(Instance.prototype(value), Instance)
end

function Instance:FindFirstChild(name, rec)
	for _, child in pairs(self.Children) do
		if child.Name == name then
			return child.Value
		elseif rec then
			local found = child:FindFirstChild(name, true)
			if found then
				return found.Value
			end
		end
	end
end

function Instance:WaitForChild(name, timeout)
	-- TODO: find out a way to yield
	return self:FindFirstChild(name)
end

function Instance:GetChildren()
	return self.Children
end

function Instance:SetParent(parent)
	table.insert(parent.Children, self)
	self.Parent = parent
end

return Instance