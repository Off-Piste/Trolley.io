//
//  Products.swift
//  Pods
//
//  Created by Harry Wright on 26.06.17.
//
//

import Foundation
import SwiftyJSON

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
    
    public required convenience init(json: JSON) throws {
        try self.init(JSONData: json.dictionaryObject)
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
    
    /// Convience init that should be overriten by the devolper when using JSONData.
    /// Should call another init
    ///
    /// - Parameter JSONData: JSON data as a dictionary
    public convenience init(JSONData: Dictionary<String, Any>?) throws {
        guard let id = JSONData?["local_id"] as? String,
            let name = JSONData?["product_name"] as? String,
            let company = JSONData?["company_name"] as? String,
            let price = JSONData?["price"] as? Float,
            let discount = JSONData?["discount"] as? Float,
            let details = JSONData?["details"] as? [String : Any],
            let type = JSONData?["type"] as? String
            else {
                throw NSError(domain: "io.trolley", code: 0, userInfo: nil)
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

// MARK: Equatable

extension Products {
    
    public static func ==(lhs: Products, rhs: Products) -> Bool {
        return lhs.name == rhs.name &&
            lhs.company == rhs.company &&
            lhs.price == rhs.price &&
            lhs.discount == rhs.discount
    }
    
}
