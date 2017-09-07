//
//  Money.swift
//  Pods
//
//  Created by Harry Wright on 24.04.17.
//
//

import Foundation

/// The Default Currency Type, uses `Locale.current` but if that cannot find the locale, GBP is used
let defaultCurrency = Currency(localeIdentifier: Locale.current.currencyCode ?? "GBP")

/**
 This is the custom decimal type. 
 
 It is a stripped down version of [Money](https://github.com/danthorpe/Money) by danthorpe
 */
public protocol DecimalType : ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    
    /// The pype of Decimal Storage, will be set to `NSDecimalNumber` but could be `Decimal`
    associatedtype DecimalStorageType
    
    /// The tuple that holds the both the monietary value and the currency being used,
    /// all `MoneyType` properties take the value from this
    var money: (value: DecimalStorageType, currency: Currency) { get }
    
    /// The Initaliser for when using a Decimal value, check `DecimalStorageType` for type
    ///
    /// - Parameter value: The NSDecimalNumber value
    init(value: DecimalStorageType)
    
    /// The initaliser for using a float value.
    ///
    /// - Parameter value: The float value for the money
    init(_ value: Float)
    
    /// The initaliser for using a Int value
    ///
    /// - Parameter value: The float value for money
    init(_ value: Int)
    
    /// The initaliser for using an Int value that may have a decimal place,
    /// the values are then divided by 100 to place them in correct places
    ///
    /// - Parameter amount: The float value for money that is in cents or pennies
    init(withAmmount amount: Int)
}

/**
 The Protocol that holds the properties that can be essential for creating a value that works like money
 */
public protocol MoneyType {
    
    /// The Float value for the decimal number found inside: 
    ///
    ///     <DecimalType>.money.value
    ///
    /// The value is converted to the currency that is found inside the same tuple as above
    var amount: Float { get }
    
    /// The non-converted float value, this would be used by developers that are wanting to do custom
    /// conversions of the money or convert the money prior
    var floatValue: Float { get }
    
    /// The non-converted int value, this would be used by developers that are wanting to do custom
    /// conversions of the money or convert the money prior.
    ///
    /// # Note:
    /// Rememeber that the values will lose there decimal place:
    ///
    ///     var money: Money = 50.55
    ///     print(money.integerValue) 
    ///     // prints ("50\n")
    ///
    /// To get int value but with decimal use `.stripe`
    var integerValue: Int { get }
    
    /// The non-converted int value that returns the value in **cents** rather than **dollars**.
    /// Helpful when working with [Stripe](https://stripe.com) as their API takes the value as cents
    ///
    ///     var money: Money = 50.55
    ///     print(money.stripe)
    ///     // prints ("5050\n")
    ///
    /// To get int value but without the deicmal use `.integerValue`
    var stripe: Int { get }
    
    /// The formatted string value for the money, 
    /// this takes the converted value and creates a formatted value based on the currency. 
    /// This is so the user doesn't have to.
    ///
    ///     var money: Money = 50.55
    ///     print(money.string, money.currency.code)
    ///     // prints ("£47.90 GBP\n")
    ///
    var string: String { get }
    
    /// The gateway to the `Currency` enum, this allows users to get the current currency code and
    /// conversion rate
    var currency: Currency { get }
    
    /// The converted NSDecimalNumber value of the currency.
    var decimalValue: NSDecimalNumber { get }
    
    /// Property to check to see if the value is negative
    var isNegative: Bool { get }
    
    /// Property that returns a negative money type
    var negative: Self { get }
    
}

/**
 A custom NSDecimalNumber type that will be used to hold all money for the framework.
 
 It is a stripped down version of [Money](https://github.com/danthorpe/Money) by danthorpe
 */
public struct Money : DecimalType {
    
    /// <#Description#>
    public typealias DecimalStorageType = NSDecimalNumber
    
    /// <#Description#>
    public typealias FloatLiteralType = Float
    
    /// <#Description#>
    public typealias IntegerLiteralType = Int
    
    ///
    public var money: (value: DecimalStorageType, currency: Currency)
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    public init(value: NSDecimalNumber) {
        self.money = (value, defaultCurrency)
    }
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    public init(_ value: Float) {
        self.money = (
            NSDecimalNumber(value: value)
                .rounding(accordingToBehavior: kDecimalHandler),
            defaultCurrency
        )
    }
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    public init(_ value: Int) {
        self.money = (NSDecimalNumber(value: value), defaultCurrency)
    }
    
