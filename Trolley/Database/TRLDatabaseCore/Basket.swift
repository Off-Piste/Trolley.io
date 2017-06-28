//
//  Basket.swift
//  Pods
//
//  Created by Harry Wright on 30.03.17.
//
//

import Foundation
import SwiftyJSON

/** The default basket, is others are used with custom products that conform to `Product` */
public typealias Basket = _Basket<Products>

/** The Basket Type */
public struct _Basket<P: Product> : ExpressibleByArrayLiteral, MutableCollection {

    /// The type of the elements of an array literal.
    public typealias Element = P

    /// A type that represents a position in the collection.
    public typealias Index = Array<P>.Index

    /// The total of the products before tax (if not preadded) and shipping.
    ///
    ///     item.price - item.discount
    ///
    /// # Note
    /// Will be converted automatically.
    /// Call `.floatValue` or `.integerValue` or `.nonConvertedDecimal`
    /// to show the nonconverted value
    ///
    ///     let money: Money = 145.24
    ///     print(money) // prints "$160.60"
    ///     print(money.floatValue) // prints "145.24"
    ///
    public var subtotal: Money {
        return _totalPrice
    }

    /// The subtotal and adding shipping. The shipping is run through `ShippingManager`,
    /// the location is managed though `CLGeocoder`'s `reverseGeocodeLocation` method.
    ///
    /// - Warning:
    /// Due to threads and async the shipping price may not have been calculated before
    /// this propertry is called, in that case shipping is set to 0.
    ///
    /// `shippingCalculated` is fired so observing for this and
    /// reloading the table view will keep everything updated
    /// ---
    /// # Note
    /// Will be converted automatically.
    /// Call the `.floatValue` or `.integerValue` properties for non converted values
    ///
    ///     let money: Money = 145.24
    ///     print(money) // prints "$160.60"
    ///     print(money.floatValue) // prints "145.24"
    ///
    public var total: Money {
        return _totalPrice + (/* ShippingManager.shared.shippingPrice ?? */ 0.0)
    }

    /// The total discount
    ///
    /// # Note
    /// Will be converted automatically.
    /// Call `.floatValue` or `.integerValue` or `.nonConvertedDecimal`
    /// to show the nonconverted value
    ///
    ///     let money: Money = 145.24
    ///     print(money) // prints "$160.60"
    ///     print(money.floatValue) // prints "145.24"
    ///
    public var discount: Money {
        return _discount
    }

    /// A formatted date for when the basket was last updated.
    /// Ovrride dataFromat (bellow) to change the format of the date
    ///
    ///     public var dateFormat: String
    ///
    public var lastUpdated: String {
        return self._updatedOn.string
    }

    /// Items are the number of 'items' in the basket, where as `count` is the quantity of the basket.
    public var items: Int {
        let items = _products.filterDuplicates { $0 == $1 }
        return items.count
    }

    /// The number of elements in the collection.
    public var count: Int {
        return _products.count
    }

    /// The position of the first element in a nonempty collection.
    public var startIndex: Index {
        return _products.startIndex
    }

    /// The collection’s “past the end” position—that is, the position one greater than the last valid subscript argument.
    public var endIndex: Index {
        return _products.endIndex
    }

    fileprivate var _updatedOn: Date

    fileprivate var _totalPrice: Money = 0

    fileprivate var _discount: Money = 0

    fileprivate var _products = [Element]() {
        didSet {
            updateFigures()
            self._updatedOn = Date()
        }
    }

    //Initialise with an empty array
    public init() {
        _products = []
        _updatedOn = Date()

        updateFigures()
    }
}

// MARK: - Custom Inits
public extension _Basket {

    /// Initialize with a sequence of Products.
    public init<ElementSequence: Sequence>(indexes: ElementSequence)
        where ElementSequence.Iterator.Element == Element {
            _products = Array(indexes)
            _updatedOn = Date()
            updateFigures()
    }

    /// Initialize with an array literal.
    public init(arrayLiteral indexes: Element...) {
        _products = indexes
        _updatedOn = Date()
        updateFigures()
    }

    /// Initialize with an array of elements.
    public init(indexes: [Element]) {
        _products = indexes
        _updatedOn = Date()
        updateFigures()
    }

    /// Initialize with a single element.
    public init(index: Element) {
        _products = [index]
        _updatedOn = Date()
        updateFigures()
    }

    public init(repeating: Element, count: Int) {
        for _ in 0...count {
            _products.append(repeating)
        }

        _updatedOn = Date()
        updateFigures()
    }

    /// Accesses the element at the specified position.
    ///
    /// - Parameter index: The position of the element to access. position must be a valid index of the collection that is not equal to the endIndex property.
    public subscript(index: Index) -> Element {
        get { return _products[index] }
        set { _products[index] = newValue }
    }

}

