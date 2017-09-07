//
//  SearchableProduct.swift
//  Pods
//
//  Created by Harry Wright on 05.06.17.
//
//

import Foundation
//import PromiseKit
import SwiftyJSON

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
    @available(*, unavailable, message: "Removed Due to [0001]")
    internal var searchableProducts: [SearchableProducts] {
        return arrayValue.flatMap { return SearchableProducts(JSON: $0) }
    }
    
}
