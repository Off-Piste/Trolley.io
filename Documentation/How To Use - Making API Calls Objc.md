# How To Use - ObjectiveC

The networking of the framework has been done using [Alamofire](https://github.com/Alamofire/Alamofire). Why you might ask? Well because it's hands-down the best networking tool out there, and allows for easy connectivity.

Calls can be done using normal call backs or with Promise Kit's AnyPromise

> Note:
> With AnyPromise you will need to `@import PromiseKit` in the file

```objective-c
TRLRequest *request = [[TRLNetworkManager shared] get:TRLProductsRoute with:nil headers:nil];
[request responseDataWithHandler:^(NSData *data, NSError *error) {
    /* */
}];

// OR

TRLRequest *request = [[TRLNetworkManager shared] get:TRLProductsRoute with:nil headers:nil];
[request responseDataPromise].then(^(NSData *data){
    /* */
}).catch(^(NSError *error){
   /* */
});

```
