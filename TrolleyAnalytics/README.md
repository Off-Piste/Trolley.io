# TrolleyAnalytics

## SDK Roadmap
- [X] Connect the server
- [X] Pass events to the server
- [ ] Handle response from server
- [ ] New events
- [ ] Adding Logging
- [ ] Add API Connections for the Server ? (This is for if we are using the SDK for our Apps or a newer one)

## JSON Response from Server

When the event is successful the response will be:
```json
{
  "t":"d",
  "d" : {
    "received": "true",
    "ts": 123567765443
  }
}
```
No need to work with this, just TRLDebugLog this as a received message.

where as an unsuccessful response is:

```json
{
  "t":"d",
  "d" : {
    "received": "false",
    "ts": 123567765443,
    "o" : {
      "#The object that was passed to the server"
    }
  }
}
```
