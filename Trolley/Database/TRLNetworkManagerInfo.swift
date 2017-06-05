//
//  TRLInternalManager.swift
//  Pods
//
//  Created by Harry Wright on 22.05.17.
//
//

import Foundation

// MARK: New API

// https://powerplay.trolley.io.com
// https://<shop name>.<base url>/<database> <- The items in database
// https://<shop name>.<base url> <- Returns all databases

// MARK: Old API

// https://<base url>/api/<route>?key=<APIKey>

let kShopName: String = "default"
let kBaseURl: String = "trolleyio.com"
let kProductsDatabaseName: String = "products"
let kBasketDatabaseName: String = "basket"
let kKeyQuery: String = "?key="

// TODO: Move to another location
struct TRLNetworkManagerInfo: CustomStringConvertible {
    
    fileprivate var isLocal: Bool
    
    fileprivate var secure: Bool {
        return !isLocal
    }
    
    fileprivate var internalHost: String
    
    fileprivate var host: String
    
    fileprivate var route: String = ""
    
    init(host: String, internalHost: String, isLocal: Bool, route: String = "") {
        self.host = host
        self.internalHost = internalHost
        self.isLocal = isLocal
        self.route = route
    }
    
    func addNode(_ node: String) -> TRLNetworkManagerInfo {
        let route = "\(self.route)/\(node)"
        return TRLNetworkManagerInfo(
            host: self.host,
            internalHost: self.internalHost,
            isLocal: self.isLocal,
            route: route
        )
    }
    
    var connectionURL: URL {
        guard let url = URL(TRLNetworkMangerInfo: self) else {
            fatalError("Invalid url - \(self.description)")
        }
        
        return url
    }
    
    var description: String {
        return "http\(secure ? "s" : "")://" +
            (isLocal ? internalHost : host) +
            (route.isEmpty ? "" : "/" + route)
    }
}

extension URL {
    
    init?(TRLNetworkMangerInfo nm: TRLNetworkManagerInfo) {
        let url = "http\(nm.secure ? "s" : "")://"
            + (nm.isLocal ? nm.internalHost : nm.host) +
            (nm.route.isEmpty ? "" : nm.route)
        
        self.init(string: url)
    }
    
}
