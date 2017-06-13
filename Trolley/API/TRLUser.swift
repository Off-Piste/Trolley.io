//
//  TRLUser.swift
//  Pods
//
//  Created by Harry Wright on 25.05.17.
//
//

import Foundation
import CoreLocation

/**
 Struct to hold the known details of the user, i.e basket or email
 */
public struct TRLUser: CustomStringConvertible {
    
    public static var current: TRLUser = TRLUser()
    
    // 1. Email
    
    // 2. User UUID
    
    // 3. Basket? Maybe optional
    
    // 4. Location
    public var location: CLLocation {
        return placemark.location ?? kCLLocation
    }
    
    public var placemark: CLPlacemark = CLPlacemark()
    
    public var locale: Locale = Locale.current
    
    // 5. Anything else
    
    public var description: String {
        return "<TRLUser:0x1234567890> locale=\(locale)"
    }
}
