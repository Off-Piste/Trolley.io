//
//  Networkable+Exts.swift
//  Pods
//
//  Created by Harry Wright on 22.05.17.
//
//

import PromiseKit
import SwiftyJSON

// MARK: Promises Networkable EXT

public extension Networkable {
    
    /// Method to return the JSON response from the server using Promise Kit
    ///
    /// - Returns: Promise with value of `JSON`,
    ///   check [Promise Kit](https://github.com/mxcl/PromiseKit) on how to use
    func responseJSON() -> Promise<JSON> {
        return Promise { fullfil, rejct in
            self.response().then { item -> Void in
                let json = JSON(item)
                fullfil(json)
            }.catch { error in
                rejct(error)
            }
        }
    }
    
    /// Method to return the Products response from the server using Promise Kit.
    ///
    /// To get the array of products, the `.products` property from the JSON is used
    ///
    /// - Returns: Promise with the value of `[Products]`
    ///   check [Promise Kit](https://github.com/mxcl/PromiseKit) on how to use
    func responseProducts() -> Promise<[Products]> {
        return Promise { fullfill, reject in
            self.responseJSON().then { json -> Void in
                fullfill(json.products)
            }.catch { error in
                reject(error)
            }
        }
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func responseProduct() -> Promise<Products> {
        return Promise { fullfill, reject in
            self.responseJSON().then { json -> Void in
                guard let product = Products(JSON: json) else {
                    throw NetworkableError.initFailed(
                        for: Products.self,
                        withInput: json
                    )
                }
                
                fullfill(product)
            }.catch { error in
                reject(error)
            }
        }
    }
    
}

public typealias JSONResponse = (JSON, Error?) -> Void

public typealias ProductsResponse = ([Products]?, Error?) -> Void

public typealias ProductResponse = (Products?, Error?) -> Void

// MARK: Closure Networkable EXT

public extension Networkable {
    
    /// The Method to return the `JSON` from our server using closures
    ///
    /// - Parameter handler: `(JSON, Error?)` JSON will be JSON.null if empty
    func responseJSON(handler: @escaping JSONResponse) {
        self.responseJSON().then { json -> Void in
            handler(json, nil)
        }.catch { (error) in
            handler(JSON.null, error)
        }
    }
    
    /// The Method to return the array of `[Products]` from our server using closures
    ///
    /// - Parameter handler: `([Products]?, Error?)`
    func responseProducts(handler: @escaping ProductsResponse) {
        self.responseProducts().then { products -> Void in
            handler(products, nil)
        }.catch { error in
            handler(nil, error)
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter handler: <#handler description#>
    func responseProduct(handler: @escaping ProductResponse) {
        self.responseProduct().then { product -> Void in
            handler(product, nil)
            }.catch { error in
                handler(nil, error)
        }
    }

    
}
