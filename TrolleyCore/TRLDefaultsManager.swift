//
//  TRLDefaultsManager.swift
//  Trolley
//
//  Created by Harry Wright on 17.09.17.
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

@objc public final class TRLDefaultsManager: NSObject {

    private var defaults: UserDefaults {
        return UserDefaults.standard
    }

    private var _key: String

    /// Initaliser to set up the key
    ///
    /// - Parameter key: The string key for UD
    @nonobjc
    public init(withKey key: String) {
        self._key = key
    }

    /// Initaliser to set up the key
    ///
    /// - Parameter key: The string key for UD
    @available(swift, introduced: 1.0, obsoleted: 1.0)
    @objc(managerForKey:)
    public static func __managerForKey(_ key: String) -> TRLDefaultsManager {
        return TRLDefaultsManager(withKey: key)
    }

    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    @objc(retriveObject:)
    public final func retrieveObject() throws -> Any {
        guard let data = defaults.data(forKey: _key) else {
            throw TRLMakeError(.nsudNilReturnValue, _key)
        }

        return try Encoder.decode(data: data, forKey: _key)
    }

    /// <#Description#>
    ///
    /// - Parameter object: <#object description#>
    @objc(setObject:)
    public func set(_ object: Any) {
        let data = Encoder(withObject: object).data
        self.defaults.set(data, forKey: self._key)
    }

    /// The method to remove objects for the key
    @objc(clearObject)
    public func clear() {
        defaults.removeObject(forKey: _key)
    }

}

fileprivate class Encoder {

    /// The data of the object.
    ///
    /// # NOTE
    /// Custom classes must conform to `NSCoding`.
    let data: Data

    /// Initalsier to set the object and encode it as data
    ///
    /// - Parameter object: Any object, please confom custom objects to `NSCoding`
    init(withObject object: Any) {
        self.data = NSKeyedArchiver.archivedData(withRootObject: object)
    }

    /// The method for whichh objects are attemped to be decoded
    ///
    /// Checks for `Basket.Helper` due to the struct having its down decode methods built in
    ///
    /// - Parameters:
    ///   - data: The retrived data
    ///   - key: The key for the object, used in the throw
    /// - Returns: An Any object that can be used and converted by the user
    /// - Throws: An `ManagerError` if the object cannot be unarchived
    class func decode(data: Data, forKey key: String) throws -> Any {
        guard let object = NSKeyedUnarchiver.unarchiveObject(with: data) else {
            throw TRLMakeError(.nsudCouldNotUnarchive, key)
        }

        return object
    }
    
}
