//
//  Filter.swift
//  Pods
//
//  Created by Harry Wright on 30.05.17.
//
//

import Foundation
import PromiseKit

typealias ProductsPromiseResponse = _PromiseResponse<Product>

public class _PromiseResponse<T: NSObjectProtocol> {
    
    /// <#Description#>
    public typealias Element = T
    
    /// <#Description#>
    public var objects: [T]
    
    /// <#Description#>
    public var count: Int {
        return objects.count
    }
    
    /// <#Description#>
    ///
    /// - Parameter position: <#position description#>
    public subscript(position: Int) -> T {
        return objects[position]
    }
    
    /// <#Description#>
    ///
    /// - Parameter element: <#element description#>
    public init(_ element: T) {
        self.objects = [element]
    }
    
    /// <#Description#>
    ///
    /// - Parameter objects: <#objects description#>
    public init(_ objects: [T]) {
        self.objects = objects
    }
    
}

public extension _PromiseResponse {
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    func sort(by value: (Element, Element) -> Bool) -> _PromiseResponse {
        return _PromiseResponse(self.objects.sorted(by: value))
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - predicateFormat: <#predicateFormat description#>
    ///   - args: <#args description#>
    /// - Returns: <#return value description#>
    func filter(_ predicateFormat: String, _ args: Any...) -> _PromiseResponse {
        let predicate = NSPredicate(format: predicateFormat, argumentArray: args)
        return self.filter(predicate)
    }
    
    /// <#Description#>
    ///
    /// - Parameter predicate: <#predicate description#>
    /// - Returns: <#return value description#>
    func filter(_ predicate: NSPredicate) -> _PromiseResponse {
        let newObjects = (self.objects as NSArray).filtered(using: predicate) as! [T]
        return _PromiseResponse(newObjects)
    }
    
}

