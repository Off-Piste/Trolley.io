//
//  URLQuery.swift
//  Pods
//
//  Created by Harry Wright on 14.06.17.
//
//

import Foundation

/**
 Easier to use URLQueryItems, the way it should have been written, 
 allows you to access the querys via a simple subscript
 */
public struct URLQuery {
    
    /// <#Description#>
    public var url: String
    
    /// <#Description#>
    ///
    /// - Parameter url: <#url description#>
    internal init(_ url: String) {
        self.url = url
    }
    
    /// <#Description#>
    ///
    /// - Parameter url: <#url description#>
    internal init(_ url: URL) {
        self.url = url.absoluteString
    }
    
}

public extension URLQuery {

    /// <#Description#>
    var parameters: [String : String] {
        return internalURL?.queryItems ?? [:]
    }
    
    /// <#Description#>
    fileprivate var internalURL: URL? {
        return URL(string: url)
    }
    
    /// <#Description#>
    ///
    /// - Parameter parameter: <#parameter description#>
    subscript(_ parameter: String) -> String {
        return self.getQueryStringParameter(parameter) ?? ""
    }
    
    func append(_ value: String, forKey key: String) {
        
    }
    
}

private extension URLQuery {

    /// <#Description#>
    ///
    /// - Parameter param: <#param description#>
    /// - Returns: <#return value description#>
    func getQueryStringParameter(_ param: String) -> String? {
        guard let url = URLComponents(string: url) else { fatalError() }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
}

extension URLQuery : CustomStringConvertible {
    
    public var description: String {
        return "URLQuery { url: \(self.url) parameters: \(self.parameters) }"
    }
    
}
