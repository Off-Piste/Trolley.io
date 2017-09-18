//
//  TRLURLDataRequest.m
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 09.09.17.
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

#import "TRLURLDataRequest.h"

#import <TrolleyCore/TrolleyCore-Swift.h>

#import "TRLURLDataTaskDelegate.h"

@implementation TRLURLDataRequest

+ (instancetype)requestForSession:(NSURLSession *)session requestTask:(TRLURLRequestTaskType *)requestTask error:(NSError *)error {
    return [[TRLURLDataRequest alloc] initWithSession:session requestTask:requestTask error:error];
}

- (instancetype)initWithSession:(NSURLSession *)session
                    requestTask:(TRLURLRequestTaskType *)requestTask
                          error:(NSError *)error {
    if (self = [super init]) {
        self.session = session;
        self->taskDelegateLock = [[NSLock alloc] init];
        self.retryCount = 0;
        self.validations = [[NSMutableArray alloc] init];

        if ([requestTask isKindOfClass:[TRLURLRequestTaskTypeData class]]) {
            self->taskDelegate = [[TRLURLDataTaskDelegate alloc]
                                  initWithTask:requestTask.sessionTask];
            self->originalTask = requestTask.originalTask;
        }

        self.delegate.error = error;
        [self.delegate.queue addOperationWithBlock:^{
            self->endTime = CFAbsoluteTimeGetCurrent();
        }];
    }

    return self;
}

- (NSMutableURLRequest *)request {
    if (super.request) {
        return super.request.mutableCopy;
    } else if ([(id)self->originalTask isKindOfClass:[TRLURLDataRequestHelper class]]) {
        return ((TRLURLDataRequestHelper *)self->originalTask).urlRequest.mutableCopy;
    }

    return nil;
}

- (NSProgress *)progress {
    return self.dataDelegate.progress;
}

- (TRLURLDataTaskDelegate *)dataDelegate {
    return (TRLURLDataTaskDelegate *)self.delegate;
}

- (instancetype)stream {
    return [self streamWithBlock:^(NSData *data) { }];
}

- (instancetype)streamWithBlock:(StreamBlock)block {
    self.dataDelegate.dataStream = block;
    return self;
}

- (instancetype)downloadProgressWithBlock:(ProgressHandler)block {
    return [self downloadProgressWithQueue:dispatch_get_main_queue() block:block];
}

- (instancetype)downloadProgressWithQueue:(dispatch_queue_t)queue block:(ProgressHandler)block {
    self.dataDelegate.progressHandler = [[TProgressHandler alloc] initWithQueue:queue
                                                                        closure:block];

    return self;
}

@end
