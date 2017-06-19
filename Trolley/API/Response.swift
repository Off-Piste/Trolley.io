//
//  Filter.swift
//  Pods
//
//  Created by Harry Wright on 30.05.17.
//
//

import Foundation
import PromiseKit

public extension Array where Element == Products {
    
    func filter(for text: String) -> [Element] {
        return self.filter { $0.name.contains(text) || $0.company.contains(text)}
    }
    
}

public extension Array where Element == SearchableProducts {
    
    func filter(for text: String) -> [Element] {
        return self.filter { $0.productName.contains(text) || $0.companyName.contains(text) }
    }
    
}

public typealias SearchResponse = _Response<SearchableProducts>

public typealias ProductResponse = _Response<Products>

public class _Response<T: NSObjectProtocol> : ExpressibleByArrayLiteral {
    
    /// <#Description#>
    public typealias Element = T
    
    /// <#Description#>
    public var objects: [T]
    
    internal var block: Any?
    
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
    
    /// <#Description#>
    ///
    /// - Parameter elements: <#elements description#>
    public required init(arrayLiteral elements: _Response.Element...) {
        self.objects = elements
    }
}

public extension _Response {
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    func sort(by value: (Element, Element) -> Bool) -> _Response {
        return _Response(self.objects.sorted(by: value))
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - predicateFormat: <#predicateFormat description#>
    ///   - args: <#args description#>
    /// - Returns: <#return value description#>
    func filter(_ predicateFormat: String, _ args: Any...) -> _Response {
        let predicate = NSPredicate(format: predicateFormat, argumentArray: args)
        return self.filter(predicate)
    }
    
    /// <#Description#>
    ///
    /// - Parameter predicate: <#predicate description#>
    /// - Returns: <#return value description#>
    func filter(_ predicate: NSPredicate) -> _Response {
        let newObjects = (self.objects as NSArray).filtered(using: predicate) as! [T]
        return _Response(newObjects)
    }
    
}

/**
 Extension to show the functions that only work for SearchableProducts;
 
 A devoloper can easier copy this and change `T == Products` if they wish
 to add `search(_:)` to `Products`
 */
public extension _Response where T == SearchableProducts {
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    func search(for value: String) -> _Response {
        let newObjects = self.objects.filter(for: value)
        return _Response(newObjects)
    }
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    func search(for value: String) -> Promise<[SearchableProducts]> {
        let promise = Promise { fullfill, reject in
            fullfill(self.objects.filter(for: value))
        }
        
        return promise
    }
    
}
