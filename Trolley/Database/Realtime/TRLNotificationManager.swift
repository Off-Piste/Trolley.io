//
//  TRLNotificationManager.swift
//  Pods
//
//  Created by Harry Wright on 19.06.17.
//
//

import Foundation
import PromiseKit
import SwiftyJSON

public typealias RequestType = (URLConvertible, HTTPMethod, Parameters?, URLEncoding, HTTPHeaders?)

func alamofireRequest(_ values: RequestType) -> DataRequest {
    return Alamofire
        .request(
            values.0,
            method: values.1,
            parameters: values.2,
            encoding: values.3,
            headers: values.4
    )
}

extension NotificationCenter {
    
    func addObserver(forName name: Notification.Name, queue: OperationQueue = .main, handler: @escaping (Notification) -> Void) {
        self.addObserver(forName: name, object: nil, queue: queue, using: handler)
    }
    
}

public struct TRLNotificationManager<T> {
    
    var notification: TRLNotification<T>
    
    var request: RequestType
    
    var internalNotification: TRLNotification<Any> {
        let type = Notification.Name("_productUpdated")
        return TRLNotification<Any>(type)
    }
    
    var firstCall: Bool = true
    
    init(_ notification: TRLNotification<T>, withRequest request: RequestType) {
        self.notification = notification
        self.request = request
        
        self.internalObserve()
    }
    
    public func observe(_ handler: @escaping (TRLNotificationResult<T>) -> Void) {
        self.notification.observe(handler)
    }
    
    private func internalObserve() {
        internalNotification.observe { (result) in
            
            // can be force unwrapped as this will
            // never fail
            self.handleObserve()
        }
    }
    
    // This is the logic for the response
    private func handleObserve() {
        let req = alamofireRequest(self.request).validate().response()
        self.handleResponse(req) { (products, err) in
            if let products = products {
                let res = ProductResponse(products)
                self.notification.post(res as! T)
            } else {
                self.notification.post(err!)
            }
        }
    }
    
    
    private func handleResponse(
        _ response: Promise<(URLRequest, HTTPURLResponse, Data)>,
        handler: @escaping ProductsHandler
        )
    {
        TRLNetworkResponse(promise: response, delegate: nil).products { (products, error) in
            if T.self is ProductResponse.Type {
                handler(products, error)
            } else {
                handler(nil, TRLNotificationErrors.invalidRequestType)
            }
        }
    }
}
