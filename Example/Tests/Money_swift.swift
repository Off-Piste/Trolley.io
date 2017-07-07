//
//  Money_swift.swift
//  Trolley
//
//  Created by Harry Wright on 07.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Trolley

class Money_swift : QuickSpec {
    
    override func spec() {
        describe("Money") {
            context("", closure: {
                it("Should Pass", closure: { 
                    let money: Money = 56
                    expect(money.stripe).to(equal(5600))
                    expect(money.currency.code).to(equal(Locale.current.currencyCode))
                    expect(money.isNegative).to(beFalse())
                    expect(money.negative.integerValue).to(equal(-56))
                })
            })
        }
    }
    
}
