//
//  TRLWebSocketManager.swift
//  Pods
//
//  Created by Harry Wright on 19.06.17.
//
//

// MARK: This will hold all the Notifications and route them

import Foundation
import SwiftyJSON
import Alamofire

extension JSON {
    
    init(dataArray: [Data]) {
        let arr = dataArray.map { JSON(data: $0) }
        self.init(arr)
    }
    
}

extension Notification.Name {
    
    static let websocketCreated = Notification.Name(rawValue: "WebSocketCreated")
    
}

let kProductUpdatedKey: String = "product-updated"

class TRLWebSocketManager {
    
    private var connection: TRLWebSocketConnection
    
    fileprivate var connected: Bool = false
    
    var volitileQueue: [String] = []
    
    /// Note:
    ///
    /// For ->
    /// nw_connection_get_connected_socket_block_invoke 1 Connection has no connected handler
    /// please use a `String` input of your ip address rather than the `ParsedURL`
    ///
    /// - Parameters:
    ///   - url: The url to be used
    ///   - protocols:
    /// - Throws: An error of invalid URL if the url is invalid
    init(url: URLConvertible, protocols: [String]?) throws {
        self.connection = try TRLWebSocketConnection(url: url, protocols: protocols)
        self.connection.delegate = self
        
        self.queueManager()
    }
    
    func open() {
        if self.connected { return }
        self.connection.open()
    }
    
    func send(_ message: String) {
        if message.isEmpty { return }
        if !self.connected { self.addToQueue(message) }
        self.connection.send(message)
    }
    
    func queueManager() {
        NotificationCenter.default.addObserver(.websocketCreated, object: nil) {
            TRLCoreLogger.debug("\($0.name.rawValue) Observed")
            self.sendQueue()
        }
    }
    
    func sendQueue() {
        let dm = DefaultsManager(withKey: "WebSocketQueue")
        TRLCoreLogger.debug("Attempting to send queue")
        
        do {
            var queue = try dm.retrieveObject() as! [String]
            queue.reverse()
            
            if self.connected {
                // send first
                if !self.volitileQueue.isEmpty {
                    self.connection.send(JSON(volitileQueue).rawString() ?? "")
                }
                
                let data = queue
                    .map { $0.data(using: .utf8, allowLossyConversion: true) }
                    .flatMap { $0 }
                
                let json = JSON(dataArray: data)
                TRLCoreLogger.debug(json.rawString() ?? "")
                self.connection.send(json.rawString() ?? "")
                dm.clear()
            }
        } catch {
            TRLCoreLogger.debug("Queue Is Empty")
        }
    }
    
    func addToQueue(_ message: String) {
        let dm = DefaultsManager(withKey: "WebSocketQueue")
        TRLCoreLogger.debug("Adding Message [\(message)] to queue")
        
        // This only needs to be sent upon connection and not mulitple times
        // Technically this should never be hit as its only sent
        // after .websocketCreated is observed
        if message.contains("DeviceData") {
            self.volitileQueue.append(message); return
        }
        
        do {
            var queue = try dm.retrieveObject() as! [String]
            queue.append(message)
        } catch {
            dm.set([message])
        }
    }
}

extension TRLWebSocketManager: TRLWebSocketDelegate {
    
    func webSocket(_ connection: TRLWebSocketConnection, onTextMessage message: String) {
        TRLCoreLogger.debug("onMessage: \(message)")
    }
    
    func webSocket(_ connection: TRLWebSocketConnection, onMessage message: JSON) {
        TRLCoreLogger.debug("onMessage: \(message.rawString() ?? "")")
        self.manageResponse(message)
    }
    
    func webSocketOnDisconnect(
        _ connection: TRLWebSocketConnection,
        wasEverConnected connected: Bool
        )
    {
        TRLCoreLogger.debug("onDisconnect [wasEverConnected: \(connected)]")
        TRLTimer.after(10, if: !connected) {
            self.attemptToRestablishConnection()
            return .stop
        }
    }
    
    func webSocketOnConnection(_ connection: TRLWebSocketConnection) {
        self.connected = true
        
        TRLCoreLogger.debug("onConnection \(connection)")
        NotificationCenter.default.post(name: .websocketCreated, object: nil)
    }
    
    func webSocketOnLostConnection(_ connection: TRLWebSocketConnection) {
        TRLCoreLogger.debug("onLostConnection \(connection)")
    }
    
    func manageResponse(_ json: JSON) {
        if json["Connections"].exists() && json["Limit"].exists() {
            //
        }
        
        if json["AnalyticsRecivedDeviceID"].exists() {
            if let json = json["AnalyticsRecivedDeviceID"].dictionary {
                NotificationCenter.default.post(name: .analyticsRecivedDeviceID, object: json)
            }
        }
    }
    
    func attemptToRestablishConnection() {
        if self.connected { return }
        
        TRLCoreLogger.debug("Attempting to reconnect to server")
        if Trolley.shared.reachability.isReachable {
            self.open()
        } else {
            TRLTimer(for: 10).once {
                self.attemptToRestablishConnection()
            }
        }
    }
    
}
