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

    /// <#Descripvarn#>
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
    fileprivate var webSocketManager: TRLWebSocketManager!

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
        do {
            try self.setupNetworking(self.anOption)
        } catch {
            self.fatalError(error)
        }

        guard let reach = Reachability() else {
            NSException.raise("Cannot setup Reachabilty")
            return
        }

        firstly {
            return reach.promise()
        }.then(on: queue) { (newReach) -> Promise<CurrencyConverter> in
            _check(newReach.currentReachabilityStatus != .notReachable, "Value should be reachable")
            Log.debug("Reachability", newReach, true)
            return self.downloadCurrency()
        }.then(on: queue) { convertor -> Promise<TRLUser> in
            Log.debug("Conversion rate:", convertor.conversionRate)
            return self.setupUser()
        }.then(on: queue)  { (user) -> Void in
            //
        }.catch(on: queue) { error in
            Log.error(error.localizedDescription)
        }

    }

    public
    func setLoggingEnabled(_ enabled: Bool) {
        isInDebugMode = enabled
    }

}

private extension Trolley {

    func setupNetworking(_ anOption: TRLOptions) throws {
        self.networkManager = try TRLNetworkManager(option: anOption)

        let dm = DefaultsManager(withKey: "_local_websocket")
        let url = try! dm.retrieveObject() as! String

        self.webSocketManager = try TRLWebSocketManager(url: url, protocols: nil)
        self.webSocketManager.open()
    }

    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func setupUser() -> Promise<TRLUser> {
        return Promise { fullfill, reject in
            var usr = TRLUser.current

            firstly {
                return LocationManager.promise()
            }.then { (PM) -> Void in
                usr.placemark = PM
                fullfill(usr)
            }.catch { (error) in
                reject(error)
            }
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

    func fatalError(_ error: Error) {
        let reason: String =
        "Reason: \(error.localizedDescription) " +
            "What to do next? Check our Error FAQ documention and see if your error " +
            "has been mentioned  if not, please rasie an issue on out github with " +
            "all the details https://github.com/Off-Piste/Trolley.io"
        Swift.fatalError(reason)
    }


}

public extension TRLNetworkManager {

    static var shared: TRLNetworkManager {
        return Trolley.shared.networkManager
    }

}
