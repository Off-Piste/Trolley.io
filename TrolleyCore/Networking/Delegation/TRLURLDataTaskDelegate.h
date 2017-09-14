//
//  TRLURLDataTaskDelegate.h
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

@class TProgressHandler;

NS_ASSUME_NONNULL_BEGIN

@interface TRLURLDataTaskDelegate : TRLURLTaskDelegate <NSURLSessionDataDelegate> {
    int64_t totalBytesReceived;
    NSMutableData *mutableData;
    int64_t expectedContentLength;
}

@property (strong, nonatomic) NSProgress *progress;

@property (strong, nonatomic) TProgressHandler *_Nullable progressHandler;

@property (nonatomic) DataStream _Nullable dataStream;

@property (strong, nonatomic) NSURLSessionDataTask *dataTask;

@property (nullable, nonatomic) TaskDidReceiveResponse dataTaskDidReceiveResponse;

@property (nullable, nonatomic) TaskDidBecomeDownloadTask dataTaskDidBecomeDownloadTask;

@property (nullable, nonatomic) TaskDidReceiveData dataTaskDidReceiveData;

@property (nullable, nonatomic) TaskWillCacheResponse dataTaskWillCacheResponse;

@end

NS_ASSUME_NONNULL_END
