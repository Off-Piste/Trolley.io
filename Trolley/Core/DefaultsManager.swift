//
//  DefaultsManager.swift
//  Pods
//
//  Created by Harry Wright on 12.04.17.
//
//

import Foundation

/// The errors that will be thrown
///
/// - returnValueNil: The value that is being requested is nil
/// - couldNotUnarchive: The encoder could not encode the data
public enum DefaultsManagerError: Error {
    
    case returnValueNil(forKey: String)
    case couldNotUnarchive(forKey: String)
    
    var localizedDescription: String {
        switch self {
        case .returnValueNil(let key):
            return "Cannot retrive the data, please check the key(\(key)) used to set and retrive are the same"
        case .couldNotUnarchive(let key):
            return "NSKeyedUnarchiver cannot unarchive the value for key: \(key). Please report this toy use via gitbug"
        }
    }
}

/// Shorter name for `DefaultsManagerError`
public typealias ManagerError = DefaultsManagerError

/** 
 
 */
public class DefaultsManager {
    
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
    
    /// The method to try and retrive the object from storage
    ///
    /// - Returns: The object in Any form, you can convert after
    /// - Throws: Throws and error if the data is nil or can't be decoded
    public func retrieveObject() throws -> Any {
        guard let data = defaults.data(forKey: _key) else {
            throw ManagerError.returnValueNil(forKey: _key)
        }
        
        return try Encoder.decode(data: data, forKey: _key)
    }
    
    /// The method to set the object in UserDefaults
    ///
    /// - Parameter object: The object, will be encoded and converted to data
    public func set(object: Any) {
        defaults.set(Encoder(withObject: object).data, forKey: _key)
    }
    
    /// The method to remove objects for the key
    public func clear() {
        defaults.removeObject(forKey: _key)
    }
    
    /** Testing Method */
    internal func setAndGet(object: Any) throws -> Any {
        self.set(object: object)
        return try retrieveObject()
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
        if object is Basket {
            let basket = object as! Basket
            self.data = basket.data()
        } else {
            self.data = NSKeyedArchiver.archivedData(withRootObject: object)
        }
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
        
        // Structs are different and require a helper class to be archived
        if object is Basket.Helper {
            return Basket.decode(for: data)
        }
        
        return object
    }
    
}
