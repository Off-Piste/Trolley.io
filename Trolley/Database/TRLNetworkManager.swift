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

let kOldBaseURL: String = "trolley-io.eu-gb.mybluemix.net/API"
let kLocalHostURL: String = "localhost:8080/API"

public struct TRLNetworkManager {
    
    fileprivate var shopKey: String
    
    var internalManagerInfo: TRLNetworkManagerInfo
    
    public init(withKey key: String, isLocal: Bool = false) {
        self.shopKey = key
        
        self.internalManagerInfo = TRLNetworkManagerInfo(
            isLocal: isLocal,
            internalHost: kLocalHostURL,
            host: kOldBaseURL
        )
    }
    
    public func fetch(_ items: Databases) -> Networkable {
        let request = Alamofire.request(
            internalManagerInfo
                .connectionURL
                .addDatabase(items)
            ).validate()
        let response = request.response()
        return TRLResponse(promise: response)
    }
    
}
