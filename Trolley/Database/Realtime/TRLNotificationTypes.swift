//
//  TRLNotificationTypes.swift
//  Pods
//
//  Created by Harry Wright on 19.06.17.
//
//

import Foundation

public enum TRLNotificationTypes: String {
    
    case productUpdated = "productUpdated"
    
    public init(_ rawValue: String) {
        switch rawValue {
        case "productUpdated":
            self = .productUpdated
        default:
            fatalError("Invalid Type")
        }
    }
    
}

extension TRLNotificationTypes {
    
    var notificationName: Notification.Name {
        return Notification.Name(self.rawValue)
    }
    
    var internalNotificationName: Notification.Name {
        return Notification.Name("_" + self.rawValue)
    }
    
}

extension TRLNotificationTypes: CustomStringConvertible {
    
    public var description: String {
        return self.rawValue
    }
    
}
