/////////////////////////////////////////////////////////////////////////////////
//
//  TRLURLResponse.swift
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 12.09.17.
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

/// This class will be used as the default internal response
/// for all network calls, this way we can validate differently 
/// to Alamofire and do so after we have our response as we may
/// special response codes to signify certain responses.
///
/// - warning: Internal Code, do not use
///
/// :nodoc:
@objc public class TRLURLResponse : NSObject {

    /// The URL request sent to the server.
    public let request: URLRequest?

    /// The server's response to the URL request.
    public let response: HTTPURLResponse?

    /// The data returned by the server.
    public let data: Data?

    /// The error encountered while executing or validating the request.
    public let error: Error?

    public init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
    {
        self.request = request
        self.response = response
        self.data = data
        self.error = error

        super.init()
    }

}
