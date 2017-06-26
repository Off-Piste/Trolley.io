//
//  TRLReporter.swift
//  Pods
//
//  Created by Harry Wright on 26.06.17.
//
//

import Foundation

class TRLReporter : Reporting {
    
    func logSearchQuery(
        _ query: String,
        userInfo: Dictionary<AnyHashable, Any>?
        )
    {
        // Convert to JSON and send
    }
    
    func logCheckout<Collection>(
        of basket: Collection,
        withPrice money: Money,
        userInfo: Dictionary<AnyHashable, Any>?
        ) where Collection : MutableCollection
    {
        // Convert to JSON and send
    }
    
    func logAddItem<Collection>(
        _ itemID: String,
        withPrice money: Money,
        toBasket basket: Collection?,
        userInfo: Dictionary<AnyHashable, Any>?
        ) where Collection : MutableCollection
    {
        // Convert to JSON and send
    }
    
}
