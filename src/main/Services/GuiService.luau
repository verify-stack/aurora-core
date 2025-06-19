-- very important service for corescripts
-- by mike
-- v2025.0618

local GuiServiceRoot = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local InstanceRoot = require("../DataTypes/Instance")
local RBXScriptSignal = require("../DataTypes/RBXScriptSignal")
local Inheritance = require("../Utils/Inheritance")
local nilReplace = "tHi5i$andl8e*l@cem&nt6236" -- pretty weird hack

local GuiService = setmetatable({}, InstanceRoot)
GuiService.__index = GuiService

function GuiService.new()
	local self = setmetatable(InstanceRoot.new(GuiServiceRoot), GuiService)
	self.ClassName = "GuiService"
	self.ErrorMessageChanged = RBXScriptSignal.new()
	self.UiMessageChanged = RBXScriptSignal.new()
	self.ShowLeaveConfirmation = RBXScriptSignal.new()
	self.EscapeKeyPressed = RBXScriptSignal.new()
	self.KeyPressed = RBXScriptSignal.new()
	self.SpecialKeyPressed = RBXScriptSignal.new()
	
	self._dialogWrapperMap = {}
	self._currentDialog = nilReplace
	self._dialogQueue = {}
	self._keyTable = {}
	self._skeyTable = {}
	self._keyRefTable = {
		["~"] = Enum.KeyCode.Tilde,
		["\t"] = Enum.KeyCode.Tab,
		["`"] = Enum.KeyCode.Backquote,
		
		-- backpack thingy
		["0"] = Enum.KeyCode.Zero,
		["1"] = Enum.KeyCode.One,
		["2"] = Enum.KeyCode.Two,
		["3"] = Enum.KeyCode.Three,
		["4"] = Enum.KeyCode.Four,
		["5"] = Enum.KeyCode.Five,
		["6"] = Enum.KeyCode.Six,
		["7"] = Enum.KeyCode.Seven,
		["8"] = Enum.KeyCode.Eight,
		["9"] = Enum.KeyCode.Nine,
	}
	self._skeyRefTable = {
		[Enum.SpecialKey.ChatHotkey] = Enum.KeyCode.Slash
	}
	
	self:_setupService()
	return self
end

function GuiService:_setupService()
	for _, enum in ipairs(Enum.CenterDialogType:GetEnumItems()) do
		self._dialogQueue[enum.Name] = {}
	end
	
	UserInputService.InputBegan:Connect(function(inputObject, gpe)
		if inputObject.KeyCode == Enum.KeyCode.Escape and gpe then -- bypass gpe
			self.EscapeKeyPressed:Fire()
		end
		
		if gpe then
			return
		end
		
		if self._keyTable[inputObject.KeyCode] then
			self.KeyPressed:Fire(self._keyTable[inputObject.KeyCode])
		end
		if self._skeyTable[inputObject.KeyCode] then
			self.SpecialKeyPressed:Fire(self._skeyTable[inputObject.KeyCode])
		end
	end)
end

function GuiService:AddSpecialKey(specialKey)
	self._skeyTable[self._skeyRefTable[specialKey]] = specialKey
end

function GuiService:AddKey(key)
	self._keyTable[self._keyRefTable[key] or Enum.KeyCode[key]] = key
end

function GuiService:RemoveSpecialKey(specialKey)
	self._skeyTable[self._skeyRefTable[specialKey]] = nil
end

function GuiService:RemoveKey(key)
	self._keyTable[self._keyRefTable[key] or Enum.KeyCode[key]] = nil
end

function GuiService:GetScreenResolution() -- why is this for RobloxScript only???
	return workspace.CurrentCamera.ViewportSize
end

function GuiService:GetInstanceCount()
	return #game:GetDescendants()
end

function GuiService:GetVoxelCount()
	-- no idea what this is
	return 0
end

function GuiService:GetBrickCount()
	local numPartInstances = 0
	for _, part in pairs(game:GetDescendants()) do
		if part:IsA("BasePart") then
			numPartInstances += 1
		end
	end

	return numPartInstances
end

function GuiService:GetConnectorCount()
	local numJointInstances = 0
	for _, part in pairs(game:GetDescendants()) do
		if part:IsA("JointInstance") then
			numJointInstances += 1
		end
	end

	return numJointInstances
end

function GuiService:GetErrorMessage()
	return ""
end

