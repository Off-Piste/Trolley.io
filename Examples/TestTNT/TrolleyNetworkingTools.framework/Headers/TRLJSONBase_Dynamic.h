//
//  TRLJSONBase_Dynamic.h
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 05.09.17.
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

#import "TRLJSONBase.h"

NS_ASSUME_NONNULL_BEGIN

// These Dynamic methods, bar `TRLJSONBaseIsEqual` as used to allow
// the JSON to be mutable but will make sure that only TRLMutableJSON
// can mutate with not inheritance errors and to allow the JSON struct
// to access raw values in the Base

/**
 @warning Not to be used publicly!

 :nodoc:
 @param base The JSON you wish to mutate
 @param key The ket of the dictionary you wish to mutate
 @param object The object to be added to the array
 */
FOUNDATION_EXTERN void TRLJSONBaseSetObjectForKeyedSubscript(TRLJSONBase *base, NSString *key, TRLJSONBase *object);

/**
 @warning Not to be used publicly!

 :nodoc:
 @param base The JSON you wish to access its rawValues
 @param type The JSON type you require
 @return An object if the JSON is valid, if not NULL
 */
FOUNDATION_EXTERN id _Nullable TRLJSONBaseRawValueForType(TRLJSONBase *base, JSONType type);

/**
 @warning Not to be used publicly!

 :nodoc:
 @param base The JSON you wish to mutate
 @param idx The index of the array you wish to mutate
 @param object The object to be added to the array
 */
FOUNDATION_EXTERN void TRLJSONBaseSetObjectForIndexedSubscript(TRLJSONBase *base, NSUInteger idx, TRLJSONBase *object);

/**
 Method to mutate the JSON was a raw value
 
 @warning Not to be used publicly!
 
 :nodoc:
 @param base The JSON you wish to mutate
 @param rawValue The raw value you wish to add to the JSON
 */
FOUNDATION_EXTERN void TRLJSONBaseSetRawValue(TRLJSONBase *base, id rawValue);

NS_ASSUME_NONNULL_END
