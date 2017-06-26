//
//  SwiftyJSON+Ext.swift
//  Pods
//
//  Created by Harry Wright on 22.05.17.
//
//

import Foundation
import SwiftyJSON

extension JSON {
    
    /// Property to turn the JSON into an array of products
    public var products: [Products] {
        
        // Not required now, but maybe useful later on so will keep commented 
        // for now.
        //
        // It will be needed for when searching as that has an empty rawArray,
        // so will not call the flatMap propery as it will have an empty value.
        //
        // if self.arrayValue.count == 0 {
        //     return (Products(JSON: self) != nil) ? [Products(JSON: self)!] : []
        // }
        
        return arrayValue.flatMap { return try? Products(json: $0) }
    }
    
}
