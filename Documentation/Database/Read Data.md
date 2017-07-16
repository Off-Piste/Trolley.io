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

### Downloaded Data

The data that is downloaded is in JSON form, it is kept as simple as possible. To see a very basic example of a shop use cURL to see the JSON response.

```bash
curl -X GET http://default-0000.trolleyio.co.uk/API/products
```

A successful response from Trolley will be a `200` containing an array of all the products, which will look something like this:

> NOTE:
> For more details on the JSON and its attributes please see [this](http://)

```json
[
  {
    "local_id" : "2d1f6e2c7c67c60d99d9d8e20b0001cd",
    "discount" : 0,
    "details" : {
      "Color" : "Black"
    },
    "product_name" : "2 Ball Bag",
    "company_name" : "Brunswick",
    "type" : "Bag",
    "price" : 20
  },
  {
    "local_id" : "12DD-RG",
    "discount" : 6,
    "details" : {
      "Color" : "Blue and Yellow"
    },
    "product_name" : "Dare Devil Trick",
    "company_name" : "Roto Grip",
    "type" : "Bowling Ball",
    "price" : 275
  }
]
```

However if the key is invalid or the request is not allows you will be hit by an error warning, like so:

```json
{
  "Code" : 400,
  "Message" : "The API key is invalid"
}
```

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

- [Connecting Ardex](https://github.com/Off-Piste/Trolley.io-cocoa/blob/0.2.0-alpha/Documentation/Database/Working%20With%20Ardex.md)
