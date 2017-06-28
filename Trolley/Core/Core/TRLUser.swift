//
//  TRLUser.swift
//  Pods
//
//  Created by Harry Wright on 25.05.17.
//
//

import Foundation
import CoreLocation

let kCLLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)

/**
 Struct to hold the known details of the user, i.e basket or email
 */
public struct TRLUser: CustomStringConvertible {

    /// <#Description#>
    public static var current: TRLUser = TRLUser()

    // 1. Email

    // 2. User UUID

    // 3. Basket? Maybe optional

    // 4. Location
    /// <#Description#>
    public var location: CLLocation {
        return placemark.location ?? kCLLocation
    }

    /// <#Description#>
    public var placemark: CLPlacemark = CLPlacemark()

    /// <#Description#>
    public var locale: Locale = Locale.current

    // 5. Anything else

    /// <#Description#>
    public var description: String {
        return "<TRLUser:0x1234567890> locale=\(locale)"
    }
}
