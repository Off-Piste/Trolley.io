//
//  TRLPercentageObjc.swift
//  Pods
//
//  Created by Harry Wright on 30.06.17.
//
//

import Foundation

@objc public final class TRLPercentage: NSObject {
    
    internal var _percentageCore: Percentage
    
    public var value: NSDecimalNumber {
        return self._percentageCore.value
    }
    
    public init(withDecimal decimal: NSDecimalNumber) {
        self._percentageCore = Percentage(value: decimal)
    }
    
    public convenience init(withNumber number: NSNumber) {
        let decimal = NSDecimalNumber(decimal: number.decimalValue)
        self.init(withDecimal: decimal)
    }
    
    internal init(core: Percentage) {
        self._percentageCore = core
    }
    
    var integer: Int {
        return self._percentageCore.integer
    }
    
    var float: Float {
        return self._percentageCore.float
    }
    
    var roundedValue: NSDecimalNumber {
        return self._percentageCore.roundedValue
    }
    
    var decimalValue: NSDecimalNumber {
        return self._percentageCore.decimalValue
    }
    
    public override var description: String {
        return self._percentageCore.description
    }
    
}
