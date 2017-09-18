//
//  TRLURLDataTaskDelegate.m
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

#import "TRLURLDataTaskDelegate.h"

#import "TRLURLSessionManager.h"
#import <TrolleyCore/TrolleyCore-Swift.h>

@implementation TRLURLDataTaskDelegate

- (NSURLSessionDataTask *)dataTask {
    return (NSURLSessionDataTask *)self.task;
}

- (NSMutableData *)data {
    if (_dataStream != nil) {
        return nil;
    } else {
        return mutableData;
    }
}

- (instancetype)initWithTask:(NSURLSessionTask *)task {
    if (self = [super initWithTask:task]) {
        self->mutableData = [NSMutableData data];
        self->_progress = [NSProgress progressWithTotalUnitCount:0];
        self.initialResponseTime = NSNotFound; // set to NSNotFound as can't set to nil
    }

    return self;
}

- (void)reset {
    [super reset];

    self.progress = [NSProgress progressWithTotalUnitCount:0];
    totalBytesReceived = 0;
    mutableData = [NSMutableData data];
    expectedContentLength = 0;
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSURLSessionResponseDisposition disposition = NSURLSessionResponseAllow;
    expectedContentLength = response.expectedContentLength;

    if (_dataTaskDidReceiveResponse) {
        disposition = _dataTaskDidReceiveResponse(session, dataTask, (NSHTTPURLResponse *)response);
    }

    completionHandler(disposition);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    _dataTaskDidBecomeDownloadTask(session, dataTask, downloadTask);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler
{
    NSCachedURLResponse * _Nullable cachedResponse = proposedResponse;
    if (_dataTaskWillCacheResponse) {
        cachedResponse = _dataTaskWillCacheResponse(session, dataTask, proposedResponse);
    }

    completionHandler(cachedResponse);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    if (self.initialResponseTime == NSNotFound) {
        self.initialResponseTime = CFAbsoluteTimeGetCurrent();
    }

    if (_dataTaskDidReceiveData) {
        _dataTaskDidReceiveData(session, dataTask, data);
    } else {
        if (_dataStream) {
            _dataStream(data);
        } else {
            [mutableData appendData:data];
        }

        int64_t bytesReceived = (int64_t) data.length;
        totalBytesReceived += bytesReceived;
        int64_t totalBytesExpected = dataTask.response ?
                                     dataTask.response.expectedContentLength :
                                     NSURLSessionTransferSizeUnknown;

        _progress.totalUnitCount = totalBytesExpected;
        _progress.completedUnitCount = totalBytesReceived;

        if (_progressHandler) {
            dispatch_async(_progressHandler.queue, ^{
                _progressHandler.closure(_progress);
            });
        }
    }
}

TRLURLDataRequest * request(NSString *url, HTTPMethod method, Parameters *_Nullable parameters, id<TRLURLParameterEncoding> encoding, HTTPHeaders *_Nullable headers) {
    return [[TRLURLSessionManager defaultManager] request:url
                                                   method:method
                                               parameters:parameters
                                                 encoding:encoding
                                                  headers:headers];
}

@end
