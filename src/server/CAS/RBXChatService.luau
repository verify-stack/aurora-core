-- handle chat services (e.g textchatservice and dialog)
-- by mike
-- v2025.0715

local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

local RBXChatServiceStructure = {
    ClassName = "RBXChatService",
    AllowFlexibleStructure = false,
    StrictChecking = false,

    Methods = {},
    Variables = {}
}
local RBXChatService = {}

function RBXChatService:init(CAS)
    -- init stuff
    self.GeneralChannel = false
    self.DialogChoiceChosen = CAS:createsignal()
    local OnPlayerAdded = function(player)
		self:UpdateTextChannel(CAS)
		self.GeneralChannel:AddUserAsync(player.UserId)
	end

    for _, player in Players:GetPlayers() do
        OnPlayerAdded(player)
    end
	Players.PlayerAdded:Connect(OnPlayerAdded)
end

function RBXChatService:UpdateTextChannel(CAS)
	self.GeneralChannel = TextChatService:FindFirstChild("TextChannels")
	if not self.GeneralChannel then
		--warn("aurora-core failed to find text channels.")
        CAS.logger:logwarn("aurora-core failed to find text channels.")
		return
	end
    if CAS.logger:logassert(self.GeneralChannel:FindFirstChild("RBXGeneral"), "aurora-core failed to find text channel RBXGeneral. Please enable default generation of channels.") then
        return
    end

	self.GeneralChannel = self.GeneralChannel:FindFirstChild("RBXGeneral")
end

function RBXChatService:SetDialogEnabled(CAS, dialog, enabled)
    -- if you want to enable/disable dialogs via attributes

    if not dialog then
        return
    end
    dialog:SetAttribute("IsUse", enabled)
end

function RBXChatService:SignalDialog(CAS, dialog, player, choice)
    -- TODO: make signal cross-server
    if not dialog then
        return
    end
    self.DialogChoiceChosen:Fire(dialog, choice)
end

return {
    Structure = RBXChatServiceStructure,
    Service = RBXChatService,
}