//
//  Percentage_Swift.swift
//  Trolley
//
//  Created by Harry Wright on 09.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Trolley

class Percentage_Swift : QuickSpec {
    
    override func spec() {
        describe("Percentage") {
            context("Initalised Properties", closure: { 
                it("Should Pass", closure: {
                    let percentage = Percentage(value: 55)
                    expect(percentage.description).to(equal("55%"))
                    expect(percentage.decimalValue.floatValue).to(equal(0.55))
                })
            })
            
            context("Factory Methods", closure: { 
                it("Should Pass `.for`", closure: {
                    let percentage = Percentage.for(10, in: 50)
                    expect(percentage.description).to(equal("20%"))
                    expect(percentage.decimalValue.floatValue).to(equal(0.2))
                })
                
                it("Should Pass `.decrease`", closure: {
                    let percentage2 = Percentage.decrease(forOld: 10, new: 5)
                    expect(percentage2.description).to(equal("50%"))
                    expect(percentage2.decimalValue).to(equal(0.5))
                    
                    let percentage3 = Percentage.decrease(forOld: 687, new: 123)
                    expect(percentage3.description).to(equal("82.1%"))
                    expect(percentage3.decimalValue).to(equal(0.82))
                })
                
                it("Should Pass `.increase`", closure: {
                    let percentage2 = Percentage.increase(forOld: 10, new: 20)
                    expect(percentage2.description).to(equal("100%"))
                    expect(percentage2.decimalValue).to(equal(1))

                    
                    let percentage3 = Percentage.increase(forOld: 12345, new: 67890)
                    expect(percentage3.description).to(equal("449.94%"))
                    expect(percentage3.decimalValue).to(equal(4.5))
                })
                
                it("Should throw assertion", closure: { 
                    expect { Percentage.decrease(forOld: 10, new: 12) }.to(throwAssertion())
                    expect { Percentage.increase(forOld: 15, new: 12) }.to(throwAssertion())
                })
            })
        }
    }
    
}
