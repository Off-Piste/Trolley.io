//
//  TRLWebSocketManager.swift
//  Pods
//
//  Created by Harry Wright on 19.06.17.
//
//

// MARK: This will hold all the Notifications and route them

import Foundation
import Alamofire

let kProductUpdatedKey: String = "product-updated"

class TRLWebSocketManager {
    
    private var connection: TRLWebSocketConnection
    
    fileprivate var reconnection: Timer?
    
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
    }
    
    func open() {
        self.connection.open()
    }
    
    func send(_ message: String) {
        if message.isEmpty { return }
        self.connection.send(message)
    }
}

extension TRLWebSocketManager: TRLWebSocketDelegate {
    
    func webSocket(
        _ connection: TRLWebSocketConnection,
        onMessage message: Dictionary<String, Any>
        )
    {
        TRLCoreLogger.debug("onMessage: \(message)")
    }
    
    func webSocketOnDisconnect(
        _ connection: TRLWebSocketConnection,
        wasEverConnected connected: Bool
        )
    {
        if !connected {
            if #available(iOS 10.0, *) {
                reconnection = Timer(timeInterval: 30, repeats: true, block: { (timer) in
                    self.attemptToRestablishConnection(timer)
                })
            } else {
                let aSelector: Selector = #selector(attemptToRestablishConnection(_:))
                reconnection = Timer(timeInterval: 30, target: self, selector: aSelector, userInfo: nil, repeats: true)
            }
        }
        TRLCoreLogger.debug("onDisconnect [wasEverConnected: \(connected)]")
    }
    
    func webSocketOnConnection(_ connection: TRLWebSocketConnection) {
        self.reconnection?.invalidate()
        TRLCoreLogger.debug("onConnection \(connection)")
    }
    
    func webSocketOnLostConnection(_ connection: TRLWebSocketConnection) {
        TRLCoreLogger.debug("onLostConnection \(connection)")
    }
    
    @objc func attemptToRestablishConnection(_ timer: Timer) {
        Trolley.shared.reachability.promise().then { reach -> Void in
            if reach.isReachable {
                self.reconnection?.invalidate()
                self.open()
            }
        }.catch { (error) in
            TRLCoreLogger.error(error)
            return
        }
    }
    
}
