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
@_exported import PromiseKit
@_exported import SwiftyJSON

extension Notification.Name {
    
    static var basketUpdated = Notification.Name("basketUpdated")
    
    static var productsUpdated = Notification.Name("productsUpdated")
    
    static var invalidAPIKey = Notification.Name("invalidAPIKey")
    
    static var connectionLost = Notification.Name("connectionLost")
    
}

var kURLBase: String = "http://localhost:8080/API"

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
    
    /// <#Description#>
    fileprivate
    var parsedURL: ParsedURL {
        return networkManager.network.parsedURL
    }
    
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
    
    /// <#Description#>
    private var webSocket: TRLWebSocketConnection!
    
    /// <#Description#>
    fileprivate
    init() { }
    
    /**
     * Configures a default Trolley.io Shop.
     *
     * Raises an exception if any configuration step fails. The saved in the 
     * `.shared` singleton. This method should be called after the using 
     * Trolley services.
     *
     * - Note
     * This method is thread safe by using `zalgo`.
     */
    public
    func configure() {
        if kAlreadyConfigured { Log.info(kAlreadyConfiguredWarning); return }
        
        let options = TRLOptions.default
        self.configure(options: options)
    }
    
    /**
     * Configures a default Trolley.io Shop.
     *
     * Raises an exception if any configuration step fails. The saved in the
     * `.shared` singleton. This method should be called after the using
     * Trolley services.
     *
     * - Note
     * This method is thread safe by using `zalgo`.
     *
     * - Parameter options: The TRLOptions that all the code will look at
     */
    public
    func configure(options: TRLOptions) {
        if kAlreadyConfigured { Log.info(kAlreadyConfiguredWarning); return }
        kAlreadyConfigured = !kAlreadyConfigured
        
        Log.info("Shutter Doors are opening, coffee is flowing")
        
        self.anOption = options
        self.anOption.validate()
        
        self.networkManager = TRLNetworkManager(network: TRLNetwork(option: anOption))
        webSocket = TRLWebSocketConnection(parsedURL: parsedURL, queue: queue)
        webSocket.open()
        
        guard let reach = Reachability() else {
            NSException.raise("Cannot setup Reachabilty")
            return
        }
        
        firstly {
            return reach.promise()
        }.then(on: queue) { (newReach) -> Promise<CurrencyConverter> in
            _check(newReach.currentReachabilityStatus != .notReachable, "Value should be reachable")
            return self.downloadCurrency()
        }.then(on: queue) { convertor -> Promise<TRLUser> in
            return self.setupUser()
        }.then(on: queue)  { (user) -> Void in
            //
        }.catch(on: queue) { error in
            Log.error(error)
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
                fullfill(XML(items))
            } catch {
                reject(error)
            }
        }
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
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
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
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
