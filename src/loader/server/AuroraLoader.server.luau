-- loads AuroraCore
-- by mike
-- v2025.0716

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AuroraCore = ReplicatedStorage.AuroraCore

local EnvConfig = require(AuroraCore.EnvConfig)
local EnvInject = require(AuroraCore.EnvInject)
local ExportJSONFlags = require(AuroraCore.Utils.ExportJSONFlags)

function _G:Inject(fenv)
	EnvInject(fenv)
end

function _G:ExportJSON()
    ExportJSONFlags(EnvConfig.FFlags, EnvConfig.ExportJSON)
end

-- do this after so we can use settings()
_G:Inject(getfenv())
_G.CASEnabled = settings():GetFFlag("AllowCASConnectionsAndDatabaseConnections")
_G.InsertServiceEnabled = settings():GetFFlag("EnableInsertServiceSupport")

-- main script
_G:ExportJSON()

if _G.InsertServiceEnabled and _G.CASEnabled then
    local InsertService = game:GetService("InsertService")
    InsertService:ApproveAssetId(1) -- filler function
end
if _G.CASEnabled then
    -- only works in CAS now
    local RBXChatService = game:GetService("RBXChatService")
    RBXChatService:UpdateTextChannel()
end