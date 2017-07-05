// https://github.com/Quick/Quick

import Quick
import Nimble
@testable import Trolley
@testable import Pods_Trolley_Tests
@testable import Pods_Trolley_Example

class NetworkCalls_Swift: QuickSpec {
    
    override func spec() {
        describe("TRLNetworkManager") {
            var networkManager: TRLNetworkManager!
            beforeSuite {
                networkManager = TRLNetworkManager.shared
            }
            
            describe("Products Response") {
                
                // When the sever is running and you expect
                // this to fail, un-comment this line
//                xcontext("Server Is Unreachable") {
                context("Server Is Unreachable") {
                    it("Error Should Not Be Nil") {
                        waitUntil(action: { (done) in
                            networkManager
                                .get(.products)
                                .responseProducts(handler: { (response) in
                                    expect(response.error).toNot(beNil())
                                    done()
                                }
                            )
                        })
                    }
                }
            }
        }
    }
    
}
