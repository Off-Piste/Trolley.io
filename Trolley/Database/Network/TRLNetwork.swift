//
//  TRLNetwork.swift
//  Pods
//
//  Created by Harry Wright on 15.06.17.
//
//

import Foundation
import PromiseKit

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
    
    /// <#Description#>
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
        self.parsedURL.__addPath(APIKey)
        
        // May look at changing this
        TRLUtilities.singleton.validate(self.parsedURL, key: APIKey)
    }
    
    internal init(_ url: String, APIKey: String) {
        let parsedURL: ParsedURL = ParsedURL(url)
        self.init(parsedURL, APIKey: APIKey)
    }
    
}

extension TRLNetwork {

    /// The method to get the items in the database
    ///
    /// - Parameters:
    ///   - database: The required database
    ///   - parameters: The parameters of the url
    /// - Returns: The `TRLResponse` for the request
    internal func get(_ database: Database, with parameters: Parameters) -> TRLNetworkResponse {
        let anURL = self.parsedURL.addingPath(database.name)
        
        return self._get(anURL, with: parameters)
    }
    
    /// The method to call a get request on a custom route,
    /// this could be for a request that uses "/<something>/<something>"
    /// that the `get(_:Database,with:)` could not hit
    ///
    /// - Parameters:
    ///   - route: The required route
    ///   - parameters: The parameters of the url
    /// - Returns: The `TRLResponse` for the request
    internal func get(_ route: String, with parameters: Parameters) -> TRLNetworkResponse {
        let anURL = self.parsedURL.addingPath(route)
        
        return self._get(anURL, with: parameters)
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - parameters: <#parameters description#>
    /// - Returns: <#return value description#>
    private func _get(_ url: URLConvertible, with parameters: Parameters) -> TRLNetworkResponse {
        let request = Alamofire.request(url, method: .get, parameters: parameters)
        let response = request.validate().response()
        
        return TRLNetworkResponse(promise: response, delegate: nil)
    }
    
}
