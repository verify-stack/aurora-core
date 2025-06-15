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

	if value then
		value.ChildAdded:Connect(function(child)
			table.insert(self.Children, child)
			self.ChildAdded:Fire(child)
		end)

		value.ChildRemoved:Connect(function(child)
			local findPosNumber = function(item)
				for num, it in pairs(self.Children) do
					if it == item then
						return num
					end
				end
			end

			table.remove(self.Children, findPosNumber(child))
			self.ChildRemoved:Fire(child)
		end)

		value.Destroying:Connect(function()
			Instance:SetParent(nil)
			self.Destroying:Fire()
		end)

		value.AncestryChanged:Connect(function(part, instance)
			self.AncestryChanged:Fire(part, instance)
		end)
	end
	
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
	if parent == nil then
		local findPosNumber = function(item)
			for num, it in pairs(self.Children) do
				if it == item then
					return num
				end
			end
		end

		table.remove(parent.Children, findPosNumber(self))
		return
	end
	table.insert(parent.Children, self)
	self.Parent = parent
end

return Instance