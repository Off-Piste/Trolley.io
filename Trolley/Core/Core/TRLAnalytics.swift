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

private let kTimeSpentInApp: String = "totalUsageTime"
private let kDeviceToken: String = "appleDeviceToken"

extension Notification.Name {
    
    static let analyticsRecivedDeviceID = Notification.Name(rawValue: "analyticsRecivedDeviceID")
    
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
        
        TRLCoreLogger.debug("Testing Analytics JSON, \(self.toJSON("default", withKey: userDefaultsKey))")
        
        let notification: Notification.Name = .UIApplicationWillTerminate
        NotificationCenter.default.observe(once: notification).then { _ in
            self.applicationWillTerminate()
        }.catch { (error) in
            TRLCoreLogger.error(error.localizedDescription)
        }
    }
    
}

// when using public will be testing `applicationWillTerminate()`
private /* public */ extension TRLAnalytics {

    func applicationDidFinishLaunching() {
        do {
            let object = try defaultsManager.retrieveObject()
            let json = self.toJSON(object, withKey: kDeviceToken)
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
        
        TRLCoreLogger.debug("Device was running for: \(timeInterval) seconds")
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
        userInfo: [AnyHashable : Any]?
        )
    {
        TRLCoreLogger.debug("\(#function) query: \(query) userInfo: \(userInfo as Any)")
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
        userInfo: [AnyHashable : Any]?
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
        userInfo: [AnyHashable : Any]?
        ) where Collection : MutableCollection
    {
        //
    }
    
}

private extension TRLAnalytics {
    
    func createDeviceToken() {
        // Create the UUID for the device and send it to the server
        let json = self.toJSON(UUID().uuidString, withKey: kDeviceToken)
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
            "data" : dictionary
            ]
        )
    }
    
    func sendToServer(_ json: JSON) {
        Trolley.shared.webSocketManager.send(json.rawString() ?? "")
    }
    
}
