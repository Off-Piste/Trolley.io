//
//  PromiseTest.swift
//  Pods
//
//  Created by Harry Wright on 04.07.17.
//
//

import Foundation
import PromiseKit

public class ProductsPromise : Promise<[Product]> {
    
    public func asResponse() -> Promise<ProductsPromiseResponse> {
        return then(on: zalgo) { _ in return self.response }
    }
    
    private var response: ProductsPromiseResponse!
    
    internal class func go(
        _ body: ( @escaping ([Product]?, Error?) -> Void) -> Void
        ) -> ProductsPromise
    {
        var promise: ProductsPromise!
        promise = ProductsPromise { fullfill, reject in
            body { (products, error) in
                if let error = error {
                    reject(error)
                } else {
                    promise.response = ProductsPromiseResponse(products!)
                    fullfill(products!)
                }
            }
        }
        
        return promise
    }
    
}
