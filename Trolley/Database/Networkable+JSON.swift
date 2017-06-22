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

//public extension Networkable {
//    
//    /// Method to return the JSON response from the server using Promise Kit
//    ///
//    /// - Returns: Promise with value of `JSON`,
//    ///   check [Promise Kit](https://github.com/mxcl/PromiseKit) on how to use
//    func JSON() -> Promise<JSON> {
//        return Promise { fullfil, rejct in
//            self.default().then { item -> Void in
//                let json = SwiftyJSON.JSON(item)
//                fullfil(json)
//            }.catch { error in
//                rejct(error)
//            }
//        }
//    }
//    
//    /// Method to return the Products response from the server using Promise Kit.
//    ///
//    /// To get the array of products, the `.products` property from the JSON is used
//    ///
//    /// - Returns: Promise with the value of `[Products]`
//    ///   check [Promise Kit](https://github.com/mxcl/PromiseKit) on how to use
//    func products() -> Promise<[Products]> {
//        return Promise { fullfill, reject in
//            self.JSON().then { json -> Void in
//                fullfill(json.products)
//            }.catch { error in
//                reject(error)
//            }
//        }
//    }
//    
//    /// <#Description#>
//    ///
//    /// - Returns: <#return value description#>
//    func product() -> Promise<Products> {
//        return Promise { fullfill, reject in
//            self.JSON().then { json -> Void in
//                guard let product = Products(JSON: json) else {
//                    throw NetworkableError.initFailed(
//                        for: Products.self,
//                        withInput: json
//                    )
//                }
//                
//                fullfill(product)
//            }.catch { error in
//                reject(error)
//            }
//        }
//    }
//    
//}
//
//public typealias JSONResponse = (JSON, Error?) -> Void
//
//public typealias ProductsHandler = ([Products]?, Error?) -> Void
//
//public typealias ProductHandler = (Products?, Error?) -> Void
//
//// MARK: Closure Networkable EXT
//
//public extension Networkable {
//    
//    /// The Method to return the `JSON` from our server using closures
//    ///
//    /// - Parameter handler: `(JSON, Error?)` JSON will be JSON.null if empty
//    func JSON(handler: @escaping JSONResponse) {
//        self.JSON().then { json -> Void in
//            handler(json, nil)
//        }.catch { (error) in
//            handler(SwiftyJSON.JSON.null, error)
//        }
//    }
//    
//    /// The Method to return the array of `[Products]` from our server using closures
//    ///
//    /// - Parameter handler: `([Products]?, Error?)`
//    func products(handler: @escaping ProductsHandler) {
//        self.products().then { products -> Void in
//            handler(products, nil)
//        }.catch { error in
//            handler(nil, error)
//        }
//    }
//    
//    /// <#Description#>
//    ///
//    /// - Parameter handler: <#handler description#>
//    func product(handler: @escaping ProductHandler) {
//        self.product().then { product -> Void in
//            handler(product, nil)
//        }.catch { error in
//            handler(nil, error)
//        }
//    }
//
//    
//}
