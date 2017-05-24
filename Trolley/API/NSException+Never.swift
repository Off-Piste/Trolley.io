//
//  NSException+Ext.swift
//  Pods
//
//  Created by Harry Wright on 24.05.17.
//
//

import Foundation

/**
 Extensions of NSException to make my life easier and
 to keep my code easier to read and use less line
 
 Way to lazy for the normal NSExceptions calls 😂
 */
internal extension NSException {
    
    internal convenience init(_ n: NSExceptionName, _ r: String, _ ui: [AnyHashable: Any]?) {
        self.init(name: n, reason: r, userInfo: ui)
    }
    
    /// Method to raise an NSException without having to initalise one or calling the
    /// orginal objc `.raise` method. This is smother and looks nicer.
    ///
    /// Always uses `genericException`
    ///
    /// - Parameters:
    ///   - reason: The reason for the NSException
    ///   - ui: The userInfo, default as `nil`
    class func raise(_ reason: String, with ui: [AnyHashable: Any]? = nil) {
        let exc = NSException(.genericException, reason, ui)
        exc.raise()
    }
    
    /// Method to raise an `NSException` and return `Never`. This is cleaner 
    /// and easier to use and read:
    ///
    ///     guard let ... else { NSException.raise("Reason"); return }
    ///
    /// Becomes:
    ///
    ///     guard let ... else { NSException.fatal("Reason") }
    ///
    ///
    /// Always uses `genericException`
    ///
    /// - Parameters:
    ///   - reason: The reason for the NSException
    ///   - ui: The userInfo, default as `nil`
    /// - Returns: `Never`
    class func fatal(_ reason: String, with ui: [AnyHashable: Any]? = nil) -> Never {
        let exc = NSException(.genericException, reason, ui)
        exc.raise()
        
        // Will never call this but is needed to conform to `-> Never`
        fatalError()
    }
    
}
