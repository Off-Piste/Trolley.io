//
//  TRLAnalyticsObject.swift
//  TrolleyAnalytics
//
//  Created by Harry Wright on 09.10.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

import Foundation
import TrolleyCore

@objcMembers public final class TRLAnalyticsObject: NSObject {

    public final var name: String

    public final var date: Date

    public final var customAttributes: [String: Any]

    public final var json: JSON {
        return ["name":name, "timestamp":date.timeIntervalSince1970, "customAttributes":customAttributes]
    }

    public init(withName name: String, date: Date, customAttributes: [String: Any]) {
        self.name = name
        self.date = date
        self.customAttributes = customAttributes
        super.init()
    }

}
