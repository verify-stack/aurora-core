-- handles chat services
-- by mike
-- v2025.0618

local RunService = game:GetService("RunService")

if RunService:IsServer() then
	return require("../../../ServerStorage/AuroraCore/Services/RBXChatService")
else
	return {
		new = function()
			return {
				WARNING = "server side use ONLY"
			}
		end
	}
end