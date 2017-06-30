//
//  TRLTimer.swift
//  Pods
//
//  Created by Harry Wright on 28.06.17.
//
//

import Foundation

public typealias RepeatClosure = () -> Void
public typealias Result = TRLTimer.Result
public typealias RepeatClosureWithResult = () -> Result

public class TRLTimer {
    
    public enum Result {
        case stop
        case continuous
        case `repeat`(after: TimeInterval)
    }
    
    fileprivate struct SubscriberInfo {
        let block: RepeatClosureWithResult
        var timeInterval: TimeInterval
    }
    
    fileprivate var seconds: TimeInterval
    
    fileprivate var subscriberInfo: SubscriberInfo?
    
    fileprivate var queue: DispatchQueue {
        return DispatchQueue(
            label: "io.trolley.timer",
            qos: .utility,
            attributes: .concurrent
        )
    }
    
    /// +- 1 second due to being on the main thread
    ///
    /// - Parameter seconds: <#seconds description#>
    public init(for seconds: TimeInterval) {
        self.seconds = seconds
    }
    
    /// +- 1 second due to being on the main thread
    ///
    /// - Parameters:
    ///   - seconds: <#seconds description#>
    ///   - repeats: <#repeats description#>
    ///   - closure: <#closure description#>
    public init(for seconds: TimeInterval, repeats: Bool, closure: @escaping (TRLTimer) -> Void) {
        self.seconds = seconds
        if repeats { self.continuous { closure(self) } }
        else { self.once { closure(self) } }
    }
}

public extension TRLTimer {
    
    static func after(_ seconds: TimeInterval, closure: @escaping RepeatClosureWithResult) {
        let aRepeater = TRLTimer(for: seconds)
        aRepeater.dispatch(closure)
    }
    
    /// This is method is a mix between the both once and continuous.
    ///
    /// This specific `after(_:if:closure:)` is helpful when maybe 
    /// having a bool test before calling like so:
    ///
    ///     if !connected {
    ///         TRLTimer(for: 10).once {
    ///             self.attemptToRestablishConnection()
    ///         }
    ///     }
    ///
    /// which can become:
    ///
    ///     TRLTimer.after(10, if: !connected) {
    ///         self.attemptToRestablishConnection()
    ///         return .stop
    ///     }
    ///
    /// - Parameters:
    ///   - seconds: The time for the interval, will be +- 1 second of choosen
    ///   - bool: The Bool test
    ///   - closure: The Result you wish to use
    static func after(_ seconds: TimeInterval, if bool: @autoclosure () -> Bool, closure: @escaping RepeatClosureWithResult) {
        if !bool() { return }
        self.after(seconds, closure: closure)
    }
    
    func once(closure: @escaping RepeatClosure) {
        if self.subscriberInfo != nil {
            TRLCoreLogger.debug("Already set the repeater \(#function)")
            return
        }
        
        let block: RepeatClosureWithResult = {
            closure()
            return .stop
        }
        
        self.dispatch(block)
    }
    
    @discardableResult
    func continuous(closure: @escaping RepeatClosure) -> TRLTimer {
        if self.subscriberInfo != nil {
            TRLCoreLogger.debug("Already set the repeater \(#function)")
            return self
        }
        let block: RepeatClosureWithResult = {
            closure()
            return .continuous
        }
        
        self.dispatch(block)
        return self
    }
    
    func invalidate() {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if self.subscriberInfo == nil { return }
        self.subscriberInfo = nil
    }
    
}

public extension TRLTimer {
    
    var timeInterval: TimeInterval {
        return self.seconds
    }
    
    var isValid: Bool {
        return self.subscriberInfo != nil
    }
    
}

extension TRLTimer : CustomStringConvertible {
    
    public var description: String {
        return "<Repeater> { isValid: \(isValid) TimeInterval: \(timeInterval) }"
    }
    
}

private extension TRLTimer {
    
    func dispatch(_ closure: @escaping RepeatClosureWithResult) {
        assert(self.seconds > 0, "Expecting intervalSecs to be > 0, not \(self.seconds)")
        
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        self.subscriberInfo = SubscriberInfo(block: closure, timeInterval: self.seconds)
        self.dispatch(self.seconds)
        
    }
    
    func dispatch(_ timeInterval: TimeInterval) {
        assert(timeInterval > 0, "Expecting intervalSecs to be > 0, not \(timeInterval)")
        
        queue.asyncAfter(deadline: .now() + .seconds(Int(timeInterval))) {
            self.timerCallback()
        }
    }
    
    func timerCallback() {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        guard self.subscriberInfo != nil else { return }
        let result = self.subscriberInfo!.block()
        
        switch result {
        case .stop:
            self.subscriberInfo = nil
        case .continuous:
            // This will stop a crash if the code is set to nil before this is hit
            let timeInterval = self.subscriberInfo?.timeInterval ?? 0
            self.dispatch(timeInterval)
        case .repeat(let interval):
            assert(interval > 0, "Expecting interval to be > 0, not \(interval)")
            self.dispatch(interval)
        }
    }
}
