//
//  TRLWebSocket.swift
//  Pods
//
//  Created by Harry Wright on 16.06.17.
//
//

import Foundation
import Alamofire

var kUserAgent: String {
    let systemVersion = TRLAppEnviroment.current.systemVersion
    let deviceName = UIDevice.current.model
    let bundleIdentifier: String? = Bundle.main.bundleIdentifier
    
    let ua: String = "Firebase/13/\(systemVersion)/\(deviceName)_\((bundleIdentifier) ?? "unknown")"
    return ua
}

class TRLWebSocketConnection {
    
    fileprivate private(set) var webSocket: WebSocket
    
    var delegate: TRLWebSocketDelegate?
    
    var wasEverConnected: Bool = false
    
    init(url: URLConvertible, protocols: [String]?) throws {
        self.webSocket = WebSocket(
            url: try url.asURL(),
            QOS: .background,
            protocols: protocols,
            userAgent: kUserAgent
        )
        self.webSocket.delegate = self
    }
    
}

extension TRLWebSocketConnection {
    
    func open() {
        assert(delegate != nil, "TRLWebSocketDelegate must be set")
        self.webSocket.connect()
        
        self.waitForTimeout(300)
    }
    
    func close() {
        self.webSocket.disconnect()
    }
    
    func send(_ message: String) {
        self.webSocket.write(string: message)
    }
    
    func waitForTimeout(_ time: TimeInterval) {
        self.webSocket.disconnect(
            forceTimeout: time,
            closeCode: WebSocket.CloseCode.noStatusReceived.rawValue
        )
    }
}

extension TRLWebSocketConnection : WebSocketDelegate {
    
    func webSocketDidConnect(_ socket: WebSocket) {
        self.wasEverConnected = true
        self.delegate?.webSocketOnConnection(self)
    }
    
    func webSocket(_ socket: WebSocket, didReceiveData data: Data) {
        self.delegate?.webSocket(self, onMessage: ["Data" : data])
    }
    
    func webSocket(_ socket: WebSocket, didReceiveMessage message: String) {
        self.delegate?.webSocket(self, onMessage: ["Message" : message])
    }
    
    func webSocket(_ socket: WebSocket, didDisconnect error: NSError?) {
        self.delegate?.webSocketOnDisconnect(self, wasEverConnected: self.wasEverConnected)
    }
    
}
