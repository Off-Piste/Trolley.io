//
//  Response+Core.swift
//  Trolley.io
//
//  Created by Harry Wright on 26.06.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

import Foundation
import PromiseKit

public extension Array where Element == Products {
    
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

public typealias SearchResponse = _Response<SearchableProducts>

public typealias ProductResponse = _Response<Products>

/**
 Extension to show the functions that only work for SearchableProducts;

 A devoloper can easier copy this and change `T == Products` if they wish
 to add `search(_:)` to `Products`
 */
public extension _Response where T == SearchableProducts {

    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    func search(for value: String) -> _Response {
        let newObjects = self.objects.filter(for: value)
        return _Response(newObjects)
    }

    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    func search(for value: String) -> Promise<[SearchableProducts]> {
        let promise = Promise { fullfill, reject in
            fullfill(self.objects.filter(for: value))
        }

        return promise
    }

}
