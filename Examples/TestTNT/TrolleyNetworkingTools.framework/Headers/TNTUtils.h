//
//  TNTUtils.h
//  TrolleyNetworkingTools
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

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JSONType) {
    JSONTypeNumber,
    JSONTypeString,
    JSONTypeBool,
    JSONTypeArray,
    JSONTypeDictionary,
    JSONTypeNull,
    JSONTypeUnknown
};

typedef NSDictionary Parameters;

typedef NSDictionary HTTPHeaders;

@class TRLJSONBase;

#define ObjcNull [NSNull null]

#define JSONBase(classname, obj) \
    TRLJSONBase *classname = [[TRLJSONBase alloc] initWithRawValue:obj];

#define UNAVAILABLE_INIT \
    - (instancetype)init NS_UNAVAILABLE

#define SWIFT_DEFAULT_INIT \
    NS_SWIFT_NAME(init(_:))

// workaround for:
// https://stackoverflow.com/questions/14993265/cannot-find-protocol-definition-for-xxx
#define OBJ_SWIFT_PROTOCOL(classname, protocolname) \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Weverything\"") \
    @interface classname : NSObject <protocolname> \
    _Pragma("clang diagnostic pop")

/**
 HTTPMethods
 */
typedef NSString *const HTTPMethod NS_EXTENSIBLE_STRING_ENUM;

/**
 GET
 */
FOUNDATION_EXPORT HTTPMethod HTTPMethodGET;

/**
 POST
 */
FOUNDATION_EXPORT HTTPMethod HTTPMethodPOST;
