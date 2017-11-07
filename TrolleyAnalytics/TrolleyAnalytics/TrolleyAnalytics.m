//
//  TrolleyAnalytics.m
//  TrolleyAnalytics
//
//  Created by Harry Wright on 09.10.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

#import "TrolleyAnalytics.h"
#import "TRLAnalytics_Network.h"
#import "TRLAnalyticsQueue.h"
#import "TRLAnalyticsConstants.h"
#import "TRLAppEnvironmentUtil.h"

#import <TrolleyAnalytics/TrolleyAnalytics-Swift.h>

@import TrolleyCore;

static TRLAnalytics *anAnalytics;

@implementation TRLAnalytics {
    NSNotificationCenter *_center;
    TRLAnalyticsQueue *_queue;
    TRLNetworkManager *_manager;
    BOOL serverIsConnected;
    NSString *_uuid;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];

        [defaultCenter addObserverForName:TRLTrolleyStartingUpNotification
                                   object:nil
                                    queue:nil
                               usingBlock:^(NSNotification *note) {
           anAnalytics = [TRLAnalytics analyticsForUUID:note.userInfo[@"DeviceUUID"]];
       }];
    });
}

+ (TRLAnalytics *)shared {
    if (anAnalytics) {
        return anAnalytics;
    }
    return nil;
}

+ (TRLAnalytics *)analyticsForUUID:(NSString *)uuid {
    return [[TRLAnalytics alloc] initWithUUID:uuid];
}

- (instancetype)initWithUUID:(NSString *)uuid {
    if (self = [super init]) {
        _center = [NSNotificationCenter defaultCenter];
        _queue = [TRLAnalyticsQueue defaultQueue];
        _uuid = uuid;
        
        [self startUpObserved];
        [self waitForNotifications];
    }
    return self;
}

#pragma mark Notification Center

- (void)waitForNotifications {
    [_center addObserver:self
                selector:@selector(serverIsConnected:)
                    name:TRLNetworkConnectedNotification
                  object:nil];

    [_center addObserver:self
                selector:@selector(serverIsDisconnected:)
                    name:TRLNetworkDisconnectedNotification
                  object:nil];

}

- (void)startUpObserved {
    TRLDebugLogger(TRLLoggerServiceAnalytics, "Notification [%@] has been observed", TRLTrolleyStartingUpNotification);

    // Validated
    _manager = [TRLNetworkManager shared];

    // Add phone info to queue
    NSDictionary *defaultAttr = @{
                                  @"deviceUUID":_uuid,
                                  @"deviceModel":[TRLAppEnvironmentUtil deviceModel],
                                  @"applicationVersion":[[UserAgent shared] appVersion],
                                  @"os": @{
#if TARGET_OS_IOS
                                          @"name":@"iOS",
#elif TARGET_OS_OSX
                                          @"name":@"macOS",
#endif
                                          @"version":[TRLAppEnvironmentUtil systemVersion]
                                          }
                                  }.copy;
    TRLAnalyticsObject *obj = [[TRLAnalyticsObject alloc] initWithType:AnalyticsEventDidStartUp
                                                                  name:nil
                                                                  date:[NSDate date]
                                                      defaultAttribues:defaultAttr
                                                      customAttributes:nil];
    [_queue addObject:obj];
}

- (void)serverIsConnected:(NSNotification *)note {
    NSAssert(_manager, @"The NetworkManager must be linked before running so we know that the SDK's notfication has been sent");
    serverIsConnected = YES;
    [_queue retrieveFromStorage];

    for (TRLAnalyticsObject *obj in _queue) {
        if (serverIsConnected) {
            [self send:obj secure:YES];
            [_queue removeObject];
        } else {
            break;
        }
    }
}

- (void)serverIsDisconnected:(NSNotification *)note {
    serverIsConnected = NO;
    [_queue pushToStorage];


    _manager = nil;
}

#pragma mark Sending to the Server


- (void)send:(TRLAnalyticsObject *)object {
    [self send:object secure:NO];
}

- (void)send:(TRLAnalyticsObject *)object secure:(BOOL)secure {
    if (!_manager) {
        [_queue addObject:object];
        return;
    }

    _trl_network_manager_send_dictionary([object.json dictionaryObject], secure);
}

@end
