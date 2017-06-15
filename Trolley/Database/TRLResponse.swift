//
//  Networking.swift
//  Pods
//
//  Created by Harry Wright on 13.04.17.
//
//

import Foundation
import PromiseKit
import SwiftyJSON
import Alamofire

public struct TRLResponse: Networkable {
    
    internal fileprivate(set) var promise: Promise<(URLRequest, HTTPURLResponse, Data)>
    
    // TODO: Look to see if can be implemented
    internal var delegate: NetworkableDelegate? = nil
    
    fileprivate let queue = DispatchQueue(
        label: "io.trolley",
        qos: .userInitiated,
        attributes: .concurrent
    )
    
    public func response() -> Promise<Any> {
        return Promise { fullfil, reject in
            self.promise.then(on: queue) { (req, res, data) in
                fullfil(data)
            }.catch(on: queue) { (error) in
                reject(error)
            }
        }
    }
    
    public func response(handler: @escaping DefaultHandler) {
        self.response().then(on: queue) { (Item) in
            handler(Item, nil)
        }.catch(on: queue) { (error) in
            handler(nil, error)
        }
    }
    
}
