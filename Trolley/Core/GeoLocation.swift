//
//  GeoLocation.swift
//  Pods
//
//  Created by Harry Wright on 25.04.17.
//
//

import Foundation
import CoreLocation

/**
 
 */
extension Notification.Name {
    
    ///
    static let locationFound = Notification.Name("location-found")
    
    /// <#Description#>
    public static let postcodeFound = Notification.Name("postcode-found")
    
    /// <#Description#>
    public static let shippingCalculated = Notification.Name("shipping-calculated")
    
}

/**
 
 */
class ShippingManager {
    
    /// <#Description#>
    static let shared = ShippingManager()
    
    /// <#Description#>
    private let center = NotificationCenter.default
    
    /// <#Description#>
    public internal(set) var shippingDict = [String : Money]()
    
    /// <#Description#>
    public private(set) var postalCode: String? {
        didSet {
            shippingPrice = calculateShipping(for: postalCode!)
        }
    }
    
    /// <#Description#>
    public private(set) var shippingPrice: Money? {
        didSet {
            center.post(name: .shippingCalculated, object: self.shippingPrice)
        }
    }
    
    /// <#Description#>
    private init() {
        center.addObserver(forName: .postcodeFound, object: nil, queue: nil) { (notif) in
            self.postalCode = (notif.object! as! String)
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter postcode: <#postcode description#>
    /// - Returns: <#return value description#>
    func calculateShipping(for postcode: String) -> Money {
        let (sucess, value) = canShip(to: postcode)
        if sucess {
            return value
        } else {
            return value
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter loc: <#loc description#>
    /// - Returns: <#return value description#>
    func canShip(to loc: String) -> (Bool, Money) {
        for (key, index) in shippingDict {
            if (loc.contains(key)) || (key == "REST") {
                return (true, index)
            }
        }
        return (false, 1.0)
    }
    
}

/**
 
 */
public class LocationManager : NSObject, CLLocationManagerDelegate {
    
    /// <#Description#>
    public static let shared = LocationManager()
    
    /// <#Description#>
    fileprivate let center = NotificationCenter.default
    
    /// <#Description#>
    fileprivate var _locationManager = CLLocationManager()
    
    /// <#Description#>
    fileprivate var location: CLLocation? {
        didSet {
            getName(for: location!)
        }
    }
    
    /// <#Description#>
    public var postalCode: String? {
        didSet {
            center.post(name: .postcodeFound, object: self.postalCode)
        }
    }
    
    /// <#Description#>
    private override init() {
        super.init()
        
        self._locationManager.delegate = self
        self._locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self._locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        self._locationManager.requestAlwaysAuthorization()
        self._locationManager.startUpdatingLocation()
    }
    
    /// <#Description#>
    ///
    /// - Parameter location: <#location description#>
    internal func getName(for location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if (error != nil && placemarks == nil && placemarks?.first == nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            
            let pm = placemarks!.first!
            self.postalCode = pm.postalCode
            
        })
    }
    
}

extension LocationManager {

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) ||
            (CLLocationManager.authorizationStatus() == .authorizedAlways) {
            guard let currentLocation = locations.first else {
                return
            }
            
            _locationManager.stopUpdatingLocation()
            _locationManager.delegate = nil
            
            self.location = currentLocation
        } else {
            self._locationManager.requestAlwaysAuthorization()
        }
    }
    
}