    /// <#Description#>
    ///
    /// - Parameter ammount: <#ammount description#>
    public init(withAmmount ammount: Int) {
        let value: Float = Float(ammount) / 100
        self.money = (
            NSDecimalNumber(value: value)
                .rounding(accordingToBehavior: kDecimalHandler),
            defaultCurrency
        )
    }
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    public init(floatLiteral value: Money.FloatLiteralType) {
        self.init(value)
    }
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    public init(integerLiteral value: Money.IntegerLiteralType) {
        switch value {
        case 0:
            self.money = (NSDecimalNumber.zero, defaultCurrency)
        case 1:
            self.money = (NSDecimalNumber.one, defaultCurrency)
        default:
            self.money = (NSDecimalNumber(value: value), defaultCurrency)
        }
    }
    
}

extension Money {
    init(_ objc: TRLMoney) {
        self = objc._core
    }
}

/**
 Money Type Conformity
 
 Also adds the `stripe` helper to change the Decimal to an Int by multiplying by 100
 */
extension Money: MoneyType, SignedNumber {
    
    /// <#Description#>
    public var amount: FloatLiteralType {
        return self.currency.convert(value: money.value)
            .rounding(accordingToBehavior: kDecimalHandler).floatValue
    }
    
    /// <#Description#>
    public var floatValue: FloatLiteralType {
        return self.money.value.rounding(accordingToBehavior: kDecimalHandler).floatValue
    }
    
    /// <#Description#>
    public var integerValue: IntegerLiteralType {
        return self.money.value
            .rounding(accordingToBehavior: kDecimalHandler).intValue
    }
    
    /// <#Description#>
    public var stripe: IntegerLiteralType {
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
    public var negative: Money {
        return Money(value: self.money.value.negate(withBehavior: kDecimalHandler))
    }
    
}

/**
 CustomStringConvertible, CustomDebugStringConvertible, Hashable conformity
 */
extension Money: CustomStringConvertible, CustomDebugStringConvertible, Hashable {
    
    /// <#Description#>
    public var description: String {
        return self.string
    }
    
    /// <#Description#>
    public var debugDescription: String {
        return "(\(self.money.value), \(self.money.currency.code))"
    }
    
    /// <#Description#>
    public var hashValue: Int {
        return self.money.value.hashValue
    }
    
}

// MARK: - Equatable

public func ==(lhs: Money, rhs: Money) -> Bool {
    return lhs.money.value.compare(rhs.money.value) == .orderedSame &&
        rhs.currency == lhs.currency
}

func +=(lhs: inout Money, rhs: Money) {
    lhs.money.value.adding(rhs.money.value, withBehavior: kDecimalHandler)
}

// MARK: - Operators

// MARK: Addition

public func +(lhs: Money, rhs: Money) -> Money {
    if lhs.currency == rhs.currency {
        let money = lhs.money.value.adding(rhs.money.value, withBehavior: kDecimalHandler)
        return Money(money.floatValue)
    }
    
    return Money(integerLiteral: 0)
}

public func +(lhs: Money.FloatLiteralType, rhs: Money) -> Money {
    return Money(lhs + rhs.floatValue)
}

public func +(lhs: Money, rhs: Money.FloatLiteralType) -> Money {
    return Money(lhs.floatValue + rhs)
}

public func +(lhs: Money.IntegerLiteralType, rhs: Money) -> Money {
    return Money(integerLiteral: lhs + rhs.integerValue)
}

public func +(lhs: Money, rhs: Money.IntegerLiteralType) -> Money {
    return Money(integerLiteral: lhs.integerValue + rhs)
}

// MARK: Subtract

public func -(lhs: Money, rhs: Money) -> Money {
    return Money(value: lhs.money.value - rhs.money.value)
}

public func -(lhs: Money.FloatLiteralType, rhs: Money) -> Money {
    return Money(lhs - rhs.floatValue)
}

public func -(lhs: Money, rhs: Money.FloatLiteralType) -> Money {
    return Money(lhs.floatValue - rhs)
}

public func -(lhs: Money.IntegerLiteralType, rhs: Money) -> Money {
    return Money(lhs - rhs.integerValue)
}

public func -(lhs: Money, rhs: Money.IntegerLiteralType) -> Money {
    return Money(lhs.integerValue - rhs)
}

// MARK: Multiplication
// TODO: Add Rest

public func /(lhs: Money, rhs: Money) -> Money {
    return Money(value: lhs.money.value / rhs.money.value)
}

// MARK: Division
// TODO: Add Rest

public func *(lhs: Money, rhs: Int) -> NSDecimalNumber {
    return lhs.money.value.multiplying(by: NSDecimalNumber(value: rhs))
}

// MARK: - Comparable

public func <(lhs: Money, rhs: Money) -> Bool {
    return lhs.decimalValue < rhs.decimalValue
}

public prefix func -(lhs: Money) -> Money {
    return lhs.negative
}
