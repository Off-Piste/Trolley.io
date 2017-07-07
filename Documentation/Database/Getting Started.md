# Database

The Trolley Database is a cloud-hosted database. Data is stored as JSON and synchronized in realtime to every connected client. When you build cross-platform apps with our iOS SDK's, all of your clients share one Realtime Database instance and automatically receive updates with the newest data.

## Requirements (Beta)

1. Install the Trolley SDK
2. Add your app to your Trolley Shop in the console

## Add Trolley Database to your app

Ensure the following dependency is in your project's `Podfile`:

```ruby
pod 'Trolley/Database'
```
Run `pod install` and open the created `.xcworkspace` file.

## Set up Trolley Database

You must initialize Trolley before any Trolley app reference is created or used.

1. Import the Firebase module in your `UIApplicationDelegate` subclass:

    > NOTE: This is usually your AppDelegate.swift or AppDelegate.h File

    **SWIFT**
    ```swift
    import Trolley
    ```

    **OBJECTIVE-C**
    ```objective-c
    @import Trolley;
    ```

2. Configure the Trolley shared instance. This is typically done in the `didFinishLaunchingWithOptions:` method.

    **SWIFT**
    ```swift
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Trolley.shared.configure()

        return true
    }
    ```

    **OBJECTIVE-C**
    ```objective-c
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        [[TRLShop shared] configure];

        return YES;
    }
    ```

One you have initialised Trolley Database, you will need make calls using `TRLNetworkManager` like so:

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

## Next Steps

- [Reading Data](http://)
