//
//  Array+Response.swift
//  Pods
//
//  Created by Harry Wright on 07.07.17.
//
//

import Foundation

// No need to add this for objc as NSArray already has this
extension Array where Element == Product {
    
    /// <#Description#>
    ///
    /// - Parameter predicate: <#predicate description#>
    /// - Returns: <#return value description#>
    public func filter(_ predicate: NSPredicate) -> Array<Element> {
        return (self as NSArray).filtered(using: predicate) as! Array<Element>
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - predicateFormat: <#predicateFormat description#>
    ///   - args: <#args description#>
    /// - Returns: <#return value description#>
    public func filter(_ predicateFormat: String, _ args: Any...) -> Array<Element> {
        let predicate = NSPredicate(format: predicateFormat, argumentArray: args)
        return self.filter(predicate)
    }
}
