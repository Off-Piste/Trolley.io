/////////////////////////////////////////////////////////////////////////////////
//
//  JSONCore.swift
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
import TrolleyCore.Dynamic

private func value<X, Y>(_ x: X, as y: Y.Type) -> Y {
    return x as! Y
}

internal struct JSONCore {

    var base: TRLMutableJSON

    init(_ base: TRLJSON) {
        self.base = value(base.mutableCopy(), as: TRLMutableJSON.self)
    }

    /// Copy is used when conforming to _ObjectiveCBridgeable
    /// as we use the base `TRLJSON` as its bridge type rather
    /// than `TRLMutableJSON` just like Swift stdlib
    var copy: TRLJSON {
        return value(base.copy(), as: TRLJSON.self)
    }

}

extension JSONCore {

    var count: Int {
        return Int(base.count)
    }

    subscript(key: String) -> JSONCore {
        get {
            return base.object(for: key).toCore
        }
        set {
            TRLJSONBaseSetObjectForKeyedSubscript(base, key, newValue.copy)
        }
    }

    subscript(index: Int) -> JSONCore {
        get {
            return base.object(at: UInt(index)).toCore
        }
        set {
            TRLJSONBaseSetObjectForIndexedSubscript(base, UInt(index), TRLJSONBase(rawValue: newValue.copy))
        }
    }

}

extension JSONCore: Hashable {

    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    var hashValue: Int {
        return self.base.hashValue
    }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: JSONCore, rhs: JSONCore) -> Bool {
        return lhs.base.isEqual(rhs.base)
    }

}
