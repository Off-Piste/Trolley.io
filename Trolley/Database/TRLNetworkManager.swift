//
//  NetworkManager.swift
//  Pods
//
//  Created by Harry Wright on 22.05.17.
//
//

import Foundation
import PromiseKit
import Alamofire

// TODO: Work with new API
// TODO: New Get/Post/Delete/Put Methods

let kOldBaseURL: String = "trolley-io.eu-gb.mybluemix.net/API"
let kLocalHostURL: String = "localhost:8080/API"

extension String {
    
    static func urlRoute(for items: String...) -> String {
        return items.joined(separator: "/")
    }
    
}

public struct TRLNetworkManager {
    
    fileprivate(set) public var network: TRLNetwork
    
    public init(network: TRLNetwork) {
        self.network = network
    }
    
}

public extension TRLNetworkManager {
    
    func get(_ database: Database, with parameters: Parameters = [:]) -> TRLResponse {
        return self.network.get(database, with: parameters)
    }
    
    func get(_ route: String, with parameters: Parameters = [:]) -> TRLResponse {
        return self.network.get(route, with: parameters)
    }
    
    func get(item: String, in db: Database, with parameters: Parameters = [:]) -> TRLResponse {
        let route = String.urlRoute(for: db.name, item)
        return self.network.get(route, with: parameters)
    }
    
}
