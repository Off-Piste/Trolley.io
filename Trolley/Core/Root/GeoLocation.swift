//
//  GeoLocation.swift
//  Pods
//
//  Created by Harry Wright on 25.04.17.
//
//

import Foundation
import PromiseKit

// TODO: Test

@objc(TRLGeolocation)
public class Geolocation: NSObject {
    
    public static var shared = Geolocation()
    
    fileprivate override init() { }
    
    // MARK: Location
    
    @objc(locationWithBlock:)
    public func location(handler: @escaping (CLLocation?, Error?) -> Void) {
        self.asLocation().then {
            handler($0, nil)
        }.catch {
            handler(nil, $0)
        }
    }
    
    public func asLocation() -> LocationPromise {
        return CLLocationManager.promise()
    }
    
    @available(swift, introduced: 1.0, obsoleted: 1.0)
    @objc(asLocation)
    public func asLocationPromise() -> AnyPromise {
        return CLLocationManager.__promise()
    }
    
    // MARK: Placemark
    
    // Testing
    public static func asPlacemark(for location: CLLocation) -> PlacemarkPromise {
        return CLGeocoder().reverseGeocode(location: location)
    }
    
    @objc(placemarkForLocation:withBlock:)
    public static func placemark(
        for location: CLLocation,
        handler: @escaping (CLPlacemark?, Error?
        ) -> Void)
    {
        self.asPlacemark(for: location).then {
            handler($0, nil)
        }.catch {
            handler(nil, $0)
        }
    }
    
    @objc(placemarkWithBlock:)
    public func placemark(handler: @escaping (CLPlacemark?, Error?) -> Void) {
        self.asPlacemark().then {
            handler($0, nil)
        }.catch {
            handler(nil, $0)
        }
    }
    
    public func asPlacemark() -> PlacemarkPromise {
        return PlacemarkPromise { fullfill, reject in
            self.asLocation().then {
                return CLGeocoder().reverseGeocode(location: $0)
            }.then {
                fullfill($0)
            }.catch {
                reject($0)
            }
        }
    }
}
