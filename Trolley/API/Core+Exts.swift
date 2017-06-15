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
public extension _Basket where P == Products {
    
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

public extension Products {
    
    /// To save writing out `Trolley.shared.networkManager`
    /// everytime. **LAZY IS KEY**
    private static var networkManager: TRLNetworkManager {
        return Trolley.shared.networkManager
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    class func getAll() -> Promise<[Products]> {
        return networkManager.get(.products).responseProducts()
    }
    
    /// <#Description#>
    ///
    /// - Parameter id: <#id description#>
    /// - Returns: <#return value description#>
    class func getProduct(with id: String) -> Promise<Products> {
        return networkManager.get(item: id, in: .products).responseProduct()
    }
    
}

extension ShippingManager {
    
    public static func reverseGeocode(for loc: CLLocation) -> Promise<CLPlacemark> {
        return Promise { fullfill, reject in
            CLGeocoder().reverseGeocode(location: loc)
                .then { loc -> Void in
                    self.shared.postalCode = loc.postalCode;
                    fullfill(loc)
                }
                .catch { reject($0) }
        }
    }

}

fileprivate let kQueue = DispatchQueue(
    label: "io.trolley",
    qos: .userInitiated,
    attributes: .concurrent
)

let kCLLocation = CLLocation(latitude: 0, longitude: 0)

extension LocationManager {
    
    public static func promise() -> Promise<CLPlacemark> {
        return Promise { fullfill, reject in
            OperationQueue.main.addOperation {
                CLLocationManager.promise()
                    .then { ShippingManager.reverseGeocode(for: $0) }
                    .then { fullfill($0) }
                    .catch { reject($0) }
            }
        }
        
    }

}
