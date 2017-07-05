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

extension URLConvertible {
    
    var desc: String {
        return ((try? asURL()) == nil) ? "invalidURL" : try! self.asURL().absoluteString
    }
    
}

@objc public class TRLRequest : NSObject {

    internal var url: URLConvertible

    internal var method: HTTPMethod

    internal var parameters: Parameters?

    internal var encoding: ParameterEncoding

    internal var headers: HTTPHeaders?
    
    internal var error: Error?

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

internal extension TRLRequest {

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

    // Make sure this calls `validate()` becasue if not the code will
    // never hit any errors and will seem like its all fine. Errors will
    // be sent back by JSON also so the code will think it is all clear.
    var promise: Promise<(URLRequest, HTTPURLResponse, Data)> {
        return dataRequest.validate().response()
    }

}

extension TRLRequest {

    public override var description: String {
        var values: [String] = []
        values.append(try! self.url.asURL().absoluteString)
        values.append(self.method.rawValue)
        return values.joined(separator: " ")
    }

}

extension TRLRequest : Networkable {

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - queue: <#queue description#>
    ///   - handler: <#handler description#>
    /// - Returns: <#return value description#>
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

    /// <#Description#>
    ///
    /// - Parameter handler: <#handler description#>
    @objc public func responseData(handler: @escaping DefaultHandler) {
        self.responseData().then {
            handler($0, nil)
        }.catch {
            handler(nil, $0)
        }
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    public func responseData() -> Promise<Data> {
        TRLCoreNetworkingLogger.debug("Creating URL Request for \(self.dataRequest)")
        
        return Promise { fullfill, reject in
            if let error = self.error { reject(error); return }
            
            self.promise.then {
                fullfill($0.2)
            }.catch {
                reject($0)
            }
        }
    }
    
}
