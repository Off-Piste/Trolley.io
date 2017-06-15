// https://github.com/Quick/Quick

import Quick
import Nimble
@testable import Trolley

import Pods_Trolley_Tests

@testable import Pods_Trolley_Example

class CoreTest: QuickSpec {
    
    override func spec() {
        describe("Percentage Testing") {

        }
    }
}

class NetworkingTest : QuickSpec {
    
    func testTRLUtitlites() {
        describe("URL Parsing") {
            let url1String = "http://localhost:8080/API/default/basket"
            let url = TRLUtilities.singleton.parseURL(url1String)
            expect(url.networkInfo.namespace).to(be("localhost:8080"))
            expect(url.networkInfo.isLocal).to(be(false))
            expect(url.networkInfo.path).to(be("API/default/basket"))
            
            let url2 = TRLNetworkInfo(
                host: "localhost:8080", namespace: "localhost:8080", secure: false
            )
            let parsedURL = ParsedURL(networkInfo: url2)
            expect(parsedURL.query["ns"]).to(be("localhost:8080"))
        }
    }
    
}
