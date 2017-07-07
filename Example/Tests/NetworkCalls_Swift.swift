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
                        var products = [Product]()
                        waitUntil(action: { (done) in
                            networkManager.get(.products).responseJSON(handler: { (json, error) in
                                if error != nil {
                                    expect(error).toNot(beNil())
                                    done()
                                } else {
                                    // Ths Products array can be updated by two ways:
                                    
                                    // Firstly
                                    products.append(contentsOf: json.arrayValue.flatMap { try? Product(json: $0) } )
                                    
                                    // OR
                                    
//                                    for item in json.arrayValue {
//                                        guard let product = try? Product(json: item) else { continue }
//                                        products.append(product)
//                                    }
                                    

                                    expect(products.count).to(equal(json.arrayValue.count))
                                    done()
                                }
                            })
                        })
                    }
                }
                
                context("Server Is Reachable") {
                    it("Products count should be the same as json.arrayValue.count") {
                        var products = [Product]()
                        waitUntil(action: { (done) in
                            networkManager.get(.products).responseJSON(handler: { (json, error) in
                                if error != nil {
                                    done()
                                } else {
                                    for item in json.arrayValue {
                                        guard let product = try? Product(json: item) else { continue }
                                        products.append(product)
                                    }
                                    
                                    
                                    expect(products.count).to(equal(json.arrayValue.count))
                                    done()
                                }
                            })
                        })
                    }
                }
            }
        }
    }
    
}
