-- settings
-- by mike
-- v2025.0511

local sharedInstance = require("./DataTypes/GlobalSettings").new()

return function()
	return sharedInstance
end 