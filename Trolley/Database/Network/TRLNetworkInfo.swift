//
//  TRLNetworkInfo.swift
//  Pods
//
//  Created by Harry Wright on 14.06.17.
//
//

import Foundation
/**
 TRLNetworkInfo is a struct that holds all the info on 
 the current network calls.
 
 So that when you call a request you can know some details about it.
 It also is used to creat
 */
struct TRLNetworkInfo {
    
    /// <#Description#>
    var host: String
    
    /// <#Description#>
    var namespace: String
    
    /// <#Description#>
    var secure: Bool
    
    /// <#Description#>
    var url: URL?
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - host: <#host description#>
    ///   - namespace: <#namespace description#>
    ///   - secure: <#secure description#>
    ///   - url: <#url description#>
    init(host: String, namespace: String, secure: Bool, url: URL? = nil) {
        self.host = host
        self.namespace = namespace
        self.secure = secure
        self.url = url
    }
    
    /// **Only** to be used when adding the API key,
    /// nothing else should touch this.
    mutating func __addPath(_ path: String) {
        if url == nil { fatalError("Paths cannot be added to `connectionURL`") }
        self.url!.appendPathComponent("/\(path)")
    }
    
    /// <#Description#>
    ///
    /// - Parameter path: <#path description#>
    /// - Returns: <#return value description#>
    func addingPath(_ path: String) -> TRLNetworkInfo {
        if url == nil { fatalError("Paths cannot be added to `connectionURL`") }
        var aURL = url!
        let last = aURL.absoluteString.characters.last!
        let newPath = (last == "/") ? path : "/" + path
        aURL.appendPathComponent(newPath)
        
        return TRLNetworkInfo(
            host: self.host,
            namespace: self.namespace,
            secure: self.secure,
            url: aURL
        )
    }
    
}

extension TRLNetworkInfo {

    /// <#Description#>
    var isLocal: Bool {
        return self.namespace == "localhost"
    }
    
    /// May move this out of the default implementation and add as an extension
    var connectionURL: URL {
        var scheme: String
        if self.secure {
            scheme = "wss"
        } else {
            scheme = "ws"
        }
        
        guard let url = URL(string: "\(scheme)://\(self.host)/.ws?ns=\(self.namespace)") else {
            fatalError()
        }
        
        return url
    }
    
    /// <#Description#>
    var path: String {
        guard let url = self.url,
            let urlComp = URLComponents(url: url, resolvingAgainstBaseURL: true)
            else {
                return ""
        }
        
        let path = urlComp.path
        let range = (path as NSString).range(of: "/").location
        return (path as NSString).substring(from: range + 1)
    }
    
}
