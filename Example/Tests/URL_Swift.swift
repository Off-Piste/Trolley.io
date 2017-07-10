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
            describe("Invalid URL's", closure: {
                context("Testing Parsed URL", closure: {
                    it("Should throw an error", closure: {
                        expect { try ParsedURL("htps:/localhost:8080") }.to(throwError())
                    })
                })
            })
            
            describe("Valid URL's", closure: { 
                context("Testing Parsed URL", closure: { 
                    it("Should not throw an error", closure: { 
                        expect { try ParsedURL("https://localhost:8080") }.toNot(throwError())
                        expect { try ParsedURL("http://api.fixer.io") }.toNot(throwError())
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
                        
                        let url2 = try! ParsedURL("http://gmail.com/API")
                        let url2Info = url2.parsedURLInfo
                        
                        expect(url2Info.host).to(equal("gmail.com"))
                        expect(url2Info.secure).to(beFalse())
                        expect(url2Info.namespace).to(equal("gmail"))
                        expect(url2Info.connectionURL.absoluteString)
                            .to(equal("ws://gmail.com/.ws?ns=gmail"))
                        
                        let url3 = try! ParsedURL("http://api.fixer.io")
                        let url3Info = url3.parsedURLInfo
                        
                        expect(url3Info.host).to(equal("api.fixer.io"))
                        expect(url3Info.secure).to(beFalse())
                        expect(url3Info.namespace).to(equal("fixer"))
                        expect(url3Info.connectionURL.absoluteString)
                            .to(equal("ws://api.fixer.io/.ws?ns=fixer"))
                        
                    }
                })
            })
        }
    }
    
}
