/////////////////////////////////////////////////////////////////////////////////
//
//  TRLURLRequestTask.swift
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 08.09.17.
//  Copyright © 2017 Off-Piste.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

@objc public protocol RequestAdapter: class {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest
}

extension NSURLRequest {

    func adapt(using adapter: RequestAdapter?) throws -> URLRequest {
        guard let adapter = adapter else { return self as URLRequest }
        return try adapter.adapt(self as URLRequest)
    }

}

extension URLRequest {

    func adapt(using adapter: RequestAdapter?) throws -> URLRequest {
        guard let adapter = adapter else { return self }
        return try adapter.adapt(self)
    }

}

@objc public protocol TRLTaskConvertible: class {

    @objc func task(session: URLSession, request: RequestAdapter?, queue: DispatchQueue) throws -> URLSessionTask

}

@objc public final class TRLURLDataRequestHelper: NSObject, TRLTaskConvertible {

    @objc public let urlRequest: URLRequest

    @objc public init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }

    @objc public func task(session: URLSession, request: RequestAdapter?, queue: DispatchQueue) throws -> URLSessionTask {
        do {
            let request = try self.urlRequest.adapt(using: request)
            return queue.sync { session.dataTask(with: request) }
        } catch  {
            throw error
        }
    }

}

/// This class is a workaround for the fact you can't have
/// an enum like:
///
///     enum RequestType {
///         .data(TRLTaskConvertible?, URLSessionTask?),
///         .download(TRLTaskConvertible?, URLSessionTask?)
///     }
///
/// in Objc so you would pass this like an enum and use:
///
///     if ([... isKindOf:[type1 class]]) { /*...*/ }
///     else if ([... isKindOf:[type1 class]]) { /*...*/ }
///     etc
///
/// Rather than the switch statement
///
@objc public class TRLURLRequestTaskType: NSObject {

    @objc public var originalTask: TRLTaskConvertible?

    @objc public var sessionTask: URLSessionTask?

    @objc public init(originalTask: TRLTaskConvertible?, sessionTask: URLSessionTask?) {
        self.originalTask = originalTask
        self.sessionTask = sessionTask
    }

}

@objc public class TRLURLRequestTaskTypeData: TRLURLRequestTaskType { }
