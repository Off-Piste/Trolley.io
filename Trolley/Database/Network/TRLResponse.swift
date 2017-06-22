//
//  Response.swift
//  Network
//
//  Created by Harry Wright on 19.06.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

import Foundation
import PromiseKit

public class Object: NSObject {
    
    var name: String
    
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
}

// Work it though alamofire
extension Object : ParameterEncoding {
    
    public func encode(
        _ urlRequest: URLRequestConvertible,
        with parameters: Parameters?
        ) throws -> URLRequest
    {
        let urlRequest = try urlRequest.asURLRequest()
        return urlRequest
    }
    
}

public enum _TRLResponse<T: NSObjectProtocol> {
    
    case response([T])
    
    case error(Error)
    
}

/** 
 These cannot be created by anyone outside our framework, 
 so the init's will be kept internal
 */
extension _TRLResponse {

    init(_ element: T) {
        self = .response([element])
    }
    
    init(_ elements: [T]) {
        self = .response(elements)
    }
    
    init(_ error: Error) {
        self = .error(error)
    }
    
}

public extension _TRLResponse {
    
    public var count: Int {
        switch self {
        case .response(let objects):
            return objects.count
        case .error:
            return 0
        }
    }
    
    var values: [T]? {
        switch self {
        case .response(let objects):
            return objects
        case .error:
            return nil
        }
    }
    
    var error: Error? {
        switch self {
        case .response:
            return nil
        case .error(let err):
            return err
        }
    }
    
    var containsResponse: Bool {
        return values != nil
    }
    
    var containsError: Bool {
        return !containsResponse
    }
    
}

extension _TRLResponse : Responsable {
    
    public typealias Element = T
    
    public func sort(by value: (Element, Element) -> Bool) -> _TRLResponse {
        switch self {
        case .error(_):
            return self
        case .response(let objects):
            return _TRLResponse(objects.sorted(by: value))
        }
    }
    
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

public extension Networkable {
    
    func responseObject(handler: @escaping (_TRLResponse<Object>) -> Void) {
        let error = InternalNetworkError.urlIsNil
        let response: _TRLResponse<Object> = _TRLResponse(error)
        handler(response)
    }
    
}
