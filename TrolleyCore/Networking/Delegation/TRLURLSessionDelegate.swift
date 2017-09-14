//
//  TRLURLSessionDelegate.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

/// Responsible for handling all delegate callbacks for the underlying session.
open class TRLURLSessionDelegate: NSObject {

    // MARK: URLSessionDelegate Overrides

    /// Overrides default behavior for URLSessionDelegate method `urlSession(_:didBecomeInvalidWithError:)`.
    open var sessionDidBecomeInvalidWithError: ((URLSession, Error?) -> Void)?

    /// Overrides default behavior for URLSessionDelegate method `urlSession(_:didReceive:completionHandler:)`.
    open var sessionDidReceiveChallenge: ((URLSession, URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?))?

    /// Overrides all behavior for URLSessionDelegate method `urlSession(_:didReceive:completionHandler:)` and requires the caller to call the `completionHandler`.
    open var sessionDidReceiveChallengeWithCompletion: ((URLSession, URLAuthenticationChallenge, @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?

    /// Overrides default behavior for URLSessionDelegate method `urlSessionDidFinishEvents(forBackgroundURLSession:)`.
    open var sessionDidFinishEventsForBackgroundURLSession: ((URLSession) -> Void)?

    // MARK: URLSessionTaskDelegate Overrides

    /// Overrides default behavior for URLSessionTaskDelegate method `urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:)`.
    open var taskWillPerformHTTPRedirection: ((URLSession, URLSessionTask, HTTPURLResponse, URLRequest) -> URLRequest?)?

    /// Overrides all behavior for URLSessionTaskDelegate method `urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:)` and
    /// requires the caller to call the `completionHandler`.
    open var taskWillPerformHTTPRedirectionWithCompletion: ((URLSession, URLSessionTask, HTTPURLResponse, URLRequest, @escaping (URLRequest?) -> Void) -> Void)?

    /// Overrides default behavior for URLSessionTaskDelegate method `urlSession(_:task:didReceive:completionHandler:)`.
    open var taskDidReceiveChallenge: ((URLSession, URLSessionTask, URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?))?

    /// Overrides all behavior for URLSessionTaskDelegate method `urlSession(_:task:didReceive:completionHandler:)` and
    /// requires the caller to call the `completionHandler`.
    open var taskDidReceiveChallengeWithCompletion: ((URLSession, URLSessionTask, URLAuthenticationChallenge, @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?

    /// Overrides default behavior for URLSessionTaskDelegate method `urlSession(_:task:needNewBodyStream:)`.
    open var taskNeedNewBodyStream: ((URLSession, URLSessionTask) -> InputStream?)?

    /// Overrides all behavior for URLSessionTaskDelegate method `urlSession(_:task:needNewBodyStream:)` and
    /// requires the caller to call the `completionHandler`.
    open var taskNeedNewBodyStreamWithCompletion: ((URLSession, URLSessionTask, @escaping (InputStream?) -> Void) -> Void)?

    /// Overrides default behavior for URLSessionTaskDelegate method `urlSession(_:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)`.
    open var taskDidSendBodyData: ((URLSession, URLSessionTask, Int64, Int64, Int64) -> Void)?

    /// Overrides default behavior for URLSessionTaskDelegate method `urlSession(_:task:didCompleteWithError:)`.
    open var taskDidComplete: ((URLSession, URLSessionTask, Error?) -> Void)?

    // MARK: URLSessionDataDelegate Overrides

    /// Overrides default behavior for URLSessionDataDelegate method `urlSession(_:dataTask:didReceive:completionHandler:)`.
    open var dataTaskDidReceiveResponse: ((URLSession, URLSessionDataTask, URLResponse) -> URLSession.ResponseDisposition)?

    /// Overrides all behavior for URLSessionDataDelegate method `urlSession(_:dataTask:didReceive:completionHandler:)` and
    /// requires caller to call the `completionHandler`.
    open var dataTaskDidReceiveResponseWithCompletion: ((URLSession, URLSessionDataTask, URLResponse, @escaping (URLSession.ResponseDisposition) -> Void) -> Void)?

    /// Overrides default behavior for URLSessionDataDelegate method `urlSession(_:dataTask:didBecome:)`.
    open var dataTaskDidBecomeDownloadTask: ((URLSession, URLSessionDataTask, URLSessionDownloadTask) -> Void)?

    /// Overrides default behavior for URLSessionDataDelegate method `urlSession(_:dataTask:didReceive:)`.
    open var dataTaskDidReceiveData: ((URLSession, URLSessionDataTask, Data) -> Void)?

    /// Overrides default behavior for URLSessionDataDelegate method `urlSession(_:dataTask:willCacheResponse:completionHandler:)`.
    open var dataTaskWillCacheResponse: ((URLSession, URLSessionDataTask, CachedURLResponse) -> CachedURLResponse?)?

    /// Overrides all behavior for URLSessionDataDelegate method `urlSession(_:dataTask:willCacheResponse:completionHandler:)` and
    /// requires caller to call the `completionHandler`.
    open var dataTaskWillCacheResponseWithCompletion: ((URLSession, URLSessionDataTask, CachedURLResponse, @escaping (CachedURLResponse?) -> Void) -> Void)?


    // MARK: Properties

//    var retrier: RequestRetrier?
    public weak var sessionManager: TRLURLSessionManager?

    private var requests: [Int: TRLURLRequest] = [:]
    private let lock = NSLock()

    /// Access the task delegate for the specified task in a thread-safe manner.
    open subscript(task: URLSessionTask) -> TRLURLRequest? {
        get {
            lock.lock() ; defer { lock.unlock() }
            return requests[task.taskIdentifier]
        }
        set {
            lock.lock() ; defer { lock.unlock() }
            requests[task.taskIdentifier] = newValue
        }
    }

    // MARK: Lifecycle

    /// Initializes the `TRLURLSessionDelegate` instance.
    ///
    /// - returns: The new `TRLURLSessionDelegate` instance.
    public override init() {
        super.init()
    }

    // MARK: NSObject Overrides

    /// Returns a `Bool` indicating whether the `TRLURLSessionDelegate` implements or inherits a method that can respond
    /// to a specified message.
    ///
    /// - parameter selector: A selector that identifies a message.
    ///
    /// - returns: `true` if the receiver implements or inherits a method that can respond to selector, otherwise `false`.
    open override func responds(to selector: Selector) -> Bool {
        #if !os(macOS)
            if selector == #selector(URLSessionDelegate.urlSessionDidFinishEvents(forBackgroundURLSession:)) {
                return sessionDidFinishEventsForBackgroundURLSession != nil
            }
        #endif

        switch selector {
        case #selector(URLSessionDelegate.urlSession(_:didBecomeInvalidWithError:)):
            return sessionDidBecomeInvalidWithError != nil
        case #selector(URLSessionDelegate.urlSession(_:didReceive:completionHandler:)):
            return (sessionDidReceiveChallenge != nil  || sessionDidReceiveChallengeWithCompletion != nil)
        case #selector(URLSessionTaskDelegate.urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:)):
            return (taskWillPerformHTTPRedirection != nil || taskWillPerformHTTPRedirectionWithCompletion != nil)
        case #selector(URLSessionDataDelegate.urlSession(_:dataTask:didReceive:completionHandler:)):
            return (dataTaskDidReceiveResponse != nil || dataTaskDidReceiveResponseWithCompletion != nil)
        default:
            return type(of: self).instancesRespond(to: selector)
        }
    }
}

// MARK: - URLSessionDelegate

extension TRLURLSessionDelegate: URLSessionDelegate {
    /// Tells the delegate that the session has been invalidated.
    ///
    /// - parameter session: The session object that was invalidated.
    /// - parameter error:   The error that caused invalidation, or nil if the invalidation was explicit.
    open func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        sessionDidBecomeInvalidWithError?(session, error)
    }

    /// Requests credentials from the delegate in response to a session-level authentication request from the
    /// remote server.
    ///
    /// - parameter session:           The session containing the task that requested authentication.
    /// - parameter challenge:         An object that contains the request for authentication.
    /// - parameter completionHandler: A handler that your delegate method must call providing the disposition
    ///                                and credential.
    open func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        guard sessionDidReceiveChallengeWithCompletion == nil else {
            sessionDidReceiveChallengeWithCompletion?(session, challenge, completionHandler)
            return
        }

        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential?

        if let sessionDidReceiveChallenge = sessionDidReceiveChallenge {
            (disposition, credential) = sessionDidReceiveChallenge(session, challenge)
        }

        completionHandler(disposition, credential)
    }

#if !os(macOS)

    /// Tells the delegate that all messages enqueued for a session have been delivered.
    ///
    /// - parameter session: The session that no longer has any outstanding requests.
    open func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        sessionDidFinishEventsForBackgroundURLSession?(session)
    }

#endif
}

