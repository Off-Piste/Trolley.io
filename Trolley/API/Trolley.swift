// TODO: Copy over all the data for the API. -> 50% Done
// TODO: Shop/API Configuration -> 50% Done
// TODO: Reachabilty ✓
// TODO: Offline storage (Caching IMGs)
// TODO: Basket Sync
// TODO: Plist Parser ✓
// TODO: Global Manager
// TODO: Exts -> 50% Done
// TODO: Currency Converter Connection ✓
// TODO: Connect Search Up -> 50% Done (SDK Code ✓)
// TODO: Basket Add/Download -> 50% Done (SDK Code ✓)
//

import Foundation
import PromiseKit
import SwiftyJSON

var kAlreadyConfigured: Bool = false
var kAlreadyConfiguredWarning: String =
    "You have already configured a Trolley Shop. " +
    "Please remove any un-required calls to `configure()` " +
    "or `configure(options:)`, thank you."

/// <#Description#>
public class Trolley {
    
    /// The singleton that ever user should access
    ///
    /// Holds the `TRLOptions` for the shop and the
    /// `TRLNetworkManager`
    public
    static var shared: Trolley = Trolley()
    
    /// <#Description#>
    internal fileprivate(set)
    var anOption: TRLOptions!
    
    /// The network manager that is set up to work with our data.
    ///
    /// Calls for downloads should be made through this.
    public fileprivate(set)
    var networkManager: TRLNetworkManager!
    
    /// The queue to be used when not using `zalgo`
    ///
    /// This is due to when using the default `Promise Kit` parameters 
    /// the closures are never called. So its a workaround
    fileprivate
    let queue = DispatchQueue(
        label: "io.trolley",
        qos: .userInitiated,
        attributes: .concurrent
    )
    
    fileprivate
    init() { }
    
    /**
     * Configures a default Trolley.io Shop.
     *
     * Raises an exception if any configuration step fails. The saved in the 
     * `.shared` singleton. This method should be called after the using 
     * Trolley services.
     *
     * # Note
     * This method is thread safe by using `zalgo`.
     */
    public
    func configure() {
        if kAlreadyConfigured { Log.info(kAlreadyConfiguredWarning); return }
        
        Log.info("Shutter Doors are opening, coffee is flowing")
        
        let options = TRLOptions.default
        self.configure(options: options)
    }
    
    /// <#Description#>
    ///
    /// - Parameter options: <#options description#>
    public
    func configure(options: TRLOptions) {
        if kAlreadyConfigured { Log.info(kAlreadyConfiguredWarning); return }
        kAlreadyConfigured = !kAlreadyConfigured
        
        self.anOption = options
        self.anOption.validate()
        
        self.networkManager = TRLNetworkManager(option: anOption)
        
        guard let reach = Reachability() else {
            NSException.raise("Cannot setup Reachabilty")
            return
        }
        
        
        firstly {
            return reach.promise()
        }.then(on: queue) { (newReach) -> Promise<CurrencyConverter> in
            Log.debug("Current Reachabilty is " + newReach, showThread: true)
            return self.downloadCurrency()
        }.then(on: queue) { convertor -> Promise<TRLUser> in
            Log.debug(
                convertor.convert(275.0),
                convertor.conversionRate,
                Money(275.0),
                showThread: true
            )
            return self.setupUser()
        }.then(on: queue)  { (user) -> Void in
            Log.debug(user, showThread: true)
        }.catch(on: queue) { error in
            Log.error(error)
        }

    }
    
    func setupUser() -> Promise<TRLUser> {
        return Promise { fullfill, reject in
            var usr = TRLUser.current
            
            firstly {
                return LocationManager.promise()
            }.then(execute: { (PM) -> Void in
                usr.placemark = PM
                
                fullfill(usr)
            }).catch(execute: { (error) in
                reject(error)
            })
        }
    }
    
    func downloadCurrency() -> Promise<CurrencyConverter> {
        return Promise { fullfill, reject in
            let converter = CurrencyConverter.shared
            converter.setupJSONUserDefaults()
            
            converter.downloadJSON { (error) in
                if error != nil { reject(error!) }
                else { fullfill(converter) }
            }
        }
    }
    
}

private extension Trolley {
    
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
