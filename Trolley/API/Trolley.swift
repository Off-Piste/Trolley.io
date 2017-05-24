// TODO: Copy over all the data for the API.
// TODO: Shop/API Configuration
// TODO: Reachabilty ✓
// TODO: Offline storage (Caching IMGs)
// TODO: Basket Sync
// TODO: Plist Parser ✓
// TODO: Global Manager
// TODO: Exts
//

import Foundation
import PromiseKit
import SwiftyJSON

/// <#Description#>
public class Trolley {
    
    /// <#Description#>
    public
    static var shared: Trolley = Trolley()
    
    public fileprivate(set)
    var anOption: TRLOptions!
    
    /// <#Description#>
    public fileprivate(set)
    var networkManager: TRLNetworkManager!
    
    /// <#Description#>
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
        let options = TRLOptions.default
        self.configure(options: options)
    }
    
    public
    func configure(options: TRLOptions) {
        self.anOption = options
        self.validateOption(anOption)
        
        self.networkManager = TRLNetworkManager(option: anOption)
        
        guard let reach = Reachability() else {
            NSException.raise("Cannot setup Reachabilty")
            return
        }
        
        reach.promise().then(on: queue) { (newReach) -> Void in
            print(newReach.currentReachabilityString)
        }.catch(on: queue) { error in
            print(error)
        }

    }
    
    /// A method to check the options inside TRLOptions.
    ///
    /// If it fails the validation then it will raise an exception
    ///
    /// - Parameter anOption: The TRLOption been used
    func validateOption(_ anOption: TRLOptions) {
        if anOption.error != nil {
            switch anOption.error! {
            case ParserError.error.pathCannotBeFound:
                NSException.raise("The required plist cannot be found, please download from <url>")
            default:
                NSException.raise(anOption.error!.localizedDescription)
            }
        }
        
        if anOption.merchantID.isEmpty {
            NSException.raise("The Merchant ID is nil, please re-download the plist")
        }
    }
    
}

extension Trolley {
    
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
