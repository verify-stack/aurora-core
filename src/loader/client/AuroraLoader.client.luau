-- loads AuroraCore
-- by mike
-- v2025.0711

-- preheaders for stuff
wait()
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
_G:ExportJSON()
_G.CASEnabled = settings():GetFFlag("AllowCASConnectionsAndDatabaseConnections")
_G.InsertServiceEnabled = settings():GetFFlag("EnableInsertServiceSupport")

-- loads the starterscript and stuff
local Players = game:GetService("Players")
local ScriptContext = game:GetService("ScriptContext")
local Chat = game:GetService("Chat")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local safeLocalAdd = function(name, parent)
	local success, message = pcall(function()  
		ScriptContext:AddCoreScriptLocal(name, parent)
	end)
	task.spawn(assert, success, message) -- while it'll error, it won't stop the flow
end
local onPlayerChatted = function(_, player, message)
	Chat:Chat(player.Character, message, Enum.ChatColor.White)
end

safeLocalAdd("RobloxGuiBuilder", PlayerGui)
PlayerGui:WaitForChild("RobloxGui", 5)

safeLocalAdd("LoadingScript", PlayerGui.RobloxGui)
safeLocalAdd("StarterScript", PlayerGui.RobloxGui)
Players.PlayerChatted:Connect(onPlayerChatted)

print("Loaded aurora-core " .. _VERSION)
print("Succesfully added required corescripts.")