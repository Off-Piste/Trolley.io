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
    
    public func fetch(_ db: Databases) -> Networkable {
        let parameters = ["key" : self.shopKey]
        let request = Alamofire.request(
                internalManagerInfo.addNode(db.name).connectionURL,
                parameters: parameters
            )
        let response = request.validate().response()
        return TRLResponse(promise: response)
    }
    
    // TODO: - Change Name
    
    internal func fetchItem(with id: String, from db: Databases) -> Networkable {
        let parameters = ["key" : self.shopKey, "item_id": id]
        let request = Alamofire.request(
            internalManagerInfo.addNode(db.name).connectionURL,
            parameters: parameters
        )
        let response = request.validate().response()
        return TRLResponse(promise: response)
    }
    
    // MARK:
    
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
