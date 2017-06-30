//
//  Reporting.swift
//  Pods
//
//  Created by Harry Wright on 27.04.17.
//
//

import Foundation

public protocol Reporting : class {
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - itemID: <#itemID description#>
    ///   - money: <#money description#>
    ///   - basket: <#basket description#>
    ///   - userInfo: <#userInfo description#>
    func logAddItem<Collection: MutableCollection>(
        _ itemID: String,
        withPrice money: Money,
        toBasket basket: Collection?,
        customAttributes: [AnyHashable : Any]?
    )
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - basket: <#basket description#>
    ///   - money: <#money description#>
    ///   - userInfo: <#userInfo description#>
    func logCheckout<Collection: MutableCollection>(
        of basket: Collection,
        withPrice money: Money,
        customAttributes: [AnyHashable : Any]?
    )
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - query: <#query description#>
    ///   - userInfo: <#userInfo description#>
    func logSearchQuery(
        _ query: String,
        customAttributes: [AnyHashable : Any]?
    )
    
}
