/////////////////////////////////////////////////////////////////////////////////
//
//  Trolley.swift
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 07.09.17.
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

extension Trolley {

    public struct Error {

        public typealias Code = TRLError.Code

        public static let invalidURL: Code = .invalidURL

        public static let jsonUnsupportedType: Code = .jsonUnsupportedType

        public static let jsonInvalidJSON: Code = .jsonInvalidJSON

        public static let jsonWrongType: Code = .jsonWrongType

        public static let jsonIndexOutOfBounds: Code = .jsonIndexOutOfBounds

        public static let jsonErrorNotExist: Code = .jsonErrorNotExist

        /// :nodoc:
        public var code: Code {
            return (_nsError as! TRLError).code
        }

        /// :nodoc:
        public var _nsError: NSError

        /// :nodoc:
        public init(_nsError error: NSError) {
            _nsError = error
        }

    }

}

internal func TRLMakeError(_ code: Trolley.Error.Code, _ msg: String) {
    
}

extension Trolley.Error : _BridgedStoredNSError {

    /// :nodoc:
    public static var _nsErrorDomain = TRLErrorDomain
}

// MARK: Equatable

extension Trolley.Error: Equatable {}

/// Returns a Boolean indicating whether the errors are identical.
public func == (lhs: Error, rhs: Error) -> Bool {
    return lhs._code == rhs._code
        && lhs._domain == rhs._domain
}

// MARK: Pattern Matching

/**
 Pattern matching matching for `Realm.Error`, so that the instances can be used with Swift's
 `do { ... } catch { ... }` syntax.
 */
public func ~= (lhs: Trolley.Error, rhs: Error) -> Bool {
    return lhs == rhs
}
