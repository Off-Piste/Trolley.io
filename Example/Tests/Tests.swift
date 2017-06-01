// https://github.com/Quick/Quick

import Quick
import Nimble
import Trolley
import PromiseKit
import SwiftyJSON

import Pods_Trolley_Tests

@testable import Pods_Trolley_Example
// TODO: Finish this

/// Required due to not being able to find `.plist` file
let kOptions = TRLOptions(merchantID: "default")

extension Parser {
    
    static func testParser(for r: String) throws -> [String : Any] {
        let bundle = Bundle.main
        guard let path = bundle.path(forResource: r, ofType: "plist") else {
            throw NSError(domain: "Cannot Find File", code: 0, userInfo: nil)
        }
        
        let plistParser = try PLISTParser(contentsOfURL: path)
        return plistParser.plist
    }
    
}

class TableOfContentsSpec: QuickSpec {
    
    override func spec() {
        describe("Products Download") {
            Trolley.shared.configure(options: kOptions)
            
            print(Bundle(for: Trolley.self))
            print(Bundle.main)
            
            Products.getAll().then { products -> Void in
                expect(products).toNot(beEmpty())
            }.catch { (error) in
                expect(error).toNot(beNil())
            }
        }
    }
}

class TrolleyTest: QuickSpec {
    
    override func spec() {
        describe("Finding the correct plist") {
            do {
                let xml = try Parser.testParser(for: "Trolley-Config")
                expect(xml).toNot(beEmpty())
            } catch {
                expect(error).to(beNil())
            }
        }
    }
    
}
