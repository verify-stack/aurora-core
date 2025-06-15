-- inheritance for instance wrapping
-- by mike
-- v2025.0503

local Inheritance = {}
Inheritance.MESSAGE_MEMBER = '%s is not a valid member of %s "%s"'
Inheritance.__index = function(wrapper, key)
	-- https://devforum.roblox.com/t/simplest-form-of-instance-wrapping-that-just-works/3489954
	-- one of the best tutorials for this lol
	if Inheritance[key] then return Inheritance[key] end

	local instance = rawget(wrapper, "_instance")
	if type(instance[key]) == "function" then
		return function(FirstParameter, ...)
			return instance[key](instance, ...)
		end
	else
		return instance[key]
	end
	
	--error(Inheritance.MESSAGE_MEMBER:format(key, class.Name, class.ClassName))
end

function Inheritance.new(instance, class)
	local self = setmetatable(class, Inheritance)
	self._instance = instance
	self._name = class.Name or ""
	self._cname = class.ClassName or ""
	
	return self
end

return Inheritance