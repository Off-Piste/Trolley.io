//
//  DefaultsManager.swift
//  Pods
//
//  Created by Harry Wright on 12.04.17.
//
//

import Foundation
import SwiftyJSON

public protocol JSONCoding {
    
    func encode() throws -> Data
    
    func decode(_ data: Data) throws -> JSON
    
}

/// The errors that will be thrown
///
/// - returnValueNil: The value that is being requested is nil
/// - couldNotUnarchive: The encoder could not encode the data
public enum DefaultsManagerError: Error {
    
    case returnValueNil(forKey: String)
    case couldNotUnarchive(forKey: String)
    case couldNotConvert(Any, to: Any)
    
    var localizedDescription: String {
        switch self {
        case .returnValueNil(let key):
            return "Cannot retrive the data, please check the key(\(key)) used to set and retrive are the same"
        case .couldNotUnarchive(let key):
            return "NSKeyedUnarchiver cannot unarchive the value for key: \(key). Please report this toy use via gitbug"
        case .couldNotConvert(let first, let second):
            return "Could not convert \(first) to \(second)"
        }
    }
}

/// Shorter name for `DefaultsManagerError`
public typealias ManagerError = DefaultsManagerError

@objc(TRLDefaultsManager)
public class DefaultsManager : NSObject {
    
    /// The standard UserDefaults shared instance
    private let defaults = UserDefaults.standard
    
    /// The key for the UserDefaults object
    private let _key: String
    
    /// Initaliser to set up the key
    ///
    /// - Parameter key: The string key for UD
    public init(withKey key: String) {
        self._key = key
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    @objc(retriveObject:)
    public func retrieveObject() throws -> Any {
        guard let data = defaults.data(forKey: _key) else {
            throw ManagerError.returnValueNil(forKey: _key)
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
            throw ManagerError.couldNotUnarchive(forKey: key)
        }
        
        return object
    }

}
