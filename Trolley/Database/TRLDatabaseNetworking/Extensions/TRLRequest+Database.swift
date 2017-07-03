//
//  TRLRequest+Database.swift
//  Trolley.io
//
//  Created by Harry Wright on 26.06.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

import Foundation

precedencegroup BooleanPrecedence { associativity: left }
infix operator ^^ : BooleanPrecedence

func ^^(lhs: Bool, rhs: Bool) -> Bool {
    return lhs != rhs
}

let kFilterQueryKey: String = "filter"
let kSearchQueryKey: String = "search"
let kRateQueryKey: String = "limit"
let kPageQueryKey: String = "next-page"

public extension TRLRequest {
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    @objc(rate:)
    func rate(_ value: Int) -> TRLRequest {
        assert(self.method == .get, "\(#function) can only be used by .get requests")
        assert(self.parameters != nil, "Cannot use \(#function) with nil prarameters")
        
        self.parameters?.updateValue(value, forKey: kRateQueryKey)
        return self.default
    }
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    @objc(page:)
    func page(_ value: Int) -> TRLRequest {
        assert(self.method == .get, "\(#function) can only be used by .get requests")
        assert(self.parameters != nil, "Cannot use \(#function) with nil prarameters")
        
        self.parameters?.updateValue(value, forKey: kPageQueryKey)
        return self.default
        
    }
    
    /// <#Description#>
    ///
    /// - Parameter predicateFormat: <#predicateFormat description#>
    /// - Returns: <#return value description#>
    @objc(filterFor:)
    func filter(_ predicateFormat: String) -> TRLRequest {
        assert(self.method == .get, "\(#function) can only be used by .get requests")
        assert(self.parameters != nil, "Cannot use \(#function) with nil prarameters")
        
        let _ = NSPredicate(format: predicateFormat)
        guard let data = predicateFormat.data(using: .utf8) else {
            TRLDatabaseLogger.info("The NSPredicate format could not be converted to Data so the request will not be carried out")
            return self.default
        }
        
        self.parameters?.updateValue(data, forKey: kFilterQueryKey)
        return self.default
    }
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    @objc(searchFor:)
    func search(for value: String) -> TRLRequest {
        assert(self.method == .get, "\(#function) can only be used by .get requests")
        assert(self.parameters != nil, "Cannot use \(#function) with nil prarameters")
        
        self.parameters?.updateValue(value, forKey: kSearchQueryKey)
        return self.default
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func validate() -> Networkable {
        TRLDatabaseLogger.debug("Validating the request")
        
        self.dataRequest.validate()
        return self
    }
    
}
