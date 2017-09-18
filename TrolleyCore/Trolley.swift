//
//  Trolley.swift
//  Trolley
//
//  Created by Harry Wright on 14.09.17.
//  Copyright © 2017 Off-Piste.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import TrolleyCore.Dynamic

@objc public final class Trolley: NSObject {

    @objc public static var shared: Trolley {
        return Trolley()
    }

    @objc public var options: TRLOptions!

    @objc public var networkManager: TRLNetworkManager!

    @objc public internal(set) var isLightweight: Bool = false

    @objc public var shopName: String {
        return options["io.trolley.shopName"]
    }

}

extension Trolley {
//    internal var ws: Websocket!
}

extension Trolley {

    @objc public func setLightweight(_ bool: Bool) {
        self.isLightweight = bool
    }

    @objc public func configure() {
        self.configure(with: .default)
    }

    @objc(configureWithOptions:)
    public func configure(with options: TRLOptions) {

        // 1. Validate Options or crash app
        self.options = options
        self.options.validateOrRaiseExcpetion()

        // 2. Create NetworkManager and Start Reachabilty
        self.networkManager = TRLNetworkManager(options: options)
        self.networkManager.reachability.start()

        // 3. Get DeviceID and Create the Websocket
        // start this after starting reachabilty so if the server
        // is down we can know sooner rather than on second/third retry
        // if good internet
        let deviceID = self.getDeviceIDOrRaiseException()
        // ws = Websocket(domain: self.networkManager.connectionURL.absoluteString, for: deviceID)
        // self.ws.connect()

        // 4. Send the TRLTrolleyStartingUp notification to app SDKs
        // this tells them to get ready as the shop is legit and running
        // and that they can use the NetworkManager and the WebSocket should 
        // be connected, is the App is a lightweight varient, then no notification
        // will be sent as the User is not wishing to use or SDK code and wants to
        // manually download our network calls to save space on an app
        //
        // For more info check: http://...
        self.sendSDKNotifications(!self.isLightweight, withDeviceID: deviceID)
    }

}

private extension Trolley {

    func getDeviceIDOrRaiseException() -> String {
        let DeviceID: String!
        let manager = TRLDefaultsManager(withKey: AppleDeviceUUIDKey)
        do {
            let obj = try manager.retrieveObject()
            if let strObj = obj as? String {
                DeviceID = strObj
            } else {
                DeviceID = ""
                TRLException(
                    "Invalid object for key: \(AppleDeviceUUIDKey), " +
                    "should be string but returned \(obj)", nil
                ).raise()
            }
        } catch {
            DeviceID = UUID().uuidString
        }
        return DeviceID
    }

    func sendSDKNotifications(_ bool: Bool, withDeviceID id: String) {
        if bool {
            let userInfo: [AnyHashable: Any] = ["DeviceID":id]
            NotificationCenter.default.post(
                name: .TRLTrolleyStartingUp,
                object: self,
                userInfo: userInfo
            )
        }
    }


}
