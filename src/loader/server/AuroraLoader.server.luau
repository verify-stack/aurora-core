-- loads AuroraCore
-- by mike
-- v2025.0618

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AuroraCore = ReplicatedStorage.AuroraCore
local Game = require(AuroraCore.Game)
local settings = require(AuroraCore.Settings)

if settings():GetFFlag("EnableInsertServiceSupport") then
    local InsertService = Game:GetService("InsertService")
    InsertService:ApproveAssetId(1) -- filler function
end

-- this is here for anyone who wants to package this
local RBXChatService = Game:GetService("RBXChatService")
RBXChatService:UpdateTextChannel()