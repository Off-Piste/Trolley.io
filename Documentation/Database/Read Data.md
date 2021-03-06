# Read Data

## Create a TRLNetworkManager reference

**SWIFT**
```swift
var networkManager: TRLNetworkManager

networkManager = TRLNetworkManager.shared
```

**OBJECTIVE-C**
```objective-c
@property (strong, nonatomic) TRLNetworkManager *networkManager;

self.networkManager = [TRLNetworkManager shared];
```

## Reading Data

This document covers the basics of reading Trolley product data. For more advance features please head to:

> Note: By default, read access to your database is unrestricted so only any user, weather logged in or not can access the data, this can be changed if required

### Observe Changes (Coming Soon)

In some cases where you may want to have the shop data being downloaded and updated as soon as changes happen on the website, like maybe you're working on a eBay like store, so when prices change you want all devices to see them change instantly.

This is been worked on and will be available during beta releases.

### Read data once

In most cases you may want a callback to be called once and then immediately removed, such as when initializing a UI element that you don't expect to change.

This is useful for data that only needs to be loaded once and isn't expected to change frequently or require active listening.

**Swift**
```swift
self.networkManager.get(.products).responseJSON { (json, error) in
    if let error = error {
        /* ... */
    } else {
        /* ... */
    }
}
```

**Objective-C**
```objective-c
TRLRequest *request = [self.networkManager getDatabase:TRLDatabaseProducts];
[request responseJSONArray:^(NSArray *json, NSError *error) {
    if (error) {
        /* ... */
    } else {
        /* ... */    
    }
}];
```

## Next Step
