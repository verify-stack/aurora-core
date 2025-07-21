-- builds RobloxGui, TODO: move this to CoreGui and leave alone this script
-- by mike
-- v2025.0721

_G:Inject(getfenv())

--// Services \\
local GuiService = game:GetService("GuiService")
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
RobloxGuiBuilds.FindFirstName = function(tbl, name)
	-- https://devforum.roblox.com/t/how-to-deep-search-a-table/791825/2
	-- im lazy to code my own version of this function lol
	for vname, value in pairs(tbl) do
        if vname == name then
            return value
        end
    end
    return false
end
RobloxGuiBuilds.Images = {
	Main = {
		Modern = {
			MouseLockButton = {
				On = {
					Normal = "rbxassetid://73948379887913",
					Hover = "rbxassetid://77193127237926"
				},
				
				Off = {
					Normal = "rbxassetid://85469622625688",
					Hover = "rbxassetid://121131447552022"
				}
			}
		},
		Legacy1 = { -- 2012E-2013E
			Exit = {
				Normal = "rbxassetid://131692680831292",
				Down = "rbxassetid://78992542594217",
				Hover = "rbxassetid://78992542594217"
			},

			CameraTiltDown = {
				Normal = "rbxassetid://79028324223368",
				Down = "rbxassetid://96320292947752",
				Hover = "rbxassetid://96320292947752"
			},

			CameraTiltUp = {
				Normal = "rbxassetid://97929000536807",
				Down = "rbxassetid://109555162322407",
				Hover = "rbxassetid://109555162322407"
			},

			CameraZoomIn = {
				Normal = "rbxassetid://77485152035175",
				Down = "rbxassetid://128266390264230",
				Hover = "rbxassetid://128266390264230"
			},

			CameraZoomOut = {
				Normal = "rbxassetid://127570582519415",
				Down = "rbxassetid://137031530932932",
				Hover = "rbxassetid://137031530932932"
			},

			MouseLockButton = {
				On = {
					Normal = "rbxassetid://2782754571",
					Hover = "rbxassetid://2782754579"
				},
				
				Off = {
					Normal = "rbxassetid://2787893818",
					Hover = "rbxassetid://2782754560"
				}
			}
		},
		Legacy2 = { -- 2010L-2011L
			MouseLockButton = {
				On = {
					Normal = "rbxassetid://2782754571",
					Hover = "rbxassetid://2782754579"
				},
				
				Off = {
					Normal = "rbxassetid://2787893818",
					Hover = "rbxassetid://2782754560"
				}
			}
		}
	},

	BuildTools = {
		Normal = "rbxassetid://81124821052064",
		Divs = {
			Normal = "rbxassetid://123045928458388"
		},

		PhysicalTools = {
			GroupMove = {
				Normal = "rbxassetid://115550725578757",
				Down = "rbxassetid://89378674060944"
			},

			ScaleObject = {
				Normal = "rbxassetid://110885862046491",
				Down = "rbxassetid://86084255012087"
			},

			StampTool = {
				Normal = "rbxassetid://137997235733619",
				Down = "rbxassetid://95829599231280"
			}
		}
	}
}

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

function RobloxGuiBuilds:ControlMouseLock(mouseLockLabel, imageSet)
	-- completely changed it so the camera module HANDLES the mouselock
	-- we're no longer forced to handle this!!
	GuiService.MouseLockInfo = {
		MouseLockLabel = mouseLockLabel,
		MouseLockImages = imageSet
	}
end

function RobloxGuiBuilds:ConnectBasicImage(button, imageGroup)
	local normal, down = imageGroup.Normal, imageGroup.Down
	local normalStateEvent = function()
		button.Image = normal
	end
	local downStateEvent = function()
		button.Image = down
	end

	normalStateEvent()
	button.MouseButton1Down:Connect(downStateEvent)
	button.MouseButton1Up:Connect(normalStateEvent)
end

