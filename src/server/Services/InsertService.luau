-- insert service replacement for old scripts that use sets
-- by mike
-- v2025.0517

local InsertServiceRoot = game:GetService("InsertService")
local HttpService = game:GetService("HttpService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AuroraCore = ServerStorage:WaitForChild("AuroraCore")
local Assets = AuroraCore:WaitForChild("Assets")

local InstanceRoot = require("../../../ReplicatedStorage/AuroraCore/DataTypes/Instance")
local Inheritance = require("../../../ReplicatedStorage/AuroraCore/Utils/Inheritance")
local ProxyServer = require("../Utils/ProxyServer")
local xml2lua = require("../Utils/xml2lua")

local InsertService = setmetatable({}, InstanceRoot)
InsertService.__index = InsertService

function InsertService.new()
	local self = setmetatable(InstanceRoot.new(InsertServiceRoot), InsertService)
	self.ClassName = "InsertService"
	self.Name = "InsertService"
	self.Proxy = ProxyServer.new(self.Name)
	
	-- create proxy elements
	self.Proxy:AddReturningMethod("GetUserCategories", function(userId)
		return self:GetUserCategories(userId)
	end)
	self.Proxy:AddReturningMethod("GetCollection", function(id)
		return self:GetCollection(id)
	end)
	self.Proxy:AddReturningMethod("LoadAsset", function(assetId)
		local asset = self:LoadAsset(assetId)
		asset.Parent = ReplicatedStorage.AuroraCore.SharedInstances
		return asset
	end)
	self.Proxy:AddReturningMethod("LoadAssetVersion", function(assetVersionId)
		local asset = self:LoadAssetVersion(assetVersionId)
		asset.Parent = ReplicatedStorage.AuroraCore.SharedInstances
		return asset
	end)
	self.Proxy:AddReturningMethod("Insert", function(assetId)
		local asset = self:LoadAsset(assetId)
		asset.Parent = ReplicatedStorage.AuroraCore.SharedInstances
		return asset
	end)
	self.Proxy:AddSingleWayMethod("ApproveAssetId", function(assetId)
		self:ApproveAssetId(assetId)
	end)
	
	return self
end

-- returns a list of collections
function InsertService:GetUserCategories(userId)
	local tree = require("../Utils/xml2lua/tree").new()
	local rawXML = HttpService:GetAsync("https://sets.pizzaboxer.xyz/Game/Tools/InsertAsset.ashx?nsets=100&type=user&userid=" .. tostring(userId))
	local halfTab = xml2lua.parser(tree)
	local result = {}
	halfTab:parse(rawXML, false)
	
	-- what a mess! not like xml parsers suck
	for _, rootObject in tree.root.List do
		for index, tabObject in rootObject do
			local resultObject = {}
			if #tabObject > 1 then
				for _, parent in tabObject do
					for _, object in parent.Table.Entry do
						resultObject[object.Key] = object.Value
					end
				end
			else
				for _, object in tabObject.Table.Entry do
					resultObject[object.Key] = object.Value
				end
			end
			
			table.insert(result, resultObject)
		end
	end
	
	return result
end

function InsertService:GetCollection(setId)
	local tree = require("../Utils/xml2lua/tree").new()
	local rawXML = HttpService:GetAsync("https://sets.pizzaboxer.xyz/Game/Tools/InsertAsset.ashx?sid=" .. tostring(setId))
	local halfTab = xml2lua.parser(tree)
	local result = {}
	halfTab:parse(rawXML, false)

	for _, rootObject in tree.root.List do
		for index, tabObject in rootObject do
			local resultObject = {}
			if #tabObject > 1 then
				for _, parent in tabObject do
					for _, object in parent.Table.Entry do
						resultObject[object.Key] = object.Value
					end
				end
			else
				for _, object in tabObject.Table.Entry do
					resultObject[object.Key] = object.Value
				end
			end

			table.insert(result, resultObject)
		end
	end
	
	return result
end

function InsertService:ApproveAssetId(assetId)
	--warn("Approving assets are no longer supported.")
	--warn("The function of this will not be added to AuroraCore.")
	--print("assetId:", tostring(assetId))
end

function InsertService:LoadAsset(assetId)
	local localAsset = Assets:FindFirstChild(tostring(assetId))
	if not localAsset then
		return InsertServiceRoot:LoadAsset(assetId)
	end
	
	localAsset = localAsset:Clone()
	localAsset.Name = "Model"
	return localAsset
end

function InsertService:LoadAssetVersion(assetVersionId)
	return self:LoadAsset(assetVersionId)
end

function InsertService:Insert(assetVersionId)
	return self:LoadAsset(assetVersionId)
end

return Inheritance.new(InsertServiceRoot, InsertService)