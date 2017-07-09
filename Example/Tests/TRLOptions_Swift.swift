//
//  TRLOptions_Swift.swift
//  Trolley
//
//  Created by Harry Wright on 09.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Trolley

let kMerchantID: String = "default"

class TRLOptions_Swift: QuickSpec {
        
    override func spec() {
        describe("TRLOptions") {
            context("only has merchant id") {
                it("will throw assertion", closure: {
                    let anOption: TRLOptions = TRLOptions(merchantID: kMerchantID)
                    expect { anOption.validate() }.to(throwAssertion())
                })
            }
            
            context("missing url", closure: { 
                it("will throw assertion", closure: {
                    let anOption: TRLOptions = TRLOptions(merchantID: kMerchantID)
                    anOption.xml[kPlistLocalCurrencyCode] = "GBP"
                    expect { anOption.validate() }.to(throwAssertion())
                })
            })
            
            context("missing currency code", closure: {
                it("will throw assertion", closure: {
                    let anOption: TRLOptions = TRLOptions(merchantID: kMerchantID)
                    anOption.xml[kBaseURLKey] = "http://localhost:8080"
                    anOption.xml[kDefaultRouteKey] = "API"
                    expect { anOption.validate() }.to(throwAssertion())
                })
            })
            
            context("full config file", closure: { 
                it("will not throw an assertion") {
                    // workaround to get the right config file
                    let bundle: Bundle = Bundle(for: type(of: self))
                    let anOption: TRLOptions = TRLOptions(withBundle: bundle)
                    expect { anOption.validate() }.toNot(throwAssertion())
                }
            })
        }
    }
    
}
