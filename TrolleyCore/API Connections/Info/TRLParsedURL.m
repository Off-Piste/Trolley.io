//
//  TRLParsedURL.m
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
//

#import "TRLParsedURL.h"

#import "TRLNetworkInfo.h"

#import "TRLError.h"

@implementation TRLParsedURL

- (NSURL *)url{
    return self.info.url;
}

- (NSURL *)connectionURL {
    return self.info.connectionURL;
}

- (instancetype)initWithURLString:(NSString *)url {
    self = [super init];
    if (self) {
        NSError *error;
        TRLNetworkInfo *info = [TRLNetworkInfo networkInfoForURL:url error:&error];
        if (error) {
            @throw TRLException(error.localizedDescription, @{ });
        }

        self->_info = info;
    }

    return self;
}

- (void)addPath:(NSString *)path {
    [self->_info addPath:path];
}

- (NSString *)description {
    return self->_info.description;
}


@end
