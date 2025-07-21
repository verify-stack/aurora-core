# Client Adapter Service (CAS) Toolkit
The CAS toolkit is a useful util that can only be used in CAS services.

## Logging
The toolkit provides an private logging service, which doesn't clutter up the output with junk.

### API
```Lua
CASToolkit.logger:logprint(rootstring, ...) -- logs an info type message
CASToolkit.logger:logwarn(rootstring, ...) -- logs an warn type message
CASToolkit.logger:logerror(rootstring, ...) -- logs an error type message
CASToolkit.logger:logassert(string, condition) -- assert function, logs an error type message if the condition is false

CASToolkit.logger:dumplog() -- dumps the log to the output
```

### Example
This example uses the whole logging API.
```Lua
CASToolkit.logger:logprint("hello CAS test!", tostring(value))
CASToolkit.logger:logwarn("warning")
CASToolkit.logger:logerror("error")
if CASToolkit.logger:logassert(true, "this would never happen") then
    CASToolkit.logger:dumplog()
end

CASToolkit.logger:dumplog()
```

Output:
```
[called logprint "hello CAS test! value"] (not in output)
[called logwarn "warning"] (not in output)
[called logerror "error"] (not in output)
[called logassert "this would never happen"] (never will be printed)
[called dumplog]

[Client Adapter Service SDK, print : Mon Feb 12 14:14:35 2024]: hello CAS test! value
[Client Adapter Service SDK, warn : Mon Feb 12 14:14:35 2024]: warning
[Client Adapter Service SDK, error : Mon Feb 12 14:14:35 2024]: error
```

## Data
If you need to send some data that normally can't be sent. No worries!

### API
```Lua
CASToolkit:sendnil() -- just sends nil, might do something more with this lol
CASToolkit:sendinstance(instance) -- sends an instance to the client
CASToolkit:createsignal() -- creates a signal
```

### Example
This example uses the whole data API.
```Lua
self.signal = CASToolkit:createsignal()

return CASToolkit:sendnil(), CASToolkit:sendinstance(Instance.new()), self.signal
```

[Back <-](/docs/Utils/CAS.md) || [Next ->](/docs/Utils/InsertService.md)