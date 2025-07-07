-- chat service! TODO: when GetService is fixed, change this to ChatService.luau
-- by mike
-- v2025.0706

local ChatServiceRoot = game:GetService("Chat")
local InstanceRoot = require("../DataTypes/Instance")
local Inheritance = require("../Utils/Inheritance")
local settings = require("../Settings")

local extensionModuleSuccess, extensionModuleFlagValue = pcall(function() return settings():GetFFlag("ExtensionModules") end)

local ChatService = setmetatable({}, InstanceRoot)
ChatService.__index = ChatService

function ChatService.new()
	local self = setmetatable(InstanceRoot.new(), ChatService)
	self.ClassName = "ChatService"
    self.ExtensionModules = if extensionModuleSuccess and type(extensionModuleFlagValue) == "table" then extensionModuleFlagValue else false
	
	return self
end

function ChatService:Chat(partOrCharacter, message, color)
    if not self.ExtensionModules then
        return
    end
    if not self.ExtensionModules.ChatBubbles then
        return
    end
    local chatManager = require(self.ExtensionModules.ChatBubbles)
    chatManager:createBubble(partOrCharacter, message, color)
end

return Inheritance.new(ChatServiceRoot, ChatService)