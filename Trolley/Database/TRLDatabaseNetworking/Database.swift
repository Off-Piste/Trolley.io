//
//  Databases.swift
//  Pods
//
//  Created by Harry Wright on 22.05.17.
//
//

import Foundation

let kProductsDatabaseName: String = "products"
let kBasketDatabaseName: String = "basket"

@objc(TRLDatabase) public enum Database: Int {
    
    case products = 0, basket
    
    var name: String {
        switch self {
        case .products:
            return kProductsDatabaseName
        case .basket:
            return kBasketDatabaseName
        }
    }
}
