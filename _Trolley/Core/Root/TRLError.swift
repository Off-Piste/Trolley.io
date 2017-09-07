//
//  TRLError.swift
//  Pods
//
//  Created by Harry Wright on 17.07.17.
//
//

import Foundation

let kTrolleyErrorDomain: String = "co.uk.trolleyio"
let kTrolleyDatabaseErrorDomain: String = kTrolleyErrorDomain.appending(".database")

@objc(TRLErrorCodes)
enum TRLErrorCodes: Int {
    case unknown = 0
    case invalidPlistFile = -100
}

func createError(for domain: String, code: Int, userInfo: [AnyHashable : Any]?) -> Error {
    return NSError(domain: domain, code: code, userInfo: userInfo) as Error
}

func createError(for domain: String, code: TRLErrorCodes, userInfo: [AnyHashable : Any]?) -> Error {
    return NSError(domain: domain, code: code.rawValue, userInfo: userInfo) as Error
}

func createError(for domain: String, code: TRLErrorCodes, withReason reason: String) -> Error {
    return createError(for: domain, code: code, userInfo: [NSLocalizedDescriptionKey : reason])
}

func createError(for domain: String, code: Int, withReason reason: String) -> Error {
    return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey : reason])
}

func createError(for error: Error, withDomain domain: String, code: TRLErrorCodes) -> Error {
    let desc = error.localizedDescription
    return createError(for: domain, code: code, withReason: desc)
}
