//
//  TRLRequestObjc.swift
//  Pods
//
//  Created by Harry Wright on 30.06.17.
//
//

import Foundation
import PromiseKit

#if _runtime(_ObjC)
public extension TRLRequest {
    
    /// @objc version of `responseData() -> Promise<Data>`
    ///
    /// - Returns: Returns Any Promise
    @objc func responseDataPromise() -> AnyPromise {
        return AnyPromise(responseData())
    }
    
}
#endif
