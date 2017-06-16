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
 parsed by `TRLUtilities.parse(_:checkingForError:)` so that the system can be sure
 it is hitting the correct location without an issue
 */
class ParsedURL : ExpressibleByStringLiteral {
    
    // Should never be accessable, by anything!
    // all changes to the the network info / base url
    // should be done here
    fileprivate var networkInfo: TRLNetworkInfo
    
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

    /// The Method for which the url is parsed
    ///
    /// This will automatically check the url for errors, 
    /// so custom errors should use init(_:check:) instead
    /// if using a custom url
    ///
    /// - Parameter url: <#url description#>
    convenience init(_ url: String) {
        self.init(TRLUtilities.singleton.parseURL(url, checkingForError: true))
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - check: <#check description#>
    convenience init(_ url: URL, check: Bool = true) {
        self.init(url.absoluteString, check: check)
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - check: <#check description#>
    convenience init(_ url: String, check: Bool) {
        self.init(TRLUtilities.singleton.parseURL(url, checkingForError: check))
    }
    
    /// <#Description#>
    ///
    /// - Parameter parsedURL: <#parsedURL description#>
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
    
    var path: String {
        return self.networkInfo.path
    }
    
    var isLocal: Bool {
        return self.networkInfo.isLocal
    }
    
    var namespace: String {
        return self.networkInfo.namespace
    }
    
    func addingPath(_ path: String) -> ParsedURL {
        return ParsedURL(networkInfo: self.networkInfo.addingPath(path))
    }
    
    func __addPath(_ path: String) {
        self.networkInfo.__addPath(path)
    }
    
}
