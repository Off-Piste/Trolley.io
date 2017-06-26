//
//  TRLNetworkManager+.swift
//  Pods
//
//  Created by Harry Wright on 22.06.17.
//
//

import Foundation
import Alamofire

extension TRLNetworkManager {
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - database: <#database description#>
    /// - Returns: <#return value description#>
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
    public func get(_ item: String, in database: Database) -> TRLRequest {
        return self.get(
            item: item,
            in: database.name,
            with: nil,
            encoding: URLEncoding.queryString,
            headers: nil
        )
    }
    
}
