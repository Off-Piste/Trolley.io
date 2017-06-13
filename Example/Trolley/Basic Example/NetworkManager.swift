//
//  Network Manager.swift
//  Trolley
//
//  Created by Harry Wright on 31.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Trolley
import UIKit
import PromiseKit

/// <#Description#>
typealias Completion = (Datasource) -> Void

/// Networkable, this will hold the required download methods.
///
/// # NOTE
/// Due to flow of infomation a handler is still required to send
/// the Datasource/Object data back to the Controller.
/// 
/// This can be done with either Promise Kit, closures or delegates,
/// I personally find that a simple 'invisable' parameter closure
/// is the best, most simple and elegent
///
///     networkable.startDownload { self.dataArray = $0.objects }
///
@available(iOS 10.0, *)
protocol Networkable {
    
    /// The Method to start the download of the data.
    ///
    /// The advantage of having the network calls held 
    /// away from the VC is that the VC can do what it 
    /// does best, control the view and not have to look
    /// so clustered like many apps are.
    ///
    /// - Parameter handler: The Datasource for the tableview,
    ///   this could be: `([Products], Error?)` but holding it all
    ///   inside datasouce keeps it cleaner
    func startDownload(_ handler: @escaping Completion)
    
    /// The Method to start the fresh download of the data.
    ///
    /// The advantage of having the network calls held
    /// away from the VC is that the VC can do what it
    /// does best, control the view and not have to look
    /// so clustered like many apps are.
    ///
    /// - Parameter handler: The Datasource for the tableview,
    ///   this could be: `([Products], Error?)` but holding it all
    ///   inside datasouce keeps it cleaner
    func startRefresh(_ handler: @escaping Completion)
    
}

/**
 
 */
@available(iOS 10.0, *)
class NetworkManager {
    
    /// <#Description#>
    var datasource: Datasource
    
    /// <#Description#>
    var viewController: UIViewController
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - datasource: <#datasource description#>
    ///   - vc: <#vc description#>
    init(datasource: Datasource, vc: UIViewController) {
        self.datasource = datasource
        self.viewController = vc
    }
    
}

// MARK: - Conforming to Networkable
@available(iOS 10.0, *)
extension NetworkManager : Networkable {
    
    func startDownload(_ handler: @escaping Completion) {
        self.networkCall().then { (products) -> Void in
            print("Download successfull")
            handler(self.handledDatasource(products, nil))
        }.catch { (error) in
            handler(self.handledDatasource([], error))
            self.postAlert(for: error, to: self.viewController)
        }
    }
    
    func startRefresh(_ handler: @escaping Completion) {
        
        // Removing all is required or the data is just overwritten
        self.datasource.objects.removeAll()
        
        // No need to re-call `networkCall()` when
        // the above method already does that, DRY!
        self.startDownload { handler($0) }
    }
    
}

// MARK: - Private Methods
@available(iOS 10.0, *)
fileprivate extension NetworkManager {

    /// Method to actually handle the network call.
    ///
    /// It will use the very handy and helpful
    /// `Products.getAll()` method, this downloads 
    /// all the Products that are held current shop.
    ///
    /// # NOTE
    /// For how this works, check the `AppDelegate` for
    /// a step by step walkthrough
    ///
    /// - Returns: A Promise of `[Products]`
    func networkCall() -> Promise<[Products]> {
        return Promise { fullfill, reject in
            firstly { _ -> Promise<[Products]> in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                return Products.getAll()
            }.then { (products) -> Void in
                fullfill(products)
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }.catch { (error) in
                reject(error)
            }
        }
    }
    
    func handledDatasource(_ products: [Products], _ error: Error?) -> Datasource {
        self.datasource.objects = products
        self.datasource.error = error
        return self.datasource
    }
    
    func postAlert(
        for error: Error,
        to vc: UIViewController,
        withStyle style: UIAlertControllerStyle = .alert
        )
    {
        let alert = PMKAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        _ = alert.addActionWithTitle(title: "Okay")
        vc.promise(alert).tap {
            self.datasource.tableView?.refreshControl?.endRefreshing()
            print($0)
        }
    }
    
}
