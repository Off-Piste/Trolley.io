//
//  TRLGeolocation_Swift.swift
//  Trolley
//
//  Created by Harry Wright on 05.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Trolley

class TRLGeolocation_Swift: QuickSpec {
    
    override func spec() {
        describe("TRLGeolocation") { 
            describe("Placemark", closure: { 
                it("Should Return a Placemark", closure: {
                    waitUntil(action: { (done) in
                        let location = CLLocation(latitude: 53.6763221, longitude: -1.9142865)
                        Geolocation.asPlacemark(for: location).then { mark -> Void in
                            expect(mark.postalCode).to(equal("HX4 0HL"))
                            done()
                        }.catch {
                            expect($0).toNot(beNil())
                            done()
                        }
                    })
                })
            })
        }
    }
    
}
