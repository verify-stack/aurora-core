# Patching CoreScripts
At the first line of each script insert `_G:Inject(getfenv())`, allowing the script to access AuroraCore.

Here are some required patches to get things working.
## SetVerb
Replace the offending line with `game:SetVerb(GUIOBJECT, VERBHERE)`.
## RobloxLocked
Delete the line that uses it. If you really want it, sandbox it yourself.
 