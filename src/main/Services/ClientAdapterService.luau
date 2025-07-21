-- client adapter service is important for server-side services.
-- by mike
-- v2025.0711

local RunService = game:GetService("RunService")
local InstanceRoot = require("../DataTypes/Instance")
local settings = require("../Settings")
local createEmptyServiceWrapper = function(self, className)
    local service = setmetatable({}, InstanceRoot)
    service.__index = service

    function service.new()
        local self = setmetatable(InstanceRoot.new(), service)
        self.ClassName = className

	    return self
    end

    return self
end

if not settings():GetFFlag("AllowCASConnectionsAndDatabaseConnections") then
	return {
		new = function()
            -- don't overflow the client with warnings
            if RunService:IsServer() then warn("The FFlag \"AllowCASConnectionsAndDatabaseConnections\" is disabled. Enable it to use InsertService!") end
			return {
				WARNING = "The FFlag \"AllowCASConnectionsAndDatabaseConnections\" is disabled. Enable it to use InsertService!",
			}
		end
	}
end
if RunService:IsClient() then
    return {
		new = function()
			return {
				WARNING = "This service must be ran on the server!",
                createEmptyServiceWrapper = createEmptyServiceWrapper
			}
		end
	}
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local AuroraCore = ServerStorage.AuroraCore
local AuroraCoreShared = ReplicatedStorage.AuroraCore
local CASList = AuroraCore.CAS

local Inheritance = require("../Utils/Inheritance")
local RBXScriptSignal = require("../DataTypes/RBXScriptSignal")
local Proxy = require(AuroraCore.Utils.ProxyServer)

local structureReference = require("../Utils/StrictStructure")
local tableFind = require("../Utils/TableFind")

local CASLogger = {}
CASLogger.__index = CASLogger

function CASLogger.new()
    -- basic logger
    local self = setmetatable({}, CASLogger)
    self.logHistory = {}
    self.logFormat = "[%s, %s : %s]: %s"
    self.logTag = "Client Adapter Service SDK"
    
	return self
end

function CASLogger:_threadString(...)
    local finalString = ""
    for index, str in pairs({...}) do
        local spacing = " "
        if index == 1 then
            spacing = ""
        end
        finalString = finalString .. spacing .. str
    end
    return finalString
end
function CASLogger:_normalLog(type, ...)
    table.insert(self.logHistory, {
        type = type,
        timestamp = os.date("%c"),
        message = self:_threadString(...)
    })
end

function CASLogger:logprint(...)
    self:_normalLog("print", ...)
end

function CASLogger:logwarn(...)
    self:_normalLog("warn", ...)
end

function CASLogger:logerror(...)
    self:_normalLog("error", ...)
end

function CASLogger:logassert(condition, ...) -- let the user break the function, since we can't
    if not condition then
        self:_normalLog("assert", ...)
        return true
    end

    return false
end

function CASLogger:dumplog()
    local logTable = {
        ["print"] = print,
        ["warn"] = warn,
        ["error"] = error,
        ["assert"] = error
    }

    for _, log in ipairs(self.logHistory) do
        task.spawn(logTable[log.type], self.logFormat:format(
            self.logTag,
            log.type,
            log.timestamp,
            log.message
        ))
    end
end

local CASToolkit = {}
CASToolkit.__index = CASToolkit

function CASToolkit.new(isClient)
    -- the mini sdk used for logging and sending instances through the server
    local self = setmetatable({}, CASToolkit)
    self.logger = CASLogger.new()
    
	return self
end

function CASToolkit:createsignal()
    return RBXScriptSignal.new()
end

function CASToolkit:sendnil()
    -- might do something useful here
    return
end

function CASToolkit:sendinstance(instance)
    assert(instance, "instance must exist!")
    assert(typeof(instance), "instance must exist!")

    local clone = instance:Clone()
    clone.Parent = AuroraCoreShared.SharedInstances
    return clone
end

local ClientAdapterService = setmetatable({}, InstanceRoot)
ClientAdapterService.__index = ClientAdapterService

function ClientAdapterService.new()
    local self = setmetatable(InstanceRoot.new(), ClientAdapterService)
	self.ClassName = "ClientAdapterService"
    self.Name = "Client Adapter Service"

    self.serviceCache = {}

	return self
end

function ClientAdapterService:_GetRootService(className)
    local success, service = pcall(function()
        return game:GetService(className)
    end)

    return success and service or nil
end

