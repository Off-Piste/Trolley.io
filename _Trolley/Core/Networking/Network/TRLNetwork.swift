//
//  Network.swift
//  Network
//
//  Created by Harry Wright on 19.06.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

import Foundation
@_exported import Alamofire

internal struct TRLNetwork {
    
    var parsedURL: ParsedURL
    
    internal init(_ url: URLConvertible) throws {
        self.parsedURL = try ParsedURL(url)
    }
    
    internal init?(url: URLConvertible) {
        do {
            self.parsedURL = try ParsedURL(url)
        } catch {
            return nil
        }
    }
    
}

extension TRLNetwork: CustomStringConvertible {
    
    public var description: String {
        return "\(parsedURL)"
    }
    
}

extension TRLNetwork {
    
    internal func get(
        _ route: String,
        with parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?
        ) -> TRLRequest
    {
        return self._get(route, parameters, encoding, headers)
    }
    
    private func _get(
        _ route: String,
        _ parameters: Parameters?,
        _ encoding: ParameterEncoding,
        _ headers: HTTPHeaders?
        ) -> TRLRequest
    {
        let aURL = parsedURL.addingPath(route)
        return TRLRequest(
            url: aURL,
            method: .get,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
    }
    
}

extension TRLNetwork {
    
    internal func post(
        _ route: String,
        with parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?
        ) -> TRLRequest
    {
        return self._post(route, parameters, encoding, headers)
    }
    
    private func _post(
        _ route: String,
        _ parameters: Parameters?,
        _ encoding: ParameterEncoding,
        _ headers: HTTPHeaders?
        ) -> TRLRequest
    {
        let aURL = parsedURL.addingPath(route)
        return TRLRequest(
            url: aURL,
            method: .post,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
    }
    
}
