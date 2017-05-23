//
//  AppDelegate.swift
//  Trolley
//
//  Created by harrytwright on 05/22/2017.
//  Copyright (c) 2017 harrytwright. All rights reserved.
//

import UIKit
import Trolley

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let manager = TRLNetworkManager(withKey: "default", isLocal: true).fetch(.products)
        manager.responseProducts { (products, error) in
            if error != nil {
                print(error!)
            } else {
                print(products!)
            }
        }
        
        return true
    }

}

