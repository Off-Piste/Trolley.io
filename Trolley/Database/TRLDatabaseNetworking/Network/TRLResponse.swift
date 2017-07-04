//
//  Response.swift
//  Network
//
//  Created by Harry Wright on 19.06.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

import Foundation

typealias TRLProductsResponse = _TRLDefaultResponse<Product>

/// <#Description#>
///
/// - response: <#response description#>
/// - error: <#error description#>
public enum _TRLDefaultResponse<T: NSObjectProtocol> {
    
    // why use `_PromiseResponse`? Well it is the
    // exact same as `_TRLDefaultResponse` but the
    // value is never nil so will never
    // have any issues, also makes it easier for
    // me to justify having both
    case response(_PromiseResponse<T>)
    
    case error(Error)
    
}

/** 
 These cannot be created by anyone outside our framework, 
 so the init's will be kept internal
 */
extension _TRLDefaultResponse {

    /// <#Description#>
    ///
    /// - Parameter element: <#element description#>
    init(_ element: T) {
        let response = _PromiseResponse(element)
        self = .response(response)
    }
    
    /// <#Description#>
    ///
    /// - Parameter elements: <#elements description#>
    init(_ elements: [T]) {
        let response = _PromiseResponse(elements)
        self = .response(response)
    }
    
    /// <#Description#>
    ///
    /// - Parameter error: <#error description#>
    init(_ error: Error) {
        self = .error(error)
    }
    
    init(_ core: _PromiseResponse<T>) {
        self = .response(core)
    }
    
}

public extension _TRLDefaultResponse {
    
    /// <#Description#>
    public var count: Int {
        switch self {
        case .response(let rawres):
            return rawres.count
        case .error:
            return 0
        }
    }
    
    /// <#Description#>
    var values: [T]? {
        switch self {
        case .response(let rawres):
            return rawres.objects
        case .error:
            return nil
        }
    }
    
    /// <#Description#>
    var error: Error? {
        switch self {
        case .response:
            return nil
        case .error(let err):
            return err
        }
    }
    
    /// <#Description#>
    var containsResponse: Bool {
        return values != nil
    }
    
    /// <#Description#>
    var containsError: Bool {
        return !containsResponse
    }
    
}

extension _TRLDefaultResponse : Responsable {
    
    /// <#Description#>
    public typealias Element = T
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    public func sort(by value: (Element, Element) -> Bool) -> _TRLDefaultResponse {
        switch self {
        case .error(_):
            return self
        case .response(let rawres):
            return _TRLDefaultResponse(rawres.sort(by: value))
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter predicate: <#predicate description#>
    /// - Returns: <#return value description#>
    public func filter(_ predicate: NSPredicate) -> _TRLDefaultResponse {
        switch self {
        case .error:
            return self
        case .response(let rawres):
            return _TRLDefaultResponse(rawres.filter(predicate))
        }
    }
    
}

