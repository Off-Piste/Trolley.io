//
//  URLQuery.swift
//  Pods
//
//  Created by Harry Wright on 14.06.17.
//
//

import Foundation
import Alamofire

/**
 Easier to use URLQueryItems, the way it should have been written, 
 allows you to access the querys via a simple subscript
 */
public struct URLQuery {
    
    /// <#Description#>
    public var url: URLConvertible
    
    /// <#Description#>
    ///
    /// - Parameter url: <#url description#>
    internal init(_ url: URLConvertible) {
        self.url = url
    }
    
}

public extension URLQuery {

    /// <#Description#>
    var parameters: [String : String] {
        return internalURL?.queryItems ?? [:]
    }
    
    /// <#Description#>
    fileprivate var internalURL: URL? {
        return try? self.url.asURL()
    }
    
    /// <#Description#>
    ///
    /// - Parameter parameter: <#parameter description#>
    subscript(_ parameter: String) -> String? {
        do {
            return try self.getQueryStringParameter(parameter)
        } catch {
            TRLCoreLogger.info("[\(self)] throw an error -> \(error.localizedDescription) ")
            return nil
        }
    }
    
}

private extension URLQuery {

    /// <#Description#>
    ///
    /// - Parameter param: <#param description#>
    /// - Returns: <#return value description#>
    func getQueryStringParameter(_ param: String) throws -> String? {
        guard let url = internalURL,
            let comp = URLComponents(url: url, resolvingAgainstBaseURL: true)
            else { throw createError("Invalid URL") }
        return comp.queryItems?.first(where: { $0.name == param })?.value
    }
    
}

extension URLQuery : CustomStringConvertible {
    
    public var description: String {
        return "URLQuery { url: \(self.url) parameters: \(self.parameters) }"
    }
    
}
