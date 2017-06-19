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
    
    func search() -> Promise<SearchResponse> {
        return Promise { fullfill, reject in
            self.JSON().then { (json) -> Void in
                let searchableProducts = json.searchableProducts
                fullfill(SearchResponse(searchableProducts))
            }.catch { (error) in
                reject(error)
            }
        }
    }
    
}

// TODO: - New Name For This

public class SearchableProducts: NSObject {
    
    public var _id: String
    
    public var companyName: String
    
    public var productName: String
    
    init(_ id: String, companyName: String, productName: String) {
        self._id = id
        self.companyName = companyName
        self.productName = productName
    }
    
}

public extension SearchableProducts {
    
    public static func getAll() -> Promise<SearchResponse> {
        return Trolley.shared.networkManager
            .get(.products, with: ["isSearching" : true])
            .response
            .search()
    }
    
}

extension SearchableProducts {
    
    public override var description: String {
        return "<SearchableProducts>{ id: \(self._id) name: \(self.productName) }"
    }
    
}

public extension SearchableProducts {
    
    /// Convenience init to use SwiftyJSON and to call the `init(JSONData:)` initaliser
    ///
    /// - Parameter json: SwiftyJSON
    public convenience init?(JSON json: JSON) {
        guard json != JSON.null,
            let dict = json.dictionary,
            let companyName = dict["company_name"]?.string,
            let productName = dict["product_name"]?.string,
            let id = dict["local_id"]?.string
            else {
                return nil
        }
        
        self.init(id, companyName: companyName, productName: productName)
    }
    
}

extension JSON {
    
    /// Property to turn the JSON into an array of products
    internal var searchableProducts: [SearchableProducts] {
        return arrayValue.flatMap { return SearchableProducts(JSON: $0) }
    }
    
}
