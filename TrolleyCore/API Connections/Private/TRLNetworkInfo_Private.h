//
//  TRLNetworkInfo_Private.h
//  RequestBuilder
//
//  Created by Harry Wright on 30.08.17.
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

#import "TRLNetworkInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Method to check if two TRLNetworkInfo's are equal

 @param lhs A value to compare.
 @param rhs Another value to compare.
 @return Boolean value indicating whether two values are equal.
 */
static BOOL TRLNetworkInfoAreEqual(TRLNetworkInfo *lhs, TRLNetworkInfo *rhs);

// JSON data for obj, or nil if an internal error occurs. The resulting data is encoded in UTF-8.

/**
 Method to create a TRLNetworkInfo from a NSString and pass back an error

 @param url NSString of the URL you wish to use
 @param error If an internal error occurs, upon return contains an NSError
 @return TRLNetworkInfo for the URL, or nil if an internal error occurs.
 */
static TRLNetworkInfo *_Nullable infoForURL(NSString *url, NSError *__autoreleasing *error);

@interface TRLNetworkInfo ()

/**
 Internal Init to create TRLNetworkInfo for the API Network

 @param host The URL's Host
 @param namespace The URL's Namespace
 @param isSecure Bool for is the URL is secure or now
 @param url The URL for the API network
 @return A TRLNetworkInfo
 */
- (instancetype)initWithHost:(NSString *)host
                   namespace:(NSString *)namespace
                      secure:(BOOL)isSecure
                         url:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
