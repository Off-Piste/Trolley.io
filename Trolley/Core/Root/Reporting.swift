//
//  Reporting.swift
//  Pods
//
//  Created by Harry Wright on 27.04.17.
//
//

import Foundation

public protocol Reporting {
    
    func logAddItem<Collection: MutableCollection>(
        _ itemID: String,
        withPrice money: Money,
        toBasket basket: Collection?,
        userInfo: Dictionary<AnyHashable, Any>?
    )
    
    func logCheckout<Collection: MutableCollection>(
        of basket: Collection,
        withPrice money: Money,
        userInfo: Dictionary<AnyHashable, Any>?
    )
    
    func logSearchQuery(
        _ query: String,
        userInfo: Dictionary<AnyHashable, Any>?
    )
    
}
