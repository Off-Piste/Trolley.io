//
//  TRLNetwork.swift
//  Pods
//
//  Created by Harry Wright on 15.06.17.
//
//

import Foundation
import PromiseKit
import Alamofire

extension URLConvertible {
    
    var string: String {
        do {
            return try self.asURL().absoluteString
        } catch  {
            return ""
        }
        
    }
    
}

extension TRLUtilities {
    
    func parseURL(_ url: URLConvertible, checkingForError check: Bool = false) -> ParsedURL {
        return self.parseURL(url.string, checkingForError: check)
    }
    
    func validate(_ url: ParsedURL, key APIKey: String) {
        if url.requestUrl == nil { fatalError("Failed Validation Check 1 : No request URL") }
        let (_, _, _, path, url) = self.split(url: url.requestUrl!.absoluteString)
        let _ = self.parseURL(url!.absoluteString) // checks for the default errors
        
        // Removes the /API as thats already been checked for
        var mutatingPath = (path as NSString).substring(from: 1)
        var slashIndex = (mutatingPath as NSString).range(of: "/").location
        mutatingPath = (mutatingPath as NSString).substring(from: slashIndex + 1)
        
        // Checks the API Key
        let key: String
        if APIKey.isEmpty { fatalError("API Key is rquired for calls to the database") }
        slashIndex = (mutatingPath as NSString).range(of: "/").location
        if slashIndex == NSNotFound { // the url is only "API/id"
            key = mutatingPath
        } else {
            key = (mutatingPath as NSString).substring(to: slashIndex)
        }
        
        if key != APIKey { fatalError("Failed Validation Check 2 : Invalid API Key for \(path)") }
    }
}

// TODO: - Check to see if removing Custom URL's is a good idea
// this is becasue we wouldn't want any random calls been used
// and clogging up anything, so could keep to save them using
// Alamofire and then so i can weign my self off them

public struct TRLNetwork {
    
    /// The URL that has been parsed and validated
    fileprivate(set) var parsedURL: ParsedURL
    
    /// The default notification center
    fileprivate var notificationCenter: NotificationCenter {
        return NotificationCenter.default
    }
    
    var delegate: NetworkableDelegate?
    
    /// An Initaliser that will allow the device to create a network that
    /// all calls will be made from.
    ///
    /// - Parameters:
    ///   - url: The string URL, will cause a fatal error if the url is invalid,
    ///          this should never happen
    ///   - APIKey: The Current Developers API key, will never be entered
    ///             by them, always done internally
    internal init(_ url: ParsedURL, APIKey: String) {
        self.parsedURL = url
        self.parsedURL.addPath(APIKey)
        
        // May look at changing this
        TRLUtilities.singleton.validate(self.parsedURL, key: APIKey)
    }
    
    /// An Initaliser that will allow the device to create a network that
    /// all calls will be made from.
    ///
    /// - Note:
    /// Even though technically the `ParsedURL` init should surfice for the
    /// string call, due to conforming to `ExpressibleByStringLiteral`, the complier
    /// throws a wobbler
    ///
    /// - Parameters:
    ///   - url: The string URL, will cause a fatal error if the url is invalid,
    ///          this should never happen
    ///   - APIKey: The Current Developers API key, will never be entered
    ///             by them, always done internally
    internal init(_ url: String, APIKey: String) {
        self.init(ParsedURL(url), APIKey: APIKey)
    }
    
}

extension TRLNetwork {

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - database: <#database description#>
    ///   - parameters: <#parameters description#>
    /// - Returns: <#return value description#>
    internal func get(_ database: Database, with parameters: Parameters) -> TRLResponse {
        self.parsedURL.addPath(database.name)
        return self.get(self.parsedURL, with: parameters)
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - route: <#route description#>
    ///   - parameters: <#parameters description#>
    /// - Returns: <#return value description#>
    internal func get(_ route: String, with parameters: Parameters) -> TRLResponse {
        self.parsedURL.addPath(route)
        return self.get(self.parsedURL, with: parameters)
    }
    
    /// <#Description#>
    ///
    /// - Parameter parameters: <#parameters description#>
    /// - Returns: <#return value description#>
    internal func get(with parameters: Parameters) -> TRLResponse {
        return self.get(self.parsedURL, with: parameters)
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - parameters: <#parameters description#>
    /// - Returns: <#return value description#>
    private func get(_ url: URLConvertible, with parameters: Parameters) -> TRLResponse {
        let request = Alamofire.request(url, method: .get, parameters: parameters)
        let response = request.validate().response()
        
        return TRLResponse(promise: response, delegate: nil)
    }
    
}
