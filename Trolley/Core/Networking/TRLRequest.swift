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

public class TRLRequest {

    internal var url: URLConvertible

    internal var method: HTTPMethod

    internal var parameters: Parameters?

    internal var encoding: ParameterEncoding

    internal var headers: HTTPHeaders?

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

    var promise: Promise<(URLRequest, HTTPURLResponse, Data)> {
        return dataRequest.response()
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
    public func responseData(handler: @escaping DefaultHandler) {
        TRLCoreNetworkingLogger.debug("Creating URL Request for \(self.dataRequest)")
        
        self.dataRequest.responseData { (response) in
            handler(response.data, response.error)
        }
    }

    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    public func responseData() -> Promise<Data> {
        TRLCoreNetworkingLogger.debug("Creating URL Request for \(self.dataRequest)")
        
        return Promise { fullfill, reject in
            self.promise.then(execute: { (_, _, data) -> Void in
                fullfill(data)
            }).catch(execute: { (error) in
                reject(error)
            })
        }
    }

}
