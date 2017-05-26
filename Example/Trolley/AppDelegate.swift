//
//  AppDelegate.swift
//  Trolley
//
//  Created by harrytwright on 05/22/2017.
//  Copyright (c) 2017 harrytwright. All rights reserved.
//

import UIKit
import SwiftyJSON
import PromiseKit
import Trolley

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // If you are using our API to store your data you should call this.
        // If not then we would reccomend using `Trolley/Core` in your podfile
        // for the use of the Core functionality without all the heavy stuff
        Trolley.shared.configure()
        
        // MARK: How to use Promise Kit
        // 1 -> Calling `firstly<T>(execute:) -> Promise<T>`
        // this closure allows you to call any pre-networking call methods,
        // i.e Network Activ Indicator. Once you have done that return your required
        // `Promise`.
        
        // 2 -> After you return your `Promise`, then call `.then<U>(execute:) -> Promise<U>`
        // this is called once your previous promise is fullfilled, the tuple response is the
        // generic value `T` supplied in the `firstly`
        //
        // NOTE:
        // Setting the closure `to -> Void` isn't always needed but here it stopped an error
        
        // 3 -> Calling `.always(execute:) -> Promise<Void>` is helpful if you have set the
        // Network Activ Indicator to true so you can change it back
        
        // 4 -> calling `.`catch`(execute:) -> Promise<Void>` is required, this allows you
        // to handle your errors correctly. Using a swicth statment you can have your errors
        // seperated out if you need to vary your response.
        
        // 1.
        firstly { _ -> Promise<[Products]> in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            return Products.getAll()
            
        // 2.
        }.then { (products) -> Void in
            print(String(describing: products))
            
        // 3.
        }.always {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        // 4.
        }.catch { (error) in
            print(error)
        }
        
        return true
    }

}

