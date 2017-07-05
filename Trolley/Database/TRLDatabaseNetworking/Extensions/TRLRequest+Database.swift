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
        return self
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
        return self
        
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
            return self
        }
        
        self.parameters?.updateValue(data, forKey: kFilterQueryKey)
        return self
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
        return self
    }
    
    func validate() -> Networkable {
        guard let paramaters = self.parameters else { return self }
        
        if (paramaters[kPageQueryKey] == nil) ^^ (paramaters[kRateQueryKey] == nil) {
            self.error = createError("The url: \(self.url.desc) should have both a page and rate")
        }
        
        return self
    }
    
    @available(swift, introduced: 1.0, obsoleted: 1.0)
    @objc var validated: TRLRequest {
        return self.validate() as! TRLRequest
    }
    
}
