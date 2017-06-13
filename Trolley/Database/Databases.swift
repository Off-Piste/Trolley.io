//
//  Databases.swift
//  Pods
//
//  Created by Harry Wright on 22.05.17.
//
//

import Foundation

//enum Path {
//    case database(Databases)
//    case search(Databases)
//    
//    init(_ database: Databases) {
//        switch self {
//        case .database(.basket) :
//            self = .database(.basket)
//        }
//    }
//}

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
