//
//  TRLAnalyticsQueue.h
//  TrolleyAnalytics
//
//  Created by Harry Wright on 09.10.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRLJSON;
@class TRLAnalyticsObject;

@interface TRLAnalyticsQueue : NSObject <NSFastEnumeration>

/**
 <#Description#>

 @return <#return value description#>
 */
+ (instancetype)defaultQueue;

/**
 <#Description#>

 @param object <#object description#>
 */
- (void)addObject:(TRLAnalyticsObject *)object;

/**
 <#Description#>
 */
- (void)removeObject;

/**
 <#Description#>
 */
- (void)retrieveFromStorage;

/**
 <#Description#>
 */
- (void)pushToStorage;

@end
