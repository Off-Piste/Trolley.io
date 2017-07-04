//
//  TRLProducts-Objc.swift
//  Pods
//
//  Created by Harry Wright on 03.07.17.
//
//

import Foundation

@available(swift, introduced: 1.0, obsoleted: 1.0)
public extension Product {
    
    @objc(price) var objc_price: TRLMoney {
        return TRLMoney(_core: self.price)
    }
    
    @objc(discount) var objc_discount: TRLPercentage {
        return TRLPercentage(core: self.discount)
    }
    
    @objc(total) var objc_total: TRLMoney {
        let core = self.price - self.discountValue
        return TRLMoney(_core: core)
    }
    
}
