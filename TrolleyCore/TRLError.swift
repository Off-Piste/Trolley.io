/////////////////////////////////////////////////////////////////////////////////
//
//  TRLError.swift
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
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

@objc public final class TRLError: NSObject {

    @objc public static func invalidURL(_ url: String) -> Error {
        let msg = "The url entered: \(url) is invalid"
        return NSError(domain: "io.trolley", code: -200, userInfo: [NSLocalizedDescriptionKey:msg])
    }

    @objc public static var urlIsNil: Error {
        let msg = "The operation cannot be processed due to a nil url"
        return NSError(domain: "io.trolley", code: -200, userInfo: [NSLocalizedDescriptionKey:msg])
    }

    @objc public static func parameterEncodingFailed(reason: String) -> Error {
        let msg = "The operation cannot be processed due to a missing parameter: \(reason)"
        return NSError(domain: "io.trolley", code: -200, userInfo: [NSLocalizedDescriptionKey:msg])
    }

    @objc public static func invalidJSON(_ str: String?) -> Error {
        let msg: String!
        if str != nil {
            msg = "The current JSON: \(str!) is invalid, please check"
        } else {
            msg = "The current JSON being passed through is invalid, please check"
        }
        return NSError(domain: "io.trolley", code: ErrorInvalidJSON, userInfo: [NSLocalizedDescriptionKey:msg])
    }
}
