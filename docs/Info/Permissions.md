# Permissions
Like any good thing, there are permissions, and source code leaks.

As listed from robloxsrc.zip, here are the permission levels that ROBLOX uses.
* None = 0 (Any identity can access this feature, including in-game scripts)
* Plugin = 1 (Second-lowest access level, just above in-game script)
* RobloxPlace = 2 (A Roblox place that we own. Therefore scripts are more trusted and we allow preliminary features)
* LocalUser = 3 (non-game permission. Usually for IDE)
* WritePlayer = 4 (Permissions for changing player name, userId, etc.)
* RobloxScript = 5 (A script, such as a CoreScript, that we run inside a game)
* Roblox = 6 (Highest level of permission)
* TestLocalUser = {if RBX_TEST_BUILD: None else: LocalUser} (For exposing Lua functions to the ReleaseTest build)

CoreScripts only uses RobloxScript, which allows access to most ROBLOX public game apis.

[Back <-](/docs/README.md) || [Next ->](/docs/Info/PATCHING.md)