//
//  TRLWebSocketManager.swift
//  Pods
//
//  Created by Harry Wright on 19.06.17.
//
//

// MARK: This will hold all the Notifications and route them

import Foundation

let kProductUpdatedKey: String = "product-updated"

struct TRLWebSocketManager {
    
    private var connection: TRLWebSocketConnection
    
    init(_ url: ParsedURL, queue: DispatchQueue = .main) {
        self.connection = TRLWebSocketConnection(parsedURL: url, queue: queue)
        self.connection.delegate = self
    }
    
    init(url: String, queue: DispatchQueue = .main) {
        self.connection = TRLWebSocketConnection(url: url, queue: queue)!
        self.connection.delegate = self
    }
    
    func setLogging(_ value: Bool) {
        self.connection.websocketLoggingEnabled = value
    }
    
    func open() {
        self.connection.open()
    }
}

extension TRLWebSocketManager: TRLWebSocketDelegate {
    
    func webSocket(
        _ connection: TRLWebSocketConnection,
        onMessage message: Dictionary<String, Any>
        )
    {
//        for (key, value) in message {
//            if (value as! String) == kProductUpdatedKey {
//                let notif = TRLNotification<Any>(
//                    TRLNotificationTypes.productUpdated.internalNotificationName.rawValue
//                )
//                notif.post(value)
//            } else if key == kProductUpdatedKey {
//                let notif = TRLNotification<Any>(
//                    TRLNotificationTypes.productUpdated.internalNotificationName.rawValue
//                )
//                notif.post(key)
//            }
//        }
    }
    
    func webSocketOnDisconnect(
        _ connection: TRLWebSocketConnection,
        wasEverConnected connected: Bool
        )
    {
        
    }
    
    func webSocketOnConnection(_ connection: TRLWebSocketConnection) {
        //
    }
    
    func webSocketOnLostConnection(_ connection: TRLWebSocketConnection) {
        //
    }
    
    
}
