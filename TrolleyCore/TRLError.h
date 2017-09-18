/////////////////////////////////////////////////////////////////////////////////
//
//  NSObject+TRLError.h
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef NS_EXTENSIBLE_STRING_ENUM
#define TRL_EXTENSIBLE_STRING_ENUM NS_EXTENSIBLE_STRING_ENUM
#define TRL_EXTENSIBLE_STRING_ENUM_CASE_SWIFT_NAME(_, extensible_string_enum) NS_SWIFT_NAME(extensible_string_enum)
#else
#define TRL_EXTENSIBLE_STRING_ENUM
#define TRL_EXTENSIBLE_STRING_ENUM_CASE_SWIFT_NAME(fully_qualified, _) NS_SWIFT_NAME(fully_qualified)
#endif

#if __has_attribute(ns_error_domain) && (!defined(__cplusplus) || !__cplusplus || __cplusplus >= 201103L)
#define TRL_ERROR_ENUM(type, name, domain) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wignored-attributes\"") \
NS_ENUM(type, __attribute__((ns_error_domain(domain))) name) \
_Pragma("clang diagnostic pop")
#else
#define TRL_ERROR_ENUM(type, name, domain) NS_ENUM(type, name)
#endif

extern NSString * const TRLErrorDomain;

typedef TRL_ERROR_ENUM(NSInteger, TRLError, TRLErrorDomain) {
    TRLErrorInvalidURL = 0,
    TRLErrorURLParameterEncodingFailed = 404,

    TRLErrorJSONUnsupportedType = 999,
    TRLErrorJSONInvalidJSON = 490,
    TRLErrorJSONWrongType = 901,
    TRLErrorJSONIndexOutOfBounds = 900,
    TRLErrorJSONErrorNotExist = 490,

    TRLErrorNSUDNilReturnValue = 500,
    TRLErrorNSUDCouldNotUnarchive = 502,
};

NSException *TRLException(NSString *reason, NSDictionary *_Nullable additionalUserInfo);

NSError *TRLMakeError(TRLError code, NSString *_Nullable reason, ...) NS_FORMAT_FUNCTION(2,3);

void TRLSetErrorOrThrow(NSError *error, NSError **outError);

NS_ASSUME_NONNULL_END
