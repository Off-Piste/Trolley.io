//
//  CurrencyConvertor.swift
//  Pods
//
//  Created by Harry Wright on 31.03.17.
//
//

import Foundation
import SwiftyJSON
import Alamofire

internal let _offlineRatesUD: String = "OfflineRate"

internal var SHOP_CURRENCY_CODE: String = "GBP"

let kDecimalHandler = NSDecimalNumberHandler(
    roundingMode: .plain,
    scale: 2,
    raiseOnExactness: true,
    raiseOnOverflow: true,
    raiseOnUnderflow: true,
    raiseOnDivideByZero: true
)

/// The CurrencyConvertable protocol that Currency conforms to
public protocol CurrencyConvertable {
    
    func convert(_ value: Float) -> Float
    
}

/// The Custom Currency Errors that can occur when downloading the JSON
///
/// - couldNotWorkWithJSON: An error when the JSON cannot be converted
/// - guardFail: An error when a guard statment fails
/// - error: A normal NSError/Error that has occured during the docatch
public enum CurrencyError: Error {
    
    case couldNotWorkWithJSON
    case guardFail(for: Int)
    case error(_ : Error)
    case ratesNil(_ : [String : Any])
    case invalidURL(_ : String)
    
    var localizedDescription: String {
        switch self {
        case .couldNotWorkWithJSON:
            return "JSONSerialization could not convert data, check source"
        case .guardFail(let line):
            return "Guard failed on line: \(line)"
        case .error(let error) :
            return error.localizedDescription
        case .ratesNil(let json):
            return "Invalid JSON \(json)"
        case .invalidURL(let url):
            return "Invalid URL \(url)"
        }
    }
}

/**
 Currency Conversion Class, this will download the JSON for the rates and can be initalised with a custom value.
 
 # Note
 Money inside of the basket or Products are not automatically converted,
 as users may not required that.
 */
public class CurrencyConverter: CurrencyConvertable {
    
    public static let shared = CurrencyConverter()
    
    public fileprivate(set) var conversionRate: Float = 0.0
    
    public var decimalRate: NSDecimalNumber {
        return NSDecimalNumber(value: conversionRate)
    }
    
    fileprivate var defaultsManager: DefaultsManager {
        return DefaultsManager(withKey: _offlineRatesUD)
    }
    
    private init() { }
    
    public init(withCovertionRate cr: Float) { self.conversionRate = cr }
    
}

private extension CurrencyConverter {
    
    var _baseCurrency: String {
        return SHOP_CURRENCY_CODE
    }
    
    var _localCurrencyCode: String {
        let locale = Locale.current
        guard let currencyCode = locale.currencyCode else { return "GBP" }
        return Currency(localeIdentifier: currencyCode).description
    }
    
    var _url: URLConvertible {
        return "http://api.fixer.io/latest?base=\(_baseCurrency)&symbols=\(_localCurrencyCode)"
    }
    
    var _offlineRate: Float {
        if _baseCurrency == _localCurrencyCode { return 1.0 }
        
        do {
            let rates = try defaultsManager.retrieveObject() as! [String : Float]
            return rates[_localCurrencyCode] ?? 1.0
        } catch {
            return 1.0
        }
    }
    
}

public extension CurrencyConverter {

    /// The conversion method, this returns the converted rate,
    /// in low internet zones it will used a saved value
    ///
    /// - Parameter value: The pre-converted value
    /// - Returns: The converted Value
    public func convert(_ value: Float) -> Float {
        if conversionRate == 0.0 {
            return value * self._offlineRate
        }
        
        return value * conversionRate
    }
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    func convert(value: NSDecimalNumber) -> NSDecimalNumber {
        if decimalRate == 0.0 {
            let dc = NSDecimalNumber(value: self._offlineRate)
            return value.multiplying(by: dc)
        }
        
        return value.multiplying(by: decimalRate)
    }
    
}

internal extension CurrencyConverter {

    func downloadCurrencyData(handler: @escaping (Error?) -> Void) {
        if self._baseCurrency == self._localCurrencyCode {
            self.conversionRate = 1.0; handler(nil); return
        }
        
        Alamofire.request(self._url).responseData { (response) in
            if response.error != nil, response.data == nil { handler(response.error); return }
            let json = JSON(data: response.data!)
            
            if json["rates"].isEmpty { handler(CurrencyError.couldNotWorkWithJSON); return }
            guard let rates = json["rates"].dictionaryObject as [String : AnyObject]?,
                let rate = rates[self._localCurrencyCode] as? Float
                else {
                    handler(CurrencyError.ratesNil(json.dictionaryValue)); return
            }
            
            self.conversionRate = rate
            self.defaultsManager.set(rates)
            handler(nil)
        }
    }
    
    func setupJSONUserDefaults() {
        let manager = DefaultsManager(withKey: _offlineRatesUD)
        do {
            let values = try manager.retrieveObject()
            _checkForNotEmpty(values as! Dictionary<String, Any>, "Should have items inside")
        } catch {
            manager.set([
                "AUD": 1.6231,
                "BGN": 2.2694,
                "BRL": 3.8936,
                "CAD": 1.6616,
                "CHF": 1.2414,
                "CNY": 8.5835,
                "CZK": 31.355,
                "DKK": 8.6315,
                "EUR": 1.1604,
                "HKD": 9.6832,
                "HRK": 8.6424,
                "HUF": 358.96,
                "IDR": 16590,
                "ILS": 4.5154,
                "INR": 80.867,
                "JPY": 138.54,
                "KRW": 1391.4,
                "MXN": 23.35,
                "MYR": 5.5074,
                "NOK": 10.64,
                "NZD": 1.7758,
                "PHP": 62.503,
                "PLN": 4.9006,
                "RON": 5.2736,
                "RUB": 70.014,
                "SEK": 11.096,
                "SGD": 1.7379,
                "THB": 42.877,
                "TRY": 4.5392,
                "USD": 1.2459,
                "ZAR": 16.032
                ]
            )
        }
    }
    
}
