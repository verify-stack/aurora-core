-- DataModel instance aka game
-- by mike
-- v2025.0711

local RunService = game:GetService("RunService")

local InstanceRoot = require("./Instance")
local Inheritance = require("../Utils/Inheritance")
local Proxy = require("../Utils/Proxy")
local settings = require("../Settings")
local EnvConfig = require("../EnvConfig")

local DataTypes = script.Parent
local AuroraCore = DataTypes.Parent
local Services = AuroraCore:WaitForChild("Services")
local ProxyEvents = AuroraCore:WaitForChild("ProxyEvents")

local structureReference = require("../Utils/StrictStructure")

local DataModel = setmetatable({}, InstanceRoot)
DataModel.__index = DataModel

function DataModel.new()
	local self = setmetatable(InstanceRoot.new(game), DataModel)
	self.MESSAGE_VAILDSERVICE = "'%s' is not a valid Service name"
	self.FLAG_USEGETSERVICE = settings():GetFFlag("UseClassNameGetService")
	self.FLAG_DELAYLOADING = settings():GetFFlag("UseDelayedLoading")
	self.FLAG_USECAS = settings():GetFFlag("AllowCASConnectionsAndDatabaseConnections")
	self.FLAG_USEPROXY = settings():GetFFlag("EnableCASProxy")
	self.SERVICES = {}
	self.CASServicesList = {}

	for name, _ in pairs(structureReference) do
		table.insert(self.CASServicesList, name)
	end
	self:InitServices()
	
	return self
end

function DataModel:InitServices()
	for _, module in ipairs(Services:GetChildren()) do
		self.SERVICES[module.Name] = require(module).new()
		self[module.Name] = self.SERVICES[module.Name]
		table.insert(self.Children, self.SERVICES[module.Name])
	end

	-- TODO: make this nicer
	if self.FLAG_USECAS and self.FLAG_USEPROXY and RunService:IsClient() then -- client CAS support
		repeat
			task.wait()
		until ProxyEvents:GetAttribute("CASInit") == true

		for _, serviceName in pairs(self.CASServicesList) do
			if not ProxyEvents:FindFirstChild(serviceName) then -- the user doesn't have to add all services
				continue
			end

			local newService = Proxy.new(serviceName)
			local structure = structureReference[serviceName]
			for _, method in pairs(structure.Methods) do
				newService:AddReturningMethod(method)
			end
			for _, variable in pairs(structure.Variables) do
				local success, message = pcall(function()
					newService:AddVariable(variable) 
				end)

				if not success and message:find("this is an signal") then -- most likely an signal
					newService:AddSignal(variable)
				end
			end
			
			self.SERVICES[serviceName] = newService
			self[serviceName] = newService
			table.insert(self.Children, newService)
		end
	end

	if self.FLAG_USECAS and RunService:IsServer() then -- server runtime
		local ClientAdapterService = self:GetService("ClientAdapterService")
		for _, serviceName in pairs(self.CASServicesList) do
			local newService = ClientAdapterService:GetService(serviceName)
			self.SERVICES[serviceName] = newService
			self[serviceName] = newService
			table.insert(self.Children, newService)
		end
	end
end

function DataModel:GetAdmins()
	return EnvConfig.AdminList
end

function DataModel:FindService(name)
	local Service = self.SERVICES[name]
	if not Service then
		local _, _ = pcall(function()
			Service = game:FindService(name)
		end)
	end
	assert(Service, self.MESSAGE_VAILDSERVICE:format(name))
	
	return Service
end

function DataModel:GetService(name)
	-- slightly slower version of findservice
	-- but is faithful to roblox
	if self.FLAG_USEGETSERVICE then
		for _, module in self.SERVICES do
			if module.ClassName == name then
				return module
			end
		end
		
		return game:GetService(name)
	else
		return self:FindService(name)
	end
end

function DataModel:SetVerb(guiObject, verbString)
	assert(self:GetService("RunService"):IsClient(), "SetVerb can only be ran on the client")
	assert(guiObject:IsA("GuiObject"), "guiObject must be a GuiObject")
	
	local verbList = {
		["Exit"] = function()
			-- TODO: add more things here
			self:GetService("TeleportService"):Teleport(1)
		end,
	}
	
	guiObject.MouseButton1Click:Connect(verbList[verbString])
end

return Inheritance.new(game, DataModel)