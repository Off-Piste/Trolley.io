//
//  URL_Swift.swift
//  Trolley
//
//  Created by Harry Wright on 04.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Trolley

class URL_Swift: QuickSpec {
    
    override func spec() {
        describe("URL's") {
            var networkManager: TRLNetworkManager!
            beforeSuite {
                networkManager = TRLNetworkManager.shared
            }

            describe("Invalid URL's", closure: {
                context("Query Parameters as invalid", closure: {
                    it("Should be nil") {
                        waitUntil(action: { (done) in
                            networkManager
                                .get(.products)
                                .rate(20)
                                .validate()
                                .responseData(handler: { (data, error) in
                                    expect(error).toNot(beNil())
                                    done()
                                }
                            )
                        })
                    }
                })
            })
            
            describe("Valid URL's", closure: { 
                context("Testing Parsed URL", closure: { 
                    it("Should not throw an error", closure: { 
                        expect { try ParsedURL("https://localhost:8080") }.toNot(throwError())
                    })
                    
                    it("Should throw an error", closure: { 
                        expect { try ParsedURL("htps:/localhost:8080") }.to(throwError())
                    })
                })
                
                context("Testing NetworkInfo", closure: {
                    it("Should Pass") {
                        let url = try! ParsedURL("https://localhost:8080")
                        let urlInfo = url.parsedURLInfo
                        
                        expect(urlInfo.host).to(equal("localhost"))
                        expect(urlInfo.secure).to(beTrue())
                        expect(urlInfo.namespace).to(equal("localhost"))
                        expect(urlInfo.connectionURL.absoluteString)
                            .to(equal("wss://localhost:8080/.ws?ns=localhost"))
                    }
                })
            })
        }
    }
    
}
