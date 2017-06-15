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

extension ParsedURL : URLConvertible {
    
    func asURL() throws -> URL {
        guard let url = self.requestUrl else { throw AFError.invalidURL(url: self) }
        return url
    }
    
}

protocol TRLWebSocketDelegate: class {
    func onMessage(_ message: Dictionary<String, Any>, connection: TRLWebSocketConnection)
    func onDisconnect(connection: TRLWebSocketConnection, wasEverConnected connected: Bool)
}

/// Due to ObjectiveC framework, NSObject is requird.
class TRLWebSocketConnection : NSObject, SRWebSocketDelegate {
    
    var webSocket: SRWebSocket
    
    var everConnected: Bool = false
    
    var queue: DispatchQueue
    
    var keepAlive: Timer?
    
    weak var delegate: TRLWebSocketDelegate?
    
    init(parsedURL: ParsedURL, queue: DispatchQueue = .main) {
        self.queue = queue
        
        Log.debug("Connecting to: \(parsedURL.connectionURL)")
        self.webSocket = SRWebSocket(url: parsedURL.connectionURL)
        self.webSocket.setDelegateDispatchQueue(queue)
        
        // needed to satisfy an error, may swap NSObject to
        // NSObjectProtocol to save this error from occuring
        super.init()
        self.webSocket.delegate = self
    }
    
    func userDevice() -> String {
        
        // When designed for MacOS, need to check for UIDevice
        let systemVersion: String = TRLAppEnviroment.current.systemVersion
        let deviceModel: String = TRLAppEnviroment.current.deviceModel
        let _ : String = UIDevice.current.model
        let bundleID: String = Bundle.main.bundleIdentifier ?? "null"
        
        return "Trolley/5/\(systemVersion)/{\(deviceModel)}/\(bundleID))}"
    }
    
    func open() {
        Log.debug()
        
        self.everConnected = false
        self.webSocket.open()
        
        let when = DispatchTime.now() + .milliseconds(300)
        queue.asyncAfter(deadline: when) {
            self.closeIfNeverConnected()
        }
    }
    
    private func closeIfNeverConnected() {
        Log.debug()
        
        if everConnected { return }
        Log.debug("WebSocket timed out")
        self.webSocket.close()
    }
    
    func nop(timer: Timer) {
        self.webSocket.send("0")
    }
    
    func restartTimer() {
        if keepAlive == nil { return }
        
        let newTime = Date(timeIntervalSinceNow: 45)
        if newTime.timeIntervalSince(keepAlive!.fireDate) > 5 {
            keepAlive!.fireDate = newTime
        }
    }
    
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
            selector: #selector(nop(timer:)),
            userInfo: nil,
            repeats: true
        )
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        Log.error(error.localizedDescription, showSource: true, showThread: true)
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        Log.debug(
            (NSError(
                domain: queue.label,
                code: code,
                userInfo: [
                    NSLocalizedDescriptionKey: reason
                ]
            ) as Error).localizedDescription
        )
    }
}
