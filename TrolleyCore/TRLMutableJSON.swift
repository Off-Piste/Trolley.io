/////////////////////////////////////////////////////////////////////////////////
//
//  TRLMutableJSON.swift
//  TrolleyCore
//
//  Created by Harry Wright on 24.08.17.
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
//   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

public final class TRLMutableJSON: TRLJSON {

    public var dictionaryObject: [String : Any] {
        get { return self.dictionary }
        set { json.dictionaryObject = newValue }
    }

    public var arrayObject: [Any] {
        get { return self.array }
        set { json.arrayObject = newValue }
    }

    public var boolValue: Bool {
        get { return self.bool }
        set { self.json.bool = newValue }
    }

    public var numberValue: NSNumber {
        get { return self.number }
        set { self.json.number = newValue }
    }

    public var stringValue: String {
        get { return self.string }
        set { self.json.string = newValue }
    }

    public func setValue(_ value: Any?, withKey key: String) {
        switch value {
        case .none: self.json[key].object = NSNull()
        case .some(let W): self.json[key].object = W
        }
    }

    public func setNilForValueWithKey(_ key: String) {
        self.json[key].object = NSNull()
    }

    public func setValue(_ value: Any?) {
        switch value {
        case .none: self.json.object = NSNull()
        case .some(let W): self.json.object = W
        }
    }

}
