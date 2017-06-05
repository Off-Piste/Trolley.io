//
//  Networking.swift
//  Pods
//
//  Created by Harry Wright on 13.04.17.
//
//

import Foundation
import PromiseKit

/// An Enum of errors that can be produced by Networkable and its subclassed objects
///
/// - couldNotCast: An error that can be called when an object cannot be cast from Any to Target
public enum NetworkableError: Error {
    
    /// An error that can be called when an object cannot be cast from Any to Target
    case couldNotCast(from: AnyClass, to: AnyClass)
    
    case initFailed(for: AnyClass, withInput: Any)
    
    /// 
    public var localizedDescription: String {
        switch self {
        case .couldNotCast(let from, let to):
            return "We could not cast the value from: \(from), to: \(to)"
        case .initFailed(let object, let input):
            return "\(object) could not be created with input: \(input))"
        }
    }
}

/**
 
 */
public protocol NetworkableDelegate {
    
    /// Delegate method to be called when the network/request manager downloads the object data
    ///
    /// - Parameters:
    ///   - networkable: The network manager been used
    ///   - data: The downloaded Data, [Alamofire](https://github.com/Alamofire/Alamofire)
    ///   is the networking framework of choice for our API, please see our documention for our
    ///   alternatives
    func networkable(_ networkable: Networkable, didDownloadData data: Data)
    
    /// Delegate method to be called when the network/request manager fails
    ///
    /// - Parameters:
    ///   - networkable: The network manager been used
    ///   - error: The error in question
    func networkable(_ networkable: Networkable, didFailForError error: Error)
    
}

/// The default completion handler, returns either:
///
///     (Any, nil) // For Successful download
///     (nil, Error) // For when an error is recived
public typealias DefaultHandler = (Any?, Error?) -> Void

/**
 
 */
public protocol Networkable {
    
    /// Method to work with Promise, will be the default response that 
    /// all `Promise Kit` methods work from.
    ///
    /// If unfamilier with [Promise Kit](https://github.com/mxcl/PromiseKit), 
    /// this is how it will work
    ///
    ///     Networkable.response.then { value in
    ///         /** Work with the value */
    ///     }.catch { error in  
    ///         /** Work with the error */
    ///     }
    ///
    /// - Returns: A Promise that can be anything
    func response() -> Promise<Any>
    
    /// The response for when the user may want to work with closures rather than `Promise Kit`
    ///
    /// - Parameter handler: The default completion handler
    func response(handler: @escaping DefaultHandler)
    
}
