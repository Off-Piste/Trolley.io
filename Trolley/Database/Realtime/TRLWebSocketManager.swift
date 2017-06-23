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

struct TRLWebSocketManager {
    
    private var connection: TRLWebSocketConnection
    
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
}

extension TRLWebSocketManager: TRLWebSocketDelegate {
    
    func webSocket(
        _ connection: TRLWebSocketConnection,
        onMessage message: Dictionary<String, Any>
        )
    {
        
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
