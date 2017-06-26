//
//  Networking.swift
//  Pods
//
//  Created by Harry Wright on 13.04.17.
//
//

import Foundation

public enum RootError: Error {
    
    case reachabilityError(ReachabilityError)
    
    case networkableError(NetworkableError)
    
    case externalError(NSError)
    
}

extension RootError {

    public var localizedDescription: String {
        switch self {
        case .networkableError(let error):
            return error.localizedDescription
        case .reachabilityError(let error):
            return error.localizedDescription
        case .externalError(let error):
            return error.localizedDescription
        }
    }
    
}

extension RootError {

    public enum ReachabilityError: Error {
        
        case FailedToCreateWithAddress(sockaddr_in)
        
        case FailedToCreateWithHostname(String)
        
        case UnableToSetCallback
        
        case UnableToSetDispatchQueue
        
        case guardFailed(String)
        
    }
 
    
}

extension RootError {
    
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
    
}