function RobloxGuiBuilds:ConnectImageAssets(button)
	local imageGroup = RobloxGuiBuilds.FindFirstName(RobloxGuiBuilds.Images.Main.Legacy1, button.Name)
	assert(imageGroup, "cannot find button: " .. button.Name)

	local normalStateEvent = function()
		button.Image = imageGroup.Normal
	end
	local hoverStateEvent = function()
		button.Image = imageGroup.Hover
	end
	local downStateEvent = function()
		button.Image = imageGroup.Down
	end

	normalStateEvent()
	button.MouseButton1Down:Connect(downStateEvent)
	button.MouseEnter:Connect(hoverStateEvent)
	button.MouseButton1Up:Connect(normalStateEvent)
	button.MouseLeave:Connect(normalStateEvent)
end

function RobloxGuiBuilds:CreateBuildToolsGUI()
	-- build tools across each version are virtually the same
	local BuildTools = Instance.new("ScreenGui")
	BuildTools.Name = "BuildTools"

	local Frame = Instance.new("ImageLabel")
	Frame.Name = "Frame"
	Frame.Image = self.Images.BuildTools.Normal
	Frame.BackgroundTransparency = 1
	Frame.Position = UDim2.new(-0.15, 0, 0.1, 0)
	Frame.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	Frame.Size = UDim2.new(0.15, 0, 0.57, 0)
	Frame.Parent = BuildTools

	local PhysicalTools = Instance.new("Frame")
	PhysicalTools.Name = "PhysicalTools"
	PhysicalTools.BackgroundTransparency = 1
	PhysicalTools.Position = UDim2.new(0, 0, 0.05, 0)
	PhysicalTools.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	PhysicalTools.Size = UDim2.new(1, 0, 0.25, 0)
	PhysicalTools.Parent = Frame

	local GroupMove = Instance.new("ImageButton")
	GroupMove.Name = "GroupMove"
	GroupMove.Size = UDim2.new(0.4, 0, 0.4, 0)
	GroupMove.Image = "rbxasset://textures/ui/GroupMoveButton.png"
	GroupMove.BackgroundTransparency = 1
	GroupMove.Position = UDim2.new(0.5, 0, 0.1, 0)
	GroupMove.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	GroupMove.AutoButtonColor = false
	GroupMove.Parent = PhysicalTools
	self:ConnectBasicImage(GroupMove, self.Images.BuildTools.PhysicalTools.GroupMove)

	local StampTool = Instance.new("ImageButton")
	StampTool.Name = "StampTool"
	StampTool.Size = UDim2.new(0.4, 0, 0.4, 0)
	StampTool.Image = "rbxasset://textures/ui/StampToolButton.png"
	StampTool.BackgroundTransparency = 1
	StampTool.Position = UDim2.new(0.05, 0, 0.1, 0)
	StampTool.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	StampTool.AutoButtonColor = false
	StampTool.Parent = PhysicalTools
	self:ConnectBasicImage(StampTool, self.Images.BuildTools.PhysicalTools.StampTool)

	local ScaleObject = Instance.new("ImageButton")
	ScaleObject.Name = "ScaleObject"
	ScaleObject.Size = UDim2.new(0.4, 0, 0.4, 0)
	ScaleObject.Image = "rbxasset://textures/ui/ScaleButton.png"
	ScaleObject.BackgroundTransparency = 1
	ScaleObject.Position = UDim2.new(0.05, 0, 0.54, 0)
	ScaleObject.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	ScaleObject.AutoButtonColor = false
	ScaleObject.Parent = PhysicalTools
	self:ConnectBasicImage(ScaleObject, self.Images.BuildTools.PhysicalTools.ScaleObject)

	local CloseButton = Instance.new("ImageButton")
	CloseButton.Name = "CloseButton"
	CloseButton.Size = UDim2.new(0.2, 0, 0.05, 0)
	CloseButton.Image = "rbxasset://textures/ui/CloseButton.png"
	CloseButton.BackgroundTransparency = 1
	CloseButton.Position = UDim2.new(0.75, 0, 0.015, 0)
	CloseButton.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	CloseButton.AutoButtonColor = false
	CloseButton.Parent = Frame

	local MiscTools = Instance.new("Frame")
	MiscTools.Name = "MiscTools"
	MiscTools.BackgroundTransparency = 1
	MiscTools.Position = UDim2.new(0, 0, 0.8, 0)
	MiscTools.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	MiscTools.Size = UDim2.new(1, 0, 0.25, 0)
	MiscTools.Parent = Frame

	local PropertyTool = Instance.new("ImageButton")
	PropertyTool.Name = "PropertyTool"
	PropertyTool.Size = UDim2.new(0.4, 0, 0.4, 0)
	PropertyTool.Image = "rbxasset://textures/ui/PropertyButton.png"
	PropertyTool.BackgroundTransparency = 1
	PropertyTool.Position = UDim2.new(0.05, 0, 0.1, 0)
	PropertyTool.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	PropertyTool.AutoButtonColor = false
	PropertyTool.Parent = MiscTools

	local PropertyTools = Instance.new("Frame")
	PropertyTools.Name = "PropertyTools"
	PropertyTools.BackgroundTransparency = 1
	PropertyTools.Position = UDim2.new(0, 0, 0.3, 0)
	PropertyTools.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	PropertyTools.Size = UDim2.new(1, 0, 0.25, 0)
	PropertyTools.Parent = Frame

	local MaterialSelector = Instance.new("ImageButton")
	MaterialSelector.Name = "MaterialSelector"
	MaterialSelector.Size = UDim2.new(0.4, 0, 0.4, 0)
	MaterialSelector.Image = "rbxasset://textures/ui/MaterialButton.png"
	MaterialSelector.BackgroundTransparency = 1
	MaterialSelector.Position = UDim2.new(0.5, 0, 0.1, 0)
	MaterialSelector.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	MaterialSelector.AutoButtonColor = false
	MaterialSelector.Parent = PropertyTools

	local PaintTool = Instance.new("ImageButton")
	PaintTool.Name = "PaintTool"
	PaintTool.Size = UDim2.new(0.4, 0, 0.4, 0)
	PaintTool.Image = "rbxasset://textures/ui/PaintButton.png"
	PaintTool.BackgroundTransparency = 1
	PaintTool.Position = UDim2.new(0.05, 0, 0.1, 0)
	PaintTool.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	PaintTool.AutoButtonColor = false
	PaintTool.Parent = PropertyTools

	local InputSelector = Instance.new("ImageButton")
	InputSelector.Name = "InputSelector"
	InputSelector.Size = UDim2.new(0.4, 0, 0.4, 0)
	InputSelector.Image = "rbxasset://textures/ui/SurfaceButton.png"
	InputSelector.BackgroundTransparency = 1
	InputSelector.Position = UDim2.new(0.05, 0, 0.54, 0)
	InputSelector.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	InputSelector.AutoButtonColor = false
	InputSelector.Parent = PropertyTools

	local Divs = Instance.new("Frame")
	Divs.Name = "Divs"
	Divs.BackgroundTransparency = 1
	Divs.Position = UDim2.new(0, 0, 0.05, 0)
	Divs.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	Divs.Size = UDim2.new(1, 0, 1, 0)
	Divs.Parent = Frame

	local TopDiv = Instance.new("ImageLabel")
	TopDiv.Name = "TopDiv"
	TopDiv.Image = self.Images.BuildTools.Divs.Normal
	TopDiv.BackgroundTransparency = 1
	TopDiv.Position = UDim2.new(0.1, 0, 0.25, 0)
	TopDiv.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	TopDiv.Size = UDim2.new(0.8, 0, 0, 2)
	TopDiv.Parent = Divs

	local SecondDiv = Instance.new("ImageLabel")
	SecondDiv.Name = "SecondDiv"
	SecondDiv.Image = self.Images.BuildTools.Divs.Normal
	SecondDiv.BackgroundTransparency = 1
	SecondDiv.Position = UDim2.new(0.1, 0, 0.5, 0)
	SecondDiv.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	SecondDiv.Size = UDim2.new(0.8, 0, 0, 2)
	SecondDiv.Parent = Divs

	local LastDiv = Instance.new("ImageLabel")
	LastDiv.Name = "LastDiv"
	LastDiv.Image = self.Images.BuildTools.Divs.Normal
	LastDiv.BackgroundTransparency = 1
	LastDiv.Position = UDim2.new(0.1, 0, 0.75, 0)
	LastDiv.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	LastDiv.Size = UDim2.new(0.8, 0, 0, 2)
	LastDiv.Parent = Divs

	local AddDeleteTools = Instance.new("Frame")
	AddDeleteTools.Name = "AddDeleteTools"
	AddDeleteTools.BackgroundTransparency = 1
	AddDeleteTools.Position = UDim2.new(0, 0, 0.55, 0)
	AddDeleteTools.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	AddDeleteTools.Size = UDim2.new(1, 0, 0.25, 0)
	AddDeleteTools.Parent = Frame

	local InsertObject = Instance.new("ImageButton")
	InsertObject.Name = "InsertObject"
	InsertObject.Size = UDim2.new(0.4, 0, 0.4, 0)
	InsertObject.Image = "rbxasset://textures/ui/InsertButton.png"
	InsertObject.BackgroundTransparency = 1
	InsertObject.Position = UDim2.new(0.05, 0, 0.1, 0)
	InsertObject.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	InsertObject.AutoButtonColor = false
	InsertObject.Parent = AddDeleteTools

	local DeleteObject = Instance.new("ImageButton")
	DeleteObject.Name = "DeleteObject"
	DeleteObject.Size = UDim2.new(0.4, 0, 0.4, 0)
	DeleteObject.Image = "rbxasset://textures/ui/DeleteButton.png"
	DeleteObject.BackgroundTransparency = 1
	DeleteObject.Position = UDim2.new(0.5, 0, 0.54, 0)
	DeleteObject.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	DeleteObject.AutoButtonColor = false
	DeleteObject.Parent = AddDeleteTools

	local CloneObject = Instance.new("ImageButton")
	CloneObject.Name = "CloneObject"
	CloneObject.Size = UDim2.new(0.4, 0, 0.4, 0)
	CloneObject.Image = "rbxasset://textures/ui/CloneButton.png"
	CloneObject.BackgroundTransparency = 1
	CloneObject.Position = UDim2.new(0.05, 0, 0.54, 0)
	CloneObject.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	CloneObject.AutoButtonColor = false
	CloneObject.Parent = AddDeleteTools

	return BuildTools
