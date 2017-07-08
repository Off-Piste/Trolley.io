//
//  TRLProducts-Objc.swift
//  Pods
//
//  Created by Harry Wright on 03.07.17.
//
//

import Foundation

public extension Product {
    
    @available(swift, introduced: 1.0, obsoleted: 2.0)
    @objc(price) var objc_price: TRLMoney {
        return TRLMoney(_core: self.price)
    }
    
    @available(swift, introduced: 1.0, obsoleted: 2.0)
    @objc(discount) var objc_discount: TRLPercentage {
        return TRLPercentage(core: self.discount)
    }
    
    @available(swift, introduced: 1.0, obsoleted: 2.0)
    @objc(total) var objc_total: TRLMoney {
        return TRLMoney(_core: self.total)
    }
    
}
