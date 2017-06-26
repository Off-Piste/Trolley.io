//
//  TRLPromise.swift
//  Pods
//
//  Created by Harry Wright on 22.06.17.
//
//

import Foundation

public typealias TRLProductsPromise = _TRLPromise<Products>

public struct _TRLPromise<T: NSObjectProtocol> {
    
    public var objects: [T]
    
    internal init(_ objects: [T]) { self.objects = objects }
    
}

extension _TRLPromise : Responsable {
    
    public typealias Element = T
    
    public func sort(by value: (Element, Element) -> Bool) -> _TRLPromise {
        return _TRLPromise(objects.sorted(by: value))
    }
    
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