end

function RobloxGuiBuilds:CreateWasteButtons(controlFrame)
	local BottomRightControl = controlFrame:WaitForChild("BottomRightControl")
	local BottomLeftControl = controlFrame:WaitForChild("BottomLeftControl")

	-- bottom left
	local Exit = Instance.new("ImageButton")
	Exit.Name = "Exit"
	Exit.Image = RobloxGuiBuilds.Images.Main.Legacy1.Exit.Normal --"rbxasset://textures/Exit.png"
	Exit.BackgroundTransparency = 1
	Exit.Position = UDim2.new(0, 2, 0, -2)
	Exit.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	Exit.Size = UDim2.new(0, 56, 0, 41)
	Exit.Parent = BottomLeftControl
	game:SetVerb(Exit, "Exit") -- set the verb to exit incase there is no magical script
	RobloxGuiBuilds:ConnectImageAssets(Exit)

	local TogglePlayMode = Instance.new("ImageButton") -- not uploading an image for a non-existant button
	TogglePlayMode.Name = "TogglePlayMode"
	TogglePlayMode.Image = "" --"rbxasset://textures/TogglePlayMode.png"
	TogglePlayMode.BackgroundTransparency = 1
	TogglePlayMode.Position = UDim2.new(0, 93, 0.5, -17)
	TogglePlayMode.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	TogglePlayMode.Size = UDim2.new(0, 33, 0, 33)
	TogglePlayMode.Parent = BottomLeftControl

	local ToolButton = Instance.new("ImageButton") -- not uploading an image for a non-existant button
	ToolButton.Name = "ToolButton"
	ToolButton.Size = UDim2.new(0, 35, 0, 35)
	ToolButton.Image = "" --"rbxasset://textures/ui/ToolButton_ds.png"
	ToolButton.BackgroundTransparency = 1
	ToolButton.Position = UDim2.new(0, 60, 0, 5)
	ToolButton.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	ToolButton.AutoButtonColor = false
	ToolButton.Parent = BottomLeftControl

	-- bottom right
	local Screenshot = Instance.new("ImageButton")
	Screenshot.Name = "Screenshot"
	Screenshot.Image = "rbxasset://textures/Screenshot.png"
	Screenshot.BackgroundTransparency = 1
	Screenshot.Position = UDim2.new(1, -198, 1, -38)
	Screenshot.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	Screenshot.Size = UDim2.new(0, 30, 0, 30)
	Screenshot.Parent = BottomRightControl

	local ReportAbuse = Instance.new("ImageButton")
	ReportAbuse.Name = "ReportAbuse"
	ReportAbuse.Position = UDim2.new(1, -140, 1, -44)
	ReportAbuse.Image = "rbxasset://textures/ReportAbuse.png"
	ReportAbuse.BackgroundTransparency = 1
	ReportAbuse.Active = false
	ReportAbuse.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	ReportAbuse.Size = UDim2.new(0, 44, 0, 41)
	ReportAbuse.Parent = BottomRightControl

	local Help = Instance.new("ImageButton")
	Help.Name = "Help"
	Help.Position = UDim2.new(1, -94, 1, -45)
	Help.Image = "rbxasset://textures/Help.png"
	Help.BackgroundTransparency = 1
	Help.Active = false
	Help.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	Help.Size = UDim2.new(0, 36, 0, 41)
	Help.Parent = BottomRightControl

	local RecordToggle = Instance.new("ImageButton")
	RecordToggle.Name = "RecordToggle"
	RecordToggle.Image = "rbxasset://textures/RecordToggle.png"
	RecordToggle.BackgroundTransparency = 1
	RecordToggle.Position = UDim2.new(1, -230, 1, -38)
	RecordToggle.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	RecordToggle.Size = UDim2.new(0, 30, 0, 30)
	RecordToggle.Parent = BottomRightControl

	local ToggleFullScreen = Instance.new("ImageButton")
	ToggleFullScreen.Name = "ToggleFullScreen"
	ToggleFullScreen.Image = "rbxasset://textures/ToggleFullScreen.png"
	ToggleFullScreen.BackgroundTransparency = 1
	ToggleFullScreen.Position = UDim2.new(1, -165, 1, -45)
	ToggleFullScreen.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	ToggleFullScreen.Size = UDim2.new(0, 24, 0, 41)
	ToggleFullScreen.Parent = BottomRightControl
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
	
	local mouseLockLabel = Instance.new("ImageButton")
	mouseLockLabel.Name = "MouseLockLabel"
	mouseLockLabel.Image = RobloxGuiBuilds.Images.Main.Modern.MouseLockButton.Off.Normal
	mouseLockLabel.BackgroundTransparency = 1
	mouseLockLabel.Position = UDim2.new(0, 2, 0, -65)
	mouseLockLabel.Size = UDim2.new(0, 62, 0, 62)
	mouseLockLabel.Parent = BottomLeftControl

	RobloxGuiBuilds:ControlMouseLock(mouseLockLabel, RobloxGuiBuilds.Images.Main.Modern.MouseLockButton)
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
	
	local mouseLockLabel = Instance.new("ImageButton")
	mouseLockLabel.Name = "MouseLockLabel"
	mouseLockLabel.Image = RobloxGuiBuilds.Images.Main.Legacy1.MouseLockButton.Off.Normal
	mouseLockLabel.BackgroundTransparency = 1
	mouseLockLabel.Position = UDim2.new(0, 2, 0, -33)
	mouseLockLabel.Size = UDim2.new(0, 149, 0, 30)
	mouseLockLabel.Parent = BottomLeftControl
	
	RobloxGuiBuilds:ControlMouseLock(mouseLockLabel, RobloxGuiBuilds.Images.Main.Legacy1.MouseLockButton)
