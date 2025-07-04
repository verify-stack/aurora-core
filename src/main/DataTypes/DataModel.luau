-- DataModel instance aka game
-- by mike
-- v2025.0704

local RunService = game:GetService("RunService")

local InstanceRoot = require("./Instance")
local RBXScriptSignal = require("./RBXScriptSignal")
local Inheritance = require("../Utils/Inheritance")
local Proxy = require("../Utils/Proxy")
local settings = require("../Settings")
local EnvConfig = require("../EnvConfig")

local Services = script.Parent.Parent:WaitForChild("Services")
local structureReference = {
    ["BadgeService"] = {
        Methods = {
            -- the only apis we would really use
            -- there are more methods that RCCService used
            "UserHasBadge",
            "IsLegal",
            "IsDisabled",
            "AwardBadge"
        },

        Variables = {
            "BadgeAwarded"
        }
    },
	["HttpService"] = {
        Methods = {
            "GenerateGUID",
            "GetAsync",
            "JSONDecode",
			"JSONEncode",
			"PostAsync",
			"UrlEncode"
        },

        Variables = {
            "HttpEnabled"
        }
    },
	["HttpRbxApiService"] = {
        Methods = {
            "GetAsync", -- we're not adding functions from 2018+
            "PostAsync"
        },

		Variables = {}
    },
	["MarketplaceService"] = {
		-- i'm not adding 2016-2017 functions yet.
        Methods = {
            "GetProductInfo",
            "PlayerOwnsAsset",
            "PromptPurchase",
			"SignalPromptPurchaseFinished",
			"PromptProductPurchase",
			"SignalClientPurchaseSuccess",
			"SignalPromptProductPurchaseFinished",
			"SignalServerLuaDialogClosed",
			"ProcessReceipt",
			"PromptThirdPartyPurchase",
			"PromptNativePurchase",
			"GetDeveloperProductsAsync"
        },

        Variables = {
            "PromptPurchaseFinished",
			"PromptPurchaseRequested",
			"ClientPurchaseSuccess",
			"PromptProductPurchaseFinished",
			"PromptProductPurchaseRequested",
			"ServerPurchaseVerification",
			"ClientLuaDialogRequested",
			"ThirdPartyPurchaseFinished",
			"NativePurchaseFinished"
        }
    }
}

local DataModel = setmetatable({}, InstanceRoot)
DataModel.__index = DataModel

function DataModel.new()
	local self = setmetatable(InstanceRoot.new(game), DataModel)
	self.MESSAGE_VAILDSERVICE = "'%s' is not a valid Service name"
	self.FLAG_USEGETSERVICE = settings():GetFFlag("UseClassNameGetService")
	self.FLAG_DELAYLOADING = settings():GetFFlag("UseDelayedLoading")
	self.SERVICES = {}
	self.CASServicesList = {
		"BadgeService"
	}
	for _, module in ipairs(Services:GetChildren()) do
		self.SERVICES[module.Name] = require(module).new()
		self[module.Name] = self.SERVICES[module.Name]
	end
	if settings():GetFFlag("AllowCASConnectionsAndDatabaseConnections") and settings():GetFFlag("EnableCASProxy") and RunService:IsClient() then -- CAS support baked into this!
		repeat
			task.wait()
		until script.Parent.Parent.ProxyEvents:GetAttribute("CASInit") == true -- shitty code, fix this later
		for _, serviceName in pairs(self.CASServicesList) do
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
		end
	end
	
	if self.FLAG_DELAYLOADING then
		self.Loaded = RBXScriptSignal.new()
		
		task.spawn(function()
			if game:IsLoaded() then
				task.wait(5)
				self.Loaded:Fire()
			end
		end)
	else
		self.FinishedScript = RBXScriptSignal.new()
	end
	
	return self
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