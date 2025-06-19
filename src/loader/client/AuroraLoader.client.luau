-- loads AuroraCore, TODO: fix this code
-- by mike
-- v2025.0615

wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local AuroraCore = ReplicatedStorage:WaitForChild("AuroraCore")
local EnvInject = require(AuroraCore.EnvInject)

EnvInject(getfenv())
function _G:Inject(fenv)
	EnvInject(fenv)
end

if settings():GetFFlag("UseDelayedLoading") then
	Game.Loaded:Connect(function()
		Game:GetService("ScriptContext"):AddCoreScriptLocal("StarterScript", Players.LocalPlayer.PlayerGui)
	end)
else
	Game.FinishedScript:Connect(function()
		Game:GetService("ScriptContext"):AddCoreScriptLocal("StarterScript", Players.LocalPlayer.PlayerGui)
	end)
end
Game:GetService("ScriptContext"):AddCoreScriptLocal("RobloxGuiBuilder", Players.LocalPlayer.PlayerGui) -- might move this
Game:GetService("ScriptContext"):AddCoreScriptLocal("LoadingScript", Players.LocalPlayer.PlayerGui)


print("Loaded AuroraCore " .. _VERSION)