// MARK: - URLSessionTaskDelegate

extension TRLURLSessionDelegate: URLSessionTaskDelegate {
    /// Tells the delegate that the remote server requested an HTTP redirect.
    ///
    /// - parameter session:           The session containing the task whose request resulted in a redirect.
    /// - parameter task:              The task whose request resulted in a redirect.
    /// - parameter response:          An object containing the server’s response to the original request.
    /// - parameter request:           A URL request object filled out with the new location.
    /// - parameter completionHandler: A closure that your handler should call with either the value of the request
    ///                                parameter, a modified URL request object, or NULL to refuse the redirect and
    ///                                return the body of the redirect response.
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void)
    {
        guard taskWillPerformHTTPRedirectionWithCompletion == nil else {
            taskWillPerformHTTPRedirectionWithCompletion?(session, task, response, request, completionHandler)
            return
        }

        var redirectRequest: URLRequest? = request

        if let taskWillPerformHTTPRedirection = taskWillPerformHTTPRedirection {
            redirectRequest = taskWillPerformHTTPRedirection(session, task, response, request)
        }

        completionHandler(redirectRequest)
    }

    /// Requests credentials from the delegate in response to an authentication request from the remote server.
    ///
    /// - parameter session:           The session containing the task whose request requires authentication.
    /// - parameter task:              The task whose request requires authentication.
    /// - parameter challenge:         An object that contains the request for authentication.
    /// - parameter completionHandler: A handler that your delegate method must call providing the disposition
    ///                                and credential.
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        guard taskDidReceiveChallengeWithCompletion == nil else {
            taskDidReceiveChallengeWithCompletion?(session, task, challenge, completionHandler)
            return
        }

        if let taskDidReceiveChallenge = taskDidReceiveChallenge {
            let result = taskDidReceiveChallenge(session, task, challenge)
            completionHandler(result.0, result.1)
        } else if let delegate = self[task]?.delegate {
            delegate.urlSession(
                session,
                task: task,
                didReceive: challenge,
                completionHandler: completionHandler
            )
        } else {
            urlSession(session, didReceive: challenge, completionHandler: completionHandler)
        }
    }

    /// Tells the delegate when a task requires a new request body stream to send to the remote server.
    ///
    /// - parameter session:           The session containing the task that needs a new body stream.
    /// - parameter task:              The task that needs a new body stream.
    /// - parameter completionHandler: A completion handler that your delegate method should call with the new body stream.
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        needNewBodyStream completionHandler: @escaping (InputStream?) -> Void)
    {
        guard taskNeedNewBodyStreamWithCompletion == nil else {
            taskNeedNewBodyStreamWithCompletion?(session, task, completionHandler)
            return
        }

        if let taskNeedNewBodyStream = taskNeedNewBodyStream {
            completionHandler(taskNeedNewBodyStream(session, task))
        } else if let delegate = self[task]?.delegate {
            delegate.urlSession(session, task: task, needNewBodyStream: completionHandler)
        }
    }

    /// Periodically informs the delegate of the progress of sending body content to the server.
    ///
    /// - parameter session:                  The session containing the data task.
    /// - parameter task:                     The data task.
    /// - parameter bytesSent:                The number of bytes sent since the last time this delegate method was called.
    /// - parameter totalBytesSent:           The total number of bytes sent so far.
    /// - parameter totalBytesExpectedToSend: The expected length of the body data.
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64)
    {
        if let taskDidSendBodyData = taskDidSendBodyData {
            taskDidSendBodyData(session, task, bytesSent, totalBytesSent, totalBytesExpectedToSend)
        }
    }

