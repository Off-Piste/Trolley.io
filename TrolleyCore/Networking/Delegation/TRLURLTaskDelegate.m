//
//  TRLURLTaskDelegate.m
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 08.09.17.
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

#import "TRLURLTaskDelegate.h"
#import "TRLURLTaskDelegate_Dynamic.h"

#import <TrolleyCore/TrolleyCore-Swift.h>

@implementation TRLURLTaskDelegate

- (NSURLSessionTask *)task {
    [_taskLock lock]; trl_defer { [_taskLock unlock]; };
    return __task;
}

- (void)setTask:(NSURLSessionTask *)task {
    [_taskLock lock]; trl_defer { [_taskLock unlock]; };

    __task = task;
    [self reset];
}

- (instancetype)initWithTask:(NSURLSessionTask *)task {
    if (self = [super init]) {
        __task = task;
        _taskLock = [[NSLock alloc] init];

        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 1;
        [queue setSuspended:YES];
        queue.qualityOfService = NSQualityOfServiceUtility;
        self.queue = queue;
    }
    return self;
}

- (void)reset {
    self.error = NULL;
    self.initialResponseTime = 0;
}

#pragma mark - URLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    TChallenge *_challengeTouple = [[TChallenge alloc] init];

    if (_taskDidReceiveChallenge) {
        _challengeTouple = _taskDidReceiveChallenge(session, task, challenge);
    } else if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        // TODO: Add this
    } else {
        if (challenge.previousFailureCount > 0) {
            _challengeTouple.disposition = NSURLSessionAuthChallengeRejectProtectionSpace;
        } else {
            _challengeTouple.credential = self->_credential ?
                                          self->_credential :
                                          [session.configuration.URLCredentialStorage
                                           defaultCredentialForProtectionSpace:challenge.protectionSpace];

            if (_challengeTouple.credential) {
                _challengeTouple.disposition = NSURLSessionAuthChallengeUseCredential;
            }
        }
    }

    completionHandler(_challengeTouple.disposition, _challengeTouple.credential);
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler
{
    NSURLRequest *_Nullable redirectRequest = request;

    if (_taskWillPerformHTTPRedirection) {
        _taskWillPerformHTTPRedirection(session, task, response, request);
    }

    completionHandler(redirectRequest);
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if (_taskDidCompleteWithError) {
        _taskDidCompleteWithError(session, task, error);
    } else {
        if (error && !self.error) {
            self.error = error;
        }

        _queue.suspended = NO;
    }

}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * _Nullable))completionHandler
{
    NSInputStream *bodyStream;
    if (_taskNeedNewBodyStream) {
        bodyStream = _taskNeedNewBodyStream(session, task);
    }

    completionHandler(bodyStream);
}

void TRLURLTaskDelegateSetCredential(TRLURLTaskDelegate *delegate, NSURLCredential *credential) {
    delegate->_credential = credential;
}

@end
