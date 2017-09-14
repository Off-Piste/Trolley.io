/////////////////////////////////////////////////////////////////////////////////
//
//  JSON+Bridging.swift
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 06.09.17.
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

extension JSON: _ObjectiveCBridgeable {
    
    public typealias _ObjectiveCType = TRLJSON

    /// Try to bridge from an Objective-C object of the bridged class
    /// type to a value of the Self type.
    ///
    /// This conditional bridging operation is used for conditional
    /// downcasting (e.g., via as?) and therefore must perform a
    /// complete conversion to the value type; it cannot defer checking
    /// to a later time.
    ///
    /// - parameter result: The location where the result is written.
    ///
    /// - Returns: `true` if bridging succeeded, `false` otherwise. This redundant
    ///   information is provided for the convenience of the runtime's `dynamic_cast`
    ///   implementation, so that it need not look into the optional representation
    ///   to determine success.
    @discardableResult
    public static func _conditionallyBridgeFromObjectiveC(_ source: TRLJSON, result: inout JSON?) -> Bool {
        if source.error != nil {
            return false
        }
        result = JSON(_core: source.toCore)
        return true
    }

    /// Bridge from an Objective-C object of the bridged class type to a
    /// value of the Self type.
    ///
    /// This bridging operation is used for unconditional bridging when
    /// interoperating with Objective-C code, either in the body of an
    /// Objective-C thunk or when calling Objective-C code, and may
    /// defer complete checking until later. For example, when bridging
    /// from `NSArray` to `Array<Element>`, we can defer the checking
    /// for the individual elements of the array.
    ///
    /// - parameter source: The Objective-C object from which we are
    /// bridging. This optional value will only be `nil` in cases where
    /// an Objective-C method has returned a `nil` despite being marked
    /// as `_Nonnull`/`nonnull`. In most such cases, bridging will
    /// generally force the value immediately. However, this gives
    /// bridging the flexibility to substitute a default value to cope
    /// with historical decisions, e.g., an existing Objective-C method
    /// that returns `nil` to for "empty result" rather than (say) an
    /// empty array. In such cases, when `nil` does occur, the
    /// implementation of `Swift.Array`'s conformance to
    /// `_ObjectiveCBridgeable` will produce an empty array rather than
    /// dynamically failing.
    public static func _unconditionallyBridgeFromObjectiveC(_ source: TRLJSON?) -> JSON {
        return JSON(_core: source?.toCore ?? TRLJSON.null().toCore)
    }

    /// Bridge from an Objective-C object of the bridged class type to a
    /// value of the Self type.
    ///
    /// This bridging operation is used for forced downcasting (e.g.,
    /// via as), and may defer complete checking until later. For
    /// example, when bridging from `NSArray` to `Array<Element>`, we can defer
    /// the checking for the individual elements of the array.
    ///
    /// - parameter result: The location where the result is written. The optional
    ///   will always contain a value.
    public static func _forceBridgeFromObjectiveC(_ source: TRLJSON, result: inout JSON?) {
        if let error = source.error {

            // When running main tests can use Nimble as precondition
            // testing has been added from this blog
            // http://www.cocoawithlove.com/blog/2016/02/02/partial-functions-part-two-catching-precondition-failures.html
            let msg = "Forcing JSON conversion requires valid TRLJSON"
            NSException(name: .invalidArgumentException, reason: msg, userInfo: [NSLocalizedDescriptionKey:error.localizedDescription]).raise()

            
        }

        result = JSON(_core: source.toCore)
    }

    /// Convert self to Objective-C.
    public func _bridgeToObjectiveC() -> _ObjectiveCType {
        return _core.copy
    }
}
