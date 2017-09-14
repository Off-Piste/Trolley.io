//
//  ViewController.swift
//  TestTNT
//
//  Created by Harry Wright on 08.09.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

import UIKit
import TrolleyNetworkingTools.Private

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!

    var reach: Reachability!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        reach = Reachability(hostName: "www.apple.com")
        reach.startNotifier()

        print(reach.currentReachabilityStatus())

        NotificationCenter
            .default
            .addObserver(forName: .reachabilityChanged, object: nil, queue: nil) { (notif) in
                self.label.text = notif.userInfo?["Status"] as? String ?? "Not worked"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

