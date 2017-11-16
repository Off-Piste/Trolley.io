//
//  TRLAnalyticsObject.swift
//  TrolleyAnalytics
//
//  Created by Harry Wright on 09.10.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

import Foundation
@testable import TrolleyCore

#if os(iOS)
import UIKit

//extension TRLApp {
//    @objc public var platformType: String {
//        #if (arch(i386) || arch(x86_64)) && os(iOS)
//            let DEVICE_IS_SIMULATOR = true
//        #else
//            let DEVICE_IS_SIMULATOR = false
//        #endif
//
//        var machineSwiftString : String = ""
//
//        if DEVICE_IS_SIMULATOR == true {
//            // this neat trick is found at http://kelan.io/2015/easier-getenv-in-swift/
//            if let dir = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
//                machineSwiftString = dir
//            }
//        } else {
//            var size : size_t = 0
//            sysctlbyname("hw.machine", nil, &size, nil, 0)
//            var machine = [CChar](repeating: 0, count: Int(size))
//            sysctlbyname("hw.machine", &machine, &size, nil, 0)
//            machineSwiftString = String(cString: (machine))
//        }
//
//        return machineSwiftString
//    }
//}

#endif

extension AnalyticsEvent: CustomStringConvertible {
    public var description: String {
        let returnValue: String = "analytics_"
        switch self {
        case .addToCart:
            return returnValue + "addToCart"
        case .custom:
            return returnValue + "custom"
        case .finishCheckout:
            return returnValue + "finishCheckout"
        case .search:
            return returnValue + "search"
        case .startCheckout:
            return returnValue + "startCheckout"
        case .viewContent:
            return returnValue + "viewContent"
        case .didStartUp:
            return returnValue + "didStartUp"
        }
    }
}

@objcMembers public final class TRLAnalyticsObject: NSObject, NSCoding {

    public final var type: AnalyticsEvent

    public final var name: String?

    public final var date: Date

    public final var defaultAttribues: [String: Any]

    public final var customAttributes: [String: Any]

    public var json: JSON {
        var json: JSON = ["type": type.description, "timestamp":date.timeIntervalSince1970]

        if type == AnalyticsEvent.custom {
            assert(name != nil)
            json["name"] = JSON(name!)
        } else {
            assert(!defaultAttribues.isEmpty)
            json["defaultAttributes"] = JSON(defaultAttribues)
        }

        json["customAttributes"] = JSON(customAttributes)
        return ["t":"analytics", "d":json.dictionaryObject!]
    }
    
    public init(
        type: AnalyticsEvent,
        name: String?,
        date: Date,
        defaultAttribues: [String: Any]?,
        customAttributes: [String: Any]?
        )
    {
        self.type = type
        self.name = name
        self.date = date
        self.defaultAttribues = defaultAttribues ?? [:]
        self.customAttributes = customAttributes ?? [:]

        super.init()
    }

    public override var description: String {
        return "\(super.description){ }"
    }

    public convenience init?(coder aDecoder: NSCoder) {
        guard let rawType = aDecoder.decodeCInt(forKey: "type") as Int32?,
            let type = AnalyticsEvent(rawValue: UInt(rawType)),
            let date = aDecoder.decodeObject(forKey: "date") as? Date,
            let defaultAttribues = aDecoder.decodeObject(forKey: "defaultAttributes") as? [String: Any]?,
            let customAttributes = aDecoder.decodeObject(forKey: "customAttributes") as? [String: Any]? else {
                return nil
        }

        // This seems to cause a crash when in the above guard statement
        var name: String? = nil
        if aDecoder.containsValue(forKey: "name") {
            guard let decoded_name = aDecoder.decodeObject(forKey: "name") as? String else {
                return nil
            }
            name = decoded_name
        }

        self.init(type: type, name: name, date: date, defaultAttribues: defaultAttribues, customAttributes: customAttributes)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encodeCInt(Int32(type.rawValue), forKey: "type")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(defaultAttribues, forKey: "defaultAttributes")
        aCoder.encode(customAttributes, forKey: "customAttributes")

        if name != nil {
            aCoder.encode(name, forKey: "name")
        }
    }

}
