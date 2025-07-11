-- config for AuroraCore
-- by mike
-- v2025.0711

local EnvConfig = {}

-- AuroraCore generic strings
-- these aren't really important
EnvConfig.AuroraVersion = "Luau (AuroraCore v2025.0711 ROJO) (LUAU FENV)"

-- AuroraCore settings
-- FFlags are pretty much settings for how the client should work
-- note these are 2015E fflags and AuroraCore flags.
EnvConfig.FFlags = {
	-- aurora core related things
	UseClassNameGetService = false, -- breaks get service
	EnableInsertServiceSupport = true,
	DisableRobloxCoreGui = true,
	UseDelayedLoading = false, -- no longer works, don't turn the flag on
	EnableCASProxy = true, -- enables clients being able to access CAS services
	AllowCASConnectionsAndDatabaseConnections = true,
	ExtensionModules = false, -- read more at /docs/Info/Extensions.md

	-- real roblox fflags
	NewPlayerListScript = true,
	NewMenuSettingsScript = false,
	ConsoleCodeExecutionEnabled = true,
	NewNotificationsScript = true,
	LuaFollowers = true,
	MaxFriendsCount = true,
	UseLuaCameraAndControl = true,
	NewTouchControlScript = false
}
if EnvConfig.FFlags.NewPlayerListScript then
	EnvConfig.AdminList = {
		["45473615"] = "http://www.roblox.com/asset/?id=105897927" -- newer playerlists use ids for the list
	}
else
	EnvConfig.AdminList = {
		["moneyxmike"] = "http://www.roblox.com/asset/?id=105897927" -- remember to make the names all lowercase
	}
end
EnvConfig.ExportJSON = [[{"FFlagReconstructAssetUrl": "True"}]] -- place your fflag json file here
EnvConfig.ClientPeriod = "2015E" -- change this to your client period

-- CoreGui related things
-- don't really touch this only you know what you're doing
EnvConfig.CoreGuiVerDict = {
	["2015E"] = {7, 4},
	["2014L"] = {7, 4},
	["2014M"] = {7, 3},
	["2014E"] = {7, 3},
	["2013L"] = {7, 3},
	["2013M"] = {7, 3},
	["2013E"] = {7, 3},
	["2012L"] = {7, 2},
	["2012M"] = {7, 1},
	["2012E"] = {3, 2},
	["2011L"] = {3, 2},
	["2011M"] = {3, 2},
	["2011E"] = {2, 1},
	["2010L"] = {0, 0} -- no core gui numbers in 2010L
}

return EnvConfig