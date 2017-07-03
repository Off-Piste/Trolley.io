# How To Use - ObjectiveC

The networking of the framework has been done using [Alamofire](https://github.com/Alamofire/Alamofire). Why you might ask? Well because it's hands-down the best networking tool out there, and allows for easy connectivity.

Calls can be done using normal call backs or with Promise Kit's AnyPromise

> Note:
> With AnyPromise you will need to `@import PromiseKit` in the file

```objective-c
TRLRequest *request = [[TRLNetworkManager shared] getDatabase:TRLDatabaseProducts];
[request responseJSONWithBlock:^(NSDictionary<NSString *,id> *json, NSError *error) {
    /** ... */
}];

// OR using PromiseKit

TRLRequest *request = [[TRLNetworkManager shared] getDatabase:TRLDatabaseProducts];
[request responseJSON].then(^(NSDictionary<NSString *,id> *json){
    /* ... */
}).catch(^(NSError *error){
    /* ... */
});

```
