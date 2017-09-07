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
    case testDefaultsNil(forKey: String)
    
    var localizedDescription: String {
        switch self {
        case .returnValueNil(let key):
            return "Cannot retrive the data, please check the key(\(key)) used to set and retrive are the same"
        case .couldNotUnarchive(let key):
            return "NSKeyedUnarchiver cannot unarchive the value for key: \(key). Please report this toy use via gitbug"
        case .couldNotConvert(let first, let second):
            return "Could not convert \(first) to \(second)"
        case .testDefaultsNil(let key):
            return "Defaults Could not be created for key [\(key)]"
        }
    }
}

/// Shorter name for `DefaultsManagerError`
public typealias ManagerError = DefaultsManagerError

@objc(TRLDefaultsManager)
public class DefaultsManager : NSObject {
    
    /// The standard UserDefaults shared instance
    private var defaults = UserDefaults.standard
    
    /// The key for the UserDefaults object
    private let _key: String
    
    private var suiteName: String?
    
    /// Initaliser to set up the key
    ///
    /// - Parameter key: The string key for UD
    public init(withKey key: String) {
        self._key = key
    }
    
    /// Testable
    /// - note:
    /// DefaultsManager works out of tests, as the AnalyticsQueue was been
    /// cleared upon app startup but in tests it fails, so workaround from:
    /// [Stack Overflow](https://stackoverflow.com/questions/19084633/shouldnt-nsuserdefault-be-clean-slate-for-unit-tests)
    init(withKey key: String, testName: String, function: String = #function, file: String = #file) throws {
        let suiteName: String = "\((file as NSString).lastPathComponent)_\(function)_\(testName)"
        self._key = key
        
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            throw ManagerError.testDefaultsNil(forKey: key)
        }
        
        self.defaults = defaults
        self.suiteName = suiteName
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    @objc(retriveObject:)
    public func retrieveObject() throws -> Any {
        objc_sync_enter(self)
        defer { defaults.synchronize(); objc_sync_exit(self) }
        
        defaults.synchronize()
        guard let data = defaults.data(forKey: _key) else {
            throw createError(
                for: kTrolleyErrorDomain,
                code: -301,
                withReason: "Unable to return value for key [\(_key)]"
            )
        }
        
        return try Encoder.decode(data: data, forKey: _key)
    }
    
    /// <#Description#>
    ///
    /// - Parameter object: <#object description#>
    @objc(setObject:)
    public func set(_ object: Any) {
        objc_sync_enter(self)
        defer { defaults.synchronize(); objc_sync_exit(self) }
        
        let data = Encoder(withObject: object).data
        self.defaults.set(data, forKey: self._key)
        defaults.synchronize()
    }
    
    /// The method to remove objects for the key
    @objc(clearObject)
    public func clear() {
        objc_sync_enter(self)
        defer { defaults.synchronize(); objc_sync_exit(self) }
        
        defaults.removeObject(forKey: _key)
    }
    
    /* testable */
    func clearSuite() {
        if defaults == UserDefaults.standard, self.suiteName == nil { return }
        self.defaults.removeSuite(named: self.suiteName!)
        self.defaults.synchronize()
    }
    
}

extension DefaultsManager {
    
    @available(*, unavailable, renamed: "set(_:)")
    public override func setValue(_ value: Any?, forKey key: String) {
        fatalError("renamed set(_:)")
    }
    
    @available(*, unavailable, renamed: "set(_:)")
    public override func setNilValueForKey(_ key: String) {
        fatalError("renamed set(_:)")
    }
    
    @available(*, unavailable, renamed: "set(_:)")
    public override func setValuesForKeys(_ keyedValues: [String : Any]) {
        fatalError("renamed set(_:)")
    }
    
    @available(*, unavailable, renamed: "set(_:)")
    public override func setValue(_ value: Any?, forKeyPath keyPath: String) {
        fatalError("renamed set(_:)")
    }
    
    @available(*, unavailable, renamed: "set(_:)")
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        fatalError("renamed set(_:)")
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
        if object is Data {
            self.data = object as! Data
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
        if key == "_WebSocketKey" { return data }
        
        guard let object = NSKeyedUnarchiver.unarchiveObject(with: data) else {
            throw createError(
                for: kTrolleyErrorDomain,
                code: -308,
                withReason: "Unable to unarchive object for key [\(key)]"
            )
        }
        
        return object
    }

}
