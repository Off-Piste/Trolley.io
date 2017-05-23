//
//  Databases.swift
//  Pods
//
//  Created by Harry Wright on 22.05.17.
//
//

import Foundation

public enum Databases {
    
    case products
    case basket
    
    var name: String {
        switch self {
        case .products:
            return kProductsDatabaseName
        case .basket:
            return kBasketDatabaseName
        }
    }
}