function ClientAdapterService:_CreateRigidService(structure, module)
    -- another version of strict checking, but it requires less setup
    local strictStructure = structureReference[structure.ClassName]
    local methods, variables = strictStructure.Methods, strictStructure.Variables
    local createProxy = settings():GetFFlag("EnableCASProxy")

    local service = setmetatable({}, InstanceRoot)
    service.__index = service

    function service.new()
        local self = setmetatable(InstanceRoot.new(), ClientAdapterService)
	    self.ClassName = structure.ClassName
        self.CASToolkit = CASToolkit.new()
        module:init(self.CASToolkit) -- initialize the variables
        if createProxy then
            self.CASProxy = Proxy.new(structure.ClassName)
        end

        for _, name in pairs(variables) do 
            assert(tableFind(module, name), "Variable " .. name .. ", doesn't exist in the class.")
            self[name] = module[name]
            if createProxy then -- TODO: fix this shitty code
                if getmetatable(module[name]) == RBXScriptSignal then
                    self.CASProxy:AddSignal(name)
                else
                    self.CASProxy:AddVariable(name, module[name])
                end
            end
        end
        for _, name in pairs(methods) do
            assert(tableFind(module, name), "Method " .. name .. ", doesn't exist in the class.")
            self[name] = function(self, ...)
                return module[name](module, self.CASToolkit, ...) -- the first arg is just self
            end
            if createProxy then
                self.CASProxy:AddReturningMethod(name, function(...)
                    return module[name](module, self.CASToolkit, ...)
                end)
            end
        end

	    return self
    end

    local serviceRoot = self:_GetRootService(structure.ClassName)
    if not serviceRoot then
        return service
    end

    return Inheritance.new(serviceRoot, service)
end

function ClientAdapterService:_CreateFlexableService(structure, module)
    -- creates a flexable service
    local methods, variables = structure.Methods, structure.Variables
    local strictStructure = structureReference[structure.ClassName]
    local strictChecking = structure.StrictChecking
    local createProxy = settings():GetFFlag("EnableCASProxy")

    local service = setmetatable({}, InstanceRoot)
    service.__index = service

    function service.new()
        local self = setmetatable(InstanceRoot.new(), ClientAdapterService)
	    self.ClassName = structure.ClassName
        self.CASToolkit = CASToolkit.new()
        module:init(self.CASToolkit) -- initialize the variables
        if createProxy then
            self.CASProxy = Proxy.new(structure.ClassName)
        end

        for name, value in pairs(variables) do 
            if strictChecking then
                assert(table.find(strictStructure.Variables, name), "Variable " .. name .. ", doesn't exist in the class.")
            end
            self[name] = module[value]
            if createProxy then -- TODO: fix this shitty code
                if getmetatable(module[name]) == RBXScriptSignal then
                    self.CASProxy:AddSignal(name)
                else
                    self.CASProxy:AddVariable(name, module[name])
                end
            end
        end
        for name, method in pairs(methods) do
            if strictChecking then
                assert(table.find(strictStructure.Methods, name), "Method " .. name .. ", doesn't exist in the class.")
            end
            self[name] = function(self, ...)
                return module[method](module, self.CASToolkit, ...) -- the first arg is just self
            end
            if createProxy then
                self.CASProxy:AddReturningMethod(name, function(...)
                    return module[method](module, self.CASToolkit, ...)
                end)
            end
        end

        if strictChecking and strictStructure then
            for _, name in pairs(strictStructure.Variables) do
                assert(self[name], "Variable " .. name .. ", doesn't exist in the service.")
            end
            for _, name in pairs(strictStructure.Methods) do
                assert(self[name], "Method " .. name .. ", doesn't exist in the service.")
            end
        end

	    return self
    end
    local serviceRoot = self:_GetRootService(structure.ClassName)
    if not serviceRoot then
        return service
    end

    return Inheritance.new(serviceRoot, service)
end

function ClientAdapterService:CreateService(name)
    -- loads the server-side module and creates a proper service out of it
    local service = CASList:FindFirstChild(name)
    if not service then
        warn("Service " .. name .. ", doesn't exist!")
        return
    end
    service = require(service)

    local structure, module = service.Structure, service.Service
    if structure.AllowFlexibleStructure then
        return self:_CreateFlexableService(structure, module)
    else
        return self:_CreateRigidService(structure, module)
    end
end

function ClientAdapterService:GetService(name)
    -- checks if the service already exists, if not it creates one (recommend way)
    local newService = self.serviceCache[name]
    if not newService then
        self.serviceCache[name] = self:CreateService(name)

        if self.serviceCache[name] then
            self.serviceCache[name] = self.serviceCache[name].new()
            newService = self.serviceCache[name]
        end
    end
    if not newService then
        return
    end

    return newService
end

return ClientAdapterService