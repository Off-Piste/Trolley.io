//
//  TRLNotificationResult.swift
//  Pods
//
//  Created by Harry Wright on 19.06.17.
//
//


import Foundation

enum TRLNotificationErrors: Error {
    
    case emptyValues
    case invalidRequestType
    
}

public enum TRLNotificationResult<T> {
    
    case value(T)
    
    case error(Error)
    
}

extension TRLNotificationResult {
    
    init(_ value: T) {
        self = .value(value)
    }
    
    init(_ error: Error) {
        self = .error(error)
    }
    
    init(_ values: (T?, Error?)) {
        if let error = values.1 {
            self = .error(error)
        } else if let object = values.0 {
            self = .value(object)
        } else {
            self = .error(TRLNotificationErrors.emptyValues)
        }
    }
    
    public init(_ value: () throws -> T) {
        do {
            self = try .value(value())
        } catch {
            self = .error(error)
        }
    }
    
}

extension TRLNotificationResult {
    
    var value: T? {
        switch self {
        case .value(let v):
            return v
        case .error:
            return nil
        }
    }
    
    var error: Error? {
        switch self {
        case .value:
            return nil
        case .error(let err):
            return err
        }
    }
    
}
