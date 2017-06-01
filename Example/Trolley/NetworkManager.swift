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

// They require handlers so that they can pass back the datasource infomation, 
// keeping it in a simple handler reduces the cluttering of a UIViewController

@available(iOS 10.0, *)
protocol Networkable {
    
    func startDownload(_ handler: @escaping (Datasource) -> Void)
    
    func startRefresh(_ handler: @escaping (Datasource) -> Void)
    
}

@available(iOS 10.0, *)
class NetworkManager {
    
    var datasource: Datasource
    
    var viewController: UIViewController
    
    init(datasource: Datasource, vc: UIViewController) {
        self.datasource = datasource
        self.viewController = vc
    }
    
}

@available(iOS 10.0, *)
extension NetworkManager : Networkable {
    
    func startDownload(_ handler: @escaping (Datasource) -> Void) {
        self.networkCall().then { (products) -> Void in
            print("Download successfull")
            handler(self.handledDatasource(products, nil))
        }.catch { (error) in
            handler(self.handledDatasource([], error))
            self.postAlert(for: error, to: self.viewController)
        }
    }
    
    func startRefresh(_ handler: @escaping (Datasource) -> Void) {
        // Removing all is required or the data is just overwritten
        self.datasource.objects.removeAll()
        
        self.networkCall().then { products -> Void in
            print("Download successfull")
            handler(self.handledDatasource(products, nil))
        }.catch { (error) in
            handler(self.handledDatasource([], error))
            self.postAlert(for: error, to: self.viewController)
        }
    }
    
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
            self.datasource.tableView.refreshControl?.endRefreshing()
            print($0)
        }
    }
    
}
