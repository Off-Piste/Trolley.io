//
//  Reporting.swift
//  Pods
//
//  Created by Harry Wright on 27.04.17.
//
//

import Foundation
import PassKit

/**
 The built in reporting delegate for the Reporter Class, can be accessed and used if people wish,
 or they can monitor the adding and removal of products from the basket.
 
 - Requires: `PassKit`
 
 This is due to the reporting of PKPayment sucess
 
 # Important
 
 There will be complimentary `Notification.Name` static properties that can be used instead,
 they are called back to back so developers can use the ones they prefer. i.e:
 
 public static let productAdded = Notification.Name("product-added")
 
 func basket<P: Product>(_ basket: _Basket<P>, productsAdded product: [P])
 */
public protocol _ReportingDelegate {
    
    /// The delegate method that is called whenever the `Basket().append` is called,
    /// this allows for users who are wanting to record the finer details of their applications
    /// to do so
    ///
    /// Check the README.md for examples of how to use with the Fabric.io framework `Answers`
    ///
    /// # NOTE
    /// At the same time of calling a `Notification.Name` is fired that can be observed
    ///
    /// ```
    /// public static let productAdded = Notification.Name("product-added")
    /// ```
    ///
    /// - Parameters:
    ///   - basket: The current basket that is been mutated
    ///   - product: An Array of products been added,
    ///              this is an array as muliple products can be appended at the same time.
    ///              Access `.first` to get the product 90% of the time
    func basket<P: Product>(_ basket: _Basket<P>, productsAdded product: [P])
    
    /// The delegate method that will be called whenever an item is removed from the basket,
    /// this allows for users who are wanting to record the finer details of their applications
    /// to do so
    ///
    /// Check the README.md for examples of how to use with the Fabric.io framework `Answers`
    ///
    /// # NOTE
    /// At the same time of calling a `Notification.Name` is fired that can be observed
    ///
    /// ```
    /// public static let productRemoved = Notification.Name("product-removed")
    /// ```
    ///
    /// - Parameters:
    ///   - basket: The current basket where P conforms to `Product`
    ///   - product: An array of products being removed,
    ///              this is an array as muliple products can be appended at the same time.
    ///              Access `.first` to get the product 90% of the time
    func basket<P: Product>(_ basket: _Basket<P>, productsRemoved product: [P])
    
    /// # REQUIRES PASS KIT
    /// # Test Method, to be changed
    ///
    ///
    /// - Parameters:
    ///   - payment: TEST
    ///   - sucess: TEST
    ///   - basket: TEST
    func payment<P: Product>(_ payment: PKPayment, didSucceed sucess: Bool, for basket:_Basket<P>)
}

/**
 An Idea.
 
 Rather than having any error messages come to the Reporting Delegate they should be seperate
 */
@objc public protocol ErrorReportingDelegate {
    
    /// TEST
    ///
    /// - Parameter error: TEST
    @objc optional func didRecive(error: Error)
    
}

/// Typealisa for all reporting Delegates,
/// check the `_ReportingDelegate` & `ErrorReportingDelegate` for details
public typealias ReportingDelegate = _ReportingDelegate & ErrorReportingDelegate

/**
 The custom `Notification.Name` proerties, check `ReportingDelegate` for infomation on these
 */
public extension Notification.Name {
    
    
    /// The Notification that is fired when an item is added to the `_Basket<Product>`
    public static let productAdded = Notification.Name("product-added")
    
    
    /// The Notification that is fired when an item is removed from the `_Basket<Product>`
    public static let productRemoved = Notification.Name("product-removed")
    
    /// The Notification that is fired when the JSON for the currency is downloaded.
    /// Observing this in your datasource and calling `.reloadData()` would allow for instant price updates when the JSON is downloaded
    public static let currencyDownloaded = Notification.Name("currency-downloaded")
    
}

/**
 The Reporter class, this will be the one to fire the delgate methods and fire the Notification Posts.
 
 Very limited access for devolpers.
 */
public class Reporter {
    
    /// The reporting delegate, setting this will allow you to capture the details with your basket
    public var delegate: ReportingDelegate?
    
    /// The shared instance of the class, this is what all objects, including internal ones talk to
    public static var shared = Reporter()
    
    /// Hidden Away...
    private init() { }
    
    /// The internal method to fire the delegate methods and Notifications when an item is added
    ///
    /// - Parameters:
    ///   - product: The product of type `Product` that had been added
    ///   - basket: The Basket the object was added to
    internal func added<P: Product>(product: P, to basket: _Basket<P>) {
        Logger.info("Product : \(product.name) added in basket (\(basket)) at \(Date())")
        
        delegate?.basket(basket, productsAdded: [product])
        NotificationCenter.default.post(
            name: .productAdded,
            object: [
                "Basket" : basket,
                "Product" : product
            ]
        )
    }
    
    /// The internal method to fire the delegate methods and Notifications when items are added
    ///
    /// May never be called, only called when appending a new basket or multiple items.
    /// If they are the same item will fire the above method.
    ///
    /// - Parameters:
    ///   - products: The products of type `Product` that had been added
    ///   - basket: The Basket the objects were added to
    internal func added<P: Product>(products: [P], to basket: _Basket<P>) {
        products.forEach {
            Logger.info("Product : \($0.name) added in basket (\(basket)) at \(Date())")
        }
        
        delegate?.basket(basket, productsAdded: products)
        NotificationCenter.default.post(
            name: .productAdded,
            object: [
                "Basket" : basket,
                "Products" : products
            ]
        )
        
    }
    
    /// The internal method to fire the delegate methods and Notifications when items are removed
    ///
    /// - Parameters:
    ///   - products: The products of type `Product` that had been removed
    ///   - basket: The Basket the objects were added to
    internal func removed<P: Product>(product: P, from basket: _Basket<P>) {
        Logger.info("Product : \(product.name) removed from basket (\(basket)) at \(Date())")
        
        delegate?.basket(basket, productsRemoved: [product])
        NotificationCenter.default.post(
            name: .productRemoved,
            object: [
                "Basket" : basket,
                "Product" : product
            ]
        )
    }
    
}
