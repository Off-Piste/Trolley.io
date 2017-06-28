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
        
        self.waitForTimeout(30)
    }
    
    func close() {
        self.webSocket.disconnect()
    }
    
    func send(_ message: String) {
        self.webSocket.write(string: message)
    }
    
    func waitForTimeout(_ time: TimeInterval) {
        let milliseconds = Int(time * 1_000)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds)) {
            TRLCoreLogger.debug("WebSocket timed out after \(time) seconds")
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
        self.delegate?.webSocket(self, onMessage: ["Message" : message])
    }
    
    func webSocket(_ socket: WebSocket, didDisconnect error: NSError?) {
        if error != nil, (error!.code == 61 && Trolley.shared.reachability.isReachable) {
            let errorResponse = "Server is down [(url: \(socket.currentURL)),( error: \(error!.localizedDescription)) (reachability: \(Trolley.shared.reachability.currentReachabilityString))]"
            TRLCoreLogger.fatalError(errorResponse)
        }
        self.delegate?.webSocketOnDisconnect(self, wasEverConnected: self.wasEverConnected)
    }
    
}

extension TRLWebSocketConnection : CustomStringConvertible {
    
    var description: String {
        return self.webSocket.description
    }
    
}
