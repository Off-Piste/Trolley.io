//
//  Responseable.swift
//  Pods
//
//  Created by Harry Wright on 22.06.17.
//
//

import Foundation

/*
 Responsable is the protocol that will hold any method to 
 mutate the downloaded response.
 
 Any class that conforms is a download response.
 */
public protocol Responsable {
    
    /// The element that is used for the sorting
    associatedtype Element
    
    /// The method used to sort the response. Works
    /// just like the normal `Array().sort(by:)` method.
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    func sort(by value: (Element, Element) -> Bool) -> Self
    
    /// <#Description#>
    ///
    /// - Parameter predicate: <#predicate description#>
    /// - Returns: <#return value description#>
    func filter(_ predicate: NSPredicate) -> Self
    
}

extension Responsable {
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - predicateFormat: <#predicateFormat description#>
    ///   - args: <#args description#>
    /// - Returns: <#return value description#>
    public func filter(_ predicateFormat: String, _ args: Any...) -> Self {
        let predicate = NSPredicate(format: predicateFormat, argumentArray: args)
        return self.filter(predicate)
    }
    
}
