//
//  Convertion+FloatExt.swift
//  Pods
//
//  Created by Harry Wright on 30.03.17.
//
//

import Foundation

var DEFAULT_CURRENCY_TYPE: String = "GBP"
var DEFAULT_LOCALE: String = "en_UK"

public extension Float {
    
    
    /// Convenience Init, that converts the value inputted to the new float.
    ///
    /// - Parameter value: The non convered currency
    public init(convert value: Float) {
        self.init(CurrencyConverter.shared.convert(value))
    }
    
    
    /// Float conversion to `NSDecimalNumber`, this is needed when using Answers for analytics
    public var decimalNumber: NSDecimalNumber {
        return NSDecimalNumber(value: self)
    }
    
    
    /// The formatted currency version of the Float, formatted to the `Locale.current`
    public var currencyValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        
        return formatter.string(from: NSNumber(value: self))!
    }
    
}
