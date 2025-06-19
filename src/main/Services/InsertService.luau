-- insert service replacement for old scripts that use sets
-- by mike
-- v2025.0618

local RunService = game:GetService("RunService")
local Proxy = require("../Utils/Proxy")
local settings = require("../Settings")

if not settings():GetFFlag("EnableInsertServiceSupport") then
	warn("The FFlag \"EnableInsertServiceSupport\" is disabled. Enable it to use InsertService!")
	return {
		new = function()
			return {
				WARNING = "The FFlag \"EnableInsertServiceSupport\" is disabled. Enable it to use InsertService!"
			}
		end
	}
end
if not settings():GetFFlag("AllowCASConnectionsAndDatabaseConnections") then
	warn("The FFlag \"AllowCASConnectionsAndDatabaseConnections\" is disabled. Enable it to use InsertService!")
	return {
		new = function()
			return {
				WARNING = "The FFlag \"AllowCASConnectionsAndDatabaseConnections\" is disabled. Enable it to use InsertService!"
			}
		end
	}
end

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