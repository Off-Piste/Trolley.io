//
//  TRLWebSocket.swift
//  Pods
//
//  Created by Harry Wright on 16.06.17.
//
//

import Foundation
import SocketRocket

/// - Note 
/// Due to ObjectiveC framework, NSObject is required.
class TRLWebSocketConnection : NSObject {
    
    weak var delegate: TRLWebSocketDelegate?
    
    fileprivate private(set) var webSocket: SRWebSocket
    
    fileprivate private(set) var queue: DispatchQueue
    
    fileprivate var keepAlive: Timer?
    
    fileprivate var everConnected: Bool = false
    
    internal var websocketLoggingEnabled: Bool {
        get {
            return kLoggingEnabled.boolValue
        } set {
            kLoggingEnabled = ObjCBool(newValue)
        }
    }
    
    /// Workaround for:
    ///
    /// `nw_connection_get_connected_socket_block_invoke 1 Connection has no connected handler`
    init?(url: String, queue: DispatchQueue = .main) {
        self.queue = queue
        
        guard let url = URL(string: url) else { return nil }
        self.webSocket = SRWebSocket(url: url)
        self.webSocket.setDelegateDispatchQueue(queue)
        
        super.init()
        self.webSocket.delegate = self
        kLoggingEnabled = true
    }
    
    init(parsedURL: ParsedURL, queue: DispatchQueue = .main) {
        self.queue = queue
        
        Log.debug("Connecting to: \(parsedURL.connectionURL)")
        self.webSocket = SRWebSocket(url: parsedURL.connectionURL)
        self.webSocket.setDelegateDispatchQueue(queue)
        
        // needed to satisfy an error, may swap NSObject to
        // NSObjectProtocol to save this error from occuring
        super.init()
        self.webSocket.delegate = self
        
        kLoggingEnabled = true
    }
    
}

/**
 
 */
extension TRLWebSocketConnection {

    func open() {
        Log.debug()
        
        self.everConnected = false
        self.webSocket.open()
        
//        let when = DispatchTime.now() + .milliseconds(300)
//        queue.asyncAfter(deadline: when) {
//            self.closeIfNeverConnected()
//        }
    }
    
    func close() {
        self.webSocket.close()
    }

}

/**
 
 */
extension TRLWebSocketConnection : SRWebSocketDelegate {

    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        Log.debug(message)
        self.restartTimer()
    }
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        Log.debug(webSocket.protocol)
        self.everConnected = true
        
        self.keepAlive = Timer.scheduledTimer(
            timeInterval: 45,
            target: self,
            selector: #selector(nop(_:)),
            userInfo: nil,
            repeats: true
        )
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        Log.error(error.localizedDescription, showSource: true, showThread: true)
    }
    
    func webSocket(
        _ webSocket: SRWebSocket!,
        didCloseWithCode code: Int,
        reason: String!,
        wasClean: Bool
        )
    {
        // `_bridgeToObjectiveC()` causes a crash here, check for nil
        // first before adding a reason.
        let reason = (reason == nil) ? "nil" : reason
        Log.debug(self.createError(withReason: reason, code: code))
    }
    
}

/**
 
 */
private extension TRLWebSocketConnection {
    
    func createError(withReason reason: String?, code: Int) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey: reason ?? "nil"]
        return NSError(domain: self.queue.label, code: code, userInfo: userInfo)
    }
    
    func closeIfNeverConnected() {
        Log.debug()
        
        if everConnected { return }
        Log.debug("WebSocket timed out")
        self.webSocket.close(withCode: 1010, reason: "WebSocket timed out")
    }
    
    @objc func nop(_ timer: Timer) {
        self.webSocket.send("0")
    }
    
    func restartTimer() {
        if keepAlive == nil { return }
        
        let newTime = Date(timeIntervalSinceNow: 45)
        if newTime.timeIntervalSince(keepAlive!.fireDate) > 5 {
            keepAlive!.fireDate = newTime
        }
    }
    
}
