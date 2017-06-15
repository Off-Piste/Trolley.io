//
//  SearchableProduct.swift
//  Pods
//
//  Created by Harry Wright on 05.06.17.
//
//

import Foundation
import PromiseKit
import SwiftyJSON

extension Networkable {
    
    func responseSearch() -> Promise<[SearchableProducts]> {
        return Promise { fullfill, reject in
            self.responseJSON().then { (json) -> Void in
                fullfill(json.searchableProducts)
            }.catch { (error) in
                reject(error)
            }
        }
    }
    
}

public struct SearchableProducts {
    
    public var _id: String
    
    public var companyName: String
    
    public var productName: String
    
}

public extension SearchableProducts {
    
    public static func getAll() -> Promise<[SearchableProducts]> {
        return Trolley.shared.networkManager
            .get(.products, with: ["isSearching" : true])
            .responseSearch()
    }
    
}

extension SearchableProducts : CustomStringConvertible {
    
    public var description: String {
        return "<SearchableProducts>{ id: \(self._id) name: \(self.productName) }"
    }
    
}

public extension SearchableProducts {
    
    /// Convenience init to use SwiftyJSON and to call the `init(JSONData:)` initaliser
    ///
    /// - Parameter json: SwiftyJSON
    public init?(JSON json: JSON) {
        guard json != JSON.null,
            let dict = json.dictionary,
            let companyName = dict["company_name"]?.string,
            let productName = dict["product_name"]?.string,
            let id = dict["local_id"]?.string
            else {
                return nil
        }
        
        self.init(_id: id, companyName: companyName, productName: productName)
    }
    
}

extension JSON {
    
    /// Property to turn the JSON into an array of products
    internal var searchableProducts: [SearchableProducts] {
        return arrayValue.flatMap { return SearchableProducts(JSON: $0) }
    }
    
}
