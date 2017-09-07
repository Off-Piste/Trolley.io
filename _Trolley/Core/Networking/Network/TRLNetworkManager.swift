//
//  NetworkManager.swift
//  Network
//
//  Created by Harry Wright on 19.06.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

import Foundation
import Alamofire

let kLocalURL: String = "http://localhost:8080/API"
let kLocalIPURL: String = "http://127.0.0.1:8080/API"

extension String {

    static func urlRoute(for items: String...) -> String {
        return items.joined(separator: "/")
    }

}

/// <#Description#>
@objc public class TRLNetworkManager : NSObject {

    var network: TRLNetwork

    var error: Error?
    
    var url: URLConvertible? {
        return network.parsedURL.url
    }
    
    var connectionURL: URLConvertible {
        return network.parsedURL.webSocketURL
    }

    internal init(network: TRLNetwork, key: String) {
        self.network = network
        self.network.parsedURL._addPath(key)
    }

    internal init(_ url: URLConvertible, key: String) throws {
        self.network = try TRLNetwork(url)
        self.network.parsedURL._addPath(key)
    }

    @available(*, unavailable, renamed: "init(_:key:)")
    internal init?(url: URLConvertible, key: String) {
        TRLCoreNetworkingLogger.info("Please use `init(_:key:) throws` instead")
        return nil
    }

}

/** 
 Deprecations
 */
extension TRLNetworkManager {
    
    @available(*, unavailable, message: "nil")
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        fatalError("Nil")
    }
    
    @available(*, unavailable, message: "nil")
    public override func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions = [], context: UnsafeMutableRawPointer?) {
        fatalError("Nil")
    }
    
    @available(*, unavailable, message: "nil")
    public override func removeObserver(_ observer: NSObject, forKeyPath keyPath: String) {
        fatalError("Nil")
    }
    
    @available(*, unavailable, message: "nil")
    public override func removeObserver(_ observer: NSObject, forKeyPath keyPath: String, context: UnsafeMutableRawPointer?) {
        fatalError("Nil")
    }
    
}

extension TRLNetworkManager {

    public override var description: String {
        return self.network.parsedURL.description
    }

}

public extension TRLNetworkManager {

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - route: <#route description#>
    ///   - parameters: <#parameters description#>
    ///   - encoding: <#encoding description#>
    ///   - headers: <#headers description#>
    /// - Returns: <#return value description#>
    func get(
        _ route: String,
        with parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?
        ) -> TRLRequest
    {
        return self.network.get(route, with: parameters, encoding: encoding, headers: headers)
    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - item: <#item description#>
    ///   - route: <#route description#>
    ///   - parameters: <#parameters description#>
    ///   - encoding: <#encoding description#>
    ///   - headers: <#headers description#>
    /// - Returns: <#return value description#>
    func get(
        item: String,
        in route: String,
        with parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?
        ) -> TRLRequest
    {
        let route = String.urlRoute(for: route, item)
        return self.network.get(route, with: parameters, encoding: encoding, headers: headers)
    }
    
}

// TODO: Add Post/Put/Delete

extension TRLNetworkManager {

}
