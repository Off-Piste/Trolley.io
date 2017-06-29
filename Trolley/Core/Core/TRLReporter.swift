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
        customAttributes: Dictionary<AnyHashable, Any>?
        )
    {
        // Convert to JSON and send
    }
    
    func logCheckout<Collection>(
        of basket: Collection,
        withPrice money: Money,
        customAttributes: Dictionary<AnyHashable, Any>?
        ) where Collection : MutableCollection
    {
        // Convert to JSON and send
    }
    
    func logAddItem<Collection>(
        _ itemID: String,
        withPrice money: Money,
        toBasket basket: Collection?,
        customAttributes: Dictionary<AnyHashable, Any>?
        ) where Collection : MutableCollection
    {
        // Convert to JSON and send
    }
    
}
