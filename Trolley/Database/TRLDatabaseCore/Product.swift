//
//  Product.swift
//  Pods
//
//  Created by Harry Wright on 30.03.17.
//
//

import Foundation

public protocol Product : Equatable, Hashable {

    /// The products id, this is set to a default of `NSUUID().uuidString` if not set
    var id: String { get }

    /// The name of the product
    var name: String { get }

    /// The Company name of the product
    var company: String { get }

    /// The non currency converted price.
    ///
    /// To get a currency formatted string version call the `.currencyValue` variable
    ///
    ///     // £20.00
    ///     price.currencyValue
    var price: Money { get }

    /// <#Description#>
    var discount: Percentage { get }

    /// The data at which the product was added to your server, this is if you wish to filter your products by data, if not just call `Date()`
    var addedOn: Date { get }

    /// The Dictionary to hold the rest of the product infomation, this can be empty if you only wish to enter the details above
    var details: [String : Any] { get }

    var type: String { get }

    /// `Equatable` method to return true if the values are equal or false if not
    ///
    /// - Parameters:
    ///   - lhs: Self
    ///   - rhs: Self
    /// - Returns: Bool test for if they are equal or not.
    static func ==(lhs: Self, rhs: Self) -> Bool
}

extension Product {

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name &&
            lhs.company == rhs.company &&
            lhs.price == rhs.price &&
            lhs.discount == rhs.discount
    }

}

/**
 The only object that should be inherited from when using custom product classes

 Check README.md for examples, should only overwrite `JSONData` init if using custom JSON data.

 # BASKET

 All subclasses will automatically work with `Basket()`
 */
open class Products : NSObject, Product {

    open var id: String

    open var name: String

    open var company: String

    open var price: Money

    open var discount: Percentage

    open var addedOn: Date

    open var type: String

    open var details: [String : Any]

    open var total: Money {
        return self.price - self.discountValue
    }

    /// The Main Initaliser to set all the local properties
    ///
    /// - Parameters:
    ///   - id: The item id
    ///   - name: The product pame
    ///   - company: The companies name
    ///   - price: The products price
    ///   - discount: The products discount
    ///   - addedOn: The date at which the product was added
    ///   - details: The remianing details
    public init(
        id: String,
        name: String,
        company: String,
        price: Money,
        discount: Percentage,
        addedOn: Date,
        type: String,
        details: [String : Any]
        )
    {
        self.id = id
        self.name = name
        self.company = company
        self.price = price
        self.discount = discount
        self.addedOn = addedOn
        self.type = type
        self.details = details
    }

    public convenience required init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: "id") as! String?,
            let name = aDecoder.decodeObject(forKey: "name") as! String?,
            let company = aDecoder.decodeObject(forKey: "company") as! String?,
            let price = aDecoder.decodeFloat(forKey: "price") as Float?,
            let discount = aDecoder.decodeFloat(forKey: "discount") as Float?,
            let type = aDecoder.decodeObject(forKey: "type") as? String,
            let details = aDecoder.decodeObject(forKey: "details") as? [String : Any],
            let timestamp = aDecoder.decodeDouble(forKey: "timestamp") as Double?
            else {
                return nil
        }

        self.init(
            id: id,
            name: name,
            company: company,
            price: Money(price),
            discount: Percentage(value: discount),
            timestamp: timestamp,
            type: type,
            details: details
        )
    }
}

// MARK: - Convience Inits
extension Products {

    /// A convenience Initaliser to set all the local properties
    ///
    /// - Parameters:
    ///   - id: The item id
    ///   - name: The product pame
    ///   - company: The companies name
    ///   - price: The products price
    ///   - discount: The products discount
    ///   - timestamp: The timestamp for the addedOn date
    ///   - details: The remianing details
    public convenience init(
        id: String,
        name: String,
        company: String,
        price: Money,
        discount: Percentage,
        timestamp: TimeInterval,
        type: String,
        details: [String : Any]
        )
    {
        self.init(
            id: id,
            name: name,
            company: company,
            price: price,
            discount: discount,
            addedOn: Date(timeIntervalSince1970: timestamp),
            type: type,
            details: details
        )
    }

    /// The Main Initaliser to set all the local properties
    ///
    /// - Parameters:
    ///   - name: The product pame
    ///   - company: The companies name
    ///   - price: The products price
    ///   - discount: The products discount
    ///   - addedOn: The date at which the product was added
    ///   - details: The remianing details
    public convenience init(
        name: String,
        company: String,
        price: Money,
        discount: Percentage,
        addedOn: Date,
        type: String,
        details: [String : Any]
        )
    {
        self.init(
            id: NSUUID().uuidString,
            name: name,
            company: company,
            price: price,
            discount: discount,
            addedOn: addedOn,
            type: type,
            details: details
        )
    }

    /// A convenience Initaliser to set all the local properties
    ///
    /// - Parameters:
    ///   - name: The product pame
    ///   - company: The companies name
    ///   - price: The products price
    ///   - discount: The products discount
    ///   - timestamp: The timestamp for the addedOn date
    ///   - details: The remianing details
    public convenience init(
        name: String,
        company: String,
        price: Money,
        discount: Percentage,
        timestamp: TimeInterval,
        type: String,
        details: [String : Any]
        )
    {
        self.init(
            id: NSUUID().uuidString,
            name: name,
            company: company,
            price: price,
            discount: discount,
            addedOn: Date(timeIntervalSince1970: timestamp),
            type: type,
            details: details
        )
    }

    /// Convience init that should be overriten by the devolper when using JSONData.
    /// Should call another init
    ///
    /// - Parameter JSONData: JSON data as a dictionary
    public convenience init?(JSONData: Dictionary<String, Any>) {
        guard let id = JSONData["local_id"] as? String,
            let name = JSONData["product_name"] as? String,
            let company = JSONData["company_name"] as? String,
            let price = JSONData["price"] as? Float,
            let discount = JSONData["discount"] as? Float,
            let details = JSONData["details"] as? [String : Any],
            let type = JSONData["type"] as? String
            else {
                return nil
        }

        self.init(
            id: id,
            name: name,
            company: company,
            price: Money(price),
            discount: Percentage(value: discount),
            timestamp: Date().timeIntervalSince1970,
            type: type,
            details: details
        )

    }

    open override var description: String {
        return "<Product> { name: \(self.name) " +
                "company: \(self.company) " +
                "type: \(self.type) " +
                "price: \(self.price) }"
    }

}

/**

 */
public extension Product {

    /// <#Description#>
    var discountValue: Money {
        return self.price / self.discount
    }

}

// MARK: - Encoding Methods

/**
 NSCoding Conformity
 */
extension Products : NSCoding {

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.company, forKey: "company")
        aCoder.encode(self.price.floatValue, forKey: "price")
        aCoder.encode(self.discount.float, forKey: "discount")
        aCoder.encode(self.details, forKey: "details")
        aCoder.encode(self.addedOn.timeIntervalSince1970, forKey: "timestamp")
    }

    public static func ==(lhs: Products, rhs: Products) -> Bool {
        return lhs.name == rhs.name &&
            lhs.company == rhs.company &&
            lhs.price == rhs.price &&
            lhs.discount == rhs.discount
    }

}
