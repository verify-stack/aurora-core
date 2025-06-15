-- testing service for checks
-- by mike
-- v2025.0601

local ScriptContextRoot = game:GetService("TestService")
local InstanceRoot = require("../DataTypes/Instance")
local Inheritance = require("../Utils/Inheritance")
local CoreScripts = script.Parent.Parent:WaitForChild("CoreScripts")

local ScriptContext = setmetatable({}, InstanceRoot)
ScriptContext.__index = ScriptContext

function ScriptContext.new()
	local self = setmetatable(InstanceRoot.new(), ScriptContext)
	self.Name = "Script Context"
	self.ClassName = "ScriptContext"

	return self
end

function ScriptContext:SetTimeout(num)
	warn("AuroraCore is cannot set the timeout of a script.")
end

function ScriptContext:AddCoreScriptLocal(name, parent)
	local structure = name:split("/")
	local coreScript = CoreScripts:FindFirstChild(structure[#structure], true)
	assert(coreScript, "failed to find corescript " .. name)
	assert(coreScript:IsA("LocalScript"), "corescript is not a localscript")
	
	coreScript.Parent = parent
	coreScript.Disabled = false
end

function ScriptContext:AddCoreScript(assetId, name, parent)
	ScriptContext:AddCoreScriptLocal(name, parent)
end

return Inheritance.new(ScriptContextRoot, ScriptContext)