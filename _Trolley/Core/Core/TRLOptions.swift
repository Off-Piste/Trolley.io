//
//  TRLOptions.swift
//  Pods
//
//  Created by Harry Wright on 24.05.17.
//
//

import Foundation
import SwiftyJSON
import PromiseKit

let kPlistName: String = "Trolley-Config"
let kPlistMerchantIDKey: String = "Merchant-ID"
let kPlistLocalCurrencyCode: String = "Shop-Currency-Code"
let kBaseURLKey: String = "Base-URL"
let kDefaultRouteKey: String = "Default-Route"

typealias XML = JSON

public class TRLOptions {

    /// <#Description#>
    public static var `default`: TRLOptions = TRLOptions()

    /// <#Description#>
    /* private(set) */
    internal(set) var xml: XML = [:]

    /// <#Description#>
    fileprivate private(set) var error: Error?

    /// <#Description#>
    private convenience init() {
        self.init(plist: kPlistName)
    }

    /// <#Description#>
    ///
    /// - Parameter plist: <#plist description#>
    public init(plist: String) {
       firstly {
           return parsePLIST(in: plist)
       }.then(on: zalgo) { (xml) -> Void in
           self.xml = xml
       }.catch(on: zalgo) { (error) in
           self.error = error
       }
    }

    /// <#Description#>
    ///
    /// - Parameter merchantID: <#merchantID description#>
    public init(merchantID: String) {
        self.xml = [kPlistMerchantIDKey: merchantID]
    }
    
    /* Testing */
    internal init(withBundle bundle: Bundle) {
        firstly {
            return self.parsePlist(kPlistName, inBundle: bundle)
        }.then(on: zalgo) { (xml) -> Void in
            self.xml = xml
        }.catch(on: zalgo) { (error) in
            self.error = error
        }
    }

}

public extension TRLOptions {

    public var containsError: Bool {
        return (error != nil) ? true : false
    }

    /// <#Description#>
    public var merchantID: String {
        return xml[kPlistMerchantIDKey].stringValue
    }
    
    public var currencyCode: String {
        return xml[kPlistLocalCurrencyCode].stringValue
    }

    private var baseURL: String {
        return xml[kBaseURLKey].stringValue
    }

    private var defaultURLRoute: String {
        return xml[kDefaultRouteKey].stringValue
    }

    internal var url: String {
        return baseURL + "/" + defaultURLRoute
    }

}

internal extension TRLOptions {

    func validate() {
        if self.containsError {
            let err = self.error!
            switch err {
            case ParserError.error.pathCannotBeFound:
                assertionFailure("The required plist cannot be found, please download from <url>")
            default:
                assertionFailure(err.localizedDescription)
            }
        }
        
        assert(!self.merchantID.isEmpty, "The Merchant ID is nil, please re-download the plist")
        assert(!self.currencyCode.isEmpty, "The Currency Code is nil, please re-download the plist")
        assert(self.url != "/", "The URL is not set, please re-download the plist")
    }

}

/** private */ extension TRLOptions {

    /// <#Description#>
    ///
    /// - Parameter file: <#file description#>
    /// - Returns: <#return value description#>
    fileprivate func parsePLIST(in file: String) -> Promise<XML> {
        return  Promise { fullfill, reject in
            do {
                let items = try Parser(forResouceName: file, ofType: "plist").items
                let xml = XML(items)
                fullfill(xml)
            } catch {
                reject(error)
            }
        }
    }
    
    /* Testing */
    internal func parsePlist(_ name: String, inBundle bundle: Bundle) -> Promise<XML> {
        let promise: Promise<XML>
        do {
            let items = try Parser(bundle: bundle, name: name, type: "plist").items
            let xml = XML(items)
            promise = Promise(value: xml)
        } catch {
            promise = Promise(error: error)
        }
        
        return promise
    }
}
