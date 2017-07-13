//
//  BasicNetworking.swift
//  Trolley
//
//  Created by Harry Wright on 13.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Ardex
import Trolley

class BasicNetworking {
    
    class func downloadProducts(handler: @escaping ([Product], Error?) -> Void) {
        TRLNetworkManager.shared.get(.products).validate().responseJSON { (json, error) in
            if let error = error {
                handler([], error)
            } else {
                let products = json.arrayValue.flatMap { try? Product(json: $0) }
                handler(products, nil)
            }
        }
    }
    
}
