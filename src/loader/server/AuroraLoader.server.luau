-- loads AuroraCore
-- by mike
-- v2025.0711

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local AuroraCore = ReplicatedStorage.AuroraCore
local AuroraCoreServer = ServerStorage.AuroraCore
local Game = require(AuroraCore.Game)
local settings = require(AuroraCore.Settings)
local EnvConfig = require(AuroraCore.EnvConfig)
local ExportJSONFlags = require(AuroraCore.Utils.ExportJSONFlags)

AuroraCore.ProxyEvents:SetAttribute("CASInit", false)
ExportJSONFlags(EnvConfig.FFlags, EnvConfig.ExportJSON)
if settings():GetFFlag("EnableInsertServiceSupport") then
    local InsertService = Game:GetService("InsertService")
    InsertService:ApproveAssetId(1) -- filler function
end

-- this is here for anyone who wants to package this
local RBXChatService = Game:GetService("RBXChatService")
RBXChatService:UpdateTextChannel()

local ClientAdapterService = Game:GetService("ClientAdapterService") -- TODO: move this to datamodel
for _, module in pairs(AuroraCoreServer.CAS:GetChildren()) do
    ClientAdapterService:GetService(module.Name)
end
AuroraCore.ProxyEvents:SetAttribute("CASInit", true)