//
//  TRLNetworkManager+.swift
//  Pods
//
//  Created by Harry Wright on 22.06.17.
//
//

import Foundation
import Alamofire

@objc(TRLParameters)
public enum APIParameters: Int {
    case rate = 0, search, page, filter
    
    var queryParmeterName: String {
        switch self {
        case .rate:
            return kRateQueryKey
        case .search:
            return kSearchQueryKey
        case .page:
            return kPageQueryKey
        case .filter:
            return kFilterQueryKey
        }
    }
}

extension TRLNetworkManager {
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - database: <#database description#>
    /// - Returns: <#return value description#>
    @objc(getDatabase:)
    public func get(_ database: Database) -> TRLRequest {
        return self.get(
            database.name,
            with: [:],
            encoding: URLEncoding.queryString,
            headers: nil
        )
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - item: <#item description#>
    ///   - database: <#database description#>
    /// - Returns: <#return value description#>
    @objc(getItem:inDatabase:)
    public func get(_ item: String, in database: Database) -> TRLRequest {
        return self.get(
            item: item,
            in: database.name,
            with: nil,
            encoding: URLEncoding.queryString,
            headers: nil
        )
    }
    
    @objc(searchForItemInDatabase:)
    public func searchForItems(in database: Database) -> TRLRequest {
        let route = String.urlRoute(for: database.name, "search")
        return self.get(route, with: nil, encoding: URLEncoding.queryString, headers: nil)
    }
    
    
}
