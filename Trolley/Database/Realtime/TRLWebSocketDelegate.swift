//
//  TRLWebSocketDelegate.swift
//  Pods
//
//  Created by Harry Wright on 14.06.17.
//
//

import Foundation

protocol TRLWebSocketDelegate {
    
    func webSocket(_ connection: TRLWebSocketConnection, onMessage message: Dictionary<String, Any>)
    
    func webSocketOnDisconnect(_ connection: TRLWebSocketConnection, wasEverConnected connected: Bool)

    func webSocketOnLostConnection(_ connection: TRLWebSocketConnection)
    
    func webSocketOnConnection(_ connection: TRLWebSocketConnection)
    
}