end)
RobloxGuiBuilds:AddGuiBuild({7, 2}, function(coregui)
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

	local BuildTools = RobloxGuiBuilds:CreateBuildToolsGUI()
	BuildTools.Parent = ControlFrame

	local TopLeftControl = Instance.new("Frame")
	TopLeftControl.Name = "TopLeftControl"
	TopLeftControl.BackgroundTransparency = 1
	TopLeftControl.Size = UDim2.new(0.05, 0, 0.05, 0)
	TopLeftControl.Parent = ControlFrame
	
	local BottomLeftControl = Instance.new("Frame")
	BottomLeftControl.Name = "BottomLeftControl"
	BottomLeftControl.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	BottomLeftControl.Size = UDim2.new(0, 130, 0, 46)
	BottomLeftControl.BackgroundTransparency = 1
	BottomLeftControl.Position = UDim2.new(0, 0, 1, -46)
	BottomLeftControl.Parent = ControlFrame

	local BottomRightControl = Instance.new("Frame")
	BottomRightControl.Name = "BottomRightControl"
	BottomRightControl.BackgroundTransparency = 1
	BottomRightControl.Position = UDim2.new(1, -180, 1, -41)
	BottomRightControl.Size = UDim2.new(0, 180, 0, 41)
	BottomRightControl.Parent = ControlFrame

	-- actual buttons we care about
	local CameraTiltDown = Instance.new("ImageButton")
	CameraTiltDown.Name = "CameraTiltDown"
	CameraTiltDown.Image = "rbxasset://textures/CameraTiltDown.png"
	CameraTiltDown.BackgroundTransparency = 1
	CameraTiltDown.Position = UDim2.new(1, -56, 1, -29)
	CameraTiltDown.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	CameraTiltDown.Size = UDim2.new(0, 25, 0, 25)
	CameraTiltDown.Parent = BottomRightControl
	RobloxGuiBuilds:ConnectImageAssets(CameraTiltDown)

	local CameraZoomIn = Instance.new("ImageButton")
	CameraZoomIn.Name = "CameraZoomIn"
	CameraZoomIn.Image = "rbxasset://textures/CameraZoomIn.png"
	CameraZoomIn.BackgroundTransparency = 1
	CameraZoomIn.Position = UDim2.new(1, -29, 1, -55)
	CameraZoomIn.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	CameraZoomIn.Size = UDim2.new(0, 25, 0, 25)
	CameraZoomIn.Parent = BottomRightControl
	RobloxGuiBuilds:ConnectImageAssets(CameraZoomIn)

	local CameraTiltUp = Instance.new("ImageButton")
	CameraTiltUp.Name = "CameraTiltUp"
	CameraTiltUp.Image = "rbxasset://textures/CameraTiltUp.png"
	CameraTiltUp.BackgroundTransparency = 1
	CameraTiltUp.Position = UDim2.new(1, -56, 1, -55)
	CameraTiltUp.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	CameraTiltUp.Size = UDim2.new(0, 25, 0, 25)
	CameraTiltUp.Parent = BottomRightControl
	RobloxGuiBuilds:ConnectImageAssets(CameraTiltUp)

	local CameraZoomOut = Instance.new("ImageButton")
	CameraZoomOut.Name = "CameraZoomOut"
	CameraZoomOut.Image = "rbxasset://textures/CameraZoomOut.png"
	CameraZoomOut.BackgroundTransparency = 1
	CameraZoomOut.Position = UDim2.new(1, -29, 1, -29)
	CameraZoomOut.BorderColor3 = Color3.new(0.106, 0.165, 0.208)
	CameraZoomOut.Size = UDim2.new(0, 25, 0, 25)
	CameraZoomOut.Parent = BottomRightControl
	RobloxGuiBuilds:ConnectImageAssets(CameraZoomOut)

	local mouseLockLabel = Instance.new("ImageButton")
	mouseLockLabel.Name = "MouseLockLabel"
	mouseLockLabel.Image = RobloxGuiBuilds.Images.Main.Legacy1.MouseLockButton.Off.Normal
	mouseLockLabel.BackgroundTransparency = 1
	mouseLockLabel.Position = UDim2.new(0, 2, 0, -33)
	mouseLockLabel.Size = UDim2.new(0, 149, 0, 30)
	mouseLockLabel.Parent = BottomLeftControl
	
	RobloxGuiBuilds:CreateWasteButtons(ControlFrame)
	RobloxGuiBuilds:ControlMouseLock(mouseLockLabel, RobloxGuiBuilds.Images.Main.Legacy1.MouseLockButton)
end)

--// Connections \\
RobloxGuiBuilds:LoadGuiBuild(CoreGui.VersionFull)