//
//  Networkable+Exts.swift
//  Pods
//
//  Created by Harry Wright on 22.05.17.
//
//

import PromiseKit
import SwiftyJSON

public extension Networkable {
    
    // MARK: JSON
    
    /// <#Description#>
    ///
    /// - Parameter handler: <#handler description#>
    func responseJSON(handler: @escaping (JSON, Error?) -> Void) {
        self.responseData { (data, error) in
            if data == nil, error != nil {
                handler(JSON.null, error)
            } else {
                handler(JSON(data: data!), nil)
            }
        }
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func responseJSON() -> Promise<JSON> {
        return Promise { fullfill, reject in
            self.responseData()
                .then { fullfill(JSON($0)) }
                .catch { reject($0) }
        }
    }
    
    // MARK: JSON -> Array of Products
    
    /// <#Description#>
    ///
    /// - Parameter handler: <#handler description#>
    func responseProducts(handler: @escaping (_TRLResponse<Products>) -> Void) {
        self.responseJSON { (json, err) in
            let response: _TRLResponse<Products>
            if json == JSON.null, err != nil {
                response = _TRLResponse(err!)
                handler(response)
            } else {
                response = _TRLResponse(json.products)
                handler(response)
                
            }
        }
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func responseProducts() -> Promise<TRLProductsPromise> {
        return Promise { fullfill, reject in
            self.responseJSON().then {
                fullfill(TRLProductsPromise($0.products))
                }.catch {
                    reject($0)
            }
        }
    }
    
    // MARK: Single Product
    
    /// <#Description#>
    ///
    /// - Parameter handler: <#handler description#>
    func responseProduct(handler: @escaping (Products?, Error?) -> Void) {
        self.responseProducts { (response) in
            switch response {
            case .response(let objects):
                if objects.count > 1 { handler(nil, createError("To Many Products Downloaded")) }
                if objects.count == 0 { handler(nil, createError("Product is empty")) }
                handler(objects.first!, nil)
            case .error(let err):
                handler(nil, err)
            }
        }
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func responseProduct() -> Promise<Products> {
        return Promise { fullfill, reject in
            self.responseJSON().then { json -> Void in
                if json.arrayValue.count > 1 { throw createError("To Many Products Downloaded") }
                if json.arrayValue.count == 0 { throw createError("Product is empty") }
                fullfill(json.products.first!)
                }.catch {
                    reject($0)
            }
        }
    }
    
}
