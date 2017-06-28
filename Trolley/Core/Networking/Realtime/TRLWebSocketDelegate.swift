//
//  TRLWebSocketDelegate.swift
//  Pods
//
//  Created by Harry Wright on 14.06.17.
//
//

import Foundation
import SwiftyJSON

protocol TRLWebSocketDelegate {
    
    func webSocket(_ connection: TRLWebSocketConnection, onMessage message: JSON)
    
    func webSocket(_ connection: TRLWebSocketConnection, onTextMessage message: String)
    
    func webSocketOnDisconnect(_ connection: TRLWebSocketConnection, wasEverConnected connected: Bool)

    func webSocketOnLostConnection(_ connection: TRLWebSocketConnection)
    
    func webSocketOnConnection(_ connection: TRLWebSocketConnection)
    
}

