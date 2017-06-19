//
//  Result.swift
//  Pods
//
//  Created by Harry Wright on 16.06.17.
//
//

import Foundation

enum Result<T> {
    
    case success(T)
    
    case error(Error)
    
    public init(success value: T) {
        self = Result.success(value)
    }
    
    public init(error: Error) {
        self = .error(error)
    }
    
}
