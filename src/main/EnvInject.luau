-- injects the game datamodel into scripts
-- by mike
-- v2025.0711

local EnvConfig = require("./EnvConfig")
local Game = require("./Game")
local Enum = require("./DataTypes/Enum")
local LoadLibrary = script.Parent:WaitForChild("LoadLibrary")
local Settings, UserSettings = require("./Settings"), require("./UserSettings")
local LoadLibraryFunc = function(name)
	return require(LoadLibrary:FindFirstChild(name))
end

return function(fenv)
	fenv.Game, fenv.game = Game, Game
	fenv.LoadLibrary = LoadLibraryFunc
	fenv.settings, fenv.UserSettings = Settings, UserSettings
	fenv.Enum = Enum
	fenv._VERSION = EnvConfig.AuroraVersion --"Luau (AuroraCore v2025.0503 RBXL) (LUAU FENV)"
end