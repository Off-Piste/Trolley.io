//
//  Core+Exts.swift
//  Pods
//
//  Created by Harry Wright on 25.05.17.
//
//

import Foundation
import SwiftyJSON
import PromiseKit
import CoreLocation

/**



 */
public extension _Basket where P == Product {

    /// <#Description#>
    ///
    /// - Parameter json: <#json description#>
    public init(json: JSON) {
        self.init(indexes: json.products)
    }

    mutating func add(_ element: Element, withQuantity q: Int) -> Promise<_Basket> {
        return Promise { fullfill, reject in
//            Trolley.shared.networkManager
//                .post(element, to: .basket)
//                .responseJSON()
//                .then { json -> Void in
//                    // validate response
//
//                    // Needed to build
//                    DispatchQueue.default.sync {
//                        for _ in 0...q {
//                            self.append(element)
//                        }
//                        fullfill(self)
//                    }
//            }.catch { (error) in
//                reject(error)
//            }
        }
    }

    mutating func add(_ element: Element, withQuantity q: Int, handler: @escaping (_Basket, Error?) -> Void) {
        self.add(element, withQuantity: q).then { newBasket -> Void in
            handler(newBasket, nil)
        }.catch { (error) in
            DispatchQueue.default.sync {
                handler(self, error)
            }
        }
    }

}

public extension Product {

    /// To save writing out `TRLNetworkManager.shared`
    /// everytime. **LAZY IS KEY**
    private static var networkManager: TRLNetworkManager {
        return TRLNetworkManager.shared
    }

    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    class func getAll() -> ProductsPromise {
        return self.networkManager.get(.products).responseProducts()
    }

    /// <#Description#>
    ///
    /// - Parameter id: <#id description#>
    /// - Returns: <#return value description#>
    class func getProduct(with id: String) -> Promise<Product> {
        return self.networkManager.get(id, in: .products).responseProduct()
    }

}
