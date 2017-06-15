//
//  ParsedURL.swift
//  Pods
//
//  Created by Harry Wright on 14.06.17.
//
//

import Foundation

/**
 Parsed URL is the class that holds the `URL` for any request,
 wether that be for the websocket or a normal rest request.
 
 This will be what is passed rather than `URL` when using URLs.
 It also contains the info the for network call it will make,
 so if its secure, or the namespace or host or path and also 
 the querys.
 
 All URL's entered, wether that be `String` or `URL` or using the 
 ExpressibleByStringLiteral protocol they will be
 parsed by `TRLUtilities.parse(_:)` so that the system can be sure
 it is hitting the correct location without an issue
 */
class ParsedURL : ExpressibleByStringLiteral {
    
    var networkInfo: TRLNetworkInfo
    
    typealias StringLiteralType = String
    
    typealias UnicodeScalarLiteralType = String
    
    typealias ExtendedGraphemeClusterLiteralType = String
    
    init(networkInfo: TRLNetworkInfo) {
        self.networkInfo = networkInfo
    }
    
    required convenience init(stringLiteral value: ParsedURL.StringLiteralType) {
        self.init(value)
    }
    
    required convenience init(unicodeScalarLiteral value: ParsedURL.UnicodeScalarLiteralType) {
        self.init(value)
    }
    
    required convenience init(
        extendedGraphemeClusterLiteral value: ParsedURL.ExtendedGraphemeClusterLiteralType
        )
    {
        self.init(value)
    }
    
}

extension ParsedURL {

    convenience init(_ url: String) {
        self.init(TRLUtilities.singleton.parseURL(url))
    }
    
    convenience init(_ url: URL) {
        self.init(url.absoluteString)
    }
    
    private convenience init(_ parsedURL: ParsedURL) {
        self.init(networkInfo: parsedURL.networkInfo)
    }
    
}

extension ParsedURL : CustomStringConvertible {

    var description: String {
        return requestUrl != nil ? requestUrl!.absoluteString : connectionURL.absoluteString
    }
    
}

extension ParsedURL {
    
    var requestUrl: URL? {
        return networkInfo.url
    }
    
    var connectionURL: URL {
        return networkInfo.connectionURL
    }
    
    var query: URLQuery {
        return URLQuery(self.isARequest ? requestUrl! : connectionURL)
    }
    
    var isARequest: Bool {
        return requestUrl != nil
    }
    
}
