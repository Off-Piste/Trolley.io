//
//  RequestBuilder.swift
//  Network
//
//  Created by Harry Wright on 19.06.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

import Foundation
import PromiseKit

func request(_ request: TRLRequest) -> DataRequest {
    return Alamofire.request(
        request.url,
        method: request.method,
        parameters: request.parameters,
        encoding: request.encoding,
        headers: request.headers
    )
}

let kFilterQueryKey: String = "filter"
let kSearchQueryKey: String = "search"
let kRateQueryKey: String = "limit"
let kPageQueryKey: String = "next-page"

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

fileprivate extension TRLRequest {
    
    var `default`: TRLRequest {
        return TRLRequest(
            url: url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
    }
    
    var dataRequest: DataRequest {
        return request(self)
    }
    
    var promise: Promise<(URLRequest, HTTPURLResponse, Data)> {
        return dataRequest.response()
    }
    
}

public extension TRLRequest {
    
    func rate(_ value: Int) -> TRLRequest {
        assert(self.method == .get, "\(#function) can only be used by .get requests")
        assert(self.parameters != nil, "Cannot use \(#function) with nil prarameters")
        
        self.parameters?.updateValue(value, forKey: kRateQueryKey)
        return self.default
    }
    
    func page(_ value: Int) -> TRLRequest {
        assert(self.method == .get, "\(#function) can only be used by .get requests")
        assert(self.parameters != nil, "Cannot use \(#function) with nil prarameters")
        
        self.parameters?.updateValue(value, forKey: kPageQueryKey)
        return self.default

    }
    
    func filter(_ predicateFormat: String) -> TRLRequest {
        assert(self.method == .get, "\(#function) can only be used by .get requests")
        assert(self.parameters != nil, "Cannot use \(#function) with nil prarameters")
        
        let _ = NSPredicate(format: predicateFormat)
        guard let data = predicateFormat.data(using: .utf8) else {
            Log.info("The NSPredicate format could not be converted to Data so the request will not be carried out")
            return self.default
        }
        
        self.parameters?.updateValue(data, forKey: kFilterQueryKey)
        return self.default
    }
    
    func search(for value: String) -> TRLRequest {
        assert(self.method == .get, "\(#function) can only be used by .get requests")
        assert(self.parameters != nil, "Cannot use \(#function) with nil prarameters")
        
        self.parameters?.updateValue(value, forKey: kSearchQueryKey)
        return self.default
    }
    
    func validate() -> Networkable {
        Log.debug("Validating the request")
        
        self.dataRequest.validate()
        return self
    }
    
    /// Method to check the query parameters
    func _validateRequest() -> Error? {
        let queryParameters = URLQuery(self.url)
        
        if queryParameters[kPageQueryKey] == nil,
            queryParameters[kRateQueryKey] == nil {
            return createError("page(_:) needs to be called with rate(_:)")
        }
        
        return nil
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
        if let error = self._validateRequest() {
            handler(nil, error)
        }
        
        self.dataRequest.responseData { (response) in
            handler(response.data, response.error)
        }
    }
    
    public func responseData() -> Promise<Data> {
        return Promise { fullfill, reject in
            if let error = self._validateRequest() {
                reject(error)
            }
            
            self.promise.then(execute: { (_, _, data) -> Void in
                fullfill(data)
            }).catch(execute: { (error) in
                reject(error)
            })
        }
    }
    
}
