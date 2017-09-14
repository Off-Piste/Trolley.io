/////////////////////////////////////////////////////////////////////////////////
//
//  TRLURLEncoding.h
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

#import "TNTUtils.h"

@protocol TRLURLParameterEncoding;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TRLURLEncodingDestination) {
    TRLURLEncodingDestinationMethodDependent,
    TRLURLEncodingDestinationQueryString
};

//@interface TRLURLEncoding : NSObject<TRLURLParameterEncoding>
OBJ_SWIFT_PROTOCOL(TRLURLEncoding, TRLURLParameterEncoding)

@property (readonly) TRLURLEncodingDestination destination;

@property (class, readonly) TRLURLEncoding *queryString;

@property (class, readonly) TRLURLEncoding *methodDependent;

@property (class, readonly) TRLURLEncoding *defaultEncoding;

- (instancetype)init;

- (instancetype)initWithDestination:(TRLURLEncodingDestination)destination
NS_DESIGNATED_INITIALIZER;

- (NSString *)escape:(NSString *)string;

- (NSString *)query:(NSDictionary *)parameters;

@end

// Taken from realm, seems like its the best way to check NSNumber...

static inline bool nsnumber_is_like_integer(__unsafe_unretained NSNumber *const obj)
{
    char data_type = obj.objCType[0];
    return data_type == *@encode(bool) ||
    data_type == *@encode(char) ||
    data_type == *@encode(short) ||
    data_type == *@encode(int) ||
    data_type == *@encode(long) ||
    data_type == *@encode(long long) ||
    data_type == *@encode(unsigned short) ||
    data_type == *@encode(unsigned int) ||
    data_type == *@encode(unsigned long) ||
    data_type == *@encode(unsigned long long);
}

static inline bool nsnumber_is_like_bool(__unsafe_unretained NSNumber *const obj)
{
    // @encode(BOOL) is 'B' on iOS 64 and 'c'
    // objcType is always 'c'. Therefore compare to "c".
    if (obj.objCType[0] == 'c') {
        return true;
    }

    if (nsnumber_is_like_integer(obj)) {
        int value = obj.intValue;
        return value == 0 || value == 1;
    }

    return false;
}

NS_ASSUME_NONNULL_END
