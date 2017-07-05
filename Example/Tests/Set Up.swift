//
//  Set Up.swift
//  Trolley
//
//  Created by Harry Wright on 04.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Quick
@testable import Trolley

// Any set up code required by both Swift & 
// Objc should be placed in here.

extension Trolley {
    
    /// This is so the code can find the right bundle
    func configure(forBundle bundle: Bundle) {
        let anOption = TRLOptions(withBundle: bundle)
        self.configure(options: anOption)
    }
    
}

class Trolley_ioConfiguration: QuickConfiguration {
    
    override class func configure(_ configuration: Configuration) {
        configuration.beforeSuite {
            let bundle = Bundle(for: self)
            Trolley.shared.configure(forBundle: bundle)
        }
    }
    
}
