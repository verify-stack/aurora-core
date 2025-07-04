-- handle chat services
-- WILL BE REPLACED WITH CAS
-- by mike
-- v2025.0618

local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

local InstanceRoot = require("../../../ReplicatedStorage/AuroraCore/DataTypes/Instance")

local RBXChatService = setmetatable({}, InstanceRoot)
RBXChatService.__index = RBXChatService

function RBXChatService.new()
	local self = setmetatable(InstanceRoot.new(), RBXChatService)
	self.ClassName = "RBXChatService"

	self.GeneralChannel = nil
	self.OnPlayerAdded = function(player)
		RBXChatService:UpdateTextChannel()
		self.GeneralChannel:AddUserAsync(player.UserId)
	end

	-- warn("RBXChatService is a temporary service until CAS releases.")
	-- warn("This service will NOT be updated when CAS releases.")
	for _, player in Players:GetPlayers() do
        self.OnPlayerAdded(player)
    end
	Players.PlayerAdded:Connect(self.OnPlayerAdded)
	return self
end

function RBXChatService:UpdateTextChannel()
	self.GeneralChannel = TextChatService:FindFirstChild("TextChannels")
	if not self.GeneralChannel then
		--warn("aurora-core failed to find text channels.")
		return
	end
	assert(self.GeneralChannel:FindFirstChild("RBXGeneral"), "aurora-core failed to find text channel RBXGeneral. Please enable default generation of channels.")
	self.GeneralChannel = self.GeneralChannel:FindFirstChild("RBXGeneral")
end

return RBXChatService