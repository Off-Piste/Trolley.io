# Getting Started

## Requirements (Beta)

Before you begin, you need a few things set up in your environment:

- Xcode
- - 8.3 or later
- An Xcode project targeting iOS 10.3 or above
- The bundle identifier of your app
- CocoaPods 1.0.0 or later

> NOTE: 1.0.0 Will be built for for 10.3/11 and Xcode 8.3/9

## Add Trolley to your app

Now it's time to add Trolley to your app. Todo this you will need a Trolley Shop and it's Trolley configuration file for your app.

1. Create a Trolley shop in the [Trolley console](http://trolleyio.co.uk), if you have't already.
2. Click **Add Trolley to your iOS app** and follow the steps, this will automatically download your Trolley configuration file.
3. If you haven't already, copy your configuration file to your Xcode project root.

## Add the SDK

If you are setting up a new project, you need to install the SDK. You may have already completed this as part of creating a Trolley shop.

We recommend using CocoaPods to install the libraries. You can install Cocoapods by following the [installation instructions](https://guides.cocoapods.org/using/getting-started.html#getting-started).

If you are planning to download and run one of the quickstart samples, the Xcode project and Podfile are already present, there will also be a sample configuration file present but this is the global tester, so if you wish to see your own products you will have to overwrite this file.

1. If you don't have an Xcode project yet, create one now.
2. Open up terminal.app and create a Podfile if you don't have one:

    ```bash
    $ cd your-project directory
    $ pod init
    ```

    > [What is a Podfile?](https://github.com/Off-Piste/Trolley.io-cocoa/blob/0.2.0-alpha/Documentation/Getting%20Started.md#podfile)


3. Add the pods that you want to install. You can include a Pod in your Podfile like this:

    ```bash
    pod 'Trolley/Core'

    # OR

    pod 'Trolley'
    ```

    > [Where do I place this?](https://github.com/Off-Piste/Trolley.io-cocoa/blob/0.2.0-alpha/Documentation/Getting%20Started.md#podfile)

    > NOTE: This will add the prerequisite libraries needed to get Firebase up and running in your iOS app. A list of currently available pods and subspecs is provided below. These are linked in feature specific setup guides as well.

4. Install the pods and open the .xcworkspace file to see the project in Xcode.

    ```bash
    $ pod install
    $ open your-project.xcworkspace
    ```

5. Download configuration file...

## Initialise Trolley in your app

The final step is to add initialization code to your application. You may have already done this as part of adding Firebase to your app. If you are using a quickstart this has been done for you.

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

## Available Pods
These pods are available for the different Trolley features

Pod                    | Service
-----------------------|-------------------------------------
pod "Trolley"          | Prerequisite libraries and Analytics
pod "Trolley/Database" | For the Product/Basket Management

### Coming Soon

See Roadmap for these ideas

## Next steps

- [Connecting The Shops Database](https://github.com/Off-Piste/Trolley.io-cocoa/blob/0.2.0-alpha/Documentation/Database/Getting%20Started.md)

## Helper Code

### Podfile

#### What are they?

A Podfile is a Ruby file that describes the dependencies (Helper Code) for Xcode Projects

#### Example

Here is an example Podfile, copy and change the <Project Name> with your project and run `pod install` to install the pods you need.

> NOTE:
> More details can be found [here](https://guides.cocoapods.org/syntax/podfile.html)

```ruby
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
use_frameworks!

target <Project Name> do
  # Place Your Pods Here:
  pod 'Trolley'

  target '<Project Name>Tests' do
    inherit! :search_paths
    # Pods for testing

  end

end

```
