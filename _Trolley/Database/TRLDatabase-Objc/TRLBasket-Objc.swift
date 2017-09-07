//
//  TRLBasket-Objc.swift
//  Pods
//
//  Created by Harry Wright on 03.07.17.
//
//

import Foundation

@objc public class TRLBasket : NSObject {
    
    internal typealias Core = _Basket<Product>
    
    fileprivate var core: Core
    
    public var products: [Product] {
        return core._products
    }
    
    public override init() {
        self.core = []
        super.init()
    }
    
    public init(withProducts products: Array<Product>) {
        self.core = Core(indexes: products)
        super.init()
    }
    
    public init(withProduct product: Product) {
        self.core = Core(index: product)
        super.init()
    }
    
    init(_ core: Core) {
        self.core = core
        super.init()
    }
    
}

public extension TRLBasket {
    
    @objc(productForIndex:)
    func product(for index: Int) -> Product {
        assert(index > self.core.endIndex, "\(index) should not be larger than \(self.core.count)")
        return self.core[index]
    }
    
    @objc(productForID:)
    func product(for id: String) -> Product? {
        return self.core.getProduct(for: id)
    }
    
    @objc(appendProduct:)
    func append(_ product: Product) {
        self.core.append(product)
    }
    
    @objc(appendingProduct:)
    func appending(_ product: Product) -> TRLBasket {
        return TRLBasket(self.core.appending(product))
    }
    
}

public extension TRLBasket {
    
    @objc(addProduct:withQuantity:block:)
    func add(
        _ product: Product,
        withQuantity q: NSNumber,
        block: @escaping (TRLBasket, Error?) -> Void
        )
    {
        let quantity = Int(q)
        self.core.add(product, withQuantity: quantity) {
            block(TRLBasket($0.0), $0.1)
        }
    }
    
    @objc(addProduct:withBlock:)
    func append(
        _ product: Product,
        block: @escaping (TRLBasket, Error?) -> Void
        )
    {
        self.core.add(product, withQuantity: 1) {
            block(TRLBasket($0.0), $0.1)
        }
    }
    
}
