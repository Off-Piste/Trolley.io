# Working With [Ardex](https://github.com/Off-Piste/Ardex)

## What is Ardex?

Ardex is a home built UICollectionView and UITableView datasource manager, which allows for applications with those UIElements to be built faster and with less boiler plate code.

For the basics on how to use Ardex, please see there documentation [here](https://github.com/Off-Piste/Ardex).

## Connecting Trolley and Ardex Swift

Add Ardex to your podfile

```ruby
pod Trolley/UI
```

>NOTE: For objective-c please see [here](http://)

### Starting Up

Firstly you will need to subclass `CollectionViewController`, to do so click `File > New > File`, choose a `Cocoa Touch Class`, name it how you see fit, then sub class `CollectionViewController` and make sure the language is Swift.

Your class will look like this:

```swift
import UIKit

class VivacityVC: CollectionViewController {

}
```

Once doing this you will be hit with this error:

```
Use of undeclared type 'CollectionViewController'
```

To remedy this, just change `UIKit` to `Ardex` and the error with go, if not straight away just press `cmd b`.

### Creating your Collection View Cell
