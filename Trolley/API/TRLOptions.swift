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
let kBaseURLKey: String = "Base-URL"
let kDefaultRouteKey: String = "Default-Route"

typealias XML = JSON

public class TRLOptions {
    
    /// <#Description#>
    public static var `default`: TRLOptions = TRLOptions()
    
    /// <#Description#>
    private(set) var xml: XML = [:]
    
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
    
}

public extension TRLOptions {
    
    public var containsError: Bool {
        return (error != nil) ? true : false
    }
    
    /// <#Description#>
    public var merchantID: String {
        return xml[kPlistMerchantIDKey].stringValue
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
                NSException.raise("The required plist cannot be found, please download from <url>")
            default:
                NSException.raise(err.localizedDescription)
            }
        }
        
        if self.merchantID.isEmpty {
            NSException.raise("The Merchant ID is nil, please re-download the plist")
        }
    }
    
}

private extension TRLOptions {
    
    /// <#Description#>
    ///
    /// - Parameter file: <#file description#>
    /// - Returns: <#return value description#>
    func parsePLIST(in file: String) -> Promise<XML> {
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
}
