//
//  TRLAnalytics.swift
//  Pods
//
//  Created by Harry Wright on 27.06.17.
//
//

import Foundation
import PromiseKit
import SwiftyJSON

private let kTimeSpentInApp: String = "TotalUsageTime"
private let kDeviceToken: String = "AppleDeviceToken"

extension Notification.Name {
    
    static let analyticsRecivedDeviceID = Notification.Name(rawValue: "AnalyticsRecivedDeviceID")
    
}

public class TRLAnalytics {
    
    fileprivate var start: Date
    
    fileprivate var userDefaultsKey: String {
        return "_analytics"
    }
    
    fileprivate var defaultsManager: DefaultsManager {
        return DefaultsManager(withKey: userDefaultsKey)
    }
    
    internal init() {
        self.start = Date()
        
        let notification: Notification.Name = .UIApplicationWillTerminate
        NotificationCenter.default.observe(once: notification).then { _ in
            self.applicationWillTerminate()
        }.catch { (error) in
            TRLAnalyticsLogger.error(error.localizedDescription)
        }
        
        // Should not only observe this once as we need to send this everytime
        // the socket is created, after crashes or wifi lost
        NotificationCenter.default.addObserver(.websocketCreated, object: nil) {
            TRLCoreLogger.debug("\($0.name.rawValue) Observed")
            self.websocketConnected()
        }
    }
    
}

// when using public will be testing `applicationWillTerminate()`
private /* public */ extension TRLAnalytics {
    
    func websocketConnected() {
        self.applicationDidFinishLaunching()
    }

    func applicationDidFinishLaunching() {
        do {
            let object = try defaultsManager.retrieveObject()
            let json : JSON = self.toJSON(["DeviceData" : [kDeviceToken : object, "NewDevice" : false]])
            self.sendToServer(json)
        } catch let error as DefaultsManagerError {
            switch error {
            case .returnValueNil:
                createDeviceToken()
            default:
                NSException.fatal(error.localizedDescription)
            }
        } catch {
            NSException.fatal(error.localizedDescription)
        }
    }
    
    func applicationWillTerminate() {
        let end = Date()
        let timeInterval = end.timeIntervalSince(start)
        
        TRLAnalyticsLogger.debug("Device was running for: \(timeInterval) seconds")
        let json = self.toJSON(timeInterval, withKey: kTimeSpentInApp)
        self.sendToServer(json)
    }
}

extension TRLAnalytics :  Reporting {
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - query: <#query description#>
    ///   - userInfo: <#userInfo description#>
    public func logSearchQuery(
        _ query: String,
        customAttributes: [AnyHashable : Any]? = nil
        )
    {
        TRLAnalyticsLogger.debug("\(#function) query: \(query)")
        let jsonDict = ["AnalyticEvent": [ "name": "searchQuery", "attributes": [ "searchValue" : query ], "customAttributes": customAttributes as Any, "date" : Date().timeIntervalSince1970]]
        
        self.sendToServer(self.toJSON(jsonDict))
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - itemID: <#itemID description#>
    ///   - money: <#money description#>
    ///   - basket: <#basket description#>
    ///   - userInfo: <#userInfo description#>
    public func logAddItem<Collection>(
        _ itemID: String,
        withPrice money: Money,
        toBasket basket: Collection?,
        customAttributes: [AnyHashable : Any]? = nil
        ) where Collection : MutableCollection
    {
        //
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - basket: <#basket description#>
    ///   - money: <#money description#>
    ///   - userInfo: <#userInfo description#>
    public func logCheckout<Collection>(
        of basket: Collection,
        withPrice money: Money,
        customAttributes: [AnyHashable : Any]? = nil
        ) where Collection : MutableCollection
    {
        //
    }
    
}

private extension TRLAnalytics {
    
    func createDeviceToken() {
        // Create the UUID for the device and send it to the server
        let json = self.toJSON([
            "DeviceData" : [ kDeviceToken : UUID().uuidString, "NewDevice" : true ]
            ]
        )
        self.sendToServer(json)
        
        // Observe for the Servers Request
        let notification: Notification.Name = .analyticsRecivedDeviceID
        NotificationCenter.default
            .observe(once: notification)
            .asNotification()
            .then { notif -> Void in
                // This should never fail, as the sever should only send it back as confirmation
                guard let token = (notif.object as! JSON)[kDeviceToken].string else {
                    fatalError()
                }
                // Sets the device
                self.defaultsManager.set(token)
            }.catch { (error) in
                NSException.fatal(error.localizedDescription)
        }
    }
    
}

private extension TRLAnalytics {
    
    func toJSON(_ value: Any, withKey key: String) -> JSON {
        return self.toJSON([key : value])
    }
    
    func toJSON(_ dictionary : [String : Any]) -> JSON {
        return JSON([
            "TRLAnalytics" : kTrolleyVersionNumber,
            "Data" : dictionary
            ]
        )
    }
    
    func sendToServer(_ json: JSON) {
        Trolley.shared.webSocketManager.send(json.rawString() ?? "")
    }
    
}
