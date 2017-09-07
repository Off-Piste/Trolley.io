//
//  Networkable+Exts.swift
//  Pods
//
//  Created by Harry Wright on 22.05.17.
//
//

import PromiseKit
import SwiftyJSON

public extension Networkable {
    
    // MARK: JSON
    
    /// <#Description#>
    ///
    /// - Parameter handler: <#handler description#>
    func responseJSON(handler: @escaping (JSON, Error?) -> Void) {
        self.responseData { (data, error) in
            if error != nil {
                handler(JSON.null, error)
            } else {
                handler(JSON(data: data!), error)
            }
        }
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func responseJSON() -> Promise<JSON> {
        return Promise { fullfill, reject in
            self.responseData()
                .then { fullfill(JSON($0)) }
                .catch { reject($0) }
        }
    }
    
}
