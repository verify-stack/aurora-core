-- enum wrapper
-- by mike
-- v2025.0607

local UploadEnum = require("../UploadEnum")
local RealEnum = Enum
local Enum = {}
setmetatable(Enum, {
	__index = function(_, key)
		if key == "UploadSetting" then
			return UploadEnum
		end
		if RealEnum[key] then
			return RealEnum[key]
		end
		error("Enum: Unknown key: "..tostring(key), 2)
	end,

	__newindex = function(_, key, _)
		error(("%s is not a valid member of Enums"):format(key))
	end,
})

return Enum