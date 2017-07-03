//
//  TRLNetworkManagerExt-Objc.swift
//  Pods
//
//  Created by Harry Wright on 03.07.17.
//
//

import Foundation
import PromiseKit
import SwiftyJSON

@available(swift, introduced: 1.0, obsoleted: 1.0)
public extension TRLRequest {
    
    // MARK: Obj-C | JSON
    
    @objc(responseJSON)
    func responseJSONPromise() -> AnyPromise {
        let promise = Promise<[String : Any]> { fullfill, reject in
            self.responseJSON(handler: { (json, error) in
                if error != nil {
                    reject(error!)
                } else {
                    if json.dictionaryObject == nil {
                        reject(createError("Dictionary is nil for [\(json.rawString() ?? "")]"))
                    } else {
                        fullfill(json.dictionaryObject!)
                    }
                }
            })
        }
        
        return AnyPromise(promise)
    }
    
    @objc
    func responseJSON(withBlock block:@escaping ([String : Any], Error?) -> Void) {
        self.responseJSON(handler: { (json, error) in
            if error != nil { block([:], error); return }
            if json.dictionaryObject == nil {
                block([:], createError("Dictionary is nil for [\(json.rawString() ?? "")]"))
            } else {
                block(json.dictionaryObject!, nil)
            }
            
        })
    }
    
    // MARK: Obj-C | JSON -> Array of Products
    
    @objc(responseProducts)
    func responseProductsPromise() -> AnyPromise {
        let promise = Promise<Array<Products>> { fullfill, reject in
            self.responseProducts(handler: { (response) in
                switch response {
                case .error(let error):
                    reject(error)
                case .response(let objects):
                    fullfill(objects)
                }
            })
        }
        
        return AnyPromise(promise)
    }
    
    @objc
    func responseProducts(withBlock block: @escaping ([Products], Error?) -> Void) {
        self.responseProducts(handler: { (response) in
            switch response {
            case .error(let error):
                block([], error)
            case .response(let objects):
                block(objects, nil)
            }
        })
    }
    
    
}
