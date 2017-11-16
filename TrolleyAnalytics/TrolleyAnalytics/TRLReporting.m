//
//  TRLReporting.m
//  TrolleyAnalytics
//
//  Created by Harry Wright on 10.10.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

#import "TRLReporting.h"
#import "TRLAnalytics_Network.h"

#import <TrolleyAnalytics/TrolleyAnalytics-Swift.h>

@interface TRLReporting ()

/**
 Pass to all logs to this method, may move it internal not sure yet.

 {
     "t":"analytics",
     "d": {
         "type":"analytics_custom",
         "name":"logItems",
         "customAttributes": { }
     }
 },
 {
     "t":"analytics",
     "d": {
         "type":"analytics_search",
         "defaultAttributes": { "query":"jeans" },
         "customAttributes": { }
     }
 }
 :nodoc:
 */
+ (void)logEvent:(AnalyticsEvent)event
      customName:(TRLReportingEventName _Nullable)customName
defaultAttributes:(NGenericDictionary)defaultAttributes
customAttributes:(NGenericDictionary)customAttributes;

@end

@implementation TRLReporting

+ (void)logAddToTrolleyWithPrice:(NSDecimalNumber *)price
                        currency:(NSString *)currency
                        itemName:(NSString *)itemName
                        itemType:(NSString *)itemType
                          itemId:(NSString *)itemId
                customAttributes:(NSDictionary *)customAttributes
{
    NSDictionary *defaultAttributes = @{
                                        @"price":price ?: [NSNull null],
                                        @"currency":currency ?: [NSNull null],
                                        @"itemName":itemName ?: [NSNull null],
                                        @"itemId":itemId ?: [NSNull null],
                                        };
    [TRLReporting logEvent:AnalyticsEventAddToCart
                customName:nil
         defaultAttributes:defaultAttributes
          customAttributes:customAttributes];
}

+ (void)logCustomEventWithName:(TRLReportingEventName)eventName
              customAttributes:(NSDictionary *)customAttributes
{
    [TRLReporting logEvent:AnalyticsEventCustom
                customName:eventName
         defaultAttributes:nil
          customAttributes:customAttributes];
}

+ (void)logSearchWithQuery:(NSString *)searchQuery
          customAttributes:(NSDictionary *)customAttributes
{
    NSDictionary *defaultAttributes = @{@"query":searchQuery}.copy;
    [TRLReporting logEvent:AnalyticsEventSearch
                customName:nil
         defaultAttributes: defaultAttributes
          customAttributes:customAttributes];
}

#pragma mark Private

+ (void)logEvent:(AnalyticsEvent)event
      customName:(TRLReportingEventName)customName
defaultAttributes:(NSDictionary *)defaultAttributes
customAttributes:(NSDictionary *)customAttributes
{
    TRLAnalyticsObject *object = [[TRLAnalyticsObject alloc] initWithType:event
                                                                     name:customName
                                                                     date:[NSDate date]
                                                         defaultAttribues:defaultAttributes
                                                         customAttributes:customAttributes];
    [[TRLAnalytics shared] send:object secure:NO];

}

@end
