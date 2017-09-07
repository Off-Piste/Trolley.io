//
//  Product.swift
//  Pods
//
//  Created by Harry Wright on 30.03.17.
//
//

import Foundation
import SwiftyJSON

public protocol _Product : Equatable, Hashable {

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
    @nonobjc var price: Money { get }

    /// <#Description#>
    @nonobjc var discount: Percentage { get }

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

extension _Product {

    /// `Equatable` method to return true if the values are equal or false if not
    ///
    /// - Parameters:
    ///   - lhs: Self
    ///   - rhs: Self
    /// - Returns: Bool test for if they are equal or not.
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name &&
            lhs.company == rhs.company &&
            lhs.price == rhs.price &&
            lhs.discount == rhs.discount
    }

}

/**

 */
public extension _Product {

    /// The Price / Discount
    var discountValue: Money {
        return self.price / self.discount
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func toJSON() -> JSON {
        let dictionary: Dictionary<String, Any> = [
            "local_id" : self.id,
            "product_name" : self.name,
            "company_name" : self.company,
            "price" : self.price.floatValue,
            "discount" : self.discount.float,
            "type" : self.type,
            "details" : self.details
        ]
        
        return JSON(dictionary)
    }

}

