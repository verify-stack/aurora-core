-- proxy instance creator, server variant
-- by mike
-- v2025.0516

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AuroraCore = ReplicatedStorage:WaitForChild("AuroraCore")
local ProxyFolder = AuroraCore:WaitForChild("ProxyEvents")

local Proxy = {}
Proxy.__index = Proxy

function Proxy.new(name)
	local self = setmetatable({}, Proxy)
	if not ProxyFolder:FindFirstChild(name) then
		local folder = Instance.new("Folder")
		folder.Name = name
		folder.Parent = ProxyFolder
		print("creating folder")
	end
	self._folder = ProxyFolder[name]

	return self
end

function Proxy:AddReturningMethod(name, func)
	local funce = Instance.new("RemoteFunction")
	funce.Name = name
	funce.OnServerInvoke = function(_, ...)
		return func(...)
	end
	funce.Parent = self._folder
end

function Proxy:AddSingleWayMethod(name, func)
	local event = Instance.new("RemoteEvent")
	event.Name = name
	event.OnServerEvent:Connect(function(_, ...)
		func(...)
	end)
	event.Parent = self._folder
end

return Proxy