#if !os(watchOS)

    /// Tells the delegate that the session finished collecting metrics for the task.
    ///
    /// - parameter session: The session collecting the metrics.
    /// - parameter task:    The task whose metrics have been collected.
    /// - parameter metrics: The collected metrics.
    @available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
    @objc(URLSession:task:didFinishCollectingMetrics:)
    open func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
//        self[task]?.delegate.metrics = metrics
    }

#endif

    /// Tells the delegate that the task finished transferring data.
    ///
    /// - parameter session: The session containing the task whose request finished transferring data.
    /// - parameter task:    The task whose request finished transferring data.
    /// - parameter error:   If an error occurred, an error object indicating how the transfer failed, otherwise nil.
    open func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        /// Executed after it is determined that the request is not going to be retried
        let completeTask: (URLSession, URLSessionTask, Error?) -> Void = { [weak self] session, task, error in
            guard let strongSelf = self else { return }

            strongSelf.taskDidComplete?(session, task, error)
            strongSelf[task]?.delegate.urlSession(session, task: task, didCompleteWithError: error)
            strongSelf[task] = nil
        }

        guard let request = self[task], let _ = sessionManager else {
            completeTask(session, task, error)
            return
        }

        // Run all validations on the request before checking if an error occurred
        (request.validations as! [TValidationsIndex]).forEach { $0.validation() }

        // Determine whether an error has occurred
        var error: Error? = error

        if request.delegate.error != nil {
            error = request.delegate.error
        }

        completeTask(session, task, error)
    }
}

