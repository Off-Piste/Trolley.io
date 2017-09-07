/////////////////////////////////////////////////////////////////////////////////
//
//  TRLJSON.swift
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

/// TRLJSON is a SwiftyJSON/Objc port
/// everything runs though SwiftJSON
/// but is designed to be an interface
/// for my Objc Tools
public class TRLJSON: NSObject {

    public internal(set) var json: JSON

    // MARK: Inits

    public override init() {
        self.json = JSON.null
    }

    public init(data: Data) {
        self.json = JSON(data: data)
    }

    public init(nullable_data: Data?) throws {
        if let data = nullable_data {
            self.json = JSON(data: data)
        } else {
            throw NSError(domain: ErrorDomain, code: ErrorInvalidJSON, userInfo: [NSLocalizedDescriptionKey:"Invalid JSON"])
        }
    }

    public init(_ objects: Any) {
        self.json = JSON(objects)
    }

    internal init(json: JSON) {
        self.json = json
    }

    final public var type: JSONType {
        return self.json.type
    }

    // MARK: Objc Overrides

    public override var description: String {
        return json.description
    }

    public override func isEqual(_ object: Any?) -> Bool {
        if let json = object as? JSON {
            return json == self.json
        } else if let json = object as? TRLJSON {
            return json.json == self.json
        }
        return super.isEqual(object)
    }

    final public override func value(forKey key: String) -> Any? {
        return self.json[key].object
    }

    final public override func mutableCopy() -> Any {
        return TRLMutableJSON(json: self.json)
    }
}

// MARK: - Get Properties
extension TRLJSON {

    /// <#Description#>
    ///
    /// - Parameter key: <#key description#>
    final public subscript(key: String) -> TRLJSON {
        return TRLJSON(json: self.json[key])
    }

    /// An error with the JSON. Will be nil
    /// if the JSON is valid
    final public var error: Error? {
        return self.json.error
    }

    /// The `Dictionary` value for the current JSON key
    ///
    /// - note: Will be empty if the JSON
    ///         value is not a dictionary
    final public var dictionary: [String: Any] {
        return self.json.dictionaryObject ?? [:]
    }

    /// The `String` value for the current JSON key
    ///
    /// - note: Will be set to `""` if the JSON
    ///         value is not a string, or string
    ///         convertable object
    final public var string: String {
        return self.json.stringValue
    }

    /// The `Bool` value for the current JSON key
    ///
    /// - note: Will be set to false if the JSON
    ///         value is not a BOOL
    @objc(boolean) final public var bool: Bool {
        return self.json.boolValue
    }

    /// The `NSNumber` value for the current JSON key
    ///
    /// - note: Will be set to `0` if the JSON
    ///         value is not a NSNumber or number
    ///         type.
    final public var number: NSNumber {
        return self.json.numberValue
    }

    /// The `Array<Any>` value for the current JSON key
    ///
    /// - note: Will be set to empty if the JSON
    ///         value is not an Arrat
    final public var array: [Any] {
        return self.json.arrayObject ?? []
    }

    /// The `Raw String` of the current JSON, this is
    /// helpful when wanting to view the JSON structure
    ///
    /// - note: Will be set to `""` is the JSON
    ///         is not valid
    final public var rawString: String {
        return self.json.rawString() ?? ""
    }

    /// The `Raw Data` for the current JSON
    ///
    /// - note: Will be `nil` if the `Data` is not valid
    final public var rawData: Data? {
        return try? self.json.rawData()
    }

}

// MARK: - NSObject Depreciations
extension TRLJSON {

    @available(*, unavailable, message: "TRLJSON is immutable")
    public override func setValue(_ value: Any?, forKey key: String) { }

    @available(*, unavailable, message: "TRLJSON is immutable")
    public override func setValue(_ value: Any?, forKeyPath keyPath: String) { }

    @available(*, unavailable, message: "TRLJSON is immutable")
    public override func setValue(_ value: Any?, forUndefinedKey key: String) { }

    @available(*, unavailable, message: "TRLJSON is immutable")
    public override func setNilValueForKey(_ key: String) { }

    @available(*, unavailable, message: "TRLJSON is immutable")
    public override func setValuesForKeys(_ keyedValues: [String : Any]) { }

}

// MARK: - Converting JSON -> TRLJSON
extension ObjectiveCSupport {

    public static func convert(object: TRLJSON) -> JSON {
        return object.json
    }

    public static func convert(object: JSON) -> TRLJSON {
        return TRLJSON(json: object)
    }

}

// MARK: - Request+JSON
extension Request {

    @nonobjc public func responseJSON(callback: @escaping (JSON?, Error?) -> Void) {
        self.response { (data, error) in
            if let error = error {
                callback(nil, error)
            } else {
                let json = JSON(data: data!)
                if let json_error = json.error {
                    callback(nil, json_error)
                } else {
                    callback(json, nil)
                }
            }
        }
    }

}

public typealias ArrayBlock = (Any, Int, Bool) -> Void

public typealias DictionaryBlock = (String, Any, Bool) -> Void

// MARK: - Objective C enumerations
extension TRLJSON {

    /// Applies a given block object to the entries of the dictionary.
    ///
    /// If the block sets *stop to true, the enumeration stops.
    ///
    /// - warning: If the JSON is not a dictionary then the
    ///            block will not be called.
    ///
    /// - Parameter block: A block object to operate on entries in the dictionary.
    final public func enumerateKeysAndObjectsUsingBlock(_ block: DictionaryBlock) {
        if self.json.type == .dictionary {
            (self.dictionary as NSDictionary).enumerateKeysAndObjects({ (key, obj, stop) in
                if let key = key as? String {
                    block(key, obj, stop.pointee.boolValue)
                }
            })
        }
        return
    }

    /// Executes a given block using each object in the array, 
    /// starting with the first object and continuing through the 
    /// array to the last object.
    ///
    /// - warning: If the JSON is not an array then the
    ///            block will not be called.
    ///
    /// - Parameter block: The block to apply to elements in the array.
    final public func enumerateObjects(_ block: ArrayBlock) {
        if self.json.type == .array {
            (self.array as NSArray).enumerateObjects({ (obj, index, stop) in
                block(obj, index, stop.pointee.boolValue)
            })
        }
        return
    }

}
