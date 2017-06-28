//
//  TRLPromise.swift
//  Pods
//
//  Created by Harry Wright on 22.06.17.
//
//

import Foundation

/// <#Description#>
public typealias TRLProductsPromise = _TRLPromise<Products>

/// <#Description#>
public struct _TRLPromise<T: NSObjectProtocol> {
    
    /// <#Description#>
    public var objects: [T]
    
    /// <#Description#>
    ///
    /// - Parameter objects: <#objects description#>
    internal init(_ objects: [T]) { self.objects = objects }
    
}

// MARK: - <#Responsable#>
extension _TRLPromise : Responsable {
    
    /// <#Description#>
    public typealias Element = T
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    public func sort(by value: (Element, Element) -> Bool) -> _TRLPromise {
        return _TRLPromise(objects.sorted(by: value))
    }
    
    /// <#Description#>
    ///
    /// - Parameter predicate: <#predicate description#>
    /// - Returns: <#return value description#>
    public func filter(_ predicate: NSPredicate) -> _TRLPromise {
        let newObjects = (objects as NSArray).filtered(using: predicate) as! [T]
        return _TRLPromise(newObjects)
    }
    
}

extension _TRLPromise :  CustomStringConvertible {
    
    public var description: String {
        return self.objects.description
    }
    
}
