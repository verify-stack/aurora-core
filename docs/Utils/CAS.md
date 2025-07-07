# Client Adapter Service (CAS)
> [!CAUTION]
> CAS/Proxy allows the client to use server commands. Be careful of what you're doing.

CAS is an adapter for AuroraCore which allows for connections with your database and services.

## Disabling CAS.
CAS/Proxy is unsafe because it allows people to access server commands. If you want to disable it, turn the FFlag `AllowCASConnectionsAndDatabaseConnections` off.

But it'll disable any services that use the server, as well any requests.

### Services it'll Disable.
- [x] InsertService (cannot be modified, view more at [InsertService.md](/docs/Utils/InsertService.md))
- [x] BadgeService
- [x] HttpService
- [x] HttpRbxApiService
- [x] MarketplaceService
- [x] LogService:ExecuteScript

### Proxy
> [!CAUTION]
> Proxy does not protect RemoteEvents/RemoteFunctions and allows hackers to use server commands if you're not careful enough.

The proxy provides the client fake functions which just calls RemoteEvents/RemoteFunctions.
Those events are connected to a server.

View an example: [client](/src/main/Services/InsertService.luau), [server](/src/server/Services/InsertService.luau).

#### Problems
While this works great, there are major problems.
* A script must call the service inorder for it to work.
* Can be messy to deal with.
* No auto-complete.
* Hackers can easily take abuse of this system.

### CAS
> [!CAUTION]
> CAS is still as dangerous as the normal proxy. Be ware!

CAS is a wrapper over proxy, requiring a non-rigid structure which can help with connecting with datastores. This also means, you don't have to deal with OOP at all.

#### Template
In `ServerStorage/AuroraCore/CAS`/`src/server/CAS`, create a module script any service name (example: BadgeService).

Use this template to guide you:
```Lua
-- MyService
-- by author
-- vYEAR.xxxx

local MyServiceStructure = {
    ClassName = "BadgeService", -- make sure to put your target service here
    AllowFlexibleStructure = true, -- if disabled, you'll have to follow the class structure. if enabled, you'll have to define your methods and variables.
    StrictChecking = false, -- if enabled, if a method is missing or doesn't exist in the class, it'll throw an error. it's recommend you enable this
    CreateProxy = true, -- creates a proxy for the client to use, you most likely want this on

    Methods = { -- only if AllowFlexibleStructure is enabled, else leave it empty
        --["Classes method"] = "your own method"

        --["UserHasBadge"] = "CheckIfUserIDHasBadged", [this would error since it never existed]
        --["NonLogged"] = "NonLoggedFunction", [if strict checking was enabled, this would've been flagged]

        ["UserHasBadge"] = "CheckIfUserIDHasBadge", -- this would work because it exists!
    },

    Variables = {
        ["BadgeVersion"] = "BadgeVersion", -- if strict checking was enabled, this would've been flagged
    }
}
local MyService = {}

function MyService:CheckIfUserIDHasBadge(CAS, value)
    print("hello CAS!")
    CAS.logger:logprint("hello CAS on logger!")
    if CAS.logger:logassert(true, "this would never happen") then
        return CAS:sendnil() -- not required, but ig it works
    end

    -- return value, Instance.new("Part") [this wouldn't work, it'll error]
    return value, CAS:sendinstance(Instance.new("Part"))
end

return { -- just send over the data
    Structure = MyServiceStructure,
    Service = MyService,
}
```

It's that simple, no OOP non-sense.

[Back <-](/docs/README.md) || [Next ->](/docs/Utils/InsertService.md)