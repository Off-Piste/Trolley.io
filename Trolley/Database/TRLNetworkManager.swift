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

public struct TRLNetworkManager {
    
    fileprivate var shopKey: String
    
    public init(withKey key: String, isLocal: Bool = false) {
        self.shopKey = key
        _TRLInternalManager.shared.isLocal = isLocal
    }
    
    public func fetch(_ items: Databases) -> Networkable {
        guard let url = URL(baseURL: kOldBaseURL, route: items.name, key: shopKey) else {
            fatalError("Invaid URL")
        }
        
        let request = Alamofire.request(url)
        let response = request.response()
        return TRLResponse(promise: response)
    }
    
}
