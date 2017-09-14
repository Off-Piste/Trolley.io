//
//  TRLJSONBase.h
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
//

#import <Foundation/Foundation.h>

@class TRLMutableDictionary;
@class TRLMutableArray;

#import "TNTUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRLJSONBase : NSObject {
    TRLMutableArray *rawArray;
    TRLMutableDictionary * rawDictionary;
    NSString *rawString;
    NSNumber *rawNumber;
    NSNull *rawNull;
    BOOL rawBool;

    JSONType _rawType;
    NSError *_Nullable _error;
}

# pragma mark Properties

/**
 The current value, if the JSON is invalid will be set to NSNull
 */
@property (NS_NONATOMIC_IOSONLY, readonly, strong) id _Nonnull rawValue;

/**
 An error or nil if the JSON is invalid or not
 */
@property (NS_NONATOMIC_IOSONLY, readonly, strong) NSError *_Nullable error;

/**
 The NSJSONWritingPrettyPrinted JSON string
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString * _Nullable rawString;

/**
 The JSONType for the current value
 */
@property (NS_NONATOMIC_IOSONLY, readonly) JSONType rawType;

# pragma mark - Init

- (instancetype)init __attribute__((unavailable("TRLJSONBase cannot be created directly")));

/**
 Obtains a JSON instance with the imputted raw value
 
 @note NSData can be passed to this but will be
 sent via @c-[initWithData:]

 @warning Subclasses should not override this method.
 @param value The raw value of the JSON
 @return A `TRLJSONBase` instance
 */
- (instancetype)initWithRawValue:(id)value;

/**
 Obtains a JSON instance with the imputted NSData

 If the data is invalid no error will be thrown,
 but the JSON will be set to [NSNull null].
 
 @note This method calls @c-[initWithData: options:]
 with a default option of NSJSONReadingAllowFragments

 @warning Subclasses should not override this method.
 @param data The NSData of the JSON
 @return A `TRLJSONBase` instance
 */
- (instancetype)initWithData:(NSData *)data;

/**
 Obtains a JSON instance with the imputted NSData

 If the data is invalid no error will be thrown,
 but the JSON will be set to [NSNull null].

 @warning Subclasses should not override this method.
 @param data    The NSData of the JSON
 @param opt     NSJSONReadingOptions
 @return A `TRLJSONBase` instance
 */
- (instancetype)initWithData:(NSData *)data
                     options:(NSJSONReadingOptions)opt;

/**
 Obtains a JSON instance with the imputted NSData

 If the data is invalid an error will be returned,
 but the JSON will also be set to [NSNull null].

 @warning Subclasses should not override this method.
 @param data    The NSData of the JSON
 @param opt     NSJSONReadingOptions
 @param error   If an error occurs, upon return contains an `NSError` object
                that describes the problem. If you are not interested in
                possible errors, pass in `NULL`.
 @return A `TRLJSONBase` instance
 */
- (instancetype)initWithData:(NSData *)data
                     options:(NSJSONReadingOptions)opt
                       error:(NSError *_Nullable *_Nullable)error;

# pragma mark - Subscript

/**
 Obtains a JSON instance with the value found inside the raw array
 
 If the data is invalid no error will be thrown,
 but the JSON will be set to [NSNull null].

 @warning Subclasses should not override this method.
 @param idx The index at which you would like to access your array data.
 @return A `TRLJSONBase` instance with the rawValue of the NSArray[idx]
 */
- (instancetype)objectAtIndexedSubscript:(NSUInteger)idx NS_SWIFT_NAME(object(at:));

/**
 Obtains a JSON instance with the value found inside the raw dictionary

 If the data is invalid no error will be thrown,
 but the JSON will be set to [NSNull null].

 @warning Subclasses should not override this method.
 @param key The key at which you would like to access your dictionary data.
 @return A `TRLJSONBase` instance with the rawValue of the NSDictionary[idx]
 */
- (instancetype)objectForKeyedSubscript:(NSString *)key NS_SWIFT_NAME(object(for:));

# pragma mark - Methods

/**
 Obtain the NSData of the current JSON.
 
 By default this method calls @c-[rawDataWithOptions: error:]
 passing NSJSONWritingPrettyPrinted as the option.
 
 @note  For swift the return value is nonnull or will throw and error
        so you will have to use the trycatch block to manage the error

 @warning Subclasses should not override this method.
 @param error   If an error occurs, upon return contains an `NSError` object
                that describes the problem.
 @return The NSData or nil if an error occured
 */
- (NSData *_Nullable)rawDataWithError:(NSError **)error NS_SWIFT_NAME(rawData());

/**
 Obtain the NSData of the current JSON.
 
 @note  For swift the return value is nonnull or will throw and error
        so you will have to use the trycatch block to manage the error

 @warning Subclasses should not override this method.
 @param opt     NSJSONWritingOptions
 @param error   If an error occurs, upon return contains an `NSError` object
                that describes the problem.
 @return The NSData or nil if an error occured
 */
- (NSData *_Nullable)rawDataWithOptions:(NSJSONWritingOptions)opt
                                  error:(NSError **)error NS_SWIFT_NAME(rawData(options:));

/**
 Obtain a NSString/String of the current JSON

 By default this method calls @c-[rawString: options:]
 passing NSJSONWritingPrettyPrinted as the option.

 @warning Subclasses should not override this method.
 @param encoding The NSStringEncoding value
 @return An NSString if the JSON is valid or nil
 */
- (NSString *_Nullable)rawString:(NSStringEncoding)encoding;

/**
 Obtain a NSString/String of the current JSON

 @warning Subclasses should not override this method.
 @param encoding The NSStringEncoding value
 @param opt NSJSONWritingOptions
 @return An NSString if the JSON is valid or nil
 */
- (NSString *_Nullable)rawString:(NSStringEncoding)encoding
                         options:(NSJSONWritingOptions)opt;

# pragma mark - others

/**
 @warning Subclasses should not override this method.

 @return The NSString of the class name
 */
+ (NSString *)className;

@end

NS_ASSUME_NONNULL_END
