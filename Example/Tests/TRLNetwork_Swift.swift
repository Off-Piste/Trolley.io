//
//  TRLNetwork.swift
//  Trolley
//
//  Created by Harry Wright on 10.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Trolley

class TRLNetwork_Swift: QuickSpec {
        
    override func spec() {
        describe("TRLNetwork") { 
            context("Invalid URL", closure: {
                it("Should throw error", closure: {
                    expect { try TRLNetwork("htp:/localhost:9090") }.to(throwError())
                })
                
                it("Should be nil", closure: { 
                    let network = TRLNetwork(url: "htp:/localhost:9090")
                    expect(network).to(beNil())
                })
            })
            
            context("Valid URL", closure: { 
                it("Should not throw error", closure: {
                    expect { try TRLNetwork("http://localhost:8080") }.toNot(throwError())
                })
                
                it("Should not be nil", closure: {
                    let network = TRLNetwork(url: "http://localhost:8080")
                    expect(network).toNot(beNil())
                })
            })
            
            // Making sure that the URL path is not overwriten
            describe("Builidng A Request", closure: {
                let network = try! TRLNetwork("http://api.fixer.io")
                
                context("First Path", closure: {
                    it("Should be valid", closure: {
                        let request = network.get(
                            "latest",
                            with: ["base" : "USD"],
                            encoding: URLEncoding.queryString,
                            headers: nil
                        )
                        
                        expect(request.dataRequest.request?.url?.absoluteString)
                            .to(equal("http://api.fixer.io/latest?base=USD"))
                    })
                })
                
                context("Second Path", closure: {
                    it("Should be valid", closure: {
                        let request = network.get(
                            "2000-01-03",
                            with: ["base" : "USD"],
                            encoding: URLEncoding.queryString,
                            headers: nil
                        )
                        
                        expect(request.dataRequest.request?.url?.absoluteString)
                            .to(equal("http://api.fixer.io/2000-01-03?base=USD"))
                    })
                })
                
                context("Making A Call", closure: { 
                    let request = network.get(
                        "latest",
                        with: ["base" : "USD", "symbols" : "GBP"],
                        encoding: URLEncoding.queryString,
                        headers: nil
                    )
                    
                    waitUntil(action: { (done) in
                        request.responseJSON(handler: { (json, error) in
                            if error != nil { expect(error).toNot(beNil()); done(); return }
                            expect(json["base"].string).to(equal("USD"))
                            expect(json["rates"].count).to(equal(1))
                            done()
                        })
                    })
                })
            })
        }
    }
    
}
