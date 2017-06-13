// https://github.com/Quick/Quick

import Quick
import Nimble
import Trolley

import Pods_Trolley_Tests

@testable import Pods_Trolley_Example

class CoreTest: QuickSpec {
    
    override func spec() {
        describe("Percentage Testing") {
            let p1: Percentage = 2
            let p2: Percentage = 55%
            let p3: Percentage = .increase(forOld: 20, new: 22)
            let p4: Percentage = .increase(forOld: Money(20), new: Money(22))
            let p5: Percentage = .for(12, in: 40)
            let p6: Percentage = Percentage(calculation: 50 / 100)
            let p7: Percentage = .decrease(forOld: 22, new: 9)
            let p8: Percentage = .decrease(forOld: Money(22), new: Money(9))
            let p9: Percentage = 55.9
            let p10: Percentage = .increase(forOld: 44.9, new: 66.8)
            
            print(p1.roundedValue, p1)
            XCTAssertTrue(p1.roundedValue == 2)
            
            print(p2.roundedValue, p2)
            XCTAssertTrue(p2.roundedValue == 55)
            
            print(p3.roundedValue, p3)
            XCTAssertTrue(p3.roundedValue == 10)
            
            print(p4.roundedValue, p4)
            XCTAssertTrue(p4.roundedValue == 10)
            
            print(p5.roundedValue, p5)
            XCTAssertTrue(p5.roundedValue == 30)
            
            print(p6.roundedValue, p6)
            XCTAssertTrue(p6.roundedValue == 50)
            
            print(p7.roundedValue, p7)
            XCTAssertTrue(p7.roundedValue == 59.09)
            
            print(p8.roundedValue, p8)
            XCTAssertTrue(p8.roundedValue == 59.09)
            
            print(p9.roundedValue, p9)
            XCTAssertTrue(p9.roundedValue == 55.9)
            
            print(p10.roundedValue, p10)
            XCTAssertTrue(p10.roundedValue == 48.78)
        }
    }
    
}
