//
//  TRLBlocks.h
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

#import <Foundation/Foundation.h>

@class TChallenge;

NS_ASSUME_NONNULL_BEGIN

typedef NSURLRequest *_Nullable(^HTTPRedirection)(
    NSURLSession *session,
    NSURLSessionTask *task,
    NSHTTPURLResponse *response,
    NSURLRequest *request
);

typedef TChallenge *_Nonnull(^DidReceiveChallenge)(
    NSURLSession *session,
    NSURLSessionTask *task,
    NSURLAuthenticationChallenge *challenge
);

typedef NSInputStream *_Nullable(^NeedNewBodyStream)(
    NSURLSession *session,
    NSURLSessionTask *task
);

typedef void(^DidCompleteWithError)(
    NSURLSession *session,
    NSURLSessionTask *task,
    NSError *_Nullable error
);

typedef void(^DataStream)(
    NSData *data
);

typedef void(^ProgressHandler)(
    NSProgress *progress
);

typedef NSURLSessionResponseDisposition(^TaskDidReceiveResponse)(
    NSURLSession *session,
    NSURLSessionDataTask *task,
    NSHTTPURLResponse *response
);

typedef void(^TaskDidBecomeDownloadTask)(
    NSURLSession *session,
    NSURLSessionDataTask *dataTask,
    NSURLSessionDownloadTask *downloadTask
);

typedef void(^TaskDidReceiveData)(
    NSURLSession *session,
    NSURLSessionDataTask *dataTask,
    NSData *data
);

typedef NSCachedURLResponse *_Nullable(^TaskWillCacheResponse)(
    NSURLSession *session,
    NSURLSessionDataTask *task,
    NSCachedURLResponse *response
);

typedef void(^StreamBlock)(
    NSData *data
);

NS_ASSUME_NONNULL_END
