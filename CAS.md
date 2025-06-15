# Client Adapter Service (CAS)
CAS is an incomplete adapter for AuroraCore which allows for connections with your database and services.
**TODO**

## How does it work?
CAS works as a handler for the existing proxy system.

### Proxy
The proxy provides the client fake functions which just calls RemoteEvents/RemoteFunctions.
Those events are connected to a server.

#### Problems
While this works great, there are major problems.
* A script must call the service inorder for it to work.
* Can be messy to deal with.
* No auto-complete.
* Hackers can easily take abuse of this system.

### CAS
CAS solves some of the issues the proxy presents. **TODO**

#### Network
Proxy creates unprotected events, CAS removes that issue.
**TODO**