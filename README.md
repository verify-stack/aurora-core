# aurora-core
> [!WARNING]
> This current version of aurora-core is incomplete, expect bugs and improper documentation.

![license: mit](https://img.shields.io/badge/license-mit-orange?style=flat)![version: v2025.0704](https://img.shields.io/badge/version-v2025.0704-blue?style=flat)
<br>
A incomplete barebones framework for replicating legacy CoreScripts and stamper tools on normal ROBLOX games.

## Get Started
Import the `AuroraCore.rbxm` file iand unpack it like you would normally.

For more info, go to [the docs](/docs/README.md).

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
Refer to [PATCHING.md](/docs/Info/PATCHING.md).

## Linking with a database
Refer to [CAS.md](/docs/Utils/CAS.md).

## Stamper Tools/InsertService
InsertService replicates the legacy functions that StamperTools use.

For more info view [InsertService.md](/docs/Utils/InsertService.md).

## Checklist
- [ ] Services
    - [x] TestService
    - [x] ReplicatedFirst
    - [x] ScriptContext
    - [x] CoreGui
    - [x] [InsertService.md](/docs/Utils/InsertService.md)
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
    - [x] 7C
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
    - [x] SecureNet
    - [ ] DataPersistence.luau
- [ ] Tests