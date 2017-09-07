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
    
}

public extension TRLPercentage {

    public var integerValue: Int {
        return self._percentageCore.integer
    }
    
    public var floatValue: Float {
        return self._percentageCore.float
    }
    
    public var roundedValue: NSDecimalNumber {
        return self._percentageCore.roundedValue
    }
    
    public var decimalValue: NSDecimalNumber {
        return self._percentageCore.decimalValue
    }
    
    public override var description: String {
        return self._percentageCore.description
    }
    
}

public extension TRLPercentage {
    
    @objc(forValues:inValue:)
    class func `for`(_ values: Int, in value: Int) -> TRLPercentage {
        return TRLPercentage(core: Percentage.for(values, in: value))
    }
    
}
