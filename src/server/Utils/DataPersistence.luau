-- a wrapper of the player to allow data persistence
-- by mike
-- v2025.0517
-- NOTE: i give up, i am NOT making my own instance datastore thingy. community resources is my goat.

local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

local RBXSerialize = require("./RBXSerialize")
local Inheritance = require("../../../ReplicatedStorage/AuroraCore/Utils/Inheritance")

local SerialSetup = false
local CurrentPlayers = {}

local SafeDataStore = {} -- util to safely use datastores
SafeDataStore.__index = SafeDataStore

function SafeDataStore.new(name)
	local self = setmetatable({}, SafeDataStore)
	self.MainDataStore = DataStoreService:GetGlobalDataStore(name)
	
	return self
end

function SafeDataStore:SetAsync(name, value)
	local success, message = pcall(function()
		self.MainDataStore:SetAsync(name, value)
	end)

	assert(success, message)
end

function SafeDataStore:GetAsync(name, value)
	local success, result = pcall(function()
		return self.MainDataStore:GetAsync(name, value)
	end)

	assert(success, result)
	return result
end

local DataPersistence = {}
DataPersistence.__index = DataPersistence

function DataPersistence.new(player)
	local self = setmetatable({}, DataPersistence)
	self._dataStore = SafeDataStore.new(if game:GetService("RunService"):IsStudio() then "DataTestingFreshSlate" else "DataPersistence")
	self._playerKey = tostring(player.UserId)
	
	self.DataReady = false
	self.Value = player
	
	local _playerData = self._dataStore:GetAsync(self._playerKey)
	if not _playerData then
		self._dataStore:SetAsync(self._playerKey, HttpService:JSONEncode({}))
		_playerData = HttpService:JSONEncode({})
	end
	if not SerialSetup then
		RBXSerialize.BuildAPI()
		SerialSetup = true
	end
	
	self._playerData = _playerData
	self._playerData = HttpService:JSONDecode(self._playerData)
	self.DataReady = true
	
	return self
end

function DataPersistence:LoadInstance(name)
	local key = self._playerData[name]
	assert(key, "Cannot find " .. name .. " as instance. Returning nil.")
	
	return RBXSerialize.Decode(key)
end

function DataPersistence:SaveInstance(name, instance)
	assert(instance, "Instance must be included!")
	
	self._playerData[name] = RBXSerialize.Encode(instance)
	self._dataStore:SetAsync(self._playerKey, HttpService:JSONEncode(self._playerData))
end

function DataPersistence:WaitForDataReady() 
	repeat
		task.wait()
	until self.DataReady == true
end

return function(player) -- big hack over here
	local givenPlayer = CurrentPlayers[player.UserId]
	if not givenPlayer then
		CurrentPlayers[player.UserId] = Inheritance.new(player, DataPersistence)
	end
	return CurrentPlayers[player.UserId]
end