-- proxy instance creator, allows the client to access server stuff
-- by mike
-- v2025.0516

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AuroraCore = ReplicatedStorage:WaitForChild("AuroraCore")
local ProxyFolder = AuroraCore:WaitForChild("ProxyEvents")

local Proxy = {}
Proxy.__index = Proxy

function Proxy.new(name)
	local self = setmetatable({}, Proxy)
	self._folder = ProxyFolder:WaitForChild(name, 5)
	assert(self._folder, "folder DOES NOT exist")
	
	return self
end

function Proxy:AddReturningMethod(name)
	self[name] = function(_, ...)
		return self._folder[name]:InvokeServer(...)
	end
end

function Proxy:AddSingleWayMethod(name)
	self[name] = function(_, ...)
		self._folder[name]:FireServer(...)
	end
end

return Proxy