// MARK: - URLSessionDataDelegate

extension TRLURLSessionDelegate: URLSessionDataDelegate {
    /// Tells the delegate that the data task received the initial reply (headers) from the server.
    ///
    /// - parameter session:           The session containing the data task that received an initial reply.
    /// - parameter dataTask:          The data task that received an initial reply.
    /// - parameter response:          A URL response object populated with headers.
    /// - parameter completionHandler: A completion handler that your code calls to continue the transfer, passing a
    ///                                constant to indicate whether the transfer should continue as a data task or
    ///                                should become a download task.
    open func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        guard dataTaskDidReceiveResponseWithCompletion == nil else {
            dataTaskDidReceiveResponseWithCompletion?(session, dataTask, response, completionHandler)
            return
        }

        var disposition: URLSession.ResponseDisposition = .allow

        if let dataTaskDidReceiveResponse = dataTaskDidReceiveResponse {
            disposition = dataTaskDidReceiveResponse(session, dataTask, response)
        }

        completionHandler(disposition)
    }

    /// Tells the delegate that the data task was changed to a download task.
    ///
    /// - parameter session:      The session containing the task that was replaced by a download task.
    /// - parameter dataTask:     The data task that was replaced by a download task.
    /// - parameter downloadTask: The new download task that replaced the data task.
    open func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didBecome downloadTask: URLSessionDownloadTask)
    {
        if let dataTaskDidBecomeDownloadTask = dataTaskDidBecomeDownloadTask {
            dataTaskDidBecomeDownloadTask(session, dataTask, downloadTask)
        } 
    }

    /// Tells the delegate that the data task has received some of the expected data.
    ///
    /// - parameter session:  The session containing the data task that provided data.
    /// - parameter dataTask: The data task that provided data.
    /// - parameter data:     A data object containing the transferred data.
    open func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let dataTaskDidReceiveData = dataTaskDidReceiveData {
            dataTaskDidReceiveData(session, dataTask, data)
        } else if let delegate = self[dataTask]?.delegate as? TRLURLDataTaskDelegate {
            delegate.urlSession(session, dataTask: dataTask, didReceive: data)
        }
    }

    /// Asks the delegate whether the data (or upload) task should store the response in the cache.
    ///
    /// - parameter session:           The session containing the data (or upload) task.
    /// - parameter dataTask:          The data (or upload) task.
    /// - parameter proposedResponse:  The default caching behavior. This behavior is determined based on the current
    ///                                caching policy and the values of certain received headers, such as the Pragma
    ///                                and Cache-Control headers.
    /// - parameter completionHandler: A block that your handler must call, providing either the original proposed
    ///                                response, a modified version of that response, or NULL to prevent caching the
    ///                                response. If your delegate implements this method, it must call this completion
    ///                                handler; otherwise, your app leaks memory.
    open func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        willCacheResponse proposedResponse: CachedURLResponse,
        completionHandler: @escaping (CachedURLResponse?) -> Void)
    {
        guard dataTaskWillCacheResponseWithCompletion == nil else {
            dataTaskWillCacheResponseWithCompletion?(session, dataTask, proposedResponse, completionHandler)
            return
        }

        if let dataTaskWillCacheResponse = dataTaskWillCacheResponse {
            completionHandler(dataTaskWillCacheResponse(session, dataTask, proposedResponse))
        } else if let delegate = self[dataTask]?.delegate as? TRLURLDataTaskDelegate {
            delegate.urlSession(
                session,
                dataTask: dataTask,
                willCacheResponse: proposedResponse,
                completionHandler: completionHandler
            )
        } else {
            completionHandler(proposedResponse)
        }
    }
}
