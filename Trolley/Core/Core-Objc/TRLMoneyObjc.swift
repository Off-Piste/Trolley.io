//
//  MoneyObjc.swift
//  Pods
//
//  Created by Harry Wright on 30.06.17.
//
//

import Foundation

@objc public final class TRLMoney : NSObject {
    
    internal var _core: Money
    
    public var money: (value: NSDecimalNumber, currency: Currency) {
        return self._core.money
    }
    
    public init(withDecimal value: NSDecimalNumber) {
        self._core = Money(value: value)
    }
    
    public convenience init(withNumber value: NSNumber) {
        let decimal = NSDecimalNumber(decimal: value.decimalValue)
        self.init(withDecimal: decimal)
    }
    
    internal init(_core: Money) { self._core = _core }
    
    /// <#Description#>
    public var amount: Float {
        return self._core.amount
    }
    
    /// <#Description#>
    public var floatValue: Float {
        return self._core.floatValue
    }
    
    /// <#Description#>
    public var integerValue: Int {
        return self._core.integerValue
    }
    
    /// <#Description#>
    public var stripe: Int {
        return self._core.stripe
    }
    
    /// <#Description#>
    public var string: String {
        return self._core.string
    }
    
    /// <#Description#>
    public var currency: Currency {
        return self._core.currency
    }
    
    /// <#Description#>
    public var decimalValue: NSDecimalNumber {
        return self._core.decimalValue
    }
    
    /// <#Description#>
    public var nonConvertedDecimal: NSDecimalNumber {
        return self._core.nonConvertedDecimal
    }
    
    /// <#Description#>
    public var isNegative: Bool {
        return self._core.isNegative
    }
    
    /// <#Description#>
    public var negative: NSDecimalNumber {
        return self._core.decimalValue.negate(withBehavior: kDecimalHandler)
    }
    
    public override var description: String {
        return self._core.description
    }
    
}
