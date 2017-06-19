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
            expect(url.namespace).to(be("localhost"))
            expect(url.isLocal).to(be(false))
            expect(url.path).to(be("API/default/basket"))
            
            let url2 = TRLNetworkInfo(
                host: "localhost:8080", namespace: "localhost:8080", secure: false
            )
            let parsedURL = ParsedURL(networkInfo: url2)
            expect(parsedURL.query["ns"]).to(be("localhost:8080"))
        }
    }
    
    override func spec() {
        describe("Testing An Oversight") {
            let mainURL: ParsedURL = "http://localhost:8080/API"
            
            let newURL = mainURL.addingPath("default") // http://localhost:8080/API/default
            Log.debug(newURL)
            expect(newURL.requestUrl!.absoluteString).to(be("http://localhost:8080/API/default"))
            
            let newerURL = mainURL.addingPath("basket") // http://localhost:8080/API/basket
            Log.debug(newerURL)
            expect(newerURL.requestUrl!.absoluteString).to(be("http://localhost:8080/API/basket"))
        }

    }
    
}
