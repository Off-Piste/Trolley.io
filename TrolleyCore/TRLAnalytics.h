//
//  TRLAnalytics.h
//  Trolley
//
//  Created by Harry Wright on 17.09.17.
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

@class TRLAnalyticsManager;
@protocol TRLReporting;

NS_ASSUME_NONNULL_BEGIN

OBJ_SWIFT_PROTOCOL(TRLAnalytics, TRLReporting)

@property (strong, class, readonly) TRLAnalytics *defaultAnalytics;

@property (weak, readonly) TRLAnalyticsManager *manager;

// Cannot Access TRLReporting Methods from a Swift Class
// so had to re-add them here for it to work

- (void)logSearchQuery:(NSString *)query customAttributes:(NSDictionary *)customAttributes;
- (void)logAddItem:(NSString *)itemID withPrice:(NSInteger)price customAttributes:(NSDictionary *)customAttributes;
- (void)logCheckoutOfItem:(NSArray *)items withTotalPrice:(NSInteger)price customAttributes:(NSDictionary *)customAttributes;

@end

NS_ASSUME_NONNULL_END
