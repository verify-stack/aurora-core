# Patching CoreScripts
> [!NOTE]
> This only covers CoreScript related info, not logical patches.

At the first line of each script insert `_G:Inject(getfenv())`, allowing the script to access AuroraCore.

Here are some required patches to get things working.
## SetVerb
Replace the offending line with `game:SetVerb(GUIOBJECT, VERBHERE)`.
## RobloxLocked
Delete the line that uses it. If you really want it, sandbox it yourself.
## EnvConfig.luau
aurora-core has config files which are **really** important for CoreScripts and how aurora-core functions.

Go into `ReplicatedStorage/AuroraCore/EnvConfig.luau` and do what ever you want.
### FFlags
ROBLOX uses something called `Fast Flags`, aka `FFlags`. They're extra development settings for ROBLOX to mess around with (e.g Chrome UI or Topbar).

You have an option to use JSON (not added yet) or lua tables, you can set values to certain flags.
## AdminList
Go to the same config file as before, find `AdminList`.
* NewPlayerListScript
    * If you enabled this flag, make sure the key is your user id and the value is an image link (via /asset or rbxassetid://).
* Legacy Player Lists
    * For older player lists, the key is your username in lower case and the value is the same as before.
## ClientPeriod
CoreScripts check which version of `RobloxGui` you're using, `ClientPeriod` changes the RobloxGui version (also known as CoreGui).

Here are some listed periods (checkmark means it fully works):
- [x] 2015E (7D)
- [x] 2014L (7D)
- [x] 2014M (7C)
- [x] 2014E (7C)
- [x] 2013L (7C)
- [x] 2013M (7C)
- [x] 2013E (7C)
- [x] 2012L (7B)
- [ ] 2012M (7A)
- [ ] 2012E (3B)
- [ ] 2011L (3B)
- [ ] 2011M (3B)
- [ ] 2011E (2A)
- [ ] 2010L (No version, aka 1A. You'll have to create most of the gui yourself.)
## TextChatService
aurora-core uses TextChatService to be compliant with ROBLOX's TOS. This also allows the user to edit chat bubbles without any scripting!

[Back <-](/docs/Info/Permissions.md) || [Next ->](/docs/Info/ROJO.md)