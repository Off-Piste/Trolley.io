//
//  Request.swift
//  Pods
//
//  Created by Harry Wright on 17.06.17.
//
//

import Foundation
import PromiseKit

public struct TRLRequest {
    
    var url: URLConvertible
    
    var method: HTTPMethod
    
    var parameters: Parameters?
    
    var encoding: URLEncoding
    
    var headers: HTTPHeaders?
    
    public var response: TRLNetworkResponse {
        let request = Alamofire.request(
            self.url,
            method: self.method,
            parameters: self.parameters,
            encoding: self.encoding,
            headers: self.headers
        )
        
        return TRLNetworkResponse(promise: request.validate().response(), delegate: nil)
    }
    
    public func addNotificationBlock<T>(_ type: TRLNotificationTypes = .productUpdated) -> TRLNotificationManager<T> {
        let notification = TRLNotification<T>(type)
        let req: RequestType = (self.url, self.method, self.parameters, self.encoding, self.headers)
        return TRLNotificationManager<T>(notification, withRequest: req)
    }
    
    init(_ url: URLConvertible,
         method: HTTPMethod = .get,
         parameters: Parameters? = nil,
         encoding: URLEncoding = .default,
         headers: HTTPHeaders? = nil
        )
    {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
    }
    
    public func filter(_ predicteFormat: String) -> TRLNetworkResponse {
        guard let data = predicteFormat.data(using: .utf8) else {
            let request = Alamofire.request(
                self.url,
                method: self.method,
                parameters: self.parameters,
                encoding: self.encoding,
                headers: self.headers
            )
            
            return TRLNetworkResponse(promise: request.validate().response(), delegate: nil)
        }
        var param = self.parameters
        param?.updateValue(data.base64EncodedString(), forKey: "filter")
        
        let request = Alamofire.request(
            self.url,
            method: self.method,
            parameters: param,
            encoding: self.encoding,
            headers: self.headers
        )
        
        return TRLNetworkResponse(promise: request.validate().response(), delegate: nil)
    }
    
    
}
