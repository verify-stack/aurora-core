# GuiService
Throughout most of ROBLOX's lifetime, `GuiService` handled most gui related utils.

## Keys/SpecialKeys
Before `ContextActionService` and `UserInputService` existed, `GuiService` had a system where you could register keys via strings and Enums.

API:
```Lua
GuiService:AddKey(string) -- Adds a key to the key list.
GuiService:RemoveKey(string) -- Removes a key from the key list.
GuiService:AddSpecialKey(Enum.SpecialKey) -- Adds a key to the special key list.
GuiService:RemoveSpecialKey(Enum.SpecialKey) -- Removes a key from the special key list.

GuiService.KeyPressed -- When a normal key is pressed (:AddKey).
GuiService.SpecialKeyPressed -- When a special key is pressed (:AddSpecialKey).
```

## Centre Dialogs
To handle how popups/dialogs worked, ROBLOX created the `CenterDialog` apis.

API:
```Lua
-- PUBLIC:
GuiService:AddCenterDialog(dialogInstance, type, show, hide) -- Adds a dialog instance to dialog queue, or just runs it.
GuiService:RemoveCenterDialog(dialogInstance) -- Removes and shows a dialog from the queue.

-- PRIVATE:
GuiService:shouldPreemptCurrentDialog(newDialog) -- Checks if the dialog should run.
GuiService:queueDialogWrapper(newDialog, preempted) -- Adds the dialog to a queue.
GuiService:showWaitingDialog(type) -- Returns the first waiting dialog.
```

## Misc
Some random APIs used in CoreScripts.

API:
```Lua
GuiService:GetScreenResolution() -- Returns the screen size.
GuiService:SetGlobalGuiInset(xo, xs, yo, ys) -- Offsets every gui.

GuiService:GetInstanceCount() -- Returns the instance count of the DataModel.
GuiService:GetVoxelCount() -- No idea what this is.
GuiService:GetBrickCount() -- Gets a part count.
GuiService:GetConnectorCount() -- Returns the amount of any JointInstances.

GuiService:GetErrorMessage() -- Returns an error message.

GuiService:GetMouseLockInfo() --[[ 
    Returns info about the mouse lock label, this is not apart of the ROBLOX api. 
    [only v2025.0706 and above]

    Return example:
    {
		MouseLockLabel = mouseLockLabel,
		MouseLockImages = {
			Off = {
				Normal = mouseLockOff,
				Hover = mouseLockOffOvr
			},

			On = {
				Normal = mouseLockOn,
				Hover = mouseLockOnOvr
			}
		}
	}
]]

GuiService.UseLuaChat -- Returns true, name speaks for itself.
```

[Back <-](/docs/README.md) || [Next ->](/docs/Services/CoreGui.md)