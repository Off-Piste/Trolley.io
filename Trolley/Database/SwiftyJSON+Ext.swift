//
//  SwiftyJSON+Ext.swift
//  Pods
//
//  Created by Harry Wright on 22.05.17.
//
//

import Foundation
import SwiftyJSON

extension Products {
    
    /// Convenience init to use SwiftyJSON and to call the `init(JSONData:)` initaliser
    ///
    /// - Parameter json: SwiftyJSON
    public convenience init?(JSON json: JSON) {
        guard json != JSON.null,
            let dict = json.dictionaryObject
            else {
                return nil
        }
        
        self.init(JSONData: dict)
    }
    
}

extension JSON {
    
    /// Property to turn the JSON into an array of products
    public var products: [Products] {
        return arrayValue.flatMap { return Products(JSON: $0) }
    }
    
}
