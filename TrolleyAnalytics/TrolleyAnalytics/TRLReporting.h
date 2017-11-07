//
//  TRLReporting.h
//  TrolleyAnalytics
//
//  Created by Harry Wright on 10.10.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

#import <Foundation/Foundation.h>
//typedef NSString *const TRLLoggerService NS_EXTENSIBLE_STRING_ENUM;

//FOUNDATION_EXPORT TRLLoggerService TRLLoggerServiceCore;

typedef NS_ENUM(NSUInteger, AnalyticsEvent) {
    AnalyticsEventAddToCart,
    AnalyticsEventSearch,
    AnalyticsEventCustom,
    AnalyticsEventViewContent,
    AnalyticsEventStartCheckout,
    AnalyticsEventFinishCheckout,
    AnalyticsEventDidStartUp
};

typedef NSString *const TRLReportingEventName;

#define NString NSString *_Nullable

#define NGenericDictionary NSDictionary *_Nullable

NS_ASSUME_NONNULL_BEGIN

@interface TRLReporting : NSObject

+ (void)logAddToTrolleyWithPrice:(NSDecimalNumber *)price
                        currency:(NString)currency
                        itemName:(NString)itemName
                        itemType:(NString)itemType
                          itemId:(NString)itemId
                customAttributes:(NGenericDictionary)customAttributes;

+ (void)logSearchWithQuery:(NSString *)searchQuery
          customAttributes:(NGenericDictionary)customAttributes NS_SWIFT_NAME(logSearch(_:customAttributes:));

+ (void)logCustomEventWithName:(TRLReportingEventName)eventName
              customAttributes:(NGenericDictionary)customAttributes NS_SWIFT_NAME(logCustomEvent(_:customAttributes:));

@end

NS_ASSUME_NONNULL_END
