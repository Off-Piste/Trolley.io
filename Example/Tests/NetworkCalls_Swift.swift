// https://github.com/Quick/Quick

import Quick
import Nimble
@testable import Trolley
@testable import Pods_Trolley_Tests
@testable import Pods_Trolley_Example

extension Trolley {
    
    func configure(forBundle bundle: Bundle) {
        let anOption = TRLOptions(withBundle: bundle)
        self.configure(options: anOption)
    }
    
}

class NetworkCalls_Swift: QuickSpec {
    
    override func spec() {
        describe("TRLNetworkManager") {
            var networkManager: TRLNetworkManager!
            beforeSuite {
                let bundle = Bundle(for: type(of: self))
                Trolley.shared.configure(forBundle: bundle)
                networkManager = TRLNetworkManager.shared
            }
            
            describe("Products Response") {
                
                // This will fail if the sever is running
                // so make sure to test on a device not
                // conencted to wifi
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
