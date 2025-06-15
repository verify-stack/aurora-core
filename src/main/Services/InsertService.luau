-- insert service replacement for old scripts that use sets
-- by mike
-- v2025.0516

local RunService = game:GetService("RunService")
local Proxy = require("../Utils/Proxy")

if RunService:IsClient() then
	local InsertServiceProxy = Proxy.new("InsertService")
	InsertServiceProxy:AddReturningMethod("GetUserCategories")
	InsertServiceProxy:AddReturningMethod("GetCollection")
	InsertServiceProxy:AddReturningMethod("LoadAsset")
	InsertServiceProxy:AddReturningMethod("LoadAssetVersion")
	InsertServiceProxy:AddReturningMethod("Insert")
	InsertServiceProxy:AddSingleWayMethod("ApproveAssetId")
	
	return {
		new = function()
			return InsertServiceProxy
		end,
	}
else
	return require("../../../ServerStorage/AuroraCore/Services/InsertService")
end