function GuiService:SetGlobalGuiInset(xo, xs, yo, ys)
	local UIPadding = Instance.new("UIPadding")
	UIPadding.PaddingRight = UDim.new(xo, xs)
	UIPadding.PaddingBottom = UDim.new(yo, ys)
	
	-- TODO: fix this code being not nice
	for _, gui in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do -- lazy way lol
		if not gui:IsA("ScreenGui") then
			continue
		end
		UIPadding:Clone().Parent = gui
	end
	UIPadding:Destroy()
end

-- taken directly from robloxsrc.zip
function GuiService:_shouldPreemptCurrentDialog(newDialog)
	if self._currentDialog == nilReplace then
		return true
	end
	if newDialog.dialogType.Value > self._currentDialog.dialogType.Value then
		return true
	end
	if newDialog.dialogType.Value < self._currentDialog.dialogType.Value then
		return false
	end
	assert(newDialog.dialogType.Value == self._currentDialog.dialogType.Value)
	
	if newDialog.dialogType == Enum.CenterDialogType.UnsolicitedDialog then
		return false
	else
		return true
	end
end

function GuiService:_queueDialogWrapper(newDialog, preempted)
	-- very weird hack here
	if newDialog.dialogType == Enum.CenterDialogType.UnsolicitedDialog then
		if preempted then
			table.insert(self._dialogQueue[newDialog.dialogType.Name], 1, newDialog)
		else
			table.insert(self._dialogQueue[newDialog.dialogType.Name], newDialog)
		end
	else
		table.insert(self._dialogQueue[newDialog.dialogType.Name], 1, newDialog)
	end
end

function GuiService:AddCenterDialog(dialogInstance, type, show, hide)
	assert(dialogInstance, "dialog must be a GuiObject instance")
	
	local dialog = self._dialogWrapperMap[dialogInstance]
	if dialog then
		assert(dialog.type ~= type, "A dialogInstance should not change CenterDialogTypes")
		
		if dialog == self._currentDialog then
            return
        else
            self:RemoveCenterDialog(dialogInstance)
		end
		-- have no idea what iter->second is, so leave this be
		--else
			--self._dialogWrapperMap[dialogInstance] = nil
		--end
	end
	
	assert(self._dialogWrapperMap[dialogInstance] == nil)
	
	local wrapper = {}
	wrapper.dialog = dialogInstance
	wrapper.dialogType = type
	wrapper.showFunction = show
	wrapper.hideFunction = hide
	
	self._dialogWrapperMap[dialogInstance] = wrapper
	if self:_shouldPreemptCurrentDialog(self._dialogWrapperMap[dialogInstance]) then
		if self._currentDialog ~= nilReplace then
			hide()
			
			self:_queueDialogWrapper(self._currentDialog, true)
			self._currentDialog = nilReplace
		end
		
		self._currentDialog = wrapper
		show()
	else
		self:_queueDialogWrapper(wrapper, false)
	end
end

function GuiService:_showWaitingDialog(type)
	assert(self._currentDialog == nilReplace)

	if #self._dialogQueue[type.Name] > 0 then
		if self._dialogQueue[type.Name][1] == nil then -- another hack
			self._dialogQueue[type.Name][1] = nilReplace
		end
		self._currentDialog = self._dialogQueue[type.Name][1]
		self._dialogQueue[type.Name][1] = nil
		return true
	end
	return false
end

function GuiService:RemoveCenterDialog(dialogInstance)
	assert(dialogInstance, "dialog must be a GuiObject instance")

	if self._dialogWrapperMap[dialogInstance] then
		-- to prevent any issues with the table ref, we do this last
		-- so this is gonna be massive lol
		--self._dialogWrapperMap[dialogInstance] = nil
		self._dialogQueue[self._dialogWrapperMap[dialogInstance].dialogType.Name][self._dialogWrapperMap[dialogInstance]] = nil
		
		if self._dialogWrapperMap[dialogInstance] == self._currentDialog then
			self._currentDialog = nilReplace
			
			-- it was like this in the source, don't ask why lol
			if self:_showWaitingDialog(Enum.CenterDialogType.QuitDialog) 
				or self:_showWaitingDialog(Enum.CenterDialogType.ModalDialog) 
				or self:_showWaitingDialog(Enum.CenterDialogType.PlayerInitiatedDialog)
				or self:_showWaitingDialog(Enum.CenterDialogType.UnsolicitedDialog) then
				self._dialogWrapperMap[dialogInstance].showFunction()
			end
		end
		self._dialogWrapperMap[dialogInstance] = nil
	end
end

return Inheritance.new(GuiServiceRoot, GuiService)