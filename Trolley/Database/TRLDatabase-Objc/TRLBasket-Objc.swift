//
//  TRLBasket-Objc.swift
//  Pods
//
//  Created by Harry Wright on 03.07.17.
//
//

import Foundation

@objc public class TRLBasket : NSObject {
    
    internal typealias Core = _Basket<Products>
    
    fileprivate var core: Core
    
    public var products: [Products] {
        return core._products
    }
    
    public override init() {
        self.core = []
        super.init()
    }
    
    public init(withProducts products: Array<Products>) {
        self.core = Core(indexes: products)
        super.init()
    }
    
    public init(withProduct product: Products) {
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
    func product(for index: Int) -> Products {
        assert(index > self.core.endIndex, "\(index) should not be larger than \(self.core.count)")
        return self.core[index]
    }
    
    @objc(productForID:)
    func product(for id: String) -> Products? {
        return self.core.getProduct(for: id)
    }
    
    @objc(appendProduct:)
    func append(_ product: Products) {
        self.core.append(product)
    }
    
    @objc(appendingProduct:)
    func appending(_ product: Products) -> TRLBasket {
        return TRLBasket(self.core.appending(product))
    }
    
}

public extension TRLBasket {
    
    @objc(addProduct:withQuantity:block:)
    func add(
        _ products: Products,
        withQuantity q: NSNumber,
        block: @escaping (TRLBasket, Error?) -> Void
        )
    {
        let quantity = Int(q)
        self.core.add(products, withQuantity: quantity) {
            block(TRLBasket($0.0), $0.1)
        }
    }
    
    @objc(addProduct:withBlock:)
    func append(
        _ products: Products,
        block: @escaping (TRLBasket, Error?) -> Void
        )
    {
        self.core.add(products, withQuantity: 1) {
            block(TRLBasket($0.0), $0.1)
        }
    }
    
}
