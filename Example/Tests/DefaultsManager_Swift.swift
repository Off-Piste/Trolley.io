//
//  DefaultsManager_Swift.swift
//  Trolley
//
//  Created by Harry Wright on 08.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Trolley

class DefaultsManager_Swift: QuickSpec {
        
    override func spec() {
        describe("Defaults Manager") {
            var dm: DefaultsManager!
            let kDefaultsManagerKey: String = "_test_key"
            beforeSuite {
                dm = try! DefaultsManager(withKey: kDefaultsManagerKey, testName: "DefaultsManager")
                dm.clearSuite()
            }
            
            context("Emptying NSUserDefaultsObject") {
                // This does clean but isn't doing it in this suite
                it("Should throw an error") {
                    dm.clearSuite()
                    expect { try dm.retrieveObject() }.to(throwError())
                }
            }
            
            context("Empty NSUserDefaultsObject", closure: {
                it("Should throw an error", closure: {
                    let manager = DefaultsManager(withKey: "throwError")
                    expect { try manager.retrieveObject() }.to(throwError())
                })
            })
            
            context("Wrong Type", closure: {
                it("Should not be a float", closure: {
//                    let dm = DefaultsManager(withKey: kDefaultsManagerKey)
                    dm.set("Hello World")
                    expect{ try dm.retrieveObject() }.toNot(beAKindOf(Float.self))
                })
            })
        }
    }
    
}
