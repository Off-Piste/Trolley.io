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
    
    var isLocal: Bool
    
    var secure: Bool {
        return !isLocal
    }
    
    var internalHost: String
    
    var host: String
    
    var connectionURL: URL {
        guard let url = URL(TRLNetworkMangerInfo: self) else {
            fatalError("Invalid url - \(self.description)")
        }
        
        return url
    }
    
    var description: String {
        return "http\(secure ? "" : "s")://" + (isLocal ? internalHost : host)
    }
}

extension URL {
    
    init?(TRLNetworkMangerInfo nm: TRLNetworkManagerInfo) {
        let url = "http\(nm.secure ? "" : "s")://" + (nm.isLocal ? nm.internalHost : nm.host)
        self.init(string: url)
    }
    
    func addDatabase(_ database: Databases) -> URL {
        let baseURL = self.absoluteString
        guard let fullURL = URL(string: baseURL + "/" + database.name) else {
            fatalError("Invalid URL")
        }
        
        return fullURL
    }
    
}
