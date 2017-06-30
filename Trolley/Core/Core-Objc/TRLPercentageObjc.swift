//
//  TRLPercentageObjc.swift
//  Pods
//
//  Created by Harry Wright on 30.06.17.
//
//

import Foundation

#if _runtime(_ObjC)

@objc public final class TRLPercentage: NSObject {
    
    var value: NSDecimalNumber
    
    public init(withDecimal decimal: NSDecimalNumber) {
        self.value = decimal
    }
    
    public init(withNumber number: NSNumber) {
        self.value = NSDecimalNumber(decimal: number.decimalValue)
    }
    
}

public extension TRLPercentage {
    
    /// <#Description#>
    var integer: Int {
        return Int(self.value)
    }
    
    /// <#Description#>
    var float: Float {
        return Float(self.value)
    }
    
    /// <#Description#>
    var roundedValue: NSDecimalNumber {
        return self.value.rounding(accordingToBehavior: kDecimalHandler)
    }
    
    /// <#Description#>
    var decimalValue: NSDecimalNumber {
        return self.value / 100
    }
    
}

extension TRLPercentage {
    
    public override var description: String {
        return "\(self.roundedValue)%"
    }
    
}

#endif
