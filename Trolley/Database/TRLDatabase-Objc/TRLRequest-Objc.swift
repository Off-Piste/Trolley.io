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
        let promise = Promise<Any> { fullfill, reject in
            self.responseJSON(handler: { (json, error) in
                if error != nil {
                    reject(error!)
                } else {
                    if json.arrayObject == nil || json.dictionaryObject == nil {
                        reject(createError("JSON is nil for [\(json.rawString() ?? "")]"))
                    } else {
                        if json.dictionaryObject != nil { fullfill(json.dictionaryObject!) }
                        else if json.arrayObject != nil { fullfill(json.arrayObject!) }
                        else { fatalError("JSON Error") }
                    }
                }
            })
        }
        
        return AnyPromise(promise)
    }
    
    @objc(responseJSONArray:)
    func responseJSONArray(withBlock block:@escaping ([Any], Error?) -> Void) {
        self.responseJSON(handler: { (json, error) in
            if error != nil { block([], error); return }
            if json.arrayObject == nil {
                block([], createError("Dictionary is nil for [\(json.rawString() ?? "")]"))
            } else {
                block(json.arrayObject!, nil)
            }
            
        })
    }
    
    @objc(responseJSONDictionary:)
    func responseJSONDictionary(withBlock block:@escaping ([String : Any], Error?) -> Void) {
        self.responseJSON(handler: { (json, error) in
            if error != nil { block([:], error); return }
            if json.dictionaryObject == nil {
                block([:], createError("Dictionary is nil for [\(json.rawString() ?? "")]"))
            } else {
                block(json.dictionaryObject!, nil)
            }
            
        })
    }
    
}
