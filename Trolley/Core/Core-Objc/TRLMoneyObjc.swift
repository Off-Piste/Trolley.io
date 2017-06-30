//
//  MoneyObjc.swift
//  Pods
//
//  Created by Harry Wright on 30.06.17.
//
//

import Foundation

#if _runtime(_ObjC)

@objc public final class TRLMoney : NSObject {
    
    public var money: (value: NSDecimalNumber, currency: Currency)
    
    public init(withDecimal value: NSDecimalNumber) {
        self.money = (value, defaultCurrency)
        super.init()
    }
    
    public init(withNumber value: NSNumber) {
        self.money = (NSDecimalNumber(decimal: value.decimalValue), defaultCurrency)
        super.init()
    }
    
}

extension TRLMoney : MoneyType {
    
    public typealias `Self` = TRLMoney
    
    /// <#Description#>
    public var amount: Float {
        return self.currency.convert(value: money.value)
            .rounding(accordingToBehavior: kDecimalHandler).floatValue
    }
    
    /// <#Description#>
    public var floatValue: Float {
        return self.money.value.rounding(accordingToBehavior: kDecimalHandler).floatValue
    }
    
    /// <#Description#>
    public var integerValue: Int {
        return self.money.value
            .rounding(accordingToBehavior: kDecimalHandler).intValue
    }
    
    /// <#Description#>
    public var stripe: Int {
        return Int(self.floatValue * 100)
    }
    
    /// <#Description#>
    public var string: String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .currency
        fmt.locale = Locale.current
        
        return fmt.string(from: self.currency.convert(value: money.value))!
    }
    
    /// <#Description#>
    public var currency: Currency {
        return self.money.currency
    }
    
    /// <#Description#>
    public var decimalValue: NSDecimalNumber {
        return self.currency.convert(value: money.value)
    }
    
    /// <#Description#>
    public var nonConvertedDecimal: NSDecimalNumber {
        return self.money.value
    }
    
    /// <#Description#>
    public var isNegative: Bool {
        return self.money.value.isNegative
    }
    
    /// <#Description#>
    public var negative: TRLMoney {
        return TRLMoney(withDecimal: self.money.value.negate(withBehavior: kDecimalHandler))
    }
    
    
}

extension TRLMoney {
    
    public override var description: String {
        return self.string
    }
    
}

#endif
