//
//  ParsedURL.swift
//  Network
//
//  Created by Harry Wright on 19.06.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

import Foundation
import Alamofire

enum InternalNetworkError: Error {
    
    case urlIsNil
    
}

// Work it like alamofire, and use the error in the handler

internal struct ParsedURL {
    
    internal var parsedURLInfo: TRLNetworkInfo
    
    internal init(_ urlInfo: TRLNetworkInfo) {
        self.parsedURLInfo = urlInfo
    }
    
    internal init(_ url: URLConvertible) throws {
        self.parsedURLInfo = try TRLNetworkInfo(url: url)
    }
    
}

internal extension ParsedURL {

    internal var url: URL? {
        return try? self.asURL()
    }
    
    internal var webSocketURL: URL {
        return parsedURLInfo.connectionURL
    }
    
}

extension ParsedURL : CustomStringConvertible {
    
    var description: String {
        return (url == nil) ? self.webSocketURL.absoluteString : self.url!.absoluteString
    }
    
}

internal extension ParsedURL {
    
    internal func addingPath(_ path: String) -> ParsedURL {
        return try! ParsedURL(self.parsedURLInfo.addingPath(path))
    }
    
    internal mutating func _addPath(_ path: String) {
        do {
            try self.parsedURLInfo._addPath(path)
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
}

/// this is so we can pass this in alamofire
extension ParsedURL : URLConvertible {
    
    func asURL() throws -> URL {
        guard let urlURl = self.url else { throw InternalNetworkError.urlIsNil }
        return urlURl
    }
    
}
