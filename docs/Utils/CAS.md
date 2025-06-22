# Client Adapter Service (CAS)
> [!CAUTION]
> CAS/Proxy allows the client to use server commands. Be careful of what you're doing.
CAS is an incomplete adapter for AuroraCore which allows for connections with your database and services.
**TODO**

## Disabling CAS.
CAS/Proxy is unsafe because it allows people to access server commands. If you want to disable it, turn the FFlag `AllowCASConnectionsAndDatabaseConnections` off.

But it'll disable any services that use the server, as well any requests.

### Services it'll Disable.
- [x] InsertService (view more at [InsertService.md](/docs/Utils/InsertService.md))
- [x] BadgeService
- [x] Players (only database requests though)
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
> While CAS makes it harder for hackers to abuse, it can stil be dangerous to use.
CAS solves some of the issues the proxy presents. **TODO**

#### Network
Proxy creates unprotected events, CAS patches that issue.

By funneling requests though 2 remotes and requiring a key, you have to do some special magic to access them.

[Back <-](/docs/README.md) || [Next ->](/docs/Utils/InsertService.md)