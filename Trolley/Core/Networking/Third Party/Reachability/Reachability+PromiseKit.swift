//
//  Reachability+PromiseKit.swift
//  Pods
//
//  Created by Harry Wright on 26.06.17.
//
//

import Foundation
import PromiseKit

// MARK: - Reachability + Promise Kit
extension Reachability {
    
    func promise() -> Promise<Reachability> {
        return Promise { fullfill, reject in
            try self.startNotifier()
            
            self.whenReachable = {
                fullfill($0)
            }
            
            self.whenUnreachable = {
                fullfill($0)
            }
        }
    }
    
}
