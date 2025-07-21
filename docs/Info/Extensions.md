# Extensions
> [!NOTE]
> aurora-core does not provide extensions, you'll have to create them yourselfs and stick to the API provided (unlike CAS).

Since ROBLOX loved to hardcode their API to services, aurora-core has the option to link in modules following a rigid stucture.

## ChatBubbles
While custom chat bubbles are not required (since TextChatService exists), there is an option to use custom bubbles.

```Lua
-- only public API
ChatBubbles:createBubble(partOrCharacter, message, colour) -- Creates a chat bubble, you can handle this anyway you want. (NOTE: you'll have to handle partOrCharacter)

-- Connections (do not add, shows where the function gets called)
Players.PlayerChatted:Connect(function(...)
    ChatBubbles:createBubble(partOrCharacter, message, colour)
end)
```

## CameraModule
> [!IMPORTANT]
> Since `v2025.0706`, the mouse lock gui is no longer handled by `RobloxGuiBuilder`.
> You will have to implement the function into your camera module.
> Possible images can be accessed via `GuiService:GetMouseLockInfo()`.

If you're using mobile, you'll have to create a custom camera module if you want it working.
Optionally, you just can use the default camera module and hookup `RotateCamera` and `ZoomCamera`.

For 2012L and below (7B and below), you'll have to handle the camera view buttons by yourself, the images are already handled though.

```Lua
CameraModule.new(name) -- Creates a new camera, name is for the runtime bind.

CameraModule:ZoomCamera(zoom) -- Zooms the camera in or out.
CameraModule:RotateCamera(rotateVector) -- Rotates the camera (startLook is just the LookVector of the camera. Call :GetCameraLook or something like that).

-- Connections (do not add, shows where the function gets called)
function UserInputService:ZoomCamera(zoom)
    CameraModule:ZoomCamera(zoom)
end

function UserInputService:RotateCamera(rotateVector)
    CameraModule:RotateCamera(rotateVector)
end
```

## TeleportModule
If you want to make your player teleport back to your own game, you can create your own teleport module.

```Lua
-- only public API
TeleportModule() -- Calls the teleport function, what else do you think it calls? 

-- Connections (do not add, shows where the function gets called)
["Exit"] = function()
	if self.TeleportModule ~= "nil" then
		self.TeleportModule()
	end

	warn("TeleportModule was not added.")
	self:GetService("TeleportService"):Teleport(1818) -- teleport to crossroads lol
end,
```

[Back <-](/docs/Info/ROJO.md)