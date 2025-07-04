-- builds RobloxGui
-- by mike
-- v2025.0622

_G:Inject(getfenv())

--// Services \\
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Variables \\
local CoreGuiVersions = { -- view full version in EnvConfig
	{7, 4},
	{7, 3},
	{7, 2},
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

function RobloxGuiBuilds:ControlMouseLock(mouseLockLabel, mouseLockOn, mouseLockOnOvr, mouseLockOff, mouseLockOffOvr)
	-- so i'm actually not sure if we should handle this in the camerascript
	-- but oh well, we have to think of the people who are using this!!!
	-- TODO: found bug where you reset, it just doesn't work.

	local mouseLockEnabled, hover = false, false
	local PlayerScripts = Players.LocalPlayer.PlayerScripts
	if not PlayerScripts:FindFirstChild("CameraScript") then
		-- warn("The legacy camera script DOES NOT EXIST!")
		-- warn("The MouseLockLabel function will not be properly loaded.")
		return
	end
	
	local ShiftLockController = require(PlayerScripts:WaitForChild("CameraScript").ShiftLockController)
	local updateMouselock = function()
		mouseLockEnabled = not mouseLockEnabled
		if mouseLockEnabled then
			mouseLockLabel.Image = mouseLockOn
			if hover then
				mouseLockLabel.Image = mouseLockOnOvr
			end
		else
			mouseLockLabel.Image = mouseLockOff
			if hover then
				mouseLockLabel.Image = mouseLockOffOvr
			end
		end
	end
	
	mouseLockLabel.MouseEnter:Connect(function()
		hover = true
		if mouseLockEnabled then
			mouseLockLabel.Image = mouseLockOnOvr
		else
			mouseLockLabel.Image = mouseLockOffOvr
		end
	end)
	mouseLockLabel.MouseLeave:Connect(function()
		hover = false
		if mouseLockEnabled then
			mouseLockLabel.Image = mouseLockOn
		else
			mouseLockLabel.Image = mouseLockOff
		end
	end)
	mouseLockLabel.MouseButton1Click:Connect(function()
		ShiftLockController:toggleShiftlock()
	end)
	ShiftLockController.OnShiftLockToggled.Event:Connect(updateMouselock)
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
	BottomLeftControl.Size = UDim2.new(0, 130, 0, 46)
	BottomLeftControl.Parent = ControlFrame

	local BottomRightControl = Instance.new("Frame")
	BottomRightControl.Name = "BottomRightControl"
	BottomRightControl.BackgroundTransparency = 1
	BottomRightControl.Position = UDim2.new(1, -180, 1, -41)
	BottomRightControl.Size = UDim2.new(0, 180, 0, 41)
	BottomRightControl.Parent = ControlFrame
	
	local mouseLockOn, mouseLockOnOvr = "rbxassetid://73948379887913", "rbxassetid://77193127237926"
	local mouseLockOff, mouseLockOffOvr = "rbxassetid://85469622625688", "rbxassetid://121131447552022"
	local mouseLockLabel = Instance.new("ImageButton")
	mouseLockLabel.Name = "MouseLockLabel"
	mouseLockLabel.Image = mouseLockOff
	mouseLockLabel.BackgroundTransparency = 1
	mouseLockLabel.Position = UDim2.new(0, 2, 0, -65)
	mouseLockLabel.Size = UDim2.new(0, 62, 0, 62)
	mouseLockLabel.Parent = BottomLeftControl

	RobloxGuiBuilds:ControlMouseLock(mouseLockLabel, mouseLockOn, mouseLockOnOvr, mouseLockOff, mouseLockOffOvr)
	RobloxGuiBuilds:InjectModuleBuild(RobloxGui)
end)
RobloxGuiBuilds:AddGuiBuild({7, 3}, function(coregui)
	local RobloxGui = Instance.new("ScreenGui")
	RobloxGui.Name = "RobloxGui"
	RobloxGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	RobloxGui.ResetOnSpawn = false
	RobloxGui.DisplayOrder = 9999
	RobloxGui.IgnoreGuiInset = true
	RobloxGui.Parent = coregui
	
	local ControlFrame = Instance.new("Frame")
	ControlFrame.Name = "ControlFrame"
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
	BottomLeftControl.Position = UDim2.new(0, 0, 1, -45)
	BottomLeftControl.Size = UDim2.new(0, 212, 0, 45)
	BottomLeftControl.Parent = ControlFrame

	local BottomRightControl = Instance.new("Frame")
	BottomRightControl.Name = "BottomRightControl"
	BottomRightControl.BackgroundTransparency = 1
	BottomRightControl.Position = UDim2.new(1, -129, 1, -45)
	BottomRightControl.Size = UDim2.new(0, 129, 0, 45)
	BottomRightControl.Parent = ControlFrame
	
	local mouseLockOn, mouseLockOnOvr = "rbxassetid://2782754571", "rbxassetid://2782754579"
	local mouseLockOff, mouseLockOffOvr = "rbxassetid://2787893818", "rbxassetid://2782754560"
	local mouseLockLabel = Instance.new("ImageButton")
	mouseLockLabel.Name = "MouseLockLabel"
	mouseLockLabel.Image = mouseLockOff
	mouseLockLabel.BackgroundTransparency = 1
	mouseLockLabel.Position = UDim2.new(0, 2, 0, -33)
	mouseLockLabel.Size = UDim2.new(0, 149, 0, 30)
	mouseLockLabel.Parent = BottomLeftControl
	
	RobloxGuiBuilds:ControlMouseLock(mouseLockLabel, mouseLockOn, mouseLockOnOvr, mouseLockOff, mouseLockOffOvr)
end)

--// Connections \\
RobloxGuiBuilds:LoadGuiBuild(CoreGui.VersionFull)