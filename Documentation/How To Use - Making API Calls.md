# How To Use - Swift

The networking of the framework has been done using [Alamofire](https://github.com/Alamofire/Alamofire). Why you might ask? Well because it's hands-down the best networking tool out there, and allows for easy connectivity.

Calls are easy to create and can be however wish. Simple or complicated, your choice.

```swift
TRLNetworkManager.shared
    .get(.products)
    .responseProducts { products in
        switch products {
        case .response(let objects):
            /* ... */
        case .error(let err):
            /* ... */
    }
}

// OR as complicated as you like

TRLNetworkManager.shared
    .get(.products)
    .filter("price > 100")
    .rate(20)
    .responseProducts { products in
        switch products {
        case .response(let objects):
            print(objects)
        case .error(let err):
            print(err)
    }
}
```

## Filter

Ahh the `.filter(_:)` function, looks familiar to Realm users and might frighten others, its very simple actually and easy to use.

As it uses `NSPredicate` a class by apple to help filter things using KVO.

> This can also be used on the response as some users may wish to filter post download rather than pre-download

Used like such:

```swift
.filter("price > 100")
```
