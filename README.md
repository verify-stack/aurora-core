# aurora-core
![version: v2025.615](https://img.shields.io/badge/version-v2025.615-blue?style=flat)
<br>
A incomplete barebones framework for replicating legacy CoreScripts and stamper tools on normal ROBLOX games.

## Get Started
Import the `AuroraCore.rbxm` file into ReplicatedStorage and move the AuroraLoader script inside to ReplicatedFirst.

## Usual CoreScript Structure
```txt
Modules/................ModuleScripts (2015E and above)
CoreScripts/............Actual scripts that are loaded.
>    BackpackScripts....Example folder
    >   BackpackBuilder.Example script
StarterScript...........Loads all of the CoreScripts. (REQUIRED)
LoadingScript...........Loading GUI (2014L and above)
```

## Patching CoreScripts
Refer to [PATCHING.md](/PATCHING.md).

## Linking with a database
Refer to [CAS.md](/CAS.md).

## Stamper Tools/InsertService
InsertService is a part of CAS and replicates the legacy functions that StamperTools use.

For more info view [InsertService.md](/InsertService.md).

## Checklist
- [ ] Services
    - [x] TestService
    - [x] ReplicatedFirst
    - [x] ScriptContext
    - [x] CoreGui
    - [x] [InsertService.md](/InsertService.md)
    - [x] StarterGui
    - [ ] Players
    - [ ] GuiService
    - [ ] LogService
    - [ ] BadgeService
    - [ ] MarketplaceService
- [ ] DataTypes
    - [x] Enum
    - [x] GlobalSettings
        - [x] RenderSettings
        - [x] GameSettings
    - [x] UserSettings
        - [x] UserGameSettings
    - [x] RBXScriptSignal (GoodSignal)
    - [ ] DataModel
    - [ ] Instance
- [ ] Supported RobloxGui Types
    - [x] 7D
    - [ ] 7C
    - [ ] 7B
    - [ ] 7A
- [ ] Networking
    - [x] Proxy
    - [ ] SecureNetwork
    - [ ] Client Adapter Service
- [ ] Utils
    - [x] Create.luau
    - [x] Inheritance.luau
    - [x] Proxy.luau
    - [x] ProxyServer.luau
    - [x] xml2lua
    - [ ] DataPersistence.luau
- [ ] Tests