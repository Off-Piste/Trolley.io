//
//  Response+Core.swift
//  Trolley.io
//
//  Created by Harry Wright on 26.06.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

import Foundation
import PromiseKit

public extension Array where Element == Product {
    
    /// <#Description#>
    ///
    /// - Parameter text: <#text description#>
    /// - Returns: <#return value description#>
    func filter(for text: String) -> [Element] {
        return self.filter { $0.name.contains(text) || $0.company.contains(text)}
    }

}

public extension Array where Element == SearchableProducts {

    /// <#Description#>
    ///
    /// - Parameter text: <#text description#>
    /// - Returns: <#return value description#>
    func filter(for text: String) -> [Element] {
        return self.filter { $0.productName.contains(text) || $0.companyName.contains(text) }
    }

}
