//
//  Filter.swift
//  Pods
//
//  Created by Harry Wright on 30.05.17.
//
//

import Foundation
import PromiseKit
import SwiftyJSON

public extension Array where Element == Products {
    
    /// <#Description#>
    ///
    /// - Parameter text: <#text description#>
    /// - Returns: <#return value description#>
    func filter(for text: String) -> [Element] {
        return self.filter { $0.name.contains(text) || $0.company.contains(text)}
    }
    
}

public extension Array where Element == SearchableProducts {
    
    func filter(for text: String) -> [Element] {
        return self.filter { $0.productName.contains(text) || $0.companyName.contains(text) }
    }
    
}

/**
 Filtering struct to bring promises to `Array`s, currently only works
 with `[Products]`, soon will be adding support for basket and anything
 else that uses an array inside our code
 
 This is designed to work easier when using a search bar to keep 
 everything concurrent.
 
     firstly { return Products.getAll() }
         .then { return TRLProductsFilter.filter($0, for: searchBar.text ?? "") }
         .then { /* work with filtered array: $0 */ }
         .catch { /* Work with error: $0 */ }
 
 */
public struct TRLFilter<Value: MutableCollection> {
    
    /// The `MutableCollection` value
    public fileprivate(set) var elements: Value
    
    ///
    ///
    /// - Parameter elements:
    public init(elements: Value) {
        self.elements = elements
    }
    
}

public extension TRLFilter where Value == [Products] {
    
    ///
    ///
    /// - Parameter text:
    /// - Returns:
    mutating func filtered(for text: String) -> TRLFilter<Value> {
        let values = elements.filter(for: text)
        return TRLFilter(elements: values)
    }
    
    /// Static method to filter the parameter values for the entered text.
    ///
    /// - Parameters:
    ///   - products: The `Array<Products>` to be filtered
    ///   - text: The `String` text to filter the products by
    /// - Returns: The Promise of a filtered `Array`
    static func filter(_ products: Value, for text: String) -> Promise<Value> {
        return Promise { fullfill, reject in
            fullfill(products.filter(for: text))
        }
    }
    
    ///
    ///
    /// - Parameter text:
    /// - Returns:
    func filter(for text: String) -> Promise<Value> {
        return Promise { fullfill, reject in
            fullfill(self.elements.filter(for: text))
        }
    }
    
}

public extension TRLFilter where Value == [SearchableProducts] {
    
    ///
    ///
    /// - Parameter text:
    /// - Returns:
    mutating func filtered(for text: String) -> TRLFilter<Value> {
        let values = elements.filter(for: text)
        return TRLFilter(elements: values)
    }
    
    /// Static method to filter the parameter values for the entered text.
    ///
    /// - Parameters:
    ///   - products: The `Array<Products>` to be filtered
    ///   - text: The `String` text to filter the products by
    /// - Returns: The Promise of a filtered `Array`
    static func filter(_ products: Value, for text: String) -> Promise<Value> {
        return Promise { fullfill, reject in
            fullfill(products.filter(for: text))
        }
    }
    
    ///
    ///
    /// - Parameter text:
    /// - Returns:
    func filter(for text: String) -> Promise<Value> {
        return Promise { fullfill, reject in
            fullfill(self.elements.filter(for: text))
        }
    }
    
}

///
public typealias TRLProductsFilter = TRLFilter<[Products]>

///
public typealias TRLSearchFilter = TRLFilter<[SearchableProducts]>
