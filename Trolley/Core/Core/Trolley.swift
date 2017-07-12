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

extension NotificationCenter {

    func addObserver(_ observer: Notification.Name, object: Any?, block: @escaping (Notification) -> Void) {
        self.addObserver(forName: observer, object: object, queue: .main, using: block)
    }

}

var kURLBase: String = "http://localhost:8080/API"

var kAlreadyConfigured: Bool = false

var kAlreadyConfiguredWarning: String =
    "You have already configured a Trolley Shop. " +
    "Please remove any un-required calls to `configure()` " +
    "or `configure(options:)`, thank you."

// Might Remove the (TRLShop) from the Objc but the idea is
// that the ObjC version of Basket will be called Trolley
/// Add Desc
@objc(TRLShop)
public class Trolley : NSObject {

    /// The singleton that ever user should access
    ///
    /// Holds the `TRLOptions` for the shop and the
    /// `TRLNetworkManager`
    public
    static var shared: Trolley = Trolley()

    /// <#Description#>
    internal fileprivate(set)
    var anOption: TRLOptions!

    fileprivate
    var networkManager: TRLNetworkManager!

    fileprivate
    var analytics: TRLAnalytics!

    /// <#Description#>
    internal
    var webSocketManager: TRLWebSocketManager!

    internal
    var reachability: Reachability! {
        didSet {
            TRLCoreLogger.debug("Reachabilty has been set")
        }
    }

    /// <#Descripvarn#>
    fileprivate
    var parsedURL: ParsedURL {
        return networkManager.network.parsedURL
    }

    fileprivate
    let queue = DispatchQueue(
        label: "io.trolley",
        qos: .userInitiated,
        attributes: .concurrent
    )

    /// <#Description#>
    fileprivate
    override init() { }

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
        self.configure(withLogging: false)
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
     */
    public
    func configure(withLogging log: Bool) {
        if kAlreadyConfigured { TRLDefaultLogger.info(kAlreadyConfiguredWarning); return }

        let options = TRLOptions.default
        self.configure(options: options, withLogging: log)
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
    func configure(options: TRLOptions, withLogging log: Bool = false) {
        if kAlreadyConfigured { TRLCoreLogger.info(kAlreadyConfiguredWarning); return }
        kAlreadyConfigured = !kAlreadyConfigured

        TRLDefaultLogger.info("Shutter Doors are opening, coffee is flowing")
        self.setLoggingEnabled(log, function: #function)

        self.analytics = TRLAnalytics()
        self.anOption = options
        self.anOption.validate()

        SHOP_CURRENCY_CODE = self.anOption.currencyCode

        do {
            try self.setupNetworking(self.anOption)
        } catch {
            self.fatalError(error)
        }

        firstly {
            return self.setupReachability()
        }.then(on: queue) { (newReach) -> Promise<CurrencyConverter> in
            _check(newReach.currentReachabilityStatus != .notReachable, "Value should be reachable")
            self.reachability = newReach

            TRLCoreLogger.debug("Reachability", self.reachability, true)
            return self.downloadCurrency()
        }.then(on: queue) { convertor -> Promise<TRLUser> in
            TRLCoreLogger.debug("Conversion rate:", convertor.conversionRate)
            return self.setupUser()
        }.then(on: queue)  { (user) -> Void in
            //
        }.catch(on: queue) { error in
            TRLCoreLogger.error(error.localizedDescription)
        }

    }

    private
    func setLoggingEnabled(_ enabled: Bool, function: String) {
        if enabled {
            TRLDefaultLogger.info("[DEBUG] tags will be now shown in the console, please set `withLogging` parameter back to true")
        }
        isInDebugMode = enabled
    }

}

private
extension Trolley {

    func setupReachability() -> Promise<Reachability> {
        NotificationCenter.default.addObserver(ReachabilityChangedNotification, object: nil) {
            if $0.object != nil, $0.object is Reachability {
                self.reachability = $0.object as! Reachability
            }
        }

        guard let aReachabilty = Reachability() else {
            preconditionFailure("Cannot setup Reachabilty")
        }

        return aReachabilty.promise()
    }

    func setupNetworking(_ anOption: TRLOptions) throws {
        self.networkManager = try TRLNetworkManager(option: anOption)
        let url = self.networkManager.connectionURL
        
        self.webSocketManager = try TRLWebSocketManager(url: url, protocols: nil)
        self.webSocketManager.open()
    }

    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func setupUser() -> Promise<TRLUser> {
        return Promise { fullfill, reject in
            let usr = TRLUser.current
            fullfill(usr)
//            firstly {
//                return LocationManager.promise()
//            }.then { (PM) -> Void in
//                usr.placemark = PM
//                fullfill(usr)
//            }.catch { (error) in
//                reject(error)
//            }
        }
    }

    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func downloadCurrency() -> Promise<CurrencyConverter> {
        return Promise { fullfill, reject in
            let converter = CurrencyConverter.shared
            converter.setupJSONUserDefaults()

            converter.downloadCurrencyData { (error) in
                if error != nil { reject(error!) }
                else { fullfill(converter) }
            }
        }
    }

    func fatalError(_ error: Error) {
        let reason: String =
        "Reason: \(error.localizedDescription) " +
            "What to dso next? Check our Error FAQ documention and see if your error " +
            "has been mentioned if not, please raise an issue on our github with " +
            "all the details https://github.com/Off-Piste/Trolley.io"
        Swift.fatalError(reason)
    }


}

extension UserDefaults {
    
    static var trolley: UserDefaults {
        return UserDefaults(suiteName: "io.trolley")!
    }
    
}

public extension TRLNetworkManager {

    static var shared: TRLNetworkManager {
        return Trolley.shared.networkManager
    }

}

public extension TRLAnalytics {

    static var shared: TRLAnalytics {
        return Trolley.shared.analytics
    }

}