// MARK: - MutableCollection Conformitity

public extension _Basket {

    /// <#Description#>
    ///
    /// - Parameter i: <#i description#>
    /// - Returns: <#return value description#>
    public func index(before i: Index) -> Index {
        return _products.index(before: i)
    }

    /// <#Description#>
    ///
    /// - Parameter i: <#i description#>
    /// - Returns: <#return value description#>
    public func index(after i: Index) -> Index {
        return _products.index(after: i)
    }

}

// MARK: - Append / Appending

public extension _Basket {

    /// Append a single element to `self`.
    public mutating func append(_ product: Element) {
        _products.append(product)
        // Reporter.shared.added(product: product, to: self)
    }

    /// Append an `Basket` to `self`.
    public mutating func append(_ other: _Basket) {
        _products.append(contentsOf: other._products)
        // Reporter.shared.added(products: other._products, to: self)
    }

    /// Append an array of elements to `self`.
    public mutating func append(_ other: [Element]) {
        _products.append(contentsOf: other)
        // Reporter.shared.added(products: other, to: self)
    }

    /// Return a new `Basket` containing the elements in self and the elements in `product`.
    public mutating func appending(_ product: Element) -> _Basket {
        var result = _products
        result.append(product)
        return _Basket(indexes: result)
    }

    /// Return a new `Basket` containing the elements in self and the elements in `other`
    public func appending(_ other: _Basket) -> _Basket {
        return _Basket(indexes: _products + other._products)
    }

    /// Return a new `Basket` containing the elements in self and the elements in `other`.
    public func appending(_ other: [Element]) -> _Basket {
        return _Basket(indexes: _products + other)
    }

    public func makeIterator() -> IndexingIterator<_Basket> {
        return IndexingIterator(_elements: self)
    }
}

// MARK: - Collection View and Table View Helpers

extension _Basket {

    /// Method to get the required item for id
    ///
    /// - Parameter id: The items ID
    /// - Returns: The Element with the id or nil if the element does not exist
    func getProduct(for id: String) -> Element? {
        for item in self._products {
            if item.id == id {
                return item
            }
        }
        return nil
    }

    /// Used when the developer wants to work with the table/collection views:
    ///
    ///     func numberOfSections(in collectionView: UICollectionView) -> Int {
    ///         return basket.numberOfBaskets
    ///     }
    ///
    /// - Returns: The number of baskets, set to 1
    public func numberOfBaskets() -> Int {
        return 1
    }

    /// Method to work with:
    ///
    ///     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    ///         return basket.numberOfProductsInBasket()
    ///     }
    ///
    /// - Returns: Returns the count of the current basket
    public func numberOfProductsInBasket() -> Int {
        return self.count
    }

    /// Method to mainly work with HWCollectionView but can be used by others, see example:
    ///
    ///     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    ///         let cell = <DEQUEUE CELL>
    ///         cell.object = basket.product(at: IndexPath)
    ///         return cell
    ///     }
    ///
    /// - Parameter indexPath: The current `indexPath` for the cell
    /// - Returns: The cell for that index path
    public func product(at indexPath: IndexPath) -> Element {
        return self._products[indexPath.row]
    }

}

// MARK: - Custom Functions

private extension _Basket {

    mutating func updateFigures() {
        self._discount = 0
        self._totalPrice = 0

        for item in _products {
            self._discount += item.price / item.discountValue
            self._totalPrice += (item.price - item.discountValue)
        }
    }
}

extension _Basket : JSONCoding {
    
    public func encode() throws -> Data {
        var json: JSON = []
        var jsonArr: [JSON] = []
        for product in self._products {
            jsonArr.append(product.toJSON())
        }
        
        json.arrayObject = jsonArr
        TRLDatabaseLogger.debug(json.rawString() ?? "")
        return try json.rawData()
    }
    
    public func decode(_ data: Data) throws -> JSON {
        let json = JSON(data: data)
        if json == JSON.null && json.error != nil {
            throw json.error!
        }
        
        return json
    }
    
}

// MARK: - Operators

extension _Basket : Equatable {

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: A value to compare.
    public static func ==(lhs: _Basket, rhs: _Basket) -> Bool {
        return lhs._products == rhs._products
    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - lhs: <#lhs description#>
    ///   - rhs: <#rhs description#>
    public static func +=(lhs: inout _Basket, rhs: _Basket) {
        lhs.append(rhs)
    }

}

// MARK: - CustomString

extension _Basket : CustomStringConvertible, CustomDebugStringConvertible, CustomReflectable {

    /// A textual representation of this instance.
    public var description: String {
        return self._products.description
    }

    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        return self.description
    }

    /// The custom mirror for this instance.
    public var customMirror: Mirror {
        return _products.customMirror
    }

}

extension Array {

    func filterDuplicates(includeElement: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()

        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }

        return results
    }
}
