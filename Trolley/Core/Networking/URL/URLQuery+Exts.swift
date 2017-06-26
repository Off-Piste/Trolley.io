//
//  URLQuery+Exts.swift
//  Pods
//
//  Created by Harry Wright on 14.06.17.
//
//

import Foundation

func +<Key, Value> (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
    var result = lhs
    rhs.forEach{ result[$0] = $1 }
    return result
}

extension URL {
    var queryItems: [String: String]? {
        return URLComponents(url: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .flatMap { $0.dictionaryRepresentation }
            .reduce([:], +)
    }
}

extension URLQueryItem {
    var dictionaryRepresentation: [String: String]? {
        if let value = value {
            return [name: value]
        }
        return nil
    }
}

