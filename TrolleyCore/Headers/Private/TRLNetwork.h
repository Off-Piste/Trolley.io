/////////////////////////////////////////////////////////////////////////////////
//
//  TRLNetwork.h
//  TrolleyCore
//
//  Created by Harry Wright on 23.08.17.
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

#import "TRLNetworkingConstants.h"

NS_ASSUME_NONNULL_BEGIN

@class ParsedURL;
@class TRLNetworkInfo;
@protocol TRLURLParameterEncoding;
@class TRLRequest;

@interface TRLNetwork : NSObject

@property(strong, readonly, nonnull) ParsedURL* _url;

/**
 @brief The base NSURL for all Trolley network calls.
 */
@property(strong, readonly, nullable) NSURL* url;

/**
 @brief The base NSURL for the trolley websocket.
 */
@property(strong, readonly, nullable) NSURL* connectionURL;


- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithParsedURL:(ParsedURL *)url NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithNetworkInfo:(TRLNetworkInfo *)info;

- (nullable instancetype)initWithURL:(NSString *)url error:(NSError *__autoreleasing *)error;

- (TRLRequest *)get:(NSString *)route
           encoding:(id<TRLURLParameterEncoding>)encoding;

- (TRLRequest *)get:(NSString *)route
               with:(Parameters *_Nullable)parameters
           encoding:(id<TRLURLParameterEncoding>)encoding
            headers:(HTTPHeaders *_Nullable)headers;

@end

NS_ASSUME_NONNULL_END
