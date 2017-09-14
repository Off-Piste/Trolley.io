//
//  TRLMutableArray.h
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 06.09.17.
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

NS_ASSUME_NONNULL_BEGIN

@interface TRLMutableArray: NSObject

+ (instancetype)initWithArray:(NSArray *)array NS_SWIFT_NAME(init(array:));

+ (instancetype)initWithMutableArray:(NSMutableArray *)array NS_SWIFT_NAME(init(mutableArray:));

+ (instancetype)initWithTRLMutableArray:(TRLMutableArray *)array NS_SWIFT_NAME(init(_:));

- (id)objectAtIndex:(NSUInteger)idx;

- (void)setObject:(id)object;

- (void)removeAll;

- (NSUInteger)count;

- (NSArray *)array;

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;

- (instancetype)map:(id (^)(id obj, NSUInteger idx))block;

- (void)enumerateObjectsUsingBlock:(void (^)(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop))block;

///
- (BOOL)isEqualToArray:(NSArray *)arg1;

///
- (BOOL)isEqualToTRLMutableArray:(TRLMutableArray *)arg1;

@end

NS_ASSUME_NONNULL_END
