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
    
    fileprivate var internalManagerInfo: TRLNetworkManagerInfo
    
    public init(withKey key: String, isLocal: Bool = false) {
        self.shopKey = key
        
        self.internalManagerInfo = TRLNetworkManagerInfo(
            host: kOldBaseURL,
            internalHost: kLocalHostURL,
            isLocal: isLocal
        )
        
    }
    
    public func fetch(_ items: Databases) -> Networkable {
        let parameters = ["key" : self.shopKey]
        let request = Alamofire.request(
                internalManagerInfo.addNode(items.name).connectionURL,
                parameters: parameters
            )
        let response = request.validate().response()
        return TRLResponse(promise: response)
    }
    
    public func post(_ items: Any, to database: Databases) -> Networkable {
        let param = ["key" : self.shopKey]
        let request = Alamofire.request(
            internalManagerInfo.addNode(database.name).connectionURL,
            parameters: param
        )
        let response = request.validate().response()
        return TRLResponse(promise: response)
    }
    
    public func postData(_ data: Any, to database: Databases) -> Networkable {
        let param = ["key" : self.shopKey]
        let request = Alamofire.request(
            internalManagerInfo.addNode(database.name).connectionURL,
            parameters: param
        )
        let response = request.validate().response()
        return TRLResponse(promise: response)
    }
    
}
