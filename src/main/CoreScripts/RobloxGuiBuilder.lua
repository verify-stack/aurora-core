-- builds RobloxGui, DO NOT TOUCH THIS SCRIPT
-- by mike
-- v2025.0607

_G:Inject(getfenv())

--// Services \\
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Variables \\
local CoreGuiVersions = { -- view full version in EnvConfig
	{7, 4},
	{7, 3},
	{7, 2},
    {7, 1}
}
local AuroraCore = ReplicatedStorage:WaitForChild("AuroraCore")
local CoreScripts = AuroraCore.CoreScripts

--// RobloxGuiBuilds \\
local RobloxGuiBuilds = {}
RobloxGuiBuilds.MatchVersion = function(version)
	-- we have to find the correct table that they match
	-- because lua makes each table have a different hash

	for _, ver in ipairs(CoreGuiVersions) do
		local first, last = ver[1], ver[2]
		local givenf, givenl = version[1], version[2]

		if first == givenf and last == givenl then
			return ver
		end
	end
	error("Cannot match version " .. tostring(version[1]), tostring(version[2]))
end

function RobloxGuiBuilds:AddGuiBuild(version, func)
	version = RobloxGuiBuilds.MatchVersion(version)
	
	RobloxGuiBuilds[version] = function()
		func(CoreGui.Value)
	end
end

function RobloxGuiBuilds:LoadGuiBuild(version)
	version = RobloxGuiBuilds.MatchVersion(version)
	
	print("Loading RobloxGui build:", tostring(version[1]), tostring(version[2]))
	RobloxGuiBuilds[version]()
end

function RobloxGuiBuilds:InjectModuleBuild(robloxgui) -- quick way of inserting modules
	local Modules = CoreScripts:FindFirstChild("Modules")
	if not Modules then -- most likely, we're in the wrong version
		return
	end
	
	Modules:Clone().Parent = robloxgui
end

--// RobloxGui Versions \\
RobloxGuiBuilds:AddGuiBuild({7, 4}, function(coregui)
	local RobloxGui = Instance.new("ScreenGui")
	RobloxGui.Name = "RobloxGui"
	RobloxGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	RobloxGui.ResetOnSpawn = false
	RobloxGui.DisplayOrder = 9999
	RobloxGui.IgnoreGuiInset = true
	RobloxGui.Parent = coregui
	
	local ControlFrame = Instance.new("Frame")
	ControlFrame.Name = "ControlFrame"
	ControlFrame.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	ControlFrame.BackgroundTransparency = 1
	ControlFrame.Size = UDim2.new(1, 0, 1, 0)
	ControlFrame.Parent = RobloxGui

	local TopLeftControl = Instance.new("Frame")
	TopLeftControl.Name = "TopLeftControl"
	TopLeftControl.BackgroundTransparency = 1
	TopLeftControl.Size = UDim2.new(0.05, 0, 0.05, 0)
	TopLeftControl.Parent = ControlFrame
	
	local BottomLeftControl = Instance.new("Frame")
	BottomLeftControl.Name = "BottomLeftControl"
	BottomLeftControl.BackgroundTransparency = 1
	BottomLeftControl.Position = UDim2.new(0, 0, 1, -46)
	BottomLeftControl.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	BottomLeftControl.Size = UDim2.new(0, 130, 0, 46)
	BottomLeftControl.Parent = ControlFrame

	local BottomRightControl = Instance.new("Frame")
	BottomRightControl.Name = "BottomRightControl"
	BottomRightControl.BackgroundTransparency = 1
	BottomRightControl.Position = UDim2.new(1, -180, 1, -41)
	BottomRightControl.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	BottomRightControl.Size = UDim2.new(0, 180, 0, 41)
	BottomRightControl.Parent = ControlFrame
	
	local mouseLockLabel = Instance.new("ImageButton")
	mouseLockLabel.Name = "MouseLockLabel"
	mouseLockLabel.Image = "rbxasset://textures/ui/mouseLock_off.png"
	mouseLockLabel.BackgroundTransparency = 1
	mouseLockLabel.Position = UDim2.new(0, 2, 0, -65)
	mouseLockLabel.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	mouseLockLabel.Size = UDim2.new(0, 62, 0, 62)
	mouseLockLabel.Parent = BottomLeftControl
	
	RobloxGuiBuilds:InjectModuleBuild(RobloxGui)
end)

--// Connections \\
RobloxGuiBuilds:LoadGuiBuild(CoreGui.VersionFull)