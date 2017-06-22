//
//  RequestBuilder.swift
//  Network
//
//  Created by Harry Wright on 19.06.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

import Foundation
import Alamofire

//public func request(_ url: URLConvertible, method: Alamofire.HTTPMethod = default, parameters: Parameters? = default, encoding: ParameterEncoding = default, headers: HTTPHeaders? = default) ->

func request(_ request: TRLRequest) -> DataRequest {
    return Alamofire.request(
        request.url,
        method: request.method,
        parameters: request.parameters,
        encoding: request.encoding,
        headers: request.headers
    )
}

public class TRLRequest {
    
    fileprivate var url: URLConvertible
    
    fileprivate var method: HTTPMethod
    
    fileprivate var parameters: Parameters?
    
    fileprivate var encoding: ParameterEncoding
    
    fileprivate var headers: HTTPHeaders?
    
    init(
        url: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?
        )
    {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
    }
    
}

extension TRLRequest {
    
    fileprivate var `default`: TRLRequest {
        return TRLRequest(
            url: url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
    }
    
    fileprivate var dataRequest: DataRequest {
        return request(self)
    }
    
}

public extension TRLRequest {
    
    func rate(_ value: Int) -> TRLRequest {
        self.parameters?.updateValue(value, forKey: "limit")
        return self.default
    }
    
    func filter(_ predicateFormat: String) -> TRLRequest {
        let _ = NSPredicate(format: predicateFormat)
        guard let data = predicateFormat.data(using: .utf8) else {
            return self.default
        }
        
        self.parameters?.updateValue(data, forKey: "filter")
        return self.default
    }
    
    func search(for value: String) -> TRLRequest {
        self.parameters?.updateValue(value, forKey: "search")
        return self.default
    }
    
}

extension TRLRequest : CustomStringConvertible {
    
    public var description: String {
        var values: [String] = []
        values.append(try! self.url.asURL().absoluteString)
        values.append(self.method.rawValue)
        return values.joined(separator: " ")
    }
    
}

extension TRLRequest : Networkable {
    
    public func progress(
        queue: DispatchQueue = .main,
        handler: @escaping (Progress) -> Void
        ) -> Networkable
    {
        self.dataRequest.downloadProgress(queue: queue) { (progress) in
            handler(progress)
        }
        return self
    }
    
    public func responseData(handler: @escaping DefaultHandler) {
        self.dataRequest.responseData { (response) in
            handler(response.data, response.error)
        }
    }
    
}
