# InsertService /Assets
> [!CAUTION]
> Enabling InsertService allows hackers to insert anything they want. Use with caution.

AuroraCore adds support for legacy InsertService functions by replacing it completely.

## Adding Custom Assets.
In this folder, add a model with the asset id. Inside have your instances there.

## Accessing from the Client.
Because of CAS, you can easily just call InsertService like normal on the client. No need to worry about anything.

## Disabling InsertService.
If you're concerned about safety, you can easily disable InsertService by just setting the FFlag `EnableInsertServiceSupport` to false.

Or if you want to, disable `AllowCASConnectionsAndDatabaseConnections`.