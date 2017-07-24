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
        .replacingOccurrences(of: ".", with: "_")
    let deviceName = UIDevice.current.model
    let bundleIdentifier: String? = Bundle.main.bundleIdentifier
    let applicationVersion = TRLAppEnviroment.current.appVersionNumber
    
    let ua: String = "Trolley/0.1.0 (Macintosh; \(deviceName) \(systemVersion)) [\((bundleIdentifier) ?? "unknown")_\(applicationVersion)]"
    return ua
}

public let ServerDown: Notification.Name = Notification.Name(rawValue: "ServerDown")

class TRLWebSocketConnection {
    
    fileprivate private(set) var webSocket: WebSocket
    
    var delegate: TRLWebSocketDelegate?
    
    var wasEverConnected: Bool = false
    
    var serverDown: Bool = false
    
    var attempts: Int = 0
    
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
        
        if self.serverDown { return }
        
        attempts += 1
        TRLCoreLogger.debug("This is WebSocket attempt #\(attempts)")
        
        self.webSocket.connect()
        self.waitForTimeout(10)
    }
    
    func close() {
        self.webSocket.disconnect()
    }
    
    func send(_ message: String) {
        self.webSocket.write(string: message)
    }
    
    func waitForTimeout(_ time: TimeInterval) {
        TRLTimer(for: time).once {
            if self.wasEverConnected { return }
            
            TRLCoreNetworkingLogger.debug("WebSocket timed out after \(time) seconds")
            self.webSocket.disconnect()
        }
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
        if message == "0" { self.delegate?.webSocket(self, onTextMessage: message) }
        else if let data = message.data(using: .utf8, allowLossyConversion: true) {
            self.delegate?.webSocket(self, onMessage: JSON(data: data))
        } else { self.delegate?.webSocket(self, onMessage: JSON(message)) }
    }
    
    func webSocket(_ socket: WebSocket, didDisconnect error: NSError?) {
        if error != nil, (error!.code == 61 && Trolley.shared.reachability.isReachable) {
            let errorResponse = "Server is down [(url: \(socket.currentURL)) ( error: \(error!.localizedDescription)) (reachability: \(Trolley.shared.reachability.currentReachabilityString))]"
            TRLCoreNetworkingLogger.error(errorResponse)
            
            // In the TRLUIComponents we will have some view watching
            // this to display an error
            NotificationCenter.default.post(name: ServerDown, object: nil)
        }
        
        
        self.delegate?.webSocketOnDisconnect(self, wasEverConnected: self.wasEverConnected)
    }
    
}

extension TRLWebSocketConnection : CustomStringConvertible {
    
    var description: String {
        return self.webSocket.description
    }
    
}
