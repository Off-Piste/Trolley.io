//
//  TRLAnalytics+Network.h
//  TrolleyAnalytics
//
//  Created by Harry Wright on 10.10.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

#import "TrolleyAnalytics.h"

@class TRLAnalyticsObject;

@interface TRLAnalytics ()

- (void)send:(TRLAnalyticsObject *)object;

- (void)send:(TRLAnalyticsObject *)object secure:(BOOL)secure;

@end
