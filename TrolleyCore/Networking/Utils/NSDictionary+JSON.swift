/////////////////////////////////////////////////////////////////////////////////
//
//  NSDictionary+JSON.swift
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 31.08.17.
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

extension JSONType: CustomStringConvertible {

    public var description: String {
        switch self {
        case .array: return "Array"
        case .bool: return "Bool"
        case .dictionary: return "Dictionary"
        case .null: return "Null"
        case .number: return "Number"
        case .string: return "String"
        case .unknown: return "Invalid JSON"
        }
    }
    
}

@objc final public class NSArrayIndex: NSObject {

    public var underlyingError: Error?

    public var newObject: Any?

    public init(newObject: Any?, error: Error?) {
        self.underlyingError = error
        self.newObject = newObject
    }

}

extension NSDictionary {
    @objc public var isJSON: Bool {
        if self.count == 0 { return false }
        return self is Dictionary<String, TRLJSON>
    }
}

extension NSArray {

    @objc public var isJSON: Bool {
        if self.count == 0 { return false }
        return self is Array<TRLJSON>
    }

    @objc public func mapThrows(_ block: (Any) -> NSArrayIndex) throws -> [Any] {
        let array = try self.map { (objc) -> Any in
            let blk = block(objc)
            if let error = blk.underlyingError {
                throw error
            } else {
                return blk.newObject!
            }
        }
        return array
    }

}

