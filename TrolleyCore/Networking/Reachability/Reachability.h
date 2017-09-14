/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Basic demonstration of how to use the SystemConfiguration Reachablity APIs.
 */

#import <Foundation/Foundation.h>

@import SystemConfiguration;

#import <netinet/in.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NetworkStatus) {
	NotReachable = 0,
	ReachableViaWiFi,
	ReachableViaWWAN
};

#pragma mark IPv6 Support
//Reachability fully support IPv6.  For full details, see ReadMe.md.


extern NSString *kReachabilityChangedNotification;


@interface Reachability : NSObject

@property (nonatomic, readonly) NetworkStatus currentReachabilityStatus;

/*!
 * WWAN may be available, but not active until a connection has been established. WiFi may require a connection for VPN on Demand.
 */
@property (nonatomic, readonly) BOOL connectionRequired NS_SWIFT_NAME(isConnectionRequired);

/*!
 * Use to check the reachability of a given host name.
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName NS_SWIFT_NAME(init(_:));

/*!
 * Use to check the reachability of a given IP address.
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

/*!
 * Start listening for reachability notifications on the current run loop.
 */
- (BOOL)startNotifier NS_SWIFT_NAME(start());

/*!
 * Stop listening for reachability notifications on the current run loop.
 */
- (void)stopNotifier NS_SWIFT_NAME(stop());

@end

NS_ASSUME_NONNULL_END
