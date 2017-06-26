//
//  NSDecimalExt.swift
//  Pods
//
//  Created by Harry Wright on 24.04.17.
//
//

import Foundation

public func ==(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
    return lhs.isEqual(to: rhs)
}

extension NSDecimalNumber: Comparable { }

public func <(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
    return lhs.compare(rhs) == .orderedAscending
}

internal extension NSDecimalNumber {
    
    var isNegative: Bool {
        return self < NSDecimalNumber.zero
    }
    
    func negate(withBehavior behavior: NSDecimalNumberBehaviors?) -> NSDecimalNumber {
        let negativeOne = NSDecimalNumber(mantissa: 1, exponent: 0, isNegative: true)
        let result = multiplying(by: negativeOne, withBehavior: behavior)
        return result
    }
    
}
