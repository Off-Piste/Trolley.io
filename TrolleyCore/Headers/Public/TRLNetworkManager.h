/////////////////////////////////////////////////////////////////////////////////
//
//  TRLNetworkManager.h
//  TrolleyCore
//
//  Created by Harry Wright on 25.08.17.
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

@class TRLRequest;

/**
 The public point for all networking calls to our server.
 
 This is the only way for code to interact with the API of
 a shop and should be the point where all calls are made.
 
 @note Will require Swift 3.1 or higher to run as the access point
       will be created in the Trolley class
 */
@interface TRLNetworkManager : NSObject

@property (class, readonly) TRLNetworkManager* shared;

- (instancetype)init NS_UNAVAILABLE;

/** This method creates a new TRLRequest for our calls to the server.
 
 This method is the base for all our API calls. By default, if parameters
 and headers and passed with nil they are initalised as empty dictionaries
 in the case anything is needed to be added internally, i.e. default HTTP Headers

 @code
 [network get:@"products"
         with:NULL
     encoding:[TRLURLEncoding defaultEncoding]
      headers:NULL];
 @endcode
 
 @warning This should never be called directly, 
 only use the API dependencies extensions of this
 
 @note This could be moved to internal so it isn't abused

 @param route The required network route
 @param parameters The parameters required for the call
 @param encoding The URL encoding of the parameters
 @param headers The headers for the call, a few have already been added
 */
- (TRLRequest *)get:(NSString *)route
       with:(Parameters *_Nullable)parameters
   encoding:(id<TRLURLParameterEncoding>)encoding
    headers:(HTTPHeaders *_Nullable)headers;

/**
 This method creates a new TRLRequest for our calls to the server.
 
 This method is useful if you have many properties and don't want 
 to have to write a [NSString stringWithFormat:...]; we because
 unlike Swift we cannot have variadic parameters
 followed by more parameters

 @warning This should never be called directly,
 only use the API dependencies extensions of this

 @note This could be moved to internal so it isn't abused

 @param items A groupe of url routes that havn't been turned into a string yet
 @param parameters The parameters required for the call
 @param encoding The URL encoding of the parameters
 @param headers The headers for the call, a few have already been added
 */
- (TRLRequest *)getItems:(NSArray<NSString *>*)items
       with:(Parameters *_Nullable)parameters
   encoding:(id<TRLURLParameterEncoding>)encoding
    headers:(HTTPHeaders *_Nullable)headers;

@end

NS_ASSUME_NONNULL_END
