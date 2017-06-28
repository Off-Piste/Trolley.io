//
//  Response.swift
//  Network
//
//  Created by Harry Wright on 19.06.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

import Foundation
//import PromiseKit

//public class Object: NSObject {
//    
//    var name: String
//    
//    var age: Int
//    
//    init(name: String, age: Int) {
//        self.name = name
//        self.age = age
//    }
//    
//}
//
//// Work it though alamofire
//extension Object : ParameterEncoding {
//    
//    public func encode(
//        _ urlRequest: URLRequestConvertible,
//        with parameters: Parameters?
//        ) throws -> URLRequest
//    {
//        let urlRequest = try urlRequest.asURLRequest()
//        return urlRequest
//    }
//    
//}

/// <#Description#>
///
/// - response: <#response description#>
/// - error: <#error description#>
public enum _TRLResponse<T: NSObjectProtocol> {
    
    case response([T])
    
    case error(Error)
    
}

/** 
 These cannot be created by anyone outside our framework, 
 so the init's will be kept internal
 */
extension _TRLResponse {

    /// <#Description#>
    ///
    /// - Parameter element: <#element description#>
    init(_ element: T) {
        self = .response([element])
    }
    
    /// <#Description#>
    ///
    /// - Parameter elements: <#elements description#>
    init(_ elements: [T]) {
        self = .response(elements)
    }
    
    /// <#Description#>
    ///
    /// - Parameter error: <#error description#>
    init(_ error: Error) {
        self = .error(error)
    }
    
}

public extension _TRLResponse {
    
    /// <#Description#>
    public var count: Int {
        switch self {
        case .response(let objects):
            return objects.count
        case .error:
            return 0
        }
    }
    
    /// <#Description#>
    var values: [T]? {
        switch self {
        case .response(let objects):
            return objects
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

extension _TRLResponse : Responsable {
    
    /// <#Description#>
    public typealias Element = T
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    public func sort(by value: (Element, Element) -> Bool) -> _TRLResponse {
        switch self {
        case .error(_):
            return self
        case .response(let objects):
            return _TRLResponse(objects.sorted(by: value))
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter predicate: <#predicate description#>
    /// - Returns: <#return value description#>
    public func filter(_ predicate: NSPredicate) -> _TRLResponse {
        switch self {
        case .error:
            return self
        case .response(let objects):
            let newObjects = (objects as NSArray).filtered(using: predicate) as! [T]
            return _TRLResponse(newObjects)
        }
    }
    
}

