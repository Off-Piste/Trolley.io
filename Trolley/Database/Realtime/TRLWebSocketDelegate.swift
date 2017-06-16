//
//  TRLWebSocketDelegate.swift
//  Pods
//
//  Created by Harry Wright on 14.06.17.
//
//

import Foundation
import Alamofire
import SocketRocket

protocol TRLWebSocketDelegate: class {
    
    func webSocket(_ connection: TRLWebSocketConnection, onMessage message: Dictionary<String, Any>)
    
    func webSocketOnDisconnect(_ connection: TRLWebSocketConnection, wasEverConnected connected: Bool)
    
}

