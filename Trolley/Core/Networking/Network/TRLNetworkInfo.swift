//
//  URLInfo.swift
//  Network
//
//  Created by Harry Wright on 19.06.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

import Foundation
import Alamofire

internal struct TRLNetworkInfo {
    
    internal private(set) var host: String
    
    internal private(set) var namespace: String
    
    internal private(set) var secure: Bool
    
    internal fileprivate(set) var url: URL?
    
    internal init(host: String, namespace: String, secure: Bool, url: URL? = nil) {
        self.host = host
        self.namespace = namespace
        self.secure = secure
        self.url = url
    }
    
    internal init(url: URLConvertible) throws {
        let (host, namespace, secure, url) = try TRLUtilities.singleton.split(url)
        self.init(host: host, namespace: namespace, secure: secure, url: url)
    }
    
}

internal extension TRLNetworkInfo {
    
    mutating func _addPath(_ path: String) throws {
        if url == nil { throw InternalNetworkError.urlIsNil }
        self.url!.appendPathComponent("/\(path)")
    }
    
    func addingPath(_ path: String) throws -> TRLNetworkInfo {
        if url == nil { throw InternalNetworkError.urlIsNil }
        var aURL = url!
        let last = aURL.absoluteString.characters.last!
        let newPath = (last == "/") ? path : "/" + path
        aURL.appendPathComponent(newPath)
        return TRLNetworkInfo(host: host, namespace: namespace, secure: secure, url: aURL)
    }
    
    var connectionURL: URL {
        var scheme: String
        if self.secure {
            scheme = "wss"
        } else {
            scheme = "ws"
        }
        
        let portInt = self.url?.port ?? NSNotFound
        let port = (portInt != NSNotFound) ? ":\(portInt)/" : "/"
        
        guard let url = URL(string: "\(scheme)://\(self.host)\(port).ws?ns=\(self.namespace)") else {
            fatalError()
        }
        
        return url
    }
    
    
}
