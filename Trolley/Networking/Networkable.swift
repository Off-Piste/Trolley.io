//
//  Networkable.swift
//  Network
//
//  Created by Harry Wright on 19.06.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

import Foundation

public typealias DefaultHandler = (Data?, Error?) -> Void

public protocol Networkable {
    
    func responseData(handler: @escaping DefaultHandler)
    
}
