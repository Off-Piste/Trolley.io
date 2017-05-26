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
extension _Basket where P == Products {
    
    /// <#Description#>
    ///
    /// - Parameter json: <#json description#>
    public init(json: JSON) {
        self.init(indexes: json.products)
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
            CLLocationManager.promise()
                .then { ShippingManager.reverseGeocode(for: $0) }
                .then { fullfill($0) }
                .catch { reject($0) }
        }
        
    }

}
