/////////////////////////////////////////////////////////////////////////////////
//
//  TRLRequest.m
//  TrolleyCore
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
//

#import "TRLRequest.h"
#import "TRLRequest_Internal.h"
#import "TRLURLRequest_Response.h"
#import "TRLNetworkingConstants.h"
#import "TRLURLParameterEncoding.h"
#import "TRLURLRequest.h"

/**
 This method will hold all the HTTP methods that the current API calls 
 this will be helpful when validating so we know what methods have not
 been added yet and can crash if they are called.

 @return An array of valid HTTPMethods
 */
static inline NSArray<HTTPMethod *> *validURLMethods() {
    return [NSArray arrayWithObjects:GET, POST, nil];
}

@implementation TRLRequest {
    NSString *requestString;
    HTTPMethod *method;
    Parameters *_Nullable parameters;
    id<TRLURLParameterEncoding> encoding;
    HTTPHeaders *_Nullable headers;
}

- (TRLURLRequest *)request {
    return [TRLURLRequest request:requestString method:method parameters:parameters encoding:encoding header:headers];
}

- (instancetype)init_common {
    self = [super init];
    return self;
}

+ (instancetype)new {
    return [[TRLRequest alloc] init_common];
}

+ (instancetype)requestWithURL:(NSString *)url
                        method:(HTTPMethod *)method
                    parameters:(Parameters *)parameters
                      encoding:(id<TRLURLParameterEncoding>)encoding
                       headers:(HTTPHeaders *)headers {
    TRLRequest *request = [TRLRequest new];
    request->requestString = url;
    request->method = method;
    request->encoding = encoding;
    request->parameters = parameters;
    request->headers = headers;
    return request;
}

- (id<Networkable>)validate {
    if (![validURLMethods() containsObject:method]) {
        [NSException raise:NSGenericException format:@""];
        return nil;
    }

    return self.request;
}

@end
