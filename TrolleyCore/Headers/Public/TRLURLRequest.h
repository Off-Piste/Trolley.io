/////////////////////////////////////////////////////////////////////////////////
//
//  TRLURLRequest.h
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
#import "TRLURLParameterEncoding.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Request)
@interface TRLURLRequest : NSObject {
    NSURLRequest *_originalRequest;
    NSError *_error;
}

@property (weak, nullable, readonly) NSURLRequest *request;

@property (weak, nullable, readonly) NSError *error;

@property (readonly) dispatch_queue_t queue;

@property (weak, readonly) NSURLSession *session;

- (instancetype)init NS_UNAVAILABLE;

/**
 <#Description#>

 @param url <#url description#>
 @return <#return value description#>
 */
+ (TRLURLRequest *)request:(NSString *)url;

/**
 <#Description#>

 @param url <#url description#>
 @param method <#method description#>
 @return <#return value description#>
 */
+ (TRLURLRequest *)request:(NSString *)url
                    method:(NSString *)method;

/**
 <#Description#>

 @param url <#url description#>
 @param parameters <#parameters description#>
 @return <#return value description#>
 */
+ (TRLURLRequest *)request:(NSString *)url
                parameters:(Parameters *_Nullable)parameters;

/**
 <#Description#>

 @param url <#url description#>
 @param method <#method description#>
 @param parameters <#parameters description#>
 @return <#return value description#>
 */
+ (TRLURLRequest *)request:(NSString *)url
                    method:(HTTPMethod *)method
                parameters:(Parameters *_Nullable)parameters;

/**
 <#Description#>

 @param url <#url description#>
 @param method <#method description#>
 @param parameters <#parameters description#>
 @param encoding <#encoding description#>
 @return <#return value description#>
 */
+ (TRLURLRequest *)request:(NSString *)url
                    method:(HTTPMethod *)method
                parameters:(Parameters *_Nullable)parameters
                  encoding:(id <TRLURLParameterEncoding>)encoding;

/**
 <#Description#>

 @param url <#url description#>
 @param method <#method description#>
 @param parameters <#parameters description#>
 @param encoding <#encoding description#>
 @param headers <#headers description#>
 @return <#return value description#>
 */
+ (TRLURLRequest *)request:(NSString *)url
                    method:(HTTPMethod *)method
                parameters:(Parameters *_Nullable)parameters
                  encoding:(id <TRLURLParameterEncoding>)encoding
                    header:(HTTPHeaders *_Nullable)headers;

@end

NS_ASSUME_NONNULL_END
