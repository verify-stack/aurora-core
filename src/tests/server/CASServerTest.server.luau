-- tests CAS functions and variables
-- by mike
-- v2025.0707

local Game = require(game:GetService("ReplicatedStorage").AuroraCore.Game)

local BadgeService = Game:GetService("BadgeService")
print(BadgeService:UserHasBadge(true)) -- on the server it should print out some junk, on the client it should return true