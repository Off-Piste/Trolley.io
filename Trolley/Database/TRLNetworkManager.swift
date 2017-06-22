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

public struct TRLNetworkManager {
    
    var network: TRLNetwork
    
    internal init(network: TRLNetwork, key: String) {
        self.network = network
        self.network.parsedURL._addPath(key)
    }
    
    internal init(_ url: URLConvertible, key: String) throws {
        self.network = try TRLNetwork(url)
        self.network.parsedURL._addPath(key)
    }
    
    internal init?(url: URLConvertible, key: String) {
        do {
            self.network = try TRLNetwork(url)
            self.network.parsedURL._addPath(key)
        } catch {
            return nil
        }
    }
    
}

extension TRLNetworkManager : CustomStringConvertible {
    
    public var description: String {
        return self.network.parsedURL.description
    }
    
}

public extension TRLNetworkManager {
    
    func get(
        _ route: String,
        with parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil
        ) -> TRLRequest
    {
        return self.network.get(route, with: parameters, encoding: encoding, headers: headers)
    }
    
    func get(
        item: String,
        in route: String,
        with parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil
        ) -> TRLRequest
    {
        let route = String.urlRoute(for: route, item)
        return self.network.get(route, with: parameters, encoding: encoding, headers: headers)
    }
    
}

// TODO: Make sure this works

public extension TRLNetworkManager {
    
    func post(
        _ object: Object,
        in route: String,
        with parameters: Parameters = [:],
        headers: HTTPHeaders? = [:]
        ) -> TRLRequest
    {
        return self.network.post(route, with: parameters, encoding: object, headers: headers)
    }
    
}
