//
//  TRLURLTaskDelegate.h
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

#import <Foundation/Foundation.h>

#import "TRLBlocks.h"
#import "TNTUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRLURLTaskDelegate : NSObject  {
    NSLock *_taskLock;
}

- (instancetype)initWithTask:(NSURLSessionTask *_Nullable)task;

@property (strong) NSOperationQueue *queue;

@property (nullable, nonatomic) NSURLSessionTask *task;

@property (nullable, nonatomic) NSURLSessionTask * _task;

@property (assign, nonatomic) CFAbsoluteTime initialResponseTime;

@property (strong, nonatomic) NSURLCredential *credential;

@property (strong, nonatomic) id metrics;

@property (nullable, copy) NSMutableData *data;

@property (nullable, nonatomic) NSError *error;

@property (nullable, nonatomic) HTTPRedirection taskWillPerformHTTPRedirection;

@property (nullable, nonatomic) DidReceiveChallenge taskDidReceiveChallenge;

@property (nullable, nonatomic) NeedNewBodyStream taskNeedNewBodyStream;

@property (nullable, nonatomic) DidCompleteWithError taskDidCompleteWithError;

- (void)reset;

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler;

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler;

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *_Nullable)error;

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * _Nullable))completionHandler;

@end

NS_ASSUME_NONNULL_END
