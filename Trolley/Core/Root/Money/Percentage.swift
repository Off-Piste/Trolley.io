//
//  Percentage.swift
//  Pods
//
//  Created by Harry Wright on 02.06.17.
//
//

import Foundation

public struct Percentage : ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {

    /// <#Description#>
    public var value: NSDecimalNumber

    /// <#Description#>
    public typealias IntegerLiteralType = Int

    /// <#Description#>
    public typealias FloatLiteralType = Float

    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    public init(value: Int) {
        self.value = NSDecimalNumber(value: value)
    }

    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    public init(value: Float) {
        self.value = NSDecimalNumber(value: value)
    }

    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    public init(value: NSDecimalNumber) {
        self.value = value
    }

    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    public init(calculation value: @autoclosure () -> Float) {
        self.init(value: value() * 100)
    }

    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    public init(integerLiteral value: Percentage.IntegerLiteralType) {
        self.value = NSDecimalNumber(value: value)
    }

    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    public init(floatLiteral value: Percentage.FloatLiteralType) {
        self.value = NSDecimalNumber(value: value)
    }

}

public extension Percentage {

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

public extension Percentage {

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - items: <#items description#>
    ///   - total: <#total description#>
    /// - Returns: <#return value description#>
    public static func `for`(_ items: Int, in total: Int) -> Percentage {
        assert(items < total, "The number of items is greater than the total")

        let value = Float(items) / Float(total)
        return Percentage(value: value * 100.00)
    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - old: <#old description#>
    ///   - new: <#new description#>
    /// - Returns: <#return value description#>
    public static func increase(forOld old: Int, new: Int) -> Percentage {
        assert(old < new, "Please use `decrease(forOld:new)` instead")

        let increase = Float(new - old) / Float(old)
        return Percentage(value: increase * 100.00)
    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - old: <#old description#>
    ///   - new: <#new description#>
    /// - Returns: <#return value description#>
    public static func increase(forOld old: Money, new: Money) -> Percentage {
        assert(old.money.value < new.money.value, "Please use `decrease(forOld:new)` instead")

        let increase = (new - old) / old
        return Percentage(value: increase * 100)
    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - old: <#old description#>
    ///   - new: <#new description#>
    /// - Returns: <#return value description#>
    public static func decrease(forOld old: Int, new: Int) -> Percentage {
        assert(old > new, "Please use `increase(forOld:new)` instead")

        let decrease = Float(old - new) / Float(old)
        return Percentage(value: decrease * 100.00)
    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - old: <#old description#>
    ///   - new: <#new description#>
    /// - Returns: <#return value description#>
    public static func decrease(forOld old: Money, new: Money) -> Percentage {
        assert(old.money.value > new.money.value, "Please use `increase(forOld:new)` instead")

        let decrease = (old - new) / old
        return Percentage(value: decrease * 100)
    }

}

/**

 */
extension Percentage : CustomStringConvertible {

    public var description: String {
        return "\(self.roundedValue)%"
    }

}

/**

 */
extension Percentage : Equatable { }

public func ==(lhs: Percentage, rhs: Percentage) -> Bool {
    return lhs.value.isEqual(to: rhs.value)
}

func /(lhs: Money, rhs: Percentage) -> Money {
    if rhs.decimalValue == .zero {
        return lhs
    }
    return Money(value: lhs.money.value.multiplying(by: rhs.decimalValue))
}

func -(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
    return lhs.subtracting(rhs)
}

func *(lhs: NSDecimalNumber, rhs: Int) -> NSDecimalNumber {
    return lhs.multiplying(by: NSDecimalNumber(value: rhs))
}

func /(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
    return lhs.dividing(by: rhs)
}

postfix operator %

public postfix func %(lhs: Int) -> Percentage {
    return Percentage(value: lhs)
}

public postfix func %(lhs: Float) -> Percentage {
    return Percentage(value: lhs)
}
