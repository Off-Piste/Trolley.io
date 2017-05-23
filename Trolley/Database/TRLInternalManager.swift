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
let kOldBaseURL: String = (_TRLInternalManager.shared.isLocal ?
    "localhost:8080/API" :
    "trolley-io.eu-gb.mybluemix.net/API"
)
let kProductsDatabaseName: String = "products"
let kBasketDatabaseName: String = "basket"
let kKeyQuery: String = "?key="

// TODO: Move to another location
struct _TRLInternalManager {
    
    static var shared = _TRLInternalManager()
    
    var isLocal: Bool = false
    
}
