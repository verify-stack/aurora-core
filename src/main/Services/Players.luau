-- players service, TODO: fix this coding
-- by mike
-- v2025.0614

local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local PlayersRoot = game:GetService("Players")
local InstanceRoot = require("../DataTypes/Instance")
local RBXScriptSignal = require("../DataTypes/RBXScriptSignal")
local Inheritance = require("../Utils/Inheritance")

local PlayerNamesCache = {}
local GetPlayerByUserId = function(id)
	if not PlayerNamesCache[id] then
		PlayerNamesCache[id] = PlayersRoot:GetPlayerByUserId(id)
	end
	
	return PlayerNamesCache[id]
end

local Players = setmetatable({}, InstanceRoot)
Players.__index = Players

function Players.new()
	local self = setmetatable(InstanceRoot.new(), Players)
	self.ClassName = "Players"
	
	self.FriendRequestEvent = RBXScriptSignal.new()
	self.PlayerChatted = RBXScriptSignal.new()
	
	if RunService:IsClient() then
		TextChatService.MessageReceived:Connect(function(textChatMessage)
			if not textChatMessage.TextSource then
				return
			end
			local chatType = Enum.PlayerChatType.All
			if textChatMessage.TextChannel.Name:sub(1, 7) == "RBXTeam" then
				chatType = Enum.PlayerChatType.Team
			end
			
			self.PlayerChatted:Fire(
				chatType, 
				GetPlayerByUserId(textChatMessage.TextSource.UserId),
				textChatMessage.Text
			)
		end)
	end
	
	return self
end

function Players:GetUseCoreScriptHealthBar()
	return true
end

function Players:Chat(cText)
	local success, message = pcall(function()
		local RBXGeneral = TextChatService.TextChannels.RBXGeneral
		RBXGeneral:SendAsync(cText)
	end)
	
	assert(success, message)
end

function Players:TeamChat(cText)
	local success, message = pcall(function()
		local currentTeam = PlayersRoot.LocalPlayer.TeamColor.Name
		local RBXTeam = TextChatService.TextChannels["RBXTeam" .. currentTeam]
		RBXTeam:SendAsync(cText)
	end)
	
	assert(success, message)
end

return Inheritance.new(PlayersRoot, Players)