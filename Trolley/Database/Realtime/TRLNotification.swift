//
//  TRLNotification.swift
//  Pods
//
//  Created by Harry Wright on 19.06.17.
//
//

import Foundation

precedencegroup BooleanPrecedence { associativity: left }

infix operator ^^ : BooleanPrecedence

func ^^(lhs: Bool, rhs: Bool) -> Bool {
    return lhs != rhs
}

public class TRLNotification<T> {
    
    public typealias NotificationHandler = (TRLNotificationResult<T>) -> Void
    
    public var name: String
    
    fileprivate var block: NotificationHandler?
    
    fileprivate var notificationName: Notification.Name {
        return Notification.Name(rawValue: name)
    }
    
    fileprivate var notificationCenter: NotificationCenter {
        return NotificationCenter.default
    }
    
    public init(_ name: String) {
        self.name = name
    }
    
    public init(_ notification: Notification) {
        self.name = notification.name.rawValue
    }
    
    public init(_ notification: Notification.Name) {
        self.name = notification.rawValue
    }
    
    public init(_ notification: TRLNotificationTypes) {
        self.name = notification.notificationName.rawValue
    }
    
    deinit {
        self._unSubscribe()
    }
    
    public func observe(_ handler: @escaping NotificationHandler) {
        if isSubscribed { Log.info("\(self) is already subscribed"); return }
        block = handler
        _subscribe()
    }
    
    func post(_ object: T) {
        self._post((object, nil))
    }
    
    func post(_ error: Error) {
        self._post((nil, error))
    }
    
    func handle(_ handler: (T?, Error?)) {
        self._post(handler)
    }
    
    // Has to be in the main part of the class due to `@objc`
    @objc fileprivate func _handler(_ notification: Notification) {
        if let value = notification.object as? (T?, Error?) {
            let result: TRLNotificationResult<T>
            result = TRLNotificationResult(value)
            block?(result)
        } else {
            // Should
            fatalError("Invalid Notification Observer")
        }
    }
}

public extension TRLNotification {
    
    var isSubscribed: Bool {
        return self.block != nil
    }
    
}

private extension TRLNotification {
    
    func _subscribe() {
        notificationCenter.addObserver(
            self,
            selector: #selector(_handler(_:)),
            name: notificationName,
            object: nil
        )
    }
    
    func _unSubscribe() {
        self.block = nil
        self.notificationCenter.removeObserver(self)
    }
    
    func _post(_ object: (T?, Error?)) {
        _check(object)
        self.notificationCenter.post(name: notificationName, object: object)
    }
    
    func _check(_ object: (T?, Error?)) {
        let boolTest = (object.0 != nil) ^^ (object.1 != nil)
        assert(boolTest, "The object [\(object)] should not be (nil, nil)")
    }
    
}

extension TRLNotification : CustomStringConvertible {
    public var description: String {
        return "TRLNotification { name: \(self.notificationName) center: \(self.notificationCenter) }"
    